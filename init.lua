-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command choco install mingw as admin should work
--if vim.fn.exists("g:vscode") == 0 then
--    require("config.lazy")
--    require("config.options")
--    require("config.autocmds")
--    require("config.keymaps")
--end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "mbbill/undotree",
  {
    'navarasu/onedark.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    enabled = true,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    opts = { source_selector = { winbar = true } }
  },
  -- LSP
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim', opts = {} }
    },
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {}
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',         -- Adds LSP completion capabilities
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets', -- Adds a number of user-friendly snippets
    },
  },
  { 'folke/which-key.nvim',    opts = {} },
  { 'lewis6991/gitsigns.nvim', opts = {}, },
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {}, },    -- Add indentation guides even on blank lines
  { 'numToStr/Comment.nvim',               opts = {},    lazy = false, }, -- "gc" to comment visual regions/lines
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup({})
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      "dimaportenko/telescope-simulators.nvim",
      "kdheepak/lazygit.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({ extensions = {} })
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'lazygit')
      --pcall(telescope.load_extension, 'file_browser')
    end
  },
  { 'akinsho/toggleterm.nvim', version = "*", opts = {} },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { 'c_sharp', 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },
          sync_install = false,
          ignore_install = {},
          modules = {},
          auto_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        }
      end, 0)
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    enabled = true,
    config = function()
      require('copilot').setup({
        panel = { enabled = false },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 50,
          keymap = {
            accept = "<C-CR>",
            accept_word = "<S-Space>",
            accept_line = "<S-CR>",
            next = "<C-j>",
            prev = "<C-k>",
            dismiss = "<C-.>",
          },
        },
      })
    end,
  }
}, {})

vim.o.hlsearch = false                 -- Set highlight on search
vim.wo.number = true                   -- Make line numbers default
vim.o.mouse = 'a'                      -- Enable mouse mode
vim.o.clipboard = 'unnamedplus'        -- Sync clipboard between OS and Neovim.
vim.o.undofile = true                  -- Save undo history
vim.o.ignorecase = true                -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true
vim.o.updatetime = 250                 -- Decrease update time
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience

vim.g.netrw_altv = 1
vim.g.netrw_banner = 1
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_keepdir = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_winsize = 30

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.wrap = true
vim.opt.linebreak = true --Wrap lines at convenient points like spaces
vim.opt.breakindent = true --Indent wrapped lines
vim.opt.showbreak = "↳" --Symbol for wrapped lines
vim.opt.list = true --shows chars like whitespace

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

local function fuzzyFindBuffer()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end
-- function()
--  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--    winblend = 10,
--    previewer = false,
--  })
--end
--
local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
}

--AUTO Commands
local augroup = vim.api.nvim_create_augroup
local auGroupConfig = augroup("auGroup_config", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = auGroupConfig,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

--Term open auto command
autocmd({ "TermOpen" }, {
  group = auGroupConfig,
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
}, { mode = 'v' })

----------------------------------------------------
-- KEYMAPS
----------------------------------------------------

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }) -- Word Wrap Fix
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }) -- Word Wrap Fix
vim.keymap.set("n", "Q", "<nop>")                                                     --UNMAP to prevent hard quit
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")                                           -- Excap enters normal mode for terminal

--UNDO TREE
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree Toggle" })

--BUFFER
vim.keymap.set("n", "<leader>q", ":bdelete<CR>")
vim.keymap.set("n", "<leader>l", ":bnext<CR>")
vim.keymap.set("n", "<leader>h", ":bprevious<CR>")
--Move selection up or down
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv")
-- COPY/PASTE/DELETE To buffer
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
--SEARCH AND REPLACE UNDER CURSOR
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--FILE Explorer
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
--MOVE BETWEEN WINDOW PREFIX
vim.keymap.set("n", "<leader>w", "<C-w>") --Helpful for moving between windows
--WINDOW SPLITS
vim.keymap.set("n", "<leader>\\", ":vsplit<CR>")
vim.keymap.set("n", "<leader>-", ":split<CR>")
vim.keymap.set("n", "<Up>", ":resize -2<CR>")
vim.keymap.set("n", "<Down>", ":resize +2<CR>")
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>")

--DIAGNOSTICS
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

--TOGGLE TERM
vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm size=40 dir=. direction=horizontal<cr>")
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm size=40 dir=. direction=float<cr>")
vim.keymap.set("n", "<leader>tb", ":enew|terminal<cr>")

--TELESCOPE
--vim.keymap.set("n", "<leader>ff", ":Telescope<CR>", silentOpt)
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", fuzzyFindBuffer, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>f.", require("telescope.builtin").git_files, { desc = "[F]ind [G]it [F]iles" })
vim.keymap.set("n", "<leader>f/", telescope_live_grep_open_files, { desc = "[F]ind [/] in Open Files" })
vim.keymap.set("n", "<leader>fG", live_grep_git_root, { desc = "[F]ind by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "[F]ind by [G]rep (Live)" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp Tags" })
vim.keymap.set("n", "<leader>fr", require("telescope.builtin").resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>fs", require("telescope.builtin").builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })

--DAP - DEBUG
-- local dap = require "dap"
-- vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue" })
-- vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
-- vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
-- vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Steop Out" })
-- vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Breakpoint" })
-- vim.keymap.set("n", "<C-F9>", function()
--     dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
-- end, { desc = "Conditional Breakpoint" })

local on_lsp_attach = function(_, bufnr) --  This function gets run when an LSP connects to a particular buffer.
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP: [C]ode [A]ction' })
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP: [C]ode [R]ename' })
  vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = bufnr, desc = 'LSP: [C]ode [F]ormat' })
  vim.keymap.set('n', '<leader>cds', require('telescope.builtin').lsp_document_symbols,
    { buffer = bufnr, desc = 'LSP: [C]ode [D]ocument [S]ymbols' })
  vim.keymap.set('n', '<leader>cws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    { buffer = bufnr, desc = 'LSP:[C]ode [W]orkspace [S]ymbols' })

  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature Documentation' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP: Hover Documentation' })

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'LSP: [G]oto [D]eclaration' })
  vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
    { buffer = bufnr, desc = 'LSP: [G]oto [I]mplementation' })
  vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
    { buffer = bufnr, desc = 'LSP: [G]oto [D]efinition' })
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
    { buffer = bufnr, desc = 'LSP: [G]oto [R]eferences' })

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}
