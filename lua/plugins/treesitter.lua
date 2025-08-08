-- ===========================================================================
-- nvim-treesitter
-- ===========================================================================
-- This file configures nvim-treesitter, a plugin that provides more
-- accurate and performant syntax highlighting, indentation, and other
-- language-aware features.

-- --- nvim-treesitter ---
-- Treesitter provides more accurate and performant syntax highlighting,
-- indentation, and other language-aware features.
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
  },
  'https://github.com/nvim-treesitter/nvim-treesitter-context' -- Shows the current code context at the top of the screen.
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  -- To add support for more languages, run `:TSInstall <language>`
  -- or add the language to the `ensure_installed` list below.
  ensure_installed = {
    'lua', 'c_sharp'
  },
  -- If `auto_install` is true, Treesitter will automatically install parsers
  -- for languages when you open a file.
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages (like HTML) have issues with Treesitter highlighting,
    -- so you can disable it for them.
    additional_vim_regex_highlighting = false,
  },
  indent = {
    -- Enable Treesitter-based indentation.
    enable = true,
  },
})

