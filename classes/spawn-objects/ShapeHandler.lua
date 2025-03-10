local Class = require("libraries.hump-master.class")

-- Local Imports --


ShapeHandler = Class()

local string_key

function ShapeHandler:init()
    self.rect_shape_table = {}
    self.rect_shape_idx = 0
    self.rect_spawned = false

    self.cir_shape_table = {}
    self.cir_shape_idx = 0
    self.cir_spawned = false
end

function ShapeHandler:addRectangle(shape --[[object]])
    self.rect_shape_idx = self.rect_shape_idx + 1
    string_key = 'rectangle' .. tostring(self.rect_shape_idx)
    table.insert(self.rect_shape_table, shape)
    --self.shape_table[key] = shape
    --print(shape.x)
end

function ShapeHandler:addCircle(shape --[[object]])
    self.cir_shape_idx = self.cir_shape_idx + 1
    string_key = 'circle' .. tostring(self.cir_shape_idx)
    table.insert(self.cir_shape_table, shape)
end

function ShapeHandler:setVelocity(shape --[[object]], positionX --[[int]], goalX --[[int]], positionY --[[int]], goalY --[[int]], staggerTime --[[float]])

    if staggerTime == 0 then
        
    end
    
    shape.velocityX = (goalX - (positionX )) / staggerTime
    shape.velocityY = (goalY - (positionY)) / staggerTime
    
end



function ShapeHandler:update(dt)

end

