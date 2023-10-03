return {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v3.x',
  dependencies = {
    -- LSP Support
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },
    { 'hrsh7th/cmp-nvim-lsp' },
    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      event = "LspAttach",
      opts = {
        -- options
      },
    }
  },
  config = function()
    local lsp_zero = require("lsp-zero")

    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({ buffer = bufnr })
    end)

    lsp_zero.set_sign_icons({
      error = '✘',
      warn = '▲',
      hint = '⚑',
      info = '»'
    })

    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {},
      handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
          local lua_opts = lsp_zero.nvim_lua_ls()
          require('lspconfig').lua_ls.setup(lua_opts)
        end,
      }
    })

    local cmp = require('cmp')
    local cmp_action = lsp_zero.cmp_action()
    local cmp_format = lsp_zero.cmp_format()

    cmp.setup({
      formatting = cmp_format,
      mapping = {
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<C-j>'] = cmp.mapping.scroll_docs(-4),
        ['<C-k>'] = cmp.mapping.scroll_docs(4),
      }
    })

    -- (Optional) Configure lua language server for neovim
    require('lspconfig').lua_ls.setup(lsp_zero.nvim_lua_ls())

    --Fix Dart Language Server
    lsp_zero.setup_servers({ 'dartls', force = true })
  end
}
