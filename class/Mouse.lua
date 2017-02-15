require 'T-Engine.class'

module("Mouse", package.seeall, class.make)

function Mouse:init(camera)
    cam = camera
end

function Mouse:getWorldPosition()
    return cam:toWorld(love.mouse.getPosition())
end

function Mouse:getGridPosition()
    local mx, my = Mouse:getWorldPosition()
    local x, y = tileMap:convertPixelToTile(mx, my)
    --round down
    x = math.floor(x)
    y = math.floor(y)
    return x,y
end

return Mouse