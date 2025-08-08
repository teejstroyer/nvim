vim.pack.add({
  "https://github.com/lervag/vimtex",
})

vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_continuous = 1               -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1           -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1 -- Enable snippets
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }
