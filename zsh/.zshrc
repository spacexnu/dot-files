fpath+=~/.zfunc
autoload -Uz compinit && compinit

# starship config
export STARSHIP_CONFIG=~/code/dot-files/starship/starship.toml
eval "$(starship init zsh)"

# Enable colors on ls command
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# load fzf
source <(fzf --zsh)

# aliases
alias brewupd="brew update && brew upgrade && brew cleanup"
alias tn="tmux new-session -s "
alias tat="tmux attach -t "
alias tls="tmux ls"
alias ls="ls -G"
alias vim='nvim'
alias ls='ls --color=auto'
alias ll='ls -latr --color=auto'
alias ss='nvim $(fzf -m --preview="bat --color=always {}")'


# neofetch

# Carrega intro ao abrir shell interativo
if [[ $- == *i* ]]; then
  source ~/.cos_intro.zsh
fi

# Created by `pipx` on 2024-08-07 22:44:29
export PATH="$PATH:/Users/spacexnu/.config/emacs/bin:/Users/amedrado/.local/bin"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
