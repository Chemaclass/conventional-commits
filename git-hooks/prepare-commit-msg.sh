#!/bin/bash

#
# Render the Jira Ticket from the given branch.
#
# Eg: Given branch "feat/TEAM-123-foo-bar" should return `TEAM-123`
#
function normalize_ticket() {
  local gitBranch=$1
  # shellcheck disable=SC2046
  # shellcheck disable=SC2005
  echo "$gitBranch" |
    grep -Eo '^(\w+\/)?(\w+-)?(\w+[-_])?[0-9]+' |
    grep -Eo '(\w+[-])?[0-9]+' |
    tr "[:lower:]" "[:upper:]"
}

#
# Render the branch key.
#
# Eg: Given branch "feat/TEAM-123-foo-bar" should return `feat`
#
function normalize_key() {
  local gitBranch=$1
  local commitMsg=$2

  # Check if starts with a string before ':'
  # In such a case, the sanitizedMsg overrides the actual git branch
  if [[ $commitMsg =~ ^([^:]+): ]]; then
    echo "${BASH_REMATCH[1]}"
    return
  fi

  local branchKey
  branchKey=$(echo "$gitBranch" | cut -d'/' -f1 | tr "[:upper:]" "[:lower:]")

  local original_branch
  original_branch="$(echo "$gitBranch" | tr "[:upper:]" "[:lower:]")"

  if [[ "$branchKey" == "$original_branch" ]]; then
    branchKey=$DEFAULT_BRANCH_KEY
  fi

  case "$branchKey" in
    "task" | "feature" | "story")
      branchKey="feat"
    ;;
    "bug" | "bugfix")
      branchKey="fix"
    ;;
    *)
      # Only if the branchKey is empty then use feat by default.
      # Otherwise, the key commit contains the following structural elements,
      # to communicate intent to the consumers of your library.
      # @see: https://www.conventionalcommits.org/en/v1.0.0/#summary
      if [ -z "$branchKey" ]; then
        branchKey="feat"
      fi
    ;;
  esac

  echo $branchKey
}

#
# Render the scope from commit if exists. Empty otherwise.
#
# Eg: Given a sanitizedMsg "(scope) foo bar" should return `(scope)`
#
function normalize_scope() {
  local commitMsg=$1
  echo "$commitMsg" |
    sed -n 's/^[!(]*\(([^)]*)\).*/\1/p' |
    tr "[:upper:]" "[:lower:]"
}

#
# Render the commit following the "conventional commits" pattern.
#
# @see: https://www.conventionalcommits.org/
#
function render_message() {
  local commitMsg=$1
  local branchKey=$2
  local commitScope=$3
  local jiraTicket=$4

  if [[ "$DEBUG" == true ]]; then
    echo "commitMsg = $commitMsg"
    echo "branchKey = $branchKey"
    echo "commitScope = $commitScope"
    echo "jiraTicket = $jiraTicket"
  fi

  local breakingChange="${commitMsg:0:1}"
  if [ "$breakingChange" == "!" ]; then
    commitMsg="${commitMsg:1}"
  else
    breakingChange=''
  fi

  local msgWithoutScope="${commitMsg/$commitScope}"
  local sanitizedMsg="${msgWithoutScope#*:}"
  sanitizedMsg="${sanitizedMsg#"${sanitizedMsg%%[![:space:]]*}"}"

  if [[ $jiraTicket != '' ]]; then
    echo "${branchKey}${commitScope}${breakingChange}: [$jiraTicket] $sanitizedMsg"
  else
    echo "${branchKey}${commitScope}${breakingChange}: $sanitizedMsg"
  fi
}

function check_conventional_commit() {
  local commitMsg=$1
  readonly COMMIT_MSG_REGEX="^[^:]+: \[[[:alnum:]-]+\] .+$"

  if [[ "$commitMsg" =~ $COMMIT_MSG_REGEX ]]; then
    if [[ "$DEBUG" == true ]]; then
      echo "sanitizedMsg = $sanitizedMsg"
      echo "The commit sanitizedMsg is already a conventional commit: ignoring the hook."
    fi

    exit 0;
  fi
}

##################
###### MAIN ######
##################

# Useful for local testing and debugging. Usage:
# TEST=true ./tools/git-hooks/prepare-commit-msg.sh
[ -z "$TEST" ] && TEST=false
[ -z "$DEBUG" ] && DEBUG=false

DEFAULT_BRANCH_KEY="feat"

if [[ "$TEST" == true ]]; then
  ORIGINAL_MSG="${1:-"!(scope)the commit message"}"
else
  file=$1
  ORIGINAL_MSG=$(cat "$file")
fi

check_conventional_commit "$ORIGINAL_MSG"

readonly GIT_BRANCH=${TEST_BRANCH:-"$(git rev-parse --abbrev-ref HEAD)")}
readonly BRANCH_KEY=$(normalize_key "$GIT_BRANCH" "$ORIGINAL_MSG")
readonly COMMIT_SCOPE=$(normalize_scope "$ORIGINAL_MSG")
readonly JIRA_TICKET=$(normalize_ticket "$GIT_BRANCH")

readonly UPDATED_MSG=$(render_message "$ORIGINAL_MSG" "$BRANCH_KEY" "$COMMIT_SCOPE" "$JIRA_TICKET")

if [[ "$TEST" == true ]]; then
  echo "$UPDATED_MSG"
else
  echo "$UPDATED_MSG" > "$file"
fi
