-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local Imports --

button = Class ()

function button:init(pos_x, pos_y, r, g, b)
    self.x = pos_x
    self.y = pos_y
    self.width = 100
    self.height = 100
    self.r = r
    self.g = g
    self. b = b
end


