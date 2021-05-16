require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      ["foo.bar"] = "Identifier", -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}
