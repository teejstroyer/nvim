-- ===========================================================================
-- Core Utilities & UI Components
-- ===========================================================================

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/hat0uma/csvview.nvim',
  'https://github.com/kevalin/mermaid.nvim',
  'https://github.com/arborist-ts/arborist.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/shorya-1012/buffer_walker.nvim',
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',
  'https://github.com/FylerOrg/fyler.nvim',
})

-- Arborist (Treesitter grammar & query manager)
require('arborist').setup()

-- Lualine (Statusline)
require('lualine').setup({
  options = { theme = "gruvbox" },
  sections = { lualine_x = { "overseer" } },
})

-- Which-Key (Keybinding hints)
local wk = require("which-key")
wk.setup()
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>f", group = "Find" },
  { "<leader>T", group = "Toggle" },
  { "<leader>t", group = "Task" },
  { "<leader>x", group = "Test" },
  { "gr",        group = "LSP Actions" },
})

-- Buffer Walker (Buffer history navigation)
vim.keymap.set("n", "<leader>[", ":MoveBack<CR>", { silent = true, desc = "Buffer move back" })
vim.keymap.set("n", "<leader>]", ":MoveForward<CR>", { silent = true, desc = "Buffer move forward" })

-- Tiny Inline Diagnostic
vim.diagnostic.config({
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN]  = "○",
      [vim.diagnostic.severity.HINT]  = "󰌶",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
})
require("tiny-inline-diagnostic").setup()

-- Fyler (File Explorer)
require("fyler").setup({
  integrations = { icon = "nvim_web_devicons" },
  views = { finder = { close_on_select = true, default_explorer = true } },
})
vim.keymap.set("n", "<leader>e", function() require('fyler').open({ kind = "split_left_most" }) end,
  { desc = "Open fyler View" })
