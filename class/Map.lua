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

--core function
function Map:getCell(x, y)
    if not x then return end
    if not y then return end
    --print('Map:getCell', x, y)
    if x > Map:getWidth()-1 or x < 1 then 
      --print("ERROR: Tried to get cell of "..x.." which is outside bounds!")
      return end

    if y > Map:getHeight()-1 or y < 1 then
      --print("ERROR: Tried to get cell of "..y.."which is outside bounds!")
      return end

    if not self.cells[x][y] then
      --print("ERROR: Tried to get cell of "..x..","..y.."but no such cell!") 
      return end
    return self.cells[x][y]
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

function Map:getCellActor(x,y)
   local res
  if not Map:getCell(x,y) then return nil 
  else 
    local cell = Map:getCell(x,y)
    res = cell:getActor()
    --if res then print("Actor for cell: "..x.." "..y.." is..", res) end
    return res
    end
end

function Map:setCellActor(x, y, value)
  --print("Map:setCellActor: ", x, y, value)
  self.cells[x][y]:setActor(value)
end

--convert tile coords to display x,y
function Map:tiletoLoc(x,y)
  local x,y = tileMap:convertTileToPixel(x,y)
    --to draw at center of tile, not at edge
  x,y = x - tileMap.tilewidth/4, y - tileMap.tileheight/4
  return x,y
end


--helper
function Map:findFreeGrid(sx, sy, radius)
    for y=1, Map:getWidth()-1 do
      for x=1, Map:getHeight()-1 do 
        if utils:distance(sx, sy, x, y) < radius then
          if Map:getCellTerrain(x,y) == 210 then 
            print_to_log("[MAP]: Found a free grid: "..x.." "..y)
            return x, y end
        end
      end
  end
end

return Map