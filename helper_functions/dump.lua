function dump(tbl, indent)
    indent = indent or 0
    local formatting = string.rep("  ", indent)
    for k, v in pairs(tbl) do
        local key = tostring(k)
        if type(v) == "table" then
            print(formatting .. key .. " = {")
            dump(v, indent + 1)
            print(formatting .. "}")
        else
            print(formatting .. key .. " = " .. tostring(v))
        end
    end
end
