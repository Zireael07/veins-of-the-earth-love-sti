--Veins of the Earth
--Zireael 2013-2015
properties_def["masterwork"] = {
    type = "armor",
    name = "masterwork ", prefix = true, --addon=true,
    ego_subtype = "bonus",
    level_range = {1, nil},
    --fake_ego = true,
    rarity = 2,
    cost = {
        silver = 100,
    },
    wielder = {
    --  combat_armor_ac = 1,
        armor_penalty = -1,
    }
}

properties_def["+1"] = {
    type = "armor",
    name = " +1", suffix = true, --addon=true,
    ego_subtype = "bonus",
    level_range = {4, nil},
    rarity = 5,
--  cost = 2000,
    cost = {
        platinum = 200,
    },
    school = "abjuration",
    wielder = {
        combat_magic_armor = 1,
        armor_penalty = -1,
    },
    --resolvers.creation_cost(),
}

properties_def["+2"] = {
    type = "armor",
    name = " +2", suffix = true, --addon=true,
    ego_subtype = "bonus",
    level_range = {8, nil},
    rarity = 10,
--  cost = 4000,
    cost = {
        platinum = 400,
    },
    school = "abjuration",
    wielder = {
        combat_magic_armor = 2,
        armor_penalty = -1,
    },
    --resolvers.creation_cost(),
}

properties_def["+3"] = {
    type = "armor",
    name = " +3", suffix = true, --addon=true,
    ego_subtype = "bonus",
    level_range = {12, nil},
    rarity = 18,
--  cost = 16000,
    cost = {
        platinum = 1600,
    },
    school = "abjuration",
    wielder = {
        combat_magic_armor = 3,
        armor_penalty = -1,
    },
    --resolvers.creation_cost(),
}
