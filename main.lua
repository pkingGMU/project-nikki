---@diagnostic disable: need-check-nil
-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
local Gamestate = require("libraries.hump-master.gamestate")
local csv = require("libraries.lua-csv-master.lua.csv")

-- On load open csv file --
local midi_file_csv = csv.open("sounds/midi_training.csv")
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

for fields in midi_file_csv:lines() do

    if midi_line_count < 2 or midi_line_count > 4 then
        goto continue
    end
    
    for i, v in ipairs(fields) do 
        print(i,v)
    end
    
    ::continue::
    midi_line_count = midi_line_count + 1
    
    
end

print("Hello World")

-- Local imports --
require("states.baseWindow")

-- Gamestate variables --
local menu = {}



--Callback function love.load 
--Called once upon opening

function love.load()

    -- Hump gamestate init --
    Gamestate.registerEvents()
    Gamestate.switch(menu)

    


    
end

-- Gamestate menu --

-- Menu Init (Load) --
function menu:init()
    local window = baseWindow()
    window:init()

    

    -- Load test image
    pfp_test = love.graphics.newImage("assets/img/pfp.jpg")

    Num = 0

    b_down = false
end

-- Menu Draw --
function menu:draw()
    if b_down == false then
        love.graphics.setColor(1, 1, 1)
        -- love.graphics.draw(pfp_test, 50, 50) --
        love.graphics.rectangle("fill", 50, 50, 100, 100)
    end
    love.graphics.setColor(255, 0, 0)
    love.graphics.print(Num, 0, 0)
end


-- Menu Update --
function menu:update(dt)
    if love.keyboard.isDown("up") then
        Num = Num + 100 * dt
    end
    
end

-- Callback function love.keypressed
-- Action listener?
-- Menu Keypressed --
function menu:keypressed(key)
    if key == 'b' then
        b_down = true
    end
end

-- Callback function love.keyreleased
-- Action listener?
-- Menu Keyreleased --
function menu:keyreleased(key)
    if key == 'b' then
        b_down = false
    end
end

