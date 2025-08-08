vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range('1.*') },
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/folke/lazydev.nvim',
})

require('lazydev').setup()
require('mason').setup()
require('mason-lspconfig').setup()

require('blink.cmp').setup({
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  sources = {

    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
    }
  },
  completion = {
    accept = {
      create_undo_point = true
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true }
})

vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })
