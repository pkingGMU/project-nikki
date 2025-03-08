local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Entity = Class{__includes = Object}

function Entity:init(xvel, yvel, speed, friction, jump_vel, can_jump)
    Object.init(self)

    self.xvel = xvel or 0
    self.yvel = yvel or 0
    
    self.friction = friction or 5
    self.speed = speed or 1500
    self.jump_vel = jump_vel or -800
    self.can_jump = can_jump or true
    

end



