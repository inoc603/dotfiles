-- cmd+ctrl+r to reload hammerspoon
hs.hotkey.bind({ "cmd", "ctrl" }, "r", function() hs.reload() end)

local alacrittyPrefix = "alacritty-"

local wf = hs.window.filter

local function possibleMainScreen()
    local screens = hs.screen.allScreens()

    local primary = hs.screen.primaryScreen()

    table.sort(screens, function(a, b)
        -- prefer screen that are not rotated
        if a:rotate() ~= b:rotate() then
            return a:rotate() == 0
        end

        -- prefer external monitors
        if a:id() == primary:id() or b:id() == primary:id() then
            return b:id() == primary:id()
        end

        -- prefer bigger screen
        return math.max(a:fullFrame().w, a:fullFrame().h) > math.max(b:fullFrame().w, b:fullFrame().h)
    end)

    -- for _, s in ipairs(screens) do
    --     print(s:name(), s:fullFrame())
    -- end

    return screens[1]
end

local function moveToMainScreen(w)
    local center = possibleMainScreen()
    if center ~= w:screen() then
        w:moveToScreen(center, 0)
        print("move to main screen")
    end
end

local appCache = {}

local function cleanAppCache(w)
    local title = alacrittyPrefix .. w:title()
    appCache[title] = nil
end

local alacritty = wf.new(false):setAppFilter('Alacritty', { allowTitles = 1 })

-- when alacritty windows is created by hot key, make sure it's in the main screen.
alacritty:subscribe(wf.windowCreated, moveToMainScreen)

-- alacritty:subscribe(wf.windowFocused, moveToMainScreen)

alacritty:subscribe(wf.windowDestroyed, cleanAppCache)

local function launchAlacritty(title, commands)
    title = alacrittyPrefix .. title

    local window = appCache[title]

    if window == nil or window:application() == nil then
        window = hs.window.get(title)
        appCache[title] = window
    end

    if window == nil then
        local params = {
            "-t", title, "--config-file", os.getenv("HOME") .. "/.alacritty.yml"
        }
        if commands then
            table.insert(params, "-e")
            for _, v in ipairs(commands) do table.insert(params, v) end
        end

        hs.task.new(os.getenv("HOME") .. "/bin/run-alacritty.sh", nil, params):start()
    else
        -- try to focus the window first.
        if hs.window.focusedWindow() == nil
            or hs.window.focusedWindow():id() ~= window:id()
        then
            window:focus()
            return
        end

        -- if the window is already focused, try to maximize it.
        if window:screen():frame().w ~= window:size().w
            or window:screen():frame().h ~= window:size().h
        then
            window:maximize()
            return
        end

        -- if the window is already maximized, try to move it to main screen.
        moveToMainScreen(window)
    end
end

-- ssh to devbox and attach to the last used tmux session.
-- hs.hotkey.bind({ "cmd", "ctrl" }, "k", function()
--     launchAlacritty("remote", { "ssh", "t" })
-- end)

-- attach to the last used tmux session or create one from home directory if there is none.
hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
    launchAlacritty("local", { "/opt/homebrew/bin/fish", "-l", "-i", "-c", "ta" })
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "i", function()
    hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
    hs.application.launchOrFocus("企业微信")
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "k", function()
    hs.application.launchOrFocus("HoYoWave")
end)

-- open a new chrome tab and focus on the address bar
hs.hotkey.bind({ "cmd", "ctrl" }, "o", function()
    if hs.application.launchOrFocus("Google Chrome") then
        hs.application.get("Google Chrome"):selectMenuItem({ "文件", "新标签页" })
    end
end)

-- move the focused window to the main screen.
hs.hotkey.bind({ "cmd", "ctrl" }, "m", function()
    moveToMainScreen(hs.window.focusedWindow())
end)

-- remap <cmd - esc> to <cmd - `> so I don't have to hold the fn button on my
-- anne pro 2 to switch between windows of the same app.
hs.hotkey.bind({ "cmd" }, "escape", function()
    hs.eventtap.keyStroke({ "cmd" }, "`")
end)

-- disable animation for window movement.
hs.window.animationDuration = 0

if hs.spoons.use("SpoonInstall") then
    -- spoon for moving the current window to the right/left half of the screen.
    spoon.SpoonInstall:andUse("WindowHalfsAndThirds", {
        hotkeys = {
            left_half  = { { "ctrl", "alt", "cmd" }, "h" },
            right_half = { { "ctrl", "alt", "cmd" }, "l" },
        }
    })
end

-- move the current window to the next screen
hs.hotkey.bind({ "ctrl", "cmd", "alt" }, "n", function()
    local window = hs.application.frontmostApplication():focusedWindow()
    window:moveToScreen(window:screen():next(), false, true, 0)
end)

-- maximize the current window
hs.hotkey.bind({ "ctrl", "cmd", "alt" }, "m", function()
    hs.window.focusedWindow():maximize()
end)

hs.alert.show("Hammerspoon Loaded")
