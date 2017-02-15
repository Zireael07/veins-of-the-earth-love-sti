require 'T-Engine.class'

module("Map", package.seeall, class.make)

function Map:getCellTerrain(x,y)
    local terrain

    if tileMap and x and y then
        local lay = tileMap.layers["Tile Layer 1"]
        local data = lay.data
        if data[y] then
            local test = data[y][x]
            if test then
               terrain = test.gid
               print("X "..x..", Y "..y..", terrain is", terrain)
            end
        end
    end

    return terrain
end

return Map