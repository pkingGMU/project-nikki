local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')


-- Parent class Object --
TextBox = Class{__includes = Object}

function TextBox:init(params, objectHandler, npc)
    Object.init(self, params, objectHandler)

    self.npx_x = npc.npx_x
    self.npc_y = npc.npc_y
    self.display_text = npc.display_text
    self.isText = true
    self.text = params.text or 'text not found'

    
end

function TextBox:update()
    Object.update(self)
end

function TextBox:draw()

    
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle("line", self.x , self.y , self.w, self.h)

    love.graphics.printf(self.text, self.x, self.y, self.w, 'center')

    

end
