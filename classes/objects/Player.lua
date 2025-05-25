local Class = require("libraries.hump-master.class")

-- Local Imports --
require('classes.objects.Entity')

-- Parent class Object --
Player = Class { __includes = Entity }

function Player:init(params, objectHandler)
  Entity.init(self, params, objectHandler)

  self.deflect = false
  self.deflected = false
  self.isPlayer = true
  self.canMoveX = true
  self.canMoveY = true
  self.dash = false
  self.direction = 'right'

  self.isPlayer = true
  self.interact = false

  self.inventory = {}

  self.type = 'player'

  -- Animations --
  self.sprite_sheet = love.graphics.newImage("assets/Aseprite/Character_Sprites/character.png")
  self.idle_anim = self:newAnimation(self.sprite_sheet, 32, 32, 1, 2, 8)
  self.current_anim = self.idle_anim

  self.walk_anim = self:newAnimation(self.sprite_sheet, 32, 32, 1, 9, 12)
  

end

function Player:update(dt, state)
  Object.update(self, dt, state)

  -- Varibales From State --
  local gravity = state.gravity
  local object_handler = state.object_handler
  local c_down = state.c_down
  local window_width = state.window_width
  local window_height =state.window_height
  -- All local update functions --

  if state.debug_mode == false then
    self:updateVelocity(dt, c_down)
    self:updateMove(dt, gravity, object_handler)
    self:updatePhysics(window_width, window_height, object_handler)
  elseif state.debug_mode == true then
    self:debugUpdateMove(dt)
  end
end

function Player:updateVelocity(dt, c_down)
  if love.keyboard.isDown('left') and (self.xvel <= self.speed) then
    self.xvel = self.xvel - self.speed * dt
    self.current_anim = self.walk_anim
    self.direction = 'left'
    self.draw_direction = -1
    self.draw_x_offset = self.w
    self.speed = 100
  end

  if love.keyboard.isDown('right') and (self.xvel >= -self.speed) then
    self.xvel = self.xvel + self.speed * dt
    self.current_anim = self.walk_anim
    self.direction = 'right'
    self.draw_direction = 1
    self.draw_x_offset = 0
  end

  if not love.keyboard.isDown('right') and not love.keyboard.isDown('left') then
    self.current_anim = self.idle_anim
  end

  if self.dash and self.direction == 'right' then
    self.xvel = self.dash_vel
    self.dash = false
  elseif self.dash and self.direction == 'left' then
    self.xvel = self.dash_vel * -1
    self.dash = false
  end
end

-- Move Player --

function Player:updateMove(dt, gravity, objectHandler)

  local old_y = self.y
  local old_x = self.x
  
  if self.canMoveX then
    self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
  end

  self.x = self.x + self.xvel * dt      
  local collide_list = self:checkCollisions(objectHandler)
  self.xvel = self:collisionMoveX(collide_list)


  if self.xvel == 0 then
    self.x = old_x
    self.x = math.ceil(self.x)
  end
  
  if self.canMoveY then
    self.yvel = self.yvel + gravity * dt
  end

  self.y = self.y + self.yvel * dt

  local collide_list = self:checkCollisions(objectHandler)
  self.yvel = self:collisionMoveY(collide_list)

  if self.yvel == 0 then
    self.y = old_y
    self.y = math.ceil(self.y)

  else
  end

  
  
end

function Player:updatePhysics(window_width, window_height, objectHandler)
  if (self.y + self.h >= window_height) then
    --self.y = window_height - self.h
    --self.yvel = 0.0
    self.can_jump = true
  end
end

function Player:draw()
  love.graphics.push()

  local frameCount = self.current_anim.endFrame - self.current_anim.startFrame + 1
  love.graphics.setColor(1,1,1,1)
  local spriteNum = math.floor(self.current_anim.currentTime / self.current_anim.duration * frameCount) + self.current_anim.startFrame
  love.graphics.draw(self.current_anim.spriteSheet, self.current_anim.quads[spriteNum], self.x, self.y, nil, self.draw_direction, 1, self.draw_x_offset, 0)
    love.graphics.pop()
end

function Player:addToInventory(item --[[Object]])
  table.insert(self.inventory, item)
  -- Debug Player Inventory --
  print(self.inventory)
end

function Player:removeFromInventory(item --[[Object]])
    table.remove(self.inventory, item)
end

function Player:debugUpdateMove(dt)
 if self.canMoveY == true then
    self.yvel = self.yvel + 0 * dt
  end

  if self.canMoveX == true then
    self.xvel = self.xvel * (1 - math.min(dt * 0, 1))
  end

  self.x = self.x + self.xvel * dt

  self.y = self.y + dt * (self.yvel + dt * 0 / 2)

end

function Player:debugUpdateMove(dt)
  if love.keyboard.isDown('left') then
    self.x = self.x - self.speed * dt
    
  end

  if love.keyboard.isDown('right') then
    self.x = self.x + self.speed * dt
  end

  if love.keyboard.isDown('up') then
    self.y = self.y - self.speed * dt
  end

  if love.keyboard.isDown('down') then
    self.y = self.y + self.speed * dt
  end
end

