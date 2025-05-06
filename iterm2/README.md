# iTerm2 Configuration

This directory contains configuration files for [iTerm2](https://iterm2.com/), a terminal emulator for macOS.

## Profiles

The `profiles` directory contains JSON configuration files for different iTerm2 profiles:

- `Personal.json` - The main profile with custom settings

## Key Mappings

The Personal profile includes the following custom key mappings:

| Key Combination | Action | Description |
|-----------------|--------|-------------|
| Cmd+Left | Send Hex Code: 0x01 | Move to beginning of line (equivalent to Home) |
| Cmd+Right | Send Hex Code: 0x05 | Move to end of line (equivalent to End) |
| Alt+Left | Send Escape Sequence: b | Move one word left |
| Alt+Right | Send Escape Sequence: f | Move one word right |
| Cmd+Backspace | Send Hex Code: 0x15 | Delete to beginning of line |
| Alt+Backspace | Send Hex Code: 0x17 | Delete one word backward |
| Cmd+K | Send Hex Code: 0x0C | Clear screen (equivalent to clear command) |
| Cmd+T | New Tab | Open a new tab |
| Cmd+N | New Window | Open a new window |
| Cmd+D | Split Vertically | Split the current pane vertically |
| Cmd+Shift+D | Split Horizontally | Split the current pane horizontally |

## Color Schemes

### Default Color Scheme

The Personal profile uses a custom color scheme with the following colors:

- **Background**: Dark gray (#1E1E1E)
- **Foreground**: Light gray (#CCCCCC)
- **Bold Text**: White (#FFFFFF)
- **Selection**: Blue (#264F78)
- **Cursor**: White (#FFFFFF)

### Alternative Color Schemes

Additional color schemes can be imported into iTerm2:

1. **Nord** - An arctic, bluish color palette
   - Compatible with the Nord Starship theme
   - Download from: https://github.com/arcticicestudio/nord-iterm2

2. **Catppuccin** - Soothing pastel theme
   - Compatible with the default Starship theme
   - Download from: https://github.com/catppuccin/iterm

3. **Gruvbox** - Retro groove color scheme
   - Download from: https://github.com/morhetz/gruvbox-contrib/tree/master/iterm2

## How to Import Profiles

1. Open iTerm2
2. Go to `iTerm2 > Preferences > Profiles`
3. Click on the `Other Actions` button at the bottom
4. Select `Import JSON Profiles...`
5. Navigate to the profile JSON file and select it

## How to Import Color Schemes

1. Download the color scheme (usually a `.itermcolors` file)
2. Open iTerm2
3. Go to `iTerm2 > Preferences > Profiles > Colors`
4. Click on `Color Presets...` dropdown
5. Select `Import...`
6. Navigate to the downloaded `.itermcolors` file and select it
7. The color scheme will now be available in the `Color Presets...` dropdown