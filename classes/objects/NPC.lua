local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Interactable')
require('classes.objects.TextBox')


-- Parent class Object --
NPC = Class{__includes = Interactable}

function NPC:init(params, objectHandler)
    Interactable.init(self, params, objectHandler)

    self.display_text = false
    self.npc_text = {}

    

    --NPC:addToNPCHandler(self, NPCHandler)
end

function NPC:update()
    Object.update(self)
end


function NPC:hoverInteraction(objectHandler)

    self:checkCollisions(objectHandler)

    if self.collision_action == false then
        goto continue
    end

    

    

    -- Create new Text Box --
    local text_box_w = 32 * 4
    local text_box_y = self.y - 50
    local text_box_x = self.centerX - ((text_box_w) / 2)
    self.npc_text = TextBox({x = text_box_x, y = text_box_y, w = text_box_w, h = 32, text = "Test"}, objectHandler, self)

    self.collision_action = false

    ::continue::

end

    

function NPC:addToNPCHandler(NPC)

end


function NPC:draw()

        love.graphics.setColor(.5,1.2,.5)
        love.graphics.rectangle("line", self.x , self.y , self.w, self.h)

        if self.hovering == true then
            self.npc_text:draw()
            
        end
        

    
end

function NPC:leave_collision_area(objectHandler)

    if self.hovering == true then
        print(#objectHandler.object_table)
        table.remove(objectHandler.object_table, self.npc_text.object_handler_key)
        objectHandler.object_idx = objectHandler.object_idx - 1
    end

end