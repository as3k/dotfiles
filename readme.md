# Dotfiles & Dev Env Setup

Welcome to my personal dev setup! This repo holds my go-to configuration for shell, Neovim, and general tooling across macOS and Linux distributions. It's built for speed, clarity, and zero fuss—whether you're setting up a fresh machine, spinning up a Docker container, or just looking to streamline your workflow.

## ✨ What's Included

- **Homebrew-first approach** - Uses Homebrew as the primary package manager on all platforms for consistency
- **Zsh** with a curated set of aliases and a slick prompt via [Starship](https://starship.rs/)
- **Neovim** set up with modern essentials: LSP, Treesitter, fuzzy finder, Git tools, Dracula theme, and more
- **NVM** for managing Node.js versions
- Global **Yarn** and **npm** binaries in your `$PATH`
- **Handy CLI aliases** for Git, Docker, network checks, and general productivity
- A **cross-platform setup script** that works across macOS, Ubuntu, Debian, and Alpine Linux

## 🖥️ Supported Platforms

- **macOS** (Intel and Apple Silicon)
- **Ubuntu** (20.04+)
- **Debian** (10+)
- **Alpine Linux** (3.x) - Perfect for Docker containers

The setup script automatically detects your OS and installs the appropriate dependencies. All development tools are installed via Homebrew for a consistent experience across platforms.



## 🗂 Folder Structure

```
.shell/
├── .zshrc 
├── .zsh/
│   └── zshalias 
├── starship/
│   └── starship.toml
├── nvim/
│   ├── init.lua lazy.nvim
│   └── lazy-lock.json
└── setup.sh
```



## 🚀 Getting Started

### Standard Setup (macOS, Ubuntu, Debian)

1. **Clone the repo:**
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/.shell
   cd ~/.shell
   ```

2. **Run the setup:**
   ```sh
   bash setup.sh
   ```

   The setup script will:
   - Detect your operating system (macOS, Ubuntu, Debian, or Alpine)
   - Install Homebrew if not already present (including Linuxbrew on Linux)
   - Install development tools via Homebrew: Zsh, Git, Neovim, Node, and more
   - Set up Starship for a beautiful prompt
   - Back up your existing dotfiles and create symlinks for the new ones
   - Configure Zsh, Starship, and Neovim

3. **Reload your terminal:**
   ```sh
   source ~/.zshrc
   ```

4. **Install Neovim plugins:**
   ```sh
   nvim
   ```
   Then type `:Lazy` and hit enter to complete plugin setup.

### Minimal Alpine Setup (for iSH or resource-constrained environments)

For Alpine Linux or iSH on iOS, use the lightweight setup:

1. **Clone the repo:**
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/.shell
   cd ~/.shell
   ```

2. **Run the minimal setup:**
   ```sh
   sh setup-alpine.sh
   ```

   This minimal setup:
   - Installs only essential packages (git, zsh, neovim, curl)
   - Uses a simple built-in prompt (no Starship for better performance)
   - Includes all your aliases
   - Uses basic Neovim config (no plugins) compatible with old Neovim versions
   - Perfect for iSH on iOS or minimal containers

3. **Start using Zsh:**
   ```sh
   zsh
   ```

**Note:** Alpine 3.14.3 (used by iSH) has Neovim 0.4.4, which doesn't support lazy.nvim. The minimal setup uses a basic vimrc-style configuration with essential features but no plugins.


## 🛠 Customizing
- Aliases: Add or update .zsh/zshalias with your favorite shortcuts
- Prompt: Adjust the look and feel in starship/starship.toml
- Neovim: Modify plugins, themes, and settings in nvim/init.lua

## 🧠 Heads-Up

- **Homebrew on Linux**: The first run will install Homebrew/Linuxbrew, which may take a few minutes. Subsequent runs will be much faster.
- **Alpine Linux**: Uses native package manager (apk) instead of Homebrew for better compatibility with musl libc. Requires `shadow` package for shell changing.
- **Backups**: Your current .zshrc, Starship config, and Neovim config will be backed up before any changes are made
- **Neovim LSP**: You may need to install additional language servers depending on what you're working on
- **Docker-friendly**: Works great in Alpine-based containers for consistent dev environments
- **Shell Changes**: To avoid hanging on password prompts, the script only changes your default shell automatically when running as root. Otherwise, run `chsh -s $(which zsh)` manually if you want Zsh as your login shell.
- **Idempotent**: Safe to run multiple times - the script detects existing installations

## 🧰 Troubleshooting

If something's off:

- **Setup script fails**: Check the output for specific error messages. The script uses `set -e` to exit on first error.
- **Homebrew not in PATH on Linux**: Make sure to restart your terminal or run `source ~/.zshrc` after setup
- **Alpine prerequisites**: On minimal Alpine containers, install `git bash shadow` before running setup: `apk add --no-cache git bash shadow`
- **Permission issues**: Some operations may require sudo (Ubuntu/Debian). Alpine in containers typically runs as root.
- **Shell not changing**: If `chsh` fails, manually run `chsh -s $(which zsh)` after setup completes. On Debian/Ubuntu, you may need to add Homebrew's zsh path to `/etc/shells` first.
- Check docs for [Starship](https://starship.rs/), [Neovim](https://neovim.io/), or [lazy.nvim](https://github.com/folke/lazy.nvim)

## 🐳 Docker Usage

Perfect for creating consistent development containers:

```dockerfile
FROM alpine:latest
RUN apk add --no-cache git bash shadow
RUN git clone https://github.com/yourusername/dotfiles.git ~/.shell
WORKDIR /root/.shell
RUN bash setup.sh
CMD ["/bin/zsh"]
```

For Ubuntu/Debian containers:

```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y git sudo
RUN git clone https://github.com/yourusername/dotfiles.git ~/.shell
WORKDIR /root/.shell
RUN bash setup.sh
CMD ["/bin/zsh"]
```



### Happy hacking 👨‍💻👩‍💻