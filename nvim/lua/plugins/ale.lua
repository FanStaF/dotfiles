return {
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_linters = {
            php = { 'phpstan' },
            -- javascript = { 'eslint_d' },
        }
    end
}
