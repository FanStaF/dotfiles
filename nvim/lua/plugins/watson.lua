return {
	"ccchapman/watson.nvim",
	config = function()
		-- Execute git command only when keymap is pressed, not at config load time
		vim.keymap.set("n", "<Leader>lt", function()
			local handle = io.popen("git branch --show-current")
			if handle then
				local branch = handle:read("*a"):gsub("\n", "")
				handle:close()
				vim.cmd("WatsonStart " .. branch)
			end
		end, { desc = "watson start with current branch" })

		vim.keymap.set("n", "<Leader>ls", ":WatsonStop<CR>", { desc = "watson stop" })
		vim.keymap.set("n", "<Leader>lr", ":WatsonRestart<CR>", { desc = "watson restart" })
		vim.keymap.set("n", "<Leader>li", ":WatsonStatus<CR>", { desc = "watson status" })
	end,
}
