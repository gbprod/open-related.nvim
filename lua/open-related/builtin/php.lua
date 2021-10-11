local helpers = require("open-related.helpers")
local filename = require("open-related.helpers.filename")

local M = {}

M.alternate_test_file = helpers.make_builtin({
  filetype = { "php" },
  related_to = function(bufnr, opts)
    local matches = {
      { match = "^(.*)tests/(.*)Test%.php$", format = "%ssrc/%s.php" },
      { match = "^(.*)src/(.*)%.php$", format = "%stests/%sTest.php" },
    }

    for _, prefix in pairs(opts.test_namespace_prefixes or {}) do
      table.insert(matches, {
        match = "^(.*)tests/" .. prefix .. "/(.*)Test%.php$",
        format = "%ssrc/%s.php",
      })
      table.insert(matches, {
        match = "^(.*)src/(.*)%.php$",
        format = "%stests/" .. prefix .. "/%sTest.php",
      })
    end

    return filename.from_patterns(matches)(bufnr, opts)
  end,
})

return M
