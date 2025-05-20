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
