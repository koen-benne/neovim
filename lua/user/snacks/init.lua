require('snacks').setup {
  bigfile = { enabled = true },
  dashboard = require('user.snacks.dashboard'),
  -- explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = require('user.snacks.picker'),
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

