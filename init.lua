vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.cmd.colorscheme "catppuccin-frappe"

if _G.FormatOnSave == nill then
  _G.FormatOnSave = true
end

-- Creates a server in the cache on boot, useful for Godot
-- https://ericlathrop.com/2024/02/configuring-neovim-s-lsp-to-work-with-godot/
local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

------------------------------------------
--- ROCKS.nvim install
-- nvim -u NORC -c "source https://raw.githubusercontent.com/nvim-neorocks/rocks.nvim/master/installer.lua"
------------------------------------------

vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })
require("mason").setup()
require("mason-lspconfig").setup()

require('mini.ai').setup()
require('mini.colors').setup()
require('mini.diff').setup()
require('mini.extra').setup()
require('mini.files').setup()
require('mini.icons').setup()
require('mini.indentscope').setup()
require('mini.notify').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()

vim.notify = require('mini.notify').make_notify()
local pick = require('mini.pick')
pick.setup()
vim.ui.select = pick.ui_select

local presets = require("markview.presets");
require("markview").setup({
  markdown = {
    headings = presets.headings.arrowed,
    horizontal_rules = presets.horizontal_rules.solid,
    tables = presets.tables.rounded
  },
  preview = {
    hybrid_modes = { "n", "v" },
    edit_range = { 1, 1 }
  }
})

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
-- require("easy-dotnet").setup()
require("nvim-dap-virtual-text").setup()
require('lazydev').setup()
require('blink.cmp').setup({
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    }
  },
  completion = {
    accept = {
      create_undo_point = true
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true }
})

require("image").setup({
  backend = "kitty",
  kitty_method = "normal",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      floating_windows = true
    }
  }
})

--##############################################################################
vim.g.have_nerd_font = true
vim.opt.breakindent = true        --Indent wrapped lines
vim.opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false -- Set highlight on search
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
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true  -- Save undo history
vim.opt.updatetime = 300 -- Decrease update time
vim.opt.wrap = true
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false
})
----------------------------------------------------
-- LaTex Configuration
----------------------------------------------------
vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_continuous = 1               -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1           -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1 -- Enable snippets
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }

----------------------------------------------------
-- AUTO Commands
----------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          if _G.FormatOnSave then
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
          end
        end
      })
    end
  end
})

local og_virt_text
local og_virt_line
vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
  group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', {}),
  callback = function()
    if og_virt_line == nil then
      og_virt_line = vim.diagnostic.config().virtual_lines
    end
    if not (og_virt_line and og_virt_line.current_line) then
      if og_virt_text then
        vim.diagnostic.config({ virtual_text = og_virt_text })
        og_virt_text = nil
      end
      return
    end

    if og_virt_text == nil then
      og_virt_text = vim.diagnostic.config().virtual_text
    end

    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

    if vim.tbl_isempty(vim.diagnostic.get(0, { lnum = lnum })) then
      vim.diagnostic.config({ virtual_text = og_virt_text })
    else
      vim.diagnostic.config({ virtual_text = false })
    end
  end
})

vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('diagnostic_redraw', {}),
  callback = function()
    pcall(vim.diagnostic.show)
  end
})


----------------------------------------------------
-- FUNCTIONS
----------------------------------------------------
function InsertDate()
  local date = os.date("%Y-%m-%d")

  vim.api.nvim_put({ tostring(date) }, "", true, true)
end

vim.api.nvim_create_user_command("InsertDate", InsertDate, {})

----------------------------------------------------
-- KEYMAPS
----------------------------------------------------
local kmap = vim.keymap.set
kmap('n', 'k', 'gk', { silent = true }) -- Word Wrap Fix
kmap('n', 'j', 'gj', { silent = true }) -- Word Wrap Fix
kmap("n", "Q", "<nop>")                 --UNMAP to prevent hard quit
kmap("t", "<Esc>", "<c-\\><c-n>")       -- Escape enters normal mode for terminal
kmap("n", "<c-h>", "<c-w>h", { silent = true })
kmap("n", "<c-j>", "<c-w>j", { silent = true })
kmap("n", "<c-k>", "<c-w>k", { silent = true })
kmap("n", "<c-l>", "<c-w>l", { silent = true })
--BUFFER
kmap("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })
--Move selection up or down
kmap("v", "<C-k>", ":m '<-2<cr>gv=gv")
kmap("v", "<C-j>", ":m '>+1<cr>gv=gv")
--SEARCH AND REPLACE UNDER CURSOR
kmap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Subsitute word" })
--FILE Explorer
kmap("n", "<leader>e", MiniFiles.open, { desc = "Explore files" })
--WINDOW SPLITS
kmap("n", "<Up>", "<C-w>+", { desc = "Resize", silent = true })
kmap("n", "<Down>", "<C-w>-", { desc = "Resize", silent = true })
kmap("n", "<Left>", "<C-w><", { desc = "Resize", silent = true })
kmap("n", "<Right>", "<C-w>>", { desc = "Resize", silent = true })
-- Mini-Pick
kmap("n", "<leader>/", MiniExtra.pickers.buf_lines, { desc = "Fuzzy Grep Buffer" })
kmap("n", "<leader><space>", MiniPick.builtin.files, { desc = "Fuzzy Files" })
kmap("n", "<leader>f.", MiniExtra.pickers.git_files, { desc = "Fuzzy Git Files" })
kmap("n", "<leader>fG", function() MiniPick.builtin.grep_live({ tool = 'git' }) end, { desc = "Grep Git Root" })
kmap("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "Buffers" })
kmap("n", "<leader>fc", MiniExtra.pickers.commands, { desc = "Commands" })
kmap("n", "<leader>fd", MiniExtra.pickers.diagnostic, { desc = "Diagnostics" })
kmap("n", "<leader>fg", MiniPick.builtin.grep_live, { desc = "Grep" })
kmap("n", "<leader>fh", MiniPick.builtin.help, { desc = "Help" })
kmap("n", "<leader>fr", MiniPick.builtin.resume, { desc = "Resume" })
kmap("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "Explorer" })
--DIAGNOSTICS
kmap('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
--INSERT
kmap('n', '<leader>id', InsertDate, { desc = 'Insert Date' })
--TOGGLES
kmap("n", "<leader>tw",
  function()
    vim.cmd('set wrap!')
    vim.notify("Toggle Line Wrap")
  end, { desc = "Toggle Wrap Lines", silent = true })

kmap("n", "<leader>th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay hint enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled({})))
  end, { desc = 'Toggle Hint' })

kmap("n", "<leader>ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. tostring(vim.opt.spell:get()))
  end, { desc = 'Toggle Spell' })

kmap("n", "<leader>tc",
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
  end, { desc = 'Toggle Conceal level' })

kmap("n", "<leader>tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })

-- Debug
local dm = require("debugmaster")
kmap({ "n", "v" }, "<leader>d", dm.mode.toggle, { desc = "Debug Mode", nowait = true })

local imgclip = require('img-clip')
kmap("n", "<leader>p", imgclip.pasteImage, { desc = "Paste Image", silent = true })
