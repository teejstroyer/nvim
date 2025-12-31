-- ===========================================================================
-- nvim-treesitter
-- ===========================================================================
-- This file configures nvim-treesitter, a plugin that provides more
-- accurate and performant syntax highlighting, indentation, and other
-- language-aware features.
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
  },
  'https://github.com/nvim-treesitter/nvim-treesitter-context'
})

local ts = require('nvim-treesitter')
ts.install({ 'lua', 'c_sharp', 'vim', 'vimdoc', 'query', 'nix' })

--Auto Install and feature enable
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft)

    if not lang then return end

    -- Check if parser is missing and try to install it
    local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not has_parser then
      ts.install(lang)
      return
    end

    -- Enable Highlighting
    if vim.treesitter.query.get(lang, "highlights") then
      vim.treesitter.start(bufnr, lang)
    end

    -- Enable Folding
    vim.wo[0][0].foldmethod = "expr"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldenable = false

    -- Enable Indentation
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

--TREE SITTER UPDATE HOOK
vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "*",
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.spec.kind ~= "deleted" then
      vim.notify("Updating Treesitter Parsers...")
      vim.cmd("TSUpdate")
    end
  end,
})
