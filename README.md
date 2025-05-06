# Dotfiles

This repository contains my personal dotfiles for various tools and applications to create a consistent and productive development environment across different machines.

## Overview

These dotfiles include configurations for:

- **Shell environments**: Bash, Zsh
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
- Vim/Neovim (if using Vim/Neovim configurations)
- Emacs (if using Emacs configurations)
- Tmux (if using Tmux configurations)
- iTerm2 (if on macOS and using iTerm2 configurations)
- Starship prompt

### Basic Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Navigate to the dotfiles directory:
   ```bash
   cd ~/.dotfiles
   ```

3. Create symbolic links to the configuration files you want to use:
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

## Customization

You can customize these dotfiles to suit your preferences:

1. Fork this repository
2. Make your changes
3. Update your local installation

## Screenshots

[Screenshots of the configured environment will be added here]

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
