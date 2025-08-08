vim.pack.add({
  'https://github.com/HakonHarnes/img-clip.nvim',
  'https://github.com/NeogitOrg/neogit',
  'https://github.com/catppuccin/nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/stevearc/oil.nvim',
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.cmd[[colorscheme catppuccin-frappe]]

if _G.FormatOnSave == nill then
  _G.FormatOnSave = true
end

-- Creates a server in the cache on boot, useful for Godot
-- https://ericlathrop.com/2024/02/configuring-neovim-s-lsp-to-work-with-godot/
local pipepath = vim.fn.stdpath('cache') .. '/server.pipe'
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

require('oil').setup()
require('plugins.lsp')
require('plugins.mini')
require('plugins.image')
require('plugins.treesitter')
require('plugins.markview')
require('plugins.dap')
require('plugins.vimtex')
------------------------------------------
------------------------------------------
require('functions')
require('autocmds')
require('keymaps')
require('options')
