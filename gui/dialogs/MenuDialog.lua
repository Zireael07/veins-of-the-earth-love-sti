require 'T-Engine.class'

local UI = require "UIElements"

module("MenuDialog", package.seeall, class.make)

function MenuDialog:load()
    UI:init_text_button(210, 130, 40, "help", "Help", function() setDialog("help_controls") end)
    UI:init_text_button(210, 150, 60, "debug", "Debug menu", function() setDialog("debug_menu", true) end)
end

function MenuDialog:draw()
    love.graphics.setColor(255,255,255)
    --background
    love.graphics.draw(loaded_tiles["stone_bg"], 200, 100)

    love.graphics.setColor(255, 255, 102)
    love.graphics.print("MAIN MENU", 210, 100)

    love.graphics.setColor(colors.GOLD)
    love.graphics.line(200, 120, 550, 120)

    UI:draw(button)
end

function MenuDialog:mouse()
    button = UI:mouse()
end

function MenuDialog:mouse_pressed(x,y,b)
    if mouse.x > 500 or mouse.y < 100 then return end
    UI:mouse_pressed(x,y,b)
end

return MenuDialog