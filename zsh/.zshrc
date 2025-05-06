# =============================================================================
# ZSH CONFIGURATION FILE
# =============================================================================
# This is the main Zsh configuration file that sources modular configuration files.

# -----------------------------------------------------------------------------
# Completion System Configuration
# -----------------------------------------------------------------------------
# Add custom completion functions directory to fpath
fpath+=~/.zfunc
# Initialize the completion system and load completion functions
autoload -Uz compinit && compinit

# -----------------------------------------------------------------------------
# Load Modular Configuration Files
# -----------------------------------------------------------------------------
# Source environment variables
source ~/code/dot-files/zsh/config/env.zsh

# Source aliases
source ~/code/dot-files/zsh/config/aliases.zsh

# Source functions
source ~/code/dot-files/zsh/config/functions.zsh

# -----------------------------------------------------------------------------
# Prompt Configuration - Starship
# -----------------------------------------------------------------------------
# Initialize Starship prompt
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Fuzzy Finder (FZF) Configuration
# -----------------------------------------------------------------------------
# Load FZF key bindings and completion for Zsh
source <(fzf --zsh)

# -----------------------------------------------------------------------------
# Shell Startup
# -----------------------------------------------------------------------------
# Load custom intro message when opening an interactive shell
if [[ $- == *i* ]]; then
  source ~/.cos_intro.zsh
fi

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# SDKMAN configuration - Must be at the end of the file
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
