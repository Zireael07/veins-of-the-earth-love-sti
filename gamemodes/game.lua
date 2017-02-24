-- gamemode for LOVE to handle the game itself
gamemode = {}

local GUI = require 'gui.PlayerGUI'
local Mouse = require 'class.Mouse'

local Area = require 'class.Area'
local Display = require 'class.Display'
local Map = require 'class.Map'
local Spawn = require 'class.Spawn'

local Calendar = require "T-Engine.Calendar"
local TurnManager = require 'class.interface.TurnManager'


local gamera = require("libraries/gamera")


function gamemode.load()
    --setup stuff for turn manager
    acting_entities = {}
    visible_actors = {}

    --messages
    logMessages = {}
    visiblelogMessages = {}

    --dialog ID if any
    popup_dialog = ''

    --load GUI
    GUI:loadGUI()
    --init the display stuff
    Display:init()

    --can't mobdebug here because it freezes
    --tileMap = sti("data/maps/arena_isometric.lua")
    tileMap = sti("data/maps/arena_isometric_2.lua")
    if tileMap then
      Map:init(tileMap.width+1, tileMap.height+1)
      Area:setup()

      Spawn:createActor(1,1, "kobold")
      Spawn:createActor(3,3, "kobold")
      Spawn:createActor(7,7, "human")
      Spawn:createItem(3,3, "studded armor")
      Spawn:createItem(2,2, "torch")
      Spawn:makeItem(4,4, "leather armor", {"+1"})
    end

    player = Spawn:createPlayer(5, 5)

    --set up gamera
    local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height
    camera = gamera.new(0, 0, w, h)

    Mouse:init(camera)

    --load scheduler
    TurnManager:init(acting_entities)
    visible_actors = TurnManager:getVisibleActors()
    s = TurnManager:getSchedulerClass()

    --calendar
    calendar = Calendar.new("data/calendar", "Today is the %s %s of %s DR. The time is %02d:%02d.", 1371, 1, 11)
    game_turn = s:getTime()


    --draw character creation
    love.timer.sleep(.5)
    setDialog("character_creation", "character_creation")
end

function draw_tiles(x,y,w,h)
    Display:draw_display(x,y,w,h)
end

function draw_GUI(player)
    --mouse drawing needs to be outside of camera because reasons
    GUI:draw_mouse()
    GUI:draw_GUI(player)
    GUI:draw_hotbar()
    GUI:draw_drawstats()
    GUI:draw_schedule()
    GUI:draw_turns_order()
    GUI:draw_log_messages()
    if popup_dialog ~= '' then
      draw_dialogs(player)
    end
end

function draw_dialogs(player)
  if popup_dialog == "death_dialog" then
    GUI:draw_death_dialog()
  elseif popup_dialog == "menu_dialog" then
    GUI:draw_menu_dialog()
  elseif popup_dialog == "debug_menu" then
    GUI:draw_debug_dialog()
  elseif popup_dialog == "summon_npc_debug" then
    GUI:draw_summonnpc_dialog()
  elseif popup_dialog == "create_item_debug" then
    GUI:draw_createitem_dialog()
  elseif popup_dialog == "character_creation" then
    GUI:draw_character_creation(player)
  elseif popup_dialog == "inventory" then
    GUI:draw_inventory(player)
  elseif popup_dialog == "log" then
    GUI:draw_log_dialog()
  elseif popup_dialog == "chat" then
    GUI:draw_chat(npc_chat)
  elseif popup_dialog == "character_sheet" then
    GUI:draw_character_sheet(player)
  elseif popup_dialog == "help_controls" then
    GUI:draw_help_controls()
  end
end


function gamemode.draw()
  local dt = love.timer.getDelta()
  camera:draw(function(l, t, w, h)
    --reset color
    love.graphics.setColor(255,255,255)
    tileMap:update(dt)
    tileMap:setDrawRange(-l, -t, w, h)
    tileMap:draw()
    --tile border needs to draw under player tile
    GUI:draw_border_mousetile()
    --draw stuff that isn't in tilemap
    draw_tiles(l,t,w,h)
    GUI:draw_damage_splashes()
    if player and do_draw_labels == true then GUI:draw_labels() end
  end)
    
    --camera independent GUI
    if player then draw_GUI(player) end
end

function gamemode.update(dt)
  --get mouse coords
    mouse = {
   x = love.mouse.getX(), 
   y = love.mouse.getY(),
  }

  if popup_dialog == '' then
    --if not on hotbar UI
    if mouse.x > 120 and mouse.y < (love.graphics.getHeight() - 70) then
      tile_x, tile_y = Mouse:getGridPosition()
    else
      GUI:hotbar_mouse()
    end
  else
    if popup_dialog == 'character_creation' then
      GUI:character_creation_mouse()
    end
    if popup_dialog == "menu_dialog" then
      GUI:menu_dialog_mouse()
    end
    if popup_dialog == "debug_menu" then
      GUI:debug_menu_mouse()
    end
    if popup_dialog == "summon_npc_debug" then
      GUI:summonnpc_menu_mouse()
    end
    if popup_dialog == "create_item_debug" then
      GUI:createitem_menu_mouse()
    end
    if popup_dialog == 'inventory' then
      GUI:inventory_mouse()
    end
    if popup_dialog == "chat" then
      GUI:chat_mouse()
    end

  end

  rounds()

