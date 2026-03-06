.PHONY: help env ci ctr vm dqd push push-ctr push-dqd clean preclean post-clean all dbg generate_ssh_config

# ------------------------------------------------------------------------------
# Config
# ------------------------------------------------------------------------------
REGISTRY ?= ghcr.io
NAMESPACE ?= ctrsploit
DEBUG ?= false
VM_PASSWORD ?= root
KERNEL ?= true
SIZE ?= 10G
TIME_STATS ?= 1

# ------------------------------------------------------------------------------
# Command helpers
# ------------------------------------------------------------------------------
D2VM := docker run --rm -i -v /var/run/docker.sock:/var/run/docker.sock --privileged -v $(PWD):/d2vm -w /d2vm ssst0n3/d2vm:v0.3.4
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
	  '  generate_ssh_config - generate ssh_config/config and per-env ssh helpers' \
	  '  clean  - remove generated vm.qcow2' \
	  '  post-clean - run cleanup after build flow' \
	  '  all    - run clean, ctr, vm, dqd, push, post-clean, generate_ssh_config' \
	  '  dbg    - build debug DQD image' \
	  '' \
	  'Note: each target prints execution time as [TIME] ... (set TIME_STATS=0 to disable)'

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

generate_ssh_config:
	$(time_begin)
	bash script/generate_ssh_config.sh
	$(time_end)

ctr: env
	$(time_begin)
	@echo "Building Docker image in directory $(ENV) with image name $(IMAGE) and version $(VERSION), TAG is $(CTR), SIZE is $(SIZE)"
	@cd $(ENV) && { [ -f build.sh ] && DEBUG=$(DEBUG) ./build.sh $(CTR) || docker build -t $(CTR) . ; }
	$(time_end)

vm: env
	$(time_begin)
	# Add -v to show verbose info.
	$(D2VM) convert $(CTR) --kernel=$(KERNEL) -s $(SIZE) -p $(VM_PASSWORD) -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)
	$(time_end)

dqd: env
	$(time_begin)
	@TMP_DIR=$$(mktemp -d -t dqd-build-XXXXXX); \
	trap 'rm -rf "$$TMP_DIR"' EXIT; \
	cp -r dqd/workspace/* $$TMP_DIR; \
	cp $(ENV)/vm.qcow2 $$TMP_DIR; \
	docker build -t $(DQD_VERSION) $$TMP_DIR
	$(time_end)

push-ctr: env
	$(time_begin)
	docker push $(CTR)
	$(time_end)

push-dqd: env
	$(time_begin)
	docker tag $(DQD_VERSION) $(DQD_LATEST)
	docker push $(DQD_VERSION)
	docker push $(DQD_LATEST)
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

all: env clean ctr vm dqd push post-clean generate_ssh_config

dbg: clean ctr
	$(time_begin)
	$(D2VM) convert $(CTR) --append-to-cmdline nokaslr -p root -o $(ENV)/vm.qcow2
	$(sparsify_qcow2)
	cd $(ENV) && docker build -t $(DQD_VERSION) -f Dockerfile.dbg .
	$(time_end)
