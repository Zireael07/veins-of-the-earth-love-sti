require 'T-Engine.class'

local Actor = require 'class.Actor'

local Pathfinding = require 'class.interface.Pathfinding'
local ActorFOV = require 'class.interface.ActorFOV'

module("Player", package.seeall, class.inherit(Actor, ActorFOV))

function _M:init(t)
    print("Initializing player")
    self.player = true
    self.body = t.body or {}
    --init inherited stuff
    Actor.init(self, t)
    --boost our survivability
    self.max_hitpoints = 20
    self.hitpoints = 20
    self.wounds = 20
    --defaults
    self.image = "player_tile"
    self.name = "Player"
    self.gender = nil
    self.race = "Human"
    self.money = {
      platinum = 0,
      gold = 0, 
      silver = 100, 
      copper = 0
    }
end

function _M:actPlayer()
  --print("[Player] act")
  
  --check for resting
  --[[if self:restStep() then
    --print("Player: Rest step")
    endTurn()
  else]]
    game_lock()
  --end
end

function _M:PlayerMove(dir_string)
  if not dir_string then print("No direction!") 
  else 
    dir_x, dir_y = utils:dirfromstring(dir_string)
    --print("Direction: ", dir_x, dir_y)
    end
  self:moveDir(dir_x, dir_y)
  --finish turn
  endTurn()
end

function _M:movetoMouse(x,y, self_x, self_y)
  --handle clicking outside of map
  if not x or x > tileMap.width then return end
  if not y or y > tileMap.height then return end
  
  if x == self_x and y == self_y then print("Error: trying to move to own position") return end
  path = Pathfinding:findPath(x, y, self_x, self_y)

  print("Moving to mouse", x,y)
  self:moveAlongPath(path)
  --[[--update FOV
  self:update_draw_visibility_new()]]
  --finish turn
  endTurn()
end

--inventory
function _M:playerPickup()
  print("Player: pickup")
    if Map:getCell(self.x,self.y):getNbObjects() > 1 then
      --should draw pickup list
      --for now pick all at once
      for i, o in pairs(Map:getCell(self.x,self.y):getObjects()) do
        self:pickupFloor(i)
      end
    else
      print("We have one object to pick")
    self:pickupFloor(1)
    end
end

function _M:doDrop(inven, item)
  --bugfix
  item = tonumber(item)
  self:dropFloor(inven, item)
end

function _M:getCoins(color)
  if not self.money[color] then print("Specified invalid coin color", color) end
  return self.money[color] or 0
end

return Player