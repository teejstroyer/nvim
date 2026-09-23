-- ===========================================================================
-- LSP (Language Server Protocol) & DAP (Debug Adapter Protocol)
-- ===========================================================================

vim.pack.add({
  -- DAP Packages
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/thehamsta/nvim-dap-virtual-text',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/leoluz/nvim-dap-go',

  -- LSP Packages
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/hedyhli/outline.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/antonk52/filepaths_ls.nvim',
  'https://github.com/seblyng/roslyn.nvim',
  'https://github.com/Mathijs-Bakker/godotdev.nvim',
  { src = 'https://github.com/JavaHello/spring-boot.nvim', version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0' },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-java/nvim-java',
})

-- LSP Configurations
require("outline").setup()
vim.keymap.set('n', "gro", "<cmd>Outline<cr>", { desc = "Toggle Outline" })

require("godotdev").setup()
require('lazydev').setup()
require('mason').setup({
  registries = {
    'github:Crashdummyy/mason-registry',
    'github:mason-org/mason-registry',
  }
})
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls" },
  automatic_enable = true,
})

require('java').setup()
vim.lsp.enable('jdtls')
vim.lsp.enable('filepaths_ls')
vim.lsp.enable('dartls')

-- DAP Keymaps & UI setup
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: Toggle UI' })

local dap = require('dap')
local dapui = require('dapui')

require("nvim-dap-virtual-text").setup()
require('mason-nvim-dap').setup({
  automatic_installation = true,
  handlers = {},
  ensure_installed = { 'csharp', 'java', 'delve' },
})

dapui.setup({
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
})

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

require('dap-go').setup({
  delve = {
    detached = vim.fn.has('win32') == 0,
  },
})

-- LSP Attach & Auto-Formatting
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = ev.buf,
        callback = function()
          if _G.FormatOnSave ~= false then
            vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
          end
        end,
      })
    end
  end,
})
