require("telescope").load_extension "file_browser"
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)


vim.api.nvim_set_keymap(
"n",
"<space>fb",
":Telescope file_browser<CR>",
{ noremap = true }
)
