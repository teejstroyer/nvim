-- ===========================================================================
-- TABLE OF CONTENTS:
-- 1. [CORE] Core Configuration (leader, server pipe)
-- 2. [FUNC] Custom Functions (Date, Plugin Updates)
-- 3. [OPTS] Basic Neovim Options
-- 4. [KEYS] General Keymaps
-- 5. [AUTO] Auto Commands
-- 6. [PLUG] Plugin Management & Configuration
--    - UI & Essentials
--    - DAP (Debugging)
--    - Diagnostics
--    - File Explorer (Fyler)
--    - Fuzzy Finder (FZF)
--    - Git Integration
--    - LSP (Language Server Protocol)
--    - Markdown & Tasks
--    - Rndr (3D/Image Preview)
--    - Treesitter
--    - VimTeX (LaTeX)
-- 7. [FINI] Final Setup (UI enable, update check)
-- ===========================================================================

-- ===========================================================================
-- Welcome to Your Neovim Configuration!
-- ===========================================================================
--
-- This file, `init.lua`, is the main entry point for configuring Neovim.
-- It's written in Lua, a lightweight and fast scripting language.

-- ===========================================================================
-- 1. [CORE] Core Configuration
-- ===========================================================================

-- Set the leader key to a space.
vim.g.mapleader = ' '

-- Set the local leader key to a comma.
vim.g.maplocalleader = ','

-- Creates a server in the cache on boot. This can be useful for integrating
-- Neovim with external tools, such as the Godot game engine.
local pipepath = vim.fn.stdpath('cache') .. '/server.pipe'
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

-- ===========================================================================
-- 2. [FUNC] Custom Functions
-- ===========================================================================

-- A custom function to insert the current date in YYYY-MM-DD format.
function InsertDate()
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_put({ tostring(date) }, "", true, true)
end

-- Create a user-defined command called `:InsertDate`.
vim.api.nvim_create_user_command("InsertDate", InsertDate, {})

-- Function to check for plugin updates once a day
function CheckPluginUpdates()
  local state_path = vim.fn.stdpath("data") .. "/plugin_update_time.txt"
  local last_update = 0
  local f = io.open(state_path, "r")
  if f then
    last_update = tonumber(f:read("*all")) or 0
    f:close()
  end

  local current_time = os.time()
  if (current_time - last_update) < (24 * 60 * 60) then
    return
  end

  local updates = {}
  local deletes = {}

  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      table.insert(deletes, plugin.spec.name)
    else
      table.insert(updates, plugin.spec.name)
    end
  end

  if #deletes > 0 then
    vim.pack.del(deletes)
  end

  if #updates > 0 then
    vim.pack.update(updates, { force = true })
  end

  local f_write = io.open(state_path, "w")
  if f_write then
    f_write:write(tostring(current_time))
    f_write:close()
  end
end

-- ===========================================================================
-- 3. [OPTS] Basic Neovim Options
-- ===========================================================================

vim.g.have_nerd_font = true
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.inccommand = 'split'
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.showbreak = "↳"
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.foldenable = false
vim.opt.foldlevel = 99

-- ===========================================================================
-- 4. [KEYS] General Keymaps
-- ===========================================================================

local kmap = vim.keymap.set

kmap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
kmap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
kmap("n", "Q", "<nop>")
kmap("t", "<Esc>", "<c-\\><c-n>")
kmap("n", "<c-h>", "<c-w>h", { silent = true, desc = "Navigate left window" })
kmap("n", "<c-j>", "<c-w>j", { silent = true, desc = "Navigate down window" })
kmap("n", "<c-k>", "<c-w>k", { silent = true, desc = "Navigate up window" })
kmap("n", "<c-l>", "<c-w>l", { silent = true, desc = "Navigate right window" })

