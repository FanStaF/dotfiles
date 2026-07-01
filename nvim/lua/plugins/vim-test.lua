return {
    "vim-test/vim-test",
    config = function()
        vim.keymap.set("n", "<Leader>tn", ":TestNearest<CR>")
        vim.keymap.set("n", "<Leader>tf", ":TestFile<CR>")
        vim.keymap.set("n", "<Leader>ts", ":TestSuite --parallel<CR>")
        vim.keymap.set("n", "<Leader>tl", ":TestLast<CR>")
        vim.keymap.set("n", "<Leader>tv", ":TestVisit<CR>")

        vim.cmd([[
            function! FloatermStrategy(cmd)
                execute 'silent FloatermKill'
                execute 'FloatermNew! '.a:cmd
            endfunction

            let g:test#custom_strategies = {'floaterm': function('FloatermStrategy')}
            let g:test#strategy = 'floaterm'
            let g:test#php#phpunit#executable = 'php artisan test'
            let g:test#php#pest#executable = 'php artisan test'
            let g:test#enabled_runners = ['php#pest', 'php#phpunit']
            ]])
    end,
}
