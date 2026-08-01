-- cmd+ctrl+r to reload hammerspoon
hs.hotkey.bind({ "cmd", "ctrl" }, "r", function() hs.reload() end)

-- enable the `hs` command-line tool / message port (for scripting & AX probing)
require("hs.ipc")

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
alacritty:subscribe(wf.windowCreated, function(w)
    moveToMainScreen(w)
end)

-- Roberta.app has its own bundle, so it needs a separate window filter.
local roberta = wf.new(false):setAppFilter('Roberta', {})
roberta:subscribe(wf.windowCreated, function(w)
    moveToMainScreen(w)
    hs.timer.doAfter(0.3, function()
        local f = w:screen():frame()
        if w:title() == "roberta-viewer" then
            -- viewer fills space to the right of the terminal
            w:setFrame({ x = f.x + f.w * 3 / 4, y = f.y + f.h / 8, w = f.w / 4, h = f.h * 3 / 4 })
        else
            -- terminal centered at 1/4 screen
            w:setFrame({ x = f.x + f.w / 4, y = f.y + f.h / 8, w = f.w / 2, h = f.h * 3 / 4 })
        end
    end)
end)
roberta:subscribe(wf.windowDestroyed, function(w)
    appCache[w:title()] = nil
end)

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
            "-t", title, "--config-file", os.getenv("HOME") .. "/.alacritty.toml"
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
hs.hotkey.bind({ "cmd", "ctrl" }, "o", function()
    -- launchAlacritty("local", { "/opt/homebrew/bin/fish", "-i", "-c", "zn" })
    launchAlacritty("local", { "/opt/homebrew/bin/fish", "-i", "-c", "ta" })
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "i", function()
    hs.application.launchOrFocus("Google Chrome")
end)

-- press cmd + ctrl + j to launch or switch to wecom.
-- press again to bring up the search dialog which doesn't have a shortcut yet.
hs.hotkey.bind({ "cmd", "ctrl" }, "j", function()
    if hs.window.focusedWindow():title() == "企业微信" then
        hs.application.get("企业微信"):selectMenuItem({ "编辑", "全局搜索" })
    else
        hs.application.launchOrFocus("企业微信")
    end
end)

hs.hotkey.bind({ "cmd", "ctrl" }, "k", function()
    local slack = hs.application.get("Slack")
    if slack then
        slack:activate()
        return
    end

    local injector = os.getenv("HOME")
        .. "/src/gitlab.awx.im/eddie.huang/slack-enhanced/scripts/slack_profile_injector.mjs"
    local task = hs.task.new("/opt/homebrew/bin/node", function(exitCode, _, stderr)
        if exitCode ~= 0 then
            print("[slack-injector] " .. tostring(stderr))
            hs.alert.show("Slack injector failed; check its log")
            return
        end

        local attempts = 0
        local function focusSlack()
            local startedSlack = hs.application.get("Slack")
            if startedSlack then
                startedSlack:activate()
                return
            end
            attempts = attempts + 1
            if attempts < 10 then
                hs.timer.doAfter(0.2, focusSlack)
            else
                hs.alert.show("Slack started but could not be focused")
            end
        end
        focusSlack()
    end, { injector, "ensure" })
    if task then
        task:start()
    else
        hs.alert.show("Could not start the Slack injector")
    end
end)

hs.hotkey.bind({ "cmd", "ctrl" }, ";", function()
    -- Find the Roberta terminal window by app, not title (ghostty/tmux may change the title)
    local robertaApp = hs.application.get('Roberta')
    local window = nil
    if robertaApp then
        for _, w in ipairs(robertaApp:allWindows()) do
            if w:title() ~= "roberta-viewer" then
                window = w
                break
            end
        end
    end

    if window == nil then
        hs.task.new("/usr/bin/open", nil, {"-a", os.getenv("HOME") .. "/src/gitlab.awx.im/eddie.huang/roberta/Roberta.app", "--args", "--app"}):start()
    elseif hs.window.focusedWindow() == nil or hs.window.focusedWindow():id() ~= window:id() then
        if robertaApp then robertaApp:activate() end
        window:focus()
    else
        -- toggle between centered 1/4 and fullscreen
        local f = window:screen():frame()
        if window:size().w < f.w * 0.9 then
            window:maximize()
        else
            window:setFrame({ x = f.x + f.w / 4, y = f.y + f.h / 8, w = f.w / 2, h = f.h * 3 / 4 })
        end
    end
end)

