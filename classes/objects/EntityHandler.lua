-- Local Imports --
local Class = require("libraries.hump-master.class")


EntityHandler = Class()

local string_key

function EntityHandler:init()
    self.entity_table = {}
    self.entity_idx = 0
end

function EntityHandler:addEntity(entity --[[]])

    self.entity_idx = self.entity_idx + 1
    string_key = 'entity' .. tostring(self.entity_idx)
    table.insert(self.entity_table, entity)

end

