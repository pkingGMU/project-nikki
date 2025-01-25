local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.Timer")

MidiTrigger = Class()

function MidiTrigger:init()
    self.noteDurationTimer = false
end

function MidiTrigger:findNote(hashMap, elapsedTime)

    elapsedTime = (math.floor(elapsedTime * 10 + 0.5) / 10) - .1
    
    if hashMap[tostring(elapsedTime)] then
        self.noteDurationTimer = true
        return hashMap[tostring(elapsedTime)]
    else
        self.noteDurationTimer = false
        return 'No Notes'
    end
end


