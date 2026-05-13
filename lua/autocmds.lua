-- ===========================================================================
-- AUTO COMMANDS
-- ===========================================================================
-- Auto commands, or `autocmd`s, are a way to automate tasks based on events.
-- They tell Neovim to execute a command whenever a specific event occurs,
-- such as a file being saved (`BufWritePre`).
--
-- The recommended way to define an autocmd in Lua is using
-- `vim.api.nvim_create_autocmd`.

-- --- Highlight Yanked Text ---
-- Briefly highlights the text that you have just yanked (copied).
-- This provides a visual confirmation of what you've copied.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

-- --- Remove Trailing Whitespace ---
-- Automatically remove trailing whitespace from a file when it's saved.
-- This helps to keep your files clean and consistent.
-- The `%s/\s\+$//e` is a regular expression that finds and removes whitespace at the end of lines.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- --- Terminal Settings ---
-- When a terminal is opened, set local options for a better experience.
-- `setlocal nonumber norelativenumber` disables line numbers in the terminal buffer.
-- `startinsert` automatically puts you in insert mode when you open a terminal.
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", { clear = true }),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})
