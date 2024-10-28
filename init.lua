vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Moved install scripts to lua/bootstrap/init.lua
require('bootstrap').init()
------------------------------------------
--
require('mini.ai').setup()
require('mini.colors').setup()
require('mini.completion').setup()
require('mini.diff').setup()
require('mini.extra').setup()
require('mini.files').setup()
require('mini.icons').setup()
require('mini.indentscope').setup()
require('mini.notify').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
--
vim.notify = require('mini.notify').make_notify()
local pick = require('mini.pick')
pick.setup()
vim.ui.select = pick.ui_select

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' }, -- Leader
    { mode = 'x', keys = '<Leader>' }, -- Leader
    { mode = 'i', keys = '<C-x>' },    -- Built-in completion
    { mode = 'n', keys = 'g' },        -- 'g' key
    { mode = 'x', keys = 'g' },        -- 'g' key
    { mode = 'n', keys = "'" },        -- Marks
    { mode = 'n', keys = '`' },        -- Marks
    { mode = 'x', keys = "'" },        -- Marks
    { mode = 'x', keys = '`' },        -- Marks
    { mode = 'n', keys = '"' },        -- Registers
    { mode = 'x', keys = '"' },        -- Registers
    { mode = 'i', keys = '<C-r>' },    -- Registers
    { mode = 'c', keys = '<C-r>' },    -- Registers
    { mode = 'n', keys = '<C-w>' },    -- Window commands
    { mode = 'n', keys = 'z' },        -- `z` key
    { mode = 'x', keys = 'z' },        -- `z` key
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    config = {
      width = "auto",
      border = "double"
    },
    delay = 100,
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
})

require("null-ls").setup()
require('mason').setup()
require("mason-null-ls").setup({ handlers = {}, ensure_installed = { 'black', 'prettierd' }, automatic_installation = {} })
require("neodev").setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = {
    "angularls",
    "bashls",
    "eslint",
    "lua_ls",
    "marksman",
    "omnisharp",
    "pyright",
    "tailwindcss",
  },
}
mason_lspconfig.setup_handlers {
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  ["lua_ls"] = function()
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          hint = {
            enable = true
          },
          diagnostics = {
            globals = { "vim" }
          }
        }
      }
    }

    --npm install -g basics-language-server
    -- lspconfig.basics_ls.setup{}
  end,
}

-- add("iamcco/markdown-preview.nvim")
-- vim.fn["mkdp#util#install"]()

---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
  -- ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'c_sharp', 'angular' },
  -- auto_install = true,
  highlight = {
    enable = true,
    -- additional_vim_regex_highlighting = { 'ruby' },
  },
  indent = { enable = true, disable = { 'ruby' } },
})


---@diagnostic disable-next-line: missing-fields
require("image").setup({
  backend = "kitty", --"ueberzug" or "kitty",
  integrations = {},
  max_width = 100,
  max_height = 12,
  max_height_window_percentage = math.huge, -- this is necessary for a good experience
  max_width_window_percentage = math.huge,
})

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20

-- later(function() add("lervag/vimtex") end)

--##############################################################################
vim.cmd.colorscheme "catppuccin-frappe"
vim.g.have_nerd_font = true
vim.opt.breakindent = true                          --Indent wrapped lines
vim.opt.clipboard = 'unnamedplus'                   -- Sync clipboard between OS and Neovim.
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menu,menuone,popup,noselect' -- Set completeopt to have a better completion experience
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false  -- Set highlight on search
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.inccommand = 'split'
vim.opt.incsearch = true
vim.opt.isfname:append("@-@")
vim.opt.linebreak = true --Wrap lines at convenient points like spaces
vim.opt.list = true      --Shows chars like whitespace
vim.opt.mouse = 'a'      -- Enable mouse mode
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.showbreak = "↳" --Symbol for wrapped lines
vim.opt.signcolumn = "number"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true  -- Save undo history
vim.opt.updatetime = 300 -- Decrease update time
vim.opt.wrap = true
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"

-- LaTex Configuration
vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1        -- Value 1 allows change focus to skim after command `:VimtexView` is given
vim.g.vimtex_continuous = 1                -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1            -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1  -- Enable snippets for faster typing (optional)
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }

--AUTO Commands
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("TrailingSpace", {}),
  pattern = "*",
  command = [[%s/\s\+$//e]], --removes trailing whitespace
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", {}),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

----------------------------------------------------
-- KEYMAPS
----------------------------------------------------
vim.keymap.set('n', 'k', 'gk', { silent = true }) -- Word Wrap Fix
vim.keymap.set('n', 'j', 'gj', { silent = true }) -- Word Wrap Fix
vim.keymap.set("n", "Q", "<nop>")                 --UNMAP to prevent hard quit
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")       -- Excap enters normal mode for terminal
--BUFFER
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "[B]buffer delete" })
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "[B]buffer next" })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "[B]buffer previous" })
--Move selection up or down
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv")
-- COPY/PASTE/DELETE To buffer
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "[Y]ank to buffer" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "[P]aste to buffer" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "[D]elete to buffer" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]ank to buffer" })
--SEARCH AND REPLACE UNDER CURSOR
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[S]ubsitute under cursor" })
--FILE Explorer
vim.keymap.set("n", "<leader>e",
  function(...)
    if not MiniFiles.close() then MiniFiles.open(...) end
  end,
  { desc = "[E]xplore files" })
