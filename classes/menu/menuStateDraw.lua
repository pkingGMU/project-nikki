-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


menuStateDraw = Class()

function menuStateDraw:init()

end

function menuStateDraw:draw(menu)
    -- Background --
    -- Background Shader --
    love.graphics.setShader(menu.background_shader)

    -- Send variables to shader --

    
    love.graphics.setColor(menu.background.r, menu.background.g, menu.background.b)
    love.graphics.rectangle("fill", menu.background.x, menu.background.y, menu.background.width, menu.background.height)
    -- Remove background shader --
    love.graphics.setShader()

    love.graphics.setColor(menu.play_button.r, menu.play_button.g, menu.play_button.b)
    love.graphics.rectangle("fill", menu.play_button.x, menu.play_button.y, menu.play_button.width, menu.play_button.height)
end