require('snacks').setup {
  bigfile = { enabled = true },
  -- explorer = { enabled = true },
  terminal = { enabled = true },
  lazygit = { enabled = true },
  dashboard = require('user.snacks.dashboard'),
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  picker = require('user.snacks.picker'),
  words = { enabled = true },
  rename = { enabled = true },
  image = { enabled = true },
}

vim.keymap.set('n', '<leader>lg', function() Snacks.lazygit.open() end, { desc = "Open lazygit" })
vim.keymap.set('n', '<C-/>', function() Snacks.terminal.toggle() end, { desc = "Toggle terminal" })
vim.keymap.set('n', '<leader>gu', function() Snacks.terminal.open('gitui') end, { desc = "Open gitui" })
