return { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { "j-hui/fidget.nvim", opts = {} },

        -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("<F12>", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map('<F11>', '<C-T>', "Go Back")

                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("<F4>", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<F9>", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                map("<F4>", vim.lsp.buf.code_action, "[C]ode [A]ction")

                -- Opens a popup that displays documentation about the word under your cursor
                --  See `:help K` for why this keymap.
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("<F1>", vim.lsp.buf.hover, "Hover Documentation")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("<F10>", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                -- The following autocommand is used to enable inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        -- mrover/ (this monorepo's ROS2 workspace) builds inside the
        -- mrover-ros container -- its headers (e.g. rclcpp) only exist
        -- in-container, so Mason's host clangd can never resolve them even
        -- though it can see mrover/compile_commands.json. Excluded here so
        -- root_dir falls through to nil and the mrover_clangd server below
        -- (routed via docker exec) picks it up instead.
        local ROVER_ROOT = os.getenv("ROVER_ROOT")
        local MROVER_ROOT = ROVER_ROOT and (ROVER_ROOT .. "/mrover")

        local function under_mrover(fname)
            return MROVER_ROOT ~= nil and fname:sub(1, #MROVER_ROOT) == MROVER_ROOT
        end

        local servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--query-driver=**",
                },
                -- Native vim.lsp.config root_dir is async: function(bufnr, on_dir).
                -- Not calling on_dir at all (rather than returning nil) is
                -- how you skip attaching this config to a buffer -- see
                -- :help lsp-root_dir(). Used here to exclude mrover/, which
                -- mrover_clangd (docker-exec'd) handles below instead.
                root_dir = function(bufnr, on_dir)
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    if under_mrover(fname) then
                        return
                    end
                    local dir = vim.fs.root(bufnr, { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" })
                    if dir then
                        on_dir(dir)
                    end
                end,
            },
            ruff = {},
            ty = {},
            gopls = {},
            rust_analyzer = {},
            -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- But for many setups, the LSP (`tsserver`) will work just fine
            ts_ls = {},
            htmx = {},
            html = {},
            marksman = {},
            bashls = {},
            svls = {},
            matlab_ls = {},
            asm_lsp = {},
            neocmake = {},
            just = {},
            lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
        }

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require("mason").setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua", -- Used to format Lua code
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        -- Apply each server's overrides via the native config API, which is
        -- what mason-lspconfig's automatic_enable actually resolves against.
        -- The old `handlers` option (below, mason-lspconfig.setup{handlers=...})
        -- was removed in mason-lspconfig v2.0.0 and is silently ignored --
        -- cmd/root_dir/settings overrides were never taking effect through it.
        for server_name, server in pairs(servers) do
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            vim.lsp.config(server_name, server)
        end

        require("mason-lspconfig").setup()

        -- mrover/ servers: not Mason-installed (Mason only knows how to
        -- install servers that run locally). These instead shell out via
        -- docker/host/bin/mrover-{clangd,pyright}, which docker-exec into
        -- the mrover-ros container where the ROS2 toolchain/headers
        -- actually live. See docker/host/README.md. Requires:
        --   - ROVER_ROOT exported and docker/host/bin on $PATH (this repo's
        --     .envrc/direnv sets both up when your shell cd's into it)
        --   - `just up` run at least once (container must be running)
        --   - `just build` run at least once (compile_commands.json must exist)
        if MROVER_ROOT then
            local lspconfig = require("lspconfig")
            local configs = require("lspconfig.configs")

            local function mrover_root(fname)
                if not under_mrover(fname) then
                    return nil
                end
                return require("lspconfig.util").root_pattern(".git")(fname) or MROVER_ROOT
            end

            local function define_mrover(name, cfg)
                if not configs[name] then
                    configs[name] = { default_config = cfg }
                end
                cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
                lspconfig[name].setup({})
            end

            define_mrover("mrover_clangd", {
                cmd = { "mrover-clangd" },
                filetypes = { "c", "cpp" },
                root_dir = mrover_root,
            })

            define_mrover("mrover_pyright", {
                cmd = { "mrover-pyright" },
                filetypes = { "python" },
                root_dir = mrover_root,
                settings = {
                    python = { pythonPath = MROVER_ROOT .. "/venv/bin/python" },
                },
            })
        end
    end,
}
