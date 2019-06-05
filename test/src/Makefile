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

## Download vendor dependencies to vendor/
$(BASE)/vendor: $(BASE) $(GOBIN)/dep
	cd $(BASE) && dep ensure

.PHONY : deps
## install OS-specific dependencies. See Makefile.*
deps::
	@exit 0

.PHONY : init
## Initialize tests
init: $(BASE)/vendor

.PHONY : test
## Run tests
test: init
	cd $(BASE) && go test -v -timeout 30m -run TestExamplesComplete

.PHONY : clean
## Clean up files
clean:
	rm -rf .gopath/ vendor/ $(TF_DATA_DIR)
