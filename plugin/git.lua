-- ===========================================================================
-- Git Integration (Gitsigns, Diffview, Neogit)
-- ===========================================================================

vim.pack.add({
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/lewis6991/gitsigns.nvim',
})

local gitsigns = require('gitsigns')
local diffview = require('diffview')
local neogit = require('neogit')

gitsigns.setup()

vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Git blame" })
vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "Git blame file" })
vim.keymap.set("n", "<leader>gd", diffview.open, { desc = "Git diff this" })
vim.keymap.set("n", "<leader>gt", neogit.open, { desc = "Git UI (Tab)" })
vim.keymap.set("n", "<leader>gs", function() neogit.open({ kind = "auto" }) end, { desc = "Git UI (Split)" })
