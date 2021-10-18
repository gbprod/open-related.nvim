local telescope = require("telescope")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local Path = require("plenary.path")

local loaded = false
if not loaded then
  telescope.load_extension("create_related")
end

return function(relations)
  pickers.new({}, {
    prompt_title = "Create related files",
    finder = finders.new_table({
      results = vim.tbl_map(function(entry)
        return entry.file
      end, relations),
      entry_maker = make_entry.gen_from_file(),
    }),
    previewer = nil,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        Path:new(selection[1]):touch({ parents = true })
        vim.cmd(string.format(":e %s", selection[1]))
      end)

      return true
    end,
  }):find()
end
