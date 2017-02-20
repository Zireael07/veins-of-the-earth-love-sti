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

    --ui
    stone_bg = lg.newImage("gfx/stone_background.png"),

    --hotbar icons
    hotbar_attack = lg.newImage("gfx/hotbar/attack.png"),
    hotbar_skills = lg.newImage("gfx/hotbar/skills.png"),

    --more UI
    ui_left_arrow = lg.newImage("gfx/kenney_ui/arrowBeige_left.png"),
    ui_right_arrow = lg.newImage("gfx/kenney_ui/arrowBeige_right.png"),
    ui_platinum_coin = lg.newImage("gfx/kenney_ui/iconCircle_grey.png"),
    ui_gold_coin = lg.newImage("gfx/kenney_ui/iconCircle_beige.png"),
    ui_silver_coin = lg.newImage("gfx/kenney_ui/iconCircle_blue.png"),
    ui_bronze_coin = lg.newImage("gfx/kenney_ui/iconCircle_brown.png"),

    --inventory
    ammo_inv = lg.newImage("gfx/inventory/ammo_inv.png"),
    amulet_inv = lg.newImage("gfx/inventory/amulet_inv.png"),
    armor_inv = lg.newImage("gfx/inventory/armor_inv.png"),
    arms_inv = lg.newImage("gfx/inventory/arms_inv.png"),
    belt_inv = lg.newImage("gfx/inventory/belt_inv.png"),
    boots_inv = lg.newImage("gfx/inventory/boots_inv.png"),
    cloak_inv = lg.newImage("gfx/inventory/cloak_inv.png"),
    gloves_inv = lg.newImage("gfx/inventory/gloves_inv.png"),
    head_inv = lg.newImage("gfx/inventory/head_inv.png"),
    light_inv = lg.newImage("gfx/inventory/light_inv.png"),
    mainhand_inv = lg.newImage("gfx/inventory/mainhand_inv.png"),
    offhand_inv = lg.newImage("gfx/inventory/offhand_inv.png"),
    ring_inv = lg.newImage("gfx/inventory/ring_inv.png"),
    shoulder_inv = lg.newImage("gfx/inventory/shoulder_inv.png"),
    tool_inv = lg.newImage("gfx/inventory/tool_inv.png"),
}

    return loaded_tiles
end

return Tile