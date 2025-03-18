-- devRoomState.lua

require("states.BaseState")

-- Local imports --
require("classes.objects.Player")
require("classes.objects.Enemy")
require("classes.objects.EntityHandler")
require("classes.objects.ObjectHandler")
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
local shapeHandler = ShapeHandler()
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
local entityHandler = EntityHandler()
local objectHandler = ObjectHandler()




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
    myPlayer = Player({x = 200, w = 32, h = 32, health = 100, speed = 500, can_collide = true}, objectHandler)
    --entityHandler:addEntity(myPlayer)

    -- Create an Enemy --
    myEnemy = Enemy({w = 32, h = 32, can_collide = true, x = 10}, objectHandler)
    --entityHandler:addEntity(myEnemy)

    -- Create a bottom border for collision detection --
    bottom_border_platform = Object({x = 200, y = self.window_height-32, w = 32, h = 32, can_collide = false}, objectHandler)

    -- Test Timer --
    myTimer = Timer(200)
    -- Test Midi Trigger --
    midiTrigger = MidiTrigger()

    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0

    --midiFile = "sounds/Asgore/midi_training.csv"
    midiFile = "sounds/song1.csv"
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


    --song = love.audio.newSource("sounds/Asgore/Asgore.mp3", "stream")
    song = love.audio.newSource("sounds/song1.mp3", "stream")
    song:play()
    music = false

    -- variable that keeps track of rectangles that have spawed --
    last_call = 0

    -- Physics --
    gravity = 2000
    mass = 1
    force = gravity * mass

    -- Add tiles --
    tileHandler:addTiles(self.window_height, self.window_width)

    
    
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
    myPlayer:updateMove(dt, gravity, objectHandler)
    myPlayer:updatePhysics(self.window_width, self.window_height, objectHandler)
    

    -- Test Enemy --
    myEnemy:updateVelocity(dt, myPlayer)
    myEnemy:update()
    myEnemy:updateMove(dt, gravity)
    myEnemy:updatePhysics(self.window_width, self.window_height, objectHandler)
    
     

   

    -- Update player physics --

    

     -- Move Player --
     

     -- Update Collision --
     --objectHandler:update(dt)


    -- Trigger midi notes --
    midiPitch = midiTrigger:findNote(midiHash, myTimer.elapsedTime, 1)
    if not (midiPitch == 'No Notes') and shapeHandler.cir_spawned == false then
        shapeHandler:addCircle(SpawnCircle(myEnemy.x + myEnemy.w /2, myEnemy.y + myEnemy.h / 2, 1, 1-(last_call/250), last_call/250, Timer(1)))
        last_call = last_call + 1
        shapeHandler.cir_spawned = true
        myPlayer.deflected = false
    elseif midiPitch == 'No Notes' then
        shapeHandler.cir_spawned = false
    end
    latest_circle = shapeHandler.cir_shape_table[1]
    latest_circle_idx = #shapeHandler.cir_shape_table
    -- Make every circle move --
    for key, pair in ipairs(shapeHandler.cir_shape_table) do

        local shape_hit = false

        current_shape = shapeHandler.cir_shape_table[key]
        current_shape.lifespanTimer:update(dt)
        
        local start_allowance_timer = .1
        local end_allowance_timer = .5
        
        
        
        -- Debug --

        if not current_shape == latest_circle then
            goto continue
        end

        if current_shape.after_contact == false then
            shapeHandler:setVelocity(current_shape, current_shape.x, myPlayer.centerX, current_shape.y, myPlayer.centerY, current_shape.lifespanTimer:getRemainingTimeFloat())
        end
        if current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and current_shape.after_contact == false then
            current_shape.after_contact = true
            current_shape.lifespanTimer:addTime(end_allowance_timer)
            
            goto continue

        elseif current_shape.lifespanTimer:getRemainingTimeFloat() <= start_allowance_timer and current_shape.after_contact == false and myPlayer.deflect == true then
            table.remove(shapeHandler.cir_shape_table, key)
            myPlayer.deflected = true
            
            goto continue

        elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() > 0 and myPlayer.deflect == true then
            table.remove(shapeHandler.cir_shape_table, key)
            myPlayer.deflected = true
            
            goto continue
        elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and myPlayer.deflect == false then
            table.remove(shapeHandler.cir_shape_table, key)
            
            myPlayer:takeDamage(1)
            goto continue
        end

        

        --if (((current_shape.x >= myPlayer.x) and (current_shape.x <= myPlayer.x + myPlayer.w)) and ((current_shape.y >= myPlayer.y) and current_shape.y <= myPlayer.y + myPlayer.h)) then
        --    myPlayer:takeDamage(1)
        --    table.remove(shapeHandler.cir_shape_table, key)
        --    goto continue
        --end


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

    
    myPlayer.deflect = false

    
    
    

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
   tileHandler:draw(self.window_height)

   -- Circle Draw --
   shapeHandler:draw()
   
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

   -- progress bar --
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

    if key == "j" then
        myPlayer.deflect = true
    end
end
