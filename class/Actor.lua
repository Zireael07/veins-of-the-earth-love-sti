require 'T-Engine.class'

local Map = require 'class.Map'

local Faction = require 'class.Faction'

--needs to be req'd first
local ActorTemporaryValues = require 'T-Engine.interface.ActorTemporaryValues'

local ActorInventory = require 'class.interface.ActorInventory'
local Combat = require 'class.interface.ActorCombat'
local ActorLife = require 'class.interface.ActorLife'
local ActorStats = require 'class.interface.ActorStats'

--player specific
local Chat = require 'class.Chat'

module("Actor", package.seeall, class.inherit(ActorTemporaryValues,
  ActorInventory, Combat, ActorLife, ActorStats))

function Actor:init(t)
    --print("Initing actor")
    self.batch_logs = {}
    self.x = 1
    self.y = 1
    self.image = t.image
    self.name = t.name
    self.type = t.type
    self.subtype = t.subtype
    --interface stuff
    self.faction = t.faction or "enemy"
    self.path = nil
    self.inventory = t.inventory
    --lighting and vision
    self.lite = t.lite
    self.darkvision = t.darkvision or 0
    -- Default melee barehanded damage
    self.combat = { dam = {1,4} }
    self.hit_die = t.hit_die
    --dialogue
    self.text = t.text
    self.convo = t.convo
    self.languages = t.languages
    --portrait
    self.show_portrait = t.show_portrait or false
    if self.show_portrait then
      self:portraitGen()
    end
    --init inherited stuff
    ActorInventory.init(self, t)
    ActorLife.init(self, t)
    ActorStats.init(self, t)
    
    --batch logs
    if self.stats_log_table then
      self.batch_logs = table.clone(self.stats_log_table)
    end
    if self.life_logs_table then
      self.batch_logs = batch_tables_together(self.batch_logs, self.life_logs_table)
    end
    self.stats_log_table = nil
    self.life_logs_table = nil
    --delayed setup
    if self.inventory then
      print("We have an inventory")
      self:equipItems(self.inventory)
    end
    --test batch printing
    if self.batch_logs then
      batch_print_to_log(self.batch_logs)
    end
end

function Actor:act()
  --check if we're alive
  if self.dead then return false end
end

function Actor:move(x, y)
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

function Actor:moveDir(dx, dy)
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

function Actor:canMove(x,y)
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

function Actor:moveAlongPath(path)
  if not path or not path[2] then return end
  local tx = path[2].x
  local ty = path[2].y
  print("[Actor] Moving along path", tx, ty)
  if self:canMove(tx, ty) then
    self:move(path[2].x, path[2].y)
  end
end

function Actor:reactionToward(target)
  local ret = Faction:factionReaction(self.faction, target.faction)
  --print("Actor reaction toward, ", target.name, "is: ", ret)
  return ret
end

function Actor:indicateReaction()
  local str
  if self:reactionToward(player) > 50 then str = "helpful"
  elseif self:reactionToward(player) > 0 then str = "friendly"
  elseif self:reactionToward(player) < -50 then str = "hostile"
  elseif self:reactionToward(player) < 0 then str = "unfriendly"
  else str = "neutral" end

  return str
end

function Actor:getReactionColor(val)
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

function Actor:bumpTarget(target)
  --check for reaction
  if target:reactionToward(self) < -50 then
    self:attackTarget(target)
  else
    if self.player == true then
      --target.emote = "Hey you!"
      if target.convo then
        local chat = Chat.new(target.convo, target, self)
        chat:invoke()
      end
    end
  end
end

function Actor:on_die(src)
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

function Actor:equipItems(t)
  --print("Equipping items")
  for i, v in ipairs(t) do
    --print("Spawning item for equipment for", self.name)
    local o
      o = Spawn:createItem(1, 1, v.name)

      if o then
        --remove it from the 1,1 tile
        i = o:getObjectIndex(o.x, o.y)
        Map:setCellObjectbyIndex(o.x, o.y, nil, i)
        if o.slot then
          --print("Object's slot is", o.slot)
          if self:wearObject(o, o.slot) then

          print_to_log("[Equipping] Wearing an object", o.name)
          else
            self:addObject(self.INVEN_INVEN, o)
            print_to_log("Adding object to inventory", o.name)
          end
        end
      end
  end
