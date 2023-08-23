vim.g.mapleader = " "
--vim.opt.guicursor = ""
vim.g.netrw_altv = 1
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_keepdir = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_winsize = 30
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = "~/.vim/undodir//"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { only_current_line = true }
})
