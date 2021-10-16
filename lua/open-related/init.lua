local Relation = require("open-related.relation")
local Relations = require("open-related.relations")
local Path = require("plenary.path")

local M = {}

M.state = {
  config = {
    open_with = "telescope",
    create_with = "inputlist",
  },
  relations = {},
  opener = nil,
  creator = nil,
}

M.setup = function(config)
  M.state.relations = Relations:new()
  M.state.config = vim.tbl_deep_extend("force", M.state.config, config)

  local success, opener = pcall(
    require,
    "open-related.opener." .. M.state.config.open_with
  )
  if not success then
    print("OpenRelated: Invalid value for 'open_with' config")
    return
  end

  opener.setup()
  M.state.opener = opener

  local success, creator = pcall(
    require,
    "open-related.creator." .. M.state.config.create_with
  )
  if not success then
    print("OpenRelated: Invalid value for 'create_with' config")
    return
  end

  creator.setup()
  M.state.creator = creator

  vim.cmd([[
    command! OpenRelated lua require("open-related").open_related()
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

M.open_related = function()
  M.state.opener.open()
end

M.create_related = function()
  M.state.creator.create()
end

M.find_creatable = function()
  return M.state.relations:resolve_creatable(vim.api.nvim_get_current_buf())
end

return M
