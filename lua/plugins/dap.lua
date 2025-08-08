-- ===========================================================================
-- DAP (Debug Adapter Protocol)
-- ===========================================================================
-- This file configures nvim-dap, which provides a standard way to communicate
-- with debuggers. It allows you to debug your code directly within Neovim.

vim.pack.add({
  -- The core DAP plugin.
  "https://github.com/mfussenegger/nvim-dap",
  -- A companion plugin that displays debug information as virtual text.
  "https://github.com/theHamsta/nvim-dap-virtual-text",
})

-- Enable the virtual text for DAP.
require("nvim-dap-virtual-text").setup()

-- Define a sign for breakpoints. The `🐞` icon will be displayed in the
-- sign column to mark the location of a breakpoint.
vim.fn.sign_define("DapBreakpoint", { text = "🐞" })