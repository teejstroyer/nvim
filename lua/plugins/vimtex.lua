-- ===========================================================================
-- VimTeX (LaTeX Support)
-- ===========================================================================
-- This file configures VimTeX, a powerful plugin for working with LaTeX
-- documents. It provides features like compilation, viewing, and snippets.

--Provides tooling needed for latex
vim.pack.add({
  "https://github.com/lervag/vimtex",
})

-- Set the default TeX file format to LaTeX.
vim.g.tex_flavor = 'latex'

-- Set the compiler to use. `latexmk` is a popular choice that automates
-- the compilation process.
vim.g.vimtex_compiler_progname = 'latexmk'

-- Set the PDF viewer to use. `skim` is a popular choice for macOS.
vim.g.vimtex_view_method = 'skim'

-- Enable forward search with Skim.
vim.g.vimtex_view_skim_sync = 1

-- Activate Skim when viewing a PDF.
vim.g.vimtex_view_skim_activate = 1

-- Enable continuous compilation. VimTeX will automatically recompile the
-- document when you save it.
vim.g.vimtex_continuous = 1

-- Automatically open the PDF viewer after compilation.
vim.g.vimtex_view_automatic = 1

-- Enable snippets for VimTeX.
vim.g.vimtex_snippets_enable_autoload = 1

-- Set the output directory for compiled files.
-- This helps to keep your project directory clean.
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }