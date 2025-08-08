vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})

local gitsigns = require('gitsigns') -- Plugin adds utilities like git blame and git signs for visual changes
local diffview = require('diffview') -- Tooling for git diffs and merges
local neogit = require('neogit')     -- A git ui for easier git in neovim

vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Git blame" })
vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "Git blame file" })
vim.keymap.set("n", "<leader>gd", diffview.open, { desc = "Git diff this" })
vim.keymap.set("n", "<leader>gt", neogit.open, { desc = "Git UI (Tab)" })
vim.keymap.set("n", "<leader>gs", function() neogit.open({ kind = "auto" }) end, { desc = "Git UI(Split)" })

-- neogit.open() -- open using defaults
-- neogit.open({ "commit" }) -- open a specific popup
-- neogit.open({ kind = "split" }) -- open as a split
-- neogit.open({ cwd = "~" }) -- open with different project
--The kind option can be one of the following values:

-- tab (default)
-- replace
-- split
-- split_above
-- split_above_all
-- split_below
-- split_below_all
-- vsplit
-- floating
-- auto (vsplit if window would have 80 cols, otherwise split)
