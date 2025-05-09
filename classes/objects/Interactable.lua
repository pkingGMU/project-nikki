local Class = require("libraries.hump-master.class")


-- Local Imports --
require('classes.objects.Object')
require('helper_functions.mysplit')

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

  local cur_obj_x = self.x + self.collide_x_offset
  local cur_obj_y = self.y + self.collide_y_offset
  local cur_obj_w = self.collide_w
  local cur_obj_h = self.collide_h

  local other_obj_x = my_player.x + my_player.collide_x_offset
  local other_obj_y = my_player.y + my_player.collide_y_offset
  local other_obj_w = my_player.collide_w
  local other_obj_h = my_player.collide_h
    if my_player == self or not my_player.isPlayer == true or my_player == nil or self == nil then
      
      goto continue
    end
    
    if cur_obj_x < other_obj_x + other_obj_w and cur_obj_x + cur_obj_w > other_obj_x and cur_obj_y < other_obj_y + other_obj_h and cur_obj_y + cur_obj_h > other_obj_y and self.hovering == false then
      table.insert(collide_list, my_player)

      print("Interacting")
      
      self.collision_action = true
      self.hovering = true

    elseif not (cur_obj_x < other_obj_x + other_obj_w and cur_obj_x + cur_obj_w > other_obj_x and cur_obj_y < other_obj_y + other_obj_h and cur_obj_y + cur_obj_h > other_obj_y) then
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

  self:firstHoverInteraction()

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
  
  if my_player.interact == false or self.hovering == false then
    goto continue
  end

  self.interacted = true
  
  ::continue::
  my_player.interact = false
  self.interacted = false
end

function Interactable:leave_collision_area()

end


