-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command
-- choco install mingw as admin should work

require('plugins')
require('config.setup-plugins')
require('config.mason')
require('config.cmp')
require('config.dap')

require('options')
require('mappings')
