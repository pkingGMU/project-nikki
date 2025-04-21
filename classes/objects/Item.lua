local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Interactable')

-- Parent class Object --
Item = Class { __includes = Interactable }

function Item:init(params, objectHandler)
  Interactable.init(self, params, objectHandler)
end

function Item:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end



function Item:firstHoverInteraction()
  print("sitting in item")

  self.collision_action = false
end

function Item:interact(my_player, objectHandler)
  -- Interaction on Hover --
  if my_player.interact == true and self.hovering == true then
    self.interacted = true

    --table.insert(my_player.inventory, self)
    print("Added item to inventory" .. #my_player.inventory)

    my_player:addToInventory(self)

    -- Last thing to do
    self:destroy(objectHandler)
  end
end