end

--input
function gamemode.keypressed(k, sc)
  local shift = (love.keyboard.isScancodeDown("lshift") or love.keyboard.isScancodeDown("rshift"))
  --if dialog
  if popup_dialog == "character_creation" then
      if sc == "backspace" then
        GUI:character_creation_keypressed(k)
      end
  end
  if popup_dialog == "inventory" then
      if sc == "escape" then dragged = nil end
  end
  --if any dialog other than character creation
  if popup_dialog ~= '' and popup_dialog ~= "character_creation" then
    -- escape to exit
    if sc == "escape" then popup_dialog = ''
    return end
  --no dialogs
  else
    --for actions, check if game is locked before doing anything
    if game_locked 
    and not player.dead then
        if sc == "left" then
          player:PlayerMove("left")
        elseif sc == "right" then
            player:PlayerMove("right")
        elseif sc == "down" then
            player:PlayerMove("down")
        elseif sc == "up" then
            player:PlayerMove("up")
        elseif sc == "g" then
            player:playerPickup()
        elseif sc == "r" then
            player:playerRest()
        end
    end
    --dialogs
    if popup_dialog ~= 'character_creation' then
      if sc == "escape" then
        setDialog("menu_dialog", "menu_dialog")
      elseif sc == 'l' then
        popup_dialog = 'log'
      elseif sc == 'c' then
        popup_dialog = "character_sheet"
      elseif sc == "/" and shift then
        popup_dialog = "help_controls"
      elseif sc == 'i' then
        setDialog("inventory", "inventory")
      --labels
      elseif sc == "tab" then 
        if not do_draw_labels then      
          do_draw_labels = true
        else
          do_draw_labels = false
        end
      end
    end
  end
end

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)
  if popup_dialog == '' then
    if b == 1 then
      --if not on hotbar UI
      if mouse.x > 120 and mouse.y < (love.graphics.getHeight() - 70) then
        if not mouse_mode then
          print("We can move to mouse")
          player:movetoMouse(tile_x, tile_y, player.x, player.y)
        --if we've clicked a hotbar icon
        else
           print("We have a mouse mode set")
           if Map:getCellActor(tile_x, tile_y) then
            a = Map:getCellActor(tile_x, tile_y)
            player:archery_attack(a)
            --nullify mouse mode
            setMouseMode(nil)
          end
        end
      else
        print("We've pressed on hotbar")
        GUI:hotbar_mouse_pressed(x,y,b)
      end

    end
  else
    if popup_dialog == "character_creation" then
      GUI:character_creation_mouse_pressed(x,y,b)
    end
    if popup_dialog == "menu_dialog" then
      GUI:menu_dialog_mouse_pressed(x,y,b)
    end
    if popup_dialog == "debug_menu" then
      GUI:debug_menu_mouse_pressed(x,y,b)
    end
    if popup_dialog == "summon_npc_debug" then
      GUI:summonnpc_menu_mouse_pressed(x,y,b)
    end
    if popup_dialog == "create_item_debug" then
      GUI:createitem_menu_mouse_pressed(x,y,b)
    end
    if popup_dialog == 'inventory' then
      GUI:inventory_mouse_pressed(x,y,b)
    end
    if popup_dialog == "chat" then
      GUI:chat_mouse_pressed(x,y,b)
    end
  end
end

--text input (necessary for character creation)
function gamemode.textinput(t)
  if popup_dialog == 'character_creation' then
    GUI:character_creation_textinput(t)
  end
end

--turns
function schedule()
  visible_actors = {}
  print("[GAME] Clear visible actors")
  TurnManager:schedule()
  visible_actors = TurnManager:getVisibleActors()
end

function rounds()
  TurnManager:rounds()
  schedule_curr = TurnManager:getDebugString()
  if not schedule_curr then schedule_curr = "Something went wrong" end
end

--turn-basedness
function player_lock()
  player:actPlayer()
end

function game_lock()
  game_locked = true
  --clear log
  visiblelogMessages = {}
end

function game_unlock()
  --if game_locked == false then return end
  game_locked = false

  TurnManager:unlocked()
end

function endTurn()
  game_unlock()
  print("[GAME] Ended our turn")
  print_to_log("[GAME] Ended our turn")
end

function removeDead()
  TurnManager:removeDead()
end

function logMessage(color,string)
  table.insert(logMessages,{time=os.clock(),message={color,string}})
  table.insert(visiblelogMessages,{time=os.clock(),message={color,string}})
end

function setDijkstra(map)
  --print("[GAME] Set dijkstra")
  dijkstra = map
end

function setDialog(str, init, data)
  --clean up
  GUI:unload()
  print("[GAME] set dialog", str)
  popup_dialog = str
  if data then
    npc_chat = data
  end
  if init then
    GUI:init_dialog(str)
  end
end

function setMouseMode(mode)
  mouse_mode = mode
end