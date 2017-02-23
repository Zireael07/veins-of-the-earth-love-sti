require 'T-Engine.class'

local treasure = require "data/treasure_lists"

module("Treasure", package.seeall, class.make)

function Treasure:getCoins(lvl)
    if not treasure then print("No treasure list!") return end
    local table = treasure.coins[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated coins: ", res)
            return res 
        end
    end

end

function Treasure:getGoods(lvl)
    if not treasure then print("No treasure list!") return end
    local table = treasure.goods[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated goods: ", res)
            return res 
        end
    end
end

function Treasure:getItems(lvl)
    if not treasure then print("No treasure list!") return end
    local table = treasure.items[lvl]
    local roll = rng:random(1, 100)

    for i, entry in ipairs(table) do
        if roll > entry[1] and roll < entry[2] then
            local res = entry[3]
            print_to_log("[TREASURE] Roll: ", roll, "generated items: ", res)
            return res 
        end
    end
end

function Treasure:getTreasure(lvl, val)
    local coins = Treasure:getCoins(lvl)
    local goods = Treasure:getGoods(lvl)
    local items = Treasure:getItems(lvl)
    return coins, goods, items
end

function Treasure:selectTreasure(lvl)
    print("[TREASURE] Spawn treasure")

    local coinage_to_item = {
        ["cp"] = "copper coins",
        ["sp"] = "silver coins",
        ["gp"] = "gold coins",
        ["pp"] = "platinum coins",
    }
    local coins, goods, items = Treasure:getTreasure(lvl)

    if coins then
        local split = coins:split(' ')
        local coin
        if split[4] then
         coin = split[4] 
         --print("[TREASURE] Coinage is ", coin) 
        end
        --print("ID is ", coinage_to_item[coin])

        return coinage_to_item[coin]
    end
end

return Treasure