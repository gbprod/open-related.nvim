local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

return telescope.register_extension({
  exports = {
    open_related = function(opts)
      local relations = require("open-related").relations:resolve_related(
        opts.bufnr or vim.api.nvim_get_current_buf()
      )
      pickers.new(opts or {}, {
        prompt_title = "Related files",
        finder = finders.new_table({
          results = vim.tbl_map(function(entry)
            return entry.file
          end, relations),
          entry_maker = make_entry.gen_from_file(),
        }),
        previewer = require("telescope.config").values.file_previewer({}),
      }):find()
    end,
  },
})
