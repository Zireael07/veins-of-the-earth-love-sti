require 'T-Engine.class'

local UI = require "UIElements"

module("DebugMenu", package.seeall, class.make)

function DebugMenu:load()
    UI:init_text_button(210, 150, 40, "summon", "Create NPC", function() setDialog("summon_npc_debug", true) end)
    UI:init_text_button(210, 170, 60, "create", "Create Item", function() end)
end

function DebugMenu:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("DEBUG MENU", 210, 120)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 140, 550, 140)

    UI:draw(button)
end

function DebugMenu:mouse()
    button = UI:mouse()
end

function DebugMenu:mouse_pressed(x,y,b)
    if mouse.x > 500 or mouse.y < 100 then return end
    UI:mouse_pressed(x,y,b)
end

return DebugMenu