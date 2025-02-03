---@diagnostic disable: need-check-nil
-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
local Gamestate = require("libraries.hump-master.gamestate")
local csv = require("libraries.lua-csv-master.lua.csv")


-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")

-- Gamestate variables --
local menu = {}

--Callback function love.load 
--Called once upon opening

function love.load()
    -- Hump gamestate init --
    Gamestate.registerEvents()
    Gamestate.switch(menu)
end

-- Gamestate menu --

-- Menu Init (Load) --
function menu:init()
    local window = baseWindow()
    window:init()

    --window sizes--
    window_height = window.windowHeight
    window_width = window.windowWidth

    -- Test Timer --
    myTimer = Timer(200)

    

    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()

    -- Test object handler --
    shapeHandler = ShapeHandler()
    
    
    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0
    b_down = false
    t_down = false
    a_down = false
    s_down = false
    d_down = false
    w_down = false

    midiFile = "sounds/Asgore/midi_training.csv"
    midiHash = midiFileHandler:readMidi(midiFile)

    -- Goal rectangle -- 
    goal_rect = {
        x = (window_width/2) - 25,
        y = (window_height/2) - 25,
        width = 50,
        height = 50
    }
    

    song = love.audio.newSource("sounds/Asgore/Asgore.mp3", "stream")
    song:play()
    music = false

    -- variable that keeps track of rectangles that have spawed --
    last_call = 0

    
end

-- Menu Draw --
function menu:draw()

    -- Goal rectangle --
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", goal_rect.x, goal_rect.y, goal_rect.width, goal_rect.height)
    
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(Num, 0, 0)
    
    --love.graphics.print(midiPitch, 60, 20)
    love.graphics.print(myTimer:getRemainingTime(), 20, 20)

    if myTimer:isFinished() then
        love.graphics.print("Timer finished!", 10, 30)
    end

    -- Draw rectangle from midi --
    

    
    --print(#shapeHandler.shape_table)
    love.graphics.setColor(0,0,0)

    --draw every rectangle
    if not (#shapeHandler.cir_shape_table == 0) then

        for key, pair in ipairs(shapeHandler.cir_shape_table) do
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


-- Menu Update --
function menu:update(dt)

    --Debug-------------
    


    --------------------
    if love.keyboard.isDown("up") then
        Num = Num + 100 * dt
    end
    -- test for timer
    if myTimer.running then
        myTimer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if music == false then
        myTimer:start()
        music = true
     end

     if t_down then
        myTimer:start()
        t_down = false  -- Reset the flag after starting the timer
    end


    -- Move goal rectangle --
    if a_down then
        goal_rect.x = goal_rect.x - 200 * dt
    end

    if d_down then
        goal_rect.x = goal_rect.x + 200 * dt
    end

    if w_down then
        goal_rect.y = goal_rect.y - 200 * dt
    end

    if s_down then
        goal_rect.y = goal_rect.y + 200 * dt
    end



    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime)

    if not (midiPitch == 'No Notes') and shapeHandler.cir_spawned == false then

        shapeHandler:addCircle(SpawnCircle(50, 300, 1, 1-(last_call/250), last_call/250, Timer(1)))
        last_call = last_call + 1
        shapeHandler.cir_spawned = true
    elseif midiPitch == 'No Notes' then
        shapeHandler.cir_spawned = false
    end

    latest_circle = shapeHandler.cir_shape_table[#shapeHandler.cir_shape_table]
    latest_circle_idx = #shapeHandler.cir_shape_table

    -- Make every rectangle move --

    for key, pair in ipairs(shapeHandler.cir_shape_table) do

        current_shape = shapeHandler.cir_shape_table[key]

        current_shape.lifespanTimer:update(dt)

        
        
        shapeHandler:setVelocity(current_shape, current_shape.x, goal_rect.x, current_shape.y, goal_rect.y, current_shape.lifespanTimer:getRemainingTimeFloat())
        

        if (shapeHandler.cir_shape_table[key].x == goal_rect.x) and (shapeHandler.cir_shape_table[key].y == goal_rect.y) then
            table.remove(shapeHandler.cir_shape_table, key)
            goto continue
        end

        if #shapeHandler.cir_shape_table >= 1 then
            current_shape_x = current_shape.x + current_shape.velocityX * dt
            current_shape_y = current_shape.y + current_shape.velocityY * dt
        end

        shapeHandler.cir_shape_table[key].x = current_shape_x
        shapeHandler.cir_shape_table[key].y = current_shape_y

        ::continue::
    end
    
   
  
end

-- Callback function love.keypressed
-- Action listener?
-- Menu Keypressed --
function menu:keypressed(key)
    if key == 'b' then
        b_down = true
    end

    if key == 't' then
        t_down = true
    end

    if key == 'a' then
        a_down = true
    end

    if key == 's' then
        s_down = true
    end

    if key == 'd' then
        d_down = true
    end

    if key == 'w' then
        w_down = true
    end
end

-- Callback function love.keyreleased
-- Action listener?
-- Menu Keyreleased --
function menu:keyreleased(key)
    if key == 'b' then
        b_down = false
    end

    if key == 'a' then
        a_down = false
    end

    if key == 's' then
        s_down = false
    end

    if key == 'd' then
        d_down = false
    end

    if key == 'w' then
        w_down = false
    end

    

    
end

