PACKAGE  = terraform-null-label
GOEXE   ?= /usr/bin/go
GOPATH   = $(CURDIR)/.gopath
GOBIN    = $(GOPATH)/bin
BASE     = $(GOPATH)/src/$(PACKAGE)
PATH 	:= $(PATH):$(GOBIN)

export TF_DATA_DIR ?= $(CURDIR)/.terraform
export TF_CLI_ARGS_init ?= -get-plugins=true
export GOPATH

.PHONY: all
## Default target
all: test

ifneq (,$(wildcard /sbin/apk))
## Install go, if not installed
$(GOEXE):
	apk add --update go
endif

ifeq ($(shell uname -s),Linux)
## Install all `dep`, if not installed
$(GOBIN)/dep:
	@mkdir -p $(GOBIN)
	@curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
endif

## Prepare the GOPATH
$(BASE): $(GOEXE)
	@mkdir -p $(dir $@)
	@ln -sf $(CURDIR) $@

## Download vendor dependencies to vendor/
$(BASE)/vendor: $(BASE) $(GOBIN)/dep
	cd $(BASE) && dep ensure

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
