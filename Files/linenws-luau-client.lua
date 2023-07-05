-- Made for LuaU [ Roblox Exploits ]
-- Written by: Linen#3485 / reallinen [ ON DISCORD.COM ]

-- This is made to be used with: https://reallinen.github.io/redirect.html
-- View the one made for html here: https://reallinen.github.io/Files/linenws-html-client.js

local HttpService = game:GetService("HttpService")
local Socket = {
    ["Connections"] = {},
    ["ParseJson"] = function(...)
        local suc, parsed = pcall(function(...)
            return HttpService:JSONDecode(...)
        end, ...)
        if not suc then
            return false
        else
            return parsed
        end
    end,
    ["StringJson"] = function(...)
        local suc, parsed = pcall(function(...)
            return HttpService:JSONEncode(...)
        end, ...)
        if not suc then
            return false
        else
            return parsed
        end
    end
}

Socket.Connect = function(url)
    url = type(url)=="string" and url or nil
    if not url then return; end

    url = (not (string.find(url, "ws") and string.find(url, "://")) and "ws://"..url:gsub("ws://", ""):gsub("wss://", ""):gsub("://", ""):gsub("://", "")) or url
    local WS = (syn and syn.websocket) or WebSocket or websocket or Websocket or webSocket
    
    if not WS then return "'WebSocket' doesn't exist in this enviorment" end
    local EventsTable, EmitTable = {}, {}

    local lastMessage = ""
    local passed, socket = pcall(WS.connect, url)
    if not passed or not socket then return "Connecting Error: "..tostring(socket) end

    socket.OnClose:Connect(function()
        if type(EventsTable["disconnect"])=="function" then
            EventsTable["disconnect"](lastMessage)
        end
    end)
    socket.OnMessage:Connect(function(message)
        local Json = Socket.ParseJson(message)
        lastMessage = message

        if Json and Json["method"] and typeof(Json["data"])~=nil then
            if typeof(EmitTable[Json["method"]])=="function" then
                EmitTable[Json["method"]](Json["data"])
            end
        else
            if typeof(EventsTable["message"])=="function" then
                EventsTable["message"](message)
            end
        end
    end)

    return {
        ["Socket"] = socket,
        emit = function(method: string, data: any)
            if(type(method)~="string" or type(data)=="nil") then return "emit: method must be a string and data must not be nil/undefined" end

            local stringified = Socket["StringJson"]({ ["method"] = method, ["data"] = data })
            if not stringified then return "Failed to process data" end

            local suc, err = pcall(function() socket:Send(stringified) end)
            if not suc then return err end

            return true
        end,
        send = function(...)
            local suc, err = pcall(function(...) socket:Send(...) end, ...)
            if not suc then return err end

            return true
        end,
        on = function(method: string, callback)
            if(type(method)~="string" or type(callback)~="function") then return "onMessage: Invalid Arguments Passed" end
            EventsTable[method] = callback   
        end,
        onMessage = function(method: string, callback)
            if(type(method)~="string" or type(callback)~="function") then return "onMessage: Invalid Arguments Passed" end
            EmitTable[method] = callback
        end,
        disconnect = function()
            pcall(function() socket:Close() end)
        end
    }
end

return Socket
--[[
local connection = Socket.Connect("ws://localhost:3000") -- If you do not include "ws://" or "wss://" it will automatically default to "ws:// for you
if(type(connection)~="table") then return print("WS Connection Failed: ", connection); end

connection.onMessage("test", function(data)
    print("Method: test |", "Data:", data)
end)

connection.on("disconnect", function(lastMessage)
    print("Disconnected:", lastMessage)
end)

connection.emit("test", 1928313123) 
]]
