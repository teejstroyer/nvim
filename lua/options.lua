vim.cmd([[colorscheme nightfox]])
vim.g.mapleader = " "
vim.go.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.go.completeopt = "menu,menuone,noselect"
vim.go.inccommand = 'split'
vim.go.mouse = "a" -- Enable your mouse
vim.go.splitbelow = true -- Horizontal splits will automatically be below
vim.go.splitright = true -- Vertical splits will automatically be to the right
vim.go.swapfile = false
vim.go.timeoutlen = 400 -- By default timeoutlen is 1000 ms
vim.go.title = true
vim.go.titlestring = "%<%F%=%l/%L - nvim"
vim.go.updatetime = 200 -- Faster completion
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.colorcolumn = "80"
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("c")
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
