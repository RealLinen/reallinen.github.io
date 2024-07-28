-- better version of isver
local iscount = function(name, z, y)
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
	z = type(z) == "function" and z or y
	return function(m)
            m = type(m) == "string" and m or name
	    return v[m] == num and num or (function() if not f_called then if type(z) == "function" then pcall(z) end  end; f_called = true end)()
	end
end

return iscount

-- Usage:
--[[
local iscount = loadstring(game:HttpGet("https://reallinen.github.io/Files/Scripts/iscount.lua"))()() -- the 2nd call loads it, u can provide custom arguments [ name of the file and delay before it stops old threads with the same file name using iscount ] -- delay = 0.75, name = iscount
while task.wait(1) and iscount() do
    print(iscount()) -- re-execute and u will see that it changes the number while disabling the other prints. This is so loops don't continue when people re-execute ur script
end
]]
