local Relation = require("open-related.relation")
local Relations = require("open-related.relations")

local M = {}

M.config = {
  open_with = "telescope",
  create_with = "inputlist",
}

M.relations = {}
M.opener = nil
M.creator = nil

M.setup = function(config)
  M.relations = Relations:new()
  M.config = vim.tbl_deep_extend("force", M.config, config)

  local load = function(type, value)
    local success, loaded = pcall(
      require,
      "open-related." .. type .. "." .. value
    )

    assert(
      success,
      "OpenRelated: Invalid value " .. value .. " for '" .. type .. "'"
    )

    loaded.setup()

    return loaded
  end

  M.opener = load("opener", M.config.open_with)
  M.creator = load("creator", M.config.create_with)

  vim.cmd([[
    command! OpenRelated lua require("open-related").open_related()
    command! CreateRelated lua require("open-related").create_related()
  ]])
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

M.open_related = function(bufnr)
  M.opener.open(bufnr or vim.api.nvim_get_current_buf())
end

M.create_related = function(bufnr)
  M.creator.create(bufnr or vim.api.nvim_get_current_buf())
end

return M
