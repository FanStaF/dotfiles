return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- Keep this plugin for utility commands like :LspInfo, :LspStart, :LspStop
    -- But don't use it for configuration (we use native vim.lsp.config instead)
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local function set_lsp_keymaps(_, bufnr)
        local o = { buffer = bufnr, silent = true }
        vim.keymap.set("n","<leader>d",vim.lsp.buf.hover,o)
        vim.keymap.set("n","<leader>gd",vim.lsp.buf.definition,o)
        vim.keymap.set("n","<leader>gr",vim.lsp.buf.references,o)
        vim.keymap.set("n","<leader>gi",vim.lsp.buf.implementation,o)
        vim.keymap.set("n","<leader>a",vim.lsp.buf.code_action,o)
        vim.keymap.set("n","<leader>r",vim.lsp.buf.rename,o)
        vim.keymap.set("n","]g",function()vim.diagnostic.goto_next();vim.cmd("normal! zz")end,o)
        vim.keymap.set("n","[g",function()vim.diagnostic.goto_prev();vim.cmd("normal! zz")end,o)
        vim.keymap.set("n","<leader>gf",function()
          if vim.bo[bufnr].filetype == "php" then
            vim.cmd("ALEFix")
          else
            vim.lsp.buf.format()
          end
        end,o)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local function get_intelephense_license()
        local f = io.open(os.getenv("HOME").."/intelephense/license.txt","rb")
        if not f then return nil end
        local c = f:read("*a"); f:close()
        return (c:gsub("%s+",""))
      end

      -- Now set up mason-lspconfig (for automatic installation only)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "cssls","html","jsonls","lua_ls","marksman",
          "intelephense","sqlls","tailwindcss","ts_ls","vue_ls",
        },
        automatic_installation = true,
      })

      -- Common config for all LSP servers
      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = set_lsp_keymaps,
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            format = { enable = true, defaultConfig = { indent_style="space", indent_size="4" } },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config('intelephense', {
        init_options = {
          licenceKey = get_intelephense_license(),
        },
        settings = {
          intelephense = {
            diagnostics = {
              undefinedMethods = false,
              undefinedProperties = false,
              undefinedTypes = false,
              undefinedConstants = false,
              undefinedFunctions = false,
            },
            files = {
              maxSize = 20000000,
              associations = {
                "*.php","_ide_helper.php","_ide_helper_models.php",
                ".phpstorm.meta.php",".intelephense-stubs.php",
              },
              exclude = {
                "**/vendor/**","**/node_modules/**","**/storage/**",
                "**/bootstrap/cache/**","**/public/**",
              },
            },
            stubs = { "laravel","pestphp","eloquent","blade","core","standard" },
            completion = { maxItems = 2000 },
            indexing = { maxFileSize = 500000 },
          },
        },
      })

      vim.lsp.config('vue_ls', {
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      })

      vim.lsp.enable('lua_ls')
      vim.lsp.enable('intelephense')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('vue_ls')
      vim.lsp.enable('tailwindcss')
      vim.lsp.enable('cssls')
      vim.lsp.enable('html')
      vim.lsp.enable('jsonls')
    end,
  },
}

