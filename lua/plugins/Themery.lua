return {
    "zaldih/themery.nvim",
    event = "VimEnter",
    dependencies = {
        {
            "catppuccin/nvim",
            lazy = false,
            priority = 1000,
            config = function()
                vim.cmd.colorscheme("catppuccin")
                require("catppuccin").setup({
                    transparent_background = false,
                    term_colors = true,
                    integrations = {
                        treesitter = true,
                        cmp = true,
                        lsp_trouble = true,
                        gitsigns = true,
                        telescope = true,
                        nvimtree = {
                            enabled = true,
                            show_root = true,
                            transparent_panel = false,
                        },
                        dashboard = true,
                        bufferline = true,
                    },
                    mocha = function(mocha)
                        return {
                            Comment = {
                                fg = mocha.overlay1,
                            },
                            Function = {
                                fg = mocha.blue,
                            },
                        }
                    end,
                })
            end
        },
        {
            "folke/tokyonight.nvim",
            lazy = true,
            config = function()
                require("tokyonight").setup({
                    style = "storm",
                    transparent = false,
                    terminal_colors = true,
                    styles = {
                        comments = {
                            italic = true,
                        },
                        keywords = {
                            italic = true,
                        },
                        functions = {
                            bold = true,
                        },
                        sidebars = "dark",
                        floats = "dark",
                    },
                    sidebars = { "qf", "vista_kind", "terminal", "packer" },
                    lualine_bold = true,
                })
            end,
        },
        {
            "navarasu/onedark.nvim",
            lazy = true,
            config = function()
                vim.cmd.colorscheme("onedark")
                require("onedark").setup({
                    style = "cool",
                    transparent = false,
                    term_colors = true,
                    code_style = {
                        comments = "italic",
                        keywords = "bold",
                        functions = "bold",
                    },
                    lualine = {
                        transparent = false,
                    }
                })
            end,
        },
        {
            "shaunsingh/nord.nvim",
            lazy = true,
            config = function()
                vim.cmd.colorscheme("nord")
            end,
        },
        {
            "Rigellute/shades-of-purple.vim",
            lazy = true,
            config = function()
                vim.cmd.colorscheme("shades_of_purple")
            end,
        }
    },
    config = function()
        require("themery").setup({
            themes = {
            { name = "Catppuccin Mocha",     colorscheme = "catppuccin", before = [[vim.opt.background = "dark"; vim.g.catppuccin_flavour = "mocha"]] },
            { name = "Catppuccin Macchiato", colorscheme = "catppuccin", before = [[vim.opt.background = "dark"; vim.g.catppuccin_flavour = "macchiato"]] },
            { name = "Catppuccin Frappe",    colorscheme = "catppuccin", before = [[vim.opt.background = "dark"; vim.g.catppuccin_flavour = "frappe"]] },
            { name = "Catppuccin Latte",     colorscheme = "catppuccin", before = [[vim.opt.background = "light"; vim.g.catppuccin_flavour = "latte"]] },
            { name = "TokyoNight",           colorscheme = "tokyonight", before = [[vim.opt.background = "dark"]] },
            { name = "TokyoLight",           colorscheme = "tokyonight", before = [[vim.opt.background = "light"]] },
            { name = "OneDark",              colorscheme = "onedark",    before = [[vim.opt.background = "dark"]] },
            { name = "OneLight",             colorscheme = "onedark",    before = [[vim.opt.background = "light"]] },
            { name = "Nord",                 colorscheme = "nord",       before = [[vim.opt.background = "dark"]] },
            { name = "Nord Light",           colorscheme = "nord",       before = [[vim.opt.background = "light"]] },
            { name = "Shades of Purple",    colorscheme = "shades_of_purple", before = [[vim.opt.background = "dark"]] },
        },
            livePreview = true,
            onColorschemeChange = function(colorscheme)
                vim.notify("Colorscheme changed to " .. colorscheme, vim.log.levels.INFO, { title = "Themery" })
            end,
        })
    end,
}
