-- Global Imports --
local Class = require("libraries.hump-master.class")

-- Local imports --


gameStateKeyPressed = Class()

function gameStateKeyPressed:init()

end

function gameStateKeyPressed:keypressed(key, game)
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

function gameStateKeyPressed:keyreleased(key, game)
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