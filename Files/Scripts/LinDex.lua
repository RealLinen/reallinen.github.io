-- LinDex V1.5.1 | Profile: https://v3rm.net/members/linen.418/
-- Documentation: https://v3rm.net/threads/lindex-make-roblox-game-exploiting-easier.9629/


local start = (tick or os.clock)(); -- for debugging
local Properties; -- gather all propertiies
local AllClasses; -- gather all class data
local Cached = getgenv()["Cached-#LinDEX"] or {};
local Services = {};

-- Get Decesdants of everything
if not Cached["Loaded"] then -- so we don't cause lag on re-execution
    -- For getting class properties
    local function GetClassProperties()
    local HttpService = game:GetService("HttpService")
    local URL = "https://anaminus.github.io/rbx/json/api/latest.json"    
    local Classes = {}
    
    local GetAPIData; GetAPIData = function()
        local success, response = pcall(function()
            return game:HttpGet(URL)
        end)
    
        if success then
            return response
        else
            task.wait(3)
            return GetAPIData()
        end
    end
    
    local apiData = GetAPIData()
    apiData = HttpService:JSONDecode(apiData)
    for _, entry in ipairs(apiData) do
        local entryType = entry.type

        if entryType == "Class" then
            
            local className = entry.Name
            local Superclass = entry.Superclass
            local classData = {
                ["Name"] = "Name"
            }
            
            if Superclass then
                local superclassData = Classes[Superclass]
                if superclassData then
                    for _, data in ipairs(superclassData) do
                        classData[data] = data
                    end
                end
            end

            Classes[className] = classData
            
        elseif entryType == "Property" then
            
            local className = entry.Class
            local propertyName = entry.Name

            if not next(entry.tags) then
                local classData = Classes[className]

                if classData then
                    classData[propertyName] = propertyName
                end
            end
        end
    end
    
    return function(ClassName: string)
        return ClassName and Classes[ClassName] or Classes
    end
    end

    -- Initialize the table
    getgenv()["Cached-#LinDEX"] = { Loaded = { ClassName = "__IGNORE", Objects = 0, Properties = GetClassProperties() } }
    getgenv()["Cached-#LinDEX"]["Loaded"]["AllClasses"] = getgenv()["Cached-#LinDEX"]["Loaded"]["Properties"]()

    -- Get all game services
    for i, v in next, game:GetChildren() do
        local success = pcall(function()
            return game.GetChildren(game, game.GetService(game, v.Name))
        end)
        if success then
            Services[v.Name] = v
        end
    end
    getgenv()["Cached-#LinDEX"]["Loaded"]["Services"] = Services

    -- Cache all items
    local ItemBy = {}
    for classname, properties in next, getgenv()["Cached-#LinDEX"]["Loaded"]["AllClasses"] do
        for propname, _ in next, properties do
            ItemBy[propname] = {"any", function(obj, value)
                if typeof(value) == "function" then -- yes you can pass functions as the value, it gets called with the object as the first argument so you can do checks before returning true to pass it or false to not
                    local suc, code = pcall(value, obj)
                    if suc and code then
                        return true
                    else
                        return false
                    end
                end
                local val = obj[propname]
                return val == value
            end}
        end
    end
    getgenv()["Cached-#LinDEX"]["Loaded"]["ItemBy"] = ItemBy

    local other = {}
    for i, v in next, Services do
        for _, obj in next, v:GetDescendants() do
            if typeof(obj) == "Instance" then
                other[obj] = obj
                obj.ChildAdded:Connect(function(_obj)
                    if other[_obj] then
                        --already:cached
                        return
                    end

                    --proceed:
                    other[_obj] = _obj
                    getgenv()["Cached-#LinDEX"][#getgenv()["Cached-#LinDEX"]+1] = _obj
                    getgenv()["Cached-#LinDEX"]["Loaded"]["Objects"] += 1
                end)
                obj.ChildRemoved:Connect(function(_obj)
                    other[_obj] = nil
                    getgenv()["Cached-#LinDEX"]["Loaded"]["Objects"] -= 1
                end)
            end
            getgenv()["Cached-#LinDEX"][#getgenv()["Cached-#LinDEX"]+1] = obj
            getgenv()["Cached-#LinDEX"]["Loaded"]["Objects"] += 1
        end
    end; 
    task.wait(1) -- Just Incase
    getgenv()["Cached-#LinDEX"]["Loaded"]["Done"] = true;
end
Properties = getgenv()["Cached-#LinDEX"]["Loaded"]["Properties"]
AllClasses = getgenv()["Cached-#LinDEX"]["Loaded"]["AllClasses"]
Services = getgenv()["Cached-#LinDEX"]["Loaded"]["Services"]

-- this line will prevent no objects getting listed
repeat task.wait(.1) until getgenv()["Cached-#LinDEX"]["Loaded"]["Done"]

-- Functions
local Library = {
    ItemBy = { -- List for the 'GetItemBy' function [ auto-generated during runtime ]
    }
}

Library.ItemBy =  getgenv()["Cached-#LinDEX"]["Loaded"]["ItemBy"]
Library.GetInstancePath = function(inst)
    if typeof(inst) == "Instance" then
        local name = inst:GetFullName()
        local newname = name
        local serv = string.split(name, ".")
        if Services[serv[1]] then
            newname = "game:GetService('"..Services[serv[1]].Name.."')" -- could of used ` but idk if exploits supported it yet
            serv[1] = nil
            for i, v in next, serv do
                if v then
                    local touse = '"' -- smart parsing
                    if v:find('"') then
                        touse = "'"
                    end
                    if v:find("'") then
                        touse = '< ?CANNOT PARSE? >' -- they won, but you will still know where it starts and ends
                    end
                    newname ..= "["..touse..v..touse.."]"
                end
            end
            name = newname
        end
        return name
    end
    return ""
end
Library.GetItemBy = function(index, value, customcheck)
    customcheck = type(customcheck) == "function" and customcheck or function() return true end
    local dump = {}
    -- Loop
    for i, v in next, Library.ItemBy do
        --invalid:type
        if type(v) ~= "table" or index ~= i then
            continue;
        end

        --type:checking
        local typeindex = typeof(value)
        local passed = true
        local callback = type(v[1]) == "function" and v[1] or type(v[2]) == "function" and v[2] or nil

        if type(v[1]) ~= "function" then
            if v[1] ~= "any" and typeindex ~= v[1] then
                passed = false
            end
        end
        if not passed or not callback then
            continue
        end

        --gather:objects
        for i, obj in next, Cached do
            local classN = Properties(obj.ClassName)
            if type(classN) ~= "table" then
                continue -- prevent errors
            end
            --check:method
            local found = classN[index]
            if not found then
                continue
            end

            --proceed->
            if callback(obj, value) and customcheck(obj) then
                local sorted = {obj} -- this will confuse people so i've disabled it
                dump[#dump+1] = obj
            end
        end
    end
    return dump
end

-- Debugging
local endtime = (tick or os.clock)()
Library["Debug"] = function()
    print("Loaded in", (endtime - start).."s")
    print("Items Cached", getgenv()["Cached-#LinDEX"]["Loaded"]["Objects"])
    --endtime = (tick or os.clock)() - start
end

-- Starting the cache so we don't get bugs/errors
if not getgenv()["Cached-#LinDEX"]["Loaded"]["__ran"] then
    getgenv()["Cached-#LinDEX"]["Loaded"]["__ran"] = true
    for i = 1, 2 do
        game:GetService("HttpService"):JSONEncode(Library.GetItemBy("Name", "_"))
        game:GetService("HttpService"):JSONEncode(Library.GetItemBy("Text", "_"))
        game:GetService("HttpService"):JSONEncode(Library.GetItemBy("Health", 10))
    end
end

--Library["Debug"]()
return Library
