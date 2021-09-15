local go = vim.o  -- global option
local wo = vim.wo -- window option
local bo = vim.bo -- buffer option
--
--
bo.expandtab = true
bo.smartindent = true        -- Makes indenting smart
go.backup = false            -- This is recommended by coc
go.clipboard = "unnamedplus" -- Copy paste between vim and everything else
go.cmdheight = 2             -- More space for displaying messages
go.completeopt = "menu,menuone,noselect"
go.conceallevel = 0          -- So that I can see `` in markdown files
go.dir = '/tmp'
go.fileencoding = "utf-8"    -- The encoding written to file
go.hidden = true             -- Required to keep multiple buffers open multiple buffers
go.hlsearch = true
go.ignorecase = true
go.incsearch = true
go.laststatus = 2
go.mouse = "a"               -- Enable your mouse
go.pumheight = 10            -- Makes popup menu smaller
go.scrolloff = 12
go.showmode = false          -- We don't need to see things like -- INSERT -- anymore
go.showtabline = 2           -- Always show tabs
go.smartcase = true
go.splitbelow = true         -- Horizontal splits will automatically be below
go.splitright = true         -- Vertical splits will automatically be to the right
go.swapfile = false
go.termguicolors = true      -- set term giu colors most terminals support this
go.timeoutlen = 400          -- By default timeoutlen is 1000 ms
go.title = true
go.titlestring="%<%F%=%l/%L - nvim"
go.updatetime = 300          -- Faster completion
go.writebackup = false       -- This is recommended by coc
wo.cursorline = true         -- Enable highlighting of the current line
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"        -- Always show the signcolumn, otherwise it would shift the text each time
wo.wrap = false
---- vim cmds
vim.cmd('set colorcolumn=99999')      -- fix indentline for now
vim.cmd('set inccommand=split')       -- Make substitution work in realtime
vim.cmd('set iskeyword+=-')           -- treat dash separated words as a word text object"
vim.cmd('set shortmess+=c')           -- Don't pass messages to |ins-completion-menu|.
vim.cmd('set sw=4')                   -- Change the number of space characters inserted for indentation
vim.cmd('set ts=4')                   -- Insert 2 spaces for a tab
vim.cmd('set whichwrap+=<,>,[,],h,l') -- move to next line with theses keys
vim.cmd('syntax on')                  -- move to next line with theses keys
vim.cmd('colorscheme evening')
