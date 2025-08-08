vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  -- To add support for more languages, run `:TSInstall <language>`
  -- or add the language to the `ensure_installed` list below.
  ensure_installed = {
    'lua', 'c_sharp'
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
