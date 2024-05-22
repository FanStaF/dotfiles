return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup()
            vim.keymap.set("n", "]h", ":Gitsigns next_hunk<CR>")
            vim.keymap.set("n", "[h", ":Gitsigns prev_hunk<CR>")
            vim.keymap.set("n", "gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
            vim.keymap.set("n", "gS", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk"})
            vim.keymap.set('n', "gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
            vim.keymap.set("n", "gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk"})
            vim.keymap.set("n", "gb", ":Gitsigns blame_line<CR>", { desc = "Blame line"})
        end,
    },
    {
        'tpope/vim-fugitive',
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    --     "kdheepak/lazygit.nvim",
    --     cmd = {
    --         "LazyGit",
    --         "LazyGitConfig",
    --         "LazyGitCurrentFile",
    --         "LazyGitFilter",
    --         "LazyGitFilterCurrentFile",
    --     },
    --     -- optional for floating window border decoration
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    -- },
}
