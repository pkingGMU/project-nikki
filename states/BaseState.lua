-- baseState.lua
BaseState = {}
BaseState.__index = BaseState


require("states.baseWindow")


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

function BaseState:enter(window)

    --window sizes--
  self.window_height = window.window_height
  self.window_width = window.window_width
  self.scale_factor = window.scale_factor
  
  self.target_width = window.target_width
  self.target_height = window.target_height

    -- Physics --
  self.gravity = 2000

  
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
  print(_G[state])
  return Gamestate.switch(_G[state], self.window, self.my_player)
  --if state == 'Level1' then
  --  Gamestate.switch(Level1, self.my_player, self.window)

--  elseif state == 'Level2' then
  --  Gamestate.switch(Level2, self.my_player, self.window)
  --end
end
