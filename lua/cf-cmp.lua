local cmp = require'cmp'

cmp.setup({
	completion = {
		completeopt = 'menu,menuone,noinsert',
		autocomplete = true
	},
	snippet = {
		expand = function(args)
            require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = {
		['<Cr>'] = cmp.mapping.complete(),
		['<Cr>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = { 
		{ name = 'nvim_lsp' },
		{ name = 'cmp_tabnine' },
        { name = 'luasnip' },
		{ name = 'buffer' },
	},
    experimental = {
      ghost_text = false,
    },
})
