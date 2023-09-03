#!/bin/bash

source "$(dirname "$0")/assert.sh"

readonly SCRIPT="$PWD/git-hooks/prepare-commit-msg.sh"

export TEST_BRANCH=""
assert "" "$("$SCRIPT" "doc: [BRANCH-666] the msg")" "Ignore all logic when using a conventional commit"

export TEST_BRANCH="main"
assert "feat: the msg" "$("$SCRIPT" "the msg")" "Use default branchKey optional"

export TEST_BRANCH="feat"
assert "feat: the msg" "$("$SCRIPT" "the msg")" "Make jiraTicket optional"

export TEST_BRANCH="BRANCH-1"
assert "feat: [BRANCH-1] the msg" "$("$SCRIPT" "the msg")" "Use feat/ when no key is used in the branch"

export TEST_BRANCH="feat/BRANCH-2"
assert "doc: [BRANCH-2] the msg" "$("$SCRIPT" "doc: the msg")" "Override key in message"
assert "feat: [BRANCH-2] the msg" "$("$SCRIPT" "the msg")" "Only commit message"
assert "feat(scope): [BRANCH-2] the msg" "$("$SCRIPT" "(scope)the msg")" "Start message with scope"

export TEST_BRANCH="doc/BRANCH-3"
assert "doc: [BRANCH-3] the msg" "$("$SCRIPT" "the msg")" "Use a custom branch key"

export TEST_BRANCH="BRANCH-4"
assert "feat: [BRANCH-4] feat the msg" "$("$SCRIPT" "feat the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-4] the msg" "$("$SCRIPT" "feat: the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-4] [INCOM-456] the msg" "$("$SCRIPT" "[INCOM-456] the msg")" "Incomplete conventional commit"
assert "feat: [BRANCH-4] doc [INCOM-456] the msg" "$("$SCRIPT" "doc [INCOM-456] the msg")" "Incomplete conventional commit"

export TEST_BRANCH="BRANCH-5"
assert "feat!: [BRANCH-5] the msg" "$("$SCRIPT" "!the msg")" "Start message with breaking change"
assert "feat(scope)!: [BRANCH-5] the msg" "$("$SCRIPT" "!(scope)the msg")" "Breaking change and scope"
