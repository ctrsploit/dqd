#!/usr/bin/env python3
"""Fake AWS Instance Metadata Service (IMDSv1) for GHSA-2phj-cp9f-qq6w.

Victim endpoint for the Harbor webhook SSRF lab. The prize of this SSRF class
is the cloud metadata service at 169.254.169.254; this VM has no cloud, so we
fake one and watch Harbor's jobservice deliver webhook POSTs to it.

169.254.169.254:80 is NOT bound directly: harbor's nginx publishes 0.0.0.0:80
in this VM (docker-proxy), so a second port-80 bind would fail. Instead,
imds.service installs two iptables nat REDIRECT rules — PREROUTING for
container-origin traffic, OUTPUT for VM-local traffic — mapping
169.254.169.254:80 to this server on 0.0.0.0:8169. Conntrack NATs the replies
back, so clients see a plain http://169.254.169.254/... endpoint.

Response policy (mirrors the exfiltration channel described in the advisory):
- GET on a known IMDSv1 path -> 200 with the normal body
- anything else -> 404 carrying the SAME credentials body. Harbor writes the
  response body of error-status webhook deliveries into the project-readable
  webhook execution log, so the 404 + credentials body is what lands in a log
  any project member can read.

All credentials below are fake and marked as such.
"""

import datetime
import json
import sys
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

LISTEN_ADDR = ("0.0.0.0", 8169)
LOG_FILE = "/var/log/fake-imds.log"
ROLE = "harbor-instance-role"

CREDENTIALS = {
    "Code": "Success",
    "LastUpdated": "2026-10-08T00:00:00Z",
    "Type": "AWS-HMAC",
    "AccessKeyId": "AKIDGHSA2PHJCP9FQQ6W",
    "SecretAccessKey": "FAKE-SECRET-ACCESS-key-for-ssrf-demo-only",
    "Token": "FAKE-SESSION-TOKEN-for-ssrf-demo-only",
    "Expiration": "2038-01-01T00:00:00Z",
}

CREDENTIALS_BODY = json.dumps(CREDENTIALS, indent=2) + "\n"


def route(path):
    """Map an IMDSv1 path to its body; None for unknown paths."""
    if path.rstrip("/") == "/latest/meta-data/iam/security-credentials/" + ROLE:
        return CREDENTIALS_BODY
    if path.rstrip("/") == "/latest/meta-data/iam/security-credentials":
        return ROLE + "\n"
    if path.rstrip("/") == "/latest/meta-data":
        return "iam/\ninstance-id/\n"
    if path.rstrip("/") == "/latest":
        return "meta-data/\n"
    return None


class Handler(BaseHTTPRequestHandler):
    server_version = "FakeIMDS/ghsa-2phj-cp9f-qq6w"

    def log_message(self, fmt, *args):
        pass  # _handle() below is the only request log

    def _log(self):
        line = "%s %s %s %s UA=%s\n" % (
            datetime.datetime.now().isoformat(timespec="seconds"),
            self.client_address[0],
            self.command,
            self.path,
            self.headers.get("User-Agent", "-"),
        )
        try:
            with open(LOG_FILE, "a") as f:
                f.write(line)
        except OSError:
            pass
        sys.stderr.write(line)
        sys.stderr.flush()

    def _respond(self, code, body):
        data = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def _handle(self):
        self._log()
        body = route(self.path)
        if body is None:
            # unknown path: still answer with the credentials on an error
            # status, so a blind webhook probe demonstrates the read-back
            body = CREDENTIALS_BODY
            code = 404
        else:
            code = 200 if self.command == "GET" else 404
        self._respond(code, body)

    do_GET = _handle
    do_POST = _handle
    do_PUT = _handle
    do_HEAD = _handle
    do_DELETE = _handle


def main():
    ThreadingHTTPServer(LISTEN_ADDR, Handler).serve_forever()


if __name__ == "__main__":
    main()
