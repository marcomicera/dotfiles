# https://stackoverflow.com/a/23324703
SCRIPTS = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/scripts

.PHONY: all
# .SILENT: all
all:
	make sync NO_STATUS=1
	make import NO_STATUS=1
	make status

.PHONY: sync
.SILENT: sync
sync:
	$(SCRIPTS)/sync.zsh
ifeq ($(NO_STATUS),)
	make status
endif

.PHONY: import
.SILENT: import
import:
	$(SCRIPTS)/import.zsh
ifeq ($(NO_STATUS),)
	make status
endif

.PHONY: status
.SILENT: status
status:
	$(SCRIPTS)/status.sh

.PHONY: tree
.SILENT: tree
tree:
	tree \
		-a \
		-I '.git|.gitignore|.idea|Makefile|README.md|img|import.zsh|util'

.PHONY: gitleaks
.SILENT: gitleaks
gitleaks:
	docker run \
		--rm \
		--name gitleaks \
		--env RUN_LOCAL=true \
		--volume $(shell pwd -P):/tmp \
		zricethezav/gitleaks:latest \
		--source="/tmp" \
		--verbose \
		--redact \
		detect

.PHONY: submodules
submodules:
	git submodule update --init --recursive
