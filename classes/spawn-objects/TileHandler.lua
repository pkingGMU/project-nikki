local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.objects.ObjectHandler")
require("classes.objects.Object")
require("classes.objects.Tile")
require("classes.objects.Warp")

TileHandler = Class()

local num_tiles_width
local num_tiles_height

-- WorldState --
local WorldState = require("states.WorldState")
local ObjectFactory = require("classes.objects.ObjectFactory")


function TileHandler:init()
    self.tile_map = {}
    self.tile_table = {}
    self.tile_idx = 0

end



function TileHandler:addBorderTiles(screen_height, screen_width)

  num_tiles_height = math.floor(screen_height / 32) + 1
  num_tiles_width = math.floor(screen_width / 32)

  print(num_tiles_height - 3)


  for y_tile=1, num_tiles_height do

    local temp_table = {}

    for x_tile=1, num_tiles_width do

      if y_tile == 1 or y_tile == num_tiles_height then
          table.insert(temp_table, 1)

      elseif x_tile == 1 or x_tile == num_tiles_width then
          table.insert(temp_table, 1)
      else
          table.insert(temp_table, 0)
      end



      
    end

    table.insert(self.tile_map, temp_table)

  end

end

function TileHandler:addMapTiles(game_map, objectHandler, level)
  for type_idx, tile_type in pairs(game_map.tileInstances) do
    if game_map.tileInstances[type_idx] == nil then
      goto continue
    end
    for tile_idx, tile in pairs(game_map.tileInstances[type_idx]) do
      local env_tile = game_map.tileInstances[type_idx][tile_idx]

      if env_tile.layer.name == 'Object' then

      elseif env_tile.layer.name == 'Spawn' then
	print('Spawn Tile')
        --Tile({x = env_tile.x, y = env_tile.y, w = 32, h = 32, can_collide = false, tag = 'player_spawn'}, objectHandler, self)
        local obj_params = {class = "Tile", type = "Tile", x = env_tile.x, y = env_tile.y, w = 32, h = 32, can_collide = false, tag = 'player_spawn', soft_reset = true}
        local instance = ObjectFactory.create(obj_params, objectHandler)
        table.insert(WorldState[level].default.objects, instance)
        
      else
        --Tile({x = env_tile.x, y = env_tile.y, w = 32, h = 32, can_collide = true}, objectHandler, self)
        local obj_params = {class = "Tile", type = "Tile", x = env_tile.x, y = env_tile.y, w = 32, h = 32, can_collide = true, soft_reset = true}
        local instance = ObjectFactory.create(obj_params, objectHandler)
        table.insert(WorldState[level].default.objects, instance)

      end
    end
      ::continue::
  end

  for tile_idx, tile_type in pairs(game_map.objects) do
    if tile_type == nil then
      goto continue
    end

    if tile_type.name == 'BR_Corner_Grass' then
      --Interactable({x = tile_type.x, y = tile_type.y - 32, w = 32, h = 32, can_collide = true, tag = 'BR_Corner_Grass', persistent = true}, objectHandler, self)
      local obj_params = {class = "Interactable", type = "Interactable", x = tile_type.x, y = tile_type.y - 32, w = 32, h = 32, can_collide = true, tag = 'BR_Corner_Grass', soft_reset = true}
      local instance = ObjectFactory.create(obj_params, objectHandler)
      table.insert(WorldState[level].default.objects, instance)

    elseif tile_type.name == 'TR_Corner_Grass' then
      print('TR')
    elseif string.find(tile_type.name, 'Level') then
      --Warp({x = tile_type.x, y = tile_type.y - 32, w = 32, h = 32, can_collide = false, tag = 'warp', warp_tag = tile_type.name, persistent = true}, objectHandler, self)
      local obj_params = {class = "Warp", type = "Warp", x = tile_type.x, y = tile_type.y - 32, w = 32, h = 32, can_collide = false, tag = 'warp', warp_tag = tile_type.name, soft_reset = true}
      local instance = ObjectFactory.create(obj_params, objectHandler)
      table.insert(WorldState[level].default.objects, instance)
    end
    ::continue::
  end

    ::continue::
end


function TileHandler:draw(screen_height)

  
  for tile_key, tile in ipairs(self.tile_table) do
      tile:draw()
  end

end
