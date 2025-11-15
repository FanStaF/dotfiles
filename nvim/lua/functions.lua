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
                        -- PHPStan raw format: "path/to/file.php:line: Error message"
                        local file, lnum, msg = line:match("^([%w%./\\_-]+%.php):(%d+):(.+)$")
                        if file and lnum and msg then
                            table.insert(items, {
                                filename = file,
                                lnum = tonumber(lnum),
                                col = 1,
                                text = vim.trim(msg),
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

-- Helper to detect nearest Pest test name (looks for test('...') above cursor)
local function get_nearest_test_filter()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line_num = cursor[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, line_num, false)

    for i = #lines, 1, -1 do
        local line = lines[i]
        local match = line:match([[test%s*%(?%s*["'](.+)["']%s*,]])
        if match then
            return match
        end
    end

    return nil
end

-- Generic job runner for Pest, with quickfix parsing
function M.run_pest_job(cmd)
    local stdout = {}
    local stderr = {}

    local job_id = vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
            vim.list_extend(stdout, data or {})
        end,
        on_stderr = function(_, data)
            vim.list_extend(stderr, data or {})
        end,
        on_exit = function(_, code)
            local all_output = vim.list_extend(stdout, stderr)
            local lines = vim.tbl_filter(function(line)
                return line and line ~= ""
            end, all_output)

            local items = {}
            local current = { test_name = nil, message = nil }

            for _, line in ipairs(lines) do
                line = line:gsub("\27%[[0-9;mK]+", "") -- remove ANSI

                local test_name = line:match("^%s*FAILED%s+(.+)")
                if test_name then
                    current.test_name = test_name
                elseif current.test_name and not current.message and line:match("^%s*Failed") then
                    current.message = line
                elseif current.test_name and current.message then
                    local file, lnum = line:match("^%s*at%s+([%w%./\\_-]+%.php):(%d+)")
                    if file and lnum then
                        table.insert(items, {
                            filename = file,
                            lnum = tonumber(lnum),
                            col = 1,
                            text = current.test_name .. " — " .. current.message,
                        })
                        current = { test_name = nil, message = nil }
                    end
                end
            end

            if #items > 0 then
                vim.fn.setqflist({}, 'r', { title = 'Pest Failures', items = items })

                -- Jump to first failure
                vim.cmd("cc 1")

                -- Format and show message
                local msg = string.format("❌ Test failed (1/%d): %s", #items, items[1].text)
                vim.notify(msg, vim.log.levels.ERROR)
            else
                vim.notify("✅ All tests passed", vim.log.levels.INFO)
            end
        end,
    })
end

-- Run nearest Pest test by extracting test('name')
function M.run_pest_nearest()
    local test_name = get_nearest_test_filter()
    if not test_name then
        vim.notify("No nearest test found", vim.log.levels.WARN)
        return
    end

    local cmd = { "php", "artisan", "test", "--filter=" .. test_name }
    M.run_pest_job(cmd)
end

-- Run all tests in the current file
function M.run_pest_file()
    local file = vim.fn.expand("%")
    local cmd = { "php", "artisan", "test", file }
    M.run_pest_job(cmd)
end

-- Run the full test suite
function M.run_pest_suite()
    local cmd = { "php", "artisan", "test" }
    M.run_pest_job(cmd)
end

return M
