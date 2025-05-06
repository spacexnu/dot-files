# =============================================================================
# ZSH ALIASES CONFIGURATION
# =============================================================================
# This file contains all aliases used in the Zsh shell configuration.
# It is sourced by the main .zshrc file.

# -----------------------------------------------------------------------------
# Package Management Aliases
# -----------------------------------------------------------------------------
# Homebrew maintenance - update, upgrade, and cleanup in one command
alias brewupd="brew update && brew upgrade && brew cleanup"

# -----------------------------------------------------------------------------
# Tmux Aliases
# -----------------------------------------------------------------------------
# Create new session
alias tn="tmux new-session -s "
# Attach to existing session
alias tat="tmux attach -t "
# List sessions
alias tls="tmux ls"

# -----------------------------------------------------------------------------
# File Management Aliases
# -----------------------------------------------------------------------------
# Colorized output for ls
alias ls='ls --color=auto'
# Long listing with details
alias ll='ls -latr --color=auto'

# -----------------------------------------------------------------------------
# Editor Aliases
# -----------------------------------------------------------------------------
# Use Neovim as vim
alias vim='nvim'
# Fuzzy find and open in Neovim
alias ss='nvim $(fzf -m --preview="bat --color=always {}")'