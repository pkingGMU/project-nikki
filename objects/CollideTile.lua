local function CollideTile(params)
	local defaults = {
		id = nil,
		x = 0,
		y = 0,
		w = 32,
		h = 32,
		collide_w = 32,
		collide_h = 32,
		collide_x_offset = 0,
		collide_y_offset = 0,
		physics = false,
		animation = false,
		can_collide = true,
	}

	tile = setmetatable(params, { __index = defaults })

	--Tiled Offset
	tile.y = tile.y - 32

	return tile
end

return CollideTile
