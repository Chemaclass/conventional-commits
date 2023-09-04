#!/bin/bash

ROOT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
SCRIPT="$ROOT_DIR/git-hooks/prepare-commit-msg.sh"

function test_ignore_all_logic_when_using_a_conventional_commit() {
  export TEST_BRANCH="main"
  assertEquals "" "$($SCRIPT "doc: [BRANCH-666] the msg")"
}

function test_use_default_branchKey_feat() {
  export TEST_BRANCH="main"
  assertEquals "feat: the msg" "$($SCRIPT "the msg")"
}

function test_make_jiraTicket_optional() {
  export TEST_BRANCH="feat"
  assertEquals "feat: the msg" "$($SCRIPT "the msg")"
}

function test_avoid_duplicate_branchKey() {
  export TEST_BRANCH="BRANCH-0"
  assertEquals "feat: [BRANCH-0] the msg" "$($SCRIPT "feat: the msg")"
}

function test_use_feat_when_no_key_is_used_in_the_branch() {
  export TEST_BRANCH="BRANCH-1"
  assertEquals "feat: [BRANCH-1] the msg" "$($SCRIPT "the msg")"
}

function test_override_key_message() {
  export TEST_BRANCH="feat/BRANCH-2"
  assertEquals "doc: [BRANCH-2] the msg" "$($SCRIPT "doc: the msg")"
}

function test_only_commit_message_in_a_branch_with_key_and_ticket() {
  export TEST_BRANCH="feat/BRANCH-3"
  assertEquals "feat: [BRANCH-3] the msg" "$($SCRIPT "the msg")"
}

function test_start_message_with_scope() {
  export TEST_BRANCH="feat/BRANCH-4"
  assertEquals "feat(scope): [BRANCH-4] the msg" "$($SCRIPT "(scope)the msg")" "Scope in message (without space)"
  assertEquals "feat(scope): [BRANCH-4] the msg" "$($SCRIPT "(scope) the msg")" "Scope in message"
}

function test_use_a_custom_branch_key() {
  export TEST_BRANCH="doc/BRANCH-5"
  assertEquals "doc: [BRANCH-5] the msg" "$($SCRIPT "the msg")"
}

function test_normalize_branch_keys() {
  export TEST_BRANCH="task/BRANCH-61"
  assertEquals "feat: [BRANCH-61] the msg" "$($SCRIPT "the msg")" "Normalize task into feat"

  export TEST_BRANCH="feature/BRANCH-62"
  assertEquals "feat: [BRANCH-62] the msg" "$($SCRIPT "the msg")" "Normalize feature into feat"

  export TEST_BRANCH="story/BRANCH-63"
  assertEquals "feat: [BRANCH-63] the msg" "$($SCRIPT "the msg")" "Normalize story into feat"

  export TEST_BRANCH="bug/BRANCH-64"
  assertEquals "fix: [BRANCH-64] the msg" "$($SCRIPT "the msg")" "Normalize bug into fix"

  export TEST_BRANCH="bugfix/BRANCH-64"
  assertEquals "fix: [BRANCH-64] the msg" "$($SCRIPT "the msg")" "Normalize bugfix into fix"
}

function test_incomplete_conventional_commit() {
  export TEST_BRANCH="BRANCH-7"
  assertEquals "feat: [BRANCH-7] feat the msg" "$($SCRIPT "feat the msg")" "Missing colon after branchKey"
  assertEquals "feat: [BRANCH-7] [INCOM-456] the msg" "$($SCRIPT "[INCOM-456] the msg")" "Missing branchKey"
  assertEquals "feat: [BRANCH-7] doc [INCOM-456] the msg" "$($SCRIPT "doc [INCOM-456] the msg")" "Missing colon after branchKey with jiraTicket"
}

function test_breaking_changes_syntax() {
  export TEST_BRANCH="BRANCH-8"
  assertEquals "feat!: [BRANCH-8] the msg" "$($SCRIPT "!the msg")" "Start message with breaking change"
  assertEquals "feat(scope)!: [BRANCH-8] the msg" "$($SCRIPT "!(scope)the msg")" "Breaking change and scope"
}
