return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require('copilot').setup({
            panel = { -- Window split with completion options
                enabled = false,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>"
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 50,
                keymap = {
                    accept = "<C-CR>",
                    accept_word = "<S-Space>",
                    accept_line = "<S-CR>",
                    next = "<C-j>",
                    prev = "<C-k>",
                    dismiss = "<C-.>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node', -- Node.js version must be > 16.x
            server_opts_overrides = {},
        })
    end,
}


