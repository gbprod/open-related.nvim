local helpers = require("open-related.helpers")
local filename = require("open-related.helpers.filename")

local M = {}

M.alternate_spec = helpers.make_builtin({
  filetypes = { "lua" },
  related_to = filename.from_patterns({
    { match = "lua/(.*).lua$", format = "spec/%s_spec.lua" },
    { match = "spec/(.*)_spec.lua$", format = "lua/%s.lua" },
  }),
})

return M
