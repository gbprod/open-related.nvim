local telescope = require("telescope")

local setup = function()
  telescope.load_extension("related")
end

local open = function()
  telescope.extensions.related.open_related()
end

return {
  setup = setup,
  open = open,
}
