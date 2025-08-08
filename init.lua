-- ===========================================================================
-- Welcome to Your Neovim Configuration!
-- ===========================================================================
--
-- This configuration requires nvim 0.12 or later, you may install it via brew install neovim --HEAD
-- Once installed, make sure add this init.lua file to ~/.config/nvim/
--
-- This file, `init.lua`, is the main entry point for configuring Neovim.
-- It's written in Lua, a lightweight and fast scripting language.
--
-- To get started, it is highly recommended to run the built-in tutorial.
-- In Neovim, press the <Escape> key, then type `:Tutor` and press <Enter>.
--
--
--  Vim and Neovim use a special notation to represent key presses in configuration files. This
--  allows you to map complex key combinations to commands.
--
--  Common Modifiers:
--
--   * `<c-` or `<C-`: Represents the Control key.
--       * Example: <c-s> means holding Ctrl and pressing s.
--
--   * `<a-` or `<M-`: Represents the Alt key (also called the Meta key).
--       * Example: <a-j> means holding Alt and pressing j.
--
--   * `<s-` or `<S-`: Represents the Shift key.
--       * Example: <s-tab> means holding Shift and pressing Tab.
--
--   * `<leader>`: A special, user-defined prefix key. In your configuration, it's set to the Space
--     bar. It's used to create custom shortcuts without overriding built-in ones.
--       * Example: <leader>q means pressing Space then q.
--
--  Special Keys:
--
--   * `<CR>`: Carriage Return (the Enter or Return key).
--   * `<Esc>`: The Escape key.
--   * `<Space>`: The spacebar.
--   * `<Tab>`: The Tab key.
--   * `<nop>`: "No Operation". This is used to disable a default keybinding.
--
--  Putting It Together
--
--  for example you'll see something like:
--
--   vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })
--
--   * `"n"`: This command applies in normal mode.
--   * `"<leader>q"`: The key combination is Space followed by q.
--   * `":bdelete<CR>"`: When you press the keys, Neovim will execute the command :bdelete and then
--     simulate pressing Enter (<CR>).
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- This configuration is structured into several sections:
-- 1. Core Configuration: Basic settings and global variables.
-- 2. Plugin Management: How plugins are installed and managed.
-- 3. Neovim Options: Fundamental settings for Neovim's behavior and appearance.
-- 4. Keymaps: Custom keyboard shortcuts for faster workflows.
-- 5. Auto Commands: Automations that trigger on specific events.
--
-- You can navigate this file to learn how each part of the configuration works.
-- Pay attention to the comments, as they provide context and instructions.
-- ===========================================================================

-- ===========================================================================
-- Core Configuration
-- ===========================================================================

-- Set the leader key to a space. This is a common practice that makes keymaps
-- easier to type. The leader key is a prefix for custom keybindings. For example,
-- if you set a mapping to "<leader>f", you would type " (space) f" to trigger it.
vim.g.mapleader = ' '

-- Set the local leader key to a comma. This is similar to the leader key but is
-- intended for mappings that are specific to a certain file type or context.
vim.g.maplocalleader = ','

-- Creates a server in the cache on boot. This can be useful for integrating
-- Neovim with external tools, such as the Godot game engine.
-- For more details, see: https://ericlathrop.com/2024/02/configuring-neovim-s-lsp-to-work-with-godot/
local pipepath = vim.fn.stdpath('cache') .. '/server.pipe'
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

-- ===========================================================================
-- Plugin Management
-- ===========================================================================
-- Neovim has a built-in package manager that makes it easy to install plugins.
-- The following lines use `vim.pack.add` to declare the plugins you want to use.
-- On the first load, Neovim will automatically download and install them.
--
-- To learn more about the built-in package manager, use the help command:
-- :h vim.pack
--
-- You can also use `:h <command>` to get help on any other Neovim command.
--
-- **********************************************************************************
-- For any plugin you see in this config, you will notice a github repository.
-- Read the repository to learn more about the plugin. You can press gx, while on a link to open it
-- **********************************************************************************

