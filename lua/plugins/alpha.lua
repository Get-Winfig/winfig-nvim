return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            lazy = true,
        },
    },
    config = function()
        local status_ok, alpha = pcall(require, "alpha")

        local dashboard = require("alpha.themes.dashboard")

        local quotes = {
            "Keep it simple.",
            "Code is like humor. When you have to explain it, it’s bad.",
            "Challenge: Try using only keyboard shortcuts today!",
            "Fact: Neovim is written in C and Lua.",
            "Tip: Use <leader>f to find files quickly!",
            "First, solve the problem. Then, write the code.",
            "Programs must be written for people to read.",
            "Hacking is not a crime, it’s an art.",
            "In Neovim we trust.",
            "Automate all the things.",
            "There’s no place like 127.0.0.1.",
            "Eat, Sleep, Code, Repeat.",
            "The best debugger is a good night’s sleep.",
            "Vim is where the heart is.",
            "Don’t comment bad code—rewrite it.",
            "It works on my machine.",
            "Refactor mercilessly.",
            "Neovim: Where productivity meets minimalism.",
            "Hack the planet.",
            "Real hackers use modal editing.",
            "Escape the ordinary, press <Esc>.",
            "Open source, open mind.",
            "The quieter you become, the more you can hear your code.",
            "Don’t fear breaking things—fear not learning.",
            "Every great idea starts with a single line of code.",
            "Plugins are the spice of Neovim.",
            "Stay curious, keep hacking.",
            "Your code is your canvas.",
            "Think twice, code once.",
            "The best way to predict the future is to invent it.",
            "Neovim: Less mouse, more power.",
            "Happy hacking!",
        }
        math.randomseed(os.time())
        local function center(str)
            local width = vim.api.nvim_get_option("columns")
            local str_width = vim.fn.strdisplaywidth(str)
            if width <= str_width then return str end
            local pad = math.floor((width - str_width) / 25)
            return string.rep(" ", pad) .. str
        end

        local function centerQuote(str)
            local width = vim.api.nvim_get_option("columns")
            local str_width = vim.fn.strdisplaywidth(str)
            if width <= str_width then return str end
            local pad = math.floor((width - str_width) / 4.25)
            return string.rep(" ", pad) .. str
        end

        local user = os.getenv("USERNAME") or os.getenv("USER") or "Coder"
        local hour = tonumber(os.date("%H"))
        local greeting = (hour < 12 and "     🌞 Good morning" or hour < 18 and "     🌤️ Good afternoon" or "     🌙 Good evening") .. ", " .. user .. "!"

        -- Customize header
        dashboard.section.header.val = {
            "                                                                                             ",
            "   ░██████                ░██            ░██       ░██ ░██               ░████ ░██           ",
            "  ░██   ░██               ░██            ░██       ░██                  ░██                  ",
            " ░██         ░███████  ░████████         ░██  ░██  ░██ ░██░████████  ░████████ ░██ ░████████ ",
            " ░██  █████ ░██    ░██    ░██    ░██████ ░██ ░████ ░██ ░██░██    ░██    ░██    ░██░██    ░██ ",
            " ░██     ██ ░█████████    ░██            ░██░██ ░██░██ ░██░██    ░██    ░██    ░██░██    ░██ ",
            "  ░██  ░███ ░██           ░██            ░████   ░████ ░██░██    ░██    ░██    ░██░██   ░███ ",
            "   ░█████░█  ░███████      ░████         ░███     ░███ ░██░██    ░██    ░██    ░██ ░█████░██ ",
            "                                                                                         ░██ ",
            "                                                                                   ░███████  ",
            centerQuote(quotes[math.random(#quotes)]),
            "                                                                                             ",
        }

        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find File", ":lua Snacks.dashboard.pick('files')<CR>"),
            dashboard.button("r", "   Recent Files", ":lua Snacks.dashboard.pick('oldfiles')<CR>"),
            dashboard.button("w", "  Find Word", ":lua Snacks.dashboard.pick('live_grep')<CR>"),
            dashboard.button("b", "  Bookmarks", ":lua Snacks.dashboard.pick('marks')<CR>"),
            dashboard.button("t", "  Themes", ":Themery<CR>"),
            dashboard.button("e", "  Config", ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})<CR>"),
            dashboard.button("u", "  Update Plugins", ":Lazy update<CR>"),
            dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
            dashboard.button("x", "  Lazy Extras", "::LazyExtras<CR>"),
            dashboard.button("k", "  Keymaps", ":WhichKey<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>")
        }
        local spinners = { "⠋", "⠼", "⠴", "⠦", "⠧" }
        dashboard.section.footer.val = {
            center(greeting),
            center(spinners[os.time() % #spinners + 1] .. " Happy Coding with Winfig-Neovim!"),
        }
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        if status_ok then
            alpha.setup(dashboard.config)
        end
    end,
}
