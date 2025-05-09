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
--require("states.MenuState")  -- MenuState (state for the main menu)
--require("states.DevState")  -- DevState (state for development/debug mode)
require("states.Level1")



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


    --Gamestate.push(DevRoomState)
    Gamestate.push(Level1)
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

