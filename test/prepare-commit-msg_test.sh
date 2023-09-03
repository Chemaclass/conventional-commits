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


export TEST=true

export SCRIPT="$PWD/git-hooks/prepare-commit-msg.sh"

export TEST_BRANCH="BRANCH-123"
assert "feat: [BRANCH-123] the msg" "$("$SCRIPT" "the msg")" "Use feat/ when no key is used in the branch"

export TEST_BRANCH="feat/BRANCH-123"
assert "doc: [BRANCH-123] the msg" "$("$SCRIPT" "doc: the msg")" "Override key in message"

export TEST_BRANCH="main"
assert "feat: the msg" "$("$SCRIPT" "the msg")" "Make Ticket Key optional"

echo ""
echo "All assertions passed. Total:" "$TOTAL_TESTS"
