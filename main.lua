-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("hump.class")

-- Local imports --
require("states.baseWindow")


--Callback function love.load 
--Called once upon opening

function love.load()
    local window = baseWindow()
    window:init()

    -- Load test image
    pfp_test = love.graphics.newImage("pfp.jpg")

    Num = 0

    b_down = false
end

-- Callback function love.update
-- Continuous
-- 'dt' is delta time
function love.update(dt)
    if love.keyboard.isDown("up") then
        Num = Num + 100 * dt
    end
    
end


-- Callback function love.draw
-- Used for drawing
-- Drawing can ONLY happen here
function love.draw()

    if b_down == false then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(pfp_test, 50, 50)
    end

    

    love.graphics.setColor(255, 0, 0)
    love.graphics.print(Num, 0, 0)
end


-- Callback function love.keypressed
-- Action listener?
function love.keypressed(key)
    if key == 'b' then
        b_down = true
    end
end

-- Callback function love.keypressed
-- Action listener?
function love.keyreleased(key)
    if key == 'b' then
        b_down = false
    end
end