local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Tile = Class{__includes = Object}

function Tile:init(params, objectHandler, tileHandler)
    Object.init(self, params, objectHandler)

    Tile:addToTileHandler(self, tileHandler)
end

function Tile:update()
    Object.update(self)
end

function Tile:addToTileHandler(tile, tileHandler)

    tileHandler.tile_idx = tileHandler.tile_idx + 1
    local string_key = 'tile'.. tostring(tileHandler.tile_idx)
    table.insert(tileHandler.tile_table, tile)
    

end


function Tile:draw()
love.graphics.rectangle("line", self.x , self.y , self.w, self.h)
end


