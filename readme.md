# Dotfiles

Personal configuration files for development environment.

## What's Included

- **Neovim** - Modern Vim configuration with LSP, lazy.nvim, and custom keybindings
- **Zsh** - Shell configuration with aliases, custom prompt, and git integration
- **Tmux** - Terminal multiplexer with vim-like keybindings
- **Kitty** - Terminal emulator theme configuration
- **Git** - Configuration with useful aliases and global gitignore
- **Scripts** - Utility scripts for productivity

## Quick Install

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
./install
```

The `install` script will:
- Create symlinks for all configuration files
- Set up scripts in `~/.local/bin`
- Configure PHPStorm URL handler for Neovim integration

## Dependencies

### Required
- **zsh** - Primary shell
- **nvim** (0.10+) - Text editor
- **tmux** - Terminal multiplexer
- **fzf** - Fuzzy finder
- **ripgrep** - Fast grep alternative
- **kitty** - Terminal emulator
- **git** - Version control

### Optional
- **volta** - Fast Node version manager (replaces NVM)
- **lazygit** - Git TUI (install via package manager)
- **xclip** - Clipboard support for tmux
- **arduino-cli** - For Arduino projects
- **docker** - For containerized development

### Fonts
- **FiraCode Nerd Font Mono** - Required for proper icon display

### Language Servers (for Neovim LSP)
Installed automatically by Mason, or manually:
```bash
npm install -g intelephense
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
```

## Directory Structure

```
dotfiles/
├── nvim/           # Neovim configuration (Lua)
│   ├── lua/
│   │   ├── plugins/  # Plugin configurations
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── functions.lua
├── zsh/            # Zsh configuration
│   ├── zshrc       # Main zsh config
│   ├── zshenv      # Environment variables
│   └── aliases     # Command aliases
├── tmux/           # Tmux configuration
│   └── tmux.conf
├── kitty/          # Kitty terminal config
├── scripts/        # Utility scripts
│   ├── t           # Tmux session manager (fzf)
│   ├── goL/goD     # Theme switchers
│   └── ...
├── install         # Installation script
└── installSoftware # Software installation script
```

## Key Features

### Neovim
- Native LSP with auto-completion
- Telescope fuzzy finder
- Neo-tree file explorer
- Git integration (gitsigns, fugitive)
- Laravel/PHP optimized with PHPStan integration
- Custom functions for Pest testing

### Zsh
- Custom prompt with git status
- Extensive Laravel/PHP aliases
- FZF key bindings
- Fast startup with Volta (not NVM)

### Tmux
- Vim-like navigation
- 10000 line scrollback
- Session manager script (`t`)
- Kitty terminal integration

### Scripts
- `t` - Quick tmux session switcher
- `goL` / `goD` - Toggle light/dark themes
- `phpstorm-url-handler` - Open PHPStorm URLs in Neovim

## Project-Specific Features

### Arduino
Auto-detects Arduino projects (`.ino` files) and loads keybindings:
- `<leader>Ac` - Compile
- `<leader>Au` - Upload (OTA)
- `<leader>AU` - Upload (USB)
- `<leader>Ab` - Quick build
- `<leader>Am` - Serial monitor

Create `.arduino-fqbn` file in project root with your board identifier.

### PHP/Laravel
Custom functions and keybindings for:
- PHPStan analysis with quickfix integration
- Pest test running (nearest test, file, suite)
- Laravel artisan shortcuts

## Notes

- **Primary shell is Zsh** - bashrc is kept for compatibility but not maintained
- **Uses Volta** instead of NVM for faster Node version management
- **LSP configuration** uses Neovim 0.11+ native API (not deprecated lspconfig)
- **Lazy loading** optimized for fast startup times

## Customization

### Adding New Aliases
Edit `zsh/aliases` for new command shortcuts.

### Adding Neovim Plugins
Create new files in `nvim/lua/plugins/` - they're auto-loaded by lazy.nvim.

### Arduino Projects
Create `scripts/kali` for Docker Kali container if needed:
```bash
#!/usr/bin/env bash
docker run -it --rm --net=host kalilinux/kali-rolling
```

## License

MIT
