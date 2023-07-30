-- Written by: Linen#3485 [ on discord.com ]
-- Optimized for performance, can be re-executed as many times as you want

-- V3rmillion Profile: https://v3rmillion.net/member.php?action=profile&uid=2467334
-- Version 0.5

local Module = { LuaLoopCount = 0 }
local CustomData = {}

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

setmetatable(CustomData, {
    __index = function(...)
        return rawget(...)
    end,
    __newindex = function(...)
        return rawset(...)
    end,
    __call = function(...) 
        return (...) -- self
    end
})

getgenv = getgenv or (getreg or debug and debug.getregistry) or function() return CustomData end
getgenv = type(getgenv)=="function" and getgenv or CustomData -- Incase ur exploit is really shitty shitty
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local create_folder = makefolder or createfolder or newfolder or make_folder or new_folder or create_folder
    local folder_exist = isfolder or is_folder or folderexist or folder_exist
    local new_file = writefile or write_file or newfile or createfile or new_file or create_file
    local file_exist = isfile or doesfileexist or file_exist or fileexist or does_fileexist or does_file_exist
    local read_file = readfile or read_file or read_file_data or readfiledata or readfilebytes or read_file_bytes or readfile_bytes or read_filebytes
    assert(create_folder and folder_exist and new_file and file_exist and read_file and hookmetamethod, "Exploit not supported. [ CreateFolder, FolderExist, Hookmetamethod, newfile, fileexist ]")
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local WrapFunction = function(func, ...) return type(func)=="function" and coroutine.wrap(func)(...) or false end -- coroutine.wrap without having to use () at the end

-------------------------
--~~~~~~~~~~~~ Safe Functions
function Module:EndObject(object, tb, ind)
    if object then
        pcall(function() object:Destroy() end)
        pcall(function() object:Disconnect() end)
        pcall(function() object:Remove() end)
        pcall(function() object:Close() end)

        return true
    end
    if type(tb)=="table" and ind then
        tb[ind] = nil
    end

    return false
end

Module["L_wait"] = function()
    for i = 1, 5 do 
        task.wait()
        RunService.Heartbeat:Wait()
        RunService.RenderStepped:Wait()
        RunService.PreRender:Wait() 
    end
end

Module["TweenObjects"] = function(tweeninfo, propertyTable, ...)
    local objects = {...}
    propertyTable = type(propertyTable)=="table" and propertyTable or {}
    tweeninfo = typeof(tweeninfo)=="TweenInfo" and tweeninfo or TweenInfo.new(1)
    local Tweens = {}

    for i,v in next, objects do
        pcall(function()
            local Tween = TweenService:Create(v, tweeninfo, propertyTable)
            Tweens[v] = Tween
        end)
    end

    for i,v in next, Tweens do
        v:Play()
    end
    return Tweens
end

Module["FileExist"] = function(...)
    local suc,err = pcall(read_file, ...)
    return suc and err or false
end

Module["FolderExist"] = function(...)
    local suc,err = pcall(folder_exist, ...)
    return suc and err or false
end

Module["getTableCount"] = function(v)
    if type(v)~="table" then return 0 end
    local count = 0;for i,v in next, v do count+=1 end;return count
end

Module["getInTable"] = function(v, amt: number)
    if type(v)~="table" then return nil end
    amt = type(amt)=="number" and amt or 1
    local count = 0;for i,v in next, v do count+=1;if count==amt then return v, i, amt end end;return nil
end

Module["CheckType"] = function(a, b, c)
    if type(b)~="string" then return c end
    return typeof(a):lower()==b:lower() and a or c
end

Module["isnumber"] = function(str)
    local suc,err = pcall(function()return str/1 end)
    if not suc then return false; end
    return err
end

Module["L_print"] = function(...)
    local tb = {...}
    local doneMessage = ""
    for i = 1, #tb do
        local inst = tb[i]
        local result = "Output Undefined"

        local suc, err = pcall(tostring, inst)
        local _suc, _err = pcall(function()return (typeof(inst)=="Instance" and inst:GetFullName().." | " or "").."type<"..typeof(inst)..">" end)
        if suc then result = err else result = (_suc and _err or result) end

        doneMessage ..= result..(i==#tb and "" or " ")
    end
    return (rconsoleprint or print)("\n"..(type(doneMessage)=="string" and doneMessage or "Output Undefined"))
end

Module["Loop"] = function(func: "Function to run in the loop", seconds: "Each second to loop | 0 = none", yeild: "Wether you want the loop to yeild", ...: "Arguments to pass to the 'func'")
    seconds = type(seconds) == "number" and seconds or nil
    if(type(seconds)=="number" and 0 >= seconds)then seconds = nil end

    func = type(func)=="function" and func or nil
    if not func then return { Stop = function() end, End = function() end}; end

    local WrapFunction = function(func, ...)if type(func)=="function"then coroutine.wrap(func)(...);return(...)end;return false;end
    local breakLoop = false
    --|||||||||||||||
    local function mainLoop(...)
        local tim = tick()
        while game:GetService("RunService").Heartbeat:Wait() and getgenv().LU_Loaded and not breakLoop do
            if seconds then
                if tick()-tim >= seconds-.1 then
                    tim = tick()
                    WrapFunction(function(...)
                        local suc, err = pcall(func, ...)
                        if not suc then Module["L_print"]((" [ LuaLoop #%s Bug ]: "..tostring(err)):format(Module.LuaLoopCount)) end
                    end, ...)
                end
            else
                WrapFunction(function(...)
                    local suc, err = pcall(func, ...)
                    if not suc then Module["L_print"]((" [ LuaLoop #%s Bug ]: "..tostring(err)):format(Module.LuaLoopCount)) end
                end, ...)
            end
        end
    end

    if yeild then
        mainLoop(...)
    else
        WrapFunction(function(...)
            local suc, err = pcall(mainLoop, ...)
            if not suc then Module["L_print"]((" [ LuaLoop #%s Bug ]: "..tostring(err)):format(Module.LuaLoopCount)) end
        end, ...)
    end
    --|||||||||||||||
    Module.LuaLoopCount += 1
    return {
        Stop = function()
            breakLoop = true
            return true
        end,
        End = function()
            breakLoop = true
            return true
        end
    }
end

--~~~~~~~~~~~~ Table Functions
if setreadonly then setreadonly(table, false) end

table.slice = table.slice or function(tbl: {}, first: number, last: number, step: number) -- Works like JavaScripts slice
    local sliced = {}

    pcall(function()
        for i = first or 1, last or #tbl, step or 1 do
            sliced[#sliced+1] = tbl[i]
        end
    end)

    return sliced
end

--~~~~~~~~~~~~ Caching Framework
Module.Cache = {
    add = function(name: string, value: any)
        local GlobalCache = getgenv().LU_Loaded or Module:LoadCache()
        local cacheName = name or #GlobalCache["Cache"]+1

        GlobalCache["Cache"][cacheName] = value
    end,

    del = function(name: string)
        local GlobalCache = getgenv().LU_Loaded or Module:LoadCache()
        local cacheName = name or #GlobalCache["Cache"]+1
    
        Module:EndObject(GlobalCache["Cache"][cacheName], GlobalCache["Cache"], cacheName)    
    end
}

--~~~~~~~~~~~~ Http Functions
Module.Http = {
    GET = function(link)
        
        if type(link)~="string" then return nil; end
        local suc,err = pcall(function() return game:HttpGet(link) end)
        -- >.< Deku Demz Is Gay  --
        if suc then return err; end
        return nil

    end
}

--~~~~~~~~~~~~ Storage Functions [ Data Saving / Flags ]
Module.Storage = {
    Data = {
        -- This is where Data will be saved / Loaded to
        -- Before accessing this table, please use this once: Module.Storage.Load()
    }, 

    Load = function( baseName, saveEach: number | "How often you want the data to save, Defaults to 1") -- Storage.Load("FolderName") -- [ If folder doesn't exist, it creates ]
        baseName = type(baseName)=="number" and baseName or "LinenModule"
        saveEach = type(saveEach)=="number" and saveEach or 1

        if not Module.FolderExist(baseName) then create_folder(baseName) end
        baseName ..= "/"..tostring(game.PlaceId)..".txt"

        if not Module.FileExist(baseName) then new_file(baseName, "{}") end
        local CharData = Module.FileExist(baseName) or "{}"

        local isdecodeable = pcall(function() CharData = HttpService:JSONDecode(CharData) end)
        if not isdecodeable then CharData = {}; new_file(baseName, "{}") end

        if type(Module.Storage)=="table" then

            if type(Module.Storage["Data"])~="table" then
                Module.Storage["Data"] = {}
            end

            if Module.Storage["FlagsLoaded"] then
                return; -- Incase you used Module.Storage.Load twice on accident
            end

            Module.Storage["Data"] = type(CharData)=="table" and CharData or {}
            Module.Storage["FlagsLoaded"] = true

        end

        WrapFunction(function() -- Basically how the data saves
            if httpget then -- celery detected?!?!
                warn("Cant save file on celery, causes lag. But you can manually write the new options ur self.")
                pcall(new_file, baseName, "{}")
                return;
            end

            Module["Loop"](function()
                local JsonPassed, JsonToString = pcall(function()
                    return HttpService:JSONEncode(Module.Storage["Data"])
                end)

                if JsonPassed and type(JsonToString)=="string" and Module.FileExist(baseName) then
                    pcall(new_file, baseName, JsonToString)
                end
            end, saveEach)
        end)
    end
}


--
function Module:Load(force) 
    if not force and Module.Loaded then return; end -- If you want to re-load the module for some reason [ not recommended ]

    if type(getgenv().LU_Loaded) == "table" then
        for i, ev in next, getgenv().LU_Loaded["Cache"] do
            pcall(function() ev:Destroy() end)
            pcall(function() ev:Disconnect() end)
            pcall(function() ev:Remove() end)
            pcall(function() ev:Close() end)
        end
    end

    getgenv().LU_Loaded = false

    for i = 1, 5 do 
        task.wait()
        RunService.Heartbeat:Wait()
        RunService.RenderStepped:Wait()
        RunService.PreRender:Wait() 
    end

    getgenv().LU_Loaded = { startTime = tick(), Events = {}, Cache = {} }
    return getgenv().LU_Loaded 

end
--

Module:Load() -- Important / required
return Module

--[[ Usage Example:

local LinenModule: { L_print: "function( ... )", Loop: "function( func, seconds, yeild, ... )" } = loadstring(game:HttpGet("https://reallinen.github.io/Files/Scripts/LinenModule.lua"))()
local Storage: { Data: {}, Load: "function( folder_name: string )" }, Http: { GET: "function( link: string )" }, Cache: { add: "function( name: string, object: anything/dynamic )", del: "function( name: string )" } = LinenModule["Storage"], LinenModule["Http"], LinenModule["Cache"]
   
for i,v in next, LinenModule do
    if i=="print" then continue; end
    getgenv()[i] = v
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print(Loop, L_print, FileExist, FolderExist, CheckType, Storage) -- function, function, function, function, function, { Data: {}, Load: function }

]]
