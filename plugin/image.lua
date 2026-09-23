-- ===========================================================================
-- Image Suite (Clipboard Pasting & Native vim.ui.img Viewport Renderer)
-- ===========================================================================

-- 1. Paste Images from Clipboard (<leader>p)
vim.pack.add({
  'https://github.com/HakonHarnes/img-clip.nvim',
})

vim.keymap.set("n", "<leader>p", function()
  require('img-clip').pasteImage()
end, { desc = "Paste Image from Clipboard", silent = true })

-- 2. Native Multi-Image Viewport Renderer using Neovim 0.13+ `vim.ui.img`
local api = vim.api
local fn = vim.fn

local ns = api.nvim_create_namespace("native_image_preview")

-- Max viewport bounds
local MAX_CELL_HEIGHT = 16
local MAX_CELL_WIDTH = 60
local DEFAULT_CELL_HEIGHT = 12
local DEFAULT_CELL_WIDTH = 40

-- Cache for processed PNG blobs: blob_cache[resolved_path] = raw_png_bytes
local blob_cache = {}

-- Cache for extracted pixel dimensions: dim_cache[resolved_path] = { w = width, h = height }
local dim_cache = {}

-- Pending fetch callbacks to avoid duplicate simultaneous downloads
local pending_fetches = {}

-- Tracked image specs per buffer:
-- buf_specs[buf] = { [extmark_id] = { file = path, line_idx = idx, cell_w = w, cell_h = h } }
local buf_specs = {}

-- Active on-screen Kitty placements per window:
-- win_placements[win] = { [extmark_id] = { img_id = id, row = r, col = c, width = w, height = h } }
local win_placements = {}

local function is_web(file)
  return file:sub(1, 4) == "http"
end

local function url_decode(str)
  return (str:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

-- Extract PNG image dimensions directly from binary IHDR chunk
local function get_png_dimensions(blob)
  if type(blob) ~= "string" or #blob < 24 then
    return nil, nil
  end
  if blob:sub(1, 8) ~= "\137PNG\r\n\026\n" then
    return nil, nil
  end
  local w1, w2, w3, w4 = blob:byte(17, 20)
  local h1, h2, h3, h4 = blob:byte(21, 24)
  local width = w1 * 16777216 + w2 * 65536 + w3 * 256 + w4
  local height = h1 * 16777216 + h2 * 65536 + h3 * 256 + h4
  return width, height
end

-- Fast header check for local PNG files without loading full file into memory
local function get_file_dimensions(filepath)
  if dim_cache[filepath] then
    return dim_cache[filepath].w, dim_cache[filepath].h
  end

  if not is_web(filepath) then
    local ext = fn.fnamemodify(filepath, ":e"):lower()
    if ext == "png" and fn.filereadable(filepath) == 1 then
      local fd = io.open(filepath, "rb")
      if fd then
        local header = fd:read(24)
        fd:close()
        local w, h = get_png_dimensions(header)
        if w and h then
          dim_cache[filepath] = { w = w, h = h }
          return w, h
        end
      end
    end
  end

  if blob_cache[filepath] then
    local w, h = get_png_dimensions(blob_cache[filepath])
    if w and h then
      dim_cache[filepath] = { w = w, h = h }
      return w, h
    end
  end

  return nil, nil
end

-- Calculate proportional cell width & height keeping the image's original aspect ratio.
-- In standard monospace fonts, terminal cells have an aspect ratio of ~1:2 (width:height ~ 0.5).
local function calculate_cell_dimensions(pixel_w, pixel_h, max_w, max_h)
  if not pixel_w or not pixel_h or pixel_w <= 0 or pixel_h <= 0 then
    return math.min(DEFAULT_CELL_WIDTH, max_w), math.min(DEFAULT_CELL_HEIGHT, max_h)
  end

  local aspect = pixel_w / pixel_h
  -- To maintain visual aspect ratio in 1:2 monospace cells: cols = 2 * aspect * rows
  local target_h = max_h
  local target_w = math.floor(2 * aspect * target_h + 0.5)

  if target_w > max_w then
    target_w = max_w
    target_h = math.max(3, math.floor(target_w / (2 * aspect) + 0.5))
  end

  target_h = math.min(math.max(3, target_h), max_h)
  target_w = math.min(math.max(6, target_w), max_w)

  return target_w, target_h
end

-- Extract image path/URL from Markdown image syntax: ![alt](path)
local function parse_image(line)
  local target = line:match("%!%[.-%]%((.-)%)")
  if not target then
    return nil
  end

  target = target:match("^%s*(.-)%s*$")
  if not target or target == "" then
    return nil
  end

  -- Handle angle brackets <url>
  local inner_angle = target:match("^<([^>]+)>")
  if inner_angle then
    return inner_angle
  end

  -- Handle quoted paths: "path" or 'path' (supports spaces in path)
  local quoted = target:match('^"([^"]+)"') or target:match("^'([^']+)'")
  if quoted then
    return quoted
  end

  -- Handle paths followed by optional title: path "title"
  local without_title = target:match('^(.-)%s+["\'].*["\']$')
  if without_title then
    target = without_title
  end

  return target
end

-- Resolve file paths relative to cwd or the buffer's folder
local function resolve_path(raw_path, buf)
  if is_web(raw_path) then
    return raw_path
  end

  local decoded = url_decode(raw_path)
  local candidates = { decoded }
  if decoded ~= raw_path then
    table.insert(candidates, raw_path)
  end

  for _, path_str in ipairs(candidates) do
    local expanded = fn.expand(path_str)
    expanded = vim.fs.normalize(expanded)
    if fn.filereadable(expanded) == 1 then
      return fn.fnamemodify(expanded, ":p")
    end

    local buf_name = api.nvim_buf_get_name(buf or 0)
    if buf_name ~= "" then
      local buf_dir = vim.fs.dirname(buf_name)
      local candidate = vim.fs.joinpath(buf_dir, path_str)
      candidate = vim.fs.normalize(fn.expand(candidate))
      if fn.filereadable(candidate) == 1 then
        return fn.fnamemodify(candidate, ":p")
      end
    end
  end

  return nil
end

-- Convert image to PNG format required by Neovim's Kitty graphics driver
local function get_png_blob(filepath, ext_hint, callback)
  local ext = ext_hint or fn.fnamemodify(filepath, ":e"):lower()
  if ext == "png" then
    if fn.filereadable(filepath) == 1 then
      callback(fn.readblob(filepath))
    end
    return
  end

  local input_file = filepath
  local needs_cleanup = false
  if fn.fnamemodify(filepath, ":e") == "" and ext ~= "" then
    input_file = filepath .. "." .. ext
    vim.uv.fs_rename(filepath, input_file)
    needs_cleanup = true
  end

  -- Convert formats (svg, jpg, webp, gif) using macOS native `sips`
  local tmp_png = fn.tempname() .. ".png"
  fn.jobstart({ "sips", "-s", "format", "png", input_file, "--out", tmp_png }, {
    on_exit = function(_, code)
      if needs_cleanup then
        pcall(os.remove, input_file)
      end
      if code == 0 and fn.filereadable(tmp_png) == 1 then
        local blob = fn.readblob(tmp_png)
        pcall(os.remove, tmp_png)
        callback(blob)
      end
    end,
  })
end

-- Asynchronously fetch image blob with in-memory caching
local function get_blob(file, callback)
  if blob_cache[file] then
    callback(blob_cache[file])
    return
  end

  if pending_fetches[file] then
    table.insert(pending_fetches[file], callback)
    return
  end

  pending_fetches[file] = { callback }

  local function on_ready(blob)
    if blob then
      blob_cache[file] = blob
      local w, h = get_png_dimensions(blob)
      if w and h then
        dim_cache[file] = { w = w, h = h }
      end
    end
    local cbs = pending_fetches[file] or {}
    pending_fetches[file] = nil
    for _, cb in ipairs(cbs) do
      cb(blob)
    end
  end

  if not is_web(file) then
    get_png_blob(file, nil, on_ready)
  else
    local url_clean = file:match("^[^?#]+") or file
    local ext = fn.fnamemodify(url_clean, ":e"):lower()
    if ext == "" then
      ext = "png"
    end

    local tmp_file = fn.tempname() .. "." .. ext
    fn.jobstart({ "curl", "-sL", file, "-o", tmp_file }, {
      on_exit = function(_, code)
        if code == 0 and fn.filereadable(tmp_file) == 1 then
          get_png_blob(tmp_file, ext, function(blob)
            pcall(os.remove, tmp_file)
            on_ready(blob)
          end)
        else
          on_ready(nil)
        end
      end,
    })
  end
end

-- Clear all terminal Kitty placements in a window
local function clear_win_placements(win)
  if win_placements[win] then
    for _, entry in pairs(win_placements[win]) do
      if entry.img_id and vim.ui and vim.ui.img then
        pcall(vim.ui.img.del, entry.img_id)
      end
    end
    win_placements[win] = nil
  end
end

-- Clear buffer extmarks and window placements
local function clear_buffer_images(buf)
  buf_specs[buf] = nil
  if api.nvim_buf_is_valid(buf) then
    pcall(api.nvim_buf_clear_namespace, buf, ns, 0, -1)
  end
  for win, _ in pairs(win_placements) do
    if not api.nvim_win_is_valid(win) or api.nvim_win_get_buf(win) == buf then
      clear_win_placements(win)
    end
  end
end

-- Pre-calculate and attach proportional virtual lines to each image in the buffer
local function sync_buffer_virtual_lines(buf)
  if not api.nvim_buf_is_valid(buf) then
    return
  end

  local ft = vim.bo[buf].filetype
  if ft ~= "markdown" and ft ~= "md" then
    return
  end

  local line_count = api.nvim_buf_line_count(buf)
  local lines = api.nvim_buf_get_lines(buf, 0, line_count, false)
  local new_specs = {}

  local max_cols = vim.o.columns
  local max_w = math.min(MAX_CELL_WIDTH, max_cols - 10)

  -- Clear previous virtual lines before resyncing
  pcall(api.nvim_buf_clear_namespace, buf, ns, 0, -1)

  for i, line_text in ipairs(lines) do
    local raw_file = parse_image(line_text)
    if raw_file then
      local file = resolve_path(raw_file, buf)
      if file then
        local line_idx = i - 1

        -- Determine proportional dimensions
        local pw, ph = get_file_dimensions(file)
        local cell_w, cell_h = calculate_cell_dimensions(pw, ph, max_w, MAX_CELL_HEIGHT)

        local virt_lines = {}
        for _ = 1, cell_h do
          table.insert(virt_lines, { { "", "" } })
        end

        local ok, extmark_id = pcall(api.nvim_buf_set_extmark, buf, ns, line_idx, 0, {
          virt_lines = virt_lines,
          virt_lines_above = false,
        })

        if ok and extmark_id then
          new_specs[extmark_id] = {
            file = file,
            line_idx = line_idx,
            cell_w = cell_w,
            cell_h = cell_h,
          }
        end
      end
    end
  end

  buf_specs[buf] = new_specs
end

-- Synchronize visible Kitty graphics placements for a window
local function sync_win_placements(win)
  if not (vim.ui and vim.ui.img) then
    return
  end

  if not api.nvim_win_is_valid(win) then
    clear_win_placements(win)
    return
  end

  local buf = api.nvim_win_get_buf(win)
  if not api.nvim_buf_is_valid(buf) then
    return
  end

  local ft = vim.bo[buf].filetype
  if ft ~= "markdown" and ft ~= "md" then
    clear_win_placements(win)
    return
  end

  if not buf_specs[buf] then
    sync_buffer_virtual_lines(buf)
  end

  local specs = buf_specs[buf] or {}
  if not win_placements[win] then
    win_placements[win] = {}
  end
  local placements = win_placements[win]

  local max_rows = vim.o.lines - vim.o.cmdheight - 1
  local max_cols = vim.o.columns

  for extmark_id, spec in pairs(specs) do
    local extmark_pos = api.nvim_buf_get_extmark_by_id(buf, ns, extmark_id, {})
    if #extmark_pos == 0 then
      if placements[extmark_id] then
        pcall(vim.ui.img.del, placements[extmark_id].img_id)
        placements[extmark_id] = nil
      end
    else
      local markdown_line = extmark_pos[1] + 1
      local image_line = extmark_pos[1] + 2
      local cur_pos = fn.screenpos(win, markdown_line, 1)
      local img_pos = fn.screenpos(win, image_line, 1)

      -- Check if image line is visible on screen
      if img_pos.row > 0 and img_pos.row < max_rows then
        local cell_w = spec.cell_w or DEFAULT_CELL_WIDTH
        local cell_h = spec.cell_h or DEFAULT_CELL_HEIGHT
        local screen_row = img_pos.row
        local display_height = math.min(cell_h, max_rows - screen_row + 1)

        if display_height >= 2 then
          local screen_col = math.min(math.max(1, cur_pos.col), math.max(1, max_cols - cell_w))
          local entry = placements[extmark_id]

          if entry and entry.img_id then
            -- Update placement position if it moved on screen
            if screen_row ~= entry.row or screen_col ~= entry.col or display_height ~= entry.height then
              pcall(vim.ui.img.set, entry.img_id, {
                row = screen_row,
                col = screen_col,
                width = cell_w,
                height = display_height,
              })
              entry.row = screen_row
              entry.col = screen_col
              entry.height = display_height
            end
          elseif not entry then
            get_blob(spec.file, function(blob)
              if not blob then
                return
              end
              vim.schedule(function()
                if not api.nvim_win_is_valid(win) or api.nvim_win_get_buf(win) ~= buf then
                  return
                end

                local latest_pos = fn.screenpos(win, line_num, 1)
                if latest_pos.row == 0 or latest_pos.row >= max_rows then
                  return
                end

                -- Recalculate dimensions once blob is available if not known initially
                local pw, ph = get_png_dimensions(blob)
                local final_w, final_h = calculate_cell_dimensions(pw, ph, math.min(MAX_CELL_WIDTH, max_cols - 10), MAX_CELL_HEIGHT)

                -- Update extmark virtual lines if height changed to match aspect ratio
                if final_h ~= spec.cell_h then
                  spec.cell_w = final_w
                  spec.cell_h = final_h
                  local virt_lines = {}
                  for _ = 1, final_h do
                    table.insert(virt_lines, { { "", "" } })
                  end
                  pcall(api.nvim_buf_set_extmark, buf, ns, extmark_pos[1], 0, {
                    id = extmark_id,
                    virt_lines = virt_lines,
                    virt_lines_above = false,
                  })
                  vim.cmd("redraw")
                  latest_pos = fn.screenpos(win, line_num, 1)
                  if latest_pos.row == 0 or latest_pos.row >= max_rows then
                    return
                  end
                end

                local cur_srow = latest_pos.row + spec.cell_h
                local cur_h = math.min(final_h, max_rows - cur_srow + 1)
                if cur_h < 2 then
                  return
                end

                local cur_scol = math.min(math.max(1, latest_pos.col), math.max(1, max_cols - final_w))

                local ok, img_id = pcall(vim.ui.img.set, blob, {
                  row = cur_srow,
                  col = cur_scol,
                  width = final_w,
                  height = cur_h,
                })

                if ok and img_id then
                  placements[extmark_id] = {
                    img_id = img_id,
                    row = cur_srow,
                    col = cur_scol,
                    width = final_w,
                    height = cur_h,
                  }
                end
              end)
            end)
          end
        else
          if placements[extmark_id] then
            pcall(vim.ui.img.del, placements[extmark_id].img_id)
            placements[extmark_id] = nil
          end
        end
      else
        if placements[extmark_id] then
          pcall(vim.ui.img.del, placements[extmark_id].img_id)
          placements[extmark_id] = nil
        end
      end
    end
  end
end

-- Refresh visible placements across active window
local function refresh_all_windows()
  local current_win = api.nvim_get_current_win()
  if api.nvim_win_is_valid(current_win) then
    sync_win_placements(current_win)
  end
end

local timer = vim.uv.new_timer()
local function schedule_placement_sync(delay_ms)
  delay_ms = delay_ms or 20
  if timer then
    timer:stop()
    timer:start(delay_ms, 0, vim.schedule_wrap(refresh_all_windows))
  end
end

local group = api.nvim_create_augroup("NativeImagePreview", { clear = true })

-- Sync buffer virtual lines on file open or text modification
api.nvim_create_autocmd({ "BufReadPost", "BufEnter", "TextChanged" }, {
  group = group,
  callback = function(ev)
    sync_buffer_virtual_lines(ev.buf)
    schedule_placement_sync(10)
  end,
})

-- Synchronize Kitty image placements when scrolling or moving cursor
api.nvim_create_autocmd({ "WinScrolled", "CursorMoved", "CursorMovedI", "VimResized" }, {
  group = group,
  callback = function()
    schedule_placement_sync(20)
  end,
})

-- Clean up image placements when leaving a window
api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  group = group,
  callback = function(ev)
    clear_win_placements(api.nvim_get_current_win())
  end,
})

-- Clean up deleted buffers
api.nvim_create_autocmd({ "BufDelete", "BufUnload" }, {
  group = group,
  callback = function(ev)
    clear_buffer_images(ev.buf)
  end,
})

api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = function()
    if vim.ui and vim.ui.img then
      pcall(vim.ui.img.del, math.huge)
    end
  end,
})
