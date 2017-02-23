require 'T-Engine.class'

local Object = require "class.Object"

module("Ego", package.seeall, class.make)

function Ego:getEgosForType(type)
    local list = {}
    for k,v in pairs(properties_def) do
        if v.type == type then
            list[#list+1] = {name=v.name, ego_subtype=v.ego_subtype, data=v}
        end
    end
    table.sort(list, function(a,b)
        return a.name < b.name
    end)
    return list
end

function Ego:hasEgoSubtype(e, subtype)
    if not e.ego_list then print("item doesn't have a list of egos yet") return false end
    local egos = e.ego_list
    if #egos > 0 then
        for i,v in ipairs(egos) do
            local check = egos[i][1].ego_subtype
            print("Checking against: "..check)
            if check == subtype then 
                print("We have an ego of subtype, "..subtype) 
                return true
            else 
                print("We do NOT have an ego of subtype, "..subtype) 
                return false 
            end
        end
    end
end

function Ego:canApplyEgo(e, ego)
    local ret
    if ego.ego_subtype == "material" then
        if Ego:hasEgoSubtype(e, "material") then ret = false
        else ret = true end
    elseif ego.ego_subtype == "bonus" then
        if Ego:hasEgoSubtype(e, "bonus") then ret = false
        else ret = true end
    end
    --[[if ret == true then
      print("Can apply ego returns true for "..ego.name.." item "..e.name)
    else
      print("Can apply ego returns FALSE for "..ego.name.." item "..e.name)
    end]]
  
    return ret
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

    --make a list of egos we have
    e.ego_list = e.ego_list or {}
    e.ego_list[#e.ego_list + 1] = {ego}
end

return Ego