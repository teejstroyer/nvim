-- ===========================================================================
-- Image Viewer
-- ===========================================================================
-- This file configures image.nvim, a plugin that allows you to view images
-- directly within Neovim.

vim.pack.add({ "https://github.com/3rd/image.nvim"})

-- Configure the image viewer.
require("image").setup({
  -- The backend to use for displaying images. `kitty` is a popular choice
  -- for terminals that support the kitty graphics protocol.
  backend = "kitty",
  kitty_method = "normal",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      floating_windows = true
    }
  }
})