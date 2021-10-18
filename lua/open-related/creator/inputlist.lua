local Path = require("plenary.path")

return function(relations)
  local input = {}
  for index, value in pairs(relations) do
    table.insert(input, index .. ". " .. value.file)
  end
  local choice = vim.fn.inputlist(input)

  if choice > 0 then
    Path:new(relations[choice].file):touch({ parents = true })
    vim.cmd(string.format("edit %s", relations[choice].file))
  end
end
