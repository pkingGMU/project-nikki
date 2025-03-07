local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Entity')

-- Parent class Object --
Player = Class{__includes = Entity}

function Player:init()
    Entity.init(self)

end

function Player:updateVelocity(dt)

    if love.keyboard.isDown('a') and (self.xvel <= self.speed) then
        self.xvel = self.xvel - self.speed * dt
    end

    if love.keyboard.isDown('d') and (self.xvel >= -self.speed)then
        self.xvel = self.xvel + self.speed * dt
    end

end