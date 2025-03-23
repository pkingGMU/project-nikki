local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Interactable = Class{__includes = Object}

function Interactable:init(params, objectHandler)
    Object.init(self, params, objectHandler)

    self.hovering = false
    self.collision_action = false
end

function Interactable:checkCollisions(objectHandler)

    local collide_list = {}
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self or not other_object.isPlayer == true then
            goto continue
        end

        

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y and self.hovering == false then
            table.insert(collide_list, other_object)

            self.collision_action = true
            self.hovering = true
        
        elseif not (self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y) then

            if self.hovering == true then
                print(#objectHandler.object_table)
                table.remove(objectHandler.object_table, self.npc_text.object_handler_key)
                objectHandler.object_idx = objectHandler.object_idx - 1
            end
            self.hovering = false
            self.collision_action = false

            
            
        end
            

            
    end

        ::continue::
        
        --return collide_list
end