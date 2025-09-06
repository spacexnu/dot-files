### > ⚙️ **Note**: I'm currently experimenting with a new streamlined workflow. 
I'm simplifying my environment and reducing tool dependencies. This setup reflects an ongoing test where I'm reducing reliance on IntelliJ due to the high cost of IntelliJ IDEA Ultimate and the AI Assistant, which is expensive and not efficient. I am testing a new stack using Neovim and Visual Studio Code combined with OpenAI Codex, and also experimenting with Gemini CLI. Fish shell remains the default choice in this streamlined workflow. 

**Vim configurations are being removed and are only kept here as a glimpse of the past, since the focus moving forward will be exclusively on Neovim.**
Some configurations may be deprecated or under revision during this transition.

# Dotfiles

This repository contains my personal dotfiles for various tools and applications to create a consistent and productive development environment across different machines.

## Overview

These dotfiles include configurations for:

- **Shell environments**: Bash, Zsh, Fish
- **Text editors**: Vim, Neovim, Emacs
- **Terminal multiplexers**: Tmux
- **Terminal emulators**: iTerm2
- **IDE integrations**: IdeaVim
- **Shell prompts**: Starship

## Installation

### Prerequisites

Before installing these dotfiles, ensure you have the following dependencies installed:

- Git
- Zsh (if using Zsh configurations)
- Fish (if using Fish configurations)
- Vim/Neovim (if using Vim/Neovim configurations)
- Emacs (if using Emacs configurations)
- Tmux (if using Tmux configurations)
- iTerm2 (if on macOS and using iTerm2 configurations)
- Starship prompt

### Basic Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/spacexnu/dotfiles.git ~/.dotfiles
   ```

2. Navigate to the dotfiles directory:
   ```bash
   cd ~/.dotfiles
   ```

3. Run the installation script:
   ```bash
   ./install.sh
   ```

   The script will guide you through the installation process, allowing you to choose which configurations to install.

4. Alternatively, you can manually create symbolic links to the configuration files you want to use:
   ```bash
   # Example for Zsh
   ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc

   # Example for Vim
   ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc
   ```

## Usage

### Zsh Configuration

The Zsh configuration includes:
- Custom aliases and functions
- Improved command history
- Enhanced tab completion
- Integration with Starship prompt

### Vim/Neovim Configuration

The Vim/Neovim configuration includes:
- Custom key mappings
- Plugin management
- Syntax highlighting and code formatting

### Tmux Configuration

The Tmux configuration includes:
- Custom key bindings
- Status bar customization
- Session management

### Starship Configuration

The Starship configuration includes:
- Custom prompt styling
- Git integration
- Command execution time display

### Fish Configuration

The Fish configuration includes:
- PATH management
- Integration with Starship and zoxide
- Custom aliases
- Custom greeting (cos_intro)

## Customization

You can customize these dotfiles to suit your preferences:

1. Fork this repository
2. Make your changes
3. Update your local installation

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