-- --- Buffer Management ---
kmap("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })

-- --- Visual Mode ---
kmap("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
kmap("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- --- Search and Replace ---
kmap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- --- Window Management ---
kmap("n", "<Up>", "<C-w>+", { desc = "Increase window height", silent = true })
kmap("n", "<Down>", "<C-w>-", { desc = "Decrease window height", silent = true })
kmap("n", "<Left>", "<C-w><", { desc = "Decrease window width", silent = true })
kmap("n", "<Right>", "<C-w>>", { desc = "Increase window width", silent = true })

-- --- Diagnostics ---
kmap('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- --- Insert Mode ---
kmap('i', '<c-d>', InsertDate, { desc = 'Insert Date' })

-- --- Toggles ---
kmap("n", "<leader>Tw",
  function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify("Line Wrap: " .. (vim.opt.wrap:get() and "On" or "Off"))
  end, { desc = "Toggle Wrap Lines", silent = true })

kmap("n", "<leader>Th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay Hints: " .. (vim.lsp.inlay_hint.is_enabled({}) and "On" or "Off"))
  end, { desc = 'Toggle Inlay Hints' })

kmap("n", "<leader>Ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. (vim.opt.spell:get() and "On" or "Off"))
  end, { desc = 'Toggle Spell Check' })

kmap("n", "<leader>Tc",
  function()
    local old_level = vim.g.conceallevel
    vim.ui.select({ nil, 0, 1, 2, 3 }, {
      prompt = 'Select Conceal Level',
      format_item = function(item)
        return "Conceal Level: " .. tostring(item)
      end,
    }, function(choice)
      vim.g.conceallevel = choice
      vim.notify("Conceal level: " .. tostring(old_level) .. " => " .. tostring(vim.g.conceallevel))
    end)
  end, { desc = 'Toggle Conceal Level' })

kmap("n", "<leader>Tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })

-- ===========================================================================
-- 5. [AUTO] Auto Commands
-- ===========================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "markdown" then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", { clear = true }),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

-- ===========================================================================
-- 6. [PLUG] Plugin Management and Configuration
-- ===========================================================================

vim.cmd [[colorscheme retrobox]]

vim.pack.add({
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/shorya-1012/buffer_walker.nvim',
  'https://github.com/HakonHarnes/img-clip.nvim',
  'https://github.com/nvim-lualine/lualine.nvim'
})

require('lualine').setup({ options = { theme = "gruvbox" } })
require('nvim-web-devicons').setup()

vim.keymap.set("n", "<leader>p", require('img-clip').pasteImage, { desc = "Paste Image from Clipboard", silent = true })
vim.keymap.set("n", "<leader>[", ":MoveBack<CR>", { silent = true })
vim.keymap.set("n", "<leader>]", ":MoveForward<CR>", { silent = true })

local whichKey = require("which-key")
whichKey.add({
  { "<leader>g", group = "Git" },
  { "<leader>f", group = "Find" },
  { "<leader>T", group = "Toggle" },
  { "<leader>t", group = "Task" },
  { "<leader>x", group = "Test" },
  { "gr",        group = "LSP Actions" },
})

-- --- DAP (Debug Adapter Protocol) ---
vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
})
require("nvim-dap-virtual-text").setup()
vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

-- --- Tiny Inline Diagnostic ---
vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })
require("tiny-inline-diagnostic").setup()
vim.diagnostic.config({
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN]  = "○",
      [vim.diagnostic.severity.HINT]  = "󰌶",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
})

-- --- Fyler (File Explorer) ---
vim.pack.add({
  { src = "https://github.com/A7Lavinraj/fyler.nvim", version = 'stable' }
})
local fyler = require('fyler')
vim.keymap.set("n", "<leader>e", function() fyler.open({ kind = "split_left_most" }) end, { desc = "Open fyler View" })
fyler.setup({
  integrations = { icon = "nvim_web_devicons" },
  views = { finder = { close_on_select = true, default_explorer = true } },
})

-- --- FZF (Fuzzy Finder) ---
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/elanmed/fzf-lua-frecency.nvim'
})
local fzf = require('fzf-lua')
fzf.register_ui_select()
local fzfr = require('fzf-lua-frecency')
vim.keymap.set("n", "<leader>F", ":FzfLua<CR>", { desc = "FZF Lua" })
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
vim.keymap.set("n", "<leader><space>", function() fzfr.frecency({ cwd_only = true, }) end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find grep" })
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find helptags" })
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Find diagnostics_document" })
vim.keymap.set("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Find diagnostics_workspace" })
vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Find resume" })
vim.keymap.set("n", "<leader>/", fzf.lines, { desc = "Find lines" })

-- --- Git ---
vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})
local gitsigns = require('gitsigns')
local diffview = require('diffview')
local neogit = require('neogit')
vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Git blame" })
vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "Git blame file" })
vim.keymap.set("n", "<leader>gd", diffview.open, { desc = "Git diff this" })
vim.keymap.set("n", "<leader>gt", neogit.open, { desc = "Git UI (Tab)" })
vim.keymap.set("n", "<leader>gs", function() neogit.open({ kind = "auto" }) end, { desc = "Git UI(Split)" })

-- --- LSP (Language Server Protocol) ---
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/antonk52/filepaths_ls.nvim',
  'https://github.com/seblyng/roslyn.nvim',
  "https://github.com/Mathijs-Bakker/godotdev.nvim",
})
vim.lsp.enable('dartls')
require("godotdev").setup()
require('lazydev').setup()
require('mason').setup({
  registries = {
    'github:Crashdummyy/mason-registry',
    'github:mason-org/mason-registry',
  }
})
require('mason-lspconfig').setup({
  ensure_installed = { "lua_ls", "copilot" },
  automatic_enable = true,
})
vim.lsp.enable('filepaths_ls')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method('textDocument/completion') then
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

