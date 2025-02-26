-- NOTE: These 2 need to be set up before any plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local options = {
  backup = false,
  clipboard = 'unnamedplus',
  completeopt = { 'menu', 'menuone', 'noselect' }, -- cmp stuff
  mouse = 'a', -- allow mouse use
  smartcase = true,
  smartindent = true,
  number = true,
  pumheight = 10, -- pop up menu height
  incsearch = true,
  visualbell = true,
  showtabline = 1, -- only show tabline when there are more than one tab
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = 'yes', -- always show the sign column to prevent shifting text
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  wrap = true,
  autoindent = true,
  ruler = true,
  hlsearch = true,
  relativenumber = false,
  scrolloff = 8,
  sidescrolloff = 8,
  swapfile = false,
  splitbelow = true,
  splitright = true,
  termguicolors = true,
  laststatus = 2, -- Single statusline when set to 3
  guifont = 'JetBrainsMonoNL Nerd Font:h11', -- font used in GUI neovim
  cursorline = true,
  pumblend = 10,
  winblend = 10,
  conceallevel = 2,
  fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
  path = vim.o.path .. '**',
  colorcolumn = '100',
}

vim.opt.shortmess:append('c')

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Folding stuff
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- vim-better-whitespace options
vim.g.better_whitespace_filetypes_blacklist = {
  'NvimTree',
  'toggleterm',
  'TelescopePrompt',
  'alpha',
}

-- Enable true colour support
if vim.fn.has('termguicolors') then
  vim.o.termguicolors = true
end

vim.cmd([[
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave  * if &nu                   | set nornu | endif
]])

-- [[ Disable auto comment on enter ]]
-- See :help formatoptions
vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local setKeymap = vim.keymap.set

setKeymap('n', '<C-e>', '<Nop>')

-- Normal mode --
-- Window nav
setKeymap('n', '<C-h>', '<C-w>h')
setKeymap('n', '<C-j>', '<C-w>j')
setKeymap('n', '<C-k>', '<C-w>k')
setKeymap('n', '<C-l>', '<C-w>l')

-- Resize with arrows
setKeymap('n', '<C-[>', ':vertical resize -2<CR>')
setKeymap('n', '<C-]>', ':vertical resize +2<CR>')

-- Naviagate buffers
setKeymap('n', '<S-l>', ':bnext<CR>')
setKeymap('n', '<S-h>', ':bprevious<CR>')

-- Move text up and down
setKeymap('n', '<A-j>', '<Esc>:m .+1<CR>==gi')
setKeymap('n', '<A-k>', '<Esc>:m .-2<CR>==gi')

-- Switch between tab sizes 2 and 4
setKeymap('n', '<leader>t', function()
  if vim.opt.shiftwidth:get() == 2 then
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
  else
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end
end)

-- Insert --
-- Press jk fast to enter
setKeymap('i', 'jk', '<ESC>')

-- Visual --
-- Stay in indent mode
setKeymap('v', '<', '<gv')
setKeymap('v', '>', '>gv')

-- Move text up and down
setKeymap('v', '<A-j>', ':m .+1<CR>==')
setKeymap('v', '<A-k>', ':m .-2<CR>==')
setKeymap('v', 'p', '"_dP')

-- Visual Block --
-- Move text up and down
setKeymap('x', 'J', ":move '>+1<CR>gv-gv")
setKeymap('x', 'K', ":move '<-2<CR>gv-gv")
setKeymap('x', '<A-j>', ":move '>+1<CR>gv-gv")
setKeymap('x', '<A-k>', ":move '<-2<CR>gv-gv")

