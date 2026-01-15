return {
  filetypes = { "ruby" },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { "Gemfile", ".git" })
    if root then
      on_dir(root)
    end
  end,
  init_options = {
    formatter = "auto",
    experimentalFeaturesEnabled = true,
  },
  settings = {},
}
