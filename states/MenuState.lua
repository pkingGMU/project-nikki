require("states.BaseState")
require("states.DevState")

-- MenuState.lua
MenuState = BaseState.new()

----------------------------------------- MENU ----------------------------------------------

-- Global Imports --
package.path = package.path .. ";/usr/share/lua/5.4/?.lua"
local Gamestate = require("libraries.hump-master.gamestate")

-- Local imports --
require("states.baseWindow")

require("classes.menu.menuStateInit")
require("classes.menu.menuStateDraw")
require("classes.menu.menuStateUpdate")


-- Menuvariables --
local menu

-- Menu Init (Load) --
function MenuState:init()
    menu = menuStateInit()

    -- Testing objects
    --myObject = Object()
    --myObject:testPrint("Object test")
    --myEntity = Entity()
    --myEntity:testPrint("Object test")

end

function MenuState:draw()
    menuStateDraw:draw(menu)
end

function MenuState:update(dt)
    menuStateUpdate:update(dt, menu)
end

function MenuState:mousereleased(mx, my, mbutton)
    if (mbutton == 1) and (mx >= menu.play_button.x) and (mx < (menu.play_button.x + menu.play_button.width)) and (my >= menu.play_button.y) and (my < (menu.play_button.y + menu.play_button.height)) then
        print("Clicked")
        Gamestate.switch(DevRoomState)
        menu.menu_song:stop()
    end
end

function MenuState:keypressed(key)
    -- Handle key presses for the menu (e.g., start game, exit, etc.)
    if key == "return" then
        Gamestate.switch(DevRoomState)  -- Switch to GameState
    end
end
