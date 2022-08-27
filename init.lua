--***************************************************************
--***************************************************************
--* Table of Contents *******************************************
--* Neovim single file configuration ****************************
--* KEYBINDINGS *************************************************
--* PLUGINS *****************************************************
--* PLUGIN_SETUP ************************************************
--* SETTINGS ****************************************************
--* LSP_ ********************************************************
--* CMP *********************************************************
--***************************************************************
--***************************************************************
-- Windows > Treesitter needs gcc so run the following command 
-- choco install mingw as admin should work
-----------------------------------------------------------------
-- PLUGINS ------------------------------------------------------
-----------------------------------------------------------------
local o = vim.o -- global option
local wo = vim.wo -- window option
local bo = vim.bo -- buffer option
local fn = vim.fn
local opt = vim.opt
local cmd = vim.api.nvim_command

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

require('packer').startup({ function()
	use 'wbthomason/packer.nvim' --Packer manages itself
	----------------------------------------------------
	use 'lewis6991/impatient.nvim' --Improves startup speed
	----------------------------------------------------
	use 'folke/which-key.nvim'
	use "b0o/mapx.nvim" --Functions for setting mappings
	use 'mhinz/vim-startify' --Start screen
	use 'lilydjwg/colorizer' --Colors hex
	use 'ellisonleao/gruvbox.nvim' --Colorscheme
	use 'windwp/nvim-autopairs'
	use 'kyazdani42/nvim-web-devicons'
	use 'rcarriga/nvim-notify' -- Pretty Notification UI
	use 'onsails/lspkind.nvim'
	----------------------------------------------------
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/nvim-treesitter-context'
	use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true }, }
	use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
	use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', }
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim', }
	use { 'romgrk/barbar.nvim', requires = { 'kyazdani42/nvim-web-devicons' } }
	use 'toppair/reach.nvim'
	use 'https://gitlab.com/yorickpeterse/nvim-window.git'
	use 'sindrets/winshift.nvim'
	use 'nvim-telescope/telescope-ui-select.nvim'
	-- LSP_ ----------------------------------------
	use 'tjdevries/nlua.nvim' --Improved neovim lua completion
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	--
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-copilot'
	use 'hrsh7th/nvim-cmp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'
	use {"github/copilot.vim"}

	--Auto install/setup packer
	if packer_bootstrap then require('packer').sync() end
end,
	config = {
		display = {
			open_fn = require('packer.util').float,
		}
	} })

-----------------------------------------------------------------
-- PLUGIN_SETUP --------------------------------------------------------
-----------------------------------------------------------------
require('impatient').enable_profile()

local status, nw = pcall(require, 'nvim-window')
if status then
	nw.setup {}
end

vim.notify = require("notify")
require('reach').setup({ notifications = true })
require('gitsigns').setup({})
require('nvim-tree').setup({})
require('lualine').setup({ options = { theme = 'gruvbox' } })
require('mapx').setup({ global = true, whichkey = true })
require("which-key").setup({})
require('nvim-treesitter.configs').setup({
	ensure_installed = { "c", "lua", "rust", "c_sharp" },
	sync_install = false,
	highlight = {
		enable = true, -- `false` will disable the whole extension
	}
})
-- This is your opts table
require("telescope").setup {
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				-- even more opts
			}
		}
	}
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

------------------------------------------------------------------
-- SETTINGS ------------------------------------------------------
------------------------------------------------------------------
vim.cmd([[colorscheme gruvbox]])
--
o.clipboard = "unnamedplus" -- Copy paste between vim and everything else
o.completeopt="menu,menuone,noselect"
o.inccommand='split'
o.mouse = "a" -- Enable your mouse
o.shortmess = o.shortmess.."c"
o.splitbelow = true -- Horizontal splits will automatically be below
o.splitright = true -- Vertical splits will automatically be to the right
o.swapfile = false
o.timeoutlen = 400 -- By default timeoutlen is 1000 ms
o.title = true
o.titlestring = "%<%F%=%l/%L - nvim"
o.updatetime = 200 -- Faster completion
opt.hlsearch=true
opt.iskeyword:append("-")
opt.showmatch = true
opt.termguicolors =true
opt.shiftwidth=2
opt.softtabstop=2
opt.tabstop=2
opt.expandtab=true
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
wo.wrap = false
--vim.cmd('set iskeyword+=-') -- Treat dash separated words as a word text object"
--vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
------------------------------------------------------------------
-- LSP_ -----------------------------------------------------------
------------------------------------------------------------------
local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")

