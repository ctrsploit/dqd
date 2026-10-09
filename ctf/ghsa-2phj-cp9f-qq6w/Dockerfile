# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_IMAGE=0.1.21
ARG FLAG=flag{ghsa-2phj-cp9f-qq6w_test_flag}

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/harbor-v2.15.2:ctr_v${VERSION_IMAGE}

# ============================================================================
# Build stages
# ============================================================================
FROM ${BASE_IMAGE} AS base
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

FROM base AS challenge
ARG FLAG

# ctf user: unprivileged, no root access. The sudoers whitelist plus the
# attacker Harbor account created by setup-challenge.sh define the entire
# attack surface: exactly the docker verbs needed to push an artifact into
# Harbor (fire the webhook) and nothing that executes or inspects containers.
RUN useradd -m -s /bin/bash ctf && \
    echo "ctf:ctf" | chpasswd

# anti-cheat: lock root password and forbid root SSH login so the player
# (ctf) cannot `su root` or `ssh root@` to bypass the challenge.
RUN usermod -p '!' root && \
    sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# sudoers whitelist: ctf may run exactly four non-executing docker commands,
# passwordless. push is pinned to the Harbor registry on 127.0.0.1.
COPY sudoers.ctf /etc/sudoers.d/ctf
RUN chmod 440 /etc/sudoers.d/ctf && \
    visudo -cf /etc/sudoers.d/ctf

# flag carrier: fake IMDS on 169.254.169.254. Unlike the vul env's imds.service
# there is NO OUTPUT-chain REDIRECT and the listener is firewalled from
# VM-local clients — only the Harbor deployment's egress (PREROUTING path)
# can reach it, so the flag is readable solely through the webhook SSRF.
COPY --chmod=755 service/flag-imds.py /usr/local/bin/flag-imds.py
COPY service/flag-imds.service /usr/lib/systemd/system/
RUN systemctl enable flag-imds.service

# challenge setup (runs once at boot, after the Harbor containers are up)
COPY --chmod=755 setup-challenge.sh /usr/local/bin/setup-challenge.sh
COPY setup-challenge.service /usr/lib/systemd/system/
RUN systemctl enable setup-challenge.service

# flag
RUN echo ${FLAG} > /root/flag && \
    chmod 400 /root/flag && \
    chown root:root /root/flag
