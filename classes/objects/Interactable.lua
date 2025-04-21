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
  self:hoverInteraction(state.object_handler, state.my_player)
end

function Interactable:checkCollisions(object_handler)
  local collide_list = {}
  for other_key, other_object in ipairs(object_handler.object_table) do
    if other_object == self or not other_object.isPlayer == true or other_object == nil or self == nil then
      goto continue
    end



    if self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y and self.hovering == false then
      table.insert(collide_list, other_object)

      self.collision_action = true
      self.hovering = true
    elseif not (self.x < other_object.x + other_object.w and self.x + self.w > other_object.x and self.y < other_object.y + other_object.h and self.y + self.h > other_object.y) then
      self:leave_collision_area(object_handler)

      self.hovering = false
      self.collision_action = false
    end
  end

  ::continue::


  --return collide_list
end

function Interactable:hoverInteraction(object_handler, my_player)
  self:checkCollisions(object_handler)

  if self.collision_action == false then
    goto continue
  end

  -- Interaction on first hover --

  self:firstHoverInteraction(object_handler)

  ::continue::

  -- Interaction on Hover --

  self:interact(my_player, object_handler)
end

function Interactable:firstHoverInteraction(object_handler)
  print("sitting in item")
  self.collision_action = false
end

function Interactable:interact(my_player, object_handler)
  if my_player.interact == true and self.hovering == true then
    self:interact()
    self.interacted = true
  end

  my_player.interact = false
  self.interacted = false
end

function Interactable:leave_collision_area(object_handler)

end
