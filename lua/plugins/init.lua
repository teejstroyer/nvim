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
    }
}