-- --- Color Scheme ---
-- The Catppuccin plugin provides a beautiful and modern color scheme.
vim.pack.add({
  'https://github.com/catppuccin/nvim',
})
-- Set the color scheme to 'catppuccin-frappe' once the plugin is loaded.
vim.cmd [[colorscheme catppuccin-frappe]]

-- --- Which-Key Plugin ---
-- Which-Key is a popular plugin that shows a popup with available keymaps
-- after you press a key (like the leader key). This is incredibly helpful for
-- discovering and remembering your keybindings.
--
-- Experiment by pressing keys like `g`, `z`, `<Space>`, etc.
vim.pack.add({
  'https://github.com/folke/which-key.nvim',
  -- Plenary.nvim is a utility library that many other plugins depend on.
  -- It provides useful functions for things like file paths and shell commands.
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})

-- --- LSP and Completion ---
-- These plugins provide powerful features for code completion, diagnostics,
-- and other language server protocol (LSP) functionality.
--
-- - **blink.cmp**: An autocompletion plugin.
-- - **nvim-lspconfig**: A collection of configurations for different language servers.
-- - **mason.nvim**: A tool for easily installing and managing LSP servers, linters, and formatters.
-- - **mason-lspconfig.nvim**: Bridges Mason and nvim-lspconfig, making it easy to set up language servers.
-- - **none-ls.nvim**: Provides a way to use non-LSP sources (like linters or formatters) with the Neovim LSP client.
-- - **lazydev.nvim**: Integrates with blink.cmp to provide completions for Neovim's Lua API.
--
-- To install language servers (e.g., for Python, TypeScript, etc.), run:
-- :Mason<Enter>
-- This will open a window where you can manage your language servers.

vim.pack.add({
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/folke/lazydev.nvim',
  { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range('1.*') },
})

-- After adding the plugins, `require()` is used to load and configure them.
require('lazydev').setup()
require('mason').setup()
require('mason-lspconfig').setup(
  {
    ensure_installed = { "lua_ls" },
  })

-- Configure blink.cmp, specifying the sources it should use for completion.
-- By default <c-n> => next <c-p> => previous, <c-y> accepts
require('blink.cmp').setup({
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
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

-- This is a generic configuration for LSP capabilities. It ensures that
-- your LSP client has the necessary features enabled to interact with servers.
vim.lsp.config('*', { capabilities = vim.lsp.protocol.make_client_capabilities() })

-- --- nvim-treesitter ---
-- Treesitter provides more accurate and performant syntax highlighting,
-- indentation, and other language-aware features.
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master",
  },
  'https://github.com/nvim-treesitter/nvim-treesitter-context'
})

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  -- To add support for more languages, run `:TSInstall <language>`
  -- or add the language to the `ensure_installed` list below.
  ensure_installed = {
    'lua', 'c_sharp'
  },
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

-- --- Markview Plugin ---
-- This plugin provides a live preview of Markdown files, which is useful for
-- writing and editing documentation.
vim.pack.add({ "https://github.com/OXY2DEV/markview.nvim" })
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

-- ===========================================================================
-- Basic Neovim Options
-- ===========================================================================
-- The following lines use `vim.opt` to set basic Neovim options.
-- These are the fundamental settings that control how Neovim looks and behaves.

-- `vim.g.have_nerd_font` is a global variable that tells other plugins that a
-- Nerd Font is available. Nerd Fonts provide special icons and symbols.
vim.g.have_nerd_font = true

-- Enable mouse support in all modes. This allows you to use the mouse
-- to navigate, resize windows, and select text.
vim.opt.mouse = 'a'

-- When a long line wraps, indent the wrapped portion to match the indentation
-- of the original line.
vim.opt.breakindent = true

-- Connect Neovim's clipboard to the system clipboard. The `unnamedplus`
-- option uses the system clipboard register "+".
vim.opt.clipboard = 'unnamedplus'

