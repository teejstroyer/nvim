vim.g.mapleader = ' '      -- Set the leader key to a space. Essentially free prefixes for keymaps
vim.g.maplocalleader = ',' -- Set the local leader key to a comma.

-- Creates a server in the cache on boot. Helps with Godot.
local pipepath = vim.fn.stdpath('cache') .. '/server.pipe'
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

-- A custom function to insert the current date in YYYY-MM-DD format.
function InsertDate()
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_put({ tostring(os.date("%Y-%m-%d")) }, "", true, true)
end

-- ===========================================================================
vim.g.have_nerd_font = true
vim.opt.breakindent = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.colorcolumn = "120"
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.inccommand = 'split'
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.showbreak = "↳"
vim.opt.signcolumn = "yes:1"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_us'
vim.opt.spelloptions = "camel"
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.wrap = false
vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ===========================================================================
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>")
vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true, desc = "Navigate left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true, desc = "Navigate down window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true, desc = "Navigate up window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true, desc = "Navigate right window" })
-- --- Buffer Management ---
vim.keymap.set("n", "<leader>q", ":bdelete<CR>", { desc = "Buffer delete" })
-- --- Visual Mode ---
vim.keymap.set("v", "<C-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
-- --- Search and Replace ---
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute word under cursor" })
-- --- Window Management ---
vim.keymap.set("n", "<Up>", "<C-w>+", { silent = true, desc = "Increase window height" })
vim.keymap.set("n", "<Down>", "<C-w>-", { silent = true, desc = "Decrease window height" })
vim.keymap.set("n", "<Left>", "<C-w><", { silent = true, desc = "Decrease window width" })
vim.keymap.set("n", "<Right>", "<C-w>>", { silent = true, desc = "Increase window width" })
-- --- Diagnostics ---
vim.keymap.set('n', '<leader>k', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
-- --- Insert Mode ---
vim.keymap.set('i', '<c-d>', function() vim.api.nvim_put({ tostring(os.date("%Y-%m-%d")) }, "", true, true) end,
  { desc = 'Insert Date' })
-- --- Toggles ---
vim.keymap.set("n", "<leader>Tw",
  function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify("Line Wrap: " .. (vim.opt.wrap:get() and "On" or "Off"))
  end, { desc = "Toggle Wrap Lines", silent = true })

vim.keymap.set("n", "<leader>Th",
  function()
    vim.opt.wrap = not vim.opt.wrap:get()
    vim.notify("Line Wrap: " .. (vim.opt.wrap:get() and "On" or "Off"))
  end, { desc = "Toggle Wrap Lines", silent = true })

vim.keymap.set("n", "<leader>Th",
  function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    vim.notify("LSP Inlay Hints: " .. (vim.lsp.inlay_hint.is_enabled({}) and "On" or "Off"))
  end, { desc = 'Toggle Inlay Hints' })

vim.keymap.set("n", "<leader>Ts",
  function()
    vim.opt.spell = not (vim.opt.spell:get())
    vim.notify("Spell Check: " .. (vim.opt.spell:get() and "On" or "Off"))
  end, { desc = 'Toggle Spell Check' })

vim.keymap.set("n", "<leader>Tc",
  function()
    local old_level = vim.g.conceallevel
    vim.ui.select({ nil, 0, 1, 2, 3 }, {
      prompt = 'Select Conceal Level',
      format_item = function(item)
        return "Conceal Level: " .. tostring(item)
      end,
    }, function(choice)
      vim.g.conceallevel = choice
      vim.notify("Conceal level: " .. tostring(old_level) .. " => " .. tostring(vim.g.conceallevel))
    end)
  end, { desc = 'Toggle Conceal Level' })

vim.keymap.set("n", "<leader>Tf", function()
  _G.FormatOnSave = not _G.FormatOnSave
  vim.notify("Format on Save: " .. tostring(_G.FormatOnSave))
end, { desc = 'Toggle Format on Save' })

-- ===========================================================================
-- 5. [AUTO] Auto Commands
-- ===========================================================================

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  pattern = "*",
  callback = function() vim.hl.hl_op() end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("TrailingSpace", { clear = true }),
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "markdown" or vim.api.nvim_buf_line_count(args.buf) > 500 then
      vim.cmd([[%s/\s\+$//e]])
    end
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  group = vim.api.nvim_create_augroup("TerminalLineNumbers", { clear = true }),
  pattern = "*",
  command = [[setlocal nonumber norelativenumber | startinsert]],
})

vim.cmd [[colorscheme retrobox]]

local packadd = function(pack, packfunc)
  vim.pack.add(pack)
  if packfunc then
    packfunc()
  end
end

packadd({ 'https://github.com/nvim-lua/plenary.nvim' })

packadd({ 'https://github.com/nvim-lualine/lualine.nvim' },
  function() require('lualine').setup({ options = { theme = "gruvbox" } }) end)

packadd({ 'https://github.com/nvim-tree/nvim-web-devicons' }, function() require('nvim-web-devicons').setup() end)

packadd({ 'https://github.com/HakonHarnes/img-clip.nvim' }, function()
  vim.keymap.set("n", "<leader>p", require('img-clip').pasteImage, { desc = "Paste Image from Clipboard", silent = true })
end)

packadd({ 'https://github.com/shorya-1012/buffer_walker.nvim' }, function()
  vim.keymap.set("n", "<leader>[", ":MoveBack<CR>", { silent = true })
  vim.keymap.set("n", "<leader>]", ":MoveForward<CR>", { silent = true })
end)

packadd({ 'https://github.com/folke/which-key.nvim' }, function()
  local whichKey = require("which-key")
  whichKey.add({
    { "<leader>g", group = "Git" },
    { "<leader>f", group = "Find" },
    { "<leader>T", group = "Toggle" },
    { "<leader>t", group = "Task" },
    { "<leader>x", group = "Test" },
    { "gr",        group = "LSP Actions" },
  })
end)

-- --- DAP (Debug Adapter Protocol) ---
packadd({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
}, function()
  require("nvim-dap-virtual-text").setup()
  vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
end)

-- --- Tiny Inline Diagnostic ---
packadd({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }, function()
  require("tiny-inline-diagnostic").setup()
  vim.diagnostic.config({
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "●",
        [vim.diagnostic.severity.WARN]  = "○",
        [vim.diagnostic.severity.HINT]  = "󰌶",
        [vim.diagnostic.severity.INFO]  = "",
      },
    },
  })
end)

-- --- Fyler (File Explorer) ---
packadd({
  { src = "https://github.com/FylerOrg/fyler.nvim", version = 'stable' }
}, function()
  local fyler = require('fyler')
  vim.keymap.set("n", "<leader>e", function() fyler.open({ kind = "split_left_most" }) end, { desc = "Open fyler View" })
  fyler.setup({
    integrations = { icon = "nvim_web_devicons" },
    views = { finder = { close_on_select = true, default_explorer = true } },
  })
end)

-- --- FZF (Fuzzy Finder) ---
packadd({
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/elanmed/fzf-lua-frecency.nvim'
}, function()
  local fzf = require('fzf-lua')
  fzf.register_ui_select()
  local fzfr = require('fzf-lua-frecency')
  vim.keymap.set("n", "<leader>F", ":FzfLua<CR>", { desc = "FZF Lua" })
  vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
  vim.keymap.set("n", "<leader><space>", function() fzfr.frecency({ cwd_only = true, }) end, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fc", fzf.commands, { desc = "Find commands" })
  vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Find grep" })
  vim.keymap.set("n", "<leader>fh", fzf.helptags, { desc = "Find helptags" })
  vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "Find diagnostics_document" })
  vim.keymap.set("n", "<leader>fD", fzf.diagnostics_workspace, { desc = "Find diagnostics_workspace" })
  vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "Find resume" })
  vim.keymap.set("n", "<leader>/", fzf.lines, { desc = "Find lines" })
