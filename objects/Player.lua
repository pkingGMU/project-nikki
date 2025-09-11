local Object = require("Object")

local function Player(id, params)
	local player = Object(id, params)
	player.canMoveX = true
	player.canMoveY = true
	player.dash = false
	player.direction = "right"
	player.interact = false
	player.inventory = {}

	-- Animations --
	player.sprite_sheet = love.graphics.newImage("assets/Aseprite/Character_Sprites/character.png")
	player.idle_anim = player:newAnimation(player.sprite_sheet, 32, 32, 1, 2, 8)
	player.current_anim = player.idle_anim
	player.walk_anim = player:newAnimation(player.sprite_sheet, 32, 32, 1, 9, 12)

	return player
end

return Player
