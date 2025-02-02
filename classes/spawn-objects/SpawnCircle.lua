local Class = require("libraries.hump-master.class")

-- Local Imports --


SpawnCircle = Class()

function SpawnCircle:init(pos_x, pos_y, r, g, b)
    self.x = pos_x
    self.y = pos_y
    self.radius = 10
    self.r = r
    self.g = g
    self. b = b
end

