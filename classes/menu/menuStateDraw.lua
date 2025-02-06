-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


menuStateDraw = Class()

function menuStateDraw:init()

end

function menuStateDraw:draw(menu)
    love.graphics.setColor(menu.play_button.r, menu.play_button.g, menu.play_button.b)
    love.graphics.rectangle("fill", menu.play_button.x, menu.play_button.y, menu.play_button.width, menu.play_button.height)
end