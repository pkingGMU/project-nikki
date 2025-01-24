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
    myTimer = Timer(10)

    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()
    
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
     if t_down then
        myTimer:start()
        t_down = false  -- Reset the flag after starting the timer
    end
    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime)

    

    if not (midiPitch == 'No Notes') and not (moving_rect.x >= goal_rect.x) then
        moving_rect.x = moving_rect.x + 5
        print(moving_rect.x)
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

