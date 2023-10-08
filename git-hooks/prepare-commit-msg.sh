#!/bin/bash

source "./git-hooks/ticket-normalizer.sh"

##################
###### MAIN ######
##################

# Useful for local testing and debugging. Usage:
# TEST=true ./git-hooks/prepare-commit-msg.sh
[ -z "$TEST" ] && TEST=false
[ -z "$DEBUG" ] && DEBUG=false

if [[ "$TEST" == true ]]; then
  ORIGINAL_MSG="${1:-"!(scope)the commit message"}"
else
  file=$1
  ORIGINAL_MSG=$(cat "$file")
fi

check_conventional_commit "$ORIGINAL_MSG"

GIT_BRANCH=${TEST_BRANCH:-"$(git rev-parse --abbrev-ref HEAD)")}
BRANCH_KEY=$(normalize_key "$GIT_BRANCH" "$ORIGINAL_MSG")
COMMIT_SCOPE=$(normalize_scope "$ORIGINAL_MSG")
JIRA_TICKET=$(normalize_ticket "$GIT_BRANCH")

UPDATED_MSG=$(render_message "$ORIGINAL_MSG" "$BRANCH_KEY" "$COMMIT_SCOPE" "$JIRA_TICKET")

render_result "$UPDATED_MSG" "$file"
