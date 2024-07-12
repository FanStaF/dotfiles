local function branch_name()
	local handle = io.popen("git branch --show-current")
	local output = handle:read("*a")
	handle:close()

    output = string.gsub(output, "\n", "")
	return ":WatsonStart " .. output .. "<CR>"
end

return {
	"ccchapman/watson.nvim",
	config = function()
		vim.keymap.set("n", "<Leader>lt", branch_name(), { desc = "watson start" })
		vim.keymap.set("n", "<Leader>ls", ":WatsonStop<CR>", { desc = "watson stop" })
		vim.keymap.set("n", "<Leader>lr", ":WatsonRestart<CR>", { desc = "watson restart" })
		vim.keymap.set("n", "<Leader>li", ":WatsonStatus<CR>", { desc = "watson status" })
	end,
}
