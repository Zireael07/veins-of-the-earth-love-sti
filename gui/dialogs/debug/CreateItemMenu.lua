require 'T-Engine.class'

local UI = require "UIElements"

local Spawn = require "class.Spawn"

module("CreateItemMenu", package.seeall, class.make)

function CreateItemMenu:load()
    local x = 210
    local y = 150
    local w = 60
    for k, v in pairs(object_types) do
        if v.name and loaded_tiles[v.image] then
            UI:init_text_button(x, y, w, v.name, v.name:capitalize(), function() CreateItemMenu:create(v, k) end)
            y = y + 15
        end
    end
end

function CreateItemMenu:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("CREATE ITEM", 210, 120)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 140, 550, 140)

    UI:draw(button)
end

function CreateItemMenu:mouse()
    button = UI:mouse()
end

function CreateItemMenu:mouse_pressed(x,y,b)
    if mouse.x > 500 or mouse.y < 100 then return end
    UI:mouse_pressed(x,y,b)
end

function CreateItemMenu:create(data, key)
    --make sure we have the tile for what we want to spawn
    if loaded_tiles[data.image] then
        Spawn:createItem(player.x, player.y, key)
        print("Spawning... "..key)
    end
    --print("Clicked option: "..data.name.. " key "..key)
end

return CreateItemMenu