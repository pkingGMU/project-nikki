-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


gameStateUpdate = Class()

function gameStateUpdate:init()

end

function gameStateUpdate:update(dt, game)


    local goal_rect = game.goal_rect
    local myTimer = game.myTimer
    local shapeHandler = game.shapeHandler
    local midiTrigger = game.midiTrigger
    local midiHash = game.midiHash
    local window_width = game.window_width
    local window_height = game.window_height
    local gravity = game.gravity
    local music = game.music
    local t_down = game.t_down
    local a_down = game.a_down
    local d_down = game.d_down
    local last_call = game.last_call
    local midiPitch = game.midiPitch
    local Num = game.Num
    local current_shape
    local latest_circle
    local latest_circle_idx

    --------------------
    if love.keyboard.isDown("up") then
        game.Num = game.Num + 100 * dt
    end
    -- test for timer
    if myTimer.running then
        game.myTimer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if music == false then
        game.myTimer:start()
        game.music = true
     end

     if t_down then
        game.myTimer:start()
        game.t_down = false  -- Reset the flag after starting the timer
    end

    


    -- Change Player velocity --
    if a_down and (goal_rect.xvel <= goal_rect.speed) then
        game.goal_rect.xvel = goal_rect.xvel - goal_rect.speed * dt
    end

    if d_down and (goal_rect.xvel >= -goal_rect.speed)then
        game.goal_rect.xvel = goal_rect.xvel + goal_rect.speed * dt
    end

    -- Move Player --
    game.goal_rect.x = goal_rect.x + goal_rect.xvel * dt
    game.goal_rect.y = goal_rect.y + dt*(goal_rect.yvel + dt*gravity/2)
    game.goal_rect.yvel = goal_rect.yvel + gravity * dt
    game.goal_rect.xvel = goal_rect.xvel * (1- math.min(dt*goal_rect.friction, 1))

    -- Player Physics -- 
    -- Check if we collided with the bottom of the screen --
    --print(goal_rect.yvel)
    if (goal_rect.y + goal_rect.height >= window_height)  then
        game.goal_rect.y = window_height - goal_rect.height
        game.goal_rect.yvel = 0.0
        game.goal_rect.can_jump = true
    elseif (goal_rect.y  <= 0) then
        game.goal_rect.y  = 0
    end

    if (goal_rect.x + goal_rect.width >= window_width) then
        game.goal_rect.x = window_width - goal_rect.width
    elseif (goal_rect.x  <= 0) then
        game.goal_rect.x = 0
    end

    

  



    -- Trigger midi notes --
    game.midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime, 1)
    if not (game.midiPitch == 'No Notes') and game.shapeHandler.cir_spawned == false then
        shapeHandler:addCircle(SpawnCircle(50, 300, 1, 1-(last_call/250), last_call/250, Timer(1)))
        game.last_call = last_call + 1
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