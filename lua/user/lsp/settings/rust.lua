return {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = '',
      other_hints_prefix = '',
    },
  },
  server = {
    on_attach = require('user.lsp.handlers').on_attach,
  },
}
