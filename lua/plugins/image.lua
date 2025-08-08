vim.pack.add({ "https://github.com/3rd/image.nvim"})
require("image").setup({
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
