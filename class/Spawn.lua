require 'T-Engine.class'

local Entity = require 'class.Entity'
local TurnManager = require 'class.interface.TurnManager'

local Player = require 'class.Player'
local NPC = require 'class.NPC'
local Object = require 'class.Object'
local Map = require 'class.Map'

module("Spawn", package.seeall, class.make)

function Spawn:createPlayer(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    t = {faction = "player",
      body = { MAIN_HAND=1, OFF_HAND=1, SHOULDER=1, BODY=1, CLOAK=1, BELT=1, QUIVER=1, GLOVES=1, LEGS=1, ARMS=1, BOOTS=1, HELM=1, RING=2, AMULET=1, LITE=1, TOOL=1, INVEN=30 },
      inventory = {{name="longsword"}, {name="leather armor"}, {name="torch"}, },
  }

    player_temp = Player.new(t)

    player_temp:move(x, y)

    print("[Spawn] Created player at ", x,y)
    return TurnManager:addEntity(player_temp)
end

function Spawn:createActor(x,y,id)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end
    if not Map:getCellTerrain(x,y) then print("No cell at x,y") end

    local actor

    if id and npc_types[id] then
      local t = npc_types[id]
      --print("[Spawn] Creating an npc from data", id)
      t = Entity:newEntity(t, "actor")
      --resolve individual stuff
      if t.setup ~= nil then
          print("[Spawn] Setup individual npc stuff")
          t:setup(t)       
      end
      actor = NPC.new(t)
    else
      --actor = Actor.new()
      print("[Spawn] Id not given, not doing anything") return
    end
    if actor then
      if actor:canMove(x,y) then
        actor:move(x,y)
      else
        print("[Spawn] Actor not able to spawn at first spot, finding free grid...")
        found_x, found_y = Map:findFreeGrid(x, y, 10)
        if found_x and found_y then
          actor:move(found_x,found_y)
        end
      end
    end

    --return actor
    return TurnManager:addEntity(actor)
end

function Spawn:createItem(x,y, id)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end
    if not Map:getCell(x,y) then print("No cell at x,y") end

    local object
    if id and object_types[id] then
      local t = object_types[id]
      --print("[Spawn] Creating an object from data", id)
      t = Entity:newEntity(t, "object")
      --resolve individual stuff
      if t.setup ~= nil then
          print("[Spawn] Setup individual item stuff")
          t:setup(t)       
      end
      object = Object.new(t)
    else
      print("[Spawn] Id not given, not doing anything") return
    end

    if object then
      print_to_log("[Spawn] Created item", object.name, " at ",x,y)
      object:place(x,y)
    end

    return object
end

return Spawn