return {
    "kdheepak/lazygit.nvim",
    event = "VeryLazy",
    dependencies = {{
        "nvim-lua/plenary.nvim",
        lazy = true
    }, {
        "akinsho/toggleterm.nvim",
        lazy = true
    }},
    config = function()
        require("mappings.Lazygit")
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "float" then
                    return 20
                end
            end,
            open_mapping = [[<c-\>]],
            direction = "float",
            float_opts = {
                border = "curved",
                winblend = 3
            },
            on_exit = function(term, job, exit_code, name)
                if term.direction == "float" then
                end
            end
        })
    end
}
