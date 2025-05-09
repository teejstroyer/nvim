----------------------------------------------------
-- FUNCTIONS
----------------------------------------------------
function InsertDate()
  local date = os.date("%Y-%m-%d")

  vim.api.nvim_put({ tostring(date) }, "", true, true)
end

vim.api.nvim_create_user_command("InsertDate", InsertDate, {})

