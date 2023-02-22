return {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    name = "lsp_lines",
    enabled=true,
    config=function()
        require("lsp_lines").setup()
        vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = { only_current_line = true }
        })
    end
}
