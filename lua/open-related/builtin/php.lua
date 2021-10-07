local helpers = require("open-related.helpers")
local filename = require("open-related.helpers.filename")

local M = {}

M.alternate_test_file = helpers.make_builtin({
  filetype = { "php" },
  related_to = function(bufnr, opts)
    local matches = {
      ["^(.*)tests/(.*)Test%.php$"] = "%ssrc/%s.php",
      ["^(.*)src/(.*)%.php$"] = "%stests/%sTest.php",
    }

    for _, prefix in pairs(opts.test_namespace_prefixes or {}) do
      matches["^(.*)tests/" .. prefix .. "/(.*)Test%.php$"] = "%ssrc/%s.php"
      matches["^(.*)src/(.*)%.php$"] = "%stests/" .. prefix .. "/%sTest.php"
    end

    return filename.from_patterns(matches)(bufnr, opts)
  end,
})

return M
