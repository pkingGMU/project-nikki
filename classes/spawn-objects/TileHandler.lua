local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.objects.ObjectHandler")
require("classes.objects.Object")
require("classes.objects.Tile")
require("classes.objects.Warp")

local Serialize = require("helper_functions.serialize")

TileHandler = Class()

local num_tiles_width
local num_tiles_height

-- WorldState --
local WorldState = require("states.WorldState")

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
	-- 	print(map_state.Item.TEST_ITEM.id)
	-- 	return map_state
	-- else
	-- 	print("Creating Map")

	for layer_idx, layer in ipairs(game_map.layers) do
		if layer then
			local layer_state = {}
			print(layer.type)
			if layer.type == "objectgroup" then
				print("here")
				for obj_idx, obj in pairs(layer.objects) do
					layer_state[obj.name] = {
						w = obj.width,
						h = obj.height,
						x = obj.x,
						y = obj.y,
						id = obj.id,
						rotation = obj.rotation,
						shape = obj.shape,
						type = obj.type or "none",
						visible = obj.visible,
						gid = obj.gid,
					}
				end
			end

			map_state[layer.name] = layer_state
		end
	end
	-- end

	Serialize.saveToFile(persistence_file_name, map_state)
	return map_state
end
-- 	for tile_idx, tile_type in pairs(game_map.objects) do
-- 		if tile_type == nil then
-- 			goto continue
-- 		end
-- 		if tile_type.name == "BR_Corner_Grass" then
-- 			local obj_params = {
-- 				class = "Interactable",
-- 				type = "Interactable",
-- 				level = level,
-- 				x = tile_type.x,
-- 				y = tile_type.y - 32,
-- 				w = 32,
-- 				h = 32,
-- 				can_collide = true,
-- 				tag = "BR_Corner_Grass",
-- 				soft_reset = true,
-- 			}
-- 		elseif string.find(tile_type.name, "Level") then
-- 			--Warp({x = tile_type.x, y = tile_type.y - 32, w = 32, h = 32, can_collide = false, tag = 'warp', warp_tag = tile_type.name, persistent = true}, objectHandler, self)
-- 			local obj_params = {
-- 				class = "Warp",
-- 				type = "Warp",
-- 				level = level,
-- 				x = tile_type.x,
-- 				y = tile_type.y - 32,
-- 				w = 32,
-- 				h = 32,
-- 				can_collide = false,
-- 				tag = "warp",
-- 				warp_tag = tile_type.name,
-- 				soft_reset = true,
-- 			}
-- 		elseif string.find(tile_type.name, "Item") then
-- 			local obj_params = {
-- 				class = "Item",
-- 				type = "Item",
-- 				level = level,
-- 				x = tile_type.x,
-- 				y = tile_type.y - 32,
-- 				w = 32,
-- 				h = 32,
-- 				can_collide = false,
-- 				tag = "item",
-- 				warp_tag = tile_type.name,
-- 				soft_reset = false,
-- 			}
-- 		end
-- 		::continue::
-- 	end

-- 	::continue::
-- end

function file_exists(filename)
	local f = io.open(filename, "r")
	if f ~= nil then
		io.close(f)

		return true
	else
		return false
	end
end

function stripObject(obj)
	local clean = {}
	for k, v in pairs(obj) do
		if type(v) ~= "function" and type(v) ~= "userdata" then
			clean[k] = v
			print(tostring(k) .. tostring(v))
		end
	end
	return clean
end
