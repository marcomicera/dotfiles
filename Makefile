.PHONY: import
.SILENT: import
import:
	./main.zsh --import

.PHONY: install
.SILENT: install
install:
	./main.zsh --install

.PHONY: tree
.SILENT: tree
tree:
	tree \
		-a \
		-I '.git|.gitignore|.idea|Makefile|README.md|img|main.zsh|util'

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
