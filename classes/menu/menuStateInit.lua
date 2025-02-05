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
    self.debugText = 'Hello'

    --window sizes--
    self.window_height = self.window.windowHeight
    self.window_width = self.window.windowWidth

    -- First button --
    self.test_button = button(400,400,1,1,1)

    
end

