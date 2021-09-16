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
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function() require('cf-treesitter') end}
  use {'folke/which-key.nvim', config = function() require('cf-whichkey') end}
  --LSP PLUGINS
  use 'OmniSharp/omnisharp-vim'           --C# LSP
  use 'neovim/nvim-lspconfig'             --LSP configuration
  use {'glepnir/lspsaga.nvim', config = function() require('cf-lspsaga') end} --Pretty pop ups
  use 'kosayoda/nvim-lightbulb'           --Code Action symbol
  use {'kabouzeid/nvim-lspinstall', config = function() require('cf-lsp') end} --LSP INSTALLER AND SETUP
  use 'dart-lang/dart-vim-plugin'
  --COMPLETION
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  -- Autocompletion plugin
  use {
      'hrsh7th/nvim-cmp',
      config = function () require('cf-cmp') end,
      requires = {
          "hrsh7th/vim-vsnip",
          "hrsh7th/cmp-buffer",
      }
  }
  use {'tzachar/cmp-tabnine', 
      run='./install.sh',
      requires = 'hrsh7th/nvim-cmp', 
      config = function() require('cf-tabnine') end;
  }
end)
