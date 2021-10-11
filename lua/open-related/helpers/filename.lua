local Path = require("plenary.path")

local M = {}

M.match_and_format = function(subject, pattern, format)
  local matches = { subject:match(pattern) }
  if matches == nil or table.maxn(matches) == 0 then
    return nil
  end

  return string.format(format, unpack(matches))
end

M.get_buffer_filename = function(bufnr)
  return Path:new(vim.api.nvim_buf_get_name(bufnr)):normalize(vim.loop.cwd())
end

M.from_patterns = function(patterns)
  return function(bufnr, _)
    local matches = {}
    local filename = M.get_buffer_filename(bufnr)
    for _, pattern in pairs(patterns) do
      local tranformed = M.match_and_format(
        filename,
        pattern.match,
        pattern.format
      )

      if tranformed ~= nil then
        table.insert(matches, {
          file = tranformed,
        })
      end
    end

    return matches
  end
end
return M
