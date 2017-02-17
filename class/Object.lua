require 'T-Engine.class'

local Map = require 'class.Map'

module("Object", package.seeall, class.inherit(Entity))

function _M:init(t)
    --if t then print("We were given a table") end
    t = t or {}
    --default loc for testing
    self.x = 1
    self.y = 1
    self.display = t.display
    self.image = t.image
    self.name = t.name
    self.add_name = t.add_name
    self.slot = t.slot
    self.combat = t.combat
    self.wielder = t.wielder
    self.cost = 0
    self.desc = t.desc
    self.on_prepickup = t.on_prepickup
    --flags
    self.ranged = t.ranged or false
    --special
    self.ammo_type = t.ammo_type
    self.number_coins = t.number_coins or 0
    --[[if t.cost then
        --print_to_log("[OBJECT] setting value for "..t.name)
        self.cost = self:setValue((t.cost.platinum or 0), (t.cost.gold or 0), (t.cost.silver or 0), (t.cost.copper or 0))
    end]]
end

function _M:act()
  --nothing for now
end

--equivalent to Actor:move()
function _M:place(x,y)
    x = math.floor(x)
    y = math.floor(y)
  
  --don't go out of bounds
    if x < 0 then x = 0 end
    --if x >= Map:getWidth() then x = Map:getWidth() - 1 end
    if y < 0 then y = 0 end
    --if y >= Map:getHeight() then y = Map:getHeight() - 1 end

    --don't place in walls
    if Map:getCellTerrain(x,y) ~= 210 then
        found_x, found_y = Map:findFreeGrid(x, y, 10)
        if found_x and found_y then
            print("Object: updating map cell: ", found_x, found_y)
            Map:setCellObject(found_x, found_y, self) 
            self.x, self.y = found_x, found_y
        end
    else
        print("Object: updating map cell: ", x, y)
        Map:setCellObject(x, y, self)
        --fix wrong coords
        self.x, self.y = x, y
    end
end

function _M:getObjectIndex(x,y)
    local res 
    local objects = Map:getCellObjects(x,y)
    for i,e in ipairs(objects) do
        if e == self then res = i 
        else res = nil end
    end
    print("Object:getting index for object ", self.name)
    return res
end

return Object