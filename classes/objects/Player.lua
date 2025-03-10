local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Entity')

-- Parent class Object --
Player = Class{__includes = Entity}

function Player:init(params)
    Entity.init(self, params)
end

function Player:updateVelocity(dt)

    if love.keyboard.isDown('a') and (self.xvel <= self.speed) then
        self.xvel = self.xvel - self.speed * dt
    end

    if love.keyboard.isDown('d') and (self.xvel >= -self.speed)then
        self.xvel = self.xvel + self.speed * dt
    end

end

 -- Move Player --

 function Player:updateMove(dt, gravity)

    self.x = self.x + self.xvel * dt
    self.y = self.y + dt*(self.yvel + dt*gravity/2)
    self.yvel = self.yvel + gravity * dt
    self.xvel = self.xvel * (1- math.min(dt*self.friction, 1))

 end

 function Player:updatePhysics(window_width, window_height)

    if (self.y + self.h >= window_height)  then
        self.y = window_height - self.h
        self.yvel = 0.0
        self.can_jump = true
    elseif (self.y  <= 0) then
        self.y  = 0
    end

    if (self.x + self.w >= window_width) then
        --self.x = window_width - self.w
    elseif (self.x  <= 0) then
        self.x = 0
    end

 end