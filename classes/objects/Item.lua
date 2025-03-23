local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Interactable')

-- Parent class Object --
Item = Class{__includes = Interactable}

function Item:init(params, objectHandler)
    Object.init(self, params, objectHandler)
end

function Item:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", self.x , self.y , self.w, self.h)
end
