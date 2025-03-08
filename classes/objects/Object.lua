local Class = require("libraries.hump-master.class")

-- Local Imports --


Object = Class()

function Object:init(x, y, z, rot, w, h, scaleX, scaleY)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 50
    self.h = h or 50
    self.rot = rot or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
end

function Object:draw()
    love.graphics.push()
    
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end

function Object:testPrint(word --[[string]])
    print(word)
end