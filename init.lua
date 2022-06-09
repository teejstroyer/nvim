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
local go = vim.o  -- global option
local wo = vim.wo -- window option
local bo = vim.bo -- buffer option
local fn = vim.fn
local opt = vim.opt
local cmd = vim.api.nvim_command

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup({function()
  use 'wbthomason/packer.nvim' --Packer manages itself
  ----------------------------------------------------
  use 'lewis6991/impatient.nvim'
  ----------------------------------------------------
  use 'folke/which-key.nvim'
  use "b0o/mapx.nvim"            --Functions for setting mappings
  use 'mhinz/vim-startify'       --Start screen
  use 'lilydjwg/colorizer'       --Colors hex
  use 'ellisonleao/gruvbox.nvim' --Colorscheme
  use 'majutsushi/tagbar'        -- code structure
  use 'Yggdroot/indentLine'      -- see indentation
  use 'tpope/vim-fugitive'       -- git integration
  use 'junegunn/gv.vim'          -- commit history
  use 'windwp/nvim-autopairs'
  use 'kyazdani42/nvim-web-devicons'
  use { 'yamatsum/nvim-nonicons', requires = {'kyazdani42/nvim-web-devicons'} }
  use 'stevearc/dressing.nvim'   -- Pretty UI middleware
  use 'rcarriga/nvim-notify'     -- Pretty Notification UI
  ----------------------------------------------------
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use { 'nvim-lualine/lualine.nvim', requires = {'kyazdani42/nvim-web-devicons', opt = true}, }
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons', }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' , }
  use { 'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'} }
  use 'toppair/reach.nvim'
  use 'https://gitlab.com/yorickpeterse/nvim-window.git'
  use 'sindrets/winshift.nvim'
  -- LSP_ ----------------------------------------
  use 'hrsh7th/nvim-cmp'
  use { 'neovim/nvim-lspconfig', requires = {'hrsh7th/nvim-cmp'}, }
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use {'folke/trouble.nvim', requires = 'kyazdani42/nvim-web-devicons'}
  --Auto install/setup packer
  if packer_bootstrap then require('packer').sync() end
end,
config = {
  display = {
    open_fn = require('packer.util').float,
  }
}})

-----------------------------------------------------------------
-- PLUGIN_SETUP --------------------------------------------------------
-----------------------------------------------------------------
require('impatient').enable_profile()
require('reach').setup({ notifications = true })

local status, nw = pcall(require, 'nvim-window')
if status then
  nw.setup{}
end
vim.notify = require("notify")
require('trouble').setup {}
require('gitsigns').setup{}
require('nvim-tree').setup {}
require('lualine').setup{ options = {theme = 'gruvbox'}}
require'mapx'.setup{ global = true, whichkey=true }
require("which-key").setup {
  key_labels = {
    ["<space>"] = "SPC",
    ["<CR>"] = "RET",
    ["<tab>"] = "TAB",
  }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "c_sharp" },
  sync_install = false,
  ignore_install = { "javascript" },
  highlight = {
    enable = true, -- `false` will disable the whole extension
    disable = { "c", "rust", "c_sharp" },
    additional_vim_regex_highlighting = false,
  }
}

------------------------------------------------------------------
-- SETTINGS ------------------------------------------------------
------------------------------------------------------------------
vim.o.background = "dark"    -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
--
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
go.updatetime = 200          -- Faster completion
go.writebackup = false       -- This is recommended by coc
wo.cursorline = false         -- Enable highlighting of the current line
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"        -- Always show the signcolumn, otherwise it would shift the text each time
wo.wrap = false
opt.syntax = "ON"
---- vim cmds
vim.cmd('set ffs=unix,dos')
--vim.cmd('set colorcolumn=99999')    -- fix indentline for now
vim.cmd('set inccommand=split')       -- Make substitution work in realtime
vim.cmd('set iskeyword+=-')           -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c')           -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set sw=2')                   -- Change the number of space characters inserted for indentation
vim.cmd('set ts=2')                   -- Insert 2 spaces for a tab
vim.cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
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

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
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
    mapping = {
      ['J'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['K'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<S-CR>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
})
------------------------------------------------------------------
-- KEYBINDINGS ---------------------------------------------------
------------------------------------------------------------------
vim.cmd([[let mapleader ="\<Space>"]])
nnoremap("<Space>","<NOP>")
inoremap("<S-Tab>",[[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], "silent", "expr")
inoremap("<Tab>",[[pumvisible() ? "\<C-n>" : "\<Tab>"]], "silent", "expr")
------------------------------------------------------------------
--****************************************************************
------------------------------------------------------------------
nnoremap ("<leader><leader>",":WhichKey<CR>","silent")
nnoremap ("<leader>rj" ,":resize -2<CR>","silent")
nnoremap ("<leader>rk" ,":resize +2<CR>","silent")
nnoremap ("<leader>rh" ,":vertical resize +2<CR>","silent")
nnoremap ("<leader>rl" ,":vertical resize -2<CR>","silent")
nnoremap ("<leader>j"  ,"<C-W>j","silent")
nnoremap ("<leader>k"  ,"<C-W>k","silent")
nnoremap ("<leader>h"  ,"<C-W>h","silent")
nnoremap ("<leader>l"  ,"<C-W>l","silent")
------------------------------------------------------------------
--****************************************************************
------------------------------------------------------------------
--Window
nnoremap ("<c-h>"     ,":tabprevious<CR>")
nnoremap ("<c-l>"     ,":tabnext<CR>")
nnoremap ("<leader>b" ,":tabnew<CR>")
nnoremap ("<leader>sh",":sp<CR>")
nnoremap ("<leader>sv",":vs<CR>")
nnoremap ("<leader>w" ,":lua require('nvim-window').pick()<CR>")
nnoremap ("<leader>ws","<Cmd>WinShift<CR>")
--NvimTree
nnoremap ("<leader>t" ,":NvimTreeToggle<CR>")
nnoremap ("<leader>tr",":NvimTreeRefresh<CR>")
nnoremap ("<leader>ts",":NvimTreeFindFile<CR>")
--Trouble
nnoremap ("<leader>xd","<cmd>TroubleToggle lsp_document_diagnostics<CR>")
nnoremap ("<leader>xl","<cmd>TroubleToggle loclist<CR>")
nnoremap ("<leader>xq","<cmd>TroubleToggle quickfix<CR>")
nnoremap ("<leader>xw","<cmd>TroubleToggle lsp_workspace_diagnostics<CR>")
nnoremap ("<leader>xx","<cmd>TroubleToggle<CR>","silent")
--Telescope
nnoremap ("<leader>fb","<cmd>Telescope buffers<CR>")
nnoremap ("<leader>ff","<cmd>Telescope find_files<CR>")
nnoremap ("<leader>fg","<cmd>Telescope live_grep<CR>")
nnoremap ("<leader>fh","<cmd>Telescope help_tags<CR>")
--LSP
nnoremap ("<leader>fm" ,"<cmd>lua vim.lsp.buf.formatting()<CR>")
nnoremap ("<leader>gD" ,"<cmd>lua vim.lsp.buf.declaration()<CR>")
nnoremap ("K" ,"<cmd>lua vim.lsp.buf.hover()<CR>")
nnoremap ("<leader>gk" ,"<cmd>lua vim.lsp.buf.signature_help()<CR>")
nnoremap ("<leader>gR" ,"<cmd>TroubleToggle lsp_references<CR>")
nnoremap ("<leader>ga" ,"<cmd>lua vim.lsp.buf.code_action()<CR>")
nnoremap ("<leader>gd" ,"<cmd>lua vim.lsp.buf.definition()<CR>")
nnoremap ("<leader>gfa","<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
nnoremap ("<leader>gfl","<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
nnoremap ("<leader>gfr","<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
nnoremap ("<leader>gi" ,"<cmd>lua vim.lsp.buf.implementation()<CR>")
nnoremap ("<leader>gr" ,"<cmd>lua vim.lsp.buf.references()<CR>")
nnoremap ("<leader>grn","<cmd>lua vim.lsp.buf.rename()<CR>")
nnoremap ("<leader>gt" ,"<cmd>lua vim.lsp.buf.type_definition()<CR>")
--Terminal
tnoremap ("<Esc>","<C-\\><C-n>")

