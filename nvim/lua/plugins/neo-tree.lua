return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
        require("neo-tree").setup({
            window = {
                width = 30
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                }
            }
        })
            vim.keymap.set("n", "<leader>n", ":Neotree filesystem toggle reveal left<CR>", {})
            -- vim.keymap.set("n", "<leader>b", ":Neotree buffers toggle float<CR>", {})
	end,
}
