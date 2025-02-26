vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.cmd.colorscheme "catppuccin-frappe"

-- Creates a server in the cache  on boot, useful for Godot
-- https://ericlathrop.com/2024/02/configuring-neovim-s-lsp-to-work-with-godot/
local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

------------------------------------------
------------------------------------------
--Rocks.nvim install
do
  local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")
  local rocks_config = { rocks_path = vim.fs.normalize(install_location), }

  vim.g.rocks_nvim = rocks_config

  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
  vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim",
    "*"))
end

-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
  local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")

  if not vim.uv.fs_stat(rocks_location) then
    -- Pull down rocks.nvim
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/nvim-neorocks/rocks.nvim",
      rocks_location,
    })
  end

  -- If the clone was successful then source the bootstrapping script
  assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")
  vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))
  vim.fn.delete(rocks_location, "rf")
end

------------------------------------------
------------------------------------------

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



require("null-ls").setup()
require('mason').setup()
---@diagnostic disable-next-line: assign-type-mismatch
require("mason-null-ls").setup({ ensure_installed = nil, automatic_installation = true })
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup()

local server_configs = {
  lua_ls = {
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
}

mason_lspconfig.setup_handlers {
  function(server_name) -- default handler (optional)
    local config = server_configs[server_name] or {};
    config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities or {})

    require("lspconfig")[server_name].setup(config)
  end,
}

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

require("image").setup(
  {
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        floating_windows = true, --
      }
    }
  }
)

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20

--##############################################################################
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
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true  -- Save undo history
vim.opt.updatetime = 300 -- Decrease update time
vim.opt.wrap = true

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
-- FUNCTIONS
----------------------------------------------------
function InsertDate()
  local date = os.date("%Y-%m-%d")

  vim.api.nvim_put({ date }, "", true, true)
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
kmap("n", "<leader>l", ":bnext<CR>", { desc = "Buffer next" })
kmap("n", "<leader>h", ":bprevious<CR>", { desc = "Buffer previous" })
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
kmap('n', '[d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Diagnostic prev' })
kmap('n', ']d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Diagnostic next' })
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


-- LSP Attach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local lsp = vim.lsp.buf

    --Staple Keymap
    kmap('n', 'K', lsp.hover, { buffer = ev.buf, silent = true, desc = 'Hover Documentation' })
    --Code
    kmap({ 'n', 'v' }, '<leader>ca', lsp.code_action, { buffer = ev.buf, silent = true, desc = 'Code Action' })
    kmap('n', '<leader>cr', lsp.rename, { buffer = ev.buf, silent = true, desc = 'Rename' })
    kmap('n', '<leader>cf', lsp.format, { buffer = ev.buf, silent = true, desc = 'Format' })
    kmap('n', '<leader>cs', lsp.signature_help, { buffer = ev.buf, silent = true, desc = 'Signature Documentation' })
    kmap('n', '<leader>cd', lsp.document_symbol, { buffer = ev.buf, silent = true, desc = 'Document Symbols' })
    --Code Workspace
    kmap('n', '<leader>cws', lsp.workspace_symbol, { buffer = ev.buf, silent = true, desc = 'Workspace Symbols' })
    kmap('n', '<leader>cwfa', lsp.add_workspace_folder, { buffer = ev.buf, silent = true, desc = 'Folder Add' })
    kmap('n', '<leader>cwfr', lsp.remove_workspace_folder, { buffer = ev.buf, silent = true, desc = 'Folder Remove' })
    kmap('n', '<leader>cwfl', lsp.list_workspace_folders, { buffer = ev.buf, silent = true, desc = 'Folders List' })
    -- GoTos
    kmap('n', 'gD', lsp.declaration, { buffer = ev.buf, silent = true, desc = 'Goto Declaration' })
    kmap('n', 'gdt', lsp.type_definition, { buffer = ev.buf, silent = true, desc = 'Goto Type Definition' })
    kmap('n', 'gI', lsp.implementation, { buffer = ev.buf, silent = true, desc = 'Goto Implementation' })
    kmap('n', 'gdd', lsp.definition, { buffer = ev.buf, silent = true, desc = 'Goto Definition' })
    kmap('n', 'grr', lsp.references, { buffer = ev.buf, silent = true, desc = 'Goto References' })
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(ev.buf, 'Format', lsp.format, { desc = 'Format current buffer with LSP' })
  end,
})
