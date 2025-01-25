local Class = require("libraries.hump-master.class")

-- Local Imports --


ShapeHandler = Class()

function ShapeHandler:init()
    self.shape_table = {}
    self.shape_idx = 0
    self.spawned = false
end

function ShapeHandler:addRectangle(shape --[[object]])
    self.shape_idx = self.shape_idx + 1
    key = 'rectangle' .. tostring(self.shape_idx)
    table.insert(self.shape_table, shape)
    --self.shape_table[key] = shape
    --print(shape.x)
end

function ShapeHandler:update(dt)

end

