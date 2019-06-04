PACKAGE  = terraform-null-label
GOPATH   = $(CURDIR)/.gopath
GOBIN    = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PATH 	:= $(PATH):$(GOBIN)

export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true

.PHONY: all
## Default target
all: test

-include Makefile.*

export GOPATH

## Prepare the GOPATH
$(BASE):
	@mkdir -p $(dir $@)
	@ln -sf $(CURDIR) $@

## install OS-specific dependencies. See Makefile.*
deps::
	@exit 0

.PHONY : init
## Initialize tests
init: | $(BASE)

.PHONY : ensure
## Install test dependencies
ensure:
	cd $(BASE) && dep ensure

.PHONY : test
## Run tests
test: deps ensure
	cd $(BASE) && go test -v -timeout 30m -run TestExamplesComplete

## Clean up files
clean:
	rm -rf .gopath/ vendor/ $(TF_DATA_DIR)


