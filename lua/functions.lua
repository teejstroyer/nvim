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