-- Set a vertical column at character 120 to act as a guide for line length.
vim.opt.colorcolumn = "120"

-- Configure the behavior of the completion menu.
-- `menuone`: Show the completion menu even if there's only one item.
-- `fuzzy`: Enable fuzzy matching.
-- `popup`: Show completions in a popup window.
-- `noselect`: Don't pre-select an item in the completion menu.
-- `preview`: Show a preview of the selected completion.
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'

-- Highlight the line where the cursor is.
vim.opt.cursorline = true

-- Use spaces instead of tabs.
vim.opt.expandtab = true

-- Disable highlighting for search results once the cursor moves or a new search begins.
vim.opt.hlsearch = false

-- Use a split window for the `substitute` command, showing changes as you type.
vim.opt.inccommand = 'split'

-- Highlight search results as you type.
vim.opt.incsearch = true

-- Wrap lines at a convenient point (like a space) instead of mid-word.
vim.opt.linebreak = true

-- Show special characters like tabs and trailing spaces.
vim.opt.list = true

-- Display line numbers.
vim.opt.number = true

-- Display line numbers relative to the current cursor position.
-- This is useful for navigation with commands like `5j` to jump down five lines.
vim.opt.relativenumber = true

-- Keep at least 10 lines of context above and below the cursor when scrolling.
vim.opt.scrolloff = 10

-- The number of spaces a tab or indent level counts as.
vim.opt.shiftwidth = 2

-- Define the symbol to display when a line wraps.
vim.opt.showbreak = "↳"

-- Control how the sign column is displayed. It shows symbols for things like
-- diagnostics or breakpoints. `number` makes the sign column share space with
-- the number column.
vim.opt.signcolumn = "number"

-- Enable smart case-sensitive searching. If your search query contains
-- an uppercase letter, the search will be case-sensitive. Otherwise, it will be
-- case-insensitive.
vim.opt.smartcase = true

-- Automatically indent new lines.
vim.opt.smartindent = true

-- The number of spaces for a soft tabstop. This is the amount of whitespace
-- added when you press the Tab key (if `expandtab` is on).
vim.opt.softtabstop = 2

-- Set the language for the spell checker.
vim.opt.spelllang = 'en_us'

-- Configure spell check options, such as treating camelCase as a single word.
vim.opt.spelloptions = "camel"

-- Disable swap files. Swap files can be useful for crash recovery but can
-- cause issues with some plugins.
vim.opt.swapfile = false

-- The number of spaces a tab character is displayed as.
vim.opt.tabstop = 2

-- Enable true color support, which is needed for most modern color schemes.
vim.opt.termguicolors = true

-- The time in milliseconds Neovim waits for a key sequence to complete
-- before assuming you've finished typing. This affects keybindings with a
-- prefix like `<leader>`.
vim.opt.timeoutlen = 300

-- Save undo history to a file, so you can undo changes even after closing
-- and reopening a file.
vim.opt.undofile = true

-- Decrease the update time for events like `CursorHold`. This makes
-- features like autocompletion and diagnostics feel more responsive.
vim.opt.updatetime = 300

-- Enable line wrapping.
vim.opt.wrap = true

-- Configure how diagnostic messages (errors, warnings, etc.) are displayed.
vim.diagnostic.config({
  -- Don't show diagnostic messages as virtual text at the end of a line.
  virtual_text = false,
  -- Show diagnostic messages on the current line as a virtual line below it.
  virtual_lines = { current_line = true },
  -- Underline words with diagnostic issues.
  underline = true,
  -- Don't update diagnostics while in insert mode to avoid distraction.
  update_in_insert = false
})

--Provides tooling needed for latex
vim.pack.add({
  "https://github.com/lervag/vimtex",
})
vim.g.tex_flavor = 'latex'                 -- Default tex file format
vim.g.vimtex_compiler_progname = 'latexmk' -- Set compiler (optional)
vim.g.vimtex_view_method = 'skim'          -- Set viewer (optional)
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_continuous = 1               -- Enable continuous compilation
vim.g.vimtex_view_automatic = 1           -- Automatically open PDF viewer
vim.g.vimtex_snippets_enable_autoload = 1 -- Enable snippets
vim.g.vimtex_compiler_latexmk = { out_dir = 'out' }


