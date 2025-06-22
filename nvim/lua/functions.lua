local M = {}

-- Run PHPStan asynchronously and populate the quickfix list
function M.run_phpstan_async()
    local output = {}

    vim.notify('🔍 PHPStan scanning for errors...', vim.log.levels.INFO)
    local job_id = vim.fn.jobstart(
        { 'vendor/bin/phpstan', 'analyse', '--no-progress', '--error-format=raw' },
        {
            stdout_buffered = true,
            on_stdout = function(_, data)
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output, line)
                    end
                end
            end,
            on_exit = function(_, exit_code)
                if #output > 0 then
                    local items = {}
                    for _, line in ipairs(output) do
                        local file, lnum = line:match("at%s+([%w%./\\_-]+%.php):(%d+)")
                        if filename and lnum and msg then
                            table.insert(items, {
                                filename = filename,
                                lnum = tonumber(lnum),
                                col = 1,
                                text = msg,
                            })
                        end
                    end

                    if #items > 0 then
                        vim.fn.setqflist({}, ' ', { title = 'PHPStan', items = items })
                        vim.cmd('cfirst')
                    else
                        vim.notify('PHPStan finished: No parseable issues', vim.log.levels.INFO)
                    end
                else
                    vim.notify('✅ PHPStan finished: No issues!', vim.log.levels.INFO)
                end
                if exit_code ~= 0 then
                    vim.notify('PHPStan exit code: ' .. exit_code, vim.log.levels.INFO)
                end
            end,
        }
    )

    if job_id <= 0 then
        vim.notify('Failed to start PHPStan job', vim.log.levels.ERROR)
    end
end

-- Load all changed files into the quickfix list (for manual inspection or hunk nav)
function M.load_changed_files_to_qf()
    local handle = io.popen("git diff --name-only")
    if not handle then
        vim.notify("Failed to run git", vim.log.levels.ERROR)
        return
    end

    local output = handle:read("*a")
    handle:close()

    local files = vim.split(output, "\n", { trimempty = true })
    if #files == 0 then
        vim.notify("No changed files found", vim.log.levels.INFO)
        return
    end

    local qf_entries = {}
    for _, file in ipairs(files) do
        if vim.fn.filereadable(file) == 1 then
            table.insert(qf_entries, {
                filename = file,
                lnum = 1,
                col = 1,
                text = "Changed file",
            })
        end
    end

    if #qf_entries > 0 then
        vim.fn.setqflist(qf_entries, 'r')
        vim.cmd("cc") -- Jump to the first quickfix entry
        vim.notify("Jumped to first changed file", vim.log.levels.INFO)
    else
        vim.notify("No readable changed files found", vim.log.levels.WARN)
    end
  end

  if #qf_entries > 0 then
    vim.fn.setqflist(qf_entries, 'r')
    vim.cmd("cc")  -- Jump to the first quickfix entry
    vim.notify("Jumped to first changed file", vim.log.levels.INFO)
  else
    vim.notify("No readable changed files found", vim.log.levels.WARN)
  end
end

return M

