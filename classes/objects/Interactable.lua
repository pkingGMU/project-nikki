local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')

-- Parent class Object --
Interactable = Class { __includes = Object }

function Interactable:init(params, object_handler)
  Object.init(self, params, object_handler)

  self.hovering = false
  self.collision_action = false
  self.interacted = false

  self.type = 'interactable'
end

function Interactable:update(dt, state)
  --Object.update(self)

  self:hoverInteraction(state.object_handler, state.my_player)
end

function Interactable:checkCollisions(my_player, object_handler)
  local collide_list = {}
    if my_player == self or not my_player.isPlayer == true or my_player == nil or self == nil then
      
      goto continue
    end
    
    if self.x < my_player.x + my_player.w and self.x + self.w > my_player.x and self.y < my_player.y + my_player.h and self.y + self.h > my_player.y and self.hovering == false then
      table.insert(collide_list, my_player)

      print("Interacting")
      
      self.collision_action = true
      self.hovering = true

    elseif not (self.x < my_player.x + my_player.w and self.x + self.w > my_player.x and self.y < my_player.y + my_player.h and self.y + self.h > my_player.y) then
      self:leave_collision_area(object_handler)

      self.hovering = false
      self.collision_action = false
    end
  
  ::continue::


  --return collide_list
end

function Interactable:hoverInteraction(object_handler, my_player)
  self:checkCollisions(my_player, object_handler)

  if self.collision_action == false then
    goto continue
  end

  -- Interaction on first hover --

  self:firstHoverInteraction(object_handler)

  ::continue::

  -- Interaction on Hover --
  if self.hovering == true then
    self:interact(my_player, object_handler)
  end
end

function Interactable:firstHoverInteraction()
  self.collision_action = false
end

function Interactable:interact(my_player)
  
  if my_player.interact == true and self.hovering == true then
    self.interacted = true
  end

  my_player.interact = false
  self.interacted = false
end

function Interactable:leave_collision_area()

end
