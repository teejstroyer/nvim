local lspkind = require('lspkind')
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['J'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['K'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<S-CR>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            before = function(entry, vim_item)
                return vim_item
            end
        })
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'cmdline' },
        { name = 'luasnip' },
    },
        {
            { name = 'buffer' },
        })
})

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})
