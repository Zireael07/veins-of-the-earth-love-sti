require 'T-Engine.class'

local Pathfinding = require "class.interface.Pathfinding"

local Map = require "class.Map"

module("ActorAI", package.seeall, class.make)

actor_path = {}

function ActorAI:init()
  self.seen_actors = {}
  print("[ActorAI] Inited AI")
end

function ActorAI:act()
  print_to_log("[ActorAI] running AI")
  self:getSeenActors()
end

function ActorAI:target(tx, ty, self_x, self_y)
    if not tx or not ty then return end

    --test
    local w = Map:getWidth()-1
    local h = Map:getHeight()-1
    dir_x, dir_y = Pathfinding:findPathDijkstra(tx, ty, self_x, self_y, w, h)

    return dir_x, dir_y
end

function ActorAI:getPath()
  --print("Getting path")
  return actor_path
end

function ActorAI:getSeenActors()
  --clear
  self.seen_actors = {}
  local range = math.max(self.lite or 0, self.darkvision or 0)
  for y=1, tileMap.width do --Map:getWidth()-1 do
      for x=1, tileMap.height do --Map:getHeight()-1 do 
        if utils:distance(self.x, self.y, x, y) < range then
          if Map:getCellActor(x,y) then 
            local a = Map:getCellActor(x,y)
            if a and a ~= self and not a.dead then
              self.seen_actors[#self.seen_actors+1] = a
              print("AI ", self.name, "can see ", a.name)
            end
          end
        end
      end
  end
end

function ActorAI:canSeePlayer()
  for i,v in ipairs(self.seen_actors) do
    if self.seen_actors[i].player then
      print_to_log("AI ", self.name, "can see Player!!")
      return true
    end
    return false
  end
end

return ActorAI
