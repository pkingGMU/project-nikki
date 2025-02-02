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
    myTimer = Timer(60)

    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()

    -- Test object handler --
    shapeHandler = ShapeHandler()
    
    
    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0
    b_down = false
    t_down = false

    midiFile = "sounds/midi_training.csv"
    midiHash = midiFileHandler:readMidi(midiFile)

    -- Goal rectangle -- 
    goal_rect = {
        x = (window_width/2) - 50,
        y = 50,
        width = 100,
        height = 100
    }
    -- Moving rectangel -- 
    moving_rect = {
        x = 50,
        y = 50,
        width = 100,
        height = 100
    }

    song = love.audio.newSource("sounds/song1.mp3", "stream")
    song:play()
    music = false

    -- variable that keeps track of rectangles that have spawed --
    last_call = 0

    
end

-- Menu Draw --
function menu:draw()

    -- Goal and moving rectangle --
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", goal_rect.x, goal_rect.y, goal_rect.width, goal_rect.height)
    
    love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("fill", moving_rect.x, moving_rect.y, moving_rect.width, moving_rect.height)
    

   

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
    if not (#shapeHandler.shape_table == 0) then

        for key, pair in ipairs(shapeHandler.shape_table) do
            love.graphics.setColor(pair.r, pair.g, pair.b)
            love.graphics.rectangle("fill", pair.x, pair.y, pair.width, pair.height)
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
    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime)

    if not (midiPitch == 'No Notes') and shapeHandler.spawned == false then
        shapeHandler:addRectangle(SpawnRectangle(50, 300, 1, 1-(last_call/50), last_call/50))
        last_call = last_call + 1
        shapeHandler.spawned = true
    elseif midiPitch == 'No Notes' then
        shapeHandler.spawned = false
    end

    latest_rectangle = shapeHandler.shape_table[#shapeHandler.shape_table]
    latest_rectangle_idx = #shapeHandler.shape_table

    -- Make every rectangle move --

    for key, pair in ipairs(shapeHandler.shape_table) do

        print(key)

        current_shape_x = shapeHandler.shape_table[key].x

        if not (#shapeHandler.shape_table == 1) and not (key == 1) then
            --previous_shape_x = shapeHandler.shape_table[key + 1].x
        else
            --previous_shape_x = 0
        end

        if shapeHandler.shape_table[key].x + 6 >= window_width then
            table.remove(shapeHandler.shape_table, key)
            goto continue
        end

        if #shapeHandler.shape_table >= 1 then
            current_shape_x = current_shape_x + .7
        end

        shapeHandler.shape_table[key].x = current_shape_x

        ::continue::
    end
    
    
    
    

    --print(shapeHandler.shape_idx)

    if not (midiPitch == 'No Notes') and not (moving_rect.x >= goal_rect.x) then
        moving_rect.x = moving_rect.x + 6
        
    else
        moving_rect.x = 50
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
end

-- Callback function love.keyreleased
-- Action listener?
-- Menu Keyreleased --
function menu:keyreleased(key)
    if key == 'b' then
        b_down = false
    end

    

    
end

