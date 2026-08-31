.PHONY: help env ci ctr vm dqd push push-ctr push-dqd clean preclean post-clean all dbg check-ssh-ports generate_ssh_config cli generate-catalog check-catalog

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
REGISTRY ?= ghcr.io
NAMESPACE ?= ctrsploit
DEBUG ?= false
VM_PASSWORD ?= root
KERNEL ?= true
SIZE ?= 10G
# Extra kernel cmdline args appended to the generated one at d2vm convert
# time (e.g. "nosmep nosmap noibt"). Empty by default = current behavior.
APPEND_TO_CMDLINE ?=
TIME_STATS ?= 1
PUSH_RETRIES ?= 3
PUSH_RETRY_DELAY ?= 10

# ------------------------------------------------------------------------------
# Toolchain location
# ------------------------------------------------------------------------------
# Directory of this Makefile (no trailing slash). Toolchain assets
# (script/, cli/, dqd/workspace) resolve relative to it, while
# environment paths and generated artifacts resolve relative to the
# invocation directory ($(CURDIR)). This lets a sibling repository
# (e.g. a private dqd-pro) `include` this Makefile and reuse the build
# pipeline without forking it; invoked directly in this checkout the
# two directories coincide and behavior is unchanged.
TOOLCHAIN_DIR := $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))

# ------------------------------------------------------------------------------
# Command helpers
# ------------------------------------------------------------------------------
D2VM := docker run --rm -i -v /var/run/docker.sock:/var/run/docker.sock --privileged -v $(PWD):/d2vm -w /d2vm ssst0n3/d2vm:v0.3.7
VIRT_SPARSIFY := docker run -i --rm -v $(PWD)/$(ENV):/data -w /data --device=/dev/kvm ghcr.io/ssst0n3/libguestfs:latest virt-sparsify

# ------------------------------------------------------------------------------
# Derived values
# ------------------------------------------------------------------------------
ENV_FILE = $(ENV)/.env

REPO = $(REGISTRY)/$(NAMESPACE)/$(IMAGE)
CTR = $(REPO):ctr_$(VERSION)
DQD_LATEST = $(REPO):latest
DQD_VERSION = $(REPO):$(VERSION)

# ------------------------------------------------------------------------------
# Validation and shared recipes
# ------------------------------------------------------------------------------
define require_env
$(if $(strip $(ENV)),,$(error ENV is required. Example: make $(1) ENV=ubuntu/22.04))
endef

define load_env
$(if $(wildcard $(ENV_FILE)),,$(error Missing env file: $(ENV_FILE)))
$(eval include $(ENV_FILE))
$(eval export $(shell sed -n 's/^\([A-Za-z_][A-Za-z0-9_]*\)=.*/\1/p' $(ENV_FILE)))
endef

define sparsify_qcow2
cd $(ENV) && $(VIRT_SPARSIFY) --compress vm.qcow2 shrunk.qcow2 && mv -f shrunk.qcow2 vm.qcow2
endef

define docker_push
@attempt=1; \
until docker push "$(1)"; do \
    if [ "$$attempt" -ge "$(PUSH_RETRIES)" ]; then \
        echo "docker push failed after $$attempt attempt(s): $(1)" >&2; \
        exit 1; \
    fi; \
    attempt=$$((attempt+1)); \
    echo "docker push failed; retrying $(1) in $(PUSH_RETRY_DELAY)s (attempt $$attempt/$(PUSH_RETRIES))" >&2; \
    sleep "$(PUSH_RETRY_DELAY)"; \
done
endef

define time_begin
@if [ "$(TIME_STATS)" = "1" ]; then \
    time_file="/tmp/dqd-make-time-$@"; \
    start_time=$$(date +%s); \
    printf '%s\n' "$$start_time" > "$$time_file"; \
    echo "[TIME] $@ start"; \
fi
endef

define time_end
@if [ "$(TIME_STATS)" = "1" ]; then \
    time_file="/tmp/dqd-make-time-$@"; \
    if [ -f "$$time_file" ]; then \
        read -r start_time < "$$time_file"; \
    else \
        start_time=$$(date +%s); \
    fi; \
    end_time=$$(date +%s); \
    elapsed=$$((end_time-start_time)); \
    rm -f "$$time_file"; \
    echo "[TIME] $@ done in $${elapsed}s"; \
fi
endef

help:
	@printf '%s\n' \
	  'Usage: make <target> ENV=<path> [VM_PASSWORD=<password>] [SIZE=10G] [DEBUG=false] [TIME_STATS=1]' \
	  '' \
	  'Targets:' \
	  '  env    - validate ENV and load variables from $$(ENV)/.env' \
	  '  ci     - run CI target set from CI_MAKE_TARGETS (default: all)' \
	  '  ctr    - build container image (uses build.sh when present)' \
	  '  vm     - convert container image to vm.qcow2 and sparsify it' \
	  '  dqd    - build DQD image with vm.qcow2' \
	  '  push-ctr - push ctr tag only' \
	  '  push-dqd - push DQD versioned and latest tags' \
	  '  push   - push ctr and DQD tags' \
	  '  check-ssh-ports - verify SSH host ports are unique across environments' \
	  '  check-catalog - verify catalog.json matches the checkout' \
	  '  generate-catalog - regenerate catalog.json from the checkout' \
	  '  cli - build the Go dqd CLI into bin/dqd' \
	  '  generate_ssh_config - generate ssh_config/config and per-env ssh helpers' \
	  '  clean  - remove generated vm.qcow2' \
	  '  post-clean - run cleanup after build flow' \
	  '  all    - run clean, ctr, vm, dqd, push, post-clean, generate_ssh_config' \
	  '  dbg    - build debug DQD image' \
	  '' \
	  'Note: each target prints execution time as [TIME] ... (set TIME_STATS=0 to disable)' \
	  'Note: push targets retry with PUSH_RETRIES=3 and PUSH_RETRY_DELAY=10 by default'

env:
	$(call require_env,env)
	$(load_env)
	$(if $(strip $(IMAGE)),,$(error IMAGE is missing in $(ENV_FILE)))
	$(if $(strip $(VERSION)),,$(error VERSION is missing in $(ENV_FILE)))
	@:

ci: env
	$(time_begin)
	@TARGETS="$(if $(strip $(CI_MAKE_TARGETS)),$(CI_MAKE_TARGETS),all)"; \
	echo "Running CI targets '$$TARGETS' for ENV=$(ENV)"; \
	$(MAKE) $$TARGETS ENV=$(ENV)
	$(time_end)

check-ssh-ports:
	$(time_begin)
	bash $(TOOLCHAIN_DIR)/script/check_ssh_ports.sh
	bash $(TOOLCHAIN_DIR)/script/check_ssh_config_consistency.sh
	$(time_end)

# Catalog freshness: catalog.json AND the committed embedded snapshot
# (cli/internal/embedded/live) must be regenerated whenever
# environment files change. Enforced alongside the SSH port checks so
# CI catches stale catalogs.
check-catalog:
	$(time_begin)
	cd $(TOOLCHAIN_DIR)/cli && go run ./cmd/dqd-gen check --repo $(CURDIR)
	$(time_end)

# Regenerate both committed artifacts: catalog.json and the embedded
# config snapshot (so `go install` builds a current self-contained
# binary). Run this in every change that touches environment files.
# When included from a foreign checkout (TOOLCHAIN_DIR != CURDIR), only
# catalog.json is refreshed: the embedded snapshot belongs to this
# repository's CLI and must never embed foreign (possibly private)
# environments.
generate-catalog:
	$(time_begin)
	cd $(TOOLCHAIN_DIR)/cli && go run ./cmd/dqd-gen catalog --repo $(CURDIR)
ifeq ($(abspath $(TOOLCHAIN_DIR)),$(abspath $(CURDIR)))
	cd $(TOOLCHAIN_DIR)/cli && go run ./cmd/dqd-gen embed --repo $(CURDIR) --out internal/embedded/live
else
	@echo "note: foreign checkout ($(CURDIR)) — refreshed catalog.json only; the embedded snapshot belongs to $(abspath $(TOOLCHAIN_DIR))"
