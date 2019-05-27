PACKAGE  = terraform-null-label
GOPATH   = $(CURDIR)/.gopath
GOBIN    = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PATH 	:= $(PATH):$(GOBIN)

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
init: | $(BASE) deps ensure

.PHONY : ensure
## Install test dependencies
ensure:
	cd $(BASE) && dep ensure

.PHONY : test
## Run tests
test:
	cd $(BASE) && go test -v -timeout 30m -run TestExamplesComplete

## Clean up files
clean:
	rm -rf .gopath/ vendor/


