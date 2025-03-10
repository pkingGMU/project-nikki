local Class = require("libraries.hump-master.class")

-- Local Imports --


TileHandler = Class()

local width_tiles
local height_tiles


function TileHandler:init()
    self.tile_map = nil
end



function TileHandler:addTiles(map --[[table]])

    

    

end

function TileHandler:draw()

    

    self.tile_map = {
        {1,1,1,1,1},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0},
        {1,0,0,0,0}

    }

    for y=1, #self.tile_map do
		for x=1, #self.tile_map[y] do
			if self.tile_map[y][x] == 1 then
				love.graphics.rectangle("line", (x * 32) - 32, (y * 32) - 32, 32, 32)
			end
		end
	end

end