endif
	$(time_end)

# Build the Go dqd CLI into bin/dqd. The embedded snapshot is
# committed, so a plain `go build`/`go install` works too; this
# target just refreshes it first so the binary matches this exact
# tree. (The legacy bash CLI lives in bin/dqd-sh, deprecated.)
# dqd-CLI-specific: refused when this Makefile is included from a
# foreign checkout (the embed step must never capture foreign envs).
cli:
	$(time_begin)
ifeq ($(abspath $(TOOLCHAIN_DIR)),$(abspath $(CURDIR)))
	cd $(TOOLCHAIN_DIR)/cli && go run ./cmd/dqd-gen embed --repo $(CURDIR) --out internal/embedded/live
	cd $(TOOLCHAIN_DIR)/cli && go build -trimpath -ldflags "-X main.version=$$(git describe --tags --always --dirty 2>/dev/null || echo dev)" -o ../bin/dqd ./cmd/dqd
else
	$(error the cli target builds dqd's own CLI and embeds this checkout's environments; run it from $(abspath $(TOOLCHAIN_DIR)), not from a foreign checkout)
endif
	$(time_end)

generate_ssh_config: check-ssh-ports
	$(time_begin)
	bash $(TOOLCHAIN_DIR)/script/generate_ssh_config.sh
	$(time_end)

ctr: env
	$(time_begin)
	@echo "Building Docker image in directory $(ENV) with image name $(IMAGE) and version $(VERSION), TAG is $(CTR), SIZE is $(SIZE)"
	# Use if/else (not `A && B || C`): the latter silently falls through to
	# `docker build` when build.sh EXISTS but FAILS, masking the real error
	# (e.g. the legacy builder then reports "security.insecure is not allowed"
	# for a Dockerfile that needs buildx entitlements, hiding a no-space/disk
	# failure). Fall back to `docker build` only when build.sh is absent.
	@cd $(ENV) && { if [ -f build.sh ]; then DEBUG=$(DEBUG) ./build.sh $(CTR); else docker build -t $(CTR) .; fi ; }
	$(time_end)

vm: env
	$(time_begin)
	# Add -v to show verbose info.
	# --append-to-cmdline is only passed when APPEND_TO_CMDLINE is non-empty,
	# so the default flow is unchanged.
	$(D2VM) convert $(CTR) --kernel=$(KERNEL) $(if $(strip $(APPEND_TO_CMDLINE)),--append-to-cmdline="$(APPEND_TO_CMDLINE)") -s $(SIZE) -p $(VM_PASSWORD) -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)
	$(time_end)

dqd: env
	$(time_begin)
	@TMP_DIR=$$(mktemp -d -t dqd-build-XXXXXX); \
	trap 'rm -rf "$$TMP_DIR"' EXIT; \
	cp -r $(TOOLCHAIN_DIR)/dqd/workspace/* $$TMP_DIR; \
	cp $(ENV)/vm.qcow2 $$TMP_DIR; \
	docker build -t $(DQD_VERSION) $$TMP_DIR
	$(time_end)

push-ctr: env
	$(time_begin)
	$(call docker_push,$(CTR))
	$(time_end)

push-dqd: env
	$(time_begin)
	docker tag $(DQD_VERSION) $(DQD_LATEST)
	$(call docker_push,$(DQD_VERSION))
	$(call docker_push,$(DQD_LATEST))
	$(time_end)

push: push-ctr push-dqd

clean: env
	$(time_begin)
	$(call require_env,clean)
	rm -f $(ENV)/vm.qcow2
	$(time_end)

post-clean: clean
	$(time_begin)
	rm -f $(ENV)/1
	$(time_end)

all: env check-ssh-ports clean ctr vm dqd push post-clean generate_ssh_config

dbg: clean ctr
	$(time_begin)
	$(D2VM) convert $(CTR) --append-to-cmdline nokaslr -p root -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)
	cd $(ENV) && docker build -t $(DQD_VERSION) -f Dockerfile.dbg .
	$(time_end)
