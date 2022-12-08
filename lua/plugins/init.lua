local ensure_packer = function()
    local intall_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(intall_path)) > 0 then
        vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', intall_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup({ function()
    use 'wbthomason/packer.nvim' --Packer manages itself
    use 'lewis6991/impatient.nvim' --Improves startup speed
    use 'folke/which-key.nvim' --Shows keybinds
    use 'mhinz/vim-startify' --Start screen
    use 'lilydjwg/colorizer' --Colors hex
    use 'EdenEast/nightfox.nvim' --Colorscheme
    use { 'windwp/nvim-autopairs' } --Auto pair braces
    use 'onsails/lspkind.nvim' --Icons for popups
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }
    use {
        "folke/noice.nvim",
        event = "VimEnter",
        config = function()
            require("noice").setup()
        end,
        requires = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            --"rcarriga/nvim-notify",
        }
    }
    ----------------------------------------------------
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        requires = { 'nvim-treesitter/nvim-treesitter-context' }
    }
    use { 'jlcrochet/vim-razor' }
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }
    use { 'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim'
        }
    }
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
    use { 'romgrk/barbar.nvim', requires = 'kyazdani42/nvim-web-devicons' }
    use 'sindrets/winshift.nvim'
    --LSP_----------------------------------------
    use { 'neovim/nvim-lspconfig', --Preconfigured LSPs
        requires = {
            'williamboman/mason.nvim', --LSP installer
            'williamboman/mason-lspconfig.nvim', --Autoconfigure lsp
            'tjdevries/nlua.nvim' --Better Lua support
        }
    }
    use { 'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
        }
    }
    --DAP_----------------------------------------
    use { 'mfussenegger/nvim-dap' }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    --Auto install/setup packer
    if packer_bootstrap then
        require('packer').sync()
    end
end, config = {
    display = {
        open_fn = require('packer.util').float,
    }
} })


--Source Plugin Setup
require('plugins.default')
require('plugins.mason')
require('plugins.cmp')
require('plugins.dap')
