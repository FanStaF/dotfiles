return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            -- Set the *.blade.php file to be filetype of blade
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { "*.blade.php" },
                command = "set ft=blade.html",
            })

            require("nvim-treesitter").install({
                "css","html","javascript","json","lua",
                "markdown","php","sql","tsx","typescript","vim","vue",
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
