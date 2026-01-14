if type -q starship
    starship init fish | source
end

if type -q zoxide
    eval (zoxide init fish)
end

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

fish_add_path ~/.zfunc
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path ~/.config/emacs/bin
fish_add_path ~/.local/bin
fish_add_path /usr/local/opt/mysql-client/bin
fish_add_path "/Applications/IntelliJ IDEA.app/Contents/MacOS"
fish_add_path ~/.lmstudio/bin

if type -q eza
    alias ls 'eza'
    alias ll 'eza -lah --group-directories-first --git'
else
    # ls color on BSD/macOS
    set -gx CLICOLOR 1
    alias ls 'ls -G'
    # macOS BSD ls: -l (long) -a (all) -h (human) -t (mtime) -r (reverse) -G (color)
    alias ll 'ls -lahtrG'
end

# GPG on terminal
set -gx GPG_TTY (tty)

# iTerm2 integration
test -e $HOME/.iterm2_shell_integration.fish; and source $HOME/.iterm2_shell_integration.fish

# Editor
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim

# Aliases
alias brewupd 'brew update; and brew upgrade; and brew cleanup'
alias tn 'tmux new-session -s '
alias tat 'tmux attach -t '
alias tls 'tmux ls'
# fzf + bat (if installed)
alias ss 'nvim (fzf -m --preview="bat --color=always {}")'
alias vim=nvim

# Functions
test -f ~/.config/fish/functions.fish; and source ~/.config/fish/functions.fish

# FZF integrations (if fzf is installed via homebrew and scripts are installed)
if type -q fzf
    if status is-interactive
        test -f ~/.fzf/shell/key-bindings.fish; and source ~/.fzf/shell/key-bindings.fish
        test -f ~/.fzf/shell/completion.fish;   and source ~/.fzf/shell/completion.fish
    end
end

# OrbStack
source ~/.orbstack/shell/init2.fish 2>/dev/null || true

# Greeting
functions -q fish_greeting; and functions -e fish_greeting
functions -c cos_intro fish_greeting 2>/dev/null; or source ~/.config/fish/cos_intro.fish

# Optional: vi mode
# fish_vi_key_bindings
