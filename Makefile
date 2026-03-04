.PHONY: help env ci ctr vm dqd push push-ctr push-dqd clean all dbg

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
REGISTRY ?= ghcr.io
NAMESPACE ?= ctrsploit
DEBUG ?= false
VM_PASSWORD ?= root
KERNEL ?= true
SIZE ?= 10G

# ------------------------------------------------------------------------------
# Command helpers
# ------------------------------------------------------------------------------
D2VM := docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock --privileged -v $(PWD):/d2vm -w /d2vm ssst0n3/d2vm:v0.3.4
VIRT_SPARSIFY := docker run -it --rm -v $(PWD)/$(ENV):/data -w /data --env PUID=$(shell id -u) --env PGID=$(shell id -u) bkahlert/libguestfs:edge virt-sparsify

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

help:
	@printf '%s\n' \
	  'Usage: make <target> ENV=<path> [VM_PASSWORD=<password>] [SIZE=10G] [DEBUG=false]' \
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
	  '  clean  - remove generated vm.qcow2' \
	  '  all    - run clean, ctr, vm, dqd' \
	  '  dbg    - build debug DQD image'

env:
	$(call require_env,env)
	$(load_env)
	$(if $(strip $(IMAGE)),,$(error IMAGE is missing in $(ENV_FILE)))
	$(if $(strip $(VERSION)),,$(error VERSION is missing in $(ENV_FILE)))
	@:

ci: env
	@TARGETS="$(if $(strip $(CI_MAKE_TARGETS)),$(CI_MAKE_TARGETS),all)"; \
	echo "Running CI targets '$$TARGETS' for ENV=$(ENV)"; \
	$(MAKE) $$TARGETS ENV=$(ENV)

ctr: env
	@echo "Building Docker image in directory $(ENV) with image name $(IMAGE) and version $(VERSION), TAG is $(CTR), SIZE is $(SIZE)"
	@cd $(ENV) && { [ -f build.sh ] && DEBUG=$(DEBUG) ./build.sh $(CTR) || docker build -t $(CTR) . ; }

vm: env
	# Add -v to show verbose info.
	$(D2VM) convert $(CTR) --kernel=$(KERNEL) -s $(SIZE) -p $(VM_PASSWORD) -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)

dqd: env
	@TMP_DIR=$$(mktemp -d -t dqd-build-XXXXXX); \
	trap 'rm -rf "$$TMP_DIR"' EXIT; \
	cp -r dqd/workspace/* $$TMP_DIR; \
	cp $(ENV)/vm.qcow2 $$TMP_DIR; \
	docker build -t $(DQD_VERSION) $$TMP_DIR

push-ctr: env
	docker push $(CTR)

push-dqd: env
	docker tag $(DQD_VERSION) $(DQD_LATEST)
	docker push $(DQD_VERSION)
	docker push $(DQD_LATEST)

push: push-ctr push-dqd

clean:
	$(call require_env,clean)
	rm -f $(ENV)/vm.qcow2 $(ENV)/1

all: env clean ctr vm dqd clean push

dbg: clean ctr
	$(D2VM) convert $(CTR) --append-to-cmdline nokaslr -p root -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)
	cd $(ENV) && docker build -t $(DQD_VERSION) -f Dockerfile.dbg .