-- ===========================================================================
-- KEYMAPS
-- ===========================================================================
-- Keymaps are custom shortcuts that streamline your workflow.
-- `vim.keymap.set` is used to define them. The first argument is the mode
-- ('n' for normal, 'i' for insert, 'v' for visual, etc.), followed by the
-- key combination, the command to execute, and optional parameters like `desc`.
--
--

local kmap = vim.keymap.set

-- --- General Navigation and Editing ---
kmap('n', 'k', 'gk', { silent = true }) -- Word Wrap Fix: 'k' moves up by visual line
kmap('n', 'j', 'gj', { silent = true }) -- Word Wrap Fix: 'j' moves down by visual line
kmap("n", "Q", "<nop>")                 -- Unmap 'Q' to prevent accidental exit
kmap("t", "<Esc>", "<c-\\><c-n>")       -- In terminal mode, <Esc> enters normal mode
kmap("n", "<c-h>", "<c-w>h", { silent = true, desc = "Navigate left window" })
kmap("n", "<c-j>", "<c-w>j", { silent = true, desc = "Navigate down window" })
kmap("n", "<c-k>", "<c-w>k", { silent = true, desc = "Navigate up window" })
kmap("n", "<c-l>", "<c-w>l", { silent = true, desc = "Navigate right window" })

-- --- Buffer Management ---
kmap("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })

-- --- Visual Mode ---
-- Move selected lines up or down
kmap("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
kmap("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- --- Search and Replace ---
-- Search and replace the word under the cursor
kmap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- --- File Explorer ---
-- mini.nvim provides a simple and effective file explorer.
-- To learn more about mini.nvim, press 'gx' over the URL below.
-- We are using mini.files, but there are many other modules available.
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })
require('mini.files').setup()
--This plugin adds a tab bar to the top of your screen
require('mini.tabline').setup()
kmap("n", "<leader>e", function() require('mini.files').open() end, { desc = "Explore files" })

-- --- Window Management ---
kmap("n", "<Up>", "<C-w>+", { desc = "Increase window height", silent = true })
kmap("n", "<Down>", "<C-w>-", { desc = "Decrease window height", silent = true })
kmap("n", "<Left>", "<C-w><", { desc = "Decrease window width", silent = true })
kmap("n", "<Right>", "<C-w>>", { desc = "Increase window width", silent = true })

--Fzf, a fuzzy finding picker, useful for finding open buffers, files, other commands etc
vim.pack.add({ 'https://github.com/ibhagwan/fzf-lua' })
local fzf = require('fzf-lua')
kmap("n", "<leader><space>", ":FzfLua<CR>", { desc = "Find Grep Buffer" })
kmap("n", "<leader>ff", fzf.files, { desc = "Find files" })
kmap("n", "<leader>fc", fzf.commands, { desc = "Find commands" })
kmap("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
kmap("n", "<leader>fg", fzf.grep, { desc = "Find grep" })
kmap("n", "<leader>fh", fzf.helptags, { desc = "Find helptags" })
kmap("n", "<leader>fd", fzf.diagnostics_document, { desc = "Find diagnostics_document" })
kmap("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Find diagnostics_workspace" })
kmap("n", "<leader>fr", fzf.resume, { desc = "Find resume" })
kmap("n", "<leader>/", fzf.lines, { desc = "Find lines" })

-- --- Diagnostics ---
kmap('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- --- Insert Mode ---
-- A custom function to insert the current date.
function InsertDate()
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_put({ tostring(date) }, "", true, true)
end

-- Create a user command to call the function.
vim.api.nvim_create_user_command("InsertDate", InsertDate, {})
-- Map <C-d> in insert mode to insert the date.
kmap('i', '<c-d>', InsertDate, { desc = 'Insert Date' })

-- --- Toggles ---
-- These keymaps toggle common settings on and off.
kmap("n", "<leader>tw",
  function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify("Line Wrap: " .. (vim.opt.wrap:get() and "On" or "Off"))
  end, { desc = "Toggle Wrap Lines", silent = true })

kmap("n", "<leader>th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay Hints: " .. (vim.lsp.inlay_hint.is_enabled({}) and "On" or "Off"))
  end, { desc = 'Toggle Inlay Hints' })

kmap("n", "<leader>ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. (vim.opt.spell:get() and "On" or "Off"))
  end, { desc = 'Toggle Spell Check' })

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
      vim.notify("Conceal level: " .. tostring(old_level) .. " => " .. tostring(vim.g.conceallevel))
    end)
  end, { desc = 'Toggle Conceal Level' })

