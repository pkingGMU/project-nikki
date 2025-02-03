local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.Timer")

MidiTrigger = Class()

function MidiTrigger:init()
    self.noteDurationTimer = false
    self.staggerTime = 1
end

function MidiTrigger:findNote(hashMap, elapsedTime)

    elapsedTime = (math.floor(elapsedTime * 10 + 0.5) / 10)

    elapsedTimeStaggered = elapsedTime + self.staggerTime
    
    if hashMap[tostring(elapsedTimeStaggered)] then
        self.noteDurationTimer = true
        return hashMap[tostring(elapsedTimeStaggered)]
    else
        self.noteDurationTimer = false
        return 'No Notes'
    end
end


