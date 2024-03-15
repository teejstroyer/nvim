-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command choco install mingw as admin should work

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable' }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  "tpope/vim-sleuth",                                                      -- Detect tabstop and shiftwidth automatically
  "mbbill/undotree",                                                       -- Visual undo tree
  { 'folke/which-key.nvim',                opts = {} },                    -- Helpful popup for keymaps
  { 'lewis6991/gitsigns.nvim',             opts = {} },                    -- Git signs in gutters
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl',  opts = {}, },    -- Add indentation guides even on blank lines
  { 'numToStr/Comment.nvim',               opts = {},     lazy = false, }, -- "gc" to comment visual regions/lines
  { 'NvChad/nvim-colorizer.lua',           opts = {}, },                   -- Colors text in editor (#FFF)
  { 'akinsho/toggleterm.nvim',             version = "*", opts = {} },     -- Makes interacting with terminal easier
  { 'stevearc/dressing.nvim',              opts = {}, },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  { "lervag/vimtex" }, -- LaTex tools
  ---------------------------------
  --Colorscheme
  ---------------------------------
  { "catppuccin/nvim",           name = "catppuccin",                                                                                                              priority = 1000 },
  { 'nvim-lualine/lualine.nvim', opts = { options = { icons_enabled = false, theme = 'catppuccin-frappe', component_separators = '|', section_separators = '' }, } },
  ---------------------------------
  --File Tree
  ---------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    config = function()
      require("neo-tree").setup({
        source_selector = { winbar = true },
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
        }
      })
    end
  },
  ---------------------------------
  -- LSP
  ---------------------------------
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',          -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'folke/neodev.nvim', opts = {} }  -- Completions for neovim
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({ handlers = {}, ensure_installed = {}, automatic_installation = {} })
    end,
  },
  {
    'hrsh7th/nvim-cmp', -- Autocompletion
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "rafamadriz/friendly-snippets",
      "zbirenbaum/copilot-cmp",
    },
  },
  { "onsails/lspkind.nvim" },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end -- Doesn't need to be called on attach if not toggled
  },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts =
    {
      snippet_engine = "luasnip",
      languages = {
        cs = { template = { annotation_convention = "xmldoc" } }
      }

    }
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
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground'
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
          playground = {
            enable = true,
            disable = {},
            updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
          },
          query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
          },
        }
      end, 0)
    end
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    enabled = true,
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
}, {})

vim.cmd.colorscheme "catppuccin-frappe"
vim.o.hlsearch = false                 -- Set highlight on search
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

vim.opt.colorcolumn = "120"
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
vim.opt.list = true --Shows chars like whitespace

-- LaTex Configuration
vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1        -- Value 1 allows change focus to skim after command `:VimtexView` is given
vim.g.vimtex_continuous = 1                -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1            -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1  -- Enable snippets for faster typing (optional)
vim.g.vimtex_compiler_latexmk = {
  out_dir = 'out'
}

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

local function fuzzy_find_buffer()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end

local function document_code()
  local choices = {
    { name = "1: Function", id = "func" },
    { name = "2: File",     id = "file" },
    { name = "3: Type",     id = "type" },
    { name = "4: Class",    id = "class" },
  }

  vim.ui.select(choices, {
    prompt = "Choose context type:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      require('neogen').generate({ type = choice.id })
    end
  end)
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
vim.api.nvim_create_user_command('FuzzyFindBuffer', fuzzy_find_buffer, {})
vim.api.nvim_create_user_command('TelescopeLiveGrepOpenFiles', telescope_live_grep_open_files, {})

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
      diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
require("copilot_cmp").setup()
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
  -- No, but seriously. Please read `:help ins-completion`, it is really good!
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<C-l>'] = cmp.mapping(function() -- <c-l> will move you to the right of each of the expansion locations.
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function() -- <c-h> is similar, except moving you backwards.
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = "copilot",  group_index = 2 },
    { name = "nvim_lsp", group_index = 2 },
    { name = "luasnip",  group_index = 2 },
    { name = "path",     group_index = 2 },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      max_width = 50,
      symbol_map = { Copilot = "" }
    })
  }
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
  ['<leader>cw'] = { name = '[C]ode [W]orkspace', _ = 'which_key_ignore' },
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
--TOGGLE TERM
vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm<cr>")
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm size=40 dir=. direction=horizontal<cr>")
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm size=40 dir=. direction=float<cr>")
vim.keymap.set("n", "<leader>tb", ":enew|terminal<cr>")
-- ZEN MODE
vim.keymap.set("n", "<leader>z", function() require("zen-mode").toggle({ window = { width = .85 } }) end,
  { desc = "[Z]en" })
--TELESCOPE
local telescope_builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>/", fuzzy_find_buffer, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader><space>", telescope_builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>?", telescope_builtin.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>f.", telescope_builtin.git_files, { desc = "[F]ind [G]it [F]iles" })
vim.keymap.set("n", "<leader>f/", telescope_live_grep_open_files, { desc = "[F]ind [/] in Open Files" })
vim.keymap.set("n", "<leader>f<space>", telescope_builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
vim.keymap.set("n", "<leader>fG", live_grep_git_root, { desc = "[F]ind by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "[F]ind [B]uffer" })
vim.keymap.set("n", "<leader>fd", telescope_builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "[F]ind by [G]rep (Live)" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "[F]ind [H]elp Tags" })
vim.keymap.set("n", "<leader>fr", telescope_builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>fw", telescope_builtin.grep_string, { desc = "[F]ind current [W]ord" })
--DIAGNOSTICS
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
--GEN AI
vim.keymap.set({ 'n', 'v' }, '<leader><', ':Gen<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>>', ':Gen Chat<CR>')

vim.keymap.set("n", "<leader>;", function() require("ollama").show() end, {})

--LSP ( Mapped only on attach)
vim.keymap.set('n', '<leader>c/', document_code, { desc = '[C]ode Documentation [G]en' })
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    --Staple Keymap
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Hover Documentation' })
    --Code
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = '[C]ode [A]ction' })
    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[C]ode [R]ename' })
    vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { buffer = ev.buf, desc = '[C]ode [F]ormat' })
    vim.keymap.set('n', '<leader>cs', vim.lsp.buf.signature_help,
      { buffer = ev.buf, desc = '[C]ode [S]ignature Documentation' })
    vim.keymap.set('n', '<leader>cd', telescope_builtin.lsp_document_symbols,
      { buffer = ev.buf, desc = '[C]ode [D]ocument Symbols' })
    --Code Workspace
    vim.keymap.set('n', '<leader>cws', telescope_builtin.lsp_dynamic_workspace_symbols,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [S]ymbols' })
    vim.keymap.set('n', '<space>cwfa', vim.lsp.buf.add_workspace_folder,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]older [A]dd' })
    vim.keymap.set('n', '<space>cwfr', vim.lsp.buf.remove_workspace_folder,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]older [R]emove' })
    vim.keymap.set('n', '<space>cwfl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]olders [L]ist' })
    -- GoTos
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = '[G]oto [D]eclaration' })
    vim.keymap.set('n', '<space>gd', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = '[G]oto Type [D]efinition' })
    vim.keymap.set('n', 'gI', telescope_builtin.lsp_implementations,
      { buffer = ev.buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, { buffer = ev.buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, { buffer = ev.buf, desc = '[G]oto [R]eferences' })
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', vim.lsp.buf.format,
      { desc = 'Format current buffer with LSP' })
  end,
})

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
