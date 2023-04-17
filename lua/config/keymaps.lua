vim.g.mapleader = " "

--noremap = not recursive map | a -> b && and b -> a infinite loop
local silentOpt = { silent = true, noremap = true }
local function map(mode, lhs, rhs, opt)
    vim.keymap.set(mode, lhs, rhs, opt)
end

map("n", "<leader>k", function() vim.diagnostic.open_float({ focusable = true }) end)
--UNMAP to prevent hard quit
map("n", "Q", "<nop>")
--TERMINAL NORMAL MODE
map("t", "<Esc>", "<c-\\><c-n>")
--UNDO TREE
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo Tree Toggle" })
--BUFFER
map("n", "<leader>q", ":bdelete<CR>", silentOpt)
map("n", "<leader>bn", ":bnext<CR>", silentOpt)
map("n", "<leader>bp", ":bprevious<CR>", silentOpt)
--Move selection up or down
map("v", "<C-j>", ":m '>+1<cr>gv=gv", silentOpt)
map("v", "<C-k>", ":m '<-2<cr>gv=gv", silentOpt)
-- COPY/PASTE/DELETE To buffer
map("n", "<leader>Y", [["+Y]])
map("x", "<leader>p", [["_dP]])
map({ "n", "v" }, "<leader>d", [["_d]])
map({ "n", "v" }, "<leader>y", [["+y]])
--SEARCH AND REPLACE UNDER CURSOR
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--FILE Explorer
map("n", "<leader>e", ":NeoTreeFocusToggle<CR>", { noremap = true })
--MOVE BETWEEN WINDOW PREFIX
map("n", "<leader>w", "<C-w>") --Helpful for moving between windows
--WINDOW SPLITS
map("n", "<leader>\\", ":vsplit<CR>")
map("n", "<leader>-", ":split<CR>")
map("n", "<Up>", ":resize -2<CR>")
map("n", "<Down>", ":resize +2<CR>")
map("n", "<Left>", ":vertical resize -2<CR>")
map("n", "<Right>", ":vertical resize +2<CR>")
--DIAGNOSTICS
map("n", "<leader>xJ", "<cmd>lprev<CR>zz")
map("n", "<leader>xK", "<cmd>lnext<CR>zz")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", silentOpt)
map("n", "<leader>xj", "<cmd>cprev<CR>zz")
map("n", "<leader>xk", "<cmd>cnext<CR>zz")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", silentOpt)
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", silentOpt)
map("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", silentOpt)
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", silentOpt)
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", silentOpt)
--TOGGLE TERM
map("n", "<C-`>", "<cmd>ToggleTerm<cr>", silentOpt)
map("n", "<leader>tt", "<cmd>ToggleTerm size=40 dir=. direction=horizontal<cr>", silentOpt)
map("n", "<leader>tf", "<cmd>ToggleTerm size=40 dir=. direction=float<cr>", silentOpt)
map("n", "<leader>tb", ":enew|terminal<cr>", silentOpt)
--TELESCOPE
local builtin = require('telescope.builtin')
map("n", "<leader>ff", ":Telescope<CR>", silentOpt)
map("n", "<leader>fe", builtin.find_files, silentOpt)
map("n", "<leader>fg", builtin.live_grep, silentOpt)
map("n", "<leader>fb", builtin.buffers, silentOpt)
map("n", "<leader>fh", builtin.help_tags, silentOpt)
map("n", "<leader>fr", builtin.resume, silentOpt)
--DAP - DEBUG
local dap = require "dap"
map("n", "<F5>", dap.continue, { desc = "Continue" })
map("n", "<F11>", dap.step_into, { desc = "Step Into" })
map("n", "<F10>", dap.step_over, { desc = "Step Over" })
map("n", "<S-F11>", dap.step_out, { desc = "Steop Out" })
map("n", "<F9>", dap.toggle_breakpoint, { desc = "Breakpoint" })
map("n", "<C-F9>", function()
    dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Conditional Breakpoint" })
