if not getgenv().LRubi then
    getgenv().LRubi = loadstring(game:HttpGet('https://scripts.luawl.com/hosted/1175/21146/Rubi.lua'))()
end
return getgenv().LRubi 
-- Version: 0.1
--[[
{
    json = {
        encode: function(table),
        decode: function(string)
    }
    wrap = function(data: table/string, ...)
        - > metatable [ you can call the table to execute the script ]
          globals: {} -- editable
}
]]
