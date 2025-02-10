-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


menuStateUpdate = Class()

function menuStateUpdate:init()

end

function menuStateUpdate:update(dt, menu)
    local song_timer = menu.menu_song_timer
    local midi_trigger = menu.midi_trigger
    local midi_hash = menu.midi_hash

    -- Update Timer --
    
    if song_timer.running then
        song_timer:update(dt)
    end
     -- If 't' is pressed, start the timer

     
     if menu.music == false then
        song_timer:start()
        menu.music = true
     end

    
    menu.midi_pitch = midi_trigger:findNote(midi_hash, song_timer.elapsedTime, 0)

    print(menu.midi_pitch)

    
end