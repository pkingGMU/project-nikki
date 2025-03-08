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
    self.window_height = self.window.windowHeight
    self.window_width = self.window.windowWidth
end

function BaseState:update(dt)
    
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
    
end

function BaseState:keyreleased(key)

    if key == 'b' then
        self.b_down = true
    end

    if key == 't' then
        self.t_down = true
    end

    if key == 'a' then
        self.a_down = true
    end

    if key == 's' then
        self.s_down = true
    end

    if key == 'd' then
        self.d_down = true
    end

    if key == 'w' then
        self.w_down = true
    end
    if key == "space" then
        
    end
    
end

function BaseState:mousepressed(mx, my, mbutton)
    
end

function BaseState:mousereleased(mx, my, mbutton)
    
end
