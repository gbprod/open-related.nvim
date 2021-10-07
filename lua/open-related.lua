local M = {}

local api = vim.api
local finder = require("open-related/finders/telescope")

M.state = {
  config = {},
  relations = {},
}

M.setup = function()
  vim.cmd([[command! OpenRelated lua require('open-related').open_related()]])
end

local default_options = {
  filetypes = {},
  related_to = function(_)
    return {}
  end,
  condition = function(_)
    return true
  end,
  opts = {},
}

M.add_relation = function(options)
  table.insert(
    M.state.relations,
    vim.tbl_deep_extend("force", default_options, options)
  )
end

M.open_related = function()
  local related = M.find_related(api.nvim_get_current_buf())
  finder.find(related)
end

M.find_related = function(bufnr)
  local ft = api.nvim_buf_get_option(bufnr, "filetype")
  local related = {}

  for _, relation in pairs(M.state.relations) do
    if
      M.filetype_matches(relation.filetypes, ft)
      and (relation.condition == nil or relation.condition(bufnr))
    then
      related = table.merge(
        related,
        relation.related_to(bufnr, relation.opts or {}) or {}
      )
    end
  end

  return related
end

M.filetype_matches = function(filetypes, ft)
  return vim.tbl_isempty(filetypes) or vim.tbl_contains(filetypes, ft)
end

return M
