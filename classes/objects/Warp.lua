local Class = require("libraries.hump-master.class")
local Gamestate = require "libraries.hump-master.gamestate"

-- Local Imports --
require('classes.objects.Object')
require('helper_functions.mysplit')

-- Parent class Object --
Warp = Class { __includes = Interactable }

function Warp:init(params, object_handler)
    Interactable.init(self, params, object_handler)

    self.warp_tag = params.warp_tag or nil
    self.warping = false
    self.type = "Warp"
end


function Warp:update(dt, state)

  Interactable.update(self, dt, state)
  if self.warping == true then
    print(self.warp_tag)
    state:warp(self.warp_tag)
    self.warping = false
  end

  
  
end


function Warp:interact(my_player)

  --Teleport Player / Gamestate Switch--
  self.warping = true
  
  if my_player.interact == false or self.hovering == false then
    goto continue
  end

  self.interacted = true
  
  ::continue::
  my_player.interact = false
  self.interacted = false
end


