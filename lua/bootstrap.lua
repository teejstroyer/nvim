return { init = function()
-- Creates a server in the cache  on boot, useful for Godot
-- https://ericlathrop.com/2024/02/configuring-neovim-s-lsp-to-work-with-godot/
local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.loop.fs_stat(pipepath) then
  vim.fn.serverstart(pipepath)
end

--##############################################################################
-- local path_package = vim.fn.stdpath('data') .. '/site'
-- local mini_path = path_package .. '/pack/deps/start/mini.nvim'
-- if not vim.loop.fs_stat(mini_path) then
--   vim.cmd('echo "Installing `mini.nvim`" | redraw')
--   local clone_cmd = {
--     'git', 'clone', '--filter=blob:none',
--     'https://github.com/echasnovski/mini.nvim', mini_path
--   }
--   vim.fn.system(clone_cmd)
--   vim.cmd('packadd mini.nvim | helptags ALL')
-- end

--Rocks.nvim install
do
  local install_location = vim.fs.joinpath(vim.fn.stdpath("data"), "rocks")
  local rocks_config = { rocks_path = vim.fs.normalize(install_location), }

  vim.g.rocks_nvim = rocks_config

  local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
  }
  package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
  local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
  }
  package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
  vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))
end

-- If rocks.nvim is not installed then install it!
if not pcall(require, "rocks") then
  local rocks_location = vim.fs.joinpath(vim.fn.stdpath("cache"), "rocks.nvim")

  if not vim.uv.fs_stat(rocks_location) then
    -- Pull down rocks.nvim
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/nvim-neorocks/rocks.nvim",
      rocks_location,
    })
  end

  -- If the clone was successful then source the bootstrapping script
  assert(vim.v.shell_error == 0, "rocks.nvim installation failed. Try exiting and re-entering Neovim!")
  vim.cmd.source(vim.fs.joinpath(rocks_location, "bootstrap.lua"))
  vim.fn.delete(rocks_location, "rf")
end

end}
