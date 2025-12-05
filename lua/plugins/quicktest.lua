vim.pack.add({ "https://github.com/quolpr/quicktest.nvim" })

local qt = require("quicktest")

qt.setup({
  adapters = {
  },
  default_win_mode = "split",
  use_builtin_colorizer = true
})

vim.keymap.set("n", "<leader>xl", qt.run_line, { desc = "[T]est Run [L]line", })
vim.keymap.set("n", "<leader>xf", qt.run_file, { desc = "[T]est Run [F]ile", })
vim.keymap.set("n", "<leader>xd", qt.run_dir, { desc = "[T]est Run [D]ir", })
vim.keymap.set("n", "<leader>xa", qt.run_all, { desc = "[T]est Run [A]ll", })
vim.keymap.set("n", "<leader>xR", qt.run_previous, { desc = "[T]est Run [P]revious", })

-- vim.keymap.set("n", "<leader>tt", function()
--   qt.toggle_win("popup")
-- end, {
--   desc = "[T]est [T]oggle popup window",
-- })
vim.keymap.set("n", "<leader>xt", function() qt.toggle_win("split") end, { desc = "[T]est [T]oggle Window", })
vim.keymap.set("n", "<leader>xc", function() qt.cancel_current_run() end, { desc = "[T]est [C]ancel Current Run", })
