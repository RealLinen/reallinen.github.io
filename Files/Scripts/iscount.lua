-- since exploits don't universally support getgenv or getgenv doesn't save its value's, i wrote this alternative for now
local writefile = writefile or dofile or createfile
assert(writefile, "Exploit not supported! [ write file must exist ]")
local iscount = (function(name, del, onend) -- string, number, functio
    del = type(del) == "number" and del or 0.75 -- delay before it stops the old threads/loops or whatever ur calling iscount() in
    onend = type(onend) == "function" and onend or function() end -- when this script is re-executed with the same name
    local fname = ("%s.txt"):format("iscount"..(name or "linen"))
    local content;
    xpcall(function()
        content = readfile(fname)
        content = tonumber(content) + 1
    end, function(err)
        content = "0"
    end)
    
    -- :write
    for i = 1, 2 do
       writefile(fname, tostring(content))
       task.wait(.02)
    end

    -- :check
    local value = true
    task.spawn(function() -- so it doesn't yeild the main thread
        while task.wait(del) do
            local file = readfile(fname)
            check = file == tostring(content)
            if not check and file ~= "" and file ~= " " and file ~= "  " then -- bug fix for reading too fast in celery
                break
            end
        end
        value = false
        onend()
    end)
    
    return function()
        return value and content
    end
end)


return iscount
--[[
local iscount = loadstring(game:HttpGet("https://reallinen.github.io/Files/Scripts/iscount.lua"))()("iscount", 0.75) -- the 2nd call loads it, u can provide custom arguments [ name of the file and delay before it stops old threads with the same file name using iscount ] -- delay = 0.75, name = iscount
while task.wait(1) and iscount() do
    print(iscount()) -- re-execute and u will see that it changes the number while disabling the other prints. This is so loops don't continue when people re-execute ur script
end
]]
