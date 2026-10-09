#!/usr/bin/env python3
"""Fake AWS Instance Metadata Service (IMDSv1) carrying the CTF flag.

Flag carrier for the GHSA-2phj-cp9f-qq6w challenge. The prize of this SSRF
class is the cloud metadata service at 169.254.169.254; this VM has no cloud,
so we fake one and put the flag in the instance-role credentials it serves.

Network reachability (the challenge's trust boundary):
- Harbor container egress CAN reach it: flag-imds.service installs a nat
  PREROUTING REDIRECT mapping 169.254.169.254:80 to this server on
  0.0.0.0:8169; conntrack NATs the replies, so jobservice sees a plain
  http://169.254.169.254/... endpoint.
- The VM itself CANNOT: unlike the vul env there is no OUTPUT redirect, an
  OUTPUT REJECT rule blocks 169.254.169.254 outright, and an INPUT rule
  rejects :8169 arriving on lo (both 127.0.0.1 and local-to-bridge-IP
  delivery traverse lo). Redirected container traffic arrives on the bridge
  interface and passes.

Response policy: every request gets 404 with the credentials body. Harbor
writes the response body of error-status webhook deliveries into the
project-readable webhook execution log, so the 404 + credentials body is the
only channel through which the flag (SecretAccessKey) can leave this service.

The flag is read from /root/flag at startup; this script and the journal it
logs request lines to are root-only visibility.
"""

import datetime
import json
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

LISTEN_ADDR = ("0.0.0.0", 8169)
FLAG_FILE = "/root/flag"
ROLE = "harbor-instance-role"


def load_flag():
    with open(FLAG_FILE) as f:
        return f.read().strip()


def credentials_body(flag):
    creds = {
        "Code": "Success",
        "LastUpdated": "2026-10-08T00:00:00Z",
        "Type": "AWS-HMAC",
        "AccessKeyId": "AKIDGHSA2PHJCP9FQQ6W",
        "SecretAccessKey": flag,
        "Token": "FAKE-SESSION-TOKEN-for-ctf-demo-only",
        "Expiration": "2038-01-01T00:00:00Z",
    }
    return json.dumps(creds, indent=2) + "\n"


class Handler(BaseHTTPRequestHandler):
    server_version = "FakeIMDS/ctf-ghsa-2phj-cp9f-qq6w"

    def log_message(self, fmt, *args):
        pass  # _respond() below is the only request log

    def _respond(self, code, body):
        line = "%s %s %s %s %s UA=%s\n" % (
            datetime.datetime.now().isoformat(timespec="seconds"),
            self.client_address[0],
            self.command,
            self.path,
            code,
            self.headers.get("User-Agent", "-"),
        )
        sys.stderr.write(line)
        sys.stderr.flush()
        data = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _handle(self):
        self._respond(404, BODY)

    do_GET = _handle
    do_POST = _handle
    do_PUT = _handle
    do_HEAD = _handle
    do_DELETE = _handle


BODY = None


def main():
    global BODY
    BODY = credentials_body(load_flag())
    ThreadingHTTPServer(LISTEN_ADDR, Handler).serve_forever()


if __name__ == "__main__":
    main()
