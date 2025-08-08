-- ===========================================================================
-- Image Clip
-- ===========================================================================
-- This file configures img-clip.nvim, a plugin that allows you to paste
-- images from your clipboard directly into Neovim.

-- --- Image Pasting ---
vim.pack.add({ 'https://github.com/HakonHarnes/img-clip.nvim' })

-- Set a keymap to paste an image from the clipboard.
-- This is useful for quickly adding images to Markdown files or other documents.
vim.keymap.set("n", "<leader>p", require('img-clip').pasteImage, { desc = "Paste Image from Clipboard", silent = true })