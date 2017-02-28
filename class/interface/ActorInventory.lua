--Based on T-Engine
-- Copyright (C) 2009 - 2016 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "T-Engine.class"

module("ActorInventory", package.seeall, class.make)

ActorInventory.inven_def = {}

function ActorInventory:defineInventory(short_name, name, is_worn, desc, show_equip, infos)
    assert(name, "no inventory slot name")
    assert(short_name, "no inventory slot short_name")
    assert(desc, "no inventory slot desc")
    table.insert(self.inven_def, {
        name = name,
        short_name = short_name,
        description = desc,
        is_worn = is_worn,
        is_shown_equip = show_equip,
        infos = infos,
        stack_limit = infos and infos.stack_limit,
    })
    self.inven_def[#self.inven_def].id = #self.inven_def
    self.inven_def[short_name] = self.inven_def[#self.inven_def]
    self["INVEN_"..short_name:upper()] = #self.inven_def
    print_to_log("[INVENTORY] define slot", #self.inven_def, self.inven_def[#self.inven_def].name)
end

-- Auto define the inventory
ActorInventory:defineInventory("INVEN", "In inventory", false, "") --INVEN_INVEN assumed to have no stacking limit

--- Initialises inventories with default values if needed
function ActorInventory:init(t)
    self.inven = t.inven or {}
    self.body = t.body
    self:initBody()
end

--- generate inventories according to the body definition table
--  @param self.body = {SLOT_ID = max, ...}
--  @param max = number of slots if number or table of properties (max = , stack_limit = , ..) merged into definition
function ActorInventory:initBody()
    if self.body then
        local def
        for inven, max in pairs(self.body) do
            def = self.inven_def[self["INVEN_"..inven]]
            assert(def, "inventory slot undefined.. "..inven)
            self.inven[self["INVEN_"..inven]] = {worn=def.is_worn, id=self["INVEN_"..inven], name=inven, stack_limit = def.stack_limit}
            if type(max) == "table" then
                table.merge(self.inven[self["INVEN_"..inven]], max, true)
            else
                self.inven[self["INVEN_"..inven]].max = max
            end
        end
        self.body = nil
    end
end

--- Returns the content of an inventory as a table
function ActorInventory:getInven(id)
    if type(id) == "number" then
        return self.inven[id]
    elseif type(id) == "string" then
        return self.inven[self["INVEN_"..id]]
    else
        return id
    end
end

--- Tells if an inventory still has room left
function ActorInventory:canAddToInven(id)
    if type(id) == "number" then
        return #self.inven[id] < self.inven[id].max
    elseif type(id) == "string" then
        return #self.inven[self["INVEN_"..id]] < self.inven[self["INVEN_"..id]].max
    else
        return id
    end
end

--- Get stacking limit for an inventory
--  @param id inventory id or table (stack_limit in inventory table takes precedence)
function ActorInventory:invenStackLimit(id)
    local inven = self:getInven(id)
    return inven.stack_limit or self.inven_def[inven.id].stack_limit or math.huge
end

function ActorInventory:addObject(inven_id, o)
    local inven = self:getInven(inven_id)

    if #inven >= inven.max then
    return false end

    table.insert(inven, #inven +1, o)

    --callbacks? onWear and onAddObject?
    --print("Added object ", inven)
    return true
end 

--item is the index we want to remove from
function ActorInventory:removeObject(inven_id, item)
    local inven = self:getInven(inven_id)

    local o = inven[item]

    table.remove(inven, item)

    -- Do whatever is needed when taking off this object
    if inven.worn and o then
        self:onTakeoff(o, self.inven_def[inven.id].short_name)
    end
end

function ActorInventory:pickupFloor(i)
    local inven = self:getInven(self.INVEN_INVEN)
    if not inven then return end

    if Map:getCellObject(self.x, self.y, i) then
        o = Map:getCellObject(self.x, self.y, i)
        if o then
            local prepickup = o:on_prepickup(self, i)
            if not prepickup then
                local ok = self:addObject(self.INVEN_INVEN, o)
                if ok then
                    logMessage(colors.WHITE, self.name.." picked up "..o.name)
                    Map:setCellObjectbyIndex(self.x, self.y, nil, i)
                    endTurn()
                else
                    logMessage(colors.WHITE, self.name.." has no room for "..o.name)
                end
            end
        end
    else
        logMessage(colors.WHITE, "Nothing to pick up here")
    end    

end

function ActorInventory:canWearObject(o, try_slot, no_log)
    if not no_log then
        print_to_log("Checking if we can wear object ", o.name, try_slot)
    end
    -- check the slot
    if try_slot and try_slot ~= o.slot then
        return nil, "wrong equipment slot"
    end

    return true
end

function ActorInventory:wearObject(o, inven_id, no_log)
--    print("Wearing: ", o, inven_id)
    local inven = self:getInven(inven_id)
    --catch errors if any
    if not inven then return end

    local ok, err = self:canWearObject(o, inven.name, no_log)

    if not ok then
        print_to_log("Can not wear", o.name)
        return false
    end

    local added = self:addObject(inven_id, o)
    if added then
        if not no_log then
            print_to_log("Wearing "..o.name.." in slot "..inven.name)
        end
        self:onWear(o, self.inven_def[inven.id].short_name)
    end
    return true
end

function ActorInventory:onWear(o, inven_id)
    -- Apply wielder properties
    o.wielded = {}

    if o.wielder then
        for k, e in pairs(o.wielder) do
            o.wielded[k] = self:addTemporaryValue(k, e)
            --force recompute FOV
            if k == "lite" and self.player then
                --force update FOV
                self:update_draw_visibility_new()
            end

        end
    end
end


function ActorInventory:doWear(inven, item, o, dst)
    if self:wearObject(o, dst) then
      self:removeObject(inven, item)
    end
    
end

function ActorInventory:onTakeoff(o, inven_id)
    if o.wielded then
        for k, id in pairs(o.wielded) do
            if type(id) == "table" then
                self:removeTemporaryValue(id[1], id[2])
            else
                self:removeTemporaryValue(k, id)
            end
        end
    end
    o.wielded = nil
end

function ActorInventory:takeoffObject(inven_id, item)
    inven = self:getInven(inven_id)
    if not inven then return false end

    local o = inven[item]

    self:removeObject(inven, item)
end

function ActorInventory:doTakeoff(inven, item, o)
    if not self:canAddToInven(self.INVEN_INVEN) then return end

    self:takeoffObject(inven, item)
    self:addObject(self.INVEN_INVEN, o)
end


function ActorInventory:dropFloor(inven, item)
    --print("Dropping", inven, item)
    local inv = self:getInven(inven)
    --print("Inventory is", inv)
    local o = inv[item]
    --print("Object is", o)
    if not o then
        logMessage(colors.WHITE, "There is nothing to drop.")
        return
    end
    --if o:check("on_drop", self) then return false end

    self:removeObject(inven, item)

    Map:setCellObject(self.x, self.y, o)
    logMessage(colors.WHITE, "Dropping "..o:getName())
end

return ActorInventory