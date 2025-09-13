function CheckCollisions(obj, obj_handler)
	local collide_list = {}
	for _, other in ipairs(obj_handler) do
		if other ~= obj and obj.can_collide and other.can_collide then
			local ax, ay, aw, ah =
				obj.x + obj.collide_x_offset, obj.y + obj.collide_y_offset, obj.collide_w, obj.collide_h
			local bx, by, bw, bh =
				other.x + other.collide_x_offset, other.y + other.collide_y_offset, other.collide_w, other.collide_h

			if ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by then
				table.insert(collide_list, other)
			end
		end
	end
	return collide_list
end
function ResolveCollisionsX(obj, collide_list)
	for _, other in ipairs(collide_list) do
		local ax, aw = obj.x + obj.collide_x_offset, obj.collide_w
		local bx, bw = other.x + other.collide_x_offset, other.collide_w

		if obj.xvel > 0 then
			local overlap = (ax + aw) - bx
			if overlap > 0 then
				obj.x = obj.x - overlap
				obj.xvel = 0
			end
		elseif obj.xvel < 0 then
			local overlap = (bx + bw) - ax
			if overlap > 0 then
				obj.x = obj.x + overlap
				obj.xvel = 0
			end
		end
	end
end

function ResolveCollisionsY(obj, collide_list)
	for _, other in ipairs(collide_list) do
		local ay, ah = obj.y + obj.collide_y_offset, obj.collide_h
		local by, bh = other.y + other.collide_y_offset, other.collide_h

		if obj.yvel > 0 then
			local overlap = (ay + ah) - by
			if overlap > 0 then
				obj.y = obj.y - overlap
				obj.yvel = 0
				obj.on_ground = true
			end
		elseif obj.yvel < 0 then
			local overlap = (by + bh) - ay
			if overlap > 0 then
				obj.y = obj.y + overlap
				obj.yvel = 0
			end
		end
	end
end

function UpdatePhysics(dt, obj, object_handler)
	if obj.can_move_x then
		obj.xvel = obj.xvel * (1 - math.min(dt * obj.friction, 1))
	end

	obj.x = obj.x + obj.xvel * dt
	local collide_x = CheckCollisions(obj, object_handler)
	ResolveCollisionsX(obj, collide_x)

	if obj.can_move_y then
		obj.yvel = obj.yvel + obj.gravity * dt
		obj.on_ground = false
	end
	obj.y = obj.y + obj.yvel * dt
	local collide_y = CheckCollisions(obj, object_handler)
	ResolveCollisionsY(obj, collide_y)
end

function KeyboardMovePlayer(dt, obj)
	if love.keyboard.isDown("left") and (obj.xvel <= obj.speed) and not obj.is_anim_locked then
		obj.xvel = obj.xvel - obj.speed * dt
		obj.current_anim = obj.walk_anim
		obj.direction = "left"
		obj.draw_direction = -1
		obj.draw_x_offset = obj.w
	end

	if love.keyboard.isDown("right") and (obj.xvel >= -obj.speed) and not obj.is_anim_locked then
		obj.xvel = obj.xvel + obj.speed * dt
		obj.current_anim = obj.walk_anim
		obj.direction = "right"
		obj.draw_direction = 1
		obj.draw_x_offset = 0
	end

	if not love.keyboard.isDown("right") and not love.keyboard.isDown("left") and not obj.is_anim_locked then
		obj.current_anim = obj.idle_anim
	end

	if obj.jump and not obj.is_anim_locked then
		print("JUMP")
		obj.is_jumping = true
		obj.yvel = obj.jump_vel
		obj.jump = false
	end

	if obj.dash_cooldown > 0 then
		obj.dash_cooldown = obj.dash_cooldown - dt
	end

	if obj.dash and not obj.is_anim_locked and obj.dash_cooldown <= 0 then
		obj.dash_timer = obj.dash_duration
		obj.dash_cooldown = obj.dash_cooldown_duration
		obj.is_dashing = true
		obj.is_anim_locked = true
		obj.dash = false
		obj.current_anim = obj.dash_anim
	end
	if obj.is_dashing then
		obj.dash_timer = obj.dash_timer - dt

		if obj.dash_timer > 0 then
			if obj.direction == "right" then
				obj.xvel = obj.dash_vel
			elseif obj.direction == "left" then
				obj.xvel = obj.dash_vel * -1
			end
		else
			obj.is_dashing = false
			obj.is_anim_locked = false
		end
	end

	return obj
end
