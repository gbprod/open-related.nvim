local Path = require("plenary.path")

local M = {}

M.state = {
  config = {},
  relations = {},
}

M.setup = function()
  require("telescope").load_extension("related")
  vim.cmd([[
    command! OpenRelated Telescope related
    command! CreateRelated lua require("open-related").create_related()
  ]])
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

M.find_related = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local related = M._resolve(bufnr)

  return vim.tbl_filter(function(entry)
    return Path:new(entry.file):exists()
  end, related)
end

M._resolve = function(bufnr)
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

  return related
end

M.filetype_matches = function(filetypes, ft)
  return vim.tbl_isempty(filetypes) or vim.tbl_contains(filetypes, ft)
end

M.create_related = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local related = M._resolve(bufnr)

  local creatable = vim.tbl_values(vim.tbl_filter(function(entry)
    return not Path:new(entry.file):exists()
  end, related))

  local input = {}
  for index, value in pairs(creatable) do
    table.insert(input, index .. "." .. value.file)
  end
  local choice = vim.fn.inputlist(input)

  Path:new(creatable[choice].file):touch({ parents = true })
  vim.cmd(string.format("edit %s", creatable[choice].file))
end

return M
