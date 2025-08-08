vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
})

require("nvim-dap-virtual-text").setup()
vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
