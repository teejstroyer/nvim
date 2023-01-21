local M = {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
        { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' }
    },
    cmd = { "Telescope", "Tel" }, -- lazy loads on these commands
    keys = { "<leader>f"}, -- lazy loads on this pattern
}

function M.config()
    local telescope = require("telescope")
    telescope.setup()

    local builtin = require('telescope.builtin')
    vim.keymap.set("n", "<space>f", ":Telescope<CR>", { noremap = true })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set("n", "<space>fe", ":Telescope file_browser<CR>", { noremap = true })
end

return M
