-- Global Imports --
local Class = require("libraries.hump-master.class")
local Gamestate = require("libraries.hump-master.gamestate")

-- Local imports --


gameStateMousePressed = Class()

function gameStateMousePressed:init()

end

function gameStateMousePressed:mousepressed(mx, my, mbutton, game)
    
end

function gameStateMousePressed:mousereleased(mx, my, mbutton, game)
    if (mbutton == 1)  then
        print("Clicked")
        Gamestate.switch(menuState)
    end

    game.song:stop()
end