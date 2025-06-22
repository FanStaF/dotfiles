return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "cssls",
                    "html",
                    "jsonls",
                    "lua_ls",
                    "marksman",
                    "intelephense",
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
            lspconfig.stimulus_ls.setup({
                cmd = { "stimulus-language-server", "--stdio" },
                filetypes = { "html", "ruby", "eruby", "blade", "php" },
            })
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
            local get_intelephense_license = function()
                local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt", "rb"))
                local content = f:read("*a")
                f:close()
                return string.gsub(content, "%s+", "")
            end
            lspconfig.intelephense.setup({
                on_attach = on_attach,
                init_options = {
                    licenceKey = get_intelephense_license(),
                    environment = {
                        includePaths = {
                            vim.fn.expand("~/code/wowbrands/r20-digital/vendor/phpstan/phpstan/src"), -- Add PHPStan path dynamically
                        },
                    },
                },
                settings = {
                    intelephense = {
                        diagnostics = {
                            disable = { "P1036" },
                        },
                    },
                },
                cmd = { "intelephense", "--stdio" },
                filetypes = { "php" },
                root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
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

            vim.keymap.set("n", "<leader>d", vim.lsp.buf.hover, { desc = "Hover (show definition)" })
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Goto definition" })
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Goto references" })
            vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
            vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code Actions" })
            vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename" })
            vim.keymap.set("n", "]g", function()
                vim.diagnostic.goto_next()
                vim.cmd("normal! zz")
            end)
            vim.keymap.set("n", "[g", function()
                vim.diagnostic.goto_prev()
                vim.cmd("normal! zz")
            end)
            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format Code" })
        end,
    },
}
