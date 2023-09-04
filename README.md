# Conventional commits

A specification for adding human and machine-readable meaning to commit messages.

Read the docs: https://www.conventionalcommits.org/

## Git to the rescue!

### Why git hooks?

Git hooks are scripts or custom executables that Git allows you to run at specific points during the version control process. These hooks enable you to customize and automate various aspects of your Git workflow.

This repository is focused on the **prepare-commit-msg** client-side hook:
- This hook is invoked before the commit message editor is displayed. You can use this to modify the commit message programmatically.

### 🏗️ Installation

Creates symlink from the actual hook to point to the bash script.

```bash
make init-hooks
# Or
./git-hooks/init.sh
```

### 💻 Development

Make sure you've installed the bash testing library.

```bash
git submodule update --init --recursive
```

#### Automated tests

I included several unit tests to verify the expected behaviour of the hook logic.

```bash
make tests
```

