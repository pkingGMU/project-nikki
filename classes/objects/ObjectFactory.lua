-- ObjectFactory.lua
local Object = require("classes.objects.Object")
local Interactable = require("classes.objects.Interactable")
local Warp = require("classes.objects.Warp")
local Enemy = require("classes.objects.Enemy")
local Tile = require("classes.objects.Tile")

local ObjectFactory = {}

-- Registry of types to classes
ObjectFactory.registry = {
    object = Object,
    interactable = Interactable,
    warp = Warp,
    enemy = Enemy,
    tile = Tile
}

function ObjectFactory.create(params, object_handler)

  
  local class = _G[params.class]
  if not class then
    class = _G[params.type]
  end

 print(params.type)

 
    
 return class(params, object_handler)
end

return ObjectFactory
