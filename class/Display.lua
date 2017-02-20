require 'T-Engine.class'

local Map = require "class.Map"

module("Display", package.seeall, class.make)

--convert tile coords to display x,y
function Display:tiletoLoc(x,y)
  local x,y = tileMap:convertTileToPixel(x,y)
  --to draw at center of tile, not at edge
  x,y = x - tileMap.tilewidth/3, y - tileMap.tileheight/2
  return x,y
end

--display stuff
function Display:unitIndicatorCircle(x,y, a)
  if a then 
    local color = a:getReactionColor(a:indicateReaction())
    love.graphics.setColor(color)
    love.graphics.ellipse('line', x, y, 0.3*tileMap.tilewidth, 0.19*tileMap.tileheight)
  end
end

--actual display stuff
function Display:draw_display(x,y,w,h)
    --reset color
    love.graphics.setColor(255,255,255)
    for x = 1, tileMap.width do
      for y = 1, tileMap.height do
        --draw objects
        if Map:getCellObjects(x,y) then
          local o = Map:getCellObject(x,y,1)
          local draw_x,draw_y = Display:tiletoLoc(x,y)
          draw_y = draw_y + tileMap.tileheight/3
          love.graphics.draw(loaded_tiles[o.image], draw_x, draw_y)
        end
        --draw actors
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
        end
      end
    end

    local draw_x, draw_y = Display:tiletoLoc(player.x, player.y)
    love.graphics.draw(loaded_tiles["player_tile"], draw_x, draw_y)
end

return Display