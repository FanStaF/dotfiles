return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "antosha417/nvim-lsp-file-operations",
    },
    config = function()
      -- Load lspconfig FIRST and disable all autostart immediately
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- 🔒 Disable auto-start globally IMMEDIATELY to prevent rogue clients
      lspconfig.util.default_config.autostart = false

      -- Disable autostart for all servers at the config level
      local configs = require("lspconfig.configs")
      for _, server in pairs(configs) do
        if type(server) == "table" and server.default_config then
          server.default_config.autostart = false
        end
      end

      -- 🔪 CRITICAL: Override lspconfig's intelephense manager to prevent ANY default behavior
      -- This prevents lspconfig from registering ANY autocommands for Intelephense
      if configs.intelephense then
        configs.intelephense.manager = nil
      end

      -- 🛡️ FAIL-SAFE: Kill any Intelephense client that doesn't have our custom settings
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "intelephense" then
            -- Check if this client has our custom settings (maxItems = 2000 is our marker)
            local has_our_settings = client.config.settings
              and client.config.settings.intelephense
              and client.config.settings.intelephense.completion
              and client.config.settings.intelephense.completion.maxItems == 2000

            if not has_our_settings then
              -- This is an unwanted default instance - kill it immediately
              vim.schedule(function()
                vim.notify("Killing rogue Intelephense instance (id: " .. client.id .. ")", vim.log.levels.WARN)
                client.stop()
              end)
            end
          end
        end,
      })

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

      -- Now set up mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = {
          "cssls","html","jsonls","lua_ls","marksman",
          "intelephense","sqlls","stimulus_ls","tailwindcss","ts_ls",
        },
        automatic_installation = true,
        automatic_setup = false,
      })

      -- Lua LS setup
      lspconfig.lua_ls.setup({
        autostart = true,
        on_attach = set_lsp_keymaps,
        capabilities = capabilities,
        settings = {
          Lua = {
            format = { enable = true, defaultConfig = { indent_style="space", indent_size="4" } },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- 🔪 NUCLEAR OPTION: Clear ALL FileType autocommands for php before setting up Intelephense
      -- This removes any default/automatic Intelephense setup that might have been registered
      pcall(function()
        vim.api.nvim_clear_autocmds({
          group = "lspconfig",
          event = "FileType",
          pattern = "php",
        })
      end)

      -- Also clear any autocommands in other groups that might start Intelephense
      pcall(function()
        local all_aus = vim.api.nvim_get_autocmds({ event = "FileType", pattern = "php" })
        for _, au in ipairs(all_aus) do
          if au.group_name and au.group_name:match("lsp") then
            vim.api.nvim_del_autocmd(au.id)
          end
        end
      end)

      -- NOW set up Intelephense - this will be the ONLY setup
      lspconfig.intelephense.setup({
        autostart = true,
        on_attach = set_lsp_keymaps,
        capabilities = capabilities,
        init_options = {
          licenceKey = get_intelephense_license(),
          environment = { includePaths = { phpstan_path } },
        },
        settings = {
          intelephense = {
            diagnostics = {
              disable = { "P1006","P1013","P1014","P1036" },
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
        root_dir = util.root_pattern("composer.json",".git"),
      })
    end,
  },
}

