--Dependencies
vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/antoinemadec/FixCursorHold.nvim",
})

vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  --language support
  'https://github.com/rcasia/neotest-java'
})

---@diagnostic disable-next-line: missing-fields
require("neotest").setup({
  adapters = {
    require("neotest-java")(),
  },
})
