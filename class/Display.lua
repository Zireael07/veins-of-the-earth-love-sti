require 'T-Engine.class'

local Map = require "class.Map"

module("Display", package.seeall, class.make)

function Display:init()
    --init shader
    outline_shader = love.graphics.newShader("gfx/shaders/outline.glsl")
end

--convert tile coords to display x,y
function Display:tiletoLoc(x,y)
  local x,y = tileMap:convertTileToPixel(x,y)
  --to draw at center of tile, not at edge
  x,y = x - tileMap.tilewidth/3, y - tileMap.tileheight/2
  return x,y
end

function Display:tilePolyPoints(tile_x,tile_y)
  --x,y is the top of the square I'm pointing mouse at
  local x,y = tileMap:convertTileToPixel(tile_x, tile_y)
  local bottomx, bottomy = tileMap:convertTileToPixel(tile_x+1, tile_y+1)
  --bottom of x-1, y is our left end
  local leftx, lefty = tileMap:convertTileToPixel(tile_x, tile_y+1)
  --top of x+1, y is our right end
  local rightx, righty = tileMap:convertTileToPixel(tile_x+1, tile_y)

  --order dictated by drawing the polygon
  return x,y, leftx, lefty, bottomx, bottomy, rightx, righty
end

--display stuff
function Display:unitIndicatorCircle(x,y, a)
  if a then 
    local color = a:getReactionColor(a:indicateReaction())
    love.graphics.setColor(color)
    love.graphics.ellipse('line', x, y, 0.3*tileMap.tilewidth, 0.19*tileMap.tileheight)
  end
end

---debugging
function Display:drawDebug(x,y)
  love.graphics.setColor(255,255,255)
  local draw_x,draw_y = Display:tiletoLoc(x,y)
  draw_y = draw_y + tileMap.tileheight/2
  if Map:isTileVisible(x,y) then
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("VIS", draw_x, draw_y)
  else
    love.graphics.setColor(128,128,128)
    love.graphics.print("NOT VIS", draw_x, draw_y)
  end
end

function Display:drawActors(x,y)
  --draw actors
  if Map:isTileVisible(x,y) then
    love.graphics.setColor(255,255,100)
    if Map:getCellActor(x,y) then
      local a = Map:getCellActor(x,y)
      local draw_x,draw_y = Display:tiletoLoc(x,y)
      --attitude indicator
      local circle_x = draw_x+0.3*tileMap.tilewidth
      local circle_y = draw_y + tileMap.tileheight
      Display:unitIndicatorCircle(circle_x, circle_y, a)

      --reset color
      love.graphics.setColor(255,255,255)
      love.graphics.draw(loaded_tiles[a.image], draw_x, draw_y)
      --draw outline around actors to make them pop out
      outline_shader:send( "stepSize", {1/32, 1/32})
      love.graphics.setShader(outline_shader)
      love.graphics.draw(loaded_tiles[a.image], draw_x, draw_y)
      love.graphics.setShader()
    end
  end
end

--actual display stuff
function Display:draw_display(x,y,w,h)
    --reset color
    love.graphics.setColor(255,255,255)
    for x = 1, tileMap.width do
      for y = 1, tileMap.height do
        Display:drawActors(x,y)
        if Map:isTileVisible(x,y) or Map:isTileSeen(x,y) then
          --overlay for visible
          if Map:isTileVisible(x,y) then
            love.graphics.setColor(255,255,100)
          else 
            love.graphics.setColor(128,128,128)
          end
          --draw objects
          if Map:getCellObjects(x,y) then
            local o = Map:getCellObject(x,y,1)
            local draw_x,draw_y = Display:tiletoLoc(x,y)
            draw_y = draw_y + tileMap.tileheight/3
            love.graphics.draw(loaded_tiles[o.image], draw_x, draw_y)
          end
        end --end of if visible or seen
        love.graphics.setColor(255, 255, 255)
        --Display:drawDebug(x,y)
      end
    end
end

return Display