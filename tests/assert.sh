#!/bin/bash

export TEST=true

export assert

TOTAL_TESTS=0
FAILED=false

assert() {
  local expected="$1"
  local actual="$2"
  local label="${3:-Assertion}"

  if [[ "$expected" != "$actual" ]]; then
    FAILED=true
    printf "❌  %s failed:\\n Expected '%s'\\n but got  '%s'\\n" "$label" "$expected" "$actual"
    exit 1
  else
    ((TOTAL_TESTS++))
    printf "✔️  Passed: %s -> '%s'\\n" "$label" "$expected"
  fi
}

render_result() {
  echo ""
  if [[ "$FAILED" == false ]]; then
    echo "All assertions passed. Total:" "$TOTAL_TESTS"
  fi
}

# Set a trap to call render_result when the script exits
trap render_result EXIT
