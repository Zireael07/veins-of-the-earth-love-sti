-- load a new gamemode
function loadGamemode(mode, skipQuit)
    if not mode then return false end
    if not skipQuit and oldGamemode and oldGamemode.quit then oldGamemode.quit() end
    love.filesystem.load("gamemodes/"..mode..".lua")() gamemode.load()
    print("Gamemode "..mode.." loaded")
    return true
end

--log files
--open save folder
function open_save()
    love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
end

--create the log file
function make_log_file()
    local time = os.date("%Y-%m-%d %H:%M:%S", os.time())
    love.filesystem.write("log.txt", "Game started: "..time.."\n\n")
end

function print_to_log(...)
    local data
    --grab all the things
    for i = 1, select("#", ...) do 
        if data ~= nil then
            data = data..tostring(select(i, ...)).." "
        else
            data = tostring(select(i, ...)).." "
        end
    end

    local time = os.date("%Y-%m-%d %H:%M:%S", os.time())
    data = "["..time .."] "..data .. "\n"

    love.filesystem.append("log.txt", data)
end

function rng_table(t)
    return t[love.math.random(1,#t)]
end