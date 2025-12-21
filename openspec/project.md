# Project Context

## Purpose
Personal development environment configuration repository. This project manages dotfiles, shell configurations, editor settings, and development tooling across macOS and Linux systems. The goal is to maintain a consistent, efficient, and easily reproducible development setup that can be deployed on fresh machines with minimal effort.

## Tech Stack
- **Shell**: Zsh with custom aliases and configurations
- **Editor**: Neovim with lazy.nvim plugin manager, LSP, Treesitter
- **Prompt**: Starship prompt with custom theming
- **Node.js**: Managed via NVM with Yarn and npm
- **Version Control**: Git
- **Containerization**: Docker and Docker Compose
- **Package Management**: Homebrew (macOS), apt (Linux)
- **Terminal Tools**: tmux (multiplexer)
- **Additional Tools**: Lando, VS Code CLI integration

## Project Conventions

### Code Style
- **Shell Scripts**: Use bash-compatible syntax, include OS detection for cross-platform support
- **Lua Configuration**: Follow Neovim and lazy.nvim conventions
- **File Organization**: Group related configurations in dedicated directories (.zsh/, nvim/, starship/)
- **Naming**: Use lowercase with underscores for shell files, camelCase for Lua configs
- **Comments**: Document complex logic and provide section headers with `### ---` format in shell files

### Architecture Patterns
- **Modular Configuration**: Separate concerns (aliases, options, keymaps, plugins)
- **Symlink Strategy**: Keep source files in repository, symlink to expected locations
- **Backup First**: Always backup existing configs before replacing
- **Idempotent Setup**: Setup script can be run multiple times safely
- **Cross-Platform**: Detect OS and adapt behavior accordingly (macOS vs Linux)

### Testing Strategy
- Manual testing on fresh VM/container installations
- Test setup.sh on both macOS and Linux environments
- Verify all symlinks are created correctly
- Ensure tools are accessible after installation
- Check for proper PATH configuration

### Git Workflow
- Use descriptive commit messages focusing on "why" not just "what"
- Follow conventional commit style when appropriate
- Branch workflow: main branch for stable configs
- Git aliases configured for common operations (gst, add, commit, push, pull)
- Auto-push to remote with gpsu alias

## Domain Context
This is a personal dotfiles repository focused on:
- Development productivity through keyboard-driven workflows
- Neovim as primary editor with modern LSP and Treesitter features
- Docker-based development environments
- Node.js/JavaScript/TypeScript development
- Git-centric workflow
- Terminal-first approach with Zsh, Starship, and tmux

## Important Constraints
- Must work on both macOS and Linux (Debian/Ubuntu)
- Preserve existing user configurations through backups
- Avoid destructive operations without user awareness
- Keep dependencies minimal and commonly available
- Ensure shell environment loads quickly
- Maintain compatibility with Homebrew and apt package managers

## External Dependencies
- **Homebrew**: macOS package manager
- **Starship**: Cross-shell prompt (https://starship.rs/)
- **lazy.nvim**: Neovim plugin manager
- **NVM**: Node Version Manager
- **Docker**: Container runtime
- **Yarn**: JavaScript package manager
- **Lando**: Local development environment tool
- **VS Code**: Optional editor integration via CLI
