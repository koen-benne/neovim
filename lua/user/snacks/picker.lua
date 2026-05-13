vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = "Buffers" })
-- Git
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
-- Search
vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set('n', '<leader>n', function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })

return {
  matcher = {
    frecency = true
  },
}
