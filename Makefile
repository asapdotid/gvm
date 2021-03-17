.POSIX:

PLATFORM=$(shell uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(shell uname -m | tr '[:upper:]' '[:lower:]')
ARCH_SIMPLE=$(shell echo $(ARCH) | sed 's/x86_64/amd64/g')

SHELLCHECK_VERSION=v0.7.1
SHELLCHECK_DOWNLOAD_URL=https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/shellcheck-$(SHELLCHECK_VERSION).$(PLATFORM).$(ARCH).tar.xz
SHELLCHECK_TAR_PATH=shellcheck-$(SHELLCHECK_VERSION)/shellcheck

SHFMT_VERSION=3.2.4
SHFMT_DOWNLOAD_URL=https://github.com/mvdan/sh/releases/download/v$(SHFMT_VERSION)/shfmt_v$(SHFMT_VERSION)_$(PLATFORM)_$(ARCH_SIMPLE)

.PHONY: prepare
prepare: .tmp/shellcheck .tmp/shfmt

.PHONY: lint
lint: prepare
	@./.tmp/shellcheck bin/* mocks/*
	@./.tmp/shfmt -d bin/* mocks/*

.PHONY: format
format: prepare
	@./.tmp/shfmt -w bin/* mocks/*

.tmp/shellcheck:
	@echo "Downloading shellcheck"
	@echo
	@mkdir -p .tmp
	@curl --location '$(SHELLCHECK_DOWNLOAD_URL)' | tar -xJO '$(SHELLCHECK_TAR_PATH)' > .tmp/shellcheck
	@chmod +x .tmp/shellcheck
	@echo

.tmp/shfmt:
	@echo "Downloading shfmt"
	@echo
	@mkdir -p .tmp
	@curl --location '$(SHFMT_DOWNLOAD_URL)' > .tmp/shfmt
	@chmod +x .tmp/shfmt
	@echo
