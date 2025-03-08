---@diagnostic disable: need-check-nil
-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
-- main.lua
local Gamestate = require "libraries.hump-master.gamestate"
-- Load the necessary state files
require("states.BaseState")  -- Base state with common methods
require("states.MenuState")  -- MenuState (state for the main menu)
require("states.DevState")   -- DevState (state for development/debug mode)
local csv = require("libraries.lua-csv-master.lua.csv")


-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")
require("classes.menu.menuStateInit")
require("classes.menu.menuStateDraw")
require("classes.menu.menuStateUpdate")
require("classes.objects.Object")
require("classes.objects.Entity")




-- Gamestate variables --
--local menuState = {}
--local gameState = {}

-- Main Objects --
local menu
local game_init
local game
local myObject
local myEntity
local state

--Callback function love.load 
--Called once upon opening

function love.load()
    -- Hump gamestate init --
    Gamestate.registerEvents()
    Gamestate.push(MenuState)
    
end

state = Gamestate.current()

function state:update(dt)
    state.update(dt)
end


function love.draw()
    Gamestate.draw()
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

