return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
            vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>")
            vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>")
            vim.keymap.set("n", "gs", ":Gitsigns stage_hunk<CR>")
            vim.keymap.set("n", "gS", ":Gitsigns undo_stage_hunk<CR>")
            vim.keymap.set("n", "gp", ":Gitsigns preview_hunk<CR>")
            vim.keymap.set("n", "gb", ":Gitsigns blame_line<CR>")
        end,
    },
    -- {
    --     'tpope/vim-fugitive',
    --     dependencies = { "nvim-lua/plenary.nvim" },
    -- },
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
}
