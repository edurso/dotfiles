-- ================================
-- Mason Setup
-- ================================
require('mason').setup({})

-- ================================
-- LSP Keymaps (attached per buffer)
-- ================================
local lsp_attach = function(client, bufnr)
    local opts = {buffer = bufnr}

    -- Keymaps for LSP functions
    vim.keymap.set('n', '<F1>', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<F12>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<F10>', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<F11>', '<C-T>', opts)
    vim.keymap.set('n', '<F9>', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<F8>', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'x'}, '<F3>', function() vim.lsp.buf.format({async = true}) end, opts)
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
end

-- ================================
-- LSP Capabilities (for completion)
-- ================================
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- ================================
-- Auto setup servers (Combined)
-- ================================
-- require('mason-lspconfig').setup_handlers(nil)
-- require('mason-lspconfig').setup({
--     -- The list of servers to ensure are installed
--     ensure_installed = {
--         'asm_lsp',
--         'neocmake',
--         -- 'yamlls',
--         'bashls',
--         -- 'jsonls',
--         -- 'veryl_ls',
--         'matlab_ls',
--         'just',
--         -- 'html',
--         'rust_analyzer',
--         'clangd',
--         'lua_ls', -- Included for installation
--         -- 'gradle_ls',
--         -- 'pyright',
--         -- 'markdown_oxide',
--         'ruff',
--         'svls',
--     },
--
--     -- Handlers replace setup_handlers
--     handlers = {
--         -- Default handler: This function is called for every server 
--         -- that does NOT have a dedicated entry in the handlers table below.
--         function(server_name)
--             require('lspconfig')[server_name].setup({
--                 on_attach = lsp_attach,
--                 capabilities = capabilities,
--             })
--         end,
--
--         ["lua_ls"] = function()
--             require('lspconfig').lua_ls.setup({
--                 on_attach = lsp_attach,
--                 capabilities = capabilities,
--                 settings = {
--                     Lua = {
--                         diagnostics = { globals = { 'vim' } },
--                         workspace = { checkThirdParty = false },
--                     },
--                 },
--             })
--         end,
--
--         ["clangd"] = function()
--             require('lspconfig').clangd.setup({
--                 on_attach = lsp_attach,
--                 capabilities = capabilities,
--                 cmd = {
--                     "clangd",
--                     "--query-driver=**"
--                 },
--             })
--         end,
--
--     },
-- })


-- Make sure these exist before setup
local lspconfig = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
    ensure_installed = {
        'clangd',
        'lua_ls',
        'rust_analyzer',
        'bashls',
        'svls',
        'matlab_ls',
        'asm_lsp',
        'neocmake',
        'just',
        'ruff',
    },

    handlers = {
        -- Default handler for all servers
        function(server_name)
            lspconfig[server_name].setup({
                on_attach = lsp_attach,
                capabilities = capabilities,
            })
        end,

        -- Custom lua config
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                on_attach = lsp_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                        workspace = { checkThirdParty = false },
                    },
                },
            })
        end,

        -- Custom clangd config (this one will override Mason defaults)
        ["clangd"] = function()
            lspconfig.clangd.setup({
                on_attach = lsp_attach,
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--header-insertion=iwyu",
                    "--query-driver=**",
                },
            })
        end,
    },
})

-- ================================
-- nvim-cmp Setup (no lsp-zero)
-- (No changes needed here)
-- ================================
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    }),
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snip]',
                buffer = '[Buf]',
                path = '[Path]',
            })[entry.source.name]
            return vim_item
        end,
    },
})

-- ================================
-- Specific Server Overrides
-- ================================
-- Setup Clangd specifically with the custom command *after* mason-lspconfig.setup
-- require('lspconfig').clangd.setup({
--     on_attach = lsp_attach,
--     capabilities = capabilities,
--     cmd = { 
--         "clangd",
--         "--query-driver=**"
--     },
-- })
--

-- vim.lsp.config.set_config('clangd', {
--     on_attach = lsp_attach,
--     capabilities = capabilities,
--     cmd = {
--         "clangd",
--         "--query-driver=**"
--     },
-- })

