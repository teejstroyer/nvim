-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command
-- choco install mingw as admin should work

if vim.fn.exists("g:vscode") == 0 then
    require('plugins')
    require('options')
    require('mappings')
end
