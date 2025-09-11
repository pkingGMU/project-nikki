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
		type = "object",
	}

	object = setmetatable(params, { __index = defaults })

	object.center_x = object.x + object.w / 2
	object.center_y = object.y + object.h / 2

	return object
end

return PlayerSpawn
