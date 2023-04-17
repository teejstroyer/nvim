return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
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
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },
        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },
    },
    config = function()
        local lsp = require("lsp-zero")

        lsp.preset("recommended")
        lsp.set_preferences({
            suggest_lsp_servers = true,
            sign_icons = {
                error = '',
                warn = '⚠',
                hint = '',
                info = ''
            }
        })

        lsp.on_attach(function(client, bufnr)
            lsp.default_keymaps({ buffer = bufnr})
        end)

        local cmp = require('cmp')
        cmp.setup({
            sources = {
                --{ name = 'copilot' },
                { name = 'nvim_lsp' },
            },
            mapping = {
                ['<CR>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace, -- Copilot documentation says this is important.
                    select = false,
                }),
            }
        })

        -- (Optional) Configure lua language server for neovim
        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

        --Fix Dart Language Server
        lsp.setup_servers({ 'dartls', force = true })
        lsp.setup()
    end
}
