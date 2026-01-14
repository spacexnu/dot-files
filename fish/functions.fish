# =============================================================================
# FISH FUNCTIONS CONFIGURATION
# =============================================================================
# This file contains all functions used in the Fish shell configuration.
# It is sourced by the main config.fish file.

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

# Create a new directory and enter it
function mkcd
    mkdir -p "$argv[1]"; and cd "$argv[1]"
end

# Extract various compressed file formats
function extract
    if test -f "$argv[1]"
        switch "$argv[1]"
            case '*.tar.bz2'
                tar xjf "$argv[1]"
            case '*.tar.gz'
                tar xzf "$argv[1]"
            case '*.bz2'
                bunzip2 "$argv[1]"
            case '*.rar'
                unrar e "$argv[1]"
            case '*.gz'
                gunzip "$argv[1]"
            case '*.tar'
                tar xf "$argv[1]"
            case '*.tbz2'
                tar xjf "$argv[1]"
            case '*.tgz'
                tar xzf "$argv[1]"
            case '*.zip'
                unzip "$argv[1]"
            case '*.Z'
                uncompress "$argv[1]"
            case '*.7z'
                7z x "$argv[1]"
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# Find a file with a pattern in name
function findfile
    find . -type f -name "*$argv[1]*"
end

# -----------------------------------------------------------------------------
# Development Functions
# -----------------------------------------------------------------------------

# Create a new git branch and switch to it
function gitbr
    git checkout -b "$argv[1]"
end

# -----------------------------------------------------------------------------
# System Functions
# -----------------------------------------------------------------------------

# Show system information
function sysinfo
    echo "OS: "(uname -s)
    echo "Kernel: "(uname -r)
    echo "Hostname: "(hostname)
    echo "Uptime: "(uptime | cut -d ',' -f1)
    echo "Shell: $SHELL"
    echo "Terminal: $TERM"
end

# -----------------------------------------------------------------------------
# Homebrew "source-first" helper commands
# -----------------------------------------------------------------------------

# Install formula from source (no bottle)
function brewi
    if test (count $argv) -eq 0
        echo "usage: brewi <formula> [extra brew args]" >&2
        return 2
    end
    brew install --build-from-source $argv
end

# Reinstall formula from source
function brewr
    if test (count $argv) -eq 0
        echo "usage: brewr <formula> [extra brew args]" >&2
        return 2
    end
    brew reinstall --build-from-source $argv
end

# Upgrade everything from source
function brewu
    brew upgrade --build-from-source $argv
end

# Upgrade only the outdated formulas, one-by-one, from source (more explicit logs)
function brewupd
    # Update metadata first
    brew update; or return $status

    # List outdated formulae (ignore casks here)
    set -l pkgs (brew outdated --formula --quiet)

    if test (count $pkgs) -eq 0
        echo "No outdated formulae."
        return 0
    end

    echo "Upgrading from source ("(count $pkgs)"): $pkgs"
    for p in $pkgs
        echo "==> brew upgrade --build-from-source $p"
        brew upgrade --build-from-source "$p"; or return $status
    end
end

# Optional: show which formulae are outdated
function brewout
    brew outdated --formula
end
