local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {'joshdick/onedark.vim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'hrsh7th/cmp-buffer'},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function ()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" , "markdown" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{'lewis6991/gitsigns.nvim'},
	{'tpope/vim-fugitive'},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		dependencies = { 'hrsh7th/nvim-cmp' },
		config = function()
			require('nvim-autopairs').setup {}
			local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
			local cmp = require 'cmp'
			cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
		end,
	},
	{'vim-airline/vim-airline'},
	{'vim-airline/vim-airline-themes'},
	{'mfussenegger/nvim-dap'},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		}
	},
    {'kyazdani42/nvim-web-devicons'},
	{
        'kyazdani42/nvim-tree.lua',
        after = 'nvim-web-devicons',
        requires = 'kyazdani42/nvim-web-devicons',
    },
    {'mg979/vim-visual-multi'},
    {'NoahTheDuke/vim-just'},
    {
        'pocco81/auto-save.nvim',
        config = function ()
            require('auto-save').setup({
                enabled = true,
                trigger_events = {
                    'InsertLeave',
                    'TextChanged',
                },
                write_delay = 500,
                concurrency_delay = 1000,
                debug = false,
                debounce_text_changed = 1000,
                exclude_buftypes = {
                    'nofile',
                    'terminal',
                    'prompt',
                },
                exclude_filetypes = {
                    'gitcommit',
                    'gitrebase',
                    'svn',
                    'hgcommit',
                    'hgrmessage',
                    'git',
                    'ledger',
                    'vim',
                    'help',
                    'man',
                    'dashboard',
                    'lazy',
                    'NvimTree',
                    'harpoon',
                },
                disable_cjk_widths = false,
            })
        end
    },
})
