local Object = require("plenary.class")
local Path = require("plenary.path")

local Relations = Object:extend()

function Relations:new()
  return setmetatable({
    relations = {},
  }, self)
end

function Relations:add(relation)
  table.insert(self.relations, relation)
end

function Relations:resolve_related(bufnr)
  return vim.tbl_filter(function(entry)
    return Path:new(entry.file):exists()
  end, self:resolve(
    bufnr
  ))
end

function Relations:resolve_creatable(bufnr)
  return vim.tbl_values(vim.tbl_filter(function(entry)
    return not Path:new(entry.file):exists()
  end, self:resolve(
    bufnr
  )))
end

function Relations:resolve(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local related = {}

  for _, relation in pairs(self.relations) do
    if relation:filetype_matches(ft) and relation:should_run(bufnr) then
      related = table.merge(related, relation:resolve(bufnr))
    end
  end

  return related
end

return Relations
