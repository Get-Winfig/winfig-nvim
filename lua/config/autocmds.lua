-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local cmd = vim.cmd

-- ===========================
-- Diagnostic Signs
-- ===========================

cmd([[
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

vim.o.updatetime = 200

-- ===========================
-- Highlight on Yank
-- ===========================
cmd([[
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=200}
]])

-- ===========================
-- Remove Trailing Whitespace on Save
-- ===========================
cmd([[
    autocmd BufWritePre * %s/\s\+$//e
]])

-- ===========================
-- Auto-Reload File If Changed Outside
-- ===========================
cmd([[
    autocmd FocusGained,BufEnter * checktime
]])

-- ===========================
-- Resize Splits When Window Resized
-- ===========================
cmd([[
    autocmd VimResized * wincmd =
]])

-- ===========================
-- Set Filetype for .env Files
-- ===========================
cmd([[
    autocmd BufRead,BufNewFile .env* set filetype=sh
]])

-- ===========================
-- Open Help in Vertical Split
-- ===========================
cmd([[
    autocmd FileType help wincmd L
]])

-- ===========================
-- Quick Close for Certain Filetypes
-- ===========================
cmd([[
    autocmd FileType qf,help,man,lspinfo nnoremap <buffer> q :close<CR>
]])

-- ===========================
-- Add Empty Line at End of File on Save
-- ===========================
cmd([[
    autocmd BufWritePre * normal! Go
]])

-- ===========================
-- Spell Check for Certain Filetypes
-- ===========================
cmd([[
    autocmd FileType gitcommit,markdown,text setlocal spell
]])

-- ===========================
-- Remember Last Cursor Position
-- ===========================
cmd([[
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
]])

-- ===========================
-- Disable Auto-Comment on New Line
-- ===========================
cmd([[
    autocmd FileType * setlocal formatoptions-=cro
]])
