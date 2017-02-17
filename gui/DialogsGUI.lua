require 'T-Engine.class'

local LogDialog = require 'gui.dialogs.LogDialog'

module("DialogsGUI", package.seeall, class.make)

--log
function DialogsGUI:draw_log_dialog()
    LogDialog:draw()
end

return DialogsGUI