-- Global Imports --
local Class = require("libraries.hump-master.class")
local camera

-- Local Import
local LoveConfig = require("LoveConfig")

BaseWindow = Class()

function BaseWindow:init()
	local config = LoveConfig()

	love.window.setMode(config.TARGET_WIDTH, config.TARGET_HEIGHT, {
		resizable = false,
		fullscreen = false,
		vsync = 0,
		minwidth = config.WIDNOW_WIDTH,
		minheight = config.WINDOW_HEIGHT,
	})

	love.graphics.setDefaultFilter("nearest", "nearest") -- scale everything with nearest neighbor
end
