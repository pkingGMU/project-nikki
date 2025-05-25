-- baseState.lua
BaseState = {}
BaseState.__index = BaseState


require("states.baseWindow")


-- WorldState --
local WorldState = require("states.WorldState")
local ObjectFactory = require("classes.objects.ObjectFactory")

-- Deepcopy Util --
require("helper_functions.deepcopy")

function BaseState.new()
    local self = setmetatable({}, BaseState)
    self.game = nil
    self.b_down = false
    self.a_down = false
    self.s_down = false
    self.w_down = false
    self.d_down = false
    self.jump_key = false
    self.c_down = false
    self.window_height = nil
    self.window_width = nil
    return self
end

function BaseState:init()
    print("BaseState init")
end

function BaseState:enter(persistent, level)


  

    -- init object handler --
  self.object_handler = persistent.object_handler

  -- init player --
  self.my_player = persistent.player
  -- init window --
  self.window = persistent.window
  
  
  
  print(level)
  -- Reset Current World State --
  WorldState[level].current.objects = {}

  -- Create Default Objects --
  for _, obj_params in ipairs(WorldState[level].default.objects) do
    local instance = ObjectFactory.create(obj_params, self.object_handler)

    
    table.insert(WorldState[level].current.objects, instance)
  end

    --window sizes--
  self.window_height = self.window.window_height
  self.window_width = self.window.window_width
  self.scale_factor = self.window.scale_factor
  
  self.target_width = self.window.target_width
  self.target_height = self.window.target_height

    -- Physics --
  self.gravity = 2000

  -- Create Current List to Reference --
  WorldState[level].current.objects = deepcopy(WorldState[level].default.objects)

end


function BaseState:update(dt)
  if self.debug_key == true and self.debug_mode == false then
    print("Debug Mode On")
    self.debug_mode = true
    self.debug_key = false
  elseif self.debug_key == true and self.debug_mode == true then
    print("Debug Mode Off")
    self.debug_mode = false
    self.debug_key = false
  end
end

function BaseState:draw()

end

function BaseState:keypressed(key)

    if key == 'b' then
        self.b_down = false
    end

    if key == 'a' then
        self.a_down = false
    end

    if key == 's' then
        self.s_down = false
    end

    if key == 'd' then
        self.d_down = false
    end

    if key == 'w' then
        self.w_down = false
    end

    if key == "space" then
        
    end

    if key == 'c' then
        self.c_down = false
    end
    
end

function BaseState:keyreleased(key)

    if key == "space" then
    self.my_player.yvel = self.my_player.jump_vel
  end

  
    if key == 'b' then
        self.b_down = true
    end

    if key == 't' then
        self.t_down = true
    end

    if key == 'c' then
      self.my_player.dash = true
    end


    if key == 'a' then
        self.a_down = true
    end

    if key == 's' then
        self.s_down = true
    end

    if key == 'd' then
      self.d_down = true
      self.debug_key = true

    end

    if key == 'w' then
        self.w_down = true
    end

    
    if key == 'c' then
        self.c_down = true
    end
    
end

function BaseState:mousepressed(mx, my, mbutton)
    
end

function BaseState:mousereleased(mx, my, mbutton)
    
end

function BaseState:warp(state)
  local Gamestate = require("libraries.hump-master.gamestate")
  Level2 = require("states.Level2")
  Level1 = require("states.Level1")

  local temp_table = {}
  
  -- remove everything except persistent objects --
  for i, obj in ipairs(self.object_handler.object_table) do
    if obj.tag == 'player' then
      table.insert(temp_table, obj)
    end
  end

  print(#temp_table .. "number in temp table")
  self.object_handler.object_table = temp_table

  
    local persistent = {
      window = self.window,
      player = self.my_player,
      object_handler = self.object_handler
    }
  
  return Gamestate.switch(_G[state], persistent)
  
end
