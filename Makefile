# Directory where your tests scripts are located
SRC_SCRIPTS_DIR = git-hooks
TEST_SCRIPTS_DIR = tests

# Find all *_test.sh scripts in the specified directory
TEST_SCRIPTS = $(wildcard $(TEST_SCRIPTS_DIR)/*_test.sh)

# Display the list of tests scripts found
init-hooks:
	$(SRC_SCRIPTS_DIR)/init.sh

# Display the list of tests scripts found
list-tests:
	@echo "Test scripts found:"
	@echo "$(TEST_SCRIPTS)"

# Run all tests scripts
test: $(TEST_SCRIPTS)
	$(TEST_SCRIPTS_DIR)/test_runner.sh $(TEST_SCRIPTS)

.PHONY: test list-tests
