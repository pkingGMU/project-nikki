local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.Timer")

MidiTrigger = Class()

function MidiTrigger:init()
    self.noteDurationTimer = false
    
end

function MidiTrigger:findNote(hashMap, elapsedTime, staggerTime)

    elapsedTime = (math.floor(elapsedTime * 10 + 0.5) / 10)

    local elapsedTimeStaggered = elapsedTime + staggerTime
    
    if hashMap[tostring(elapsedTimeStaggered)] then
        self.noteDurationTimer = true
        return hashMap[tostring(elapsedTimeStaggered)]
    else
        self.noteDurationTimer = false
        return 'No Notes'
    end
end


