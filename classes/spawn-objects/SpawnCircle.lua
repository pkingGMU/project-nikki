local Class = require("libraries.hump-master.class")

-- Local Imports --


SpawnCircle = Class()

function SpawnCircle:init(pos_x, pos_y, r, g, b, lifespanTimer)
    self.x = pos_x
    self.y = pos_y
    self.radius = 10
    self.r = r
    self.g = g
    self. b = b
    self.lifespanTimer = lifespanTimer
    self.velocityX = 0
    self.velocityY = 0
    self.lifespanTimer:start()
    

end


