-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("hump.class")
local Gamestate = require("hump.gamestate")

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
        love.graphics.draw(pfp_test, 50, 50)
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

