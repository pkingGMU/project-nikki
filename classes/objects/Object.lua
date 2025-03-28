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
   

    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2

    self.can_collide = params.can_collide or false

    
    self.object_handler_key = Object:addToHandler(self, objectHandler)
    
    

end

function Object:draw()
    love.graphics.push()
    
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end

function Object:update()

    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2

end


function Object:testPrint(word --[[string]])
    print(word)
end

function Object:addToHandler(object --[[table]], objectHandler --[[table]])

    objectHandler.object_idx = objectHandler.object_idx + 1
    string_key = 'object' .. tostring(objectHandler.object_idx)
    table.insert(objectHandler.object_table, object)

    print("Inserted " .. string_key)
    --print(object.can_collide)

    return objectHandler.object_idx

end

function Object:checkCollisions(objectHandler)
    local collide_list = {}
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self or other_object.can_collide == false or self.can_collide == false then
            goto continue
        end

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
    print("Deleting object with key: " .. tostring(self.object_handler_key))

    print(self)
    print(objectHandler.object_table[self.object_handler_key])
    print(self.object_handler_key)

    
    
    objectHandler.object_table[self.object_handler_key] = nil

    -- Optional: Nullify properties to help garbage collection
    for k in pairs(self) do
        self[k] = nil
    end

    --self = nil
    print(objectHandler.object_table[self.object_handler_key])
    print(self.object_handler_key)
            

    

    print(self)

    collectgarbage("collect") -- Force garbage collection
end

    


