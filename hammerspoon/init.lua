hs.hotkey.bind({"cmd", "ctrl"}, "r", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

function posX(screen)
    x, y = screen:position()
    return x
end

function screenAtCenter()
    local screens = hs.screen.allScreens()
    table.sort(screens, function(a, b) return posX(a) < posX(b) end)
    return screens[math.ceil(#screens/2)]
end

local wf=hs.window.filter

function startsWith(str, start)
   return str:sub(1, #start) == start
end

local alacrittyPrefix = "alacritty-"

local appCache = {}

function moveToCenter(w)
    if startsWith(w:title(), alacrittyPrefix) then
	w:moveToScreen(screenAtCenter(), 0)
    end
end

-- when alacritty windows is created or focused by hot key, make sure it's in the center screen.
local alacritty = wf.new(false):setAppFilter('Alacritty', {allowTitles=1})
alacritty:subscribe(wf.windowCreated, moveToCenter)
alacritty:subscribe(wf.windowFocused, moveToCenter)

function launchAlacritty(title, commands)
    title = alacrittyPrefix .. title

    app = appCache[title]

    if app == nil then
	app = hs.window.get(title)
	appCache[title] = app
    end

    if app == nil then
        params = {"-t", title, "--config-file", os.getenv("HOME") .. "/.alacritty.yml"}
        if commands then
            table.insert(params, "-e")
            for i, v in ipairs(commands) do
                table.insert(params, v)
            end
        end

        hs.task.new(
		"/Applications/Alacritty.app/Contents/MacOS/alacritty",
		function()
			print("STOPPED", title)
			appCache[title] = nil
		end,
		params
	):start()
    else
        app:focus()
    end
end

-- ssh to devbox and attach to the last used tmux session.
hs.hotkey.bind({"cmd", "ctrl"}, "k", function()
    launchAlacritty("remote", {"ssh", "t"})
end)

-- attach to the last used tmux session or create one from home directory if there is none.
hs.hotkey.bind({"cmd", "ctrl"}, "l", function()
    launchAlacritty("local", {"zsh", "--login",  "-i", "-c", "ta"})
end)
