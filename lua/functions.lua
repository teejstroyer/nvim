----------------------------------------------------
-- FUNCTIONS
----------------------------------------------------
-- This file is for storing custom Lua functions that you can call from
-- other parts of your Neovim configuration, such as keymaps or autocmds.

-- A custom function to insert the current date in YYYY-MM-DD format.
function InsertDate()
  -- Get the current date from the operating system.
  local date = os.date("%Y-%m-%d")
  -- Insert the date string at the current cursor position.
  vim.api.nvim_put({ tostring(date) }, "", true, true)
end

-- Create a user-defined command called `:InsertDate` that calls the `InsertDate` function.
-- This allows you to type `:InsertDate` in normal mode to execute the function.
vim.api.nvim_create_user_command("InsertDate", InsertDate, {})

-- Function to check for plugin updates once a day
function CheckPluginUpdates()
  local state_path = vim.fn.stdpath("data") .. "/plugin_update_time.txt"
  local last_update = 0
  local f = io.open(state_path, "r")
  if f then
    last_update = tonumber(f:read("*all")) or 0
    f:close()
  end

  local current_time = os.time()
  if (current_time - last_update) < (24 * 60 * 60) then
    vim.notify("Skipping Update")
    return
  end

  local updates = {}
  local deletes = {}

  for _, plugin in ipairs(vim.pack.get()) do
    if not plugin.active then
      table.insert(deletes, plugin.spec.name)
    else
      table.insert(updates, plugin.spec.name)
    end
  end

  if #deletes > 0 then
    vim.pack.del(deletes)
  end

  if #updates > 0 then
    vim.pack.update(updates, { force = true })
  end

  local f_write = io.open(state_path, "w")
  if f_write then
    f_write:write(tostring(current_time))
    f_write:close()
  end
end