-- Generic Arduino project configuration
-- Automatically detects Arduino projects and loads keybindings

-- Helper to check if current directory is an Arduino project
local function is_arduino_project()
    -- Look for .ino files in current directory
    local ino_files = vim.fn.glob("*.ino", false, true)
    return #ino_files > 0
end

-- Helper to get FQBN from project directory or prompt user
local function get_fqbn()
    -- Check if .arduino-fqbn file exists in project root
    local fqbn_file = io.open(".arduino-fqbn", "r")
    if fqbn_file then
        local fqbn = fqbn_file:read("*l")
        fqbn_file:close()
        return fqbn
    end

    -- Common defaults
    return vim.fn.input("Board FQBN (e.g., arduino:avr:uno): ", "esp8266:esp8266:d1_mini_clone")
end

-- Setup Arduino keybindings
local function setup_arduino_bindings()
    -- Only set up if in an Arduino project
    if not is_arduino_project() then
        return
    end

    local fqbn = get_fqbn()

    -- Compile only
    vim.keymap.set("n", "<leader>Ac", function()
        vim.cmd("split | terminal arduino-cli compile --fqbn " .. fqbn .. " .")
    end, { desc = "Arduino: Compile", buffer = true })

    -- Upload via OTA
    vim.keymap.set("n", "<leader>Au", function()
        local ip = vim.fn.input("OTA IP address: ", "192.168.1.67")
        if ip ~= "" then
            vim.cmd(
                "split | terminal arduino-cli compile --fqbn " .. fqbn .. " . && arduino-cli upload --fqbn " .. fqbn .. " --port " .. ip .. " ."
            )
        end
    end, { desc = "Arduino: Upload (OTA)", buffer = true })

    -- Upload via USB
    vim.keymap.set("n", "<leader>AU", function()
        local port = vim.fn.input("USB Port: ", "/dev/ttyUSB0")
        if port ~= "" then
            vim.cmd(
                "split | terminal arduino-cli compile --fqbn " .. fqbn .. " . && arduino-cli upload --fqbn " .. fqbn .. " --port " .. port .. " ."
            )
        end
    end, { desc = "Arduino: Upload (USB)", buffer = true })

    -- Quick build (compile only, minimal output)
    vim.keymap.set("n", "<leader>Ab", function()
        vim.cmd("!arduino-cli compile --fqbn " .. fqbn .. " .")
    end, { desc = "Arduino: Quick Build", buffer = true })

    -- Monitor serial output
    vim.keymap.set("n", "<leader>Am", function()
        local port = vim.fn.input("USB Port: ", "/dev/ttyUSB0")
        if port ~= "" then
            vim.cmd("split | terminal arduino-cli monitor -p " .. port .. " -c baudrate=115200")
        end
    end, { desc = "Arduino: Serial Monitor", buffer = true })

    print("Arduino shortcuts loaded for FQBN: " .. fqbn)
end

-- Auto-detect and load for Arduino files
local arduino_group = vim.api.nvim_create_augroup("ArduinoProject", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = arduino_group,
    pattern = { "*.ino", "*.cpp", "*.h" },
    callback = function()
        -- Only setup once per project
        if not vim.b.arduino_setup then
            setup_arduino_bindings()
            vim.b.arduino_setup = true
        end
    end,
})

-- Setup immediately if we're already in an Arduino project
if is_arduino_project() then
    setup_arduino_bindings()
end

