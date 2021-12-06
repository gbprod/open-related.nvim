local M = {}

M.make_builtin = function(opts)
  local builtin = {
    filetypes = opts.filetypes,
    related_to = opts.related_to,
    opts = opts.opts or {},
    condition = opts.condition or function(_)
      return true
    end,
  }

  builtin.with = function(user_opts)
    builtin.filetypes = user_opts.filetypes or builtin.filetypes
    builtin.related_to = user_opts.related_to or builtin.related_to
    builtin.condition = user_opts.condition or builtin.condition
    builtin.opts = vim.tbl_deep_extend("force", builtin.opts, user_opts.opts or {})

    return builtin
  end

  return builtin
end

return M
