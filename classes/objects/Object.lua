local Class = require("libraries.hump-master.class")

-- Local Imports --

local string_key

-- WorldState --
local WorldState = require("states.WorldState")

Object = Class()

function Object:init(params, objectHandler)
    self.x = params.x or 0
    self.y = params.y or 0
    self.z = params.z or 0
    self.w = params.w or 32
    self.h = params.h or 32
    self.rot = params.rot or 0
    self.scaleX = params.scaleX or 1
    self.scaleY = params.scaleY or 1
    self.tag = params.tag or 'none'
    self.soft_reset = params.soft_reset or false
    
    self.collide_x_offset = params.collide_x_offset or 0
    self.collide_y_offset = params.collide_y_offset or 0
    self.collide_w = params.collide_w or 32
    self.collide_h = params.collide_h or 32
    
    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2

    self.can_collide = params.can_collide or false

    self.to_be_destroyed = false
    

    
    self.id = Object:addToHandler(self, objectHandler)
    

    self.type = params.type or 'object'
    
    

end

function Object:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1,1)
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end

function Object:update(dt, state)
  self.centerX = self.x + self.w / 2
  self.centerY = self.y + self.h / 2

  if self.current_anim then
    self.current_anim.currentTime = self.current_anim.currentTime + dt
    if self.current_anim.currentTime >= self.current_anim.duration then
      self.current_anim.currentTime = self.current_anim.currentTime - self.current_anim.duration
    end
  end
end


function Object:testPrint(word --[[string]])
    --print(word)
end

function Object:addToHandler(object --[[table]], objectHandler --[[table]])
    table.insert(objectHandler.object_table, object)
    objectHandler.object_idx = objectHandler.object_idx + 1
    local id = objectHandler.object_idx

    return id
end

function Object:checkCollisions(objectHandler)
  local collide_list = {}
  
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self or other_object.can_collide == false or self.can_collide == false then
            goto continue
        end

        local cur_obj_x = self.x + self.collide_x_offset
        local cur_obj_y = self.y + self.collide_y_offset
        local cur_obj_w = self.collide_w
        local cur_obj_h = self.collide_h

        local other_obj_x = other_object.x + other_object.collide_x_offset
        local other_obj_y = other_object.y + other_object.collide_y_offset
        local other_obj_w = other_object.collide_w
        local other_obj_h = other_object.collide_h
        
        if cur_obj_x < other_obj_x + other_obj_w and cur_obj_x + cur_obj_w > other_obj_x and cur_obj_y < other_obj_y + other_obj_h and cur_obj_y + cur_obj_h > other_obj_y then
            table.insert(collide_list, other_object)
        else
            
        end

        ::continue::
        
    end

    return collide_list
end

function Object:collisionMoveX(collide_list --[[table]])
  for other_key, other_object in ipairs(collide_list) do

    local cur_obj_x = self.x + self.collide_x_offset
    local cur_obj_w = self.collide_w

    local other_obj_x = other_object.x + other_object.collide_x_offset
    local other_obj_w = other_object.collide_w

    if cur_obj_x < other_obj_x + other_obj_w and cur_obj_x + cur_obj_w > other_obj_x then
      self.xvel = 0
    else
    end
  end

    return self.xvel

end

function Object:collisionMoveY(collide_list)
  for other_key, other_object in ipairs(collide_list) do

        local cur_obj_y = self.y + self.collide_y_offset
        local cur_obj_h = self.collide_h

        local other_obj_y = other_object.y + other_object.collide_y_offset
        local other_obj_h = other_object.collide_h
        if cur_obj_y < other_obj_y + other_obj_h and cur_obj_y + cur_obj_h > other_obj_y then

          if self.isPlayer == true then
          end
            self.yvel = 0

        else
        end
    end

    return self.yvel
end

function Object:destroy(objectHandler, level)
   -- Debug --
    --print(#objectHandler.object_table)
  
  for i = #objectHandler.object_table, 1, -1 do

    print(objectHandler.object_table[i].id)
    
      if objectHandler.object_table[i].id == self.id then
        table.remove(objectHandler.object_table, i)
      end
    end

    local current_world_obj = WorldState[level].current.objects

    for i = #current_world_obj, 1, -1 do
      if current_world_obj[i].id == self.id then
        table.remove(current_world_obj, i)
      end
    end

    WorldState[level].current.objects = current_world_obj

    self.to_be_destroyed = true
    collectgarbage("collect") -- Force garbage collection

    
end


function Object:newAnimation(image, width, height, duration, startFrame, endFrame)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0
    animation.startFrame = startFrame or 1
    animation.endFrame = endFrame or 1

    return animation
end 


