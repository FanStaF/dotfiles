# Dotfiles

Personal configuration files for PHP/Laravel development environment with Neovim, Zsh, and Tmux.

## What's Included

- **Neovim** - Modern Vim configuration with LSP, lazy.nvim, and custom keybindings
- **Zsh** - Shell configuration with aliases, custom prompt, and git integration
- **Tmux** - Terminal multiplexer with vim-like keybindings
- **Kitty** - Terminal emulator theme configuration
- **Git** - Configuration with useful aliases and global gitignore
- **Scripts** - Utility scripts for productivity and Laravel development

## Quick Start (New Machine)

```bash
# 1. Clone this repository
cd ~
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles

# 2. Run interactive installation (select PHP version, MySQL, etc.)
./installSoftware

# 3. Configure MySQL (if installed locally)
./scripts/bootstrap-mysql

# 4. Install dotfiles (create symlinks)
./install

# 5. Restart shell
exec zsh

# 6. Open Neovim and install plugins
nvim +Lazy
# Press 'I' to install, then :q

# 7. Verify everything works
./scripts/verify-setup
```

## Installation Guide

### Step 1: Interactive Software Installation

The `installSoftware` script provides an interactive menu to customize your setup:

```bash
./installSoftware
```

**You'll be prompted to select:**

- **PHP Version** - Choose 8.1, 8.2, 8.3, or 8.4 (beta)
- **PHP Extensions** - All recommended or minimal
- **Composer** - PHP dependency manager
- **MySQL** - Local server or Docker (recommended)
- **Redis** - Local server or Docker (recommended)
- **Docker** - Container runtime with Docker Compose
- **Node.js** - Via Volta (fast version manager)
- **Neovim** - Latest stable release
- **LazyGit** - Git TUI
- **FiraCode Nerd Font** - For icons

**Installed automatically:**
- Zsh, Tmux, Git
- FZF (fuzzy finder)
- Ripgrep (fast grep)
- Kitty (terminal emulator)
- Build tools

### Step 2: Database Setup

#### Option A: Local MySQL

If you installed MySQL locally:

```bash
./scripts/bootstrap-mysql
```

This configures:
- Root user: `root` / `password`
- Databases: `development`, `testing`
- Character set: `utf8mb4`

#### Option B: Docker MySQL

If you chose Docker MySQL:

```bash
docker compose up -d
```

This starts:
- **MySQL** on port 3306 (root/password)
- **Redis** on port 6379
- **MailHog** on ports 1025 (SMTP) and 8025 (Web UI)

View services: `docker compose ps`

### Step 3: Install Dotfiles

```bash
./install
```

Creates symlinks for:
- `~/.zshrc`, `~/.zshenv`
- `~/.tmux.conf`
- `~/.gitconfig`, `~/.gitignore_global`
- `~/.config/nvim/`
- `~/.config/kitty/`
- `~/.local/bin/` scripts (t, goL, goD, phpstorm-url-handler)

### Step 4: Configure Neovim

```bash
# Open Neovim
nvim

# Install plugins (Lazy.nvim will auto-run on first launch)
# Or manually: :Lazy

# Install LSP servers
:MasonInstall intelephense tailwindcss-language-server
```

### Step 5: Verify Installation

```bash
./scripts/verify-setup
```

This checks:
- ✅ All core tools installed
- ✅ Shell configuration
- ✅ PHP and extensions
- ✅ Database connectivity
- ✅ Neovim plugins
- ✅ Fonts

## Creating Laravel Projects

Use the included script to quickly bootstrap new Laravel projects:

```bash
./scripts/new-laravel-project my-app
```

This will:
1. Create new Laravel project via Composer
2. Configure `.env` with standard credentials (root/password, database: development)
3. Optionally install dev tools (PHPStan, Pint, Pest, IDE Helper)
4. Create database and run migrations
5. Initialize git repository
6. Create development scripts

**Quick create and start:**
```bash
./scripts/new-laravel-project my-blog ~/projects
cd ~/projects/my-blog
php artisan serve
```

