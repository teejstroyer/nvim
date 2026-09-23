-- ===========================================================================
-- Markdown & Tasks
-- ===========================================================================

-- Markview (Markdown Pretty-Printing) & Task.nvim (Task Management)
vim.pack.add({
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/teejstroyer/task.nvim",
})

local presets = require("markview.presets")
require("markview").setup({
  markdown = {
    headings = presets.headings.arrowed,
    horizontal_rules = presets.horizontal_rules.solid,
    tables = presets.tables.rounded,
  },
  preview = { hybrid_modes = { "n", "v" }, edit_range = { 1, 1 } },
  experimental = { check_rtp = false },
})

local tasks = require("task")
tasks.setup({
  sections = {
    todo      = { label = "Todo", check_style = "[ ]", order = 1, color = "#ff9e64" },
    doing     = { label = "In Progress", check_style = "[/]", order = 2, color = "#7aa2f7" },
    done      = { label = "Completed", check_style = "[x]", order = 3, color = "#9ece6a" },
    archive   = { label = "Archive", check_style = "[b]", style = "~~", order = 4, color = "#565f89" },
    cancelled = { label = "Cancelled", check_style = "[-]", style = "~~", order = 5, color = "#444b6a" },
    wont      = { label = "Wont Do", check_style = "[d]", style = "~~", order = 6, color = "#f7768e" },
    idea      = { label = "Proposals", check_style = "[I]", style = "", order = 7, color = "#f7768e" },
  },
  highlights = { metadata = { fg = "#565f89", italic = true } },
  types = {
    bug  = { style = "**", color = "#f7768e" },
    feat = { style = "_", color = "#bb9af7" },
    task = { style = "", color = "#7aa2f7" },
  },
  date_format = "%Y-%m-%d",
  default_type = "TASK",
})

vim.keymap.set('n', '<leader>tn', function() tasks.new_task('task') end, { desc = "Task: Quick New" })
vim.keymap.set('n', '<leader>tN', function()
  vim.ui.input({ prompt = "Task Type: " }, function(input) tasks.new_task(input) end)
end, { desc = "Task: New with Type" })
vim.keymap.set({ 'n', 'v' }, '<leader>tb', function() tasks.move_task("todo") end, { desc = "Task: Backlog" })
vim.keymap.set({ 'n', 'v' }, '<leader>tp', function() tasks.move_task("doing") end, { desc = "Task: Progress" })
vim.keymap.set({ 'n', 'v' }, '<leader>td', function() tasks.move_task("done") end, { desc = "Task: Completed" })
vim.keymap.set({ 'n', 'v' }, '<leader>ta', function() tasks.move_task("archive") end, { desc = "Task: Archive" })
vim.keymap.set({ 'n', 'v' }, '<leader>tw', function() tasks.move_task("wont") end, { desc = "Task: Wont Do" })
vim.keymap.set({ 'n', 'v' }, '<leader>tc', function() tasks.move_task("cancelled") end, { desc = "Task: Cancelled" })
vim.keymap.set({ 'n', 'v' }, '<leader>t<space>', function() tasks.select_move() end, { desc = "Task: Move" })
