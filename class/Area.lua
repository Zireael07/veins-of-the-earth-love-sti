require 'T-Engine.class'

local Pathfinding = require 'class.interface.Pathfinding'

module("Area", package.seeall, class.make)

function Area:setup()
    Area:getAreaMap()
    if path_map then print_to_log("Created a path_map successfully!")  end
end

function Area:getAreaMap()
  path_map = Pathfinding:create()
  return path_map
end

return Area