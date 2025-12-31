-- ===========================================================================
-- KEYMAPS
-- ===========================================================================
-- Keymaps are custom shortcuts that streamline your workflow.
-- `vim.keymap.set` is used to define them. The first argument is the mode
-- ('n' for normal, 'i' for insert, 'v' for visual, etc.), followed by the
-- key combination, the command to execute, and optional parameters like `desc`.
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

local kmap = vim.keymap.set

-- It's good practice to require any files that define functions you use in your keymaps.
require('functions')

-- --- General Navigation and Editing ---
kmap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })                                        -- Word Wrap Fix: 'k' moves up by visual line, unless a count is provided.
kmap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })                                        -- Word Wrap Fix: 'j' moves down by visual line, unless a count is provided.
kmap("n", "Q", "<nop>")                                                        -- Unmap 'Q' to prevent accidentally entering Ex mode.
kmap("t", "<Esc>", "<c-\\><c-n>")                                              -- In terminal mode, <Esc> enters normal mode, making it feel more like Vim.
kmap("n", "<c-h>", "<c-w>h", { silent = true, desc = "Navigate left window" }) -- Use Ctrl+h/j/k/l to switch between windows.
kmap("n", "<c-j>", "<c-w>j", { silent = true, desc = "Navigate down window" })
kmap("n", "<c-k>", "<c-w>k", { silent = true, desc = "Navigate up window" })
kmap("n", "<c-l>", "<c-w>l", { silent = true, desc = "Navigate right window" })

-- --- Buffer Management ---
kmap("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" }) -- Close the current buffer.

-- --- Visual Mode ---
-- Move selected lines up or down. The `gv=gv` part re-selects the moved lines and re-indents them.
kmap("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
kmap("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })

-- --- Search and Replace ---
-- Search and replace the word under the cursor. This is a powerful shortcut for refactoring.
-- `<C-r><C-w>` inserts the word under the cursor into the command line.
kmap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })


-- --- Window Management ---
-- Resize windows using the arrow keys.
kmap("n", "<Up>", "<C-w>+", { desc = "Increase window height", silent = true })
kmap("n", "<Down>", "<C-w>-", { desc = "Decrease window height", silent = true })
kmap("n", "<Left>", "<C-w><", { desc = "Decrease window width", silent = true })
kmap("n", "<Right>", "<C-w>>", { desc = "Increase window width", silent = true })

-- --- Diagnostics ---
-- Show diagnostic information (errors, warnings) in a floating window.
kmap('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- --- Insert Mode ---
-- Create a user command to call the function.
vim.api.nvim_create_user_command("InsertDate", InsertDate, {})
-- Map <C-d> in insert mode to insert the date.
kmap('i', '<c-d>', InsertDate, { desc = 'Insert Date' })

-- --- Toggles ---
-- These keymaps toggle common settings on and off, providing quick access to change your editing environment.
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

