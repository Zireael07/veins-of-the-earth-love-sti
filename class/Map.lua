require 'T-Engine.class'

local Cell = require 'class.Cell'

module("Map", package.seeall, class.make)

function Map:init(width, height)
  print('Map:initialize', width, height)
    
    self.cells = {}
    self.bounds = { X=0, Y=0, Width=width, Height=height }

    -- Initialize the array of cells
    --Need to start at 1 because that's what Dijkstra wants
    for x = 1, self.bounds.Width-1 do
        self.cells[x] = {}
        for y = 1, self.bounds.Height-1 do
            self.cells[x][y] = Cell:new()
        end
    end
end

--bounds
function Map:getBounds()
--  print('Map:getBounds')
    return self.bounds
end

function Map:getWidth()
--  print('Map:getWidth')
    return self.bounds.Width
end
function Map:getHeight()
--  print('Map:getHeight')
    return self.bounds.Height
end


--we're drawing on STI here
function Map:getCellTerrain(x,y)
    local terrain

    if tileMap and x and y then
        local lay = tileMap.layers["Tile Layer 1"]
        local data = lay.data
        if data[y] then
            local test = data[y][x]
            if test then
               terrain = test.gid
               --print("X "..x..", Y "..y..", terrain is", terrain)
            end
        end
    end

    return terrain
end

return Map