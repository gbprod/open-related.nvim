local Path = require("plenary.path")

local M = {}

M.state = {
  config = {},
  relations = {},
}

M.setup = function()
  require("telescope").load_extension("related")
  vim.cmd([[command! OpenRelated Telescope related]])
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

M.find_related = function(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
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

  return vim.tbl_filter(function(entry)
    return Path:new(entry.file):exists()
  end, related)
end

M.filetype_matches = function(filetypes, ft)
  return vim.tbl_isempty(filetypes) or vim.tbl_contains(filetypes, ft)
end

return M
