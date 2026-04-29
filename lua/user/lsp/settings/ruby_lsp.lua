return {
  -- Explicit cmd so vim.lsp.enable works correctly.
  -- The binary is expected in PATH from the project's ruby environment (e.g. via direnv/bundler).
  -- Do NOT install ruby-lsp via nix; it must match the project's Ruby version.
  cmd = { "ruby-lsp" },
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
