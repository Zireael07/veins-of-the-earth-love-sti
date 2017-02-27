gamemode = {}

function gamemode.load()
    background = love.graphics.newImage("gfx/Veins.png")
    welcome_text = "Welcome to Veins of the Earth!"
end

function load_stuff()
    --create log file
    make_log_file()
    open_save()

    --load stuff that is necessary for all the classes/modules
    load = love.filesystem.load("load.lua")
    local loaded = load()
    
    --randomness
    rng = ROT.RNG.Twister:new()
    rng:randomseed()

    --require content tables
    require 'data/npcs'
    require 'data/objects'
end



function gamemode.keypressed(k)
    if k == "return" then
        welcome_text = "Loading..."
        --load stuff necessary for the game 
        load_stuff()
        loadGamemode("game")
    end
end

function gamemode.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(background)
    love.graphics.setColor(255, 215, 0)--(colors.GOLD)
    love.graphics.rectangle("line", 100, 100, 350, 100)
    love.graphics.setColor(140, 140, 140)--(colors.SLATE)
    love.graphics.rectangle("fill", 100, 100, 350, 100)
    love.graphics.setColor(255, 119, 0)--(colors.ORANGE)
    love.graphics.print(welcome_text, 100, 100)
    love.graphics.print("Press ENTER to start game!", 100, 150)
end