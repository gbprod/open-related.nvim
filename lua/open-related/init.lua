local Relation = require("open-related.relation")
local Relations = require("open-related.relations")

local M = {}

M.config = {
  open_with = "telescope",
  create_with = "telescope",
}

M.relations = {}
M.open = nil
M.create = nil

M.setup = function(config)
  M.relations = Relations:new()
  M.config = vim.tbl_deep_extend("force", M.config, config)

  M.open = M.load("opener", M.config.open_with)
  M.create = M.load("creator", M.config.create_with)

  vim.cmd([[
    command! OpenRelated lua require("open-related").open_related()
    command! CreateRelated lua require("open-related").create_related()
  ]])
end

M.load = function(type, value)
  local success, loaded = pcall(
    require,
    "open-related." .. type .. "." .. value
  )

  assert(
    success,
    "OpenRelated: Invalid value " .. value .. " for '" .. type .. "'"
  )

  return loaded
end

M.add_relation = function(options)
  M.relations:add(
    Relation:new(
      options.filetypes,
      options.related_to,
      options.condition or nil,
      options.opts or nil
    )
  )
end

M.open_related = function(bufnr, opts)
  local relations = M.relations:resolve_related(
    bufnr or vim.api.nvim_get_current_buf()
  )

  if vim.tbl_isempty(relations) then
    print("No related file found")
    return
  end

  if opts ~= nil and opts.open_with ~= nil then
    M.load("opener", opts.open_with)(relations)
  end

  M.open(relations)
end

M.create_related = function(bufnr, opts)
  local relations = M.relations:resolve_creatable(
    bufnr or vim.api.nvim_get_current_buf()
  )

  if vim.tbl_isempty(relations) then
    print("No creatable file found")
    return
  end

  if opts ~= nil and opts.create_with ~= nil then
    M.load("creator", opts.create_with)(relations)
  end

  M.create(relations)
end

return M
