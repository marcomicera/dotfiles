.PHONY: import
.SILENT: import
import:
	./import.zsh

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
