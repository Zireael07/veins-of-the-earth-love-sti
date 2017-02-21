require 'T-Engine.class'

local UI = require "gui.UIElements"

--various dialogs
local CharacterCreation = require 'gui.dialogs.CharacterCreation'
local LogDialog = require 'gui.dialogs.LogDialog'
local InventoryDialog = require 'gui.dialogs.InventoryDialog'
local ChatDialog = require 'gui.dialogs.ChatDialog'

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
    end]]
    if str == "inventory" then
        InventoryDialog:load()
    end
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

--inventory
function DialogsGUI:draw_inventory(player)
    InventoryDialog:draw(player)
end

function DialogsGUI:inventory_mouse()
    InventoryDialog:mouse()
end

function DialogsGUI:inventory_mouse_pressed(x,y,b)
    InventoryDialog:mouse_pressed(x,y,b)
end

--log
function DialogsGUI:draw_log_dialog()
    LogDialog:draw()
end

--NPC chat screen
function DialogsGUI:draw_chat(npc_chat)
    ChatDialog:draw(npc_chat.chat, npc_chat.id)
end

function DialogsGUI:chat_mouse()
    ChatDialog:mouse()
end

function DialogsGUI:chat_mouse_pressed(x,y,b)
    ChatDialog:mouse_pressed(x,y,b)
end

return DialogsGUI