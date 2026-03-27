-- ===========================================================================
-- Image Viewer
-- ===========================================================================
-- This file configures image.nvim, a plugin that allows you to view images
-- directly within Neovim.

--Auto command needs to be registered first...
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    -- Use available |event-data|
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'rndr.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end
})

vim.pack.add({
  "https://github.com/3rd/image.nvim",
  "https://github.com/SalarAlo/rndr.nvim", --Renders images and 3d objects? WHAT
})

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

require("rndr").setup({
  preview = {
    auto_open = true,
  },
})
