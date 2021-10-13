local helpers = require("open-related.helpers")
local filename = require("open-related.helpers.filename")

local M = {}

M.alternate_header = helpers.make_builtin({
  filetypes = { "cpp" },
  related_to = filename.from_patterns({
    ["(.*).h$"] = "%s.cpp",
    ["(.*).cpp$"] = "%s.h",
  }),
})

return M
