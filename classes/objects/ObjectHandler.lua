-- Local Imports --
local Class = require("libraries.hump-master.class")
require("states.WorldState")

ObjectHandler = Class()

local string_key

function ObjectHandler:init()
    self.object_table = {}
    self.object_idx = 0
end

function ObjectHandler:addObject(object --[[]])

    table.insert(self.object_table, object)
    self.object_idx = self.object_idx + 1
    local id = self.object_idx

    return id
    

end

function ObjectHandler:update(dt)

    
end

