-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Tile = Class{__includes = Object}

function Tile:init(params)
    Object.init(self, params)
end

function Tile:update()
    Object.update(self)
end


