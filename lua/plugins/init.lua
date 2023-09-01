return {
    { 'folke/neodev.nvim',     config = true },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    "mbbill/undotree",
    {
        "ellisonleao/gruvbox.nvim",
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
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }, -- optional: for multi-select
    },
    { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({})
        end
    }
}
