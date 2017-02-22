require 'T-Engine.class'

local UI = require "gui.UIElements"

--various dialogs
local CharacterCreation = require 'gui.dialogs.CharacterCreation'
local LogDialog = require 'gui.dialogs.LogDialog'
local InventoryDialog = require 'gui.dialogs.InventoryDialog'
local ChatDialog = require 'gui.dialogs.ChatDialog'
local CharacterSheet = require 'gui.dialogs.CharacterSheet'
local HelpControls = require 'gui.dialogs.HelpControls'
--in game menu
local MenuDialog = require 'gui.dialogs.MenuDialog'
--debug
local DebugMenu = require 'gui.dialogs.debug.DebugMenu'
local SummonNPCMenu = require 'gui.dialogs.debug.SummonNPCMenu'
--death screen
local DeathDialog = require 'gui.dialogs.DeathDialog'

module("DialogsGUI", package.seeall, class.make)

--generic
function DialogsGUI:unload()
    UI:unload()
end

function DialogsGUI:init_dialog(str)
    if str == "character_creation" then
        CharacterCreation:load()
    end
    if str == "menu_dialog" then
        MenuDialog:load()
    end
    if str == "debug_menu" then
        DebugMenu:load()
    end
    if str == "summon_npc_debug" then
        SummonNPCMenu:load()
    end
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

function DialogsGUI:draw_character_sheet(player)
    CharacterSheet:draw(player)
end

function DialogsGUI:draw_help_controls()
    HelpControls:draw()
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

--menu
function DialogsGUI:draw_menu_dialog()
    MenuDialog:draw()
end

function DialogsGUI:menu_dialog_mouse()
    MenuDialog:mouse()
end

function DialogsGUI:menu_dialog_mouse_pressed(x,y,b)
    MenuDialog:mouse_pressed(x,y,b)
end

--debug
function DialogsGUI:draw_debug_dialog()
    DebugMenu:draw()
end

function DialogsGUI:debug_menu_mouse()
    DebugMenu:mouse()
end

function DialogsGUI:debug_menu_mouse_pressed(x,y,b)
    DebugMenu:mouse_pressed(x,y,b)
end

function DialogsGUI:draw_summonnpc_dialog()
    SummonNPCMenu:draw()
end

function DialogsGUI:summonnpc_menu_mouse()
    SummonNPCMenu:mouse()
end

function DialogsGUI:summonnpc_menu_mouse_pressed(x,y,b)
    SummonNPCMenu:mouse_pressed(x,y,b)
end

--death screen
function DialogsGUI:draw_death_dialog()
    DeathDialog:draw()
end

return DialogsGUI