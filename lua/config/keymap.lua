vim.g.mapleader = " "

vim.keymap.set("n", "<leader>b", ":bnext<CR>")
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>")

vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
--vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>;f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
--Helpful for moving between windows
vim.keymap.set("n", "<leader>w", "<C-w>")

require("lsp-zero").on_attach(function(client, bufnr)

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, remap = false, desc = 'Goto Definition' })
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, remap = false, desc = 'Goto Definition' })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, remap = false, desc = 'Hover Details' })
    vim.keymap.set("n", "<leader>;ws", vim.lsp.buf.workspace_symbol, { buffer = bufnr, remap = false, desc = 'Workspace Symbols' })
    vim.keymap.set("n", "<leader>;d", vim.diagnostic.open_float, { buffer = bufnr, remap = false, desc = 'Diagnostics' })
    vim.keymap.set("n", "<leader>;dn", vim.diagnostic.goto_next, { buffer = bufnr, remap = false, desc = 'Diagnostics Next' })
    vim.keymap.set("n", "<leader>;dp", vim.diagnostic.goto_prev, { buffer = bufnr, remap = false, desc = 'Diagnostics Previous' })
    vim.keymap.set("n", "<leader>;a", vim.lsp.buf.code_action, { buffer = bufnr, remap = false, desc = 'Code Action' })
    vim.keymap.set("n", "<leader>;r", vim.lsp.buf.references, { buffer = bufnr, remap = false, desc = 'References' })
    vim.keymap.set("n", "<leader>;R", vim.lsp.buf.rename, { buffer = bufnr, remap = false, desc = 'Rename' })
    vim.keymap.set("i", "<leader>;h", vim.lsp.buf.signature_help, { buffer = bufnr, remap = false, desc = '' })
end)

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").toggle()
    vim.wo.wrap = false
end)

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
