require 'T-Engine.class'

local Map = require 'class.Map'

module("ActorFOV", package.seeall, class.make)

function ActorFOV:resetVisibleTiles()
    for y=0, tileMap.width do --Map:getWidth()-1 do
      for x=0, tileMap.height do --Map:getHeight()-1 do
        Map:setTileVisible(x,y, false)
      end
    end
end

function ActorFOV:update_draw_visibility_new()
    local radius = 4 --self.lite or 0
    print("[ActorFOV] Our x,y are: "..self.x..", "..self.y..". R: "..radius)

    --reset visible tiles
    self:resetVisibleTiles()
    -- mark all seen tiles as not currently seen
    
    fov=ROT.FOV.Precise:new(lightPassesCallback,{topology=8})
    results = fov:compute(self.x,self.y,radius,isVisibleCallback)
    --results = fov:compute(self.x, self.y, self.lite or 0, isVisibleCallback)
end

-- for FOV calculation
function lightPassesCallback(coords,qx,qy)
    -- required as otherwise moving near the edge crashes
    if Map:getCell(qx, qy) then
        -- actual check
        if Map:getCellTerrain(qx, qy) == 210 then
            return true
        end
    end
    return false
end

-- for FOV calculation
function isVisibleCallback(x,y,r,v)
    --print("Setting as visible", x, y, r, v)
    -- first mark as visible
    Map:setTileVisible(x,y, true)
    -- also mark  as currently seen
    Map:setTileSeen(x,y, true)
end

return ActorFOV