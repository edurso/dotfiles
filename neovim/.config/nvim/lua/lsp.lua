local lsp_zero = require('lsp-zero')

local lsp_attach = function(client, bufnr)
    local opts = {buffer = bufnr}

    vim.keymap.set('n', '<F1>', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', '<F12>', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', '<F10>', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', '<F11>', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', '<F9>', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', '<F8>', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
end

lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        -- full list: github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        'rust_analyzer',
        'clangd',
        'lua_ls',
        'gradle_ls',
        'markdown_oxide',
        'ruff',
        'svls',
    },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        ['ruff'] = function()
            require('lspconfig').ruff.setup({
                init_options = {
                    settings = {
                        lineLength = 120,
                    },
                },
            })
        end,
    }
})

local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format({details = true})

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
    },
    snippet = {
        expand = function(args)
        vim.snippet.expand(args.body)
        end,
    },
    formatting = cmp_format,
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                cmp.mapping.scroll_docs(4)(fallback)
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping.scroll_docs(-4),
    }),
})
