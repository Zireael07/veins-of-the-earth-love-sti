properties_def["mithril"] = {
    type = "armor",
    name = "mithril ", prefix = true,
    keywords = {mithril=true},
    level_range = {4, nil},
    rarity = 20, --5% chance
    cost = {
        platinum = 100,
    },
    wielder = {
        spell_fail = -10,
        max_dex_bonus = 2,
        armor_penalty = -3,
    },
    --resolvers.creation_cost(),
    --resolvers.mithril_lighten()
}

properties_def["adamantine"] = {
    type = "armor",
    name = "adamantine ", prefix = true,
    keywords = {adamantine=true},
    level_range = {4, nil},
    rarity = 20, --5% chance
    cost = {
        platinum = 100,
    },
    wielder = {
        combat_dr = 1,
        armor_penalty = -1,
    },
    --resolvers.creation_cost(),
}