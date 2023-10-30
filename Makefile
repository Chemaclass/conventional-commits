SHELL=/bin/bash
ROOT_DIR = .
SRC_SCRIPTS_DIR = git-hooks
TEST_SCRIPTS_DIR = tests

init-hooks:
	$(SRC_SCRIPTS_DIR)/init.sh

list-tests:
	@echo "Test scripts found:"
	@echo $(TEST_SCRIPTS) | tr ' ' '\n'

test: $(TEST_SCRIPTS)
	TEST=true ./lib/bashunit tests

test/watch: $(TEST_SCRIPTS)
	watch --color -n 1 ./lib/bashunit tests

.PHONY: test list-tests
