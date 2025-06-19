# Set path 
set -U fish_user_paths ~/.zfunc $fish_user_paths
set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
set -U fish_user_paths /opt/homebrew/sbin $fish_user_paths
set -U fish_user_paths /Users/spacexnu/.config/emacs/bin $fish_user_paths
set -U fish_user_paths /Users/spacexnu/.local/bin $fish_user_paths
set -U fish_user_paths /usr/local/opt/mysql-client/bin $fish_user_paths
set -U fish_user_paths '/Applications/IntelliJ IDEA.app/Contents/MacOS' $fish_user_paths

set -gx GPG_TTY (tty)

# Enable colors on ls command
set -x CLICOLOR 1
set -x LSCOLORS GxFxCxDxBxegedabagaced

# Check and load fzf if it is available and compatible
if type -q fzf && fzf --version >/dev/null 2>&1
    if status is-interactive
        if test -f ~/.fzf/shell/key-bindings.fish
            source ~/.fzf/shell/key-bindings.fish
        end
        if test -f ~/.fzf/shell/completion.fish
            source ~/.fzf/shell/completion.fish
        end
    end
end

# Aliases
alias brewupd "brew update; and brew upgrade; and brew cleanup"
alias tn "tmux new-session -s "
alias tat "tmux attach -t "
alias tls "tmux ls"
alias ls "ls -G"
alias vim nvim
alias ll "ls -latr --color=auto"
alias ss "nvim (fzf -m --preview='bat --color=always {}')"

test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

set -gx EDITOR nvim
set -gx GIT_EDITOR nvim

# cat ~/.config/fish/cos_intro.txt
source ~/.config/fish/cos_intro.fish

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/spacexnu/.lmstudio/bin
