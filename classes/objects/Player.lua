local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Entity')

-- Parent class Object --
Player = Class{__includes = Entity}

function Player:init(params, objectHandler)
    Entity.init(self, params, objectHandler)

    self.deflect = false
    self.deflected = false
    self.isPlayer = true
    self.canMoveX = true
    self.canMoveY = true

    self.isPlayer = true
    self.interact = false

    self.inventory = {}
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

 function Player:updateMove(dt, gravity, objectHandler)

    if self.canMoveY == true then
        self.yvel = self.yvel + gravity * dt
    end

    if self.canMoveX == true then
        self.xvel = self.xvel * (1- math.min(dt*self.friction, 1))
    end

    self.x = self.x + self.xvel * dt
    local collide_list = self:checkCollisions(objectHandler)
    self.xvel = self:collisionMoveX(collide_list)

    self.y = self.y + dt*(self.yvel + dt*gravity/2)
    local collide_list = self:checkCollisions(objectHandler)
    self.yvel = self:collisionMoveY(collide_list)

    

 end

 function Player:updatePhysics(window_width, window_height, objectHandler)

    


    if (self.y + self.h >= window_height)  then
        self.y = window_height - self.h
        self.yvel = 0.0
        self.can_jump = true
    end

    if (self.x + self.w >= window_width) then
        --self.x = window_width - self.w
    end

 end

 function Player:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1)

    if self.deflected == true then
        love.graphics.setColor(0,1,0)
    end
    
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end