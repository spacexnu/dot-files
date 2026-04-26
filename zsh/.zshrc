# =============================================================================
# ZSH CONFIGURATION FILE
# =============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export GPG_TTY=$(tty)

# =============================================================================
# Homebrew always compile (macOS only)
# =============================================================================
if [[ "$(uname -s)" == "Darwin" ]]; then
  export HOMEBREW_BUILD_FROM_SOURCE=1
fi

# -----------------------------------------------------------------------------
# Completion System Configuration
# -----------------------------------------------------------------------------
fpath+=~/.zfunc
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"

# -----------------------------------------------------------------------------
# Load Modular Configuration Files
# -----------------------------------------------------------------------------
[[ -f ~/projects/dot-files/zsh/config/env.zsh ]] && source ~/projects/dot-files/zsh/config/env.zsh
[[ -f ~/projects/dot-files/zsh/config/aliases.zsh ]] && source ~/projects/dot-files/zsh/config/aliases.zsh
[[ -f ~/projects/dot-files/zsh/config/functions.zsh ]] && source ~/projects/dot-files/zsh/config/functions.zsh

# -----------------------------------------------------------------------------
# History Configuration
# -----------------------------------------------------------------------------
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

# -----------------------------------------------------------------------------
# Fuzzy Finder (FZF) Configuration
# -----------------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  fzf_base_dirs=(
    "${HOMEBREW_PREFIX:-}/opt/fzf/shell"
    "${HOMEBREW_PREFIX:-}/share/fzf/shell"
    "/opt/homebrew/opt/fzf/shell"
    "/usr/local/opt/fzf/shell"
    "/home/linuxbrew/.linuxbrew/opt/fzf/shell"
    "/usr/share/fzf"
    "/usr/share/doc/fzf/examples"
    "$HOME/.fzf/shell"
  )

  for fzf_base_dir in "${fzf_base_dirs[@]}"; do
    [[ -f "$fzf_base_dir/completion.zsh" ]] && source "$fzf_base_dir/completion.zsh"
    [[ -f "$fzf_base_dir/key-bindings.zsh" ]] && source "$fzf_base_dir/key-bindings.zsh" && break
  done

  unset fzf_base_dir fzf_base_dirs
fi

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"


# -----------------------------------------------------------------------------
# Prompt Configuration - Starship
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Pyenv
# -----------------------------------------------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# -----------------------------------------------------------------------------
# Shell Startup
# -----------------------------------------------------------------------------
[[ $- == *i* && -f ~/.cos_intro.zsh ]] && source ~/.cos_intro.zsh

# Created by `pipx` on 2026-04-25 19:46:18
export PATH="$PATH:/home/spacexnu/.local/bin"
