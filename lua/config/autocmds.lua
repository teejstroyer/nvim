local augroup = vim.api.nvim_create_augroup
local auGroupConfig = augroup("auGroup_config", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = auGroupConfig,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

--Term open auto command
autocmd({ "TermOpen" }, {
    group = auGroupConfig,
    pattern = "*",
    command = [[setlocal nonumber norelativenumber | startinsert]],
})
