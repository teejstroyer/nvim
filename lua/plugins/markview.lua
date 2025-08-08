-- ===========================================================================
-- Markview (Markdown Preview)
-- ===========================================================================
-- This file configures markview.nvim, a plugin that provides a live preview
-- of Markdown files directly within Neovim.

-- --- Markview Plugin ---
-- This plugin provides a live preview of Markdown files, which is useful for
-- writing and editing documentation.
vim.pack.add({ "https://github.com/OXY2DEV/markview.nvim" })

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