local Class = require("libraries.hump-master.class")

-- Local Imports --
local PlayerSpawn = require("objects.PlayerSpawn")

local Serialize = require("helper_functions.serialize")

TileHandler = Class()

local num_tiles_width
local num_tiles_height

-- WorldState --

-- Obj Constructor --
-------------------------------------------------------------------------------
local ObjectConstructors = {
	PlayerSpawn = PlayerSpawn,
	EnemySpawn = EnemySpawn,
	ItemSpawn = ItemSpawn,
}

function TileHandler:init()
	self.tile_map = {}
	self.tile_idx = 0
end

function TileHandler:addMapTiles(game_map)
	map_name = game_map.class
	local map_state = {}
	-- Check if persistence file exists
	persistence_file_name = ("persistence/" .. map_name .. ".json")
	-- if file_exists(persistence_file_name) then
	-- 	map_state = Serialize.loadFromFile(persistence_file_name)
	-- 	return map_state
	-- else

	for layer_idx, layer in ipairs(game_map.layers) do
		if layer then
			local layer_state = {}
			if layer.type == "objectgroup" then
				for obj_idx, obj in pairs(layer.objects) do
					local constructor = ObjectConstructors[obj.name]
					if constructor then
						local instance = constructor(obj)
						layer_state[obj.name] = copyNoCyclesNoFunctions(instance)
					end
				end
			end

			map_state[layer.name] = layer_state
		end
	end
	-- end

	Serialize.saveToFile(persistence_file_name, map_state)
	return map_state
end

function file_exists(filename)
	local f = io.open(filename, "r")
	if f ~= nil then
		io.close(f)

		return true
	else
		return false
	end
end

function copyNoCyclesNoFunctions(obj, seen)
	seen = seen or {}
	if type(obj) ~= "table" then
		if type(obj) == "function" or type(obj) == "userdata" then
			return nil
		else
			return obj
		end
	end
	if seen[obj] then
		return nil
	end
	seen[obj] = true

	local t = {}
	for k, v in pairs(obj) do
		if type(k) ~= "function" or type(k) ~= "userdata" then
			local val = copyNoCyclesNoFunctions(v, seen)
			if val ~= nil then
				t[k] = val
			end
		end
	end
	return t
end
