-- ===========================================================================
-- Basic Neovim Options
-- ===========================================================================
-- The following lines use `vim.opt` to set basic Neovim options.
-- These are the fundamental settings that control how Neovim looks and behaves.

-- `vim.g.have_nerd_font` is a global variable that tells other plugins that a
-- Nerd Font is available. Nerd Fonts provide special icons and symbols.
-- Make sure you have a Nerd Font installed and configured in your terminal.
-- You can find them at https://www.nerdfonts.com/
vim.g.have_nerd_font = true

-- Enable mouse support in all modes. This allows you to use the mouse
-- to navigate, resize windows, and select text.
vim.opt.mouse = 'a'

-- When a long line wraps, indent the wrapped portion to match the indentation
-- of the original line. This makes wrapped code much easier to read.
vim.opt.breakindent = true

-- Connect Neovim's clipboard to the system clipboard. The `unnamedplus`
-- option uses the system clipboard register "+". This means that yanking
-- text in Neovim will copy it to your system clipboard, and pasting from
-- your system clipboard will work as expected.
vim.opt.clipboard = 'unnamedplus'

-- Set a vertical column at character 120 to act as a guide for line length.
-- This helps you to write code that conforms to style guides.
vim.opt.colorcolumn = "120"

-- Configure the behavior of the completion menu.
-- `menuone`: Show the completion menu even if there's only one item.
-- `fuzzy`: Enable fuzzy matching, so you don't have to type exact sequences.
-- `popup`: Show completions in a popup window.
-- `noselect`: Don't pre-select an item in the completion menu.
-- `preview`: Show a preview of the selected completion.
vim.opt.completeopt = 'menuone,fuzzy,popup,noselect,preview'

-- Highlight the line where the cursor is.
-- This makes it easier to locate the cursor, especially on large screens.
vim.opt.cursorline = true

-- Use spaces instead of tabs. This is a common convention in many programming languages.
vim.opt.expandtab = true

-- Disable highlighting for search results once the cursor moves or a new search begins.
-- This keeps the screen from getting cluttered with old search highlights.
vim.opt.hlsearch = false

-- Use a split window for the `substitute` command, showing changes as you type.
-- This gives you a live preview of your search and replace operations.
vim.opt.inccommand = 'split'

-- Highlight search results as you type.
-- This helps you to see the matches as you're typing your search query.
vim.opt.incsearch = true

-- Wrap lines at a convenient point (like a space) instead of mid-word.
-- This improves readability.
vim.opt.linebreak = true

-- Show special characters like tabs and trailing spaces.
-- This can help you to identify and fix whitespace issues.
vim.opt.list = true

-- Display line numbers.
-- This is essential for navigating code and for pair programming.
vim.opt.number = true

-- Display line numbers relative to the current cursor position.
-- This is useful for navigation with commands like `5j` to jump down five lines.
-- When combined with `number`, the current line shows the absolute line number,
-- and all other lines show their relative number.
vim.opt.relativenumber = true

-- Keep at least 10 lines of context above and below the cursor when scrolling.
-- This helps you to see the surrounding code as you scroll through a file.
vim.opt.scrolloff = 10

-- The number of spaces a tab or indent level counts as.
-- Setting this to 2 is a common convention.
vim.opt.shiftwidth = 2

-- Define the symbol to display when a line wraps.
-- The `↳` character provides a clear visual indicator of a wrapped line.
vim.opt.showbreak = "↳"

-- Control how the sign column is displayed. It shows symbols for things like
-- diagnostics or breakpoints. `number` makes the sign column share space with
-- the number column, which saves horizontal space.
vim.opt.signcolumn = "auto"

-- Enable smart case-sensitive searching. If your search query contains
-- an uppercase letter, the search will be case-sensitive. Otherwise, it will be
-- case-insensitive. This is a convenient way to control case sensitivity on the fly.
vim.opt.smartcase = true

-- Automatically indent new lines.
-- This helps to maintain consistent indentation as you write code.
vim.opt.smartindent = true

-- The number of spaces for a soft tabstop. This is the amount of whitespace
-- added when you press the Tab key (if `expandtab` is on).
vim.opt.softtabstop = 2

-- Set the language for the spell checker.
vim.opt.spelllang = 'en_us'

-- Configure spell check options, such as treating camelCase as a single word.
-- This prevents the spell checker from flagging every camelCase variable as a typo.
vim.opt.spelloptions = "camel"

-- Disable swap files. Swap files can be useful for crash recovery but can
-- cause issues with some plugins or when you have multiple instances of Neovim open.
vim.opt.swapfile = false

-- The number of spaces a tab character is displayed as.
vim.opt.tabstop = 2

-- Enable true color support, which is needed for most modern color schemes.
-- This allows Neovim to display a much wider range of colors.
vim.opt.termguicolors = true

-- The time in milliseconds Neovim waits for a key sequence to complete
-- before assuming you've finished typing. This affects keybindings with a
-- prefix like `<leader>`. A shorter timeout feels more responsive.
vim.opt.timeoutlen = 300

-- Save undo history to a file, so you can undo changes even after closing
-- and reopening a file. This is a very useful feature for preventing data loss.
vim.opt.undofile = true

-- Decrease the update time for events like `CursorHold`. This makes
-- features like autocompletion and diagnostics feel more responsive.
vim.opt.updatetime = 300

-- Enable line wrapping.
-- This is generally a good default, but you can toggle it with a keymap.
vim.opt.wrap = true

-- Configure how diagnostic messages (errors, warnings, etc.) are displayed.
vim.diagnostic.config({
  -- Don't show diagnostic messages as virtual text at the end of a line.
  -- This can be distracting, so we disable it.
  virtual_text = false,
  -- Show diagnostic messages on the current line as a virtual line below it.
  -- This is a good way to see the full error message without cluttering the screen.
  virtual_lines = { current_line = true },
  -- Underline words with diagnostic issues.
  -- This provides a clear visual indicator of where the issue is.
  underline = true,
  -- Don't update diagnostics while in insert mode to avoid distraction.
  -- Diagnostics will be updated when you enter normal mode.
  update_in_insert = false
})