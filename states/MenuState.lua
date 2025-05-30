require("states.BaseState")
require("states.DevState")


----------------------------------------- MENU ----------------------------------------------

-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Gamestate = require("libraries.hump-master.gamestate")

-- Local imports --
require("states.baseWindow")

--local Class = require("libraries.hump-master.class")

-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")
require("classes.button")
require("classes.objects.Object")
require("classes.objects.Object")


-- Menuvariables --
local menu
local window = baseWindow()
local background
local menu_button_margin_side
local menu_button_margin_top
local button_height
local button_width
local button_pos_x
local button_pos_y
local play_button
local menu_song
local menu_song_timer
local midi_trigger
local music
local midi_file
local midi_hash
local midi_pitch
local background_shader

-- MenuState.lua
MenuState = BaseState.new()

-- Menu Init (Load) --
function MenuState:init()

    local self = BaseState.new() -- BaseState Constructor
    setmetatable(self, {__index = MenuState})

    return self

end

function MenuState:enter()
    BaseState.enter(self)

    self.canvas = love.graphics.newCanvas(self.window_width, self.window_height)

    window:init()

    -- Background dimensions --
    background = SpawnRectangle(0,0,self.window_width, self.window_height, 0.0,0.0,0.0)

    -- Button dimensions --
    menu_button_margin_side = ((self.window_width * 10)/15) 
    menu_button_margin_top = ((self.window_height * 10)/11) 
    button_width = self.window_width - menu_button_margin_side
    button_height = self.window_height - menu_button_margin_top
    button_pos_x = (.5 * (self.window_width)) - (.5 * (button_width))
    button_pos_y = (.5 * (self.window_height)) - (.5 * (button_height))


    -- First button --
    play_button = button(button_pos_x, button_pos_y, button_width, button_height,1,1,1)

    -- Menu Music --
    menu_song = love.audio.newSource("sounds/Main_Menu/8bit.mp3", 'stream')
    menu_song:play()

    -- Timer For Menu Music --
    menu_song_timer = Timer(20)

    -- MidiTrigger Object --
    midi_trigger = MidiTrigger()
    music = false

    -- Hash Music --
    midi_file = "sounds/Main_Menu/midi_training.csv"
    midi_hash = midiFileHandler:readMidi(midi_file)
    midi_pitch = 0


    -- Load Menu Background shader --
    background_shader = love.graphics.newShader("shaders/menu/menu-background.glsl")

end

function MenuState:update(dt)

    -- Update Timer --
    
    if menu_song_timer.running then
        menu_song_timer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if music == false then
        menu_song_timer:start()
        music = true
     end

    
    midi_pitch = midi_trigger:findNote(midi_hash, menu_song_timer.elapsedTime, 0)

    --print(midi_pitch)

    if midi_pitch == 'No Notes' then
        goto continue
    end
 
    
    ::continue::

    --background_shader:send("iTime", love.timer.getTime())
    
    background_shader:send("screen", {self.window_width, self.window_height})
end

function MenuState:draw()

    love.graphics.setCanvas(self.canvas)
    love.graphics.clear(0, 0, 0, 0)
    -- Background --
    -- Background Shader --
    love.graphics.setShader(background_shader)

    -- Send variables to shader --

    love.graphics.setColor(background.r, background.g, background.b)
    love.graphics.rectangle("fill", background.x, background.y, background.width, background.height)
    -- Remove background shader --
    love.graphics.setShader()

    love.graphics.setColor(play_button.r, play_button.g, play_button.b)
    love.graphics.rectangle("fill", play_button.x, play_button.y, play_button.width, play_button.height)

    love.graphics.setCanvas()

   love.graphics.setColor(1,1,1)
   love.graphics.setBlendMode("alpha", "premultiplied")
   love.graphics.draw(self.canvas, 0, 0, 0, self.scale_factor, self.scale_factor)
   love.graphics.setBlendMode("alpha")
end

function MenuState:mousereleased(mx, my, mbutton)
    if (mbutton == 1) and (mx >= play_button.x) and (mx < (play_button.x + play_button.width)) and (my >= play_button.y) and (my < (play_button.y + play_button.height)) then
        print("Clicked")
        Gamestate.switch(DevRoomState)
        menu_song:stop()
    end
end

function MenuState:keypressed(key)
    -- Handle key presses for the menu (e.g., start game, exit, etc.)
    if key == "return" then
        Gamestate.switch(DevRoomState)  -- Switch to GameState
    end
end
