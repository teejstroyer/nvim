local M = {}
--https://minimal.guide/checklists--
-- - [ ]	to-do
-- - [/]	incomplete
-- - [x]	done
-- - [-]	canceled
-- - [>]	forwarded
-- - [<]	scheduling
-- - [?]	question
-- - [!]	important
-- - [*]	star
-- - ["]	quote
-- - [l]	location
-- - [b]	bookmark
-- - [i]	information
-- - [S]	savings
-- - [I]	idea
-- - [p]	pros
-- - [c]	cons
-- - [f]	fire
-- - [k]	key
-- - [w]	win
-- - [u]	up
-- - [d]	down

M.config = {
  sections = {
    todo      = { label = "Todo", check_style = "[ ]", order = 1, color = "#ff9e64" },
    doing     = { label = "In Progress", check_style = "[/]", order = 2, color = "#7aa2f7" },
    done      = { label = "Completed", check_style = "[x]", order = 3, color = "#9ece6a" },
    archive   = { label = "Archive", check_style = "[b]", style = "~~", order = 4, color = "#565f89" },
    cancelled = { label = "Cancelled", check_style = "[-]", style = "~~", order = 5, color = "#444b6a" },
    wont      = { label = "Wont Do", check_style = "[d]", style = "~~", order = 6, color = "#f7768e" },
  },
  highlights = {
    metadata = { fg = "#565f89", italic = true }
  },
  types = {
    bug  = { style = "**", color = "#f7768e" },
    feat = { style = "_", color = "#bb9af7" },
    task = { style = "", color = "#7aa2f7" }
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

local function get_physical_section_id(line_num)
  local lnum = line_num or vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, lnum, false)
  for i = #lines, 1, -1 do
    local label = lines[i]:match("^#+%s+(.*)$")
    if label then
      for id, conf in pairs(M.config.sections) do
        if conf.label == label then return id end
      end
    end
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

function M._format_line(line_content, section_id, force_today)
  local conf = M.config.sections[section_id]
  if not conf then return line_content end

  local tag_pattern = "@([%w]+)|?([^%s|]*)%|?([^%s]*)"
  local current_tag, current_type, current_date = line_content:match(tag_pattern)

  local manual_type = line_content:match("|([^%s|]+)|")
  local item_type = (manual_type or current_type or M.config.default_type):upper()

  local today = os.date(M.config.date_format)
  local final_date = (not force_today and current_date and current_date:match("%d%d%d%d%-")) and current_date or today

  local updated = line_content
  for _, s in pairs(M.config.sections) do if s.style then updated = updated:gsub(pesc(s.style), "") end end
  for _, t in pairs(M.config.types) do if t.style then updated = updated:gsub(pesc(t.style), "") end end

  updated = updated:gsub("^%s*%- %[.%]", "- " .. conf.check_style)
  local metadata = "@" .. section_id .. "|" .. item_type .. "|" .. final_date
  if line_content:match("@%w+") then
    updated = updated:gsub("@%w+[^%s]*", metadata)
  else
    updated = updated .. " " .. metadata
  end

  local t_conf = M.config.types[item_type:lower()]
  local s_style, t_style = conf.style or "", (t_conf and t_conf.style) or ""

  return updated:gsub("(%- %[.%]%s+)(.*)(%s+@)", function(p, d, s)
    return p .. s_style .. t_style .. d .. t_style .. s_style .. s
  end)
end

function M._perform_move(section_id, line_num)
  local conf = M.config.sections[section_id]
  local curr_lnum = line_num or vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, curr_lnum - 1, curr_lnum, false)[1]
  if not line or not line:match("^%s*%- %[.%]") then return end

  local updated_line = M._format_line(line, section_id, true)
  local target_h = find_header_line(conf.label)
  if not target_h then
    local ins = get_smart_insert_pos(section_id)
    vim.api.nvim_buf_set_lines(0, ins, ins, false, { "", "## " .. conf.label, "" })
    target_h = find_header_line(conf.label)
  end

  vim.api.nvim_buf_set_lines(0, target_h, target_h, false, { updated_line })
  local del_idx = (target_h <= curr_lnum) and curr_lnum or curr_lnum - 1
  vim.api.nvim_buf_set_lines(0, del_idx, del_idx + 1, false, {})
  if not line_num then vim.api.nvim_win_set_cursor(0, { target_h + 1, 0 }) end
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

function M.new_task(itype)
  vim.ui.input({ prompt = "Description: " }, function(desc)
    if not desc or desc == "" then return end
    local final_type = (itype == nil or itype == "") and M.config.default_type or itype:upper()
    local temp = "- [ ] " .. desc .. " @todo|" .. final_type .. "|" .. os.date(M.config.date_format)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, { temp })
    M._perform_move("todo", row + 1)
  end)
