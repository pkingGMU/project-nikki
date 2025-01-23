local Class = require("libraries.hump-master.class")

-- Local Imports --
require("classes.Timer")

MidiTrigger = Class()

function MidiTrigger:init()
    self.noteDurationTimer = false
end

function MidiTrigger:findNote(hashMap, elapsedTime)

    elapsedTime = math.floor(elapsedTime * 10 + 0.5) / 10
    
    if hashMap[tostring(elapsedTime)] then
        self.noteDurationTimer = true
        return hashMap[tostring(elapsedTime)]
    else
        self.noteDurationTimer = false
        return 'No Notes'
    end
end


function MidiTrigger:findNotes(hashMap, elapsedTime)
    
    for key, value in pairs(hashMap) do
        local numericKey = tonumber(key)

        if not numericKey then
            goto continue
        end
        if numericKey[elapsedTime] then
            return value
        end
        ::continue::
    end
    return 'No Notes'
end