-- Created by: Linen
-- Github: https://github.com/RealLinen
-- Discord: linenhs
-- Use this to dump game functions 
getgenv()["getgchook"] = typeof(getgenv()["getgchook"]) == "table" and getgenv()["getgchook"] or {
    Hooks = {},
    Cached = {}
}; getgenv()["getgchook"]["Hooks"] = getgenv()["getgchook"]["Hooks"] or {}; getgenv()["getgchook"]["Cached"] = getgenv()["getgchook"]["Cached"] or {}

getgchook["OnFunction"] = getgchook["OnFunction"] or function(name, func, upvalues)
-- name: string | func: the function | upvalues: the amount of upvalues the function has
    -- Example
    if name == "Shoot" then
        getgchook["Hooks"][name] = function(old, ...)
            -- Hooking it, so when the function is called again we get to see what its getting called with
            print(name, ...)
            return old(...)
        end
    end
end
getgchook["OnSearchEnded"] = getgchook["OnSearchEnded"] or function(str)
    -- call getgchook.search(true) to copy the dumped functions to ur clipboard
    -- str is a string containing the done, you can use 'setclipboard' to copy it to ur clipboard
    --print("Dumped! Results copied to clipboard")
    --setclipboard(str)
end

-----------------------------
local str = "Hooked:\n"
local cache = {}
local alrprint = 0
local formatupv = function(v)
    local results = ""
    for i,v in next, v do
        if alrprint >= 100 then break; end
    end
    return #v
end

local function search(copy)
    for i,v in next, getgc(true) do
        if typeof(v) == "function" then
            local info = debug.info(v, "n")
            local source = debug.info(v, "s")
            if source == "" or source == "[C]" or info == ""  then 
                -- [C] is the exploit global functions
                -- "" as the source means the exploits global varibales that you or a script u executed made
                -- "" as info means invalid source or sum else idk lol
                continue; 
            end
            -----------------------
            local upvals = formatupv(debug.getupvalues(v))
            local func = debug.info(v, "f")
            getgchook["OnFunction"](info, func, upvals)

            -- Basically hook everything so u can modify
            if not getgchook["Cached"][info] then
                pcall(function()
                    getgchook["Cached"][info] = hookfunc(func, function(...)
                        getgchook["Hooks"][info] = type(getgchook["Hooks"][info]) == "function" and getgchook["Hooks"][info] or function(old, ...)
                            return old(...)
                        end
                        return getgchook["Hooks"][info](getgchook["Cached"][info], ...)
                    end)
                end)
            end
            cache[source] = typeof(cache[source]) == "string" and cache[source] or ""
            cache[source] ..= (string.format("    -  %s | Upvalues: %s", info, upvals)).."\n"
        end
    end

    for i, v in next, cache do 
        str ..= string.format("%s ->\n%s", i, v)
    end
    
    getgchook["OnSearchEnded"](str)
    if copy then
        print("Dumped! Results copied to clipboard");
        (setclipboard or function() end)(str)
    end
end

getgchook["search"] = search
search()
-- Usage [ After Executing, also u can re-execute this as many times as u want ]:
--[[
    getgchook["OnFunction"] = function(name, func, upvalues_amount)
        -- Each function that the GC Dump finds, it will pass it through here [ can be used for hooking games with ammo, etc ]
    end

    -- 
    getgchook.search() -- this is also for OnFunction to get called
    getgchook.search(true) -- this is for the dumped functions to get copied to ur clipboard, OnFunction will still get called

    getgchook["OnSearchEnded"] = function(results)
        -- After the whole GC is dumped, it will copy the results to ur clipboard
        --setclipboard(results)
    end

    -- Hooks
    getgchook["Hooks"]["Reload"] = function(old, ...)
        local args = {...}
        print(...) -- Print the arguments passed with the function
        -- to modify something, lets say args[1] was the new amount of bullets to reload to. We would simply do this to have inf ammo:
        -- args[1] = math.huge 
        return old(unpack(args)) -- Return the default value. 'old' is custom and not apart of the arguments, its a function used to return the spoofed values
    end
]]
