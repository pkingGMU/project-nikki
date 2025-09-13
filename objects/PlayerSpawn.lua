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
		xvel = 0,
		yvel = 0,
		dash_vel = 400,
		scale_x = 1,
		scale_y = 1,
		tag = "player_spawn",
		collide_x_offset = 0,
		collide_y_offset = 0,
		collide_w = 32,
		collide_h = 32,
		can_collide = true,
		can_move_x = true,
		friction = 5,
		gravity = 900,
		speed = 500,
		dash = false,
		can_move_y = true,
		direction = "right",
		type = "player",
		physics = true,
		animation = true,
		is_anim_locked = false,
		is_dashing = false,
		dash_duration = 0.4,
		dash_timer = 0,
		dash_cooldown_duration = 1,
		dash_cooldown = 0,
		can_dash = true,
		can_jump = true,
		jump_vel = -300,
		is_jumping = false,
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
	player.dash_anim = NewAnimation(player.sprite_sheet, 32, 32, 0.4, 13, 16)
	return player
end

return PlayerSpawn
