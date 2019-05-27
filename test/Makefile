TEST_HARNESS ?= https://github.com/cloudposse/test-harness.git
TEST_HARNESS_BRANCH ?= tf-tests
TEST_HARNESS_PATH = $(realpath .test-harness)
BATS_ARGS ?= --tap
BATS_LOG ?= test.log

# Define a macro to run the tests
define RUN_TESTS 
@echo "Running tests in $(1)"
@cd $(1) && bats $(BATS_ARGS) $(addsuffix .bats,$(addprefix $(TEST_HARNESS_PATH)/test/terraform/,$(TESTS)))
endef

default: all

# Provision the test-harnesss
.test-harness:
	[ -d $@ ] || git clone --depth=1 -b $(TEST_HARNESS_BRANCH) $(TEST_HARNESS) $@

# Initialize the tests
init: .test-harness

# Clean up the test harness
clean:
	[ "$(TEST_HARNESS_PATH)" == "/" ] || rm -rf $(TEST_HARNESS_PATH)
  
# Run all tests
all: module examples/complete

# Install all dependencies (OS specific)
deps: init
	@[ ! -x /sbin/apk ] || apk add --update terraform-docs@cloudposse

# Run basic sanity checks against the module itself
module: export TESTS ?= installed lint get-modules validate terraform-docs input-descriptions output-descriptions
module: deps
	$(call RUN_TESTS, ../)

# Run tests against example
examples/complete: export TESTS ?= init plan apply
examples/complete: deps
	$(call RUN_TESTS, ../$@)
