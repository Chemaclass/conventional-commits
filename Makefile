SHELL=/bin/bash
ROOT_DIR = .
SRC_SCRIPTS_DIR = git-hooks
TEST_SCRIPTS_DIR = tests

TEST_SCRIPTS = $(wildcard $(TEST_SCRIPTS_DIR)/*_test.sh)

init-hooks:
	$(SRC_SCRIPTS_DIR)/init.sh

list-tests:
	@echo "Test scripts found:"
	@echo $(TEST_SCRIPTS) | tr ' ' '\n'

test: $(TEST_SCRIPTS)
	TEST=true ./bin/bashunit "$(TEST_SCRIPTS)"

test/watch: $(TEST_SCRIPTS)
	watch --color -n 1 ./bin/bashunit "$(TEST_SCRIPTS)"

.PHONY: test list-tests
