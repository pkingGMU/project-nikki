-- devRoomState.lua

require("states.BaseState")

-- Local imports --
require("classes.objects.Player")
require("classes.objects.Enemy")
require("classes.spawn-objects.TileHandler")
require("states.baseWindow")

require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")

-- Camera --
local camera = require("libraries.hump-master.camera")



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
local current_shape_x
local current_shape_y
local window = baseWindow()
local bottom_border_platform
local myPlayer
local myEnemy
local pfp_test
local song
local cam
local tileHandler = TileHandler()


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

    self.cam = camera()
    
    window:init()

    -- Create a Player --
    myPlayer = Player({w = 32, h = 32, health = 100, speed = 500})

    -- Create an Enemy --
    myEnemy = Enemy({w = 32, h = 32})

    -- Create a bottom border for collision detection --
    bottom_border_platform = Object({x = 0, y = self.window_height, w = self.window_width, h = 20})


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


    -- Test Player
    myPlayer:updateVelocity(dt)
    myPlayer:update()

    -- Test Enemy --
    myEnemy:updateVelocity(dt, myPlayer)
    myEnemy:updateMove(dt, gravity)
    myEnemy:updatePhysics(self.window_width, self.window_height)
    myEnemy:update()
     

    -- Move Player --
    myPlayer:updateMove(dt, gravity)

    -- Update player physics --

    myPlayer:updatePhysics(self.window_width, self.window_height)
    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime, 1)
    if not (midiPitch == 'No Notes') and shapeHandler.cir_spawned == false then
        shapeHandler:addCircle(SpawnCircle(myEnemy.x + myEnemy.w /2, myEnemy.y + myEnemy.h / 2, 1, 1-(last_call/250), last_call/250, Timer(1)))
        last_call = last_call + 1
        shapeHandler.cir_spawned = true
    elseif midiPitch == 'No Notes' then
        shapeHandler.cir_spawned = false
    end
    latest_circle = shapeHandler.cir_shape_table[#shapeHandler.cir_shape_table]
    latest_circle_idx = #shapeHandler.cir_shape_table
    -- Make every circle move --
    for key, pair in ipairs(shapeHandler.cir_shape_table) do
        current_shape = shapeHandler.cir_shape_table[key]
        current_shape.lifespanTimer:update(dt)
        
        
        
        
        -- Debug --
        shapeHandler:setVelocity(current_shape, current_shape.x, myPlayer.centerX, current_shape.y, myPlayer.centerY, current_shape.lifespanTimer:getRemainingTimeFloat())


        if (((current_shape.x >= myPlayer.x) and (current_shape.x <= myPlayer.x + myPlayer.w)) and ((current_shape.y >= myPlayer.y) and current_shape.y <= myPlayer.y + myPlayer.h)) then
            myPlayer:takeDamage(1)
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
    

    -- Camera Update --
    self.cam:lookAt(myPlayer.x + myPlayer.w / 2, myPlayer.y + myPlayer.h / 2)

    if self.cam.x < self.window_width / 2 then
        self.cam.x = self.window_width / 2
    end

    if self.cam.y < self.window_height / 2 or self.cam.y > self.window_height / 2 then
        self.cam.y = self.window_height / 2
    end

end


function DevRoomState:draw()

    -- Camera --
   self.cam:attach()
   -- Test Player --
   love.graphics.setColor(1, 1, 1)
   myPlayer:draw()
   love.graphics.setColor(1,0,0)
   myEnemy:draw()
   love.graphics.setColor(1,1,1,.4)
   bottom_border_platform:draw()

   -- Tile Map --
   tileHandler:draw()

 

   --draw every rectangle
   if not (#shapeHandler.cir_shape_table == 0) then

        for key, pair in ipairs(shapeHandler.cir_shape_table) do
            love.graphics.setColor(pair.r, pair.g, pair.b)
            love.graphics.circle("fill", pair.x, pair.y, pair.radius)
        end

    end
   self.cam:detach()


   -- Goal rectangle --
   --love.graphics.setColor(1, 1, 1)
   --love.graphics.rectangle("fill", goal_rect.x, goal_rect.y, goal_rect.width, goal_rect.height)
   
   love.graphics.setColor(255, 0, 0)
   love.graphics.print(Num, 0, 0)
   
   --love.graphics.print(midiPitch, 60, 20)
   love.graphics.print(myTimer:getRemainingTime(), 20, 20)
   love.graphics.print("Health: " .. myPlayer.health, self.window_width - 100, 50)
 
   if myTimer:isFinished() then
       love.graphics.print("Timer finished!", 10, 30)
   end

   -- Draw rectangle from midi --
   

   
   --print(#shapeHandler.shape_table)
   love.graphics.setColor(0,0,0)

   


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
