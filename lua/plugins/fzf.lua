-- ===========================================================================
-- FZF (Fuzzy Finder)
-- ===========================================================================
-- This file configures fzf-lua, a plugin that integrates the powerful fzf
-- fuzzy finder into Neovim. It allows you to quickly find files, buffers,
-- commands, and more.

-- Fzf, a fuzzy finding picker, useful for finding open buffers, files, other commands etc
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/elanmed/fzf-lua-frecency.nvim'
})

-- Load the fzf-lua module.
local fzf = require('fzf-lua')
local fzfr = require('fzf-lua-frecency')
-- Set up keymaps for various fzf commands.
-- The descriptions will be shown by the which-key plugin.
vim.keymap.set("n", "<leader>F", ":FzfLua<CR>", { desc = "FZF Lua" })                                               -- A general-purpose fzf command.
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })                                               -- Find files in the current working directory.
---@diagnostic disable-next-line: missing-fields
vim.keymap.set("n", "<leader><space>", function() fzfr.frecency({ cwd_only = true, }) end, { desc = "Find files" }) -- Find files in the current working directory, based on frecency.
vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find commands" })                                         -- Find and execute Neovim commands.
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })                                           -- Find and switch to open buffers.
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find grep" })                                            -- Search for a string in all files in the project.
vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find helptags" })                                         -- Search through the help documentation.
vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Find diagnostics_document" })                 -- Find diagnostics in the current document.
vim.keymap.set("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Find diagnostics_workspace" })               -- Find diagnostics in the entire workspace.
vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Find resume" })                                             -- Resume the last fzf search.
vim.keymap.set("n", "<leader>/", fzf.lines, { desc = "Find lines" })                                                -- Search for lines in the current buffer.
