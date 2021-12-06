local Object = require("plenary.class")

local Relation = Object:extend()

function Relation:new(filetypes, related_to, condition, opts)
  assert(type(filetypes) == "table", "filetypes should be a table")
  assert(type(related_to) == "function", "related_to should be a function")
  assert(type(condition) == "function" or condition == nil, "condition should be a function or nil")
  assert(type(opts) == "table" or opts == nil, "Opts should be a table or nil")

  return setmetatable({
    filetypes = filetypes,
    related_to = related_to,
    condition = condition or nil,
    opts = opts or nil,
  }, self)
end

function Relation:filetype_matches(ft)
  return vim.tbl_isempty(self.filetypes) or vim.tbl_contains(self.filetypes, ft)
end

function Relation:should_run(bufnr)
  return self.condition == nil or self.condition(bufnr)
end

function Relation:resolve(bufnr)
  return self.related_to(bufnr, self.opts) or {}
end

return Relation
