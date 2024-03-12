return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
	},
	{
		"Mofiqul/vscode.nvim",
	},
	{
		"mcchrish/zenbones.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
		lazy = false,
		priority = 1000,
		-- set default theme
		config = function()
			-- vim.cmd.colorscheme("catppuccin")
			-- vim.cmd.colorscheme("zenbones")
			vim.cmd.colorscheme("vscode")
		end,
	},
}