## Standard Credentials

### MySQL
```
Host:     127.0.0.1
Port:     3306
Username: root
Password: password
Database: development (main) / testing (tests)
```

### Laravel .env
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=development
DB_USERNAME=root
DB_PASSWORD=password
```

Use `env.template` as reference for complete Laravel configuration.

## Directory Structure

```
dotfiles/
├── nvim/                      # Neovim configuration (Lua)
│   ├── lua/
│   │   ├── plugins/           # Plugin configurations
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── functions.lua
├── zsh/                       # Zsh configuration
│   ├── zshrc                  # Main zsh config
│   ├── zshenv                 # Environment variables
│   └── aliases                # Command aliases
├── tmux/                      # Tmux configuration
│   └── tmux.conf
├── kitty/                     # Kitty terminal config
├── git/                       # Git configuration
│   ├── gitconfig
│   └── gitignore_global
├── scripts/                   # Utility scripts
│   ├── t                      # Tmux session manager
│   ├── goL / goD              # Theme switchers
│   ├── bootstrap-mysql        # MySQL setup
│   ├── verify-setup           # Installation checker
│   ├── new-laravel-project    # Laravel project creator
│   └── phpstorm-url-handler   # PHPStorm integration
├── docker/                    # Docker configurations
│   └── mysql/init/            # MySQL init scripts
├── install                    # Dotfiles symlink script
├── installSoftware            # Interactive system setup
├── docker-compose.yml         # Development services
└── env.template               # Laravel .env template
```

## Key Features

### Neovim

- **Native LSP** with auto-completion (Intelephense for PHP)
- **Telescope** - Fuzzy finder for files, grep, git
- **Neo-tree** - File explorer with git integration
- **Git integration** - Gitsigns, Fugitive, LazyGit
- **Laravel/PHP optimized** - PHPStan integration, Pest runner
- **Custom functions** - Run tests, analyze code
- **Treesitter** - Advanced syntax highlighting
- **Auto-pairs, Surround** - Editing enhancements

**Key bindings:**
- `<leader>d` - Hover documentation
- `<leader>gd` - Go to definition
- `<leader>gr` - Find references
- `<leader>a` - Code actions
- `<leader>pa` - Run PHPStan analysis
- `<leader>ff` - Find files
- `<leader>fg` - Live grep

### Zsh

- Custom prompt with git status
- Extensive Laravel/PHP aliases
- FZF key bindings (Ctrl+R history, Ctrl+T files)
- Fast startup with Volta (not NVM)

**Common aliases:**
```bash
art              # php artisan
serve            # php artisan serve
migrate          # php artisan migrate --force
tinker           # php artisan tinker
pint             # php ./vendor/bin/pint --dirty
stan             # ./vendor/bin/phpstan (from project)
ide-helper       # Generate Laravel IDE helper files

