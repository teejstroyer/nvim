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

-- --- Format on Save ---
-- This autocmd sets up automatic formatting on save.
-- It works by creating a `BufWritePre` event listener *only* when a language
-- server that supports formatting is attached to a buffer.
-- This is a smart way to ensure that formatting is only attempted when it's possible.
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
