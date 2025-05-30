---@diagnostic disable: need-check-nil

-- Debug --
--if arg[2] == "debug" then
--    require("lldebugger").start()
--end

-- LUME Debug tables --
--local lume = require "lume/lume.lua"


-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
-- main.lua
local Gamestate = require "libraries.hump-master.gamestate"
-- Load the necessary state files
require("states.BaseState")  -- Base state with common methods
require("states.MenuState")  -- MenuState (state for the main menu)
require("states.DevState")  -- DevState (state for development/debug mode)
require("states.Level1")
require("states.baseWindow") -- Base Window
local csv = require("libraries.lua-csv-master.lua.csv")




-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")
require("classes.objects.Object")
require("classes.objects.Entity")

-- STI --
local sti = require('libraries.Simple-Tiled-Implementation.sti')

-- Tile Handler --
require("classes.spawn-objects.TileHandler")
local tile_handler = TileHandler()




-- Gamestate variables --
--local menuState = {}
--local gameState = {}

-- Main Objects --
local state

--Callback function love.load 
--Called once upon opening

function love.load()

  -- Hump gamestate init --
  Gamestate.registerEvents()

  -- Load Object Handler --
  local object_handler = ObjectHandler()

  -- Load Map Information --
  local level_maps = {
    level1 = {
      map = sti('assets/Aseprite/TileMap/level_1.lua'),
      name = 'Level1'
    },
    
    level2 = {
      map = sti('assets/Aseprite/TileMap/level_2.lua'),
      name = 'Level2'
    }
  }

  
  for _, level in pairs(level_maps) do
    tile_handler:addMapTiles(level.map, object_handler, level.name)
  end

  

  -- Load Player --
  local player = Player({ x = nil, y = nil, w = 32, h = 32, health = 100, speed = 500, can_collide = true , tag = 'player' , collide_x_offset = 12, collide_y_offset = 3, collide_w = 10, collide_h = 29}, object_handler)

  -- Load Window --
  local window = baseWindow()

  
  -- Persistent variables --
  
  local persistent = {
    window = window,
    player = player,
    object_handler = object_handler
  }
    
  --Gamestate.push(DevRoomState)
  Gamestate.switch(Level1, persistent)
end



state = Gamestate.current()

function state:update(dt)
    state.update(dt)
end

function state:draw(dt)
    state.draw(dt)
end

function love.keypressed(key)
    Gamestate.keypressed(key)
end

function love.keyreleased(key)
    Gamestate.keyreleased(key)
end

function love.mousepressed(mx, my, mbutton)
    Gamestate.mousepressed(mx, my, mbutton)
end

function love.mousereleased(mx, my, mbutton)
    Gamestate.mousereleased(mx, my, mbutton)
end

----------------------------------------- MENU ----------------------------------------------

