-- Draw Functions
require("objects.DrawFunctions")

local function PlayerSpawn(params)
	local defaults = {
		id = nil,
		x = 0,
		y = 0,
		z = 0,
		w = 32,
		h = 32,
		rot = 0,
		scale_x = 1,
		scale_y = 1,
		tag = "player_spawn",
		collide_x_off = 0,
		collide_y_off = 0,
		collide_w = 32,
		collide_h = 32,
		can_collide = false,
		type = "player",
	}

	player = setmetatable(params, { __index = defaults })

	-- Bug fix with tiled
	player.y = player.y - 32

	player.center_x = player.x + player.w / 2
	player.center_y = player.y + player.h / 2

	player.canMoveX = true
	player.canMoveY = true
	player.dash = false
	player.direction = "right"
	player.interact = false
	player.inventory = {}

	-- Animations --
	player.sprite_sheet = love.graphics.newImage("assets/Aseprite/Character_Sprites/character.png")
	player.idle_anim = NewAnimation(player.sprite_sheet, 32, 32, 1, 2, 8)
	player.current_anim = player.idle_anim
	player.walk_anim = NewAnimation(player.sprite_sheet, 32, 32, 1, 9, 12)

	return player
end

return PlayerSpawn
