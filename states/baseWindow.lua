-- Global Imports --
local Class = require("hump.class")

baseWindow = Class()

function baseWindow:init()
    self.windowHeight = 600
    self.windowWidth = 800

    love.window.setMode(self.windowWidth, self.windowHeight, {
        resizable=false, 
        vsync=0, 
        minwidth=0, 
        minheight=0})
end

