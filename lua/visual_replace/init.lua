M = {}

M.replace_visual = function()
  local count = vim.v.count
  local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)
  local function Set(list)
    local set = {}
    for _, l in ipairs(list) do
      set[l] = true
    end
    return set
  end
  local escaped_keys = Set({ "<", "[", "\\", "." })
  local vstart = vim.api.nvim_buf_get_mark(0, "<")
  local vend = vim.api.nvim_buf_get_mark(0, ">")
  local line = vim.api.nvim_buf_get_lines(0, vstart[1] - 1, vend[1], 0)
  local text = string.sub(line[1], vstart[2] + 1, vend[2] + 1)
  local escaped_string = text

  local index = 0
  for i = 1, string.len(text) do
    local letter = string.sub(text, i, i)
    if escaped_keys[letter] then
      escaped_string = string.sub(escaped_string, 0, i - 1 + index)
        .. "\\"
        .. string.sub(escaped_string, i + index, string.len(escaped_string))
      index = index + 1
    end
  end

  local return_string_raw
  if count > 0 then
    return_string_raw = ":<C-U>.,.+" .. count .. "s/" .. escaped_string .. "/" .. text .. "/gI<Left><Left><Left>"
  else
    return_string_raw = ":<C-U>%s/" .. escaped_string .. "/" .. text .. "/gI<Left><Left><Left>"
  end
  local return_string = vim.api.nvim_replace_termcodes(return_string_raw, true, false, true)
  vim.api.nvim_feedkeys(return_string, "t", false)
end

return M
