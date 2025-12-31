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

vim.pack.add({
  -- --- Which-Key Plugin ---
  -- Which-Key is a popular plugin that shows a popup with available keymaps
  -- after you press a key (like the leader key). This is incredibly helpful for
  -- discovering and remembering your keybindings.
  -- Experiment by pressing keys like `g`, `z`, `<Space>`, etc.
  'https://github.com/folke/which-key.nvim',
  -- Plenary.nvim is a utility library that many other plugins depend on.
  -- It provides useful functions for things like file paths and shell commands.
  'https://github.com/nvim-lua/plenary.nvim',
})



--Here we add top level headings to our custom mappings and groups
local wk = require("which-key")
wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>f", group = "Find" },
  { "<leader>t", group = "Toggle" },
  { "<leader>x", group = "Test" },
  { "gr",        group = "LSP Actions" },
})

-- ===========================================================================
-- Modularized Configuration
-- ===========================================================================
--
-- To keep this `init.lua` file clean and organized, the configuration is
-- broken down into smaller, more manageable files. These files are located
-- in the `lua/` directory.
--
-- The `require()` function is used to load these files. For example,
-- `require('plugins.dap')` will load the `lua/plugins/dap.lua` file.

-- Load plugin configurations
-- Each file in `lua/plugins/` is dedicated to configuring a specific plugin.
require('plugins.dap')           -- Debug Adapter Protocol (DAP) for debugging
require('plugins.fzf')           -- Fuzzy finder for quickly searching files, buffers, etc.
require('plugins.image')         -- Image viewing capabilities
require('plugins.image-clip')    -- Clipboard support for images
require('plugins.lsp')           -- Language Server Protocol (LSP) for code intelligence
require('plugins.markview')      -- Markdown previewer
require('plugins.mini')          -- A collection of minimal, fast, and single-file plugins
require('plugins.treesitter')    -- Advanced syntax highlighting and code parsing
require('plugins.vimtex')        -- Enhanced support for LaTeX documents
require('plugins.git')
require('plugins.buffer-walker') -- Utility plugin for back and next buffer navigation
require('plugins.fyler')

-- Load other core configuration files
require('autocmds')  -- Automations that trigger on specific events
require('functions') -- Custom Lua functions
require('options')   -- General Neovim settings
require('keymaps')   -- Custom keybindings

--UPDATE AND CLEANUP PLUGINS
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = CheckPluginUpdates,
})