end

--languages
function Actor:getLanguages()
  local list = {}

    for i, n in pairs(self.languages) do
        list[#list+1] = {
            name = n
        }
    end

  return list
end

function Actor:speakLanguage(lg)
  if type(lg) ~= "string" then return nil end

  for i,t in pairs(self:getLanguages()) do
    if t.name == lg then return true end
  end
  return false
end

function Actor:speakSameLanguage(target)
  for i, t in pairs(self:getLanguages()) do
    if target:speakLanguage(t.name) then return true end
    return false
  end
end

--Portrait generator
function Actor:portraitGen()
  local doll = "doll"

  if self.show_portrait == true then

    local base = {"dwarf", "dwarf_alt"}

    if self.subtype == "drow" then
      doll = "doll_drow"
    elseif self.subtype == "dwarf" then
      doll = "doll_"..rng_table(base)
    end

    self.portrait = doll

    --First things first
    local add = {}

    --Now the rest of the face
    local eyes_light = {"amber", "seablue", "seagreen", "yellow"}
    local eyes_medium = {"green", "blue", "gray"}
    local eyes_dark = {"black", "brown"}
    local eyes_red = {"red", "pink"}

    local eyes_dwarf = {"1", "2", "3", "4"}
    local eyes_human = {}
    local eyes_all = {}

    local mouth = {"mouth", "mouth2"}

    --Hair colors
    local color = {"black", "black2", "brown", "gray", "red", "white"}
    local color_choice = rng_table(color)

    --Hair
    if self.subtype == "drow" then
      local drow_hair = {"1", "2", "3", "4"}
      add[#add+1] = {name="drow_hair"..rng_table(drow_hair) }
    else
  --  elseif self.subtype == "dwarf" then
      add[#add+1] = {name="hair_"..color_choice }
  --  else
    end


    if self.subtype == "drow" then
      add[#add+1] = {name="eyebrows_drow"}
    else
      add[#add+1] = {name="eyebrows_"..color_choice }
    end

    if self.subtype == "dwarf" then
    --  table.append(eyes_dwarf, eyes_medium)
    --  table.append(eyes_dwarf, eyes_dark)
      add[#add+1] = {name="eyes_dwarf_"..rng_table(eyes_dwarf) }
    elseif self.subtype == "human" then
      table.append(eyes_human, eyes_light)
      table.append(eyes_all, eyes_medium)
      table.append(eyes_human, eyes_dark)
      add[#add+1] = {name="eyes_"..rng_table(eyes_human) }
    else
      table.append(eyes_all, eyes_light)
      table.append(eyes_all, eyes_medium)
      table.append(eyes_all, eyes_dark)
      table.append(eyes_all, eyes_red)
      add[#add+1] = {name="eyes_"..rng_table(eyes_all) }
    end

    if self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_nose"}
    end

    if self.subtype == "drow" then
      add[#add+1] = {name="drow_"..rng_table(mouth) }
    elseif self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_"..rng_table(mouth) }
    else
      add[#add+1] = {name=rng_table(mouth) }
    end


    if self.subtype == "dwarf" then
      add[#add+1] = {name="dwarf_beard_"..color_choice }
    end

    --Decor
    if self.name:find("noble") then
      add[#add+1] = {name="noble_outfit"}
    end

    if self.name:find("commoner") or self.name:find("courtesan") then
      add[#add+1] = {name="hood_base"}
    end

    if self.name:find("shopkeeper") or self.name:find("sage") then
      local glasses = {"1", "2"}
      add[#add+1] = {name="glasses"..rng_table(glasses) }
    end

    if self.name:find("sage") then
      add[#add+1] = {name="robes"}
    end

    if self.name:find("hireling") then
      add[#add+1] = {name="armor" }
    end

    self.portrait_table = add
  end
end

return Actor