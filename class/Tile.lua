require 'T-Engine.class'

module("Tile", package.seeall, class.make)

_G.loaded_tiles = {}

function Tile:loadTiles()
    --global table
    _G.loaded_tiles= {
    player_tile = lg.newImage("gfx/tiles/player/racial_dolls/human_m.png"),
    kobold = lg.newImage("gfx/tiles/mobiles/kobold.png"),

    --objects
    studded = lg.newImage("gfx/tiles/object/armor_studded.png"),
    --light
    torch = lg.newImage("gfx/tiles/object/torch.png"),
    lantern = lg.newImage("gfx/tiles/object/lantern.png"),
}

    return loaded_tiles
end

return Tile