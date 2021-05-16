local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute 'packadd packer.nvim'
end

local my = function(file) require(file) end
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua
require('packer').init({display = {auto_clean = false}})

return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer manages itself
  --
  use 'airblade/vim-gitgutter'            --Git gutter symbols
  use 'lilydjwg/colorizer'                --Colors hex
  use 'luochen1990/rainbow'               --Rainbow Braces
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'liuchengxu/vim-which-key'          --Shows mappings
  --LSP PLUGINS
  use 'OmniSharp/omnisharp-vim'           --C# LSP
  use 'neovim/nvim-lspconfig'             --LSP configuration
  use 'glepnir/lspsaga.nvim'              --Pretty auto complete UI
  use 'kosayoda/nvim-lightbulb'           --Code Action symbol
  use 'kabouzeid/nvim-lspinstall'
  use 'dart-lang/dart-vim-plugin'
  --COMPLETION
  use 'hrsh7th/nvim-compe' --Completion engine
end)
