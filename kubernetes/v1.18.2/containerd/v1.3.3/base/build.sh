#!/bin/bash
set -ex
cd "$(dirname "$0")"
source .env
make -C "$(git rev-parse --show-toplevel)" ctr ENV=kubernetes/v1.18.2/containerd/v1.3.3/base
