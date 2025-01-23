local Class = require("libraries.hump-master.class")

MidiTrigger = Class()

function MidiTrigger:init()
end

function MidiTrigger:midiHash(lines)

    

end

function MidiTrigger:findNote(lines)
    for fields in lines do
        if midi_line_count < 2 or midi_line_count > 4 then
            goto continue
        else
            -- print first row
           local first_col = fields[1]
            print(first_col)
        end
        
        ::continue::
        midi_line_count = midi_line_count + 1
    end
end