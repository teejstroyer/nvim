return {
    "mbbill/undotree",
    {
        'folke/tokyonight.nvim',
        config = function()

            vim.cmd("colorscheme tokyonight")
        end
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
                "<leader>/", function()
                    require("spectre").open()
                end,
                desc = "Replace in files (Spectre)"
            }
        }
    }

}
