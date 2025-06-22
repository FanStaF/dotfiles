return {
  "AndrewRadev/splitjoin.vim",

  -- Optional: tell lazy.nvim when to load it
  event = { "BufReadPost", "BufNewFile" },

  -- Optional: declare the default key-maps so Lazy shows them in :Lazy keys
  keys = {
    { "gS", mode = { "n" }, desc = "Split (one-liner → multiline)" },
    { "gJ", mode = { "n" }, desc = "Join (multiline → one-liner)" },
  },

  -- Optional: global settings go here
  init = function()
    -- Align the equals signs when splitting PHP arrays (example)
    vim.g.splitjoin_php_align = 1
  end,
}

