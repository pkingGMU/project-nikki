local function LoveConfig()
	local config = {
		WINDOW_WIDTH = 640,
		WINDOW_HEIGHT = 360,
		SCALE_FACTOR = 1,
	}

	config.TARGET_WIDTH = config.WINDOW_WIDTH * config.SCALE_FACTOR
	config.TARGET_HEIGHT = config.WINDOW_HEIGHT * config.SCALE_FACTOR

	return config
end

return LoveConfig