--WINDOW SPLITS
vim.keymap.set("n", "<Up>", "<C-w>+", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Down>", "<C-w>-", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Left>", "<C-w><", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Right>", "<C-w>>", { desc = "Resize", silent = true })
-- Mini-Pick
vim.keymap.set("n", "<leader>/", MiniExtra.pickers.buf_lines, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader><space>", MiniPick.builtin.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>f.", MiniExtra.pickers.git_files, { desc = "[F]ind [G]it [F]iles" })
vim.keymap.set("n", "<leader>fG", function() MiniPick.builtin.grep_live({ tool = 'git' }) end, { desc = "[F]ind by [G]rep on Git Root" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "[F]ind [b]buffers" })
vim.keymap.set("n", "<leader>fc", MiniExtra.pickers.commands, { desc = "[F]ind [C]ommands" })
vim.keymap.set("n", "<leader>fd", MiniExtra.pickers.diagnostic, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep_live, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>fh", MiniPick.builtin.help, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fr", MiniPick.builtin.resume, { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "[F]ind [E]xplore" })
--DIAGNOSTICS
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

--TOGGLES
vim.keymap.set("n", "<leader>tw",
  function()
    vim.cmd('set wrap!')
    vim.notify("Toggle Line Wrap")
  end, { desc = "[T]oggle [W]rap Lines", silent = true })

vim.keymap.set("n", "<leader>th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay hint enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled({})))
  end, { desc = '[T]oggle [H]int (LSP)' })


vim.keymap.set("n", "<leader>ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. tostring(vim.opt.spell:get()))
  end, { desc = '[T]oggle [S]pell' })

vim.keymap.set("n", "<leader>tc",
  function()
    local old_level = vim.g.conceallevel
    vim.ui.select({ nil, 0, 1, 2, 3 }, {
      prompt = 'Select Conceal Level',
      format_item = function(item)
        return "Conceal Level: " .. tostring(item)
      end,
    }, function(choice)
      vim.g.conceallevel = choice
      vim.notify("Conceal level: " .. tostring(old_level) .. "=>" .. tostring(vim.g.conceallevel))
    end)
  end, { desc = '[T]oggle [C]onceal level' })


-- LSP Attach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.notify("LSP Inlay hint enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled({})))
    local function declaration() MiniExtra.pickers.lsp({ scope = 'declaration' }) end
    local function definition() MiniExtra.pickers.lsp({ scope = 'definition' }) end
    local function document_symbol() MiniExtra.pickers.lsp({ scope = 'document_symbol' }) end
    local function implementation() MiniExtra.pickers.lsp({ scope = 'implementation' }) end
    local function references() MiniExtra.pickers.lsp({ scope = 'references' }) end
    local function type_definition() MiniExtra.pickers.lsp({ scope = 'type_definition' }) end
    local function workspace_symbol() MiniExtra.pickers.lsp({ scope = 'workspace_symbol' }) end

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
    vim.keymap.set('n', '<leader>cd', document_symbol, { buffer = ev.buf, desc = '[C]ode [D]ocument Symbols' })
    --Code Workspace
    vim.keymap.set('n', '<leader>cws', workspace_symbol, { buffer = ev.buf, desc = '[C]ode [W]orkspace [S]ymbols' })
    vim.keymap.set('n', '<leader>cwfa', vim.lsp.buf.add_workspace_folder,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]older [A]dd' })
    vim.keymap.set('n', '<leader>cwfr', vim.lsp.buf.remove_workspace_folder,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]older [R]emove' })
    vim.keymap.set('n', '<leader>cwfl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
      { buffer = ev.buf, desc = '[C]ode [W]orkspace [F]olders [L]ist' })
    -- GoTos
    vim.keymap.set('n', 'gD', declaration, { buffer = ev.buf, desc = '[G]oto [D]eclaration' })
    vim.keymap.set('n', '<leader>gd', type_definition, { buffer = ev.buf, desc = '[G]oto Type [D]efinition' })
    vim.keymap.set('n', 'gI', implementation, { buffer = ev.buf, desc = '[G]oto [I]mplementation' })
    vim.keymap.set('n', 'gd', definition, { buffer = ev.buf, desc = '[G]oto [D]efinition' })
    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { buffer = ev.buf, desc = '[G]oto [R]eferences' })
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', vim.lsp.buf.format,
      { desc = 'Format current buffer with LSP' })
  end,
})