-- --- Markview (Markdown Preview) and Task ---
vim.pack.add({
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/teejstroyer/task.nvim",
})
local presets = require("markview.presets");
require("markview").setup({
  markdown = {
    headings = presets.headings.arrowed,
    horizontal_rules = presets.horizontal_rules.solid,
    tables = presets.tables.rounded
  },
  preview = { hybrid_modes = { "n", "v" }, edit_range = { 1, 1 } },
  experimental = { check_rtp = false }
})

-- TASK, my custom plugin
local tasks = require("task")
tasks.setup({
  sections = {
    todo      = { label = "Todo", check_style = "[ ]", order = 1, color = "#ff9e64" },
    doing     = { label = "In Progress", check_style = "[/]", order = 2, color = "#7aa2f7" },
    done      = { label = "Completed", check_style = "[x]", order = 3, color = "#9ece6a" },
    archive   = { label = "Archive", check_style = "[b]", style = "~~", order = 4, color = "#565f89" },
    cancelled = { label = "Cancelled", check_style = "[-]", style = "~~", order = 5, color = "#444b6a" },
    wont      = { label = "Wont Do", check_style = "[d]", style = "~~", order = 6, color = "#f7768e" },
    idea      = { label = "Proposals", check_style = "[I]", style = "", order = 7, color = "#f7768e" },
  },
  highlights = { metadata = { fg = "#565f89", italic = true } },
  types = {
    bug  = { style = "**", color = "#f7768e" },
    feat = { style = "_", color = "#bb9af7" },
    task = { style = "", color = "#7aa2f7" }
  },
  date_format = "%Y-%m-%d",
  default_type = "TASK"
})
vim.keymap.set('n', '<leader>tn', function() tasks.new_task('task') end, { desc = "Task: Quick New (default type)" })
vim.keymap.set('n', '<leader>tN', function()
  vim.ui.input({ prompt = "Task Type: " }, function(input) tasks.new_task(input) end)
end, { desc = "Task: New (Prompt for Type)" })
vim.keymap.set({ 'n', 'v' }, '<leader>tb', function() tasks.move_task("todo") end, { desc = "Task:Backlog" })
vim.keymap.set({ 'n', 'v' }, '<leader>tp', function() tasks.move_task("doing") end, { desc = "Task:Progress" })
vim.keymap.set({ 'n', 'v' }, '<leader>td', function() tasks.move_task("done") end, { desc = "Task:Completed" })
vim.keymap.set({ 'n', 'v' }, '<leader>ta', function() tasks.move_task("archive") end, { desc = "Task:Archive" })
vim.keymap.set({ 'n', 'v' }, '<leader>tw', function() tasks.move_task("wont") end, { desc = "Task:Wont Do" })
vim.keymap.set({ 'n', 'v' }, '<leader>tc', function() tasks.move_task("cancelled") end, { desc = "Task:Cancelled" })
vim.keymap.set({ 'n', 'v' }, '<leader>t<space>', function() tasks.select_move() end, { desc = "Task: Move" })

-- --- Rndr (3D/Image Preview) ---
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'rndr.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end
})
vim.pack.add({ "https://github.com/SalarAlo/rndr.nvim" })
require("rndr").setup({ preview = { auto_open = true } })

-- --- Treesitter ---
vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "*",
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.spec.kind ~= "deleted" then
      vim.notify("Updating Treesitter Parsers...")
      vim.cmd("TSUpdate")
    end
  end,
})
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  'https://github.com/nvim-treesitter/nvim-treesitter-context'
})
local ts = require('nvim-treesitter')
ts.install({ 'lua', 'c_sharp', 'vim', 'vimdoc', 'query', 'nix' })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if ft == "mininotify" or ft == "minipick" or ft == "minifiles" or ft == "" then return end
    if not lang then return end
    if not vim.tbl_contains(ts.get_available(), lang) then return end
    local has_parser = pcall(vim.treesitter.get_parser, bufnr, lang)
    if not has_parser then
      ts.install(lang)
      return
    end
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
  end,
})

-- --- VimTeX (LaTeX Support) ---
vim.pack.add({ "https://github.com/lervag/vimtex" })
vim.g.tex_flavor = 'latex'
vim.g.vimtex_compiler_progname = 'latexmk'
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_continuous = 1
vim.g.vimtex_view_automatic = 1
vim.g.vimtex_snippets_enable_autoload = 1
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }

-- ===========================================================================
-- 7. [FINI] Final Setup
-- ===========================================================================

require('vim._core.ui2').enable({})

-- UPDATE AND CLEANUP PLUGINS
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = CheckPluginUpdates,
})
