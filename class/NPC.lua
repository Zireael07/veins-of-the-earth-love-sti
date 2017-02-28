require 'T-Engine.class'

local Actor = require 'class.Actor'
--AI
local ActorAI = require 'class.interface.ActorAI'

local Map = require 'class.Map'
local Treasure = require 'class.Treasure'

module("NPC", package.seeall, class.inherit(Actor, ActorAI))

function NPC:init(t)
    --init inherited stuff
    Actor.init(self, t)
    ActorAI.init(self)
end

function NPC:act()
    ActorAI.act(self)
    if self:reactionToward(player) < 0 and self:canSeePlayer() then
        self:target(player.x, player.y)
    else
        self:randomTarget()
    end
end

function NPC:target(x,y)
  dir_x, dir_y = ActorAI:target(x, y, self.x, self.y)
  --print("[NPC] AI moving in dir", dir_x, dir_y)
  self:moveDir(dir_x, dir_y)
end  

function NPC:randomTarget()
    x, y = Map:findRandomStandingGrid()
    dir_x, dir_y = ActorAI:target(x, y, self.x, self.y)
    --print("[NPC] AI moving in dir", dir_x, dir_y)
    self:moveDir(dir_x, dir_y)
end  

function NPC:on_die(src)
    Actor.on_die(self, src)
    print("[NPC] on die")
    --gen treasure
    self:spawnTreasure(1)
end

function NPC:spawnTreasure(lvl)
    treasure = Treasure:selectTreasure(lvl)
    if treasure then
        Spawn:createItem(self.x, self.y, treasure)
    end
end

return NPC