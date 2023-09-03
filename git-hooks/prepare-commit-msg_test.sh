#!/bin/bash

TOTAL_TESTS=0

assert() {
  local expected=$1
  local actual=$2
  local label="${3:-Assertion}"

  if [[ "$expected" != "$actual" ]]; then
    printf "❌  %s failed:\\n Expected '%s'\\n but got  '%s'\\n" "$label" "$expected" "$actual"
    exit 1
  else
    ((TOTAL_TESTS++))
    printf "✔️  Passed: %s -> '%s'\\n" "$label" "$expected"
  fi
}

echo ""
echo "All assertions passed. Total:" "$TOTAL_TESTS"
