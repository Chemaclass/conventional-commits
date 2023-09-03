#!/usr/bin/env bash

set -e

function setup_git_hooks()
{
  echo "Initialising git hooks..."
  ln -sf "$PWD/git-hooks/prepare-commit-msg.sh" ".git/hooks/prepare-commit-msg"
  echo "Done"
}

setup_git_hooks
