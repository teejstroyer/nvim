-- NEOVIM Configuration
-- Windows > Treesitter needs gcc so run the following command
-- choco install mingw as admin should work

if vim.fn.exists("g:vscode") == 0 then
    require("config.lazy")
    require("config.options")
    require("config.autocmds")
    require("config.keymaps")
end

if vim.g.neovide then
    vim.o.guifont = "FiraCode Nerd Font Mono:h16"
    vim.g.neovide_cursor_vfx_mode = "railgun"
end
