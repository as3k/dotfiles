Sure! Here’s your fully formatted README.md in Markdown, ready to paste into your repo:

# Dotfiles & Dev Environment Setup

Welcome to my personal dev setup! This repo holds my go-to configuration for shell, Neovim, and general tooling across macOS and Linux. It’s built for speed, clarity, and zero fuss—whether you’re setting up a fresh machine or just looking to streamline your workflow.

---

## ✨ What’s Included

- **Zsh** with a curated set of aliases and a slick prompt via [Starship](https://starship.rs/)
- **Neovim** set up with modern essentials: LSP, Treesitter, fuzzy finder, Git tools, Dracula theme, and more
- **NVM** for managing Node.js versions
- Global **Yarn** and **npm** binaries in your `$PATH`
- **Handy CLI aliases** for Git, Docker, network checks, and general productivity
- A **cross-platform setup script** that works on both macOS and Linux

---

## 🗂 Folder Structure

.shell/
├── .zshrc                # Main Zsh config — sources aliases, sets up Starship, NVM, etc.
├── .zsh/
│   └── zshalias          # All your custom aliases in one place
├── starship/
│   └── starship.toml     # Prompt styling and behavior config
├── nvim/
│   ├── init.lua          # Neovim settings and plugin setup via lazy.nvim
│   └── lazy-lock.json    # Plugin versions lockfile
└── setup.sh              # One-step setup script

---

## 🚀 Getting Started

1. **Clone the repo:**
   ```sh
   git clone https://github.com/yourusername/dotfiles.git ~/.shell
   cd ~/.shell

	2.	Run the setup:

bash setup.sh

This will:
	•	Install Zsh, Git, Neovim, Node, and more
	•	Set up Starship for a better prompt
	•	Back up your existing dotfiles and create symlinks for the new ones

	3.	Reload your terminal config:

source ~/.zshrc


	4.	Fire up Neovim and install plugins:

nvim

Then type :Lazy and hit enter to complete plugin setup.

⸻

🛠 Customizing
	•	Aliases: Add or update .zsh/zshalias with your favorite shortcuts
	•	Prompt: Adjust the look and feel in starship/starship.toml
	•	Neovim: Modify plugins, themes, and settings in nvim/init.lua

⸻

🧠 Heads-Up
	•	Your current .zshrc and Starship config will be backed up before any changes are made
	•	Neovim may need a few extra language servers or tools depending on what you’re working on
	•	Docker users: useful aliases are already built in

⸻

🧰 Troubleshooting

If something’s off:
	•	Start by reading the output from setup.sh for clues
	•	Check docs for Starship, Neovim, or lazy.nvim
	•	Or just comment things out and go step by step—because hey, dotfiles are meant to be hacked

⸻

Happy hacking 👨‍💻👩‍💻

Let me know if you want a version with badges (e.g. Shellcheck, Neovim versions, etc.) or GitHub Actions setup too!