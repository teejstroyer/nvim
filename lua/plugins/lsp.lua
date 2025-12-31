-- ===========================================================================
-- LSP (Language Server Protocol) and Completion
-- ===========================================================================
-- This file configures the plugins that provide language-specific features
-- like autocompletion, go-to-definition, and diagnostics.

-- --- LSP and Completion ---
-- These plugins provide powerful features for code completion, diagnostics,
-- and other language server protocol (LSP) functionality.
--
-- - **blink.cmp**: An autocompletion plugin.
-- - **nvim-lspconfig**: A collection of configurations for different language servers.
-- - **mason.nvim**: A tool for easily installing and managing LSP servers, linters, and formatters.
-- - **mason-lspconfig.nvim**: Bridges Mason and nvim-lspconfig, making it easy to set up language servers.
-- - **none-ls.nvim**: Provides a way to use non-LSP sources (like linters or formatters) with the Neovim LSP client.
-- - **lazydev.nvim**: Integrates with blink.cmp to provide completions for Neovim's Lua API.
--
-- To install language servers (e.g., for Python, TypeScript, etc.), run:
-- :Mason<Enter>
-- This will open a window where you can manage your language servers.

vim.pack.add({

  'https://github.com/neovim/nvim-lspconfig',                                          -- The core LSP configuration plugin.
  'https://github.com/mason-org/mason.nvim',                                           -- The LSP installer.
  'https://github.com/mason-org/mason-lspconfig.nvim',                                 -- The bridge between Mason and lspconfig.
  'https://github.com/nvimtools/none-ls.nvim',                                         -- For non-LSP sources.
  'https://github.com/folke/lazydev.nvim',                                             -- For Neovim Lua API completions.
  'https://github.com/rafamadriz/friendly-snippets',                                   -- A collection of snippets for various languages.
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range('1.*') }, -- The autocompletion engine.
})


-- After adding the plugins, `require()` is used to load and configure them.
require('lazydev').setup() -- Set up lazydev.
require('mason').setup()   -- Set up Mason.
require('mason-lspconfig').setup({
  -- A list of language servers to ensure are installed.
  -- You can add any language server supported by mason-lspconfig here.
  ensure_installed = { "lua_ls" },
})

-- Configure blink.cmp, specifying the sources it should use for completion.
-- By default <c-n> => next <c-p> => previous, <c-y> accepts
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

-- This is a generic configuration for LSP capabilities. It ensures that
-- your LSP client has the necessary features enabled to interact with servers.
-- This is important for getting the most out of your language servers.
vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })
