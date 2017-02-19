require 'T-Engine.class'

local UI = require "gui.UIElements"

--various dialogs
local CharacterCreation = require 'gui.dialogs.CharacterCreation'
local LogDialog = require 'gui.dialogs.LogDialog'


module("DialogsGUI", package.seeall, class.make)

--generic
function DialogsGUI:unload()
    UI:unload()
end

function DialogsGUI:init_dialog(str)
    if str == "character_creation" then
        CharacterCreation:load()
    end
    --[[if str == "menu_dialog" then
        MenuDialog:load()
    end
    if str == "inventory" then
        InventoryDialog:load()
    end]]
end


--character creation
function DialogsGUI:draw_character_creation(player)
    CharacterCreation:draw(player)
end

function DialogsGUI:character_creation_mouse()
    CharacterCreation:mouse()
end

function DialogsGUI:character_creation_mouse_pressed(x,y,b)
    CharacterCreation:mouse_pressed(x,y,b)
end

function DialogsGUI:character_creation_keypressed(k)
    CharacterCreation:keypressed(k)
end

function DialogsGUI:character_creation_textinput(t)
    CharacterCreation:textinput(t)
end

--log
function DialogsGUI:draw_log_dialog()
    LogDialog:draw()
end

return DialogsGUI