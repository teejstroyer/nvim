vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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
-- require('mini.surround').setup()
-- require('mini.completion').setup()
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
    { mode = 'i', keys = '<C-x><C-f>',  desc = 'File names' },
    { mode = 'i', keys = '<C-x><C-l>',  desc = 'Whole lines' },
    { mode = 'i', keys = '<C-x><C-o>',  desc = 'Omni completion' },
    { mode = 'i', keys = '<C-x><C-s>',  desc = 'Spelling suggestions' },
    { mode = 'i', keys = '<C-x><C-u>',  desc = "With 'completefunc'" },
    { mode = 'n', keys = '<leader>c',   desc = "Code" },
    { mode = 'n', keys = '<leader>cw',  desc = "Code Workspace" },
    { mode = 'n', keys = '<leader>cwf', desc = "Code Workspace Folder" },
    { mode = 'n', keys = '<leader>t',   desc = "Toggle" },
    { mode = 'n', keys = '<leader>f',   desc = "Find" },
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
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ---@diagnostic disable-next-line: missing-fields
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
    -- add lazydev to your completion providers
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
      },
    }
  },
  completion = {
    list = {
      selection = function(ctx)
        return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect'
      end
    },
    accept = {
      create_undo_point = true
    }

  }
})

---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
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
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")       -- Escape enters normal mode for terminal
--BUFFER
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })
vim.keymap.set("n", "<leader>l", ":bnext<CR>", { desc = "Buffer next" })
vim.keymap.set("n", "<leader>h", ":bprevious<CR>", { desc = "Buffer previous" })
--Move selection up or down
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv")
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv")
--SEARCH AND REPLACE UNDER CURSOR
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Subsitute word" })
--FILE Explorer
vim.keymap.set("n", "<leader>e", MiniFiles.open, { desc = "Explore files" })
--WINDOW SPLITS
vim.keymap.set("n", "<Up>", "<C-w>+", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Down>", "<C-w>-", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Left>", "<C-w><", { desc = "Resize", silent = true })
vim.keymap.set("n", "<Right>", "<C-w>>", { desc = "Resize", silent = true })
-- Mini-Pick
vim.keymap.set("n", "<leader>/", MiniExtra.pickers.buf_lines, { desc = "Fuzzy Grep Buffer" })
vim.keymap.set("n", "<leader><space>", MiniPick.builtin.files, { desc = "Fuzzy Files" })
vim.keymap.set("n", "<leader>f.", MiniExtra.pickers.git_files, { desc = "Fuzzy Git Files" })
vim.keymap.set("n", "<leader>fG", function() MiniPick.builtin.grep_live({ tool = 'git' }) end, { desc = "Grep Git Root" })
vim.keymap.set("n", "<leader>fb", MiniPick.builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", MiniExtra.pickers.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>fd", MiniExtra.pickers.diagnostic, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fg", MiniPick.builtin.grep_live, { desc = "Grep" })
vim.keymap.set("n", "<leader>fh", MiniPick.builtin.help, { desc = "Help" })
vim.keymap.set("n", "<leader>fr", MiniPick.builtin.resume, { desc = "Resume" })
vim.keymap.set("n", "<leader>fe", MiniExtra.pickers.explorer, { desc = "Explorer" })
--DIAGNOSTICS
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Diagnostic prev' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Diagnostic next' })
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

--TOGGLES
vim.keymap.set("n", "<leader>tw",
  function()
    vim.cmd('set wrap!')
    vim.notify("Toggle Line Wrap")
  end, { desc = "Toggle Wrap Lines", silent = true })

vim.keymap.set("n", "<leader>th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay hint enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled({})))
  end, { desc = 'Toggle Hint' })

vim.keymap.set("n", "<leader>ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. tostring(vim.opt.spell:get()))
  end, { desc = 'Toggle Spell' })

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
  end, { desc = 'Toggle Conceal level' })

-- LSP Attach autocmd
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.notify("LSP Inlay hint enabled: " .. tostring(vim.lsp.inlay_hint.is_enabled({})))
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local lsp = vim.lsp.buf
    local kmap = vim.keymap.set

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
