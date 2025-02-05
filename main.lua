---@diagnostic disable: need-check-nil
-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Class = require("libraries.hump-master.class")
local Gamestate = require("libraries.hump-master.gamestate")
local csv = require("libraries.lua-csv-master.lua.csv")


-- Local imports --
require("states.baseWindow")
require("classes.midiFileHandler")
require("classes.Timer")
require("classes.MidiTrigger")
require("classes.spawn-objects.SpawnRectangle")
require("classes.spawn-objects.ShapeHandler")
require("classes.spawn-objects.SpawnCircle")
require("classes.menu.menuStateInit")
require("classes.menu.menuStateDraw")
require("classes.game.gameStateInit")
require("classes.game.gameStateDraw")
require("classes.game.gameStateUpdate")


-- Gamestate variables --
local menuState = {}
local gameState = {}

--Callback function love.load 
--Called once upon opening

function love.load()
    -- Hump gamestate init --
    Gamestate.registerEvents()
    Gamestate.switch(menuState)
end

-- Gamestate menu --

-- Menu Init (Load) --
function menuState:init()
    menu = menuStateInit()
end

function menuState:draw()
    menuStateDraw:draw(menu)
end

function menuState:update(dt)
    
end

function menuState:mousereleased(mx, my, mbutton)
    if (mbutton == 1) and (mx >= menu.test_button.x) and (mx < (menu.test_button.x + menu.test_button.width)) and (my >= menu.test_button.y) and (my < (menu.test_button.y + menu.test_button.height)) then
        print("Clicked")
        Gamestate.switch(gameState)
    end
end



-- gamestate Init --
function gameState:init()
    game = gameStateInit()
end

-- gamestate Draw --
function gameState:draw()
    gameStateDraw:draw(game)
end


-- Menu Update --
function gameState:update(dt)
   gameStateUpdate:update(dt, game)
end

-- Callback function love.keypressed
-- Action listener?
-- Menu Keypressed --
function gameState:keypressed(key)
    if key == 'b' then
        game.b_down = true
    end

    if key == 't' then
        game.t_down = true
    end

    if key == 'a' then
        game.a_down = true
    end

    if key == 's' then
        game.s_down = true
    end

    if key == 'd' then
        game.d_down = true
    end

    if key == 'w' then
        game.w_down = true
    end
end

-- Callback function love.keyreleased
-- Action listener?
-- Menu Keyreleased --
function gameState:keyreleased(key)
    if key == 'b' then
        game.b_down = false
    end

    if key == 'a' then
        game.a_down = false
    end

    if key == 's' then
        game.s_down = false
    end

    if key == 'd' then
        game.d_down = false
    end

    if key == 'w' then
        game.w_down = false
    end

    

    
end

