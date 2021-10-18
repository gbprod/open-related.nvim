local telescope = require("telescope")
local open_related = require("open-related")

return telescope.register_extension({
  exports = {
    create_related = function(_)
      open_related.create_related(
        vim.api.nvim_get_current_buf(),
        { create_with = "telescope" }
      )
    end,
  },
})
