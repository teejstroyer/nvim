-- ===========================================================================
-- Autocommands
-- ===========================================================================

-- Initial Working Directory on startup
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(vim.fn.argv(0)))
    elseif vim.fn.filereadable(vim.fn.expand("%")) == 1 then
      vim.cmd("cd " .. vim.fn.expand("%:p:h"))
    end
  end,
})

-- Highlight region on Yank and Put
vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
  group = vim.api.nvim_create_augroup("HighlightYankPut", { clear = true }),
  pattern = "*",
  callback = function() vim.hl.hl_op() end,
})

-- Strip trailing whitespace on save (preserves markdown and keeps cursor steady)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype == "markdown" or vim.api.nvim_buf_line_count(args.buf) > 500 then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Clean terminal window settings
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", { clear = true }),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

-- Update and clean plugins daily on first launch
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local today = os.date('%Y-%m-%d')
    local state_file = vim.fn.stdpath('data') .. '/daily_task_date.txt'
    local last_run = ''

    if vim.fn.filereadable(state_file) == 1 then
      local file = io.open(state_file, 'r')
      if file then
        last_run = (file:read('*l') or ''):match('^%s*(.-)%s*$') or ''
        file:close()
      end
    end

    if last_run ~= today then
      vim.notify('Syncing lockfile and updating packages...', vim.log.levels.INFO)
      local ok, err = pcall(vim.pack.update, nil, { force = true })
      if ok then
        local file = io.open(state_file, 'w')
        if file then
          file:write(today, '\n')
          file:close()
        end
      else
        vim.notify('Package update failed: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end

    pcall(vim.cmd, 'packdel ++all')
  end,
})
