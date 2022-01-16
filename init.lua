-- Table of Contents
-- KEYBINDINGS --------------------------------------------------
-- PLUGINS ------------------------------------------------------
-- SETTINGS -----------------------------------------------------
-- TREESITTER ---------------------------------------------------
-- LSP ----------------------------------------------------------
-- LSP-SAGA -----------------------------------------------------
-- TABNINE ------------------------------------------------------
-- WHICH KEY ----------------------------------------------------
-- Neovim single file configuration
--
------------------------------------------------------------------
-- PLUGINS -------------------------------------------------------
------------------------------------------------------------------
local go = vim.o  -- global option
local wo = vim.wo -- window option
local bo = vim.bo -- buffer option
local fn = vim.fn
local execute = vim.api.nvim_command
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer manages itself
	use "b0o/mapx.nvim"
  use 'airblade/vim-gitgutter'            --Git gutter symbols
  use 'lilydjwg/colorizer'                --Colors hex
  use 'luochen1990/rainbow'               --Rainbow Braces
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'folke/which-key.nvim'
  -- LSP
  use { 'neovim/nvim-lspconfig', requires = {'hrsh7th/nvim-cmp'}, }
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'kosayoda/nvim-lightbulb'           --Code Action symbol
  use 'L3MON4D3/LuaSnip'
  use {'tami5/lspsaga.nvim', branch='nvim51'}
  use {'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons', config = function() require('trouble').setup {} end }
  -- Language Specific
  use 'OmniSharp/omnisharp-vim'           --C# LSP
  use 'dart-lang/dart-vim-plugin'

end)
------------------------------------------------------------------
-- SETTINGS ------------------------------------------------------
------------------------------------------------------------------
bo.expandtab = true
bo.smartindent = true        -- Makes indenting smart
go.backup = false            -- This is recommended by coc
go.clipboard = "unnamedplus" -- Copy paste between vim and everything else
go.cmdheight = 2             -- More space for displaying messages
go.completeopt = "menu,menuone,noselect"
go.conceallevel = 0          -- So that I can see `` in markdown files
go.dir = '/tmp'
go.fileencoding = "utf-8"    -- The encoding written to file
go.hidden = true             -- Required to keep multiple buffers open multiple buffers
go.hlsearch = true
go.ignorecase = true
go.incsearch = true
go.laststatus = 2
go.mouse = "a"               -- Enable your mouse
go.pumheight = 10            -- Makes popup menu smaller
go.scrolloff = 12
go.showmode = false          -- We don't need to see things like -- INSERT -- anymore
go.showtabline = 2           -- Always show tabs
go.smartcase = true
go.splitbelow = true         -- Horizontal splits will automatically be below
go.splitright = true         -- Vertical splits will automatically be to the right
go.swapfile = false
go.termguicolors = true      -- set term giu colors most terminals support this
go.timeoutlen = 400          -- By default timeoutlen is 1000 ms
go.title = true
go.titlestring="%<%F%=%l/%L - nvim"
go.updatetime = 300          -- Faster completion
go.writebackup = false       -- This is recommended by coc
wo.cursorline = true         -- Enable highlighting of the current line
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"        -- Always show the signcolumn, otherwise it would shift the text each time
wo.wrap = false
---- vim cmds
vim.cmd('set colorcolumn=99999')      -- fix indentline for now
vim.cmd('set inccommand=split')       -- Make substitution work in realtime
vim.cmd('set iskeyword+=-')           -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c')           -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set sw=2')                   -- Change the number of space characters inserted for indentation
vim.cmd('set ts=2')                   -- Insert 2 spaces for a tab
vim.cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
vim.cmd('syntax on')                  -- move to next line with theses keys
vim.cmd('colorscheme evening')

------------------------------------------------------------------
-- WHICH KEY -----------------------------------------------------
------------------------------------------------------------------
local wk = require("which-key")
wk.setup {
  key_labels = {
    ["<space>"] = "SPC",
    ["<CR>"] = "RET",
    ["<tab>"] = "TAB",
  },
}

