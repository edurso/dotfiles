-- editor shortcuts
vim.api.nvim_set_keymap('n', 'qq', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'q!', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'qa', ':qa<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-s>', ':wa<CR>', { noremap = true, silent = true })

-- move around splits
vim.api.nvim_set_keymap('i', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- newline
vim.api.nvim_set_keymap('n', '<Enter>', 'o<ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Enter>', 'O<ESC>', { noremap = true, silent = true })

-- lazy.nvim
vim.api.nvim_set_keymap('n', 'l', ':Lazy<CR>', { noremap = true, silent = true })

-- telescope.nvim
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})

-- nvim-tree
require('nvim-tree').setup()
vim.api.nvim_set_keymap('n', 't', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
