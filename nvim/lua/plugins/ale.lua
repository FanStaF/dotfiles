return {
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g

        g.ale_linters = {
            php = { 'phpstan' },
            -- javascript = { 'eslint_d' },
        }

        g.ale_fixers = {
            php = { 'pint' },
        }

        g.ale_fix_on_save = 0
    end
}
