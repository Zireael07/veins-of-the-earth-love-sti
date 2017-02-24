require 'T-Engine.class'

module("Entity", package.seeall, class.make)

--Common functions
function Entity:importBase(t, base)
    --print("[ENTITY] Importing base:",base, "for", t.name)
    local temp = table.clone(base, true)
    table.mergeAppendArray(temp, t, true)
    t = temp
    t.base = nil
    return t
end

function Entity:newEntity(t, typ)
    --print("[ENTITY] Creating new entity, type:", typ)
    -- Do we inherit things ?
    if t.base then
        local base
        local b = t.base
        --print("[ENTITY] base is", b)
        if typ == "actor" then
            base = npc_types[b]
        elseif typ == "object" then
            base = object_types[b]
        end
        --print("[ENTITY] Creating new entity with a base")
        t = self:importBase(t, base) 
    end

    return t
end

return Entity
