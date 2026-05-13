vim.keymap.set('n', '-', ':Canola<CR>', { desc = 'Open Canola file explorer' })

vim.g.canola_trash = true

vim.g.canola = {
  columns = { "icon" },
  confirm = "delete",
  watch = true,
  lsp = {
    enabled = true,
    timeout_ms = 1000,
    autosave = true,
  },
  keymaps = {
    ["<C-v>"] = { callback = "actions.select", opts = { vertical = true },   desc = "Open in vertical split" },
    ["<C-s>"] = { callback = "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
    ["~"]     = false,
  },
}
