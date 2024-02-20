return {
    "nvim-lualine/lualine.nvim",
    config = function()
        local separator = { '"▏"' }
        require("lualine").setup({
            options = {
                section_separators = "",
                component_separators = "",
                globalstatus = true,
                theme = {
                    normal = {
                        a = "StatusLine",
                        b = "StatusLine",
                        c = "StatusLine",
                    },
                },
            },
            sections = {
                lualine_a = {
                    "mode",
                    separator,
                },
                lualine_b = {
                    "branch",
                    "diff",
                    separator,
                    '"🖧  " .. tostring(#vim.tbl_keys(vim.lsp.buf_get_clients()))',
                    { "diagnostics", sources = { "nvim_diagnostic" } },
                    separator,
                },
                lualine_c = {},
                lualine_x = {
                    {
                        "filename",
                        path = 1,
                    },
                    "filetype",
                    "encoding",
                    "fileformat",
                },
                lualine_y = {
                    separator,
                    '(vim.bo.expandtab and "␠ " or "⇥ ") .. " " .. vim.bo.shiftwidth',
                    separator,
                },
                lualine_z = {
                    "location",
                    "progress",
                },
            },
        })
        -- require('lualine').setup {
        --     options = {
        --         theme = 'dracula'
        --     }
        -- }
    end,
}
