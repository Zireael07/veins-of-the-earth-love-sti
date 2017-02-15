-- gamemode for LOVE to handle the game itself
gamemode = {}

local GUI = require 'class.PlayerGUI'

local Spawn = require 'class.Spawn'

local gamera = require("libraries/gamera")


function gamemode.load()
    --can't mobdebug here because it freezes
    tileMap = sti("data/maps/arena_isometric.lua")

    player = Spawn:createPlayer(18, 9)

    --set up gamera
    local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height
    camera = gamera.new(0, 0, w, h)
end

function draw_tiles()
    --reset color
    love.graphics.setColor(255,255,255)
    local x,y = tileMap:convertTileToPixel(player.x,player.y)
    --to draw at center of tile, not at edge
    x,y = x - tileMap.tilewidth/4, y - tileMap.tileheight/4
    love.graphics.draw(loaded_tiles["player_tile"], x, y)
end

function draw_GUI()
    GUI:draw_mouse()
    --GUI:draw_border_mousetile()
    GUI:draw_drawstats()
end

function gamemode.draw()
  local dt = love.timer.getDelta()
  camera:draw(function(l, t, w, h)
    --reset color
    love.graphics.setColor(255,255,255)
    tileMap:update(dt)
    tileMap:setDrawRange(-l, -t, w, h)
    tileMap:draw()
    
  end)
    --tile border needs to draw under player tile
    GUI:draw_border_mousetile()
  --drawing outside of camera to draw at invariant coords
    --draw stuff that isn't in tilemap
    draw_tiles()
    --camera independent GUI
  draw_GUI()
end

function gamemode.update(dt)
  --get mouse coords
    mouse = {
   x = love.mouse.getX(),
   y = love.mouse.getY()
  }
  tile_x, tile_y = tileMap:convertPixelToTile(mouse.x, mouse.y)
  --round down
  tile_x = math.floor(tile_x)
  tile_y = math.floor(tile_y)

end

--input
function gamemode.keypressed(k, sc)
  require("mobdebug").on()
    if not player.dead then
        if sc == "left" then
          player:PlayerMove("left")
        elseif sc == "right" then
            player:PlayerMove("right")
        elseif sc == "down" then
            player:PlayerMove("down")
        elseif sc == "up" then
            player:PlayerMove("up")
        end
    end
end