return {
  -- Note: If you want to use rust-tools.nvim or rustaceanvim in the future,
  -- you'll need to configure them separately as they have their own setup functions.
  -- The 'tools' section below was for rust-tools but isn't currently being used.

  on_attach = require('user.lsp.handlers').on_attach,

  -- Uncomment and add rust-analyzer specific settings here if needed:
  -- settings = {
  --   ['rust-analyzer'] = {
  --     checkOnSave = {
  --       command = "clippy",
  --     },
  --   },
  -- },
}
