# syntax=docker/dockerfile:1-labs

# ============================================================================
# Configuration variables
# ============================================================================
ARG VERSION_IMAGE=0.1.21

# ============================================================================
# Internal variables
# ============================================================================
ARG BASE_IMAGE=ghcr.io/ctrsploit/harbor-v2.15.2:ctr_v${VERSION_IMAGE}

# ============================================================================
# Build stages
# ============================================================================
FROM ${BASE_IMAGE}
# GHSA-2phj-cp9f-qq6w: Harbor < 2.15.3 accepts webhook targets on private,
# loopback and link-local addresses. The base image ships the stock
# (vulnerable) Harbor v2.15.2 deployment; this layer adds only the SSRF
# victim: a fake IMDS on 169.254.169.254, started at VM boot by imds.service.
# No attacker accounts or reproduction state are baked in — the README
# reproduces the registered-user attack chain against a pristine deployment.
COPY --chmod=755 service/fake-imds.py /usr/local/bin/fake-imds.py
COPY service/imds.service /usr/lib/systemd/system/
RUN systemctl enable imds.service
