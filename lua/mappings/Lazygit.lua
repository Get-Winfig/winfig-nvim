local map = vim.keymap.set

map(
    "n",
    "<leader>gp",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git push", direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Push" }
)
map(
    "n",
    "<leader>gs",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git status", direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Status" }
)
map(
    "n",
    "<leader>gu",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git pull", direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Pull" }
)
map(
    "n",
    "<leader>gd",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git diff " .. vim.fn.input("File to diff: "), direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Diff File" }
)
map(
    "n",
    "<leader>gz",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git stash", direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Stash" }
)
map(
    "n",
    "<leader>ga",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git add .", direction="float", close_on_exit = true}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Add All" }
)
map(
    "n",
    "<leader>gc",
    [[:lua require('toggleterm.terminal').Terminal:new({cmd='git commit -m "' .. vim.fn.input('Commit message: ') .. '"', direction='float', close_on_exit=false}):toggle()<CR>]],
    { noremap = true, silent = true, desc = "Git Commit" }
)
map(
    "n",
    "<leader>gb",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git branch -a", direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Branch" }
)
map(
    "n",
    "<leader>gx",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git branch " .. vim.fn.input("New branch name: "), direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Create New Git Branch" }
)
map(
    "n",
    "<leader>go",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git checkout " .. vim.fn.input("Branch to checkout: "), direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Checkout Git Branch" }
)
map(
    "n",
    "<leader>gm",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git merge " .. vim.fn.input("Branch to merge: "), direction="float", close_on_exit = false}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Git Merge" }
)
map(
    "n",
    "<leader>gi",
    '<cmd>lua require("toggleterm.terminal").Terminal:new({cmd="git init", direction="float", close_on_exit = true}):toggle()<cr>',
    { noremap = true, silent = true, desc = "Initialize Git Repo" }
)

map("n", "<leader>gg", "<cmd>LazyGit<cr>", { noremap = true, silent = true, desc = "LazyGit" })
map("n", "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", { noremap = true, silent = true, desc = "LazyGit Current File" })
map("n", "<leader>gl", "<cmd>LazyGitFilter<cr>", { noremap = true, silent = true, desc = "LazyGit View Logs" })
