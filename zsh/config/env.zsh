# =============================================================================
# ZSH ENVIRONMENT VARIABLES CONFIGURATION
# =============================================================================
# This file contains all environment variables used in the Zsh shell configuration.
# It is sourced by the main .zshrc file.

# -----------------------------------------------------------------------------
# Prompt Configuration
# -----------------------------------------------------------------------------
# Set the path to the Starship configuration file
export STARSHIP_CONFIG=~/code/dot-files/starship/starship.toml

# -----------------------------------------------------------------------------
# Terminal Colors Configuration
# -----------------------------------------------------------------------------
# Enable colorized output for ls and other commands
export CLICOLOR=1
# Define colors for different file types in ls output
export LSCOLORS=GxFxCxDxBxegedabagaced

# -----------------------------------------------------------------------------
# Path Configuration
# -----------------------------------------------------------------------------
export PATH="$PATH:/usr/local/clamav/bin:/usr/local/clamav/sbin"

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# SDKMAN configuration
export SDKMAN_DIR="$HOME/.sdkman"