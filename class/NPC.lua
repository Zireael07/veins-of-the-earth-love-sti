require 'T-Engine.class'

local Actor = require 'class.Actor'

local Map = require 'class.Map'

module("NPC", package.seeall, class.inherit(Actor))

function NPC:init(t)
    --init inherited stuff
    Actor.init(self, t)
    --ActorAI.init(self)
end

return NPC