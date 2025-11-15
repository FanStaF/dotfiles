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
        vim.keymap.set("n","<leader>gf",vim.lsp.buf.format,o)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local function get_intelephense_license()
        local f = io.open(os.getenv("HOME").."/intelephense/license.txt","rb")
        if not f then return nil end
        local c = f:read("*a"); f:close()
        return (c:gsub("%s+",""))
      end

      local phpstan_path = vim.fn.expand(
        "~/code/wowbrands/r20-digital/vendor/phpstan/phpstan/src"
      )

      -- Now set up mason-lspconfig (for automatic installation only)
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "cssls","html","jsonls","lua_ls","marksman",
          "intelephense","sqlls","stimulus_ls","tailwindcss","ts_ls",
        },
        automatic_installation = true,
      })

      -- Lua LS setup using native vim.lsp.config (Neovim 0.11+)
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings = {
          Lua = {
            format = { enable = true, defaultConfig = { indent_style="space", indent_size="4" } },
            diagnostics = { globals = { "vim" } },
          },
        },
        on_attach = set_lsp_keymaps,
      })

      -- Intelephense setup using native vim.lsp.config (Neovim 0.11+)
      vim.lsp.config('intelephense', {
        cmd = { 'intelephense', '--stdio' },
        filetypes = { 'php' },
        root_markers = { 'composer.json', '.git' },
        capabilities = capabilities,
        init_options = {
          licenceKey = get_intelephense_license(),
          environment = { includePaths = { phpstan_path } },
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
            environment = { includePaths = { phpstan_path } },
            completion = { maxItems = 2000 },
            indexing = { maxFileSize = 500000 },
          },
        },
        on_attach = set_lsp_keymaps,
      })

      -- Enable the LSP servers
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('intelephense')
    end,
  },
}

