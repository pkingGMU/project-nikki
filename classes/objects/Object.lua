local Class = require("libraries.hump-master.class")

-- Local Imports --

local string_key


Object = Class()

function Object:init(params, objectHandler)
    self.x = params.x or 0
    self.y = params.y or 0
    self.z = params.z or 0
    self.w = params.w or 50
    self.h = params.h or 50
    self.rot = params.rot or 0
    self.scaleX = params.scaleX or 1
    self.scaleY = params.scaleY or 1
    self.type = {1}
   

    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2

    self.can_collide = params.can_collide or false

    
    Object:addToHandler(self, objectHandler)

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
    string_key = 'entity' .. tostring(objectHandler.object_idx)
    table.insert(objectHandler.object_table, object)

    print("Inserted " .. string_key)
    print(object.can_collide)

end

function Object:checkCollisions(objectHandler)

        
        
        

end

    


