local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer manages itself
  --
  use 'airblade/vim-gitgutter'            --Git gutter symbols
  use 'lilydjwg/colorizer'                --Colors hex
  use 'luochen1990/rainbow'               --Rainbow Braces
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',config=function()require('cf-treesitter')end}
  use {'folke/which-key.nvim',config=function()require('cf-whichkey')end}
  --LSP PLUGINS
  use 'OmniSharp/omnisharp-vim'           --C# LSP
  use {
      'neovim/nvim-lspconfig',
      requires = {
	'coq_nvim',
	'nvim-lspinstall'
      },
      config=function()require('cf-lsp') end
  }
  use {'glepnir/lspsaga.nvim', config=function()require('cf-lspsaga') end}              --Pretty pop ups
  use 'kosayoda/nvim-lightbulb'           --Code Action symbol
  use 'kabouzeid/nvim-lspinstall'
  use 'dart-lang/dart-vim-plugin'
  --COMPLETION
  use {'ms-jpq/coq_nvim', branch = 'coq'}
  use {'ms-jpq/coq.artifacts', branch = 'artifacts'}
end)
