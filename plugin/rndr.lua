-- ===========================================================================
-- 3D Model Renderer & Preview (rndr.nvim)
-- ===========================================================================

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'rndr.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
  end,
})

vim.pack.add({
  "https://github.com/SalarAlo/rndr.nvim",
})

require("rndr").setup({
  preview = { auto_open = true },
  git = { timeout = 900 },
})

local plugin_info = vim.pack.get({ "rndr.nvim" })[1]
if plugin_info and not vim.uv.fs_stat(plugin_info.path .. "/renderer/build/rndr") then
  vim.system({ 'make' }, { cwd = plugin_info.path })
end
