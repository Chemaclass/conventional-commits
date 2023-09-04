#!/bin/bash

source "$(dirname "$0")/assert.sh"

readonly SCRIPT="$PWD/git-hooks/prepare-commit-msg.sh"

function test_ignore_all_logic_when_using_a_conventional_commit() {
  export TEST_BRANCH="main"
  assert "" "$("$SCRIPT" "doc: [BRANCH-666] the msg")"
}

function test_use_default_branchKey_feat() {
  export TEST_BRANCH="main"
  assert "feat: the msg" "$("$SCRIPT" "the msg")"
}

function test_make_jiraTicket_optional() {
  export TEST_BRANCH="feat"
  assert "feat: the msg" "$("$SCRIPT" "the msg")"
}

function test_avoid_duplicate_branchKey() {
  export TEST_BRANCH="BRANCH-0"
  assert "feat: [BRANCH-0] the msg" "$("$SCRIPT" "feat: the msg")"
}

function test_use_feat_when_no_key_is_used_in_the_branch() {
  export TEST_BRANCH="BRANCH-1"
  assert "feat: [BRANCH-1] the msg" "$("$SCRIPT" "the msg")"
}

function test_override_key_message() {
  export TEST_BRANCH="feat/BRANCH-2"
  assert "doc: [BRANCH-2] the msg" "$("$SCRIPT" "doc: the msg")"
}

function test_only_commit_message_in_a_branch_with_key_and_ticket() {
  export TEST_BRANCH="feat/BRANCH-3"
  assert "feat: [BRANCH-3] the msg" "$("$SCRIPT" "the msg")"
}

function test_start_message_with_scope() {
  export TEST_BRANCH="feat/BRANCH-4"
  assert "feat(scope): [BRANCH-4] the msg" "$("$SCRIPT" "(scope)the msg")" "Scope in message (without space)"
  assert "feat(scope): [BRANCH-4] the msg" "$("$SCRIPT" "(scope) the msg")" "Scope in message"
}

function test_use_a_custom_branch_key() {
  export TEST_BRANCH="doc/BRANCH-5"
  assert "doc: [BRANCH-5] the msg" "$("$SCRIPT" "the msg")"
}

function test_normalize_branch_keys() {
  export TEST_BRANCH="task/BRANCH-61"
  assert "feat: [BRANCH-61] the msg" "$("$SCRIPT" "the msg")" "Normalize task into feat"

  export TEST_BRANCH="feature/BRANCH-62"
  assert "feat: [BRANCH-62] the msg" "$("$SCRIPT" "the msg")" "Normalize feature into feat"

  export TEST_BRANCH="story/BRANCH-63"
  assert "feat: [BRANCH-63] the msg" "$("$SCRIPT" "the msg")" "Normalize story into feat"

  export TEST_BRANCH="bug/BRANCH-64"
  assert "fix: [BRANCH-64] the msg" "$("$SCRIPT" "the msg")" "Normalize bug into fix"

  export TEST_BRANCH="bugfix/BRANCH-64"
  assert "fix: [BRANCH-64] the msg" "$("$SCRIPT" "the msg")" "Normalize bugfix into fix"
}

function test_incomplete_conventional_commit() {
  export TEST_BRANCH="BRANCH-7"
  assert "feat: [BRANCH-7] feat the msg" "$("$SCRIPT" "feat the msg")" "Missing colon after branchKey"
  assert "feat: [BRANCH-7] [INCOM-456] the msg" "$("$SCRIPT" "[INCOM-456] the msg")" "Missing branchKey"
  assert "feat: [BRANCH-7] doc [INCOM-456] the msg" "$("$SCRIPT" "doc [INCOM-456] the msg")" "Missing colon after branchKey with jiraTicket"
}

function test_breaking_changes_syntax() {
  export TEST_BRANCH="BRANCH-8"
  assert "feat!: [BRANCH-8] the msg" "$("$SCRIPT" "!the msg")" "Start message with breaking change"
  assert "feat(scope)!: [BRANCH-8] the msg" "$("$SCRIPT" "!(scope)the msg")" "Breaking change and scope"
}
