require 'T-Engine.class'

module("PlayerGUI", package.seeall, class.make)

function PlayerGUI:draw_mouse(x,y)
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255,255,255)
    love.graphics.print(mouse.x..", "..mouse.y, mouse.x+10, mouse.y)
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+20, mouse.y+30)
end

function PlayerGUI:draw_border_mousetile()
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.GOLD)
        --x,y is the top of the square I'm pointing mouse at
        local x,y = tileMap:convertTileToPixel(tile_x, tile_y)
        local bottomx, bottomy = tileMap:convertTileToPixel(tile_x+1, tile_y+1)
        --bottom of x-1, y is our left end
        local leftx, lefty = tileMap:convertTileToPixel(tile_x, tile_y+1)
        --top of x+1, y is our right end
        local rightx, righty = tileMap:convertTileToPixel(tile_x+1, tile_y)
        local vertices = { x,y, leftx, lefty, bottomx, bottomy, rightx, righty }
        love.graphics.polygon('line', vertices)
    end    
end

--debugging stuff
function PlayerGUI:draw_drawstats()
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255, 255, 102)
    local stats = love.graphics.getStats()
 
    local str = string.format("Estimated texture memory used: %.2f MB", stats.texturememory / 1024 / 1024)
    love.graphics.print(str, 700, 50)
    local drawcalls = string.format("Drawcalls: %d", stats.drawcalls)
    love.graphics.print(drawcalls, 700, 65)
end

function PlayerGUI:draw_schedule()
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(128, 255, 0)
    love.graphics.print(schedule_curr, 680, 30)
end

return PlayerGUI