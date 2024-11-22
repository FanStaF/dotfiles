return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "cssls",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "marksman",
                    "phpactor",
                    "sqlls",
                    "stimulus_ls",
                    "tailwindcss",
                    "ts_ls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "antosha417/nvim-lsp-file-operations", config = true },
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                            -- Put format options here
                            -- NOTE: the value should be STRING!!
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "4",
                            },
                        },
                    },
                },
            })
            lspconfig.phpactor.setup({
                on_attach = on_attach,
                init_options = {
                    ["language_server_phpstan.enabled"] = true,
                    --     ["language_server_psalm.enabled"] = false,
                },
            })
            lspconfig.stimulus_ls.setup({})
            lspconfig.ts_ls.setup({
                root_dir = function(...)
                    return require("lspconfig.util").root_pattern(".git")(...)
                end,
                single_file_support = false,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "literal",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            })
            lspconfig.html.setup({
                capabilities = capabilities,
                init_options = {
                    configurationSection = { "html", "css", "javascript", "blade" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                },
            })
            lspconfig.cssls.setup({
                capabilities = capabilities,
            })
            lspconfig.tailwindcss.setup({
                cmd = { "tailwindcss-language-server", "--stdio" },
                filetypes = {
                    "html",
                    "css",
                    "scss",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "vue",
                },
                root_dir = lspconfig.util.root_pattern("tailwind.config.js", "package.json"),
                settings = {},
            })

            vim.keymap.set("n", "<leader>pm", ":PhpactorContextMenu<CR>")
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Goto definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Goto references" })
            vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
            vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
            vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
        end,
    },
}
