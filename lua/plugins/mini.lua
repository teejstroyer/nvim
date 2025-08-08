-- ===========================================================================
-- Mini.nvim
-- ===========================================================================
-- This file configures mini.nvim, a collection of minimal, fast, and
-- single-file plugins. It provides a wide range of functionality, from
-- a file explorer to a statusline.

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

-- Set up the various mini.nvim modules that you want to use.
require('mini.ai').setup()          -- Extends and improves the default `a` and `i` text objects.
require('mini.align').setup()       -- For interactive aligning
require('mini.colors').setup()      -- A minimal and fast color scheme.
-- require('mini.diff').setup()     -- A minimal and fast diff viewer.
require('mini.extra').setup()       -- Extra functionality for other mini modules.
require('mini.files').setup()       -- A minimal and fast file explorer.
require('mini.icons').setup()       -- Provides icons for other plugins.
require('mini.indentscope').setup() -- Visualizes indentation levels.
require('mini.notify').setup()      -- A minimal and fast notification manager.
require('mini.pick').setup()        -- A minimal and fast picker.
require('mini.statusline').setup()  -- A minimal and fast statusline.
require('mini.tabline').setup()     -- A minimal and fast tabline.

-- Set the default notification function to use mini.notify.
-- This will make all notifications look consistent.
vim.notify = require('mini.notify').make_notify()

-- Set up the picker UI.
local pick = require('mini.pick')
pick.setup()
-- Set the default UI select function to use the mini.pick UI.
-- This will make all selection menus look consistent.
vim.ui.select = pick.ui_select

-- --- File Explorer ---
-- mini.nvim provides a simple and effective file explorer.
-- To learn more about mini.nvim, press 'gx' over the URL below.
-- We are using mini.files, but there are many other modules available.
-- https://github.com/echasnovski/mini.nvim
vim.keymap.set("n", "<leader>e", function() require('mini.files').open() end, { desc = "Explore files" })
