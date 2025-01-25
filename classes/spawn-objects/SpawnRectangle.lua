local Class = require("libraries.hump-master.class")

-- Local Imports --


SpawnRectangle = Class()

function SpawnRectangle:init(pos_x, pos_y)
    self.x = pos_x
    self.y = pos_y
    self.width = 100
    self.height = 100
end

