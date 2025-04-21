-- Global Imports --
local Class = require("libraries.hump-master.class")
local camera




baseWindow = Class()

function baseWindow:init()
    self.window_width = 640
    self.window_height = 360

    self.scale_factor = 1

    self.target_width = self.window_width * self.scale_factor
    self.target_height = self.window_height * self.scale_factor

    

    

    love.window.setMode(self.target_width, self.target_height, {
        resizable=false, 
        fullscreen = false,
        vsync=0, 
        minwidth=self.window_width, 
        minheight=self.window_height})

    love.graphics.setDefaultFilter('nearest', 'nearest') -- scale everything with nearest neighbor


    
end

