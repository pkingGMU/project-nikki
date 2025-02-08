local Class = require("libraries.hump-master.class")


-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")


gameStateEnter = Class()


function gameStateEnter:init()

    self.window = baseWindow()
    self.window:init()

    

    self.debugText = 'Hello'

    --window sizes--
    self.window_height = self.window.windowHeight
    self.window_width = self.window.windowWidth


    -- Test Timer --
    self.myTimer = Timer(200)

        

    -- Test Midi Trigger --
    self.midiTrigger = MidiTrigger()

    -- Test object handler --
    self.shapeHandler = ShapeHandler()


    -- Load test image
    self.pfp_test = love.graphics.newImage("assets/img/pfp.jpg")
    self.Num = 0
    self.b_down = false
    self.t_down = false
    self.a_down = false
    self.s_down = false
    self.d_down = false
    self.w_down = false

    self.midiFile = "sounds/Asgore/midi_training.csv"
    self.midiHash = midiFileHandler:readMidi(self.midiFile)

    -- Goal rectangle -- 
    self.goal_rect = {
        x = (self.window_width/2) - 25,
        y = (self.window_height/2) - 25,
        width = 50,
        height = 50,
        xvel = 0,
        yvel = 0,
        friction = 5,
        speed = 1500,
        jump_vel = -800,
        can_jump = true
    }


    self.song = love.audio.newSource("sounds/Asgore/Asgore.mp3", "stream")
    self.song:play()
    self.music = false

    -- variable that keeps track of rectangles that have spawed --
    self.last_call = 0

    -- Physics --
    self.gravity = 2000
    self.mass = 1
    self.force = self.gravity * self.mass

end