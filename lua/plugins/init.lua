return {
    { 'folke/neodev.nvim', config = true },
    "mbbill/undotree",
    {
        "ellisonleao/gruvbox.nvim",
        --"folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
    {
        "windwp/nvim-spectre", -- search and replace in multiple files
        keys = {
            {
                "<leader>/",
                function()
                    require("spectre").open()
                end,
                desc = "Replace in files (Spectre)"
            }
        }
    },
    {
        "Fildo7525/pretty_hover",
        config = function()
            require("pretty_hover").setup {}
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup {}
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = true,
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"

            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = false,
            }
        end
    },
    "nvim-lualine/lualine.nvim",
    {"ellisonleao/glow.nvim", config = true, cmd = "Glow"}
}
