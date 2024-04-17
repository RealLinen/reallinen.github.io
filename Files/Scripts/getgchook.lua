-- Created by: Linen
-- Github: https://github.com/RealLinen
-- Discord: linenhs
-- Use this to dump game functions 
getgenv()["getgchook"] = typeof(getgenv()["getgchook"]) == "table" and getgenv()["getgchook"] or {
    Hooks = {},
    Cached = {}
}; getgenv()["getgchook"]["Hooks"] = getgenv()["getgchook"]["Hooks"] or {}; getgenv()["getgchook"]["Cached"] = getgenv()["getgchook"]["Cached"] or {}

getgenv()["getgchook"]["OnFunction"] = getgenv()["getgchook"]["OnFunction"] or function(name, func, upvalues)
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
getgenv()["getgchook"]["OnSearchEnded"] = getgenv()["getgchook"]["OnSearchEnded"] or function(str)
    -- str is a string containing the done, you can use 'setclipboard' to copy it to ur clipboard
    print("Dumped! Results copied to clipboard")
    setclipboard(str)
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

for i,v in next, getgc(true) do
    if typeof(v) == "function" then
        local info = debug.info(v, "n")
        local source = debug.info(v, "s")
        if source == "" or source == "[C]" or info == ""  then 
            continue; 
        end
        -----------------------
        local upvals = formatupv(debug.getupvalues(v))
        getgchook["OnFunction"](info, debug.info(v, "f"), upvals)
        if getgchook["Hooks"][info] then
            if not getgchook["Cached"][info] then
                getgchook["Cached"][info] = hookfunc(v, function(...)
                    getgchook["Hooks"][info] = type(getgchook["Hooks"][info]) == "function" and getgchook["Hooks"][info] or function (old, ...)
                        return old(...)
                    end
                    return getgchook["Hooks"][info](getgchook["Cached"][info], ...)
                end)
            end
        end
        cache[source] = typeof(cache[source]) == "string" and cache[source] or ""
        cache[source] ..= (string.format("    -  %s | Upvalues: %s", info, upvals)).."\n"
    end
end
for i, v in next, cache do 
    str ..= string.format("%s ->\n%s", i, v)
end
getgchook["OnSearchEnded"](str)

-- Usage [ After Executing, also u can re-execute this as many times as u want ]:
--[[
    getgchook["OnFunction"] = function(name, func, upvalues_amount)
        -- Each function that the GC Dump finds, it will pass it through here [ can be used for hooking games with ammo, etc ]
    end
    getgchook["OnSearchEnded"] = function(results)
        -- After the whole GC is dumped, it will copy the results to ur clipboard
        setclipboard(results)
    end
]]
