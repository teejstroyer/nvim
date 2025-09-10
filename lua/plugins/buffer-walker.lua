vim.pack.add({ 'https://github.com/shorya-1012/buffer_walker.nvim' })

vim.keymap.set("n", "<leader>[", ":MoveBack<CR>", { silent = true })
vim.keymap.set("n", "<leader>]", ":MoveForward<CR>", { silent = true })
