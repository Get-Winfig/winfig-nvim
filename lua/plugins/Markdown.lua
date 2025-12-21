return {
    {
        "iamcco/markdown-preview.nvim",
        event = "VeryLazy",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }

            vim.g.mkdp_auto_open = 1
            vim.g.mkdp_highlight_line = 1
            vim.g.mkdp_open_to_the_world = 1
            vim.g.mkdp_port = 9000
            vim.g.mkdp_open_ip = 'localhost'
            vim.g.mkdp_preview_options = {
                mkit = true,
                disable_sync_scroll = false,
            }
            -- Keymap: Toggle Markdown Preview
            vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })
        end,
        ft = { "markdown" },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter',
                lazy = true,
            },
            {
                'nvim-tree/nvim-web-devicons',
                lazy = true,
            }
        },
        config = function()
            require('render-markdown').setup()
        end,
    }

}
