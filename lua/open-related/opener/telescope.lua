local telescope = require("telescope")

local setup = function()
  telescope.load_extension("open_related")
end

local open = function(bufnr)
  telescope.extensions.open_related.open_related({
    bufnr = bufnr,
  })
end

return {
  setup = setup,
  open = open,
}
