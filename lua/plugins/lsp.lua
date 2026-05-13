-- ===========================================================================
-- LSP (Language Server Protocol) and Completion
-- ===========================================================================
-- This file configures the plugins that provide language-specific features
-- like autocompletion, go-to-definition, and diagnostics.

-- --- LSP and Completion ---
-- These plugins provide powerful features for code completion, diagnostics,
-- and other language server protocol (LSP) functionality.
--
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
  'https://github.com/neovim/nvim-lspconfig',          -- The core LSP configuration plugin.
  'https://github.com/mason-org/mason.nvim',           -- The LSP installer.
  'https://github.com/mason-org/mason-lspconfig.nvim', -- The bridge between Mason and lspconfig.
  'https://github.com/nvimtools/none-ls.nvim',         -- For non-LSP sources.
  'https://github.com/folke/lazydev.nvim',             -- For Neovim Lua API completions.
  'https://github.com/rafamadriz/friendly-snippets',   -- A collection of snippets for various languages.
  'https://github.com/antonk52/filepaths_ls.nvim',     -- File system completion
  'https://github.com/seblyng/roslyn.nvim',            -- C# Roslyn lsp for faster performance
  "https://github.com/Mathijs-Bakker/godotdev.nvim",   -- Godot
})

require("lspconfig")
vim.lsp.enable('dartls') -- Manualy done, since dart is already on the machine

require("godotdev").setup()

-- After adding the plugins, `require()` is used to load and configure them.
require('lazydev').setup()
require('mason').setup({
  registries = {
    'github:Crashdummyy/mason-registry',
    'github:mason-org/mason-registry',
  }
})
require('mason-lspconfig').setup({
  -- A list of language servers to ensure are installed.
  -- You can add any language server supported by mason-lspconfig here.
  ensure_installed = { "lua_ls", "copilot" },
  automatic_enable = true,
})

vim.lsp.enable('filepaths_ls')

-- Copied from :help vim.lsp.completion.enable
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
