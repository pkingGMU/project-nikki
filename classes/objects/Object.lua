local Class = require("libraries.hump-master.class")

-- Local Imports --


Object = Class()

function Object:init(x, y, z, rot, scaleX, scaleY, w, h, friction, speed, jump_vel, can_jump)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.rot = rot or 0
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
    self.w = w or 50
    self.h = h or 50
    self.friction = friction or 5
    self.speed = speed or 1500
    self.jump_vel = jump_vel or -800
    self.can_jump = can_jump or true
end

function Object:draw()
    love.graphics.push()
    --love.graphics.translate(self.x, self.y)
    --love.graphics.rotate(self.rot)
    --love.graphics.scale(self.scaleX, self.scaleY)
    
    -- Draw the rectangle (or image for your entity)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

end

function Object:testPrint(word --[[string]])
    print(word)
end