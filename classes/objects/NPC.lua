local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')
require('classes.objects.TextBox')


-- Parent class Object --
NPC = Class{__includes = Object}

function NPC:init(params, objectHandler)
    Object.init(self, params, objectHandler)

    self.display_text = false
    self.npc_text = {}

    

    --NPC:addToNPCHandler(self, NPCHandler)
end

function NPC:update()
    Object.update(self)
end

function NPC:checkCollisions(objectHandler)
    local collide_list = {}
    for other_key, other_object in ipairs(objectHandler.object_table) do
        
        if other_object == self or not other_object.isPlayer == true then
            goto continue
        end

        

        if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y and self.display_text == false then
            table.insert(collide_list, other_object)
            
            -- Create new Text Box --
            local text_box_w = 32 * 4
            local text_box_y = self.y - 50
            local text_box_x = self.centerX - ((text_box_w) / 2)
            self.npc_text = TextBox({x = text_box_x, y = text_box_y, w = text_box_w, h = 32}, objectHandler, self)

            self.display_text = true
        
        elseif not (self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y) then

            if self.display_text == true then
                print(#objectHandler.object_table)
                table.remove(objectHandler.object_table, self.npc_text.object_handler_key)
                objectHandler.object_idx = objectHandler.object_idx - 1
            end
            self.display_text = false

            
            
        end
            

            
    end

        ::continue::
        
end

    

function NPC:addToNPCHandler(NPC)

end


function NPC:draw()

        love.graphics.setColor(.5,1.2,.5)
        love.graphics.rectangle("line", self.x , self.y , self.w, self.h)

        if self.display_text == true then
            self.npc_text:draw()
            
        end
        

    
end