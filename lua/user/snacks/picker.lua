vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set('n', '<leader>:', function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set('n', '<leader>n', function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set('n', '<C-t>', function() Snacks.explorer() end, { desc = "File Explorer" })
vim.keymap.set('n', '<leader>of', function() Snacks.explorer({hidden = true, ignored = true,}) end, { desc = "Open File in File Explorer" })
-- Find
vim.keymap.set('n', ';', function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set('n', '<leader>fc', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg', function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
vim.keymap.set('n', '<leader>fp', function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = "Recent" })
-- Git
vim.keymap.set('n', '<leader>gb', function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set('n', '<leader>gl', function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set('n', '<leader>gL', function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set('n', '<leader>gS', function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set('n', '<leader>gd', function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
-- Grep
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set('n', 'rg', function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set('n', '<leader>sB', function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = "Grep word" })
vim.keymap.set('x', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = "Grep visual selection" })
-- search
vim.keymap.set('n', '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Search History" })
vim.keymap.set('n', '<leadergsg', function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set('n', '<leader>sb', function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set('n', '<leader>sC', function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set('n', '<leader>sH', function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set('n', '<leader>si', function() Snacks.picker.icons() end, { desc = "Icons" })
vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set('n', '<leader>sl', function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set('n', '<leader>sm', function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set('n', '<leader>sM', function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set('n', '<leader>sp', function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set('n', '<leader>uC', function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })
-- Non-LSP specific pickers
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })

-- Fix issue specifically with kanagawa
local highlight = require('utils.highlights')
highlight.fg_bg('SnacksPickerTree', '#54546D', '#16161d')
highlight.fg_bg('SnacksPickerTitle', '#000000', '#957fb8')
highlight.fg_bg('SnacksPickerPreviewTitle', '#000000', '#7e9cd8')

return {
  matcher = {
    frecency = true
  },
  sources = {
    explorer = {
      auto_close = true,
      jump = { close = true },
      layout = {
        preset = "default",
        cycle = false,
        preview = false,
        layout = {
          width = 0.5,
          min_width = 40,
        }
      },
      win = {
        list = {
          keys = {
          },
        },
      },
    },
  }
}

