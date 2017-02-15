require 'T-Engine.class'

module("Map", package.seeall, class.make)

function Map:getCellTerrain(x,y)
    local terrain

    if tileMap and x and y then
        local lay = tileMap.layers["Tile Layer 1"]
        local data = lay.data
        if data[tile_y] then
            local test = data[tile_y][tile_x]
            if test then
               --print("We have the values ", tile_x, tile_y)
               terrain = test.gid
               print("X "..tile_x..", Y "..tile_y..", terrain is", terrain)
            end
        end
    end

    return terrain
end

return Map