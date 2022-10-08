-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command
-- choco install mingw as admin should work

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
    use 'rcarriga/nvim-notify' --Pretty Notification UI
    use 'onsails/lspkind.nvim' --Icons for popups
    ----------------------------------------------------
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
        requires = { 'nvim-treesitter/nvim-treesitter-context' }
    }
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
            'hrsh7th/cmp-copilot',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
            'github/copilot.vim'
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

-----------------------------------------------------------------
-- PLUGIN_SETUP --------------------------------------------------------
-----------------------------------------------------------------
require('impatient').enable_profile()
vim.notify = require("notify")
require('nightfox').setup({
    options = {
        styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
        }
    }
})

require("nvim-autopairs").setup()
require('gitsigns').setup()
require('nvim-tree').setup()
require('lualine').setup({ options = { theme = 'nightfox' } })
require("which-key").setup()
require('nvim-treesitter.configs').setup({
    ensure_installed = { "c", "lua", "rust", "c_sharp" },
    sync_install = false,
    highlight = {
        enable = true,
    }
})
require("telescope").setup {
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown()
        }
    }
}
require("telescope").load_extension("ui-select")
require("telescope").load_extension("notify")

------------------------------------------------------------------
-- SETTINGS ------------------------------------------------------
------------------------------------------------------------------
vim.cmd([[colorscheme nightfox]])
vim.g.mapleader = " "
vim.go.clipboard = "unnamedplus" -- Copy paste between vim and everything else
vim.go.completeopt = "menu,menuone,noselect"
vim.go.inccommand = 'split'
vim.go.mouse = "a" -- Enable your mouse
vim.go.splitbelow = true -- Horizontal splits will automatically be below
vim.go.splitright = true -- Vertical splits will automatically be to the right
vim.go.swapfile = false
vim.go.timeoutlen = 400 -- By default timeoutlen is 1000 ms
vim.go.title = true
vim.go.titlestring = "%<%F%=%l/%L - nvim"
vim.go.updatetime = 200 -- Faster completion
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.colorcolumn = "80"
vim.opt.errorbells = false
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.iskeyword:append("-")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 4
vim.opt.shortmess:append("c")
vim.opt.showmatch = true
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false
------------------------------------------------------------------
-- LSP_ -----------------------------------------------------------
------------------------------------------------------------------
require('mason').setup()
require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua", "omnisharp", "rust_analyzer", "tsserver" }
}

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers({
    function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    ["sumneko_lua"] = function() --Per lsp config
        lspconfig.sumneko_lua.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
    end,
})

local dap, dapui = require('dap'), require('dapui')
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
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

cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

------------------------------------------------------------------
-- KEYBINDINGS ---------------------------------------------------
------------------------------------------------------------------
vim.cmd([[let mapleader ="\<Space>"]])
vim.keymap.set('n', "<Space>", "<NOP>")
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? '\<C-p>' : '\<S-Tab>']], { silent = true, expr = true })
vim.keymap.set('i', '<Tab>', [[pumvisible() ? '\<C-n>' : '\<Tab>']], { silent = true, expr = true })
vim.keymap.set('n', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>p', '"_dP')
------------------------------------------------------------------
vim.keymap.set('n', '<leader><leader>', ':WhichKey<CR>', { silent = true })
vim.keymap.set('n', '<leader>J', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<leader>K', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<leader>H', ':vertical resize +2<CR>', { silent = true })
vim.keymap.set('n', '<leader>L', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<leader>j', '<C-W>j', { silent = true })
vim.keymap.set('n', '<leader>k', '<C-W>k', { silent = true })
vim.keymap.set('n', '<leader>h', '<C-W>h', { silent = true })
vim.keymap.set('n', '<leader>l', '<C-W>l', { silent = true })
--Buffer
vim.keymap.set('n', '<leader><Tab>', ':BufferNext<CR>')
vim.keymap.set('n', '<leader><S-Tab>', ':BufferPrevious<CR>')
vim.keymap.set('n', '<leader>q', ':BufferClose<CR>')
vim.keymap.set('n', '<leader>qa', ':BufferCloseAllButCurrentOrPinned<CR>')
vim.keymap.set('n', '<leader>;', ':BufferPick<CR>')
vim.keymap.set('n', '<leader><Tab><Tab>', ':BufferPin<CR>')
--Window
vim.keymap.set('n', '<leader>sh', ':sp<CR>')
vim.keymap.set('n', '<leader>sv', ':vs<CR>')
vim.keymap.set('n', '<leader>ws', '<Cmd>WinShift<CR>')
--NvimTree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>er', ':NvimTreeRefresh<CR>')
vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>')
vim.keymap.set('n', '<leader>em', ':help nvim-tree.view.mappings<CR>')
--Telescope
vim.keymap.set('n', '<leader>t', '<cmd>Telescope<CR>')
vim.keymap.set('n', '<leader>tb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<leader>tf', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>tg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>th', '<cmd>Telescope help_tags<CR>')
vim.keymap.set('n', '<leader>td', '<cmd>Telescope diagnostics<CR>')
--LSP
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
vim.keymap.set('n', '<leader>ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
vim.keymap.set('n', '<leader>gdc', '<cmd>lua vim.lsp.buf.declaration()<CR>')
vim.keymap.set('n', '<leader>gf', '<cmd>lua vim.lsp.buf.format()<CR>')
vim.keymap.set('n', '<leader>gfa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
vim.keymap.set('n', '<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
vim.keymap.set('n', '<leader>glf', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>')
vim.keymap.set('n', '<leader>grf', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
vim.keymap.set('n', '<leader>grn', '<cmd>lua vim.lsp.buf.rename()<CR>')
vim.keymap.set('n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
--DAP
vim.keymap.set('n', '<F5>', ":DapContinue<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F10>', ":DapStepOver<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F11>', ":DapStepInto()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F12>', ":DapStepOut<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F9>', ":DapToggleBreakpoint<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<S-F9>', "<cmd> lua require'DapSetBreakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>dr', "<cmd> lua require'DapRepl.open()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>dl', "<cmd> lua require'DapRun_last()<CR>", { noremap = true, silent = true })
--Terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
