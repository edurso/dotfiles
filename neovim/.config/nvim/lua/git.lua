require('gitsigns').setup()

-- Git status
vim.api.nvim_set_keymap('n', 'gs', ':G<CR>', { noremap = true, silent = true })

-- Git diff
vim.api.nvim_set_keymap('n', 'gd', ':Gdiffsplit<CR>', { noremap = true, silent = true })

-- Git log
vim.api.nvim_set_keymap('n', 'gl', ':Glog<CR>', { noremap = true, silent = true })

-- Git blame
vim.api.nvim_set_keymap('n', 'gb', ':Git blame<CR>', { noremap = true, silent = true })

-- Git pull
vim.api.nvim_set_keymap('n', 'gp', ':Git pull<CR>', { noremap = true, silent = true })

-- Git fetch
vim.api.nvim_set_keymap('n', 'gf', ':Git fetch<CR>', { noremap = true, silent = true })

-- Git show (view a commit)
vim.api.nvim_set_keymap('n', 'gS', ':Git show<Space>', { noremap = true })

-- Git branch
vim.api.nvim_set_keymap('n', 'gbr', ':Git branch<CR>', { noremap = true, silent = true })