end)

-- --- Git ---
packadd({
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
}, function()
  local gitsigns = require('gitsigns')
  local diffview = require('diffview')
  local neogit = require('neogit')
  vim.keymap.set("n", "<leader>gb", gitsigns.blame_line, { desc = "Git blame" })
  vim.keymap.set("n", "<leader>gB", gitsigns.blame, { desc = "Git blame file" })
  vim.keymap.set("n", "<leader>gd", diffview.open, { desc = "Git diff this" })
  vim.keymap.set("n", "<leader>gt", neogit.open, { desc = "Git UI (Tab)" })
  vim.keymap.set("n", "<leader>gs", function() neogit.open({ kind = "auto" }) end, { desc = "Git UI(Split)" })
end)

-- --- LSP (Language Server Protocol) ---
packadd({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/antonk52/filepaths_ls.nvim',
  'https://github.com/seblyng/roslyn.nvim',
  "https://github.com/Mathijs-Bakker/godotdev.nvim",
  -- Java Stuff
  {
    src = 'https://github.com/JavaHello/spring-boot.nvim',
    version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
  },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-java/nvim-java',
}, function()
  require('mason').setup({
    registries = {
      'github:Crashdummyy/mason-registry',
      'github:mason-org/mason-registry',
    }
  })

  require('java').setup()
  vim.lsp.enable('jdtls')

  vim.lsp.enable('dartls')
  require("godotdev").setup()
  require('lazydev').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls" },
    automatic_enable = true,
  })
  vim.lsp.enable('filepaths_ls')

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(ev)
      local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
      if client:supports_method('textDocument/completion') then
        local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        client.server_capabilities.completionProvider.triggerCharacters = chars
        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
      end
      if not client:supports_method('textDocument/willSaveWaitUntil')
          and client:supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
          buffer = ev.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
          end,
        })
      end
    end,
  })
