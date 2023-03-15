local M = {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            "dimaportenko/telescope-simulators.nvim",
            "kdheepak/lazygit.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        }
    },
    --cmd = { "Telescope", "Tel" }, -- lazy loads on these commands
    --keys = { "<leader>f" }, -- lazy loads on this pattern
}

function M.config()
    local telescope = require("telescope")
    telescope.setup({
        extensions = {
            file_browser = {
                theme = "ivy",
                hijack_netrw = false,
            },
        },
    })

    telescope.load_extension("lazygit")
    telescope.load_extension("ui-select")
    telescope.load_extension("file_browser")
end

return M
