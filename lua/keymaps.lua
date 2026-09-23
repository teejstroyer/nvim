-- ===========================================================================
-- Global Keymap Conflict Detector (Transparent vim.keymap.set Hook)
-- ===========================================================================
local orig_keymap_set = vim.keymap.set
local registered_keymaps = {} -- { [mode] = { [lhs] = { desc = ..., loc = ... } } }

vim.keymap.set = function(mode, lhs, rhs, opts)
  opts = opts or {}
  local m_list = type(mode) == "table" and mode or { mode }
  local k_list = type(lhs) == "table" and lhs or { lhs }

  -- Only check global mappings to avoid false positives on buffer-local LSP keymaps
  if not opts.buffer then
    local info = debug.getinfo(2, "Sl")
    local source_loc = info and
    string.format("%s:%d", info.short_src:match("[^/]+$") or info.short_src, info.currentline) or "unknown"
    local new_desc = opts.desc or (type(rhs) == "string" and rhs or "function")

    for _, m in ipairs(m_list) do
      registered_keymaps[m] = registered_keymaps[m] or {}
      for _, k in ipairs(k_list) do
        local existing = registered_keymaps[m][k]

        if existing and existing.desc ~= new_desc then
          vim.schedule(function()
            vim.notify(
              string.format(
                "⚠️ Keymap Conflict on '%s' (mode '%s'):\n  - Existing: '%s' [%s]\n  - Overwritten by: '%s' [%s]",
                k, m, existing.desc, existing.loc, new_desc, source_loc
              ),
              vim.log.levels.WARN,
              { title = "Keymap Conflict Detector" }
            )
          end)
        end

        registered_keymaps[m][k] = { desc = new_desc, loc = source_loc }
      end
    end
  end

  return orig_keymap_set(mode, lhs, rhs, opts)
end

-- ===========================================================================
-- Keymaps
-- ===========================================================================

-- Insert Date Helper
function InsertDate()
  vim.api.nvim_put({ tostring(os.date("%Y-%m-%d")) }, "", true, true)
end

-- Navigation & Movements
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up wrapped" })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down wrapped" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex Mode Q" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Window Navigation
vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true, desc = "Navigate left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true, desc = "Navigate down window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true, desc = "Navigate up window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true, desc = "Navigate right window" })

-- Window Resizing
vim.keymap.set("n", "<Up>", "<C-w>+", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<Down>", "<C-w>-", { silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<Left>", "<C-w><", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<Right>", "<C-w>>", { silent = true, desc = "Increase window width" })

-- Buffer Management
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })

-- Visual Mode Moving
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- Search and Replace Word under Cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute word under cursor" })

-- Diagnostics
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Insert Mode
vim.keymap.set('i', '<c-d>', InsertDate, { desc = 'Insert Date' })

-- ===========================================================================
-- Toggles (<leader>T)
-- ===========================================================================
vim.keymap.set("n", "<leader>Tw", function()
  vim.opt.wrap = not vim.opt.wrap:get()
  vim.notify("Line Wrap: " .. (vim.opt.wrap:get() and "On" or "Off"))
end, { desc = "Toggle Wrap Lines", silent = true })

vim.keymap.set("n", "<leader>Th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
  vim.notify("LSP Inlay Hints: " .. (vim.lsp.inlay_hint.is_enabled({}) and "On" or "Off"))
end, { desc = 'Toggle Inlay Hints' })

vim.keymap.set("n", "<leader>Ts", function()
  vim.opt.spell = not (vim.opt.spell:get())
  vim.notify("Spell Check: " .. (vim.opt.spell:get() and "On" or "Off"))
end, { desc = 'Toggle Spell Check' })

vim.keymap.set("n", "<leader>Tc", function()
  local old_level = vim.g.conceallevel
  vim.ui.select({ nil, 0, 1, 2, 3 }, {
    prompt = 'Select Conceal Level',
    format_item = function(item) return "Conceal Level: " .. tostring(item) end,
  }, function(choice)
    vim.g.conceallevel = choice
    vim.notify("Conceal level: " .. tostring(old_level) .. " => " .. tostring(vim.g.conceallevel))
  end)
end, { desc = 'Toggle Conceal Level' })

vim.keymap.set("n", "<leader>Tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })

vim.keymap.set("n", "<leader>Ti", function()
  if _G.ToggleInlineImages then
    _G.ToggleInlineImages()
  end
end, { desc = 'Toggle Inline Images' })
