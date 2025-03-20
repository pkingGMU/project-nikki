local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Entity = Class{__includes = Object}

function Entity:init(params, objectHandler)
    Object.init(self, params, objectHandler)

    self.xvel = params.xvel or 0
    self.yvel = params.yvel or 0
    
    self.friction = params.friction or 5
    self.speed = params.speed or 1500
    self.jump_vel = params.jump_vel or -800
    self.can_jump = params.can_jump or true

    self.health = params.health or 100

end

function Entity:update()
    Object.update(self)
end

function Entity:takeDamage(damage)
    self.health = self.health - damage
end





