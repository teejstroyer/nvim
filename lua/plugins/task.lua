local M = {}

M.config = {
  sections = {
    todo    = { label = "Backlog", check_style = "[ ]", order = 1 },
    doing   = { label = "In Progress", check_style = "[/]", order = 2 },
    done    = { label = "Completed", check_style = "[x]", order = 3 },
    archive = { label = "Archive", check_style = "[x]", style = "~~", order = 4 },
    wont    = { label = "Wont Do", check_style = "[ ]", style = "~~", order = 5 },
  },
  types = {
    bug  = { style = "**" }, -- Bold
    feat = { style = "_" },  -- Italics
    task = { style = "" }    -- Plain
  },
  date_format = "%Y-%m-%d",
  default_type = "TASK"
}

local function pesc(str) return str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") end

local function find_header_line(header_text)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local pattern = "^#+%s+" .. pesc(header_text) .. "%s*$"
  for i, line in ipairs(lines) do
    if line:match(pattern) then return i end
  end
  return nil
end

local function get_smart_insert_pos(section_id)
  local target_order = M.config.sections[section_id].order or 99
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local best_pos = #lines
  local found_higher = false

  for id, conf in pairs(M.config.sections) do
    local line_idx = find_header_line(conf.label)
    if line_idx then
      if (conf.order or 99) > target_order then
        if not found_higher or line_idx < best_pos then
          best_pos = line_idx - 1
          found_higher = true
        end
      end
    end
  end
  return best_pos
end

function M._perform_move(section_id, line_num)
  local conf = M.config.sections[section_id]
  if not conf then return end

  local curr_line_num = line_num or vim.api.nvim_win_get_cursor(0)[1]
  local line_content = vim.api.nvim_buf_get_lines(0, curr_line_num - 1, curr_line_num, false)[1]

  if not line_content or not line_content:match("^%s*%- %[.%]") then return end

  -- 1. Metadata extraction
  local tag_pattern = "@([%w]+)(|?[^%s]*)"
  local current_tag, metadata = line_content:match(tag_pattern)
  local today = os.date(M.config.date_format)
  local item_type = M.config.default_type

  if metadata then
    local parts = vim.split(metadata, "|", { trimempty = true })
    if #parts >= 1 and not parts[1]:match("%d%d%d%d%-") then item_type = parts[1] end
  end
  local new_metadata = "|" .. item_type .. "|" .. today

  -- 2. Clean Slate: Strip all section and type styles to prevent stacking
  local updated_line = line_content
  for _, s_conf in pairs(M.config.sections) do
    if s_conf.style then updated_line = updated_line:gsub(pesc(s_conf.style), "") end
  end
  for _, t_conf in pairs(M.config.types or {}) do
    if t_conf.style then updated_line = updated_line:gsub(pesc(t_conf.style), "") end
  end

  -- 3. Checkbox swap
  updated_line = updated_line:gsub("^%s*%- %[.%]", "- " .. conf.check_style)

  -- 4. Tagging
  local final_tag = "@" .. section_id .. new_metadata
  if current_tag then
    updated_line = updated_line:gsub("@" .. current_tag .. "[^%s]*", final_tag)
  else
    updated_line = updated_line .. " " .. final_tag
  end

  -- 5. Style Nesting (Type style inside Section style)
  local type_conf = M.config.types[item_type:lower()]
  local s_style = conf.style or ""
  local t_style = (type_conf and type_conf.style) and type_conf.style or ""

  updated_line = updated_line:gsub("(%- %[.%]%s+)(.*)(%s+@)", function(prefix, desc, suffix)
    local styled = t_style .. desc .. t_style -- Apply Type (e.g., Bold)
    styled = s_style .. styled .. s_style     -- Apply Section (e.g., Strikethrough)
    return prefix .. styled .. suffix
  end)

  -- 6. Move to Header
  local header_lnum = find_header_line(conf.label)
  if not header_lnum then
    local ins_point = get_smart_insert_pos(section_id)
    vim.api.nvim_buf_set_lines(0, ins_point, ins_point, false, { "", "## " .. conf.label, "" })
    header_lnum = find_header_line(conf.label)
  end

  vim.api.nvim_buf_set_lines(0, header_lnum, header_lnum, false, { updated_line })
  local del_idx = (header_lnum <= curr_line_num) and curr_line_num or curr_line_num - 1
  vim.api.nvim_buf_set_lines(0, del_idx, del_idx + 1, false, {})

  if not line_num then vim.api.nvim_win_set_cursor(0, { header_lnum + 1, 0 }) end
end

function M.move_task(section_id)
  local mode = vim.api.nvim_get_mode().mode
  if mode:match("[vV\22]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'nx', false)
    vim.schedule(function()
      local l1, l2 = vim.fn.line("'<"), vim.fn.line("'>")
      for i = l2, l1, -1 do M._perform_move(section_id, i) end
    end)
  else
    M._perform_move(section_id)
  end
end

function M.new_task(item_type)
  local function execute(final_type)
    vim.ui.input({ prompt = "Description: " }, function(desc)
      if not desc or desc == "" then return end
      local today = os.date(M.config.date_format)
      local itype = (final_type == nil or final_type == "") and M.config.default_type or final_type:upper()

      -- Insert temp line and use _perform_move to apply styles/positioning
      local temp = "- [ ] " .. desc .. " @todo|" .. itype .. "|" .. today
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, { temp })
      M._perform_move("todo", row + 1)
    end)
  end

  if item_type then
    execute(item_type)
  else
    vim.ui.input({ prompt = "Type (BUG/FEAT/TASK): " }, function(i) execute(i) end)
  end
end

function M.check_and_sync()
  local line = vim.api.nvim_get_current_line()
  for id, conf in pairs(M.config.sections) do
    if line:match("^%s*%- " .. pesc(conf.check_style)) then
      if line:match("@([%w]+)") ~= id then M._perform_move(id) end
      return
    end
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  local group = vim.api.nvim_create_augroup("TaskOrganizer", { clear = true })
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = group,
    pattern = "*.md",
    callback = function() vim.schedule(function() M.check_and_sync() end) end,
  })
end

return M
