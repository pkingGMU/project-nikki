-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


gameStateUpdate = Class()

function gameStateUpdate:init()

end

function gameStateUpdate:update(dt, game)
    --------------------
    if love.keyboard.isDown("up") then
        Num = Num + 100 * dt
    end
    -- test for timer
    if game.myTimer.running then
        game.myTimer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if game.music == false then
        game.myTimer:start()
        game.music = true
     end

     if game.t_down then
        game.myTimer:start()
        game.t_down = false  -- Reset the flag after starting the timer
    end


    -- Move goal rectangle --
    if game.a_down then
        game.goal_rect.x = game.goal_rect.x - 200 * dt
    end

    if game.d_down then
        game.goal_rect.x = game.goal_rect.x + 200 * dt
    end

    if game.w_down then
        game.goal_rect.y = game.goal_rect.y - 200 * dt
    end

    if game.s_down then
        game.goal_rect.y = game.goal_rect.y + 200 * dt
    end



    -- Trigger midi notes --
    game.midiPitch = game.midiTrigger:findNote(game.midiHash, game.myTimer.elapsedTime)

    if not (game.midiPitch == 'No Notes') and game.shapeHandler.cir_spawned == false then

        game.shapeHandler:addCircle(SpawnCircle(50, 300, 1, 1-(game.last_call/250), game.last_call/250, Timer(1)))
        game.last_call = game.last_call + 1
        game.shapeHandler.cir_spawned = true
    elseif game.midiPitch == 'No Notes' then
        game.shapeHandler.cir_spawned = false
    end

    game.latest_circle = game.shapeHandler.cir_shape_table[#game.shapeHandler.cir_shape_table]
    game.latest_circle_idx = #game.shapeHandler.cir_shape_table

    -- Make every rectangle move --

    for key, pair in ipairs(game.shapeHandler.cir_shape_table) do

        game.current_shape = game.shapeHandler.cir_shape_table[key]

        game.current_shape.lifespanTimer:update(dt)

        
        
        game.shapeHandler:setVelocity(game.current_shape, game.current_shape.x, game.goal_rect.x, game.current_shape.y, game.goal_rect.y, game.current_shape.lifespanTimer:getRemainingTimeFloat())
        

        if (game.shapeHandler.cir_shape_table[key].x == game.goal_rect.x) and (game.shapeHandler.cir_shape_table[key].y == game.goal_rect.y) then
            table.remove(game.shapeHandler.cir_shape_table, key)
            goto continue
        end

        if #game.shapeHandler.cir_shape_table >= 1 then
            game.current_shape_x = game.current_shape.x + game.current_shape.velocityX * dt
            game.current_shape_y = game.current_shape.y + game.current_shape.velocityY * dt
        end

        game.shapeHandler.cir_shape_table[key].x = game.current_shape_x
        game.shapeHandler.cir_shape_table[key].y = game.current_shape_y

        ::continue::
    end
end