-- ===========================================================================
-- nvim-treesitter
-- ===========================================================================
-- This file configures nvim-treesitter, a plugin that provides more
-- accurate and performant syntax highlighting, indentation, and other
-- language-aware features.

-- --- nvim-treesitter ---
-- Treesitter provides more accurate and performant syntax highlighting,
-- indentation, and other language-aware features.
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
  },
  'https://github.com/nvim-treesitter/nvim-treesitter-context' -- Shows the current code context at the top of the screen.
})

---@diagnostic disable-next-line: missing-fields
-- require("nvim-treesitter.configs").setup({
--   -- To add support for more languages, run `:TSInstall <language>`
--   -- or add the language to the `ensure_installed` list below.
--   ensure_installed = {
--     'lua', 'c_sharp'
--   },
--   -- If `auto_install` is true, Treesitter will automatically install parsers
--   -- for languages when you open a file.
--   auto_install = true,
--   highlight = {
--     enable = true,
--     -- Some languages (like HTML) have issues with Treesitter highlighting,
--     -- so you can disable it for them.
--     additional_vim_regex_highlighting = false,
--   },
--   indent = {
--     -- Enable Treesitter-based indentation.
--     enable = true,
--   },
-- })


--LIKE BUILD STEP FOR OTHER PACKAGE MANAGE MANAGER
vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "*",
  callback = function(ev)
    vim.notify(ev.data.spec.name .. " has been updated.")
    if ev.data.spec.name == "nvim-treesitter"
        and ev.data.spec.kind ~= "deleted" then
      vim.cmd [[ TSUpdate ]]
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if lang then
      -- This will install the parser if it's missing
      require('nvim-treesitter').install(lang)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

    -- 1. Check if we have a parser for this language
    -- If you want to auto-install missing ones, call require('nvim-treesitter').install(lang) here
    if lang and vim.treesitter.query.get(lang, "highlights") then
      -- 2. Enable Highlighting
      vim.treesitter.start(bufnr, lang)

      -- 3. Enable Folding (Buffer-local)
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldenable = false -- Prevents everything from folding on open

      -- 4. Enable Indentation (Buffer-local)
      -- This uses the nvim-treesitter legacy indent logic
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

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