end

function M.sync_line()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  if not line:match("^%s*%- %[.%]") then return end

  local physical_id = get_physical_section_id(lnum)
  if not physical_id then return end

  local tag_id = line:match("@([%w]+)")
  if tag_id and M.config.sections[tag_id] and tag_id ~= physical_id then
    M._perform_move(tag_id)
    return
  end

  for id, conf in pairs(M.config.sections) do
    if line:match("^%s*%- " .. pesc(conf.check_style)) and id ~= physical_id then
      M._perform_move(id)
      return
    end
  end

  local correct = M._format_line(line, physical_id, false)
  if correct ~= line then
    vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { correct })
  end
end

function M.sync_buffer()
  local i = 1
  while i <= vim.api.nvim_buf_line_count(0) do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:match("^%s*%- %[.%]") then
      local tag_id = line:match("@([%w]+)")
      local physical_id = get_physical_section_id(i)
      if (tag_id and M.config.sections[tag_id] and tag_id ~= physical_id) then
        M._perform_move(tag_id, i)
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end
end

function M.apply_highlights()
  -- 1. Create the Section Tag & Checkbox highlights (@todo and [ ])
  for id, conf in pairs(M.config.sections) do
    if conf.color then
      local suffix = id:gsub("^%l", string.upper)
      local tag_hl = "TaskGroup" .. suffix
      local check_hl = "TaskCheck" .. suffix

      -- Tag Highlight (@todo)
      vim.api.nvim_set_hl(0, tag_hl, { fg = conf.color, bold = true })
      vim.cmd(string.format([[syntax match %s "@%s"]], tag_hl, id))

      -- Checkbox Highlight ([ ]) - Moved here where 'conf' and 'id' are valid
      vim.api.nvim_set_hl(0, check_hl, { fg = conf.color })
      vim.cmd(string.format([[syntax match %s "^\s*-\s*%s"]], check_hl, pesc(conf.check_style)))
    end
  end

  -- 2. Define the Type highlights (|BUG|, |FEAT|) with 'contained'
  local type_groups = {}
  for tid, tconf in pairs(M.config.types) do
    if tconf.color then
      local hl = "TaskType" .. tid:upper()
      table.insert(type_groups, hl)
      vim.api.nvim_set_hl(0, hl, { fg = tconf.color, bold = true })
      -- Match the type name specifically inside pipes
      vim.cmd(string.format([[syntax match %s "\<%s\>" contained]], hl, tid:upper()))
    end
  end

  -- 3. Define the Metadata wrapper (the pipes and date)
  vim.api.nvim_set_hl(0, "TaskMetadata", M.config.highlights.metadata)
  local contains_list = table.concat(type_groups, ",")
  -- 'contains' allows TaskType highlights to show through the Metadata highlight
  vim.cmd(string.format([[syntax match TaskMetadata "|[^ ]*|" contains=%s]], contains_list))
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- VALIDATION: Check for duplicate check_styles
  local seen_styles = {}
  for id, conf in pairs(M.config.sections) do
    if seen_styles[conf.check_style] then
      error(string.format(
        "[TaskOrganizer] Configuration Error: Sections '%s' and '%s' share the same check_style '%s'. Styles must be unique.",
        seen_styles[conf.check_style], id, conf.check_style
      ))
    end
    seen_styles[conf.check_style] = id
  end

  local group = vim.api.nvim_create_augroup("TaskOrganizer", { clear = true })
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    group = group, pattern = "*.md", callback = function() vim.schedule(M.sync_line) end,
  })
  vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
    group = group,
    pattern = "*.md",
    callback = function()
      vim.schedule(function()
        M.sync_buffer(); M.apply_highlights()
      end)
    end,
  })
  vim.api.nvim_create_user_command("TaskSync", M.sync_buffer, {})
  for id, _ in pairs(M.config.sections) do
    local name = "Task" .. id:gsub("^%l", string.upper)
    vim.api.nvim_create_user_command(name, function(c)
      if c.range > 0 then
        for i = c.line2, c.line1, -1 do M._perform_move(id, i) end
      else
        M._perform_move(id)
      end
    end, { range = true })
  end
end

return M
