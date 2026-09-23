-- ===========================================================================
-- Leader Keys (Must be set before any keymaps/plugins)
-- ===========================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.launch_cwd = vim.fn.getcwd()
vim.o.autoread = true
vim.opt.autochdir = false

-- ===========================================================================
-- UI & Core Options
-- ===========================================================================
vim.g.have_nerd_font = true
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.inccommand = 'split'
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.scrolloffpad = 1
vim.opt.shiftwidth = 2
vim.opt.showbreak = "↳"
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"

-- Global format on save flag
_G.FormatOnSave = true

-- Disabled Providers (Speed up startup)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- UI2 (Experimental Nvim core UI)
pcall(function() require('vim._core.ui2').enable({}) end)

-- Godot Cache Server Pipe
local pipepath = vim.fn.stdpath('cache') .. '/server.pipe'
if not vim.uv.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

-- Colorscheme
vim.cmd [[colorscheme retrobox]]
