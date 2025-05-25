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

local sti = require('libraries.Simple-Tiled-Implementation.sti')

-- Camera --
local Camera = require("libraries.STALKER-X.Camera")

local my_timer
local shape_handler = ShapeHandler()
local midi_trigger
local midi_hash
local midi_file
local music
local last_call
local midi_pitch
local Num
local current_shape
local current_shape_x
local current_shape_y
local window = baseWindow()
local my_enemy
local tile_handler = TileHandler()
local game_map

-- Commented out below --
local song



DevRoomState = BaseState.new()

function DevRoomState:init()
  print("DevRoomState init")
  local self = BaseState.new()                   -- Call the BaseState constructor
  setmetatable(self, { __index = DevRoomState }) -- Set metatable to DevRoomState
  return self
end

function DevRoomState:enter()
  BaseState.enter(self)
  

  -- load sti map --
  game_map = sti('assets/Aseprite/TileMap/map_1.lua')
  tile_handler:addMapTiles(game_map, self.object_handler)

  window:init()

  local spawn_tile
  
  for _, obj in ipairs(self.object_handler.object_table) do
    if obj.tag == 'player_spawn' then
      spawn_tile = obj
      print(spawn_tile.x)
    end
  end

  -- Create a Player --
  Player({ x = spawn_tile.x, y = spawn_tile.y, w = 32, h = 32, health = 100, speed = 500, can_collide = true , tag = 'player' , collide_x_offset = 15, collide_y_offset = 3, collide_w = 20, collide_h = 32}, self.object_handler)
  --self.cam:setBounds(0,0,self.target_width, self.target_height)

  -- Create an Enemy --
  my_enemy = Enemy({ x = 150, y = 100, w = 32, h = 32, can_collide = true , tag = 'test_enemy'}, self.object_handler)
  --entity_handler:addEntity(my_enemy)

  -- Create a bottom border for collision detection --
  --bottom_border_platform = Object({x = 200, y = self.window_height-60, w = 32, h = 32, can_collide = true}, object_handler)

  -- Create Test NPC --
  NPC({ x = 400, y = self.window_height - 150, can_collide = false }, self.object_handler)

  -- Create Test Item --
  Item({ x = 450, y = self.window_height - 10, can_collide = false, type = 'item' }, self.object_handler)

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

  --song = love.audio.newSource("sounds/Asgore/Asgore.mp3", "stream")
  song = love.audio.newSource("sounds/song1.mp3", "stream")
  --song:play()
  music = false

  -- variable that keeps track of rectangles that have spawed --
  last_call = 0
  -- Add tiles --
  --tile_handler:addBorderTiles(self.window_height, self.window_width)
end

function DevRoomState:update(dt)


  --------------------
  -- test for timer
  if my_timer.running then
    my_timer:update(dt)
  end
  if music == false then
    my_timer:start()
    music = true
  end


  
  -- Trigger midi notes --
  midi_pitch = midi_trigger:findNote(midi_hash, my_timer.elapsedTime, 1)
  if not (midi_pitch == 'No Notes') and shape_handler.cir_spawned == false then
    shape_handler:addCircle(SpawnCircle(my_enemy.x + my_enemy.w / 2, my_enemy.y + my_enemy.h / 2, 1,
      1 - (last_call / 250),
      last_call / 250, Timer(1)))
    last_call = last_call + 1
    shape_handler.cir_spawned = true
    self.my_player.deflected = false
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
      shape_handler:setVelocity(current_shape, current_shape.x, self.my_player.centerX, current_shape.y, self.my_player.centerY,
        current_shape.lifespanTimer:getRemainingTimeFloat())
    end
    if current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and current_shape.after_contact == false then
      current_shape.after_contact = true
      current_shape.lifespanTimer:addTime(end_allowance_timer)

      goto continue
    elseif current_shape.lifespanTimer:getRemainingTimeFloat() <= start_allowance_timer and current_shape.after_contact == false and self.my_player.deflect == true then
      table.remove(shape_handler.cir_shape_table, key)
      self.my_player.deflected = true

      goto continue
    elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() > 0 and self.my_player.deflect == true then
      table.remove(shape_handler.cir_shape_table, key)
      self.my_player.deflected = true

      goto continue
    elseif current_shape.after_contact == true and current_shape.lifespanTimer:getRemainingTimeFloat() <= 0 and self.my_player.deflect == false then
      table.remove(shape_handler.cir_shape_table, key)

      self.my_player:takeDamage(1)
      goto continue
    end

    --if (((current_shape.x >= self.my_player.x) and (current_shape.x <= self.my_player.x + self.my_player.w)) and ((current_shape.y >= self.my_player.y) and current_shape.y <= self.my_player.y + self.my_player.h)) then
    --    self.my_player:takeDamage(1)
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

  --local offset_x = (self.scale_width - self.base_width) / self.scale_factor
  --local offset_y = (self.scale_height - self.base_height) / self.scale_factor


  -- Camera Update --

  self.cam:update(dt)
  self.cam:follow((self.my_player.x + self.my_player.w / 2), (self.my_player.y + self.my_player.h / 2))
  
  --[[ if self.cam.x < self.window_width / 2 then
        self.cam.x = self.window_width / 2
    end

    if self.cam.y < self.window_height / 2 then
        self.cam.y = self.window_height / 2
    end ]]

  self.my_player.deflect = false
  self.my_player.interact = false
end

function DevRoomState:draw()
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0, 0, 0, 0)

  -- Camera --
  self.cam:attach()

  love.graphics.setColor(1, 1, 1, 1)
  game_map:drawLayer(game_map.layers["Tile Layer 1"])
  game_map:drawLayer(game_map.layers["Spawn"])
  game_map:drawLayer(game_map.layers["Object"])
  
  for i, obj in ipairs(self.object_handler.object_table) do
    obj:draw()
  end

  -- Circle Draw --
  shape_handler:draw()
  self.cam:detach()

  love.graphics.setColor(255, 0, 0)
  love.graphics.print(Num, 0, 0)

  --love.graphics.print(midi_pitch, 60, 20)
  love.graphics.print(my_timer:getRemainingTime(), 20, 20)
  love.graphics.print("Health: " .. self.my_player.health, self.window_width - 100, 50)

  if my_timer:isFinished() then
    love.graphics.print("Timer finished!", 10, 30)
  end

  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas, 0, 0, 0, self.scale_factor, self.scale_factor)
  love.graphics.setBlendMode("alpha")
end

function DevRoomState:keypressed(key)
  BaseState.keypressed(self, key)
end

function DevRoomState:keyreleased(key)
  BaseState.keyreleased(self, key)


  if key == "j" then
    self.my_player.deflect = true
  end

  if key == "k" then
    self.my_player.interact = true
  end

  if key == "p" then
    debug_print = true
  end


  if key =='d' then
  end
end
