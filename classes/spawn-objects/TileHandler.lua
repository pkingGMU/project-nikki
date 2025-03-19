local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.objects.ObjectHandler")
require("classes.objects.Object")
require("classes.objects.Tile")


TileHandler = Class()

local num_tiles_width
local num_tiles_height


function TileHandler:init()
    self.tile_map = {}
    self.tile_table = {}
    self.tile_idx = 0

end



function TileHandler:addTiles(screen_height, screen_width)

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

function TileHandler:createTileObjects(objectHandler)

  for y=1, #self.tile_map do
    for x=1, #self.tile_map[y] do
      if self.tile_map[y][x] == 1 then

        Tile({x = (x * 32) - 32, y = (y * 32) - 32, w = 32, h = 32, can_collide = true}, objectHandler, self)
        
        
      end
    end
  end

end

function TileHandler:draw(screen_height)

    --self.tile_map = {
      --  {1,1,1,1,1},
        --{1,0,0,0,0},
        --{1,0,0,0,0},
        --{1,0,0,0,0},
        --{1,0,0,0,0},
        --{1,0,0,0,0}

    --}

  --[[ for y=1, #self.tile_map do
    for x=1, #self.tile_map[y] do
      if self.tile_map[y][x] == 1 then
        
        love.graphics.rectangle("line", (x * 32) - 32, (y * 32) - 32, 32, 32)
      end
    end
  end ]]
  
  
  for tile_key, tile in ipairs(self.tile_table) do
      tile:draw()
  end

end