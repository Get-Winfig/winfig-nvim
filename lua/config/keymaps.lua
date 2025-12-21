-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- ===========================
-- Basic Keymaps
-- ===========================
map("n", ";", ":", { noremap = true, desc = "Enter command mode" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- ===========================
-- Search and Replace
-- ===========================
map(
    "n",
    "<C-f>",
    ':let @/ = ""<CR>:let @a = ""<CR>:execute "silent! %s/" . input("Search for: ") . "/" . input("Replace with: ") . "/gc"<CR>',
    { noremap = true, silent = true, desc = "Search and replace with confirmation" }
)

map(
    "n",
    "<C-r>",
    ':let @/ = ""<CR>:execute "silent! %s/" . input("Search for: ") . "/" . input("Replace with: ") . "/g"<CR>',
    { noremap = true, silent = true, desc = "Search and replace all occurrences" }
)

map("n", "<C-F>", ":grep <C-R>=expand('<cword>')<CR><CR>", { noremap = true, desc = "Find word under cursor" })

map(
    "n",
    "<C-A-f>",
    ":vimgrep /<C-R>=expand('<cword>')<CR>/g **/*<CR>:copen<CR>",
    { noremap = true, desc = "Find word under cursor in all files" }
)

-- ===========================
-- Undo/Redo/Cut/Copy/Paste
-- ===========================
map("n", "<C-z>", ":undo<CR>", { noremap = true, desc = "Undo last action" })
map("n", "<C-y>", ":redo<CR>", { noremap = true, desc = "Redo last undone action" })
map("n", "<C-c>", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
map("n", "<C-x>", '"+d', { noremap = true, desc = "Cut selection to clipboard" })
map("n", "<C-v>", '"+p', { noremap = true, desc = "Paste from clipboard" })

-- ===========================
-- Text Manipulation
-- ===========================
map("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selected text up" })
map("n", "<C-a>", "ggVG", { desc = "Select all text in the file" })
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("n", "<C-w>l", "<cmd>set wrap!<CR>", { desc = "Toggle line wrapping" })

-- ===========================
-- Tabs
-- ===========================
map("n", "<A-Tab>", ":tabnext<CR>", { noremap = true, desc = "Switch to the next tab" })
map("n", "<A-1>", ":tabnew<CR>", { noremap = true, desc = "Open a new tab" })
map("n", "<A-q>", ":tabclose<CR>", { noremap = true, desc = "Close the current tab" })

-- ===========================
-- Panes
-- ===========================
map("n", "<A-2>", ":vsplit<CR>", { noremap = true, desc = "Open new vertical split" })
map("n", "<A-3>", ":split<CR>", { noremap = true, desc = "Open new horizontal split" })
map("n", "<S-q>", ":q<CR>", { noremap = true, desc = "Close the active pane" })

-- ===========================
-- File Management
-- ===========================
map("n", "<C-o>", ":e <C-R>=expand('%:p:h') . '/'<CR>", { noremap = true, desc = "Open file in current directory" })
map("n", "<C-s>", ":w<CR>", { noremap = true, desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { noremap = true, desc = "Quit Neovim" })
map("n", "<C-S-q>", ":q!<CR>", { noremap = true, desc = "Quit without saving" })

-- ===========================
-- Visual Mode Enhancements
-- ===========================
map("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selected text down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selected text up" })
map("v", "<C-c>", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
map("v", "<C-x>", '"+d', { noremap = true, desc = "Cut selection to clipboard" })
map("v", "<C-v>", '"+p', { noremap = true, desc = "Paste from clipboard" })

-- ===========================
-- Window and Pane Navigation
-- ===========================
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
map("n", "<C-n>", ":bn<CR>", { noremap = true, desc = "Next buffer" })
map("n", "<C-p>", ":bp<CR>", { noremap = true, desc = "Previous buffer" })

-- ===========================
-- Toggle Line Wrap
-- ===========================
map("n", "<M-z>", ":set wrap!<CR>", { noremap = true, silent = true, desc = "Toggle Line Wrap" })

-- ===========================
-- Keymap for :Themer
-- ===========================
map("n", "<leader>T", ":Themery<CR>", { noremap = true, silent = true, desc = "Color Themes Selection" })

-- ===========================
-- Tagbar Keybindings
-- ===========================
map("n", "<Leader>G", ":TagbarToggle<CR>", { noremap = true, silent = true, desc = "Toggle Tagbar" })

-- ===========================
-- Commants
-- ===========================
map("n", "<leader>/", ":Commentary<CR>", { desc = "Toggle Comment" })
