local function Object(id, params)
	local object = {
		id = id or nil,
		x = params.x or 0,
		y = params.y or 0,
		z = params.z or 0,
		w = params.w or 32,
		h = params.h or 32,
		rot = params.rot or 0,
		scale_x = params.scale_x or 1,
		scale_y = params.scale_y or 1,
		tag = params.tag or "none",
		collide_x_off = params.collide_x_offset or 0,
		collide_y_off = params.collide_y_offset or 0,
		collide_w = params.collide_w or 32,
		collide_h = params.collide_h or 32,
		can_collide = params.can_collide or false,
		type = params.type or "object",
	}

	object.center_x = object.x + object.w / 2
	object.center_y = object.y + object.h / 2

	function object:serialize()
		local t = {}
		for k, v in pairs(self) do
			if type(v) ~= "function" then
				t[k] = v
			end
		end
		return t
	end

	function object:load(data)
		for k, v in pairs(data) do
			self[k] = v
		end
	end

	return object
end

return Object
