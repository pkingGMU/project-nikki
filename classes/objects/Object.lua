local Class = require("libraries.hump-master.class")

-- Local Imports --


Object = Class()

function Object:init(params)
    self.x = params.x or 0
    self.y = params.y or 0
    self.z = params.z or 0
    self.w = params.w or 50
    self.h = params.h or 50
    self.rot = params.rot or 0
    self.scaleX = params.scaleX or 1
    self.scaleY = params.scaleY or 1

    self.centerX = self.x + self.w / 2
    self.centerY = self.y + self.h / 2
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