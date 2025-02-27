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
  laststatus = 3, -- Single statusline when set to 3
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


vim.keymap.set('n', '<C-e>', '<Nop>')

-- Normal mode --
-- Window nav
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Resize with arrows
vim.keymap.set('n', '<C-[>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<C-]>', ':vertical resize +2<CR>')

-- Naviagate buffers
vim.keymap.set('n', '<S-l>', ':bnext<CR>')
vim.keymap.set('n', '<S-h>', ':bprevious<CR>')

-- Move text up and down
vim.keymap.set('n', '<A-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('n', '<A-k>', '<Esc>:m .-2<CR>==gi')

-- Switch between tab sizes 2 and 4
vim.keymap.set('n', '<leader>t', function()
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
vim.keymap.set('i', 'jk', '<ESC>')

-- Visual --
-- Stay in indent mode
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('v', 'p', '"_dP')

-- Visual Block --
-- Move text up and down
vim.keymap.set('x', 'J', ":move '>+1<CR>gv-gv")
vim.keymap.set('x', 'K', ":move '<-2<CR>gv-gv")
vim.keymap.set('x', '<A-j>', ":move '>+1<CR>gv-gv")
vim.keymap.set('x', '<A-k>', ":move '<-2<CR>gv-gv")

