local Tile = require "class.Tile"

--colors
local colors = love.filesystem.load("colors.lua")
colors()

--load fonts
print_to_log('Loading fonts')
sherwood_large = love.graphics.newFont("fonts/sherwood.ttf", 20)
sherwood_font = love.graphics.newFont("fonts/sherwood.ttf", 14)
goldbox_font = love.graphics.newFont("fonts/Gold_Box.ttf", 12)
goldbox_large_font = love.graphics.newFont("fonts/Gold_Box.ttf", 16)

--load tiles
print_to_log("Loading tiles..")
Tile:loadTiles()