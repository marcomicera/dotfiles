# https://stackoverflow.com/a/23324703
SCRIPTS = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))/scripts

# Open command
ifeq ($(OS), Windows_NT)
	OPEN := start
else
	UNAME := $(shell uname -s)
	ifeq ($(UNAME), Linux)
		OPEN := xdg-open
	else ifeq ($(UNAME), Darwin)
		OPEN := open
	endif
endif


.PHONY: all
# .SILENT: all
all:
	$(MAKE) submodules
	$(MAKE) sync NO_GIT_INFO=1
	$(MAKE) import NO_GIT_INFO=1
	$(MAKE) status
	$(MAKE) diff

.PHONY: sync
.SILENT: sync
sync:
	$(SCRIPTS)/sync.zsh
ifeq ($(NO_GIT_INFO),)
	$(MAKE) status
	$(MAKE) diff
endif

.PHONY: import
.SILENT: import
import:
	$(SCRIPTS)/import.zsh
ifeq ($(NO_GIT_INFO),)
	$(MAKE) status
	$(MAKE) diff
endif

.PHONY: status
.SILENT: status
status:
	$(SCRIPTS)/status.sh

.PHONY: diff
.SILENT: diff
diff:
	$(SCRIPTS)/diff.sh

.PHONY: tree
.SILENT: tree
tree:
	tree \
		-a \
		-I '.git|.gitignore|.idea|Makefile|README.md|img|import.zsh|util'

.PHONY: start-colima
start-colima:
ifeq ($(UNAME), Darwin)
	@if ! docker info > /dev/null 2>&1; then \
		echo "Container runtime is not running. Starting Colima..."; \
		colima start; \
		echo "Colima is now running."; \
	fi
endif

.PHONY: gitleaks
.SILENT: gitleaks
gitleaks: start-colima
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