end)

-- --- Markview (Markdown Preview) and Task ---
packadd({
  "https://github.com/OXY2DEV/markview.nvim",
  "https://github.com/teejstroyer/task.nvim",
}, function()
  local presets = require("markview.presets");
  require("markview").setup({
    markdown = {
      headings = presets.headings.arrowed,
      horizontal_rules = presets.horizontal_rules.solid,
      tables = presets.tables.rounded
    },
    preview = { hybrid_modes = { "n", "v" }, edit_range = { 1, 1 } },
    experimental = { check_rtp = false }
  })

  -- TASK, my custom plugin
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
      task = { style = "", color = "#7aa2f7" }
    },
    date_format = "%Y-%m-%d",
    default_type = "TASK"
  })
  vim.keymap.set('n', '<leader>tn', function() tasks.new_task('task') end, { desc = "Task: Quick New (default type)" })
  vim.keymap.set('n', '<leader>tN', function()
    vim.ui.input({ prompt = "Task Type: " }, function(input) tasks.new_task(input) end)
  end, { desc = "Task: New (Prompt for Type)" })
  vim.keymap.set({ 'n', 'v' }, '<leader>tb', function() tasks.move_task("todo") end, { desc = "Task:Backlog" })
  vim.keymap.set({ 'n', 'v' }, '<leader>tp', function() tasks.move_task("doing") end, { desc = "Task:Progress" })
  vim.keymap.set({ 'n', 'v' }, '<leader>td', function() tasks.move_task("done") end, { desc = "Task:Completed" })
  vim.keymap.set({ 'n', 'v' }, '<leader>ta', function() tasks.move_task("archive") end, { desc = "Task:Archive" })
  vim.keymap.set({ 'n', 'v' }, '<leader>tw', function() tasks.move_task("wont") end, { desc = "Task:Wont Do" })
  vim.keymap.set({ 'n', 'v' }, '<leader>tc', function() tasks.move_task("cancelled") end, { desc = "Task:Cancelled" })
  vim.keymap.set({ 'n', 'v' }, '<leader>t<space>', function() tasks.select_move() end, { desc = "Task: Move" })
end)

-- --- CSV View ---
packadd({ "https://github.com/hat0uma/csvview.nvim" }, function() require("csvview").setup() end)

--- Rndr (3D/Image Preview) ---
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'rndr.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end
})

packadd({ "https://github.com/SalarAlo/rndr.nvim" }, function()
  require("rndr").setup({
    preview = { auto_open = true },
    git = {
      timeout = 900 -- 15 minutes/timeout, assimp
    }
  })

  local plugin_info = vim.pack.get({ "rndr.nvim" })[1]
  if plugin_info and not vim.uv.fs_stat(plugin_info.path .. "/renderer/build/rndr") then
    vim.system({ 'make' }, { cwd = plugin_info.path })
  end
end)

-- --- Arborist ---
packadd({ "https://github.com/arborist-ts/arborist.nvim" }, function() require("arborist").setup() end)

-- --- Leetcode ---
packadd({ 'https://github.com/kawre/leetcode.nvim' }, function()
  require("leetcode").setup({
    lang = "csharp",
    picker = { provider = "fzf-lua" },
  })
end)

require('vim._core.ui2').enable({})
-- UPDATE AND CLEANUP PLUGINS
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    local today = os.date('%Y-%m-%d')
    local state_file = vim.fn.stdpath('data') .. '/daily_task_date.txt'
    local last_run = ''

    if vim.fn.filereadable(state_file) == 1 then
      local file = io.open(state_file, 'r')
      if file then
        last_run = (file:read('*l') or ''):match('^%s*(.-)%s*$') or ''
        file:close()
      end
    end

    if last_run ~= today then
      vim.notify('Syncing lockfile and updating packages...', vim.log.levels.INFO)
      local ok, err = pcall(vim.pack.update, nil, { force = true })
      if ok then
        local file = io.open(state_file, 'w')
        if file then
          file:write(today, '\n')
          file:close()
        end
      else
        vim.notify('Package update failed: ' .. tostring(err), vim.log.levels.ERROR)
      end
    end

    pcall(vim.cmd, 'packdel ++all')
  end,
})
