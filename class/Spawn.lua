require 'T-Engine.class'

local Entity = require 'class.Entity'
local TurnManager = require 'class.interface.TurnManager'

local Player = require 'class.Player'
local NPC = require 'class.NPC'
local Map = require 'class.Map'

module("Spawn", package.seeall, class.make)

function Spawn:createPlayer(x,y)
    if not x or not y then print("No location parameters") return end
    if x > Map:getHeight()-1 then print("X out of bounds") end
    if y > Map:getWidth()-1 then print("Y out of bounds") end

    t = {faction = "player",
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

return Spawn