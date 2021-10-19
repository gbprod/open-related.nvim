return function(relations)
  local qf_entries = {}
  for _, relation in ipairs(relations) do
    table.insert(qf_entries, {
      filename = relation.file,
      lnum = 1,
      col = 1,
      text = relation.file,
    })
  end
  vim.fn.setqflist(qf_entries, "r")
  vim.cmd([[copen]])
end
