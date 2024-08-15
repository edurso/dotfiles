vim.api.nvim_set_keymap('n', 'qq', ':wq<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'q!', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'qa', ':qa<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-h>', '<C-\\><C-N><C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-j>', '<C-\\><C-N><C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<C-\\><C-N><C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<C-\\><C-N><C-w>l', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Enter>', 'o<ESC>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Enter>', 'O<ESC>', { noremap = true, silent = true })
