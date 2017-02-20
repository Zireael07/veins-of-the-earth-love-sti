require 'T-Engine.class'

local Map = require 'class.Map'

local Faction = require 'class.Faction'

--needs to be req'd first
local ActorTemporaryValues = require 'T-Engine.interface.ActorTemporaryValues'

local ActorInventory = require 'class.interface.ActorInventory'
local Combat = require 'class.interface.ActorCombat'
local ActorLife = require 'class.interface.ActorLife'
local ActorStats = require 'class.interface.ActorStats'

module("Actor", package.seeall, class.inherit(ActorTemporaryValues,
  ActorInventory, Combat, ActorLife, ActorStats))

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
    --lighting and vision
    self.lite = t.lite
    self.darkvision = t.darkvision or 0
    -- Default melee barehanded damage
    self.combat = { dam = {1,4} }
    self.hit_die = t.hit_die

    self.inventory = t.inventory
    --init inherited stuff
    ActorInventory.init(self, t)
    ActorLife.init(self, t)
    ActorStats.init(self, t)
    --delayed setup
    if self.inventory then
      print("We have an inventory")
      self:equipItems(self.inventory)
    end
end

function _M:act()
  --check if we're alive
  if self.dead then return false end
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
    --should call combat
    if Map:getCellActor(x,y) then 
      local target = Map:getCellActor(x,y)
      self:bumpTarget(target)
      return false 
    end
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

function _M:reactionToward(target)
  local ret = Faction:factionReaction(self.faction, target.faction)
  --print("Actor reaction toward, ", target.name, "is: ", ret)
  return ret
end

function _M:indicateReaction()
  local str
  if self:reactionToward(player) > 50 then str = "helpful"
  elseif self:reactionToward(player) > 0 then str = "friendly"
  elseif self:reactionToward(player) < -50 then str = "hostile"
  elseif self:reactionToward(player) < 0 then str = "unfriendly"
  else str = "neutral" end

  return str
end

function _M:getReactionColor(val)
  local color 
  if val == "player" or val == "helpful" then
    color = {0, 255, 255}
  elseif val == "friendly" then 
    color = {0, 255, 0}
  elseif val == "neutral" then 
    color = {255, 255, 0}
  elseif val == "unfriendly" then 
    color = {255, 119,0}
  elseif val == "hostile" then
    color = {255, 0, 0}
  end 

  return color
end

function _M:bumpTarget(target)
  --check for reaction
  if target:reactionToward(self) < -50 then
    self:attackTarget(target)
  end
end

function _M:on_die(src)
  print("[ACTOR] on_die")
  --drop our inventory
  local dropx, dropy = self.x, self.y
  local invens = {}
  for id, inven in pairs(self.inven) do
    invens[#invens+1] = inven
  end

  for id, inven in pairs(invens) do
    for i = #inven, 1, -1 do
      local o = inven[i]
      o.dropped_by = o.dropped_by or self.name

      self:removeObject(inven, i)
      Map:setCellObject(dropx, dropy, o)
      print("[ACTOR] on death: dropped item from inventory", o.name)
    end
  end
  self.inven = {}
end

function _M:equipItems(t)
  print("Equipping items")
  for i, v in ipairs(t) do
    print("Spawning item for equipment for", self.name)
    local o
      o = Spawn:createItem(1, 1, v.name)

      if o then
        --remove it from the 1,1 tile
        i = o:getObjectIndex(o.x, o.y)
        Map:setCellObjectbyIndex(o.x, o.y, nil, i)
        if o.slot then
          --print("Object's slot is", o.slot)
          if self:wearObject(o, o.slot) then

          print("Wearing an object", o.name)
          else
            self:addObject(self.INVEN_INVEN, o)
            print("Adding object to inventory", o.name)
          end
        end
      end
  end
end

return Actor