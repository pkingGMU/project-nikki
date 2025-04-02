local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Entity')

-- Parent class Object --
Enemy = Class{__includes = Entity}

local right_edge_reached = false
local left_edge_reached = false
local vector_threshold = 100

function Enemy:init(params, objectHandler)
    Entity.init(self, params, objectHandler)

    self.isEnemy = true
    self.type = 'enemy'
end

function Enemy:update(dt, my_player, gravity, object_handler, window_width, window_height)
    Object.update(self)

    self:updateVelocity(dt, my_player)
    
    self:updateMove(dt, gravity, object_handler)
    self:updatePhysics(window_width, window_height, object_handler)

    
end

function Enemy:updateVelocity(dt, myPlayer)

    math.randomseed(os.time())

    self.speed = math.random(100, 500)

    

    if right_edge_reached == true then
        self.xvel = self.xvel - self.speed * dt
    elseif left_edge_reached == true then
        self.xvel = self.xvel + self.speed * dt
    else
        self.xvel = self.xvel + self.speed * dt

    end

    if math.abs((self.x) - (myPlayer.x)) < vector_threshold then

        if self.x >= myPlayer.x and self.y - 10 <= myPlayer.y then
            self.xvel = self.xvel + myPlayer.speed * dt
        elseif self.x <= myPlayer.x and self.y - 10 <= myPlayer.y then
            self.xvel = self.xvel - myPlayer.speed * dt
        else
            --self.xvel = self.xvel + myPlayer.speed * dt
        end


    end

    

end

 -- Move Player --

 function Enemy:updateMove(dt, gravity, objectHandler)

    self.xvel = self.xvel * (1- math.min(dt*self.friction, 1))
    self.yvel = self.yvel + gravity * dt

    self.x = self.x + self.xvel * dt
    local collide_list = self:checkCollisions(objectHandler)
    self.xvel = self:collisionMoveX(collide_list)
    
    self.y = self.y + dt*(self.yvel + dt*gravity/2)
    local collide_list = self:checkCollisions(objectHandler)
    self.yvel = self:collisionMoveY(collide_list)

 end

 function Enemy:updatePhysics(window_width, window_height, objectHandler)

    if (self.y + self.h >= window_height)  then
        --self.y = window_height - self.h
        --self.yvel = 0.0
        self.can_jump = true
    elseif (self.y  <= 0) then
        self.y  = 0
    end

    if (self.x + self.w >= window_width) then
        self.x = window_width - self.w
        right_edge_reached = true
        left_edge_reached = false
    elseif (self.x  <= 0) then
        self.x = 0
        left_edge_reached = true
        right_edge_reached = false
    end

    

 end