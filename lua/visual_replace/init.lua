local M = {}

M.replace_visual = function()
  local count = vim.v.count
  local keys = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)

  local vstart = vim.api.nvim_buf_get_mark(0, "<")
  local vend = vim.api.nvim_buf_get_mark(0, ">")
  local line = vim.api.nvim_buf_get_lines(0, vstart[1] - 1, vend[1], 0)
  local text = string.sub(line[1], vstart[2] + 1, vend[2] + 1)

  local escaped_characters = {
    ['%"'] = '\\"',
    ["%["] = '\\[',
    ["\\"] = "\\\\",
  }
  local escaped_text = text
  text = string.gsub(text,"\\","\\\\")
  for i, v in pairs(escaped_characters) do
    escaped_text = string.gsub(escaped_text, i, v)
  end

  local return_string_raw
  if count > 0 then
    return_string_raw = ":<C-U>.,.+" .. count .. "s/" .. escaped_text .. "/" .. text .. "/gI<Left><Left><Left>"
  else
    return_string_raw = ":<C-U>%s/" .. escaped_text .. "/" .. text .. "/gI<Left><Left><Left>"
  end
  local return_string = vim.api.nvim_replace_termcodes(return_string_raw, true, false, true)
  vim.api.nvim_feedkeys(return_string, "t", false)
end

return M
