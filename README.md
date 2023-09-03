# Conventional commits

A specification for adding human and machine readable meaning to commit messages

Read the docs: https://www.conventionalcommits.org/en/v1.0.0/

## Git to the rescue!

### Why git hooks?

Git hooks are scripts or custom executables that Git allows you to run at specific points during the version control process. These hooks enable you to customize and automate various aspects of your Git workflow.

This repository is focused on the **prepare-commit-msg** client-side hook:
- This hook is invoked before the commit message editor is displayed. You can use this to modify the commit message programmatically.

### Installation

Create a symlink from the actual hook to point to the bash script.

```bash
ln -sf "git-hooks/prepare-commit-msg.sh" ".git/hooks/prepare-commit-msg"
```

### Tests

I included several unit tests to verify the expected behaviour of the hook. The tests are next to the script with the hook. You can run them all by executing the `*_test.sh`.

```bash
./git-hooks/prepare-commit-msg_test.sh
```