kmap("n", "<leader>tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })

-- --- Image Pasting ---
vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })
kmap("n", "<leader>p", require('img-clip').pasteImage, { desc = "Paste Image from Clipboard", silent = true })

-- ===========================================================================
-- AUTO COMMANDS
-- ===========================================================================
-- Auto commands, or `autocmd`s, are a way to automate tasks based on events.
-- They tell Neovim to execute a command whenever a specific event occurs,
-- such as a file being saved (`BufWritePre`).
--
-- The recommended way to define an autocmd in Lua is using
-- `vim.api.nvim_create_autocmd`.

-- --- Treesitter Update Handler ---
-- Automatically runs `:TSUpdate` when the nvim-treesitter plugin is updated.
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Handle nvim-treesitter updates',
  group = vim.api.nvim_create_augroup('nvim-treesitter-pack-changed-update-handler', { clear = true }),
  callback = function(event)
    if event.data.kind == 'update' then
      vim.notify('nvim-treesitter updated, running TSUpdate...', vim.log.levels.INFO)
      ---@diagnostic disable-next-line: param-type-mismatch
      local ok = pcall(vim.cmd, 'TSUpdate')
      if ok then
        vim.notify('TSUpdate completed successfully!', vim.log.levels.INFO)
      else
        vim.notify('TSUpdate command not available yet, skipping', vim.log.levels.WARN)
      end
    end
  end,
})

-- --- Highlight Yanked Text ---
-- Briefly highlights the text that you have just yanked (copied).
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

-- --- Remove Trailing Whitespace ---
-- Automatically remove trailing whitespace from a file when it's saved.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- --- Terminal Settings ---
-- When a terminal is opened, set local options for a better experience.
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", { clear = true }),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

-- --- Format on Save ---
-- This autocmd sets up automatic formatting on save.
-- It works by creating a `BufWritePre` event listener *only* when a language

-- server that supports formatting is attached to a buffer.
if _G.FormatOnSave == nil then
  _G.FormatOnSave = true
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp.format_on_save', { clear = true }),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp.format_on_save', { clear = false }),
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

-- --- Advanced Diagnostic Control ---
-- This autocmd is a clever way to make diagnostics less visually noisy.
-- It ensures that diagnostic virtual text (the full error message) is only
-- hidden on the current line if there is a virtual line shown for it. This
-- prevents you from seeing the same error message twice.
local og_virt_text
local og_virt_line
vim.api.nvim_create_autocmd({ 'CursorMoved', 'DiagnosticChanged' }, {
  group = vim.api.nvim_create_augroup('diagnostic_only_virtlines', { clear = true }),
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

-- --- Redraw Diagnostics on Mode Change ---
-- This ensures that diagnostics are updated and displayed correctly
-- when you switch from Insert mode to Normal mode.
vim.api.nvim_create_autocmd('ModeChanged', {
  group = vim.api.nvim_create_augroup('diagnostic_redraw', { clear = true }),
  callback = function()
    pcall(vim.diagnostic.show)
  end
})
