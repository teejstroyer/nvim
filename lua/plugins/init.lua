return {
    { 'folke/neodev.nvim', config = true },
    "mbbill/undotree",
    {
        "folke/tokyonight.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
        config = function()
            --nightfox,dayfox,dawnfox,duskfox,nordfox,terafox,carbonfox,
            --vim.cmd("colorscheme nightfox")
        end,
    },
    -- search and replace in multiple files
    {
        "windwp/nvim-spectre",
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
            require("pretty_hover").setup(options)
        end
    },
    { 'lommix/godot.nvim' },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup {}
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"

            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    },
    "nvim-lualine/lualine.nvim",
}
