function DrawAnim(obj)
	love.graphics.push()

	local frame_count = obj.current_anim.end_frame - obj.current_anim.start_frame + 1
	love.graphics.setColor(1, 1, 1, 1)
	local sprite_num = math.floor(obj.current_anim.current_time / obj.current_anim.duration * frame_count)
		+ obj.current_anim.start_frame
	love.graphics.draw(
		obj.current_anim.sprite_sheet,
		obj.current_anim.quads[sprite_num],
		obj.x,
		obj.y,
		nil,
		obj.draw_direction,
		1,
		obj.draw_x_offset,
		0
	)
	love.graphics.pop()

	print(frame_count)
end

function DrawStatic(obj) end

function NewAnimation(image, width, height, duration, start_frame, end_frame)
	local animation = {}
	animation.sprite_sheet = image
	animation.quads = {}

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	animation.duration = duration or 1
	animation.current_time = 0
	animation.start_frame = start_frame or 1
	animation.end_frame = end_frame or 1

	return animation
end

function UpdateAnimation(dt, obj)
	if obj.current_anim then
		obj.current_anim.current_time = obj.current_anim.current_time + dt

		if obj.current_anim.current_time >= obj.current_anim.duration then
			obj.current_anim.current_time = obj.current_anim.current_time - obj.current_anim.duration
		end
	end
end