-- focus the next unread Roberta notification's tmux pane
hs.hotkey.bind({ "cmd", "ctrl" }, "n", function()
    print("[roberta-hotkey] cmd+ctrl+n pressed")
    hs.task.new(os.getenv("HOME") .. "/src/gitlab.awx.im/eddie.huang/roberta/Roberta.app/Contents/MacOS/roberta",
        function(exitCode, stdout, stderr)
            print("[roberta-hotkey] exit=" .. tostring(exitCode) .. " stdout=" .. tostring(stdout) .. " stderr=" .. tostring(stderr))
            if exitCode ~= 0 then return end
            local ok, resp = pcall(hs.json.decode, stdout)
            if not ok or not resp or not resp.ok then
                print("[roberta-hotkey] no notification to focus")
                return
            end
            local session = resp.session or ""
            local isRoberta = session == "" or session:find("^roberta")
            print("[roberta-hotkey] isRoberta=" .. tostring(isRoberta) .. " session=" .. session)
            -- Daemon already selected the tmux pane; we just need to focus the window.
            if isRoberta then
                local robertaApp = hs.application.get('Roberta')
                if robertaApp then robertaApp:activate() end
                local w = nil
                if robertaApp then
                    for _, win in ipairs(robertaApp:allWindows()) do
                        if win:title() ~= "roberta-viewer" then w = win; break end
                    end
                end
                print("[roberta-hotkey] roberta window=" .. tostring(w and w:title() or "nil"))
                if w then w:focus() end
            else
                local app = hs.application.get("com.mitchellh.ghostty")
                print("[roberta-hotkey] ghostty app=" .. tostring(app))
                if app then
                    app:activate()
                    local w = app:mainWindow()
                    if w then w:focus() end
                end
            end
        end, {"--focus-next"}):start()
end)

-- launch or focus Ghostty (single-window tmux workflow, same as Alacritty)
hs.hotkey.bind({ "cmd", "ctrl" }, "l", function()
    local app = hs.application.get("com.mitchellh.ghostty")
    local window = nil
    if app then
        window = app:mainWindow()
    end

    if window == nil then
        hs.task.new("/usr/bin/open", nil,
            {"-a", "Ghostty", "--args", "-e", "/opt/homebrew/bin/fish", "-i", "-c", "ta"}):start()
    elseif hs.window.focusedWindow() == nil
        or hs.window.focusedWindow():id() ~= window:id()
    then
        app:activate()
        window:focus()
    else
        local wf = window:frame()
        local sf = window:screen():frame()
        if wf.w < sf.w or wf.h < sf.h then
            window:maximize()
        else
            moveToMainScreen(window)
        end
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
    window:moveToScreen(window:screen():next(), true, true, 0)
end)

-- maximize the current window
hs.hotkey.bind({ "ctrl", "cmd", "alt" }, "m", function()
    hs.window.focusedWindow():maximize()
end)

-- polish: rephrase the draft in the focused input (cmd+ctrl+p). Tool lives in the roberta repo.
local polishPath = os.getenv("HOME") .. "/src/gitlab.awx.im/eddie.huang/roberta/polish/hs.lua"
if hs.fs.attributes(polishPath) then
    dofile(polishPath).bind({ "cmd", "ctrl" }, "p")
end

hs.alert.show("Hammerspoon Loaded")
