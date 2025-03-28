-- devRoomState.lua

require("states.BaseState")

-- Local imports --
require("classes.objects.Player")
require("classes.objects.Enemy")
require("classes.objects.NPC")
require("classes.objects.Item")
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
local my_timer
local shape_handler = ShapeHandler()
local midi_trigger
local midi_hash
local midi_file
local gravity
local music
local last_call
local midi_pitch
local Num 
local current_shape
local current_shape_x
local current_shape_y
local window = baseWindow()
local bottom_border_platform
local my_player
local my_enemy
local item
local pfp_test
local song
local cam
local tile_handler = TileHandler()
local entity_handler = EntityHandler()
local object_handler = ObjectHandler()
local npc




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
    self.cam:zoom(1)
    
    window:init()

    -- Create a Player --
    my_player = Player({x = 200, y = 100, w = 32, h = 32, health = 100, speed = 500, can_collide = true}, object_handler)
    --entity_handler:addEntity(my_player)

    -- Create an Enemy --
    my_enemy = Enemy({x = 150, y = 100, w = 32, h = 32, can_collide = true}, object_handler)
    --entity_handler:addEntity(my_enemy)

    -- Create a bottom border for collision detection --
    bottom_border_platform = Object({x = 200, y = self.window_height-60, w = 32, h = 32, can_collide = true}, object_handler)

    -- Create Test NPC --
    npc = NPC({x = 400, y = self.window_height-60, can_collide = false}, object_handler)

    -- Create Test Item --
    item = Item({x = 450, y = self.window_height-60, can_collide = false}, object_handler)


    -- Test Timer --
    my_timer = Timer(200)
    -- Test Midi Trigger --
    midi_trigger = MidiTrigger()

    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    Num = 0

    --midi_file = "sounds/Asgore/midi_training.csv"
    midi_file = "sounds/song1.csv"
    midi_hash = midiFileHandler:readMidi(midi_file)

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
    --song:play()
    music = false

    -- variable that keeps track of rectangles that have spawed --
    last_call = 0

    -- Physics --
    gravity = 2000
    mass = 1
    force = gravity * mass

    -- Add tiles --
    tile_handler:addTiles(self.window_height, self.window_width)
    tile_handler:createTileObjects(object_handler)

    

    
    
end

function DevRoomState:update(dt)

    if self.jump_key == true then
        print("Jumping")
    end

    --------------------
    -- test for timer
    if my_timer.running then
        my_timer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if music == false then
        my_timer:start()
        music = true
     end


    -- Test Player
    my_player:updateVelocity(dt)
    my_player:update()
    my_player:updateMove(dt, gravity, object_handler)
    my_player:updatePhysics(self.window_width, self.window_height, object_handler)
    

    -- Test Enemy --
    my_enemy:updateVelocity(dt, my_player)
    my_enemy:update()
    my_enemy:updateMove(dt, gravity, object_handler)
    my_enemy:updatePhysics(self.window_width, self.window_height, object_handler)

    -- Test NPC --
    npc:hoverInteraction(object_handler, my_player)

    -- Test Item --
    item:hoverInteraction(object_handler, my_player)

    
    
    

    -- Update player physics --

    

     -- Move Player --
     

     -- Update Collision --
     --object_handler:update(dt)


    -- Trigger midi notes --
    midi_pitch = midi_trigger:findNote(midi_hash, my_timer.elapsedTime, 1)
    if not (midi_pitch == 'No Notes') and shape_handler.cir_spawned == false then
        shape_handler:addCircle(SpawnCircle(my_enemy.x + my_enemy.w /2, my_enemy.y + my_enemy.h / 2, 1, 1-(last_call/250), last_call/250, Timer(1)))
        last_call = last_call + 1
        shape_handler.cir_spawned = true
        my_player.deflected = false
    elseif midi_pitch == 'No Notes' then
        shape_handler.cir_spawned = false
    end
    latest_circle = shape_handler.cir_shape_table[1]
    latest_circle_idx = #shape_handler.cir_shape_table
    -- Make every circle move --
    for key, pair in ipairs(shape_handler.cir_shape_table) do

        local shape_hit = false

        current_shape = shape_handler.cir_shape_table[key]
        current_shape.lifespanTimer:update(dt)
        
        local start_allowance_timer = .1
        local end_allowance_timer = .5
        
        
        
        -- Debug --

        if not current_shape == latest_circle then
            goto continue
        end

        if current_shape.after_contact == false then
            shape_handler:setVelocity(current_shape, current_shape.x, my_player.centerX, current_shape.y, my_player.centerY, current_shape.lifespanTimer:getRemainingTimeFloat())
        end
        if current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and current_shape.after_contact == false then
            current_shape.after_contact = true
            current_shape.lifespanTimer:addTime(end_allowance_timer)
            
            goto continue

        elseif current_shape.lifespanTimer:getRemainingTimeFloat() <= start_allowance_timer and current_shape.after_contact == false and my_player.deflect == true then
            table.remove(shape_handler.cir_shape_table, key)
            my_player.deflected = true
            
            goto continue

        elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() > 0 and my_player.deflect == true then
            table.remove(shape_handler.cir_shape_table, key)
            my_player.deflected = true
            
            goto continue
        elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and my_player.deflect == false then
            table.remove(shape_handler.cir_shape_table, key)
            
            my_player:takeDamage(1)
            goto continue
        end

        

        --if (((current_shape.x >= my_player.x) and (current_shape.x <= my_player.x + my_player.w)) and ((current_shape.y >= my_player.y) and current_shape.y <= my_player.y + my_player.h)) then
        --    my_player:takeDamage(1)
        --    table.remove(shape_handler.cir_shape_table, key)
        --    goto continue
        --end


        if #shape_handler.cir_shape_table >= 1 then
            current_shape_x = current_shape.x + current_shape.velocityX * dt
            current_shape_y = current_shape.y + current_shape.velocityY * dt
        end
        shape_handler.cir_shape_table[key].x = current_shape_x
        shape_handler.cir_shape_table[key].y = current_shape_y
        ::continue::


        
    end
    

    -- Camera Update --
    self.cam:lookAt(my_player.x + my_player.w / 2, my_player.y + my_player.h / 2)

    if self.cam.x < self.window_width / 2 then
        self.cam.x = self.window_width / 2
    end

    if self.cam.y < self.window_height / 2 or self.cam.y > self.window_height / 2 then
        self.cam.y = self.window_height / 2
    end

    

    
    my_player.deflect = false
    my_player.interact = false

    
    
    

end


function DevRoomState:draw()

    -- Camera --
   self.cam:attach()
   -- Test Player --
   love.graphics.setColor(1, 1, 1)
   --my_player:draw()
   love.graphics.setColor(1,0,0)
   --my_enemy:draw()
   love.graphics.setColor(1,1,1,.4)
   bottom_border_platform:draw()
   love.graphics.setColor(1,1,1, .8)
   -- Tile Map --
   tile_handler:draw(self.window_height)

   --npc:draw()
  -- item:draw()

  for i, obj in ipairs(object_handler.object_table) do
    obj:draw()
  end

   -- Circle Draw --
   shape_handler:draw()
   
   self.cam:detach()


   -- Goal rectangle --
   --love.graphics.setColor(1, 1, 1)
   --love.graphics.rectangle("fill", goal_rect.x, goal_rect.y, goal_rect.width, goal_rect.height)
   
   love.graphics.setColor(255, 0, 0)
   love.graphics.print(Num, 0, 0)
   
   --love.graphics.print(midi_pitch, 60, 20)
   love.graphics.print(my_timer:getRemainingTime(), 20, 20)
   love.graphics.print("Health: " .. my_player.health, self.window_width - 100, 50)
 
   if my_timer:isFinished() then
       love.graphics.print("Timer finished!", 10, 30)
   end

   -- Draw rectangle from midi --
   

   
   --print(#shape_handler.shape_table)
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
        my_player.yvel = my_player.jump_vel
        
    end

    if key == "j" then
        my_player.deflect = true
    end

    if key == "k" then
        my_player.interact = true
    end

    if key == "p" then
        debug_print = true
    end
end
