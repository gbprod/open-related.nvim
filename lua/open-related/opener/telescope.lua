local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local config = require("telescope.config")

local loaded = false
if not loaded then
  telescope.load_extension("open_related")
end

return function(relations)
  pickers.new({}, {
    prompt_title = "Related files",
    finder = finders.new_table({
      results = vim.tbl_map(function(entry)
        return entry.file
      end, relations),
      entry_maker = make_entry.gen_from_file(),
    }),
    previewer = config.values.file_previewer({}),
  }):find()
end
