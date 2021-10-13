local Relation = require("open-related.relation")
local Relations = require("open-related.relations")
local Path = require("plenary.path")

local M = {}

M.state = {
  config = {},
  relations = {},
}

M.setup = function()
  M.state.relations = Relations:new()
  require("telescope").load_extension("related")
  vim.cmd([[
    command! OpenRelated Telescope related
    command! CreateRelated lua require("open-related").create_related()
  ]])
end

M.add_relation = function(options)
  M.state.relations:add(
    Relation:new(
      options.filetypes,
      options.related_to,
      options.condition or nil,
      options.opts or nil
    )
  )
end

M.find_related = function()
  return M.state.relations:resolve_related(vim.api.nvim_get_current_buf())
end

M.create_related = function()
  local creatable = M.state.relations:resolve_creatable(
    vim.api.nvim_get_current_buf()
  )

  local input = {}
  for index, value in pairs(creatable) do
    table.insert(input, index .. "." .. value.file)
  end
  local choice = vim.fn.inputlist(input)

  Path:new(creatable[choice].file):touch({ parents = true })
  vim.cmd(string.format("edit %s", creatable[choice].file))
end

return M
