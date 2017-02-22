require 'T-Engine.class'

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


return Ego