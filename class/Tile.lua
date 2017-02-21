require 'T-Engine.class'

module("Tile", package.seeall, class.make)

_G.loaded_tiles = {}

function Tile:loadTiles()
    --global table
    _G.loaded_tiles= {
    player_tile = lg.newImage("gfx/tiles/player/racial_dolls/human_m.png"),
    kobold = lg.newImage("gfx/tiles/mobiles/kobold.png"),
    human = lg.newImage("gfx/tiles/mobiles/human.png"),

    --objects
    --weapons
    longsword = lg.newImage("gfx/tiles/object/longsword.png"),
    dagger = lg.newImage("gfx/tiles/object/dagger.png"),
    --armor
    leather = lg.newImage("gfx/tiles/object/armor_leather.png"),
    studded = lg.newImage("gfx/tiles/object/armor_studded.png"),
    --light
    torch = lg.newImage("gfx/tiles/object/torch.png"),
    lantern = lg.newImage("gfx/tiles/object/lantern.png"),

    --coins
    copper_coins = lg.newImage("gfx/tiles/object/copper_coins.png"),
    silver_coins = lg.newImage("gfx/tiles/object/silver_coins.png"),
    gold_coins = lg.newImage("gfx/tiles/object/gold_coins.png"),
    platinum_coins = lg.newImage("gfx/tiles/object/platinum_coins.png"),

    --ui
    stone_bg = lg.newImage("gfx/stone_background.png"),
    --effect
    damage_tile = lg.newImage("gfx/splash_gray.png"),
    shield_tile = lg.newImage("gfx/splash_shield.png"),

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

    --portraits
    doll = lg.newImage("gfx/portraits/base.png"),
    doll_drow = lg.newImage("gfx/portraits/base_drow.png"),
    doll_dwarf = lg.newImage("gfx/portraits/ozy/dwarf_base.png"),
    doll_dwarf_alt = lg.newImage("gfx/portraits/ozy/dwarf_base2.png"),

    drow_hair_1 = lg.newImage("gfx/portraits/ozy/drow_hair1.png"),
    drow_hair_2 = lg.newImage("gfx/portraits/ozy/drow_hair2.png"),
    drow_hair_3 = lg.newImage("gfx/portraits/ozy/drow_hair3.png"),
    drow_hair_4 = lg.newImage("gfx/portraits/ozy/drow_hair4.png"),

    hair_black = lg.newImage("gfx/portraits/ozy/hair_black.png"),
    hair_black2 = lg.newImage("gfx/portraits/ozy/hair_black2.png"),
    hair_brown = lg.newImage("gfx/portraits/ozy/hair_brown.png"),
    hair_gray = lg.newImage("gfx/portraits/ozy/hair_gray.png"),
    hair_red = lg.newImage("gfx/portraits/ozy/hair_red.png"),
    hair_white = lg.newImage("gfx/portraits/ozy/hair_white.png"),

    eyebrows_drow = lg.newImage("gfx/portraits/eyebrows_drow.png"),
    eyebrows_black = lg.newImage("gfx/portraits/ozy/eyebrows_black.png"),
    eyebrows_black2 = lg.newImage("gfx/portraits/ozy/eyebrows_black2.png"),
    eyebrows_brown = lg.newImage("gfx/portraits/ozy/eyebrows_brown.png"),
    eyebrows_gray = lg.newImage("gfx/portraits/ozy/eyebrows_gray.png"),
    eyebrows_red = lg.newImage("gfx/portraits/ozy/eyebrows_red.png"),
    eyebrows_white = lg.newImage("gfx/portraits/ozy/eyebrows_white.png"),

    eyes_dwarf_1 = lg.newImage("gfx/portraits/ozy/eyes_dwarf1.png"),
    eyes_dwarf_2 = lg.newImage("gfx/portraits/ozy/eyes_dwarf2.png"),
    eyes_dwarf_3 = lg.newImage("gfx/portraits/ozy/eyes_dwarf3.png"),
    eyes_dwarf_4 = lg.newImage("gfx/portraits/ozy/eyes_dwarf4.png"),

    eyes_amber = lg.newImage("gfx/portraits/eyes_amber.png"),
    eyes_seablue = lg.newImage("gfx/portraits/eyes_seablue.png"),
    eyes_seagreen = lg.newImage("gfx/portraits/eyes_seagreen.png"),
    eyes_yellow = lg.newImage("gfx/portraits/eyes_yellow.png"),
    eyes_green = lg.newImage("gfx/portraits/eyes_green.png"),
    eyes_blue = lg.newImage("gfx/portraits/eyes_blue.png"),
    eyes_gray = lg.newImage("gfx/portraits/eyes_gray.png"),
    eyes_black = lg.newImage("gfx/portraits/eyes_black.png"),
    eyes_brown = lg.newImage("gfx/portraits/eyes_brown.png"),
    eyes_red = lg.newImage("gfx/portraits/eyes_red.png"),
    eyes_pink = lg.newImage("gfx/portraits/eyes_pink.png"),

    dwarf_nose = lg.newImage("gfx/portraits/ozy/dwarf_nose.png"),

    drow_mouth = lg.newImage("gfx/portraits/ozy/drow_mouth.png"),
    drow_mouth2 = lg.newImage("gfx/portraits/ozy/drow_mouth2.png"),
    dwarf_mouth = lg.newImage("gfx/portraits/ozy/dwarf_mouth.png"),
    dwarf_mouth2 = lg.newImage("gfx/portraits/ozy/dwarf_mouth2.png"),
    mouth = lg.newImage("gfx/portraits/mouth.png"),
    mouth2 = lg.newImage("gfx/portraits/mouth2.png"),

    dwarf_beard_black = lg.newImage("gfx/portraits/ozy/dwarf_beard_black.png"),
    dwarf_beard_brown = lg.newImage("gfx/portraits/ozy/dwarf_beard_brown.png"),
    dwarf_beard_gray = lg.newImage("gfx/portraits/ozy/dwarf_beard_gray.png"),
    dwarf_beard_white = lg.newImage("gfx/portraits/ozy/dwarf_beard_white.png"),
}

    return loaded_tiles
end

return Tile