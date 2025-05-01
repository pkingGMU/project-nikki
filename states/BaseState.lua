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
    self.window = baseWindow()
    self.window_height = nil
    self.window_width = nil
    return self
end

function BaseState:init()
    
    print("BaseState init")

end


function BaseState:enter()
    print("BaseState enter")

    --window sizes--
    self.window:init()
    self.window_height = self.window.window_height
    self.window_width = self.window.window_width
    self.scale_factor = self.window.scale_factor

    self.target_width = self.window.target_width
    self.target_height = self.window.target_height

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

    local point_size = 1

    -- tlfres --
    --TLfres.beginRendering(self.window_width, self.window_height)
    --love.graphics.setPointSize(TLfres.getScale()*point_size) -- Point size doesn't scale automatically, so multiply it manually.
    --love.graphics.points(self.window_width / 2, self.window_height / 2) -- Will draw at the center of the canvas no matter how the screen is resized.

    --TLfres.endRendering() -- Draw black letterbox
    
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
