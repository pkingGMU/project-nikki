-- Global Imports --
local Class = require("libraries.hump-master.class")

baseWindow = Class()

function baseWindow:init()
    self.windowHeight = 360
    self.windowWidth = 640

    love.window.setMode(self.windowWidth, self.windowHeight, {
        resizable=false, 
        vsync=0, 
        minwidth=0, 
        minheight=0})
end

