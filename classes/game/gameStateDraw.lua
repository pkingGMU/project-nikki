-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


gameStateDraw = Class()

function gameStateDraw:init()

end

function gameStateDraw:draw(game)

    -- Test Player --
    love.graphics.setColor(1, 1, 1)
    game.myPlayer:draw()


    -- Goal rectangle --
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", game.goal_rect.x, game.goal_rect.y, game.goal_rect.width, game.goal_rect.height)
    
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(game.Num, 0, 0)
    
    --love.graphics.print(midiPitch, 60, 20)
    love.graphics.print(game.myTimer:getRemainingTime(), 20, 20)

    if game.myTimer:isFinished() then
        love.graphics.print("Timer finished!", 10, 30)
    end

    -- Draw rectangle from midi --
    

    
    --print(#shapeHandler.shape_table)
    love.graphics.setColor(0,0,0)

    --draw every rectangle
    if not (#game.shapeHandler.cir_shape_table == 0) then

        for key, pair in ipairs(game.shapeHandler.cir_shape_table) do
            love.graphics.setColor(pair.r, pair.g, pair.b)
            love.graphics.circle("fill", pair.x, pair.y, pair.radius)
        end

    end


    -- draw the latest_rectangle
    --if not (#shapeHandler.shape_table == 0) and shapeHandler.spawned == false then
    --    love.graphics.setColor((#shapeHandler.shape_table/50), 1 - (#shapeHandler.shape_table/50),(#shapeHandler.shape_table/50) + .03)
    --    love.graphics.rectangle("fill", latest_rectangle.x, latest_rectangle.y, latest_rectangle.width, latest_rectangle.height)
    --    last_call = #shapeHandler.shape_table
    --end
    
end