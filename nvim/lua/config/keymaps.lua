-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { noremap = false })

-- Smart resize support for tmux + Neovim

-- These are mostly no-ops unless tmux forwards the keys,
-- but defining them makes behavior explicit and predictable.

vim.keymap.set("n", "<C-w><", "<C-w><", { silent = true })
vim.keymap.set("n", "<C-w>>", "<C-w>>", { silent = true })
vim.keymap.set("n", "<C-w>+", "<C-w>+", { silent = true })
vim.keymap.set("n", "<C-w>-", "<C-w>-", { silent = true })
