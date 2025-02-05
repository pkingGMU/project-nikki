-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


menuStateDraw = Class()

function menuStateDraw:init()

end

function menuStateDraw:draw(menu)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", 100,100,100,100)
    love.graphics.print(menu.debugText)


    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", menu.test_button.x, menu.test_button.y, menu.test_button.width, menu.test_button.height)
end