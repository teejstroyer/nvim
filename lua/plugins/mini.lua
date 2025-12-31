-- ===========================================================================
-- Mini.nvim
-- ===========================================================================
-- This file configures mini.nvim, a collection of minimal, fast, and
-- single-file plugins. It provides a wide range of functionality, from
-- a file explorer to a statusline.

vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

require('mini.ai').setup()          -- Extends and improves the default `a` and `i` text objects.
require('mini.extra').setup()       -- Extra functionality for other mini modules.
require('mini.icons').setup()       -- Provides icons for other plugins.
require('mini.indentscope').setup() -- Visualizes indentation levels.
require('mini.notify').setup()      -- A minimal and fast notification manager.
require('mini.pick').setup()        -- A minimal and fast picker.
require('mini.statusline').setup()  -- A minimal and fast statusline.
require('mini.tabline').setup()     -- A minimal and fast tabline.

vim.notify = require('mini.notify').make_notify()

-- Set up the picker UI.
local pick = require('mini.pick')
pick.setup()
vim.ui.select = pick.ui_select
