require 'T-Engine.class'

local Actor = require 'class.Actor'

module("Player", package.seeall, class.inherit(Actor))

function _M:init(t)
    print("Initializing player")
    self.player = true
    self.image = "player_tile"
    self.name = "Player"
end

function _M:PlayerMove(dir_string)
  if not dir_string then print("No direction!") 
  else 
    dir_x, dir_y = utils:dirfromstring(dir_string)
    --print("Direction: ", dir_x, dir_y)
    end
  self:moveDir(dir_x, dir_y)
end

return Player