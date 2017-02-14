require 'T-Engine.class'

module("Tile", package.seeall, class.make)

_G.loaded_tiles = {}

function Tile:loadTiles()
    --global table
    _G.loaded_tiles= {
    player_tile = lg.newImage("gfx/tiles/player/racial_dolls/human_m.png"),
}

    return loaded_tiles
end

return Tile