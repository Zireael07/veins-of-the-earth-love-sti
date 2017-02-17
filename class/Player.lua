require 'T-Engine.class'

local Actor = require 'class.Actor'

local Pathfinding = require 'class.interface.Pathfinding'

module("Player", package.seeall, class.inherit(Actor))

function _M:init(t)
    print("Initializing player")
    self.player = true
    --init inherited stuff
    Actor.init(self, t)
    self.image = "player_tile"
    self.name = "Player"
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
  if not x then return end
  if not y then return end
  
  if x == self_x and y == self_y then print("Error: trying to move to own position") return end
  path = Pathfinding:findPath(x, y, self_x, self_y)

  print("Moving to mouse", x,y)
  self:moveAlongPath(path)
  --[[--update FOV
  self:update_draw_visibility_new()]]
  --finish turn
  endTurn()
end

return Player