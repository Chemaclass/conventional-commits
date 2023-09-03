# Directory where your test scripts are located
TEST_SCRIPTS_DIR = test

# Find all *_test.sh scripts in the specified directory
TEST_SCRIPTS = $(wildcard $(TEST_SCRIPTS_DIR)/*_test.sh)

# Display the list of test scripts found
list-tests:
	@echo "Test scripts found:"
	@echo "$(TEST_SCRIPTS)"

# Run all test scripts
test: $(TEST_SCRIPTS)
	@for test_script in $(TEST_SCRIPTS); do \
		echo "Running $$test_script"; \
		bash $$test_script; \
	done

.PHONY: test list-tests
