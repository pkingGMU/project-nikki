-- baseState.lua
BaseState = {}
BaseState.__index = BaseState

local Gamestate = require("libraries.hump-master.gamestate")
-- Inspection --
require("helper_functions.dump")

-- Local Import
local LoveConfig = require("LoveConfig")

function BaseState.new()
	local self = setmetatable({}, BaseState)
	return self
end

function BaseState:init() end

function BaseState:enter(persistent, level)
	-- Set generic state love config
	self.config = LoveConfig()
end

function BaseState:update(dt, level) end

function BaseState:draw() end

function BaseState:SoftReset() end

function BaseState:HardReset() end

function BaseState:keypressed(key) end

function BaseState:keyreleased(key) end

function BaseState:mousepressed(mx, my, mbutton) end

function BaseState:mousereleased(mx, my, mbutton) end
