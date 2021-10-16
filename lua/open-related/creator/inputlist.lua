local Path = require("plenary.path")

local setup = function() end

local create = function()
  local creatable = require("open-related").find_creatable()

  local input = {}
  for index, value in pairs(creatable) do
    table.insert(input, index .. ") " .. value.file)
  end
  local choice = vim.fn.inputlist(input)

  if choice > 0 then
    Path:new(creatable[choice].file):touch({ parents = true })
    vim.cmd(string.format("edit %s", creatable[choice].file))
  end
end

return {
  setup = setup,
  create = create,
}