G / GS / GC      # Git shortcuts
hg               # History grep
```

### Tmux

- Vim-like navigation (Ctrl+h/j/k/l)
- 10000 line scrollback
- Session manager script (`t`)
- Kitty terminal integration
- Mouse support

**Key bindings:**
- `Ctrl+a` - Prefix key
- `Prefix + |` - Split vertically
- `Prefix + -` - Split horizontally
- `Prefix + s` - Choose session

### Scripts

- **`t`** - Quick tmux session switcher with FZF
- **`goL` / `goD`** - Toggle light/dark themes globally
- **`new-laravel-project`** - Bootstrap Laravel projects
- **`bootstrap-mysql`** - Configure MySQL database
- **`verify-setup`** - Check installation status
- **`phpstorm-url-handler`** - Open PHPStorm URLs in Neovim

## Project-Specific Features

### PHP/Laravel

The Neovim config includes Laravel-optimized features:

- **PHPStan integration** - `<leader>pa` runs analysis with quickfix list
- **Pest test runner** - Run tests from Neovim
- **Artisan integration** - Quick access to artisan commands
- **Intelephense LSP** - Advanced PHP intellisense
  - Go to definition
  - Find references
  - Auto-imports
  - Code completion

**Required per-project:**
```bash
composer require --dev phpstan/phpstan
composer require --dev laravel/pint
composer require --dev pestphp/pest
```

### Arduino

Auto-detects Arduino projects (`.ino` files) and loads keybindings:
- `<leader>Ac` - Compile
- `<leader>Au` - Upload (OTA)
- `<leader>AU` - Upload (USB)
- `<leader>Ab` - Quick build
- `<leader>Am` - Serial monitor

Create `.arduino-fqbn` file in project root with your board identifier.

## Docker Services

Start all development services:

```bash
docker compose up -d
```

**Included services:**

| Service    | Port       | Purpose                |
|------------|------------|------------------------|
| MySQL      | 3306       | Database               |
| Redis      | 6379       | Cache/Queue            |
| MailHog    | 1025, 8025 | Email testing          |

**Optional services** (uncomment in `docker-compose.yml`):
- phpMyAdmin on port 8080
- Meilisearch on port 7700 (for Laravel Scout)

**Useful commands:**
```bash
docker compose ps              # List services
docker compose logs -f mysql   # View MySQL logs
docker compose stop            # Stop all services
docker compose down            # Stop and remove
```

## PHP Extensions Reference

**Essential (auto-installed):**
- `mysql`, `pgsql`, `sqlite3` - Database drivers
- `curl` - HTTP client
- `mbstring` - Multibyte string handling
- `xml` - XML parsing
- `zip` - Archive handling

**Recommended (auto-installed):**
- `gd` - Image manipulation
- `intl` - Internationalization
- `bcmath` - Arbitrary precision math
- `redis` - Redis PHP extension
- `soap` - SOAP protocol support
- `imagick` - Advanced image processing

**Optional:**
- `xdebug` - Debugging and profiling (dev only)

**Check installed extensions:**
```bash
php -m
```

## Switching PHP Versions

If multiple PHP versions are installed:

```bash
changephp
# Or directly:
sudo update-alternatives --config php
```

## Maintenance

### Update all software

```bash
# System packages
sudo nala upgrade

# Composer global packages
composer global update

# Node.js (via Volta)
volta install node@lts

# Neovim plugins
nvim +Lazy update
```

### Update dotfiles from repo

```bash
cd ~/dotfiles
git pull
./install  # Re-run to update symlinks if needed
```

## Troubleshooting

### Neovim LSP not working

```bash
# Check LSP status
:LspInfo

# Install missing servers
:Mason
# Press 'i' to install: intelephense, tailwindcss-language-server

# Restart LSP
:LspRestart
```

### MySQL connection failed

```bash
# Check MySQL is running
sudo systemctl status mysql

# Reset MySQL password
./scripts/bootstrap-mysql

# Test connection
mysql -uroot -ppassword
```

### Docker permission denied

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login again
```

### Fonts not displaying correctly

```bash
# Reinstall Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCodeNerdFont-Regular.ttf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
fc-cache -fv

# Set Kitty to use the font (kitty/kitty.conf)
```

## Notes

- **Primary shell is Zsh** - bashrc is kept for compatibility but not maintained
- **Uses Volta** instead of NVM for faster Node version management
- **LSP configuration** uses Neovim 0.11+ native API
- **Lazy loading** optimized for fast startup times
- **Standard credentials** - root/password for consistency across projects

## Customization

### Adding Zsh Aliases

Edit `zsh/aliases`:
```bash
alias mycommand='echo "Hello"'
```

### Adding Neovim Plugins

Create `nvim/lua/plugins/myplugin.lua`:
```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

Plugins are auto-loaded by lazy.nvim.

### Changing MySQL Credentials

Edit `scripts/bootstrap-mysql` and change the password:
```bash
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'newpassword';
```

Also update `docker-compose.yml` for Docker MySQL.

## License

MIT
