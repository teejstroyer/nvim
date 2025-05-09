vim.g.have_nerd_font = true
vim.opt.breakindent = true        --Indent wrapped lines
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false -- Set highlight on search
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.linebreak = true --Wrap lines at convenient points like spaces
vim.opt.list = true      --Shows chars like whitespace
vim.opt.mouse = 'a'      -- Enable mouse mode
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.showbreak = "↳" --Symbol for wrapped lines
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true  -- Save undo history
vim.opt.updatetime = 300 -- Decrease update time
vim.opt.wrap = true
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false
})
vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
----------------------------------------------------
-- LaTex Configuration
----------------------------------------------------
vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_continuous = 1               -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1           -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1 -- Enable snippets
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }
