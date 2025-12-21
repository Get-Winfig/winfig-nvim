-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

-- =========================== General Settings ===========================
g.mapleader = " "      -- Set leader key to space
g.maplocalleader = " " -- Set local leader key to space
opt.mouse = "a"        -- Enable mouse support
opt.cursorline = true  -- Highlight the current line
opt.number = true      -- Show line numbers
opt.signcolumn = "yes" -- Always show the sign column
opt.scrolloff = 10     -- Keep 10 lines above/below the cursor when scrolling
opt.showmatch = true   -- Highlight matching brackets/parentheses

-- =========================== Appearance Enhancements ===========================
opt.relativenumber = true     -- Enable relative line numbers
opt.wrap = false              -- Disable line wrapping
opt.fillchars = { eob = " " } -- Hide ~ on empty lines
opt.winblend = 10             -- Transparency for floating windows
opt.cursorlineopt = "number"  -- Highlight only the line number of the current line
opt.termguicolors = true      -- Enable 24-bit RGB color in the terminal
opt.title = true              -- Enable setting terminal title
opt.titlestring = "%F - nvim" -- Customize terminal title to show the current file

-- =========================== File Handling ===========================
opt.autoread = true                 -- Automatically reload files if changed outside of Neovim
opt.backup = false                  -- Disable file backup
opt.undofile = true                 -- Enable persistent undo
opt.swapfile = false                -- Disable swap files
opt.fileencoding = "utf-8"          -- File encoding to UTF-8
opt.fileformats = { "unix", "dos" } -- Support Unix and DOS file formats

-- =========================== Indentation and Tabs ===========================
opt.expandtab = true    -- Convert tabs to spaces
opt.tabstop = 4         -- Number of spaces for a tab
opt.softtabstop = 4     -- Number of spaces for a soft tab
opt.shiftwidth = 4      -- Number of spaces for indentation
opt.smartindent = true  -- Smart auto-indentation
opt.filetype = "indent" -- Enable filetype indent

-- =========================== Search and Command Behavior ===========================
opt.hlsearch = true                                 -- Highlight search results
opt.incsearch = true                                -- Incremental search (show as you type)
opt.ignorecase = true                               -- Ignore case in search
opt.smartcase = true                                -- Override ignorecase if search contains capital letters
opt.completeopt = { "menu", "menuone", "noselect" } -- Customize completion menu

-- =========================== Split and Window Behavior ===========================
opt.splitbelow = true    -- Horizontal splits below the current window
opt.splitright = true    -- Vertical splits to the right of the current window
opt.equalalways = true   -- Ensure windows are equal in size after splitting
opt.splitkeep = "screen" -- Keeps content in the same place when splitting
opt.scroll = 5           -- Scroll by 5 lines when scrolling up/down

-- =========================== Performance ===========================
opt.updatetime = 250   -- Faster completion (default is 4000ms)
vim.o.updatetime = 200 -- Faster diagnostic updates

-- =========================== Custom Options ===========================
opt.hidden = true               -- Allow switching buffers without saving
opt.paste = false               -- Disable paste mode
opt.mousemodel = "popup"        -- Mouse popup on right-click
opt.mousescroll = "ver:1,hor:0" -- Set mouse scroll speed
opt.list = false                -- Show some invisible characters like tabs
opt.matchtime = 2               -- Time (in tenths of a second) to highlight matching parentheses

-- =========================== Interface Enhancements ===========================
opt.wildmenu = true                       -- Enhanced command line completion
opt.wildmode = { "longest:full", "full" } -- Command-line completion settings
opt.shortmess = opt.shortmess + "c"       -- Don't show redundant messages when completing

-- =========================== Folding and Navigation ===========================
opt.foldmethod = "expr"                     -- Enable expression-based folding
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for code folding
opt.foldlevelstart = 99                     -- Start with all folds open
opt.sidescrolloff = 8                       -- Keep 8 columns to the left/right of the cursor
opt.scrolloff = 8                           -- Keep 8 lines above/below the cursor when scrolling


-- =========================== Terminal Customizations ===========================
opt.guifont = "FiraCode Nerd Font:h17" -- Set custom font for GUI clients

-- =========================== Custom Clipboard Behavior ===========================
if vim.fn.has("win32") == 1 then
    opt.clipboard = "unnamedplus" -- Use Windows clipboard
elseif vim.fn.has("mac") == 1 then
    opt.clipboard = "unnamed"     -- Use macOS clipboard
else
    opt.clipboard = "unnamedplus" -- Default to unnamedplus for Linux
end

-- =========================== Custom File Management ===========================
opt.autoread = true  -- Automatically reload files changed outside of Neovim
opt.backup = false   -- Disable file backups
opt.swapfile = false -- Disable swap files
opt.undofile = true  -- Enable undo files for persistent undo

-- =========================== Additional Customizations ===========================
opt.cursorlineopt = "number" -- Highlight only the line number
opt.inccommand = "split"     -- Show live substitution preview
opt.conceallevel = 2         -- Conceal text for certain elements (e.g., Markdown)

-- =========================== Language and Filetype Enhancements ===========================
opt.syntax = "on"   -- Enable syntax highlighting
opt.filetype = "on" -- Enable filetype detection

-- =========================== Confirmation and Misc ===========================
opt.confirm = true                                                                                                                                                                                                                                                                                                 -- Ask for confirmation before quitting with unsaved changes
opt.wildignore =
"*.o,*.a,*.swp,*.so,*.git,*.hg,*.svn,*.DS_Store,*.class,*.tmp,*.exe,*.dll,*.obj,*.pdb,*.pyc,*.pyo,*.db,*.sqlite,*.iml,*.jar,*.zip,*.tar,*.gz,*.tgz,*.rar,*.7z,*.csv,*.docx,*.xlsx,*.pptx,*.pdf,*.mkv,*.mp4,*.avi,*.mp3,*.wav,*.flac,*.iso,,*.pem,*.key,*.csr,*.crt,*.pub,*" -- Ignored during file completion and commands that require file paths
opt.spell = false                                                                                                                                                                                                                                                                                                  -- Disable spell checking

-- =========================== Additional Useful Options ===========================
opt.pumheight = 10              -- Maximum number of items in popup menu
opt.history = 1000              -- Number of commands to remember in history
opt.undolevels = 10000          -- Number of undo levels
opt.backspace = { "indent", "eol", "start" } -- Make backspace behave like most editors
opt.formatoptions = opt.formatoptions - "cro" -- Don't auto-comment new lines
opt.ruler = true                -- Show the cursor position all the time
opt.swapfile = false            -- Don't use swapfile
opt.writebackup = false         -- Don't create backup before overwriting a file
opt.shada = "!,'1000,<50,s10,h" -- Session history settings