lsp_installer.setup { automatic_installation = true }

local pid = vim.fn.getpid()

for _, server in ipairs(lsp_installer.get_installed_servers()) do
	lspconfig[server.name].setup {}
end

--lspconfig.omnisharp.setup { use_mono = true }

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	underline = true,
	update_in_insert = true,
	float = { border = 'rounded', source = 'always', header = '', prefix = '' }
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.api.nvim_create_autocmd("CursorHold", {
	buffer = bufnr,
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = 'rounded',
			source = 'always',
			prefix = ' ',
			scope = 'cursor',
		}
		vim.diagnostic.open_float(nil, opts)
	end
})

------------------------------------------------------------------
-- CMP -----------------------------------------------------------
------------------------------------------------------------------
local lspkind = require('lspkind')
local cmp = require('cmp')
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		['J'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['K'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<S-CR>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = 'symbol', -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			before = function(entry, vim_item)
				return vim_item
			end
		})
	},
	sources = cmp.config.sources({
		{ name = 'copilot', },
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'cmdline' },
		{ name = 'luasnip' },
	},
	{
		{ name = 'buffer' },
	})
})

require 'cmp'.setup.cmdline(':', {
	sources = {
		{ name = 'cmdline' }
	}
})

require 'cmp'.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' }
	}
})

------------------------------------------------------------------
-- KEYBINDINGS ---------------------------------------------------
------------------------------------------------------------------
vim.cmd([[let mapleader ="\<Space>"]])
nnoremap("<Space>","<NOP>")
inoremap("<S-Tab>",[[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], "silent", "expr")
inoremap("<Tab>",  [[pumvisible() ? "\<C-n>" : "\<Tab>"]], "silent", "expr")
------------------------------------------------------------------
nnoremap('<leader><leader>', ':WhichKey<CR>', 'silent')
nnoremap('<leader>rj',':resize -2<CR>', 'silent')
nnoremap('<leader>rk',':resize +2<CR>', 'silent')
nnoremap('<leader>rh',':vertical resize +2<CR>', 'silent')
nnoremap('<leader>rl',':vertical resize -2<CR>', 'silent')
nnoremap('<leader>j', '<C-W>j', 'silent')
nnoremap('<leader>k', '<C-W>k', 'silent')
nnoremap('<leader>h', '<C-W>h', 'silent')
nnoremap('<leader>l', '<C-W>l', 'silent')
------------------------------------------------------------------
--Window
nnoremap('<c-h>', ':tabprevious<CR>')
nnoremap('<c-l>', ':tabnext<CR>')
nnoremap('<leader>b',  ':tabnew<CR>')
nnoremap('<leader>sh', ':sp<CR>')
nnoremap('<leader>sv', ':vs<CR>')
nnoremap('<leader>w',  ":lua require('nvim-window').pick()<CR>")
nnoremap('<leader>ws', '<Cmd>WinShift<CR>')
--NvimTree
nnoremap('<leader>e',  ':NvimTreeToggle<CR>')
nnoremap('<leader>er', ':NvimTreeRefresh<CR>')
nnoremap('<leader>ef', ':NvimTreeFindFile<CR>')
--Telescope
nnoremap('<leader>t',  '<cmd>Telescope<CR>')
nnoremap('<leader>tb', '<cmd>Telescope buffers<CR>')
nnoremap('<leader>tf', '<cmd>Telescope find_files<CR>')
nnoremap('<leader>tg', '<cmd>Telescope live_grep<CR>')
nnoremap('<leader>th', '<cmd>Telescope help_tags<CR>')
nnoremap('<leader>td', '<cmd>Telescope diagnostics<CR>')
--LSP
nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
nnoremap('<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
nnoremap('<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nnoremap('<leader>gdc','<cmd>lua vim.lsp.buf.declaration()<CR>')
nnoremap('<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
nnoremap('<leader>gfa','<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
nnoremap('<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
nnoremap('<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
nnoremap('<leader>glf','<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
nnoremap('<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nnoremap('<leader>grf','<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
nnoremap('<leader>grn','<cmd>lua vim.lsp.buf.rename()<CR>')
nnoremap('<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
--Terminal
tnoremap('<Esc>', '<C-\\><C-n>')
