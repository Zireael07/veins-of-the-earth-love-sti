require 'T-Engine.class'

local Map = require 'class.Map'

module("Actor", package.seeall, class.make)

function _M:init(t)
    self.x = 1
    self.y = 1
    self.image = t.image
    self.name = t.name
    self.type = t.type
    self.subtype = t.subtype
    --interface stuff
    self.faction = t.faction or "enemy"
    self.path = nil
end

function _M:move(x, y)
  if not x or not y then return end

  x = math.floor(x)
  y = math.floor(y)
  
  --don't go out of bounds
  if x < 0 then x = 0 end
  if y < 0 then y = 0 end
  self.old_x, self.old_y = self.x or x, self.y or y
  self.x, self.y = x, y
  print_to_log("Actor: new x,y : ", self.x, self.y)

  --update map
  Map:setCellActor(self.old_x, self.old_y, nil)
  Map:setCellActor(x, y, self)
end

function _M:moveDir(dx, dy)
  if not dx then dx = 0 end
  if not dy then dy = 0 end
  print_to_log("[Actor] move in dir", dx, dy)
  
  local tx = self.x+dx
  local ty = self.y+dy
  print_to_log("[Actor] Move to", tx, ty)
  if self:canMove(tx,ty) then
    self:move(tx, ty)
  else
    print("[Actor] Failed a move attempt to", tx, ty)
  end
 
end

function _M:canMove(x,y)
  if not Map:getCellTerrain(x,y) then print("No terrain") return false
  else
    --blocked
    if Map:getCellTerrain(x,y) ~= 210 then print("Terrain is not floor") return false end
  end

  return true
end

function _M:moveAlongPath(path)
  if not path or not path[2] then return end
  local tx = path[2].x
  local ty = path[2].y
  print("[Actor] Moving along path", tx, ty)
  if self:canMove(tx, ty) then
    self:move(path[2].x, path[2].y)
  end
end

return Actor