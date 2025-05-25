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

local sti = require('libraries.Simple-Tiled-Implementation.sti')
-- Camera --
local Camera = require("libraries.STALKER-X.Camera")


local level = "Level2"

local tile_handler = TileHandler()


Level2 = BaseState.new()
function Level2:init()
  print("Level: 2")
  local self = BaseState.new()                   -- Call the BaseState constructor
  setmetatable(self, { __index = Level2 }) -- Set metatable to 
  return self
end

function Level2:enter(prev, persistent)
  self.game_map = sti('assets/Aseprite/TileMap/level_2.lua')

  BaseState.enter(self, persistent, level)

  for _, obj in ipairs(self.object_handler.object_table) do
    if obj.tag == 'object' then
      table.remove(self.object_handler.object_table, obj.id)
    end
  end

  -- Spawn Player at Spawn Tile --
  for _, obj in ipairs(self.object_handler.object_table) do
    if obj.tag == 'player_spawn' then
      spawn_tile = obj
    end
  end

  self.my_player.x = spawn_tile.x
  self.my_player.y = spawn_tile.y

  
  
  self.debug_mode = false
  -- Create a render target
  self.canvas = love.graphics.newCanvas(self.window_width, self.window_height)

  
  self.cam = Camera(0, 0, self.window_width, self.window_height)
  self.cam:setFollowLerp(0.2)
  self.cam:setFollowLead(0)
  self.cam:setFollowStyle('PLATFORMER')
  self.cam.scale = 2;
  
end

function Level2:update(dt)
  BaseState.update(self, dt, level)


  for _, obj in ipairs(self.object_handler.object_table) do
    obj:update(dt, self)
  end
  
  self.cam:update(dt)
  self.cam:follow((self.my_player.x + self.my_player.w / 2), (self.my_player.y + self.my_player.h / 2))
  self.my_player.deflect = false
  self.my_player.interact = false


end

function Level2:draw()
  BaseState.draw(self)
  love.graphics.setCanvas(self.canvas)
  love.graphics.clear(0, 0, 0, 0)

  -- Camera --
  self.cam:attach()

  love.graphics.setColor(1, 1, 1, 1)
  self.game_map:drawLayer(self.game_map.layers["Tile Layer 1"])
  self.game_map:drawLayer(self.game_map.layers["Spawn"])
  self.game_map:drawLayer(self.game_map.layers["Object"])
  
  for i, obj in ipairs(self.object_handler.object_table) do
    obj:draw()
  end

  self.cam:detach()



  love.graphics.setCanvas()

  love.graphics.setColor(1, 1, 1)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(self.canvas, 0, 0, 0, self.scale_factor, self.scale_factor)
  love.graphics.setBlendMode("alpha")

end

function Level2:keypressed(key)
  BaseState.keypressed(self, key)
end

function Level2:keyreleased(key)
  BaseState.keyreleased(self, key)

  if key == "space" then
    self.my_player.yvel = self.my_player.jump_vel
  end

  
  if key == "=" then
    -- GameState --
    local Gamestate = require "libraries.hump-master.gamestate"
    require("states.Level2")

    Gamestate.switch(Level1, self.window, self.my_player)
  end
end


return Level2
