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


    -- Change Player velocity --
    if game.a_down and (game.goal_rect.xvel <= game.goal_rect.speed) then
        game.goal_rect.xvel = game.goal_rect.xvel - game.goal_rect.speed * dt
    end

    if game.d_down and (game.goal_rect.xvel >= -game.goal_rect.speed)then
        game.goal_rect.xvel = game.goal_rect.xvel + game.goal_rect.speed * dt
    end

    -- Move Player --
    game.goal_rect.x = game.goal_rect.x + game.goal_rect.xvel * dt
    game.goal_rect.y = game.goal_rect.y + dt*(game.goal_rect.yvel + dt*game.gravity/2)
    game.goal_rect.yvel = game.goal_rect.yvel + game.gravity * dt
    game.goal_rect.xvel = game.goal_rect.xvel * (1- math.min(dt*game.goal_rect.friction, 1))

    

    -- Player Physics -- 
    -- Check if we collided with the bottom of the screen --
    if (game.goal_rect.y + game.goal_rect.height >= game.window_height)  then
        game.goal_rect.y = game.window_height - game.goal_rect.height
        game.goal_rect.can_jump = true
    elseif (game.goal_rect.y  <= 0) then
        game.goal_rect.y  = 0
    end

    if (game.goal_rect.x + game.goal_rect.width >= game.window_width) then
        game.goal_rect.x = game.window_width - game.goal_rect.width
    elseif (game.goal_rect.x  <= 0) then
        game.goal_rect.x = 0
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

    -- Make every circle move --

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