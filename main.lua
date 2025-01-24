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

    -- Test Timer --
    myTimer = Timer(5)

    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()
    
    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0
    b_down = false
    t_down = false

    midiFile = "sounds/midi_training.csv"
    midiHash = midiFileHandler:readMidi(midiFile)
    
end

-- Menu Draw --
function menu:draw()
    if b_down == false then
        love.graphics.setColor(1, 1, 1)
        -- love.graphics.draw(pfp_test, 50, 50) --
        love.graphics.rectangle("fill", 50, 50, 100, 100)
    end

   

    love.graphics.setColor(255, 0, 0)
    love.graphics.print(Num, 0, 0)
    love.graphics.print(midiPitch, 60, 20)
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

    
    ::continue::
    
    
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

