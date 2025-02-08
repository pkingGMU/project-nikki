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
require("classes.game.gameStateEnter")
require("classes.game.gameStateDraw")
require("classes.game.gameStateUpdate")
require("classes.game.gameStateKeyPressed")
require("classes.game.gameStateMousePressed")


-- Gamestate variables --
local menuState = {}
local gameState = {}

-- Main Objects --
local menu
local game_init
local game

--Callback function love.load 
--Called once upon opening

function love.load()
    -- Hump gamestate init --
    Gamestate.registerEvents()
    Gamestate.switch(menuState)
end

----------------------------------------- MENU ----------------------------------------------

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
    if (mbutton == 1) and (mx >= menu.play_button.x) and (mx < (menu.play_button.x + menu.play_button.width)) and (my >= menu.play_button.y) and (my < (menu.play_button.y + menu.play_button.height)) then
        print("Clicked")
        Gamestate.switch(gameState)
    end
end

----------------------------------------- GAMESTATE -----------------------------------------

-- gamestate Init --
function gameState:init()
    game = gameStateInit()
end

function gameState:enter()
    game = gameStateEnter()
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
function gameState:keypressed(key)
    gameStateKeyPressed:keypressed(key, game)
end

-- Callback function love.keyreleased
function gameState:keyreleased(key)
    gameStateKeyPressed:keyreleased(key, game)
end

-- Callback function love.mousepressed
function gameState:mousepressed(mx, my, mbutton)
    gameStateMousePressed:mousepressed(mx, my, mbutton, game)
end

-- Callback function love.mousereleased
function gameState:mousereleased(mx, my, mbutton)
    gameStateMousePressed:mousereleased(mx, my, mbutton, game)
end

