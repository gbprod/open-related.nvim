local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local Path = require("plenary.path")

local M = {}

M.find = function(related)
  pickers.new({}, {
    prompt_title = "Related files",
    finder = finders.new_table({
      results = vim.tbl_map(
        function(entry)
          return entry.file
        end,
        vim.tbl_filter(function(entry)
          return Path:new(entry.file):exists()
        end, related)
      ),
      entry_maker = make_entry.gen_from_file(),
    }),
    previewer = require("telescope.config").values.file_previewer({}),
  }):find()
end

return M
