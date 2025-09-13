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

-- Draw Functions
require("objects.DrawFunctions")

-- Physics Functions
require("objects.PhysicsFunctions")

-- Player Spawn Preset
PlayerSpawn = require("objects.PlayerSpawn")

-- Collide Tile Preset
CollideTile = require("objects.CollideTile")
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
	self.cam.scale = 2

	--Using STI to either Create a new map state file or read in an existing map state file
	tile_handler = TileHandler()
	local map_state = tile_handler:addMapTiles(self.game_map, self.object_handler)

	--Create Game Objects
	for layer, value in pairs(map_state) do
		if layer == "PlayerSpawn" then
			for object, value in pairs(value) do
				if string.find(object, "PlayerSpawn") then
					self.player = PlayerSpawn(value)
					table.insert(self.object_handler.active_objects, self.player)
				end
			end
		end

		if layer == "TileCollision" then
			for tile, value in pairs(value) do
				local collide_tile = CollideTile(value)
				table.insert(self.object_handler.active_objects, collide_tile)
			end
		end
	end

	--TODO--Serialize.saveToFile(persistence_file_name, self.map_state)
end

function Level1:update(dt)
	BaseState.update(self, dt)

	self.cam:update(dt)
	self.cam:follow(0, 0)
	self.cam:follow((self.player.x + self.player.w / 2), (self.player.y + self.player.h / 2))

	-- Update Active Objects
	for objIdx, obj in ipairs(self.object_handler.active_objects) do
		if obj.name == "PlayerSpawn" then
			KeyboardMovePlayer(dt, obj)
		end

		if obj.physics then
			-- Update Physics
			UpdatePhysics(dt, obj, self.object_handler.active_objects)
		end

		if obj.animation then
			-- Update Animations
			UpdateAnimation(dt, obj)
		end
	end
end

function Level1:draw()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear(0, 0, 0, 0)

	-- Camera --
	self.cam:attach()

	love.graphics.setColor(1, 1, 1, 1)
	self.game_map:drawLayer(self.game_map.layers["Tile Layer 1"])

	for objIdx, obj in ipairs(self.object_handler.active_objects) do
		if obj.animation then
			DrawAnim(obj)
		else
			love.graphics.rectangle("line", obj.x, obj.y, obj.w, obj.h)
		end
	end

	self.cam:detach()

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

	if key == "c" then
		self.player.dash = true
	end

	if key == "space" then
		self.player.jump = true
	end
end

return Level1
