-- ===========================================================================
-- LSP (Language Server Protocol) & DAP (Debug Adapter Protocol)
-- ===========================================================================

vim.pack.add({
  -- DAP Packages
  'https://github.com/mfussenegger/nvim-dap',
  { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
  -- LSP Packages
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/hedyhli/outline.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/antonk52/filepaths_ls.nvim',
  'https://github.com/Mathijs-Bakker/godotdev.nvim',
})

vim.pack.add({
  { src = "https://github.com/carldaws/miser.nvim" },
})

-- using mise https://mise.jdx.dev to manage entire env
require("miser").setup({
  auto_install = true, -- run `mise install` on startup
  auto_format = true,  -- format on save (registry first, LSP fallback)
  auto_lsp = true,     -- enable LSPs from mise tools
  registry = {
    ["dotnet:roslyn-language-server"] = {
      lsp = "roslyn_ls",
    },
  },
  task_runner = nil,                                       -- function(cmd_string) -> ... (default: terminal split)
  task_keymaps = { enabled = true, prefix = "<leader>m" }, -- bind <prefix><alias> for tasks with an `alias`
})

-- LSP Configurations
require("outline").setup()
vim.keymap.set('n', "gro", "<cmd>Outline<cr>", { desc = "Toggle Outline" })

require("godotdev").setup()

require('java').setup()
vim.lsp.enable('jdtls')
vim.lsp.enable('filepaths_ls')
vim.lsp.enable('dartls')

-- DAP Keymaps & UI setup
local dap = require('dap')
vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() dap.step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() dap.step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() dap.step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = 'Debug: Set Breakpoint' })
