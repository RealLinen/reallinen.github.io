-- Created by: Linen
-- Github: https://github.com/RealLinen
-- Discord: linenhs
-- Use this to dump game functions 


-- BETTER VERSION OF: http://reallinen.github.io/Files/Scripts/getgchook.lua
local ENV = "gchook"
getgenv()[ENV] = type(getgenv()[ENV]) == "table" and getgenv()[ENV] or {
    Hooks = {}
}

--------
getgenv()[ENV]["search"] = function(key, optional)
    if type(key) == "nil" then
        return "Invalid search! Check the arguments you provided."
    end
    optional = type(optional) == "table" and optional or {}
    -- Optional Parameters
    optional["value"] = optional["value"] or nil -- set something [ set index to value ]
    optional["lock"] = optional["lock"] -- lock an index to a certain value, optional["value"] must be used for this to work
    optional["dump"] = optional["dump"] -- retrieve all index and values regardless of name
    optional["get"] = optional["get"] -- to get the raw value of something
    optional["valuesearch"] = optional["valuesearch"] -- search by value, so it will look for things with the value of <key> instead of things with the name of <key>

    local stack = {}
    local results = "\n"
    local breakscript = false
    local function handleVariable(tbl, index, value)
        local logvar = function()
            local classnameInd = typeof(index) == "Instance" and index.ClassName or typeof(index)
            local classnameVal = typeof(value) == "Instance" and value.ClassName or typeof(value)

            if stack[tostring(index)] == value then
                -- Same contents
                return
            end
            stack[tostring(index)] = value
            results = results .. ("%s - %s: %s [%s]\n"):format(classnameInd, tostring(index), tostring(value), classnameVal)
        end

        -- Exploit calls, ignore them
        -- To bypass, set "AllowExploitCalls" true in the options when u pass the argument
        if typeof(value) == "function" and debug.info(value, "s") == "[C]" and not optional["AllowExploitCalls"] then
            return;
        end

        local searchBy = function(ist)
            if optional["valuesearch"] then
                return key == value
            else
                return (ist and tostring(index) or index) == key
            end
        end

        if optional["dump"] then
            logvar()
        else
            if type(optional["value"]) ~= "nil" then
                getgenv()[ENV]["Hooks"][tbl] = type(getgenv()[ENV]["Hooks"][tbl]) == "table" and getgenv()[ENV]["Hooks"][tbl] or {}

                -- check for mismatch
                if searchBy(true) then
                    return;
                end

                -- Set value
                if optional["lock"] then
                    -- To do: since multiple values can be in the same table, add a global data collection to handle this -- DONE :D
                    getgenv()[ENV]["Hooks"][tbl][index] = optional["value"]
                    setmetatable(tbl, {
                        __index = function(self, index)
                            if getgenv()[ENV]["Hooks"][tbl] then
                                for i, v in next, getgenv()[ENV]["Hooks"][tbl] do
                                    if i == index then
                                        return v
                                    end
                                end 
                            end
                            return rawget(self, index)
                        end,
                    })
                else
                    setmetatable(tbl, {})
                end

                -- Set value
                if type(tbl) == "table" and typeof(optional["value"]) == typeof(value) then
                    -- Function hooks
                    if type(value) == "function" then
                        local storekey = "GCHOOK"..tostring(tbl).."-"..tostring(index)
                        local stored = optional["value"]
                        local middleman = function(...)
                            return stored((getgenv()[ENV]["Hooks"][tbl][storekey] or function(...) return ... end), ...)
                        end

                        getgenv()[ENV]["Hooks"][tbl][storekey] = getgenv()[ENV]["Hooks"][tbl][storekey] or value
                        optional["value"] = middleman
                    end

                    -- ...
                    rawset(tbl, index, optional["value"])
                end
            elseif type(getgenv()[ENV]["Hooks"][tbl]) == "table" and getgenv()[ENV]["Hooks"][tbl][index] and optional["lock"] == false then
                -- Remove Hooks
                getgenv()[ENV]["Hooks"][tbl][index] = nil
            else
                -- Dump results to search query
                if optional["get"] then
                    if searchBy() then
                        breakscript = true
                        results = type(value) == "function" and debug.info(value, "f") or value
                        return;
                    end
                end

                if not optional["valuesearch"] and string.match(tostring(index):lower(), tostring(key):lower()) then
                    logvar()
                elseif optional["valuesearch"] and key == value then
                    logvar()
                end
            end
        end
    end

    -- Logging
    for a,b in next, getgc() do
        if type(b) == 'function' then
            if debug.info(b, "s") == "[C]" and not optional["AllowExploitCalls"] then
                continue;
            end
            for c, d in next, debug.getupvalues(b) do
               if type(d) == 'function' then
                  if debug.info(d, "s") == "[C]" and not optional["AllowExploitCalls"] then
                    continue;
                  end
                  for e, tbl in next, debug.getupvalues(d) do
                      if type(tbl) == 'table' then
                          for var, value in next, tbl do
                              handleVariable(tbl, var, value, e)
                              if breakscript then
                                  return results
                              end
                          end
                      end
                end
               end
               if type(d) == "table" then
                 local brooml = {debug.getupvalues(b),c}
                 for var, val in next, d do
                    handleVariable(d, var, val)
                    if breakscript then
                        return results
                    end
                 end
               end          
            end
        end
    end
    return results
end

-- Info: search for stuff stored in the garbadge collection [ gc ] for the game!
-- Can be used to make inf ammo for gun games or bypass anti cheats by hooking the functions!
--[[
    Usage: gchook.search(key, optional)

     -- Optional Parameters
    optional["value"] = optional["value"] or nil -- set something [ set index to value ]
    optional["lock"] = optional["lock"] -- lock an index to a certain value, optional["value"] must be used for this to work
    optional["dump"] = optional["dump"] -- retrieve all index and values regardless of name
    optional["get"] = optional["get"] -- to get the raw value of something
    optional["valuesearch"] = optional["valuesearch"] -- search by value, so it will look for things with the value of <key> instead of things with the name of <key>

    -- Set Jailbreak Nitro [if it exist in getgc] to 100 and lock it to that value
    gchook.search("Nitro", {
        value = 100,
        lock = true
    })

    -- Output indexes that contains with "Core" [for coregui or some shit idk]
    print(gchook.search("Core"))

    -- Get the real value of something ur searching for instead of a string
    print(gchook.search("Nitro", {
        get = true
    })) -- number since nitro should be a number in gc

    -- Search for something by its value instead of its name
    -- Lets say it was a building game that had ur money stored as a name not relating to money
    -- If you know the value of the money, you can search for it to reveal the name
    -- For example, we know we have $360,000
    -- This works for functions, tables, strings, etc
    print(gchook.search(360000, {
        valuesearch: true
    })) -- "secret_alternative_name_for_money"
]]
