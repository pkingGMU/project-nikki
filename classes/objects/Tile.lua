local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Tile = Class{__includes = Object}

function Tile:init(params, objectHandler, tileHandler)
    Object.init(self, params, objectHandler)

    Tile:addToTileHandler(self, tileHandler)

    self.type = 'tile'
end

function Tile:update(dt, state)
    Object.update(self)
end

function Tile:addToTileHandler(tile, tileHandler)

    tileHandler.tile_idx = tileHandler.tile_idx + 1
    local string_key = 'tile'.. tostring(tileHandler.tile_idx)
    table.insert(tileHandler.tile_table, tile)

end


function Tile:draw()
    
end


