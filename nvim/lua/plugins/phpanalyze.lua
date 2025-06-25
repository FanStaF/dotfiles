return {
  "fanstaf/nvim-phpanalyze",
  config = function()
    require("phpanalyze").setup()

    -- Defer keymap until after setup registers the command
    vim.schedule(function()
      vim.keymap.set("n", "<leader>pa", "<cmd>PhpAnalyze<CR>", { desc = "Run PHP analyzer" })
    end)
  end,
}
