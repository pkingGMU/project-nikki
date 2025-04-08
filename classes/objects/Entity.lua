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
    self.dash_vel = params.dash_speed or 500
    self.can_jump = params.can_jump or true

    self.health = params.health or 100

    self.type = 'entity'
end

function Entity:update(dt, my_player, gravity, object_handler, window_width, window_height)
    Object.update(self)

    self:updateVelocity(dt, my_player)
    
    self:updateMove(dt, gravity, object_handler)
    self:updatePhysics(window_width, window_height, object_handler)

    
end

function Entity:takeDamage(damage)
    self.health = self.health - damage
end





