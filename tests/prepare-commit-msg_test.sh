#!/bin/bash

source "$(dirname "$0")/assert.sh"

readonly SCRIPT="$PWD/git-hooks/prepare-commit-msg.sh"

function test_ignore_all_logic_when_using_a_conventional_commit() {
  export TEST_BRANCH=""
  assert "" "$("$SCRIPT" "doc: [BRANCH-666] the msg")" "Ignore all logic when using a conventional commit"
}

function test_use_default_branchKey_optional() {
  export TEST_BRANCH="main"
  assert "feat: the msg" "$("$SCRIPT" "the msg")" "Use default branchKey optional"
}

function test_make_jiraTicket_optional() {
  export TEST_BRANCH="feat"
  assert "feat: the msg" "$("$SCRIPT" "the msg")" "Make jiraTicket optional"
}

function test_use_feat_when_no_key_is_used_in_the_branch() {
  export TEST_BRANCH="BRANCH-1"
  assert "feat: [BRANCH-1] the msg" "$("$SCRIPT" "the msg")" "Use feat/ when no key is used in the branch"
}

function test_override_key_message() {
  export TEST_BRANCH="feat/BRANCH-2"
  assert "doc: [BRANCH-2] the msg" "$("$SCRIPT" "doc: the msg")" "Override key in message"
}

function test_only_commit_message() {
  export TEST_BRANCH="feat/BRANCH-3"
  assert "feat: [BRANCH-3] the msg" "$("$SCRIPT" "the msg")" "Only commit message"
}
function test_start_message_with_scope() {
  export TEST_BRANCH="feat/BRANCH-4"
  assert "feat(scope): [BRANCH-4] the msg" "$("$SCRIPT" "(scope)the msg")" "Start message with scope"
}

function test_use_a_custom_branch_key() {
  export TEST_BRANCH="doc/BRANCH-5"
  assert "doc: [BRANCH-5] the msg" "$("$SCRIPT" "the msg")" "Use a custom branch key"
}

function test_incomplete_conventional_commit() {
  export TEST_BRANCH="BRANCH-6"
  assert "feat: [BRANCH-6] feat the msg" "$("$SCRIPT" "feat the msg")" "Incomplete conventional commit"
  assert "feat: [BRANCH-6] the msg" "$("$SCRIPT" "feat: the msg")" "Incomplete conventional commit"
  assert "feat: [BRANCH-6] [INCOM-456] the msg" "$("$SCRIPT" "[INCOM-456] the msg")" "Incomplete conventional commit"
  assert "feat: [BRANCH-6] doc [INCOM-456] the msg" "$("$SCRIPT" "doc [INCOM-456] the msg")" "Incomplete conventional commit"
}

function test_breaking_changes_syntax() {
  export TEST_BRANCH="BRANCH-7"
  assert "feat!: [BRANCH-7] the msg" "$("$SCRIPT" "!the msg")" "Start message with breaking change"
  assert "feat(scope)!: [BRANCH-7] the msg" "$("$SCRIPT" "!(scope)the msg")" "Breaking change and scope"
}