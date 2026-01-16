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

    if ft == "mininotify" or ft == "minipick" or ft == "minifiles" or ft == "" then
      return
    end

    if not lang then return end

    --Might need to verify this is working correctly
    if not vim.tbl_contains(ts.get_available(), lang) then
      return -- Exit silently: No Treesitter parser exists for this filetype
    end

    -- Check if parser is missing and try to install it
    local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not has_parser then
      ts.install(lang)
      return
    end


    -- Enable Folding
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'

    -- Enable Indentation
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

    --treesitter no longer starts on its own...
    vim.treesitter.start()
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
