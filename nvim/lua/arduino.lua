-- Neovim configuration for Arduino Thermostat project
-- Add this to your init.lua or source it with :luafile .nvim.lua

-- Project-specific keybindings
local function setup_arduino_bindings()
    -- Compile only
    vim.keymap.set("n", "<leader>Ac", function()
        vim.cmd("split | terminal arduino-cli compile --fqbn esp8266:esp8266:d1_mini_clone .")
    end, { desc = "Arduino: Compile", buffer = true })

    -- Upload via OTA
    vim.keymap.set("n", "<leader>Au", function()
        vim.cmd(
            "split | terminal arduino-cli compile --fqbn esp8266:esp8266:d1_mini_clone . && arduino-cli upload --fqbn esp8266:esp8266:d1_mini_clone --port 192.168.1.67 ."
        )
    end, { desc = "Arduino: Upload (OTA)", buffer = true })

    -- Upload via USB
    vim.keymap.set("n", "<leader>AU", function()
        local port = vim.fn.input("USB Port (default /dev/ttyUSB0): ", "/dev/ttyUSB0")
        if port ~= "" then
            vim.cmd(
                "split | terminal arduino-cli compile --fqbn esp8266:esp8266:d1_mini_clone . && arduino-cli upload --fqbn esp8266:esp8266:d1_mini_clone --port "
                .. port
                .. " ."
            )
        end
    end, { desc = "Arduino: Upload (USB)", buffer = true })

    -- Quick build (compile only, minimal output)
    vim.keymap.set("n", "<leader>Ab", function()
        vim.cmd("!arduino-cli compile --fqbn esp8266:esp8266:d1_mini_clone .")
    end, { desc = "Arduino: Quick Build", buffer = true })

    -- Monitor serial output
    vim.keymap.set("n", "<leader>Am", function()
        local port = vim.fn.input("USB Port (default /dev/ttyUSB0): ", "/dev/ttyUSB0")
        if port ~= "" then
            vim.cmd("split | terminal arduino-cli monitor -p " .. port .. " -c baudrate=115200")
        end
    end, { desc = "Arduino: Serial Monitor", buffer = true })

    print(
        "Arduino shortcuts loaded: <leader>ac (compile), <leader>au (upload), <leader>aU (USB), <leader>ab (quick build), <leader>am (monitor)"
    )
end

-- Auto-load for .ino, .cpp, .h files in this project
local arduino_group = vim.api.nvim_create_augroup("ArduinoProject", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = arduino_group,
    pattern = "/home/fanstaf/Arduino/Thermostat/*",
    callback = setup_arduino_bindings,
})

-- Setup immediately if we're already in the project
if vim.fn.getcwd() == "/home/fanstaf/Arduino/Thermostat" then
    setup_arduino_bindings()
end

