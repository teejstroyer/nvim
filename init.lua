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
-----------------------------------------------------------------
-- PLUGINS ------------------------------------------------------
-----------------------------------------------------------------
local go = vim.o -- global option
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
	use 'Yggdroot/indentLine' -- see indentation
	use 'tpope/vim-fugitive' -- git integration
	use 'windwp/nvim-autopairs'
	use 'kyazdani42/nvim-web-devicons'
	use 'rcarriga/nvim-notify' -- Pretty Notification UI
	----------------------------------------------------
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
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
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	--
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/nvim-cmp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip'
	--use {"github/copilot.vim"}
	use {
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup()
			end, 100)
		end,
	}
	use {
		"zbirenbaum/copilot-cmp",
		module = "copilot_cmp",
	}
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

			-- pseudo code / specification for writing custom displays, like the one
			-- for "codeactions"
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin "codeactions" display
			--      do the following
			--   codeactions = false,
			-- }
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
go.clipboard = "unnamedplus" -- Copy paste between vim and everything else
go.mouse = "a" -- Enable your mouse
go.splitbelow = true -- Horizontal splits will automatically be below
go.splitright = true -- Vertical splits will automatically be to the right
go.swapfile = false
go.timeoutlen = 400 -- By default timeoutlen is 1000 ms
go.title = true
go.titlestring = "%<%F%=%l/%L - nvim"
go.updatetime = 200 -- Faster completion
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
wo.wrap = false

--vim.cmd('set termguicolors')
vim.cmd('set inccommand=split') -- Make substitution work in realtime
vim.cmd('set iskeyword+=-') -- Treat dash separated words as a word text object"
vim.cmd('set shortmess+=c') -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set sw=2') -- Change the number of space characters inserted for indentation
vim.cmd('set ts=2') -- Insert 2 spaces for a tab
vim.cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
vim.cmd('set completeopt=menu,menuone,noselect')
--vim.cmd("autocmd CursorHold <buffer> lua vim.diagnostic.open_float({ focusable = false, focus=false })")
--vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

------------------------------------------------------------------
-- LSP_ -----------------------------------------------------------
------------------------------------------------------------------
local lsp_installer = require("nvim-lsp-installer")
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(function(server)
	local opts = { capabilities = capabilities }
	server:setup(opts)
end)

local lspconf = require("lspconfig")
lspconf.omnisharp.setup {
	use_mono = true,
	capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	on_attach = function(_, bufnr)
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	end,
	cmd = { "/usr/local/bin/omnisharp", "--languageserver", "--hostPID", tostring(pid) },
}

vim.diagnostic.config({
	virtual_text = true,
	severity_sort = true,
	underline = true,
	update_in_insert = true,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = ''
	}
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
local cmp = require 'cmp'
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
	--formatting = { },
	sources = cmp.config.sources({
		-- Copilot Source
		{ name = 'copilot', },
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'cmdline' },
		{ name = 'nvim-lsp' },
		{ name = 'luasnip' },
	}, {
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
nnoremap("<Space>", "<NOP>")
inoremap("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], "silent", "expr")
inoremap("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], "silent", "expr")
------------------------------------------------------------------
--****************************************************************
------------------------------------------------------------------
nnoremap('<leader><leader>', ':WhichKey<CR>', 'silent')
nnoremap('<leader>rj', ':resize -2<CR>', 'silent')
nnoremap('<leader>rk', ':resize +2<CR>', 'silent')
nnoremap('<leader>rh', ':vertical resize +2<CR>', 'silent')
nnoremap('<leader>rl', ':vertical resize -2<CR>', 'silent')
nnoremap('<leader>j', '<C-W>j', 'silent')
nnoremap('<leader>k', '<C-W>k', 'silent')
nnoremap('<leader>h', '<C-W>h', 'silent')
nnoremap('<leader>l', '<C-W>l', 'silent')
------------------------------------------------------------------
--****************************************************************
------------------------------------------------------------------
--Window
nnoremap('<c-h>', ':tabprevious<CR>')
nnoremap('<c-l>', ':tabnext<CR>')
nnoremap('<leader>b', ':tabnew<CR>')
nnoremap('<leader>sh', ':sp<CR>')
nnoremap('<leader>sv', ':vs<CR>')
nnoremap('<leader>w', ":lua require('nvim-window').pick()<CR>")
nnoremap('<leader>ws', '<Cmd>WinShift<CR>')
--NvimTree
nnoremap('<leader>e', ':NvimTreeToggle<CR>')
nnoremap('<leader>er', ':NvimTreeRefresh<CR>')
nnoremap('<leader>ef', ':NvimTreeFindFile<CR>')
--Telescope
nnoremap('<leader>t', '<cmd>Telescope<CR>')
nnoremap('<leader>tb', '<cmd>Telescope buffers<CR>')
nnoremap('<leader>tf', '<cmd>Telescope find_files<CR>')
nnoremap('<leader>tg', '<cmd>Telescope live_grep<CR>')
nnoremap('<leader>th', '<cmd>Telescope help_tags<CR>')
nnoremap('<leader>td', '<cmd>Telescope diagnostics<CR>')
--LSP
nnoremap('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
nnoremap('<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
nnoremap('<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
nnoremap('<leader>gdc', '<cmd>lua vim.lsp.buf.declaration()<CR>')
nnoremap('<leader>gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
nnoremap('<leader>gfa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
nnoremap('<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
nnoremap('<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
nnoremap('<leader>glf', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
nnoremap('<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
nnoremap('<leader>grf', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
nnoremap('<leader>grn', '<cmd>lua vim.lsp.buf.rename()<CR>')
nnoremap('<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
--Terminal
tnoremap('<Esc>', '<C-\\><C-n>')
