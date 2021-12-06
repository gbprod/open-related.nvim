local telescope = require("telescope")
local open_related = require("open-related")

return telescope.register_extension({
  exports = {
    open_related = function(_)
      open_related.open_related(vim.api.nvim_get_current_buf(), { open_with = "telescope" })
    end,
  },
})
