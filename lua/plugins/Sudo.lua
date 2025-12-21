return {
    "lambdalisue/vim-suda",
    event = "VeryLazy",
    config = function()
        vim.cmd [[
            command! -nargs=1 SudaEdit execute 'SudaRead' <q-args>
        ]]
    end,
}
