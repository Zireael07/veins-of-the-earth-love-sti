-- gamemode for LOVE to handle the game itself
gamemode = {}

local GUI = require 'class.PlayerGUI'
local Mouse = require 'class.Mouse'

local Area = require 'class.Area'
local Map = require 'class.Map'
local Spawn = require 'class.Spawn'

local TurnManager = require 'class.interface.TurnManager'


local gamera = require("libraries/gamera")


function gamemode.load()
    --setup stuff for turn manager
    acting_entities = {}
    visible_actors = {}

    --can't mobdebug here because it freezes
    --tileMap = sti("data/maps/arena_isometric.lua")
    tileMap = sti("data/maps/arena_isometric_2.lua")
    if tileMap then
      Map:init(tileMap.width+1, tileMap.height+1)
      Area:setup()

      Spawn:createActor(1,1, "kobold")
      Spawn:createActor(3,3, "kobold")
    end

    player = Spawn:createPlayer(5, 5)

    --set up gamera
    local w, h = tileMap.tilewidth * tileMap.width, tileMap.tileheight * tileMap.height
    camera = gamera.new(0, 0, w, h)

    Mouse:init(camera)

    --load scheduler
    TurnManager:init(acting_entities)
    visible_actors = TurnManager:getVisibleActors()
    s = TurnManager:getSchedulerClass()
end

function draw_tiles(x,y,w,h)
    --reset color
    love.graphics.setColor(255,255,255)
    for x = 1, tileMap.width do
      for y = 1, tileMap.height do
        if Map:getCellActor(x,y) then
          local a = Map:getCellActor(x,y)
          local draw_x,draw_y = Map:tiletoLoc(x,y)
          --attitude indicator
          local circle_x = draw_x+0.3*tileMap.tilewidth
          local circle_y = draw_y + tileMap.tileheight
          Map:unitIndicatorCircle(circle_x, circle_y, a)

          --reset color
          love.graphics.setColor(255,255,255)
          love.graphics.draw(loaded_tiles[a.image], draw_x, draw_y)
        end
      end
    end

    local draw_x, draw_y = Map:tiletoLoc(player.x, player.y)
    love.graphics.draw(loaded_tiles["player_tile"], draw_x, draw_y)
end

function draw_GUI()
    --mouse drawing needs to be outside of camera because reasons
    GUI:draw_mouse()
    GUI:draw_drawstats()
    GUI:draw_schedule()
end

function gamemode.draw()
  local dt = love.timer.getDelta()
  camera:draw(function(l, t, w, h)
    --reset color
    love.graphics.setColor(255,255,255)
    tileMap:update(dt)
    tileMap:setDrawRange(-l, -t, w, h)
    tileMap:draw()
    --tile border needs to draw under player tile
    GUI:draw_border_mousetile()
    --draw stuff that isn't in tilemap
    draw_tiles(l,t,w,h)
  end)
    
    --camera independent GUI
  draw_GUI()
end

function gamemode.update(dt)
  --get mouse coords
    mouse = {
   x = love.mouse.getX(), 
   y = love.mouse.getY(),
  }

  tile_x, tile_y = Mouse:getGridPosition()

  rounds()

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

function gamemode.mousepressed(x,y,b)
  print("Calling mousepressed",x,y,b)

  if b == 1 then
    player:movetoMouse(tile_x, tile_y, player.x, player.y)
  end
end

function schedule()
  visible_actors = {}
  print("[GAME] Clear visible actors")
  TurnManager:schedule()
  visible_actors = TurnManager:getVisibleActors()
end

function rounds()
  TurnManager:rounds()
  schedule_curr = TurnManager:getDebugString()
  if not schedule_curr then schedule_curr = "Something went wrong" end
end

--turn-basedness
function player_lock()
  player:actPlayer()
end

function game_lock()
  game_locked = true
  --clear log
  --visiblelogMessages = {}
end

function game_unlock()
  --if game_locked == false then return end
  game_locked = false

  TurnManager:unlocked()
end

function endTurn()
  game_unlock()
  print("[GAME] Ended our turn")
  print_to_log("[GAME] Ended our turn")
end

function removeDead()
  TurnManager:removeDead()
end

function setDijkstra(map)
  --print("[GAME] Set dijkstra")
  dijkstra = map
end