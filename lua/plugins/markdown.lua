-- ===========================================================================
-- Markview (Markdown Preview)
-- ===========================================================================
-- This file configures markview.nvim, a plugin that provides a live preview
-- of Markdown files directly within Neovim.

-- --- Markview Plugin ---
-- This plugin provides a live preview of Markdown files, which is useful for
-- writing and editing documentation.
vim.pack.add({
  "https://github.com/OXY2DEV/markview.nvim",
})

-- Load the presets for styling the preview.
local presets = require("markview.presets");

-- Configure the Markview plugin.
require("markview").setup({
  markdown = {
    -- Use presets for a consistent and attractive look.
    headings = presets.headings.arrowed,
    horizontal_rules = presets.horizontal_rules.solid,
    tables = presets.tables.rounded
  },
  preview = {
    -- The modes in which the preview will be active.
    hybrid_modes = { "n", "v" },
    -- The range of lines to edit in the preview.
    edit_range = { 1, 1 }
  },
  -- This checks for treesitter, but this causes issues if treesitter is loaded after
  -- so we disable it here.
  experimental = {
    check_rtp = false
  }
})

local tasks = require("plugins.task")

tasks.setup({
  sections = {
    todo      = { label = "Todo", check_style = "[ ]", order = 1, color = "#ff9e64" },
    doing     = { label = "In Progress", check_style = "[/]", order = 2, color = "#7aa2f7" },
    done      = { label = "Completed", check_style = "[x]", order = 3, color = "#9ece6a" },
    archive   = { label = "Archive", check_style = "[b]", style = "~~", order = 4, color = "#565f89" },
    cancelled = { label = "Cancelled", check_style = "[-]", style = "~~", order = 5, color = "#444b6a" },
    wont      = { label = "Wont Do", check_style = "[d]", style = "~~", order = 6, color = "#f7768e" },
  },
  highlights = {
    metadata = { fg = "#565f89", italic = true }
  },
  types = {
    bug  = { style = "**", color = "#f7768e" },
    feat = { style = "_", color = "#bb9af7" },
    task = { style = "", color = "#7aa2f7" }
  },
  date_format = "%Y-%m-%d",
  default_type = "TASK"
})

local kmap = vim.keymap.set
-- Task Creation
kmap('n', '<localleader>tn', function() tasks.new_task('task') end, { desc = "Task: Quick New (default type)" })
kmap('n', '<localleader>tN', function() tasks.new_task() end, { desc = "Task: New (Prompt for Type)" })
kmap({ 'n', 'v' }, '<localleader>tb', function() tasks.move_task("todo") end, { desc = "Task:Backlog" })
kmap({ 'n', 'v' }, '<localleader>tp', function() tasks.move_task("doing") end, { desc = "Task: Progress" })
kmap({ 'n', 'v' }, '<localleader>td', function() tasks.move_task("done") end, { desc = "Task:Completed" })
kmap({ 'n', 'v' }, '<localleader>ta', function() tasks.move_task("archive") end, { desc = "Task:Archive" })
kmap({ 'n', 'v' }, '<localleader>tw', function() tasks.move_task("wont") end, { desc = "Task: Wont Do" })
kmap({ 'n', 'v' }, '<localleader>tc', function() tasks.move_task("cancelled") end, { desc = "Task: Cancelled" })
