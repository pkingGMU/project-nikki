local Class = require("libraries.hump-master.class")
local Gamestate = require("libraries.hump-master.gamestate")
local csv = require("libraries.lua-csv-master.lua.csv")

-- Name Class --
midiFileHandler = Class()

function midiFileHandler:init()
end

function midiFileHandler:readMidi(midiFilePath --[[string]])

        -- On load open csv file --
    local midi_file_csv = csv.open(midiFilePath)
    -- Fetch the first row (header)
    local header = midi_file_csv:lines()()

    -- Keep track of line count --
    midi_line_count = 1


    if header then
        -- Print the header to check it
        print("CSV Header: ", table.concat(header, ", "))
    else
        print("No header found in CSV.")
    end

    

    notesTable = {}

    for fields in midi_file_csv:lines() do

        local key = fields[6]
        local pair = fields[4]
        notesTable[key] = pair
        
    end

    return notesTable

    
    --for fields in midi_file_csv:lines() do

        --if midi_line_count < 2 or midi_line_count > 4 then
        --    goto continue
        --else
        --    -- print first row
        --   local first_col = fields[1]
        --    print(first_col)
        --end
        
        --::continue::
        --midi_line_count = midi_line_count + 1
        
        
    --end

end

