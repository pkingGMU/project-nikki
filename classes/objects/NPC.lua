local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Interactable')
require('classes.objects.TextBox')

local text_box_w
local text_box_x
local text_box_y


-- Parent class Object --
NPC = Class { __includes = Interactable }

function NPC:init(params, objectHandler)
  Interactable.init(self, params, objectHandler)

  self.display_text = false
  self.npc_text = {}



  --NPC:addToNPCHandler(self, NPCHandler)
end

--function NPC:update()
--    Object.update(self)
--end



function NPC:firstHoverInteraction(objectHandler)
  -- Create new Text Box --
  text_box_w = 32 * 4
  text_box_y = self.y - 50
  text_box_x = self.centerX - ((text_box_w) / 2)
  self.npc_text = TextBox({ x = text_box_x, y = text_box_y, w = text_box_w, h = 32, text = "Test" }, objectHandler, self)

  self.collision_action = false
end

function NPC:interact(my_player, objectHandler)
  -- Interaction on Hover --
  if my_player.interact == true and self.hovering == true then
    print("interacted with interactable")
  end

end

function NPC:addToNPCHandler(NPC)

end

function NPC:draw()
  love.graphics.setColor(.5, 1.2, .5)
  love.graphics.rectangle("line", self.x, self.y, self.w, self.h)

  if self.hovering == true then
    self.npc_text:draw()
  end
end

function NPC:leave_collision_area(objectHandler)
  if self.hovering == true then
    --print(#objectHandler.object_table)

    self.npc_text:destroy(objectHandler)
  end
end
