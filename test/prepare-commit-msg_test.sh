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

export TEST_BRANCH=""
assert "" "$("$SCRIPT" "doc: [BRANCH-666] the msg")" "Ignore all logic when using a conventional commit"

export TEST_BRANCH="main"
assert "feat: the msg" "$("$SCRIPT" "the msg")" "Use default branchKey optional"

export TEST_BRANCH="feat"
assert "feat: the msg" "$("$SCRIPT" "the msg")" "Make jiraTicket optional"

export TEST_BRANCH="BRANCH-123"
assert "feat: [BRANCH-123] the msg" "$("$SCRIPT" "the msg")" "Use feat/ when no key is used in the branch"

export TEST_BRANCH="feat/BRANCH-123"
assert "doc: [BRANCH-123] the msg" "$("$SCRIPT" "doc: the msg")" "Override key in message"
assert "feat: [BRANCH-123] the msg" "$("$SCRIPT" "the msg")" "Only commit message"
assert "feat(scope): [BRANCH-123] the msg" "$("$SCRIPT" "(scope)the msg")" "Start message with scope"

export TEST_BRANCH="doc/BRANCH-123"
assert "doc: [BRANCH-123] the msg" "$("$SCRIPT" "the msg")" "Use a custom branch key"

export TEST_BRANCH="BRANCH-123"
assert "feat: [BRANCH-123] feat the msg" "$("$SCRIPT" "feat the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-123] the msg" "$("$SCRIPT" "feat: the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-123] [INCOM-456] the msg" "$("$SCRIPT" "[INCOM-456] the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-123] doc [INCOM-456] the msg" "$("$SCRIPT" "doc [INCOM-456] the msg")" "Incomplete conventional commit"

echo ""
echo "All assertions passed. Total:" "$TOTAL_TESTS"
