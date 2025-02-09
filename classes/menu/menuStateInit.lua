local Class = require("libraries.hump-master.class")


-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")
require("classes.button")


menuStateInit = Class()


function menuStateInit:init()

    self.window = baseWindow()
    self.window:init()

    --window sizes--
    self.window_height = self.window.windowHeight
    self.window_width = self.window.windowWidth

    -- Button dimensions --
    self.menu_button_margin_side = ((self.window_width * 10)/15) 
    self.menu_button_margin_top = ((self.window_height * 10)/11) 
    self.button_width = self.window_width - self.menu_button_margin_side
    self.button_height = self.window_height - self.menu_button_margin_top
    self.button_pos_x = (.5 * (self.window_width)) - (.5 * (self.button_width))
    self.button_pos_y = (.5 * (self.window_height)) - (.5 * (self.button_height))


    -- First button --
    self.play_button = button(self.button_pos_x, self.button_pos_y, self.button_width, self.button_height,1,1,1)

    -- Menu Music --
    self.menu_song = love.audio.newSource("sounds/Main_Menu/8bit.mp3", 'stream')
    self.menu_song:setLooping(true)
    self.menu_song:play()

    
end

