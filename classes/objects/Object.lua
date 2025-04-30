local Class = require("libraries.hump-master.class")

-- Local Imports --

local string_key


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
   

    self.collide_x_offset = params.collide_offset_x or 0
    self.collide_y_offset = params.collide_offset_y or 0
    self.collide_w = params.collide_w or self.w
    self.collide_h = params.collide_h or self.h
    
    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2

    self.can_collide = params.can_collide or false

    self.to_be_destroyed = false
    

    
    self.id = Object:addToHandler(self, objectHandler)

    self.type = params.type or 'object'
    
    

end

function Object:draw()
    love.graphics.push()
    love.graphics.setColor(1,1,1,0)
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end

function Object:update(dt, state)
    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2
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

        local cur_obj_x
        local cur_obj_y
        local cur_obj_w
        local cur_obj_h

        

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y then
            table.insert(collide_list, other_object)
        else
            
        end

        ::continue::
        
    end

    return collide_list
end

function Object:collisionMoveX(collide_list --[[table]])
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

    return self.xvel

end

function Object:collisionMoveY(collide_list)
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

    return self.yvel
end

function Object:destroy(objectHandler)
   -- Debug --
    --print(#objectHandler.object_table)

    for i, obj in ipairs(objectHandler.object_table) do
        if obj.id == self.id then
           --print(obj.id)
           --print(self.id)
           --print("found")
            table.remove(objectHandler.object_table, i)
        end
    end

    self.to_be_destroyed = true

    

    collectgarbage("collect") -- Force garbage collection
end

    


