return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            autotag = {
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            },
        })
       -- requires manually running :TSInstall blade 
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.blade = {
            install_info = {
                url = "https://github.com/EmranMR/tree-sitter-blade",
                files = { "src/parser.c" },
                branch = "main",
            },
            filetype = "blade",
        }
        -- Set the *.blade.php file to be filetype of blade
        vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
                pattern = {"*.blade.php"},
                command = "set ft=blade",
})
    end,
}
