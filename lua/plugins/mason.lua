require('mason').setup()
require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua","csharp_ls" }
}

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers({
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    ["sumneko_lua"] = function() --Per lsp config
        lspconfig.sumneko_lua.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
    end,
})
