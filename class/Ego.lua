require 'T-Engine.class'

local Object = require "class.Object"

module("Ego", package.seeall, class.make)

function Ego:getEgosForType(type)
    local list = {}
    for k,v in pairs(properties_def) do
        if v.type == type then
            list[#list+1] = {name=v.name, data=v}
        end
    end
    table.sort(list, function(a,b)
        return a.name < b.name
    end)

    return list
end

function Ego:applyEgo(e, ego)
    print("Applying ego "..ego.name.." to item "..e.name)
    local e_original = table.clone(e, true)
    local old_name = e.name

     --handle cost
    ego.real_cost = Object:setValue((ego.cost.platinum or 0), (ego.cost.gold or 0), (ego.cost.silver or 0), (ego.cost.copper or 0))

    --remember to add the numbers
    table.mergeAppendArray(e, ego, true, false, false, true)

    --handle naming
    if ego.prefix then
        e.name = e.name..old_name
    else
        e.name = old_name..e.name
    end

    --mark as egoed
    if not ego.fake_ego then
        e.egoed = true
    end
end

return Ego