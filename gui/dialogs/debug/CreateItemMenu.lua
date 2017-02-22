require 'T-Engine.class'

local UI = require "UIElements"

local Spawn = require "class.Spawn"
local Ego = require "class.Ego"

module("CreateItemMenu", package.seeall, class.make)

function CreateItemMenu:load()
    local x = 210
    local y = 160
    local w = 60
    local list_types = {}
    list_types = CreateItemMenu:generateCategories()

    for i,e in ipairs(list_types) do
        UI:init_text_button(x,y,w, e.name, e.name:capitalize(), function() CreateItemMenu:categorySelect(e.name) end)
        y = y + 15
    end
end

function CreateItemMenu:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("CREATE ITEM", 210, 110)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 130, 350, 130)

    love.graphics.print("Type", 210, 140)
    love.graphics.print("Item", 280, 140)
    love.graphics.print("Ego", 410, 140)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 160, 550, 160)

    UI:draw(button)
end

function CreateItemMenu:mouse()
    button = UI:mouse()
end

function CreateItemMenu:mouse_pressed(x,y,b)
    if mouse.x > 500 or mouse.y < 100 then return end
    UI:mouse_pressed(x,y,b)
end

function CreateItemMenu:generateCategories()
    local list = {}
    local hits = {}

    for k, o in pairs(object_types) do
        if o.type and _G.type(o.type) == "string" then
            local name = o.type
            local key = o.type

            if not hits[key] then
                 list[#list+1] = { name=key, type=o.type }
                 hits[key] = true
            end
        end
    end

    table.sort(list, function(a,b) return a.name < b.name end)
    return list
end

function CreateItemMenu:categorySelect(type)
    --print("Selected category is ", type)
    list = CreateItemMenu:generateItems(type)

    list_egos = Ego:getEgosForType(type)

    --draw list of items
    local x = 280
    local y = 160
    local w = 60
    for i,e in ipairs(list) do
        if e.name then
            UI:init_text_button(x, y, w, e.name, e.name:capitalize(), function() CreateItemMenu:create(e.data, e.key) end)
            y = y + 15
        end
    end

    --draw list of egos
    local x = 410
    local y = 160
    local w = 60
    for i,e in ipairs(list_egos) do
        if e.name then
            UI:init_text_button(x, y, w, e.name, e.name:capitalize(), function() print("Ego is ", e.name) end)
            y = y + 15
        end
    end

end

function CreateItemMenu:generateItems(type)
    local list = {}
    for k, o in pairs(object_types) do
        if o.name and o.type == type then
            list[#list+1] = {name =o.name, key=k, data=o}
        end
    end
    table.sort(list, function(a,b)
        return a.name < b.name
    end)

    return list
end

function CreateItemMenu:create(data, key)
    --make sure we have the tile for what we want to spawn
    if loaded_tiles[data.image] then
        Spawn:createItem(player.x, player.y, key)
        print("Spawning... "..key)
    else
        print("We're missing a tile for "..data.name)
    end
    --print("Clicked option: "..data.name.. " key "..key)
end

return CreateItemMenu