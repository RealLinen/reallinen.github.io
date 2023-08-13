if not getgenv().LRubi then
    getgenv().LRubi = loadstring(game:HttpGet('https://scripts.luawl.com/hosted/1175/21146/Rubi.lua'))()
end
return getgenv().LRubi 
--[[
{
    wrap = function(data: table/string, ...)
}
]]
