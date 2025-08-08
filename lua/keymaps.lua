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
--Move selection up or down
kmap("v", "<C-k>", ":m '<-2<cr>gv=gv")
kmap("v", "<C-j>", ":m '>+1<cr>gv=gv")
--SEARCH AND REPLACE UNDER CURSOR
kmap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Subsitute word" })
--FILE Explorer
kmap("n", "<leader>e", MiniFiles.open, { desc = "Explore files" })

kmap("n", "<leader>o", function()
  vim.cmd("vsplit | wincmd l")
  require("oil").open()
end)

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

kmap("n", "<leader>tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })


vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim'})
kmap("n", "<leader>p", require('img-clip').pasteImage, { desc = "Paste Image", silent = true })
