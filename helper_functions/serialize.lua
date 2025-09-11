-- helper_functions/serialize.lua
local json = require("libraries.dkjson.dkjson")
local Serialize = {}

function Serialize.saveToFile(filename, value)
	local serialized = json.encode(value, { indent = true })
	local file, err = io.open(filename, "w")
	if not file then
		error("Could not open file: " .. filename .. " (" .. tostring(err) .. ")")
	end
	file:write(serialized)
	file:close()
end

function Serialize.loadFromFile(filename)
	local file, err = io.open(filename, "r")
	if not file then
		error("Could not open file: " .. filename .. " (" .. tostring(err) .. ")")
	end
	local content = file:read("*a")
	file:close()
	local obj, pos, decode_err = json.decode(content, 1, nil)
	if decode_err then
		error("JSON decode error: " .. decode_err)
	end
	return obj
end

return Serialize
