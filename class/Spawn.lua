require 'T-Engine.class'

require 'class.Player'

module("Spawn", package.seeall, class.make)

function Spawn:createPlayer(x,y)
    if not x or not y then print("No location parameters") return end
    --if x > Map:getHeight()-1 then print("X out of bounds") end
    --if y > Map:getWidth()-1 then print("Y out of bounds") end

    t = {}

    player_temp = Player.new(t)

    player_temp:move(x, y)

    print("[Spawn] Created player at ", x,y)
    return player_temp
end

return Spawn