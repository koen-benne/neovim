return {
  filetypes = { "ruby" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "Gemfile", ".git" })
  end,
  init_options = {
    formatter = "auto",
    experimentalFeaturesEnabled = true,
  },
  settings = {},
}
