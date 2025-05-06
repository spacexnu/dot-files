# Git Configuration

This directory contains Git configuration files and templates to standardize Git usage across different environments.

## Files

- `.gitconfig` - Main Git configuration file with settings, aliases, and customizations
- `.gitignore_global` - Global gitignore file for ignoring common files and directories
- `commit-template.txt` - Template for standardized commit messages

## Installation

### Option 1: Symlink the files

Create symbolic links to these files from your home directory:

```bash
# Create symbolic link for .gitconfig
ln -s ~/code/dot-files/git/.gitconfig ~/.gitconfig

# Create symbolic link for global gitignore
ln -s ~/code/dot-files/git/.gitignore_global ~/.gitignore_global
```

### Option 2: Include in existing configuration

If you already have a `.gitconfig` file, you can include this configuration:

```
[include]
    path = ~/code/dot-files/git/.gitconfig

[core]
    excludesfile = ~/code/dot-files/git/.gitignore_global
```

## Features

### Useful Aliases

The configuration includes many useful aliases:

- `git st` - Short for `git status`
- `git ci` - Short for `git commit`
- `git co` - Short for `git checkout`
- `git br` - Short for `git branch`
- `git lg` - Pretty log with graph
- `git unstage` - Unstage changes
- `git discard` - Discard changes
- `git wip` - Create a "Work in Progress" commit
- `git unwip` - Undo the last WIP commit

See the full list in the `.gitconfig` file.

### Commit Template

The commit template follows the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Formatting changes
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or fixing tests
- `chore`: Maintenance tasks

### Global Gitignore

The global gitignore file ignores common files and directories that should not be committed to any repository:

- Operating system files (`.DS_Store`, `Thumbs.db`, etc.)
- IDE and editor files (`.idea/`, `.vscode/`, etc.)
- Language-specific files (`.pyc`, `node_modules/`, etc.)
- Temporary and build files

## Customization

You can customize these files to suit your preferences:

1. Fork this repository
2. Modify the configuration files
3. Update your symlinks or includes to point to your modified files