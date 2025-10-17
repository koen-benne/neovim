return {
  filetypes = { "ruby" },
  root_dir = require('lspconfig.util').root_pattern("Gemfile", ".git"),
  init_options = {
    formatter = "auto",
    experimentalFeaturesEnabled = true,
  },
  settings = {},
}
