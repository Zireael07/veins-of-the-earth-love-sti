--require two libraries that are absolutely crucial
sti = require("libraries/sti")
ROT=require 'libraries/rotLove/rotLove'
--profiling
--ProFi = require 'libraries.ProFi'

-- LÖVE Shortcuts
lg  = love.graphics

--print to console in realtime
io.stdout:setvbuf('no')

  require "helpers/gamefunctions"
  require "helpers/utils"

--load
function load_stuff()
    --load stuff that is necessary for all the classes/modules
    load = love.filesystem.load("load.lua")
    local loaded = load()
    
    --randomness
    rng = ROT.RNG.Twister:new()
    rng:randomseed()

    --require content tables
    require 'data/npcs'
    require 'data/objects'
    --require 'data/areas'

    --show menu screen
    loadGamemode("menu")
end

--Zerobrane debugging
function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() 
    --prevent total slowdown
    require("mobdebug").off()
    --use require("mobdebug").on and require("mobdebug").off where necessary
  end

  sherwood_large = love.graphics.newFont("fonts/sherwood.ttf", 20)
  --set default font (large because of main menu)
  love.graphics.setFont(sherwood_large)
  loadGamemode("menu")
  
  --[[ProFi:start()
  ProFi:stop()
  local success = ProFi:writeReport('MyProfilingReport.txt')  --( string.format( '../profiling/startup_%d.txt', os.time( os.date( '*t' ))));
]]


end


--Core functions
function love.draw()
    if not (gamemode and gamemode.draw and not gamemode.draw()) then
        love.graphics.print("Debug", 400, 300)
    end
end

function love.keypressed(key, scancode)
    print("Pressed key: ".. key, scancode)
    --if gamemode and gamemode.keypressed and not gamemode.keypressed(k) then return end
    if gamemode and gamemode.keypressed then gamemode.keypressed(key, scancode) end
    --keys that are always active
  local alt = (love.keyboard.isScancodeDown("lalt") or love.keyboard.isScancodeDown("ralt"))
    if scancode == "f4" and alt then love.event.push("q") end
end

function love.update(dt)
    if gamemode then
      if gamemode.update then 
        if gamemode.update(dt) then gamemode.update(dt) end
      end
    else return end
end

-- called when a player clicks the mouse
function love.mousepressed(x, y, b)
    if b == 3 then love.keypressed("escape") return end
  --  if gamemode and gamemode.mousepressed and not gamemode.mousepressed(cursor.x, cursor.y, b) then return end
    if gamemode and gamemode.mousepressed then gamemode.mousepressed(x,y,b) end
    if gamemode and gamemode.postmousepressed then gamemode.postmousepressed(cursor.x, cursor.y, b) end
end

--called when the window is focused
function love.focus(f)
    if f then
        --print("Window is focused.")
    else
        --print("Window is not focused.")
    end
    if gamemode and gamemode.focus then gamemode.focus(f) end
end

function love.textinput(t)
    if gamemode and gamemode.textinput then gamemode.textinput(t) end
end