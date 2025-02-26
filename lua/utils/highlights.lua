local M = {}

-- functions for setting highlights
function M.fg_bg(group, guifg, guibg)
  vim.cmd('hi ' .. group .. ' guibg=' .. guibg .. ' guifg=' .. guifg)
end
function M.bg(group, guibg)
  vim.cmd('hi ' .. group .. ' guibg=' .. guibg)
end

return M
