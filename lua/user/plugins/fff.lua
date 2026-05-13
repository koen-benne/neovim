require('fff').setup({
  lazy_sync = true,
  prompt = '❯ ',
  layout = {
    prompt_position = 'top',
  },
  hl = {
    normal = 'NormalFloat',
  },
})

-- Backdrop: dim everything behind fff when picker is open
local backdrop_buf = nil
local backdrop_win = nil

local function open_backdrop()
  backdrop_buf = vim.api.nvim_create_buf(false, true)
  backdrop_win = vim.api.nvim_open_win(backdrop_buf, false, {
    relative = 'editor',
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    style = 'minimal',
    focusable = false,
    zindex = 49, -- just below fff windows (fff uses 50+)
  })
  vim.api.nvim_set_option_value('winhighlight', 'Normal:FffBackdrop', { win = backdrop_win })
  vim.api.nvim_set_option_value('winblend', 60, { win = backdrop_win })
end

local function close_backdrop()
  if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
    vim.api.nvim_win_close(backdrop_win, true)
  end
  if backdrop_buf and vim.api.nvim_buf_is_valid(backdrop_buf) then
    vim.api.nvim_buf_delete(backdrop_buf, { force = true })
  end
  backdrop_win = nil
  backdrop_buf = nil
end

-- Hook into fff's input buffer creation to close backdrop when picker closes
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fff_input',
  callback = function(ev)
    vim.api.nvim_create_autocmd('BufWipeout', {
      buffer = ev.buf,
      once = true,
      callback = close_backdrop,
    })
  end,
})

vim.api.nvim_set_hl(0, 'FffBackdrop', { bg = '#000000', default = true })

local function with_backdrop(fn)
  return function(...)
    open_backdrop()
    fn(...)
  end
end

local fff = require('fff')

-- File finding
vim.keymap.set('n', '<leader><space>', with_backdrop(function() fff.find_files() end),                                              { desc = "Find Files" })
vim.keymap.set('n', '<leader>sf',      with_backdrop(function() fff.find_files() end),                                              { desc = "Find Files" })
vim.keymap.set('n', '<leader>fg',      with_backdrop(function() fff.find_files() end),                                              { desc = "Find Git Files" })
vim.keymap.set('n', '<leader>fr',      with_backdrop(function() fff.find_files() end),                                              { desc = "Recent Files" })
vim.keymap.set('n', '<leader>fc',      with_backdrop(function() fff.find_files_in_dir(vim.fn.stdpath("config")) end),               { desc = "Find Config File" })

-- Grep
vim.keymap.set('n', 'rg',             with_backdrop(function() fff.live_grep() end),                                               { desc = "Grep" })
vim.keymap.set('n', '<leader>sw',     with_backdrop(function() fff.live_grep({ query = vim.fn.expand("<cword>") }) end),           { desc = "Grep word" })
vim.keymap.set('x', '<leader>sw',     with_backdrop(function() fff.live_grep({ query = vim.fn.expand("<cword>") }) end),           { desc = "Grep visual selection" })
