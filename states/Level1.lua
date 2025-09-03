require("states.BaseState")

-- Local imports --
local sti = require("libraries.Simple-Tiled-Implementation.sti")
-- Camera --
local Camera = require("libraries.STALKER-X.Camera")

-- GameState --
local Gamestate = require("libraries.hump-master.gamestate")

-- Tile Handler
require("classes.spawn-objects.TileHandler")

-- Dump
require("helper_functions.dump")

Level1 = BaseState.new()
function Level1:init()
	local self = BaseState.new() -- Call the BaseState constructor
	setmetatable(self, { __index = Level1 }) -- Set metatable to DevRoomState
	return self
end

function Level1:enter(prev, persistent)
	-- TEMP object lists
	self.object_handler = {
		active_objects = {},
		inactive_objects = {},
	}

	self.game_map = sti("assets/Aseprite/TileMap/level_1.lua")

	BaseState.enter(self, persistent)

	self.canvas = love.graphics.newCanvas(self.config.WINDOW_WIDTH, self.config.WINDOW_HEIGHT)

	self.cam = Camera(0, 0, self.config.WINDOW_WIDTH, self.config.WINDOW_HEIGHT)
	self.cam:setFollowLerp(0.2)
	self.cam:setFollowLead(0)
	self.cam:setFollowStyle("PLATFORMER")
	self.cam.scale = 1

	--Using STI to either Create a new map state file or read in an existing map state file
	tile_handler = TileHandler()
	local map_state = tile_handler:addMapTiles(self.game_map, self.object_handler)

	--Create Game Objects
	for key, layer in pairs(map_state) do
		if key == "Item" then
		elseif key == "Spawn" then
		end
	end

	--TODO--Serialize.saveToFile(persistence_file_name, self.map_state)
end

function Level1:update(dt)
	BaseState.update(self, dt)

	self.cam:update(dt)
	self.cam:follow(0, 0)
	--self.cam:follow((self.my_player.x + self.my_player.w / 2), (self.my_player.y + self.my_player.h / 2))
end

function Level1:draw()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0, 0, 0, 0)

	-- Camera --
	-- self.cam:attach()

	love.graphics.setColor(1, 1, 1, 1)
	self.game_map:drawLayer(self.game_map.layers["Tile Layer 1"])

	-- self.cam:detach()

	love.graphics.setCanvas()

	love.graphics.setColor(1, 1, 1)
	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.draw(self.canvas, 0, 0, 0, self.config.SCALE_FACTOR, self.config.SCALE_FACTOR)
	love.graphics.setBlendMode("alpha")
end

function Level1:keypressed(key)
	BaseState.keypressed(self, key)
end

function Level1:keyreleased(key)
	BaseState.keyreleased(self, key)
end

return Level1
