-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command
-- choco install mingw as admin should work

if vim.fn.exists("g:vscode") == 0 then
    require("config.lazy")
    require("config.options")
    require("config.autocmds")
    require("config.keymaps")
end
