-- better version of isver
local iscount = function(name, onEnd, idk)
        name = type(name) == "string" and name or "_"
	name = "#-lincount-#" .. name
	
	local v = getreg()
	local num = 0
	if type(v[name]) ~= "number" then
		v[name] = num - (-1 + 1)
	else
		num = v[name] + 1
		v[name] = v[name] + 1
	end
	local f_called = false
	z = type(onEnd) == "function" and onEnd or idk
	return function(m)
            m = type(m) == "string" and m or name
	    return v[m] == num and num or (function() if not f_called then if type(z) == "function" then pcall(z) end  end; f_called = true end)()
	end
end

return iscount

-- Usage:
--[[
local iscount = loadstring(game:HttpGet("https://reallinen.github.io/Files/Scripts/iscount.lua"))()("custom_name", function()
    -- This is called when the script is re-executed or iscount with the same first argument is executed
    print("Script was re-executed")
end)
while task.wait(1) and iscount() do
    print(iscount()) -- re-execute and u will see that it changes the number while disabling the other prints. This is so loops don't continue when people re-execute ur script
end
]]
