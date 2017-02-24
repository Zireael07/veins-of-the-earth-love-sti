require 'T-Engine.class'

--bar
local Hotbar = require 'gui.Hotbar'

--child class to govern all the dialogs
local DialogsGUI = require "gui.DialogsGUI"

module("PlayerGUI", package.seeall, class.inherit(DialogsGUI)) --class.make)

function PlayerGUI:loadGUI()
    love.graphics.setFont(goldbox_font)
    Hotbar:load()
end

function PlayerGUI:draw_hotbar()
    Hotbar:draw()
end

function PlayerGUI:hotbar_mouse()
    Hotbar:mouse()
end

function PlayerGUI:hotbar_mouse_pressed(x,y,b)
    Hotbar:mouse_pressed(x,y,b)
end

function PlayerGUI:draw_GUI(player)
    --reset color
    love.graphics.setColor(255, 255, 255)
    
    local hp = player.hitpoints
    local wounds = player.wounds

    love.graphics.draw(loaded_tiles["stone_bg"], 0,0, 0, 0.25, 1)
    love.graphics.draw(loaded_tiles["stone_bg"], 0, 320, 0, 0.25, 1)

    love.graphics.setFont(goldbox_large_font)

    love.graphics.setColor(255, 51, 51)
    love.graphics.print("Endure: "..player.hitpoints, 10, 10)
    love.graphics.print("Health: "..player.wounds, 10, 25)

    --draw body
    --[[love.graphics.setColor(colors.GREEN)
    if player.body_parts then
        local x = 25
        local y = 50
        love.graphics.draw(loaded_tiles["body_ui"], x, y)
    end]]
end


function PlayerGUI:draw_mouse(x,y)
    love.graphics.setFont(sherwood_font)
    love.graphics.setColor(255,255,255)
    --love.graphics.print(mouse.x..", "..mouse.y, mouse.x+10, mouse.y)
    love.graphics.print((tile_x or "N/A")..", "..(tile_y or "N/A"), mouse.x+10, mouse.y)
    if tile_x and tile_y then
        local dist = utils:distance(player.x, player.y, tile_x, tile_y)
        local feet = dist*5
        love.graphics.print(dist.." "..feet.." ft", mouse.x+50, mouse.y)
    end 
end

function PlayerGUI:draw_border_mousetile()
    --reset color
    love.graphics.setColor(255, 255, 255)
    if tile_x and tile_y then
        love.graphics.setColor(colors.GOLD)
        local x,y, leftx, lefty, bottomx, bottomy, rightx, righty = Display:tilePolyPoints(tile_x,tile_y)
        local vertices = { x,y, leftx, lefty, bottomx, bottomy, rightx, righty }
        love.graphics.polygon('line', vertices)
    end    
end

function PlayerGUI:draw_turns_order()
    --reset color
    love.graphics.setColor(255, 255, 255)

    for y=1, tileMap.width do--Map:getWidth()-1 do
        for x=1, tileMap.height do--Map:getHeight()-1 do 
            if Map:getCellActor(x,y) then --Map:isTileSeen(x,y) and Map:getCellActor(x,y) then 
                a = Map:getCellActor(x, y)
                draw_x = 135
                draw_y = 15

                for i=1, #visible_actors do
                    local item = visible_actors[i]
                    --reset color
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.draw(loaded_tiles[item.image], draw_x, draw_y)
                    local col = item:getReactionColor(item:indicateReaction())
                    love.graphics.setColor(col)
                    love.graphics.rectangle("line", draw_x, draw_y, 32, 32)
                    draw_x = draw_x + 40
                end
            end 
        end
    end
    love.graphics.setColor(colors.SLATE)
    love.graphics.rectangle("line", 130, 10, draw_x-130, 40)   
end

function PlayerGUI:draw_log_messages()
    love.graphics.setFont(sherwood_font)
    -- draw log messages
    local height = love.graphics.getHeight()
    local hotbar = 70

    local a = 255
    local font_h = 15
    local i2 = #logMessages
    local i1 = i2-5
    i1 = math.max(1, i1+1)

    if #logMessages > 0 then
        --for i, message in ipairs(visiblelogMessages) do
        for i = i1, i2 do
            local off = -(i2 - i)
            local myColor = r,g,b,a
            love.graphics.setColor(a,a,a,a)
            local y = height-hotbar-(font_h*2)+(font_h*off)
            love.graphics.print(logMessages[i]['message'], 120, y)
            --love.graphics.print(message['message'], 120, 
            --height-hotbar-(font_h*5)+(font_h*i))--15*i)
        end
    end
end

--optional stuff
function PlayerGUI:tiletoactorlabel(x,y)
    local pixel_x, pixel_y = Display:tiletoLoc(x,y)
    pixel_x, pixel_y = pixel_x, math.floor(pixel_y-15) --0.2*tileMap.tileheight

    return pixel_x, pixel_y
end

function PlayerGUI:tiletoobjectlabel(x,y)
    local pixel_x, pixel_y = Display:tiletoLoc(x,y)
    pixel_x, pixel_y = math.floor(pixel_x+20), pixel_y--+0.2*tileMap.tileheight

    return pixel_x, pixel_y
end


function PlayerGUI:draw_labels()
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, tileMap.width do --Map:getWidth()-1 do
        for x=1, tileMap.height do --Map:getHeight()-1 do
            if Map:isTileSeen(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                love.graphics.setColor(255, 255, 102)
                love.graphics.print(a.name, PlayerGUI:tiletoactorlabel(x,y))
            end
            if Map:isTileSeen(x,y) and Map:getCellObjects(x,y) then
                o = Map:getCellObject(x,y, 1)
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(o.name, PlayerGUI:tiletoobjectlabel(x,y))
            end
        end
    end
end

function PlayerGUI:tiletosplash(x,y)
    local pixel_x, pixel_y = Display:tiletoLoc(x,y)
    pixel_x, pixel_y = pixel_x, pixel_y+0.2*tileMap.tileheight

    return pixel_x, pixel_y
end

function PlayerGUI:draw_damage_splashes()
    --reset color
    love.graphics.setColor(255, 255, 255)
    for y=1, tileMap.width do --Map:getWidth()-1 do
        for x=1, tileMap.height do --Map:getHeight()-1 do
            if Map:isTileVisible(x,y) and Map:getCellActor(x,y) then
                a = Map:getCellActor(x, y)
                if a.damage_taken then
                    local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y)
                    love.graphics.setColor(colors.RED)
                    love.graphics.draw(loaded_tiles["damage_tile"], pixel_x, pixel_y)
                    --reset color
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.print(a.damage_taken, pixel_x+0.2*tileMap.tilewidth, pixel_y)
                elseif a.no_damage then
                    local pixel_x, pixel_y = PlayerGUI:tiletosplash(x,y)
                    love.graphics.setColor(255,255, 255)
                    love.graphics.draw(loaded_tiles["shield_tile"], pixel_x, pixel_y)
                end
            end
        end
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