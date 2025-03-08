-- devRoomState.lua

require("states.BaseState")

-- Local imports --
require("classes.objects.Player")
require("states.baseWindow")

require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")



local goal_rect
local myTimer
local shapeHandler
local midiTrigger
local midiHash
local gravity
local music
local last_call
local midiPitch
local Num 
local current_shape
local latest_circle
local latest_circle_idx
local window = baseWindow()
local myPlayer
local pfp_test
local song


DevRoomState = BaseState.new()

function DevRoomState:init()
    print("DevRoomState init")
    local self = BaseState.new()  -- Call the BaseState constructor
    setmetatable(self, {__index = DevRoomState})  -- Set metatable to DevRoomState
    -- Define state-specific variables (if needed)
    return self
end

function DevRoomState:enter()
    BaseState.enter(self)
    
    window:init()

    myPlayer = Player()


    -- Test Timer --
    myTimer = Timer(200)
    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()

    -- Test object handler --
    shapeHandler = ShapeHandler()

    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0

    midiFile = "sounds/Asgore/midi_training.csv"
    midiHash = midiFileHandler:readMidi(midiFile)

    -- Goal rectangle -- 
    goal_rect = {
        x = (self.window_width/2) - 25,
        y = (self.window_height/2) - 25,
        width = 50,
        height = 50,
        xvel = 0,
        yvel = 0,
        friction = 5,
        speed = 1500,
        jump_vel = -800,
        can_jump = true
    }


    song = love.audio.newSource("sounds/Asgore/Asgore.mp3", "stream")
    song:play()
    music = false

    -- variable that keeps track of rectangles that have spawed --
    last_call = 0

    -- Physics --
    gravity = 2000
    mass = 1
    force = gravity * mass
    
end

function DevRoomState:update(dt)

    if self.jump_key == true then
        print("Jumping")
    end

    --------------------
    -- test for timer
    if myTimer.running then
        myTimer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if music == false then
        myTimer:start()
        music = true
     end

     print(dt)

    -- Test Player
    myPlayer:updateVelocity(dt)

    -- Move Player --
    myPlayer:updateMove(dt, gravity)

    -- Update player physics --

    myPlayer:updatePhysics(self.window_width, self.window_height)

    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime, 1)
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


function DevRoomState:draw()
   -- Test Player --
   love.graphics.setColor(1, 1, 1)
   myPlayer:draw()


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

function DevRoomState:keypressed(key)
    -- Handle key presses for the dev room (e.g., add objects, toggle debug mode)
    BaseState.keypressed(self,key)

end

function DevRoomState:keyreleased(key)
    -- Handle key presses for the dev room (e.g., add objects, toggle debug mode)
    BaseState.keyreleased(self,key)

    if key == "space" then
        myPlayer.yvel = myPlayer.jump_vel
        
    end
end