------------------------------------------------------------------
-- TREESITTER ----------------------------------------------------
------------------------------------------------------------------
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      ["foo.bar"] = "Identifier", -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  }
}

------------------------------------------------------------------
-- LSP -----------------------------------------------------------
------------------------------------------------------------------
local lsp_installer = require("nvim-lsp-installer")
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(function(server)
    local opts = {
        capabilities = capabilities
    }
    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end
    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
    server:setup(opts)
end)

------------------------------------------------------------------
-- CMP -----------------------------------------------------------
------------------------------------------------------------------
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
             require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['J'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['K'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<S-CR>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        --['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        --['<C-e>'] = cmp.mapping({
        --    i = cmp.mapping.abort(),
        --    c = cmp.mapping.close(),
        --}),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })

    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
    })
})

------------------------------------------------------------------
-- LSP-SAGA ------------------------------------------------------
------------------------------------------------------------------
local saga = require 'lspsaga'
saga.init_lsp_saga()

------------------------------------------------------------------
-- KEYBINDINGS ---------------------------------------------------
------------------------------------------------------------------
require'mapx'.setup{ global = true, whichkey=true }
vim.cmd([[let mapleader ="\<Space>"]])
nnoremap("<Space>", "<NOP>")
nnoremap ("<leader>J",":resize -2<CR>","silent")
nnoremap ("<leader>K",":resize +2<CR>","silent")
nnoremap ("<leader>H",":vertical resize +2<CR>","silent")
nnoremap ("<leader>L",":vertical resize -2<CR>","silent")
nnoremap ("<leader>jj","<C-W>j","silent")
nnoremap ("<leader>kk","<C-W>k","silent")
nnoremap ("<leader>hh"," <C-W>h","silent")
nnoremap ("<leader>ll","<C-W>l","silent")
nnoremap ("<leader>vs",":vs<CR>")
nnoremap ("<leader>hs",":sp<CR>")
nnoremap ("<leader><leader>",":WhichKey<CR>","silent")
nnoremap ("gh","<cmd require'lspsaga.provider'.lsp_finder()<CR>","silent")
nnoremap ("<leader>gh","<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>","silent")
nnoremap ("<leader>ca","<cmd>lua require('lspsaga.codeaction').code_action()<CR>","silent")
vnoremap ("<leader>ca",":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>","silent")
nnoremap ("K","<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>","silent")
nnoremap ("<C-j>","<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>","silent")
nnoremap ("<C-k>","<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>","silent")
nnoremap ("<leader>gs","<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>","silent")
nnoremap ("<leader>gr","<cmd>lua require('lspsaga.rename').rename()<CR>","silent")
nnoremap ("<leader>gd","<cmd>lua require'lspsaga.provider'.preview_definition()<CR>","silent")
nnoremap ("<leader>cd","<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>","silent")
nnoremap ("<leader>cc","<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>","silent")
nnoremap ("<leader>n","<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>","silent")
nnoremap ("<leader>;","<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>","silent")
nnoremap ("<leader>ft","<cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR> ","silent")
tnoremap ("<leader>ft","<C-\\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>","silent")
nnoremap ("<leader>xx","<cmd>TroubleToggle<cr>","silent")
nnoremap ("<leader>xw","<cmd>TroubleToggle lsp_workspace_diagnostics<cr>")
nnoremap ("<leader>xd","<cmd>TroubleToggle lsp_document_diagnostics<cr>")
nnoremap ("<leader>xq","<cmd>TroubleToggle quickfix<cr>")
nnoremap ("<leader>xl","<cmd>TroubleToggle loclist<cr>")
nnoremap ("gR","<cmd>TroubleToggle lsp_references<cr>")
inoremap("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], "silent", "expr")
inoremap("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], "silent", "expr")

