TEST_HARNESS ?= https://github.com/cloudposse/test-harness.git
TEST_HARNESS_BRANCH ?= tf-tests
TEST_HARNESS_PATH = $(realpath .test-harness/tests/terraform)

default: init all
 
.test-harness:
	[ -d $@ ] || git clone --depth=1 -b $(TEST_HARNESS_BRANCH) $(TEST_HARNESS) $@

init: .test-harness

clean:
	rm -rf .test-harness
  
all: module examples 

deps: init
	@[ ! -x /usr/bin/apk ] || apk add --update terraform-docs@cloudposse

module: export TESTS=00.installed 00.lint 00.get-modules 01.validate 00.terraform-docs 00.input-descriptions 00.output-descriptions
module: deps
	@cd .. && \
	bats --pretty $(addsuffix .bats,$(addprefix $(TEST_HARNESS_PATH)/,$(TESTS)))

examples/complete: export TESTS=01.init 02.plan 02.apply
examples/complete: deps
	@cd ../examples/complete && \
	bats --pretty $(addsuffix .bats,$(addprefix $(TEST_HARNESS_PATH)/,$(TESTS)))
