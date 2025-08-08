vim.pack.add({ "https://github.com/echasnovski/mini.nvim" })

require('mini.ai').setup()
require('mini.colors').setup()
require('mini.diff').setup()
require('mini.extra').setup()
require('mini.files').setup()
require('mini.icons').setup()
require('mini.indentscope').setup()
require('mini.notify').setup()
require('mini.pick').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()

vim.notify = require('mini.notify').make_notify()
local pick = require('mini.pick')
pick.setup()
vim.ui.select = pick.ui_select
