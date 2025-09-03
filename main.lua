---@diagnostic disable: need-check-nil

-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
-- main.lua
local Gamestate = require("libraries.hump-master.gamestate")
-- Load the necessary state files
local csv = require("libraries.lua-csv-master.lua.csv")

-- Local imports --
local Object = require("objects.Object")
local Serialize = require("helper_functions.serialize")
require("classes.spawn-objects.TileHandler")
require("states.Level1")
require("states.BaseWindow")
-- STI --
local sti = require("libraries.Simple-Tiled-Implementation.sti")

local state

function love.load()
	-- Hump gamestate init --
	Gamestate.registerEvents()

	-- Create Window --
	local window = BaseWindow()

	persistent = { window = window }
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
