return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	config = function()
		local actions = require("telescope.actions")

		require("telescope").setup({
			defaults = {
				path_display = { "smart" },
				prompt_prefix = "   ",
				selection_caret = "  ",
				layout_config = {
					prompt_position = "top",
				},
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
					},
				},
				file_ignore_patterns = { ".git/", "phpstan-baseline.neon" },
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				buffers = {
					previewer = false,
					layout_config = {
						width = 80,
					},
				},
				oldfiles = {
					prompt_title = "History",
				},
				lsp_references = {
					previewer = false,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files"})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in files" })
        vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Find recently opened" })
		vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Buffers switch"})
		vim.keymap.set(
			"n",
			"<leader>fa",
			[[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files', desc = 'Find All Files' })<CR>]]
		)

		require("telescope").load_extension("ui-select")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("live_grep_args")
	end,
}
