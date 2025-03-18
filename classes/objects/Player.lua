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

    table.insert(self.type, 1)
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

    local collide_list = {}
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self then
            goto continue
        end

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y then
            table.insert(collide_list, other_object)
        else
            
        end

        ::continue::
        
    end

    for other_key, other_object in ipairs(collide_list) do

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x then
            
            if self.xvel > 0 then
                self.x = other_object.x - self.w
            elseif self.xvel < 0 then
                self.x = other_object.x + other_object.w
            end
            self.xvel = 0
            
        else
            
        end
    end





    self.y = self.y + dt*(self.yvel + dt*gravity/2)

    local collide_list = {}
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self then
            goto continue
        end

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y then
            table.insert(collide_list, other_object)
        else
            
        end

        ::continue::
        
    end

    for other_key, other_object in ipairs(collide_list) do
    
        if self.y < other_object.y + other_object.h and self.y + self.h > other_object.y then
            
            if self.yvel > 0 then
                self.y = other_object.y - self.h
            elseif self.yvel < 0 then
                self.y = other_object.y + other_object.h
            end
            self.yvel = 0
            
        else
            
        end
        
    end

    

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