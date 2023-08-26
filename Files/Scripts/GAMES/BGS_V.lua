-- Bubble Gum Simulator V Script
-- Made by a friend

-----------------------------------------
-- Bubble Gum Simulator V Script
-- Made by a friend

-----------------------------------------
-- [ UI Library Credits: Linen & Dawid]
local lib = loadstring(game:HttpGet "https://linenapi.linenporches.repl.co/Files/Libs/UI/VapeUI.lua")()

local win = lib:Window("Bubble Gum Simulator V", Color3.fromRGB(44, 120, 224), Enum.KeyCode.RightControl)

-- [ Services ] --
local replicatedStorage = game:GetService("ReplicatedStorage")

-- [ Values ] --
getgenv().autoBubble = false;
getgenv().hatchEgg = false

-- [ Remote(s) ] --
-- The remotes are created for each client based on their userid and the type of remote.
local remotePath = replicatedStorage:FindFirstChild(string.format("%sEvent",
  game.Players.LocalPlayer.UserId))


-- [ Utility ] --

function Time(Tick)
  if typeof(Tick) ~= "number" then
    return warn('Integer expected, got', typeof(Tick))
  end
  local Tick = tick() - Tick
  local Weeks = math.floor(math.floor(math.floor(math.floor(Tick / 60) / 60) / 24) / 7)
  local Days = math.floor(math.floor(math.floor(Tick / 60) / 60) / 24)
  local Hours = math.floor(math.floor(Tick / 60) / 60)
  local Minutes = math.floor(Tick / 60)
  local Seconds = math.floor(Tick)
  local MilliSeconds = (Tick * 1000)
  local Format = ""
  if Weeks > 0 then
    Format = Format .. string.format("%d Week/s, ", Weeks)
  end
  if Days > 0 then
    Format = Format .. string.format("%d Day/s, ", Days % 7)
  end
  if Hours > 0 then
    Format = Format .. string.format("%d Hour/s, ", Hours % 24)
  end
  if Minutes > 0 then
    Format = Format .. string.format("%d Minute/s, ", Minutes % 60)
  end
  if Seconds > 0 then
    Format = Format .. string.format("%d Second/s, ", Seconds % 60)
  end
  if MilliSeconds > 0 then
    Format = Format .. string.format("%d Ms", MilliSeconds % 1000)
  end
  return Format
end

-- [ Functions ] --

function autoBubble()
  task.spawn(function()
    while getgenv().autoBubble == true do
      remotePath:FireServer(unpack({ [1] = "BlowBubble" }))
      task.wait()
    end
  end)
end

function hatchEgg(eggType, hatchType)
  warn(eggType, hatchType)
  task.spawn(function()
  while getgenv().hatchEgg == true do
    remotePath:FireServer(unpack({ [1] = "PurchaseEgg", [2] = eggType, [3] = hatchType }))
    game:GetService("RunService").RenderStepped:Wait()
    end
  end)
end

function teleportTo(placeCFrame)
  local player = game.Players.LocalPlayer;
  if player.Character then
    player.Character.HumanoidRootPart.CFrame = placeCFrame;
  end
end

function teleportIsland(islandName)
  if workspace.FloatingIslands.Overworld:FindFirstChild(islandName) then
    local islandCFrame = workspace.FloatingIslands.Overworld[islandName].Collision.CFrame * CFrame.new(0, 20, 0)
    teleportTo(islandCFrame)
  end
end

local startTick = tick()

function getAllEggs()
  local allEggs = {}
  local path = workspace.Eggs
  for k, v in pairs(path:GetChildren()) do
    table.insert(allEggs, v.Name)
    task.wait()
  end
  return allEggs
end

function getAllIslands()
  local allIslands = {}
  local path = workspace.FloatingIslands.Overworld
  for k, v in pairs(path:GetChildren()) do
    table.insert(allIslands, v.Name)
  end
  return allIslands
end

-- [ Options ] --
local eggOptions = getAllEggs()

-- [ Debug ] --
warn("Added all eggs to database. Took " .. tostring(Time(startTick)))

local islandOptions = getAllIslands()

-- [ Tabs ] --
local farmTab = win:Tab("Farming")
local teleportsTab = win:Tab("Teleports")
local creditsTab = win:Tab("Credits")

-- [ Farming ] --
farmTab:Label("Bubble Farming Options")
farmTab:Toggle("Auto Bubble", false, function(value)
  getgenv().autoBubble = value
  print("Auto Bubble is: ", value)
  if value then
    autoBubble()
  end
end)

local chosenEgg;
farmTab:Dropdown("Eggs", eggOptions, function(value)
  chosenEgg = value
end)

local chosenHatchType;
farmTab:Dropdown("Hatch Types", { "Single", "Multi" }, function(value)
  chosenHatchType = value;
end)


farmTab:Label("Egg Farming Options")
farmTab:Toggle("Hatch Egg", false, function(value)
  getgenv().hatchEgg = value
  warn(value, chosenEgg, chosenHatchType)
  if value and chosenEgg and chosenHatchType then
    hatchEgg(chosenEgg, chosenHatchType)
  end
end)

-- [ Teleports ] --
local chosenIsland;
teleportsTab:Label("Make sure you are at spawn or this won't work!")
teleportsTab:Dropdown("Islands", islandOptions, function(value)
  chosenIsland = value
  print("Selected Island:", value)
end)
teleportsTab:Button("Teleport Selected", function()
  if chosenIsland then
    teleportIsland(chosenIsland)
  end
end)

-- [ Credits ] --
creditsTab:Label("UI Library - Linen & Dawid")
creditsTab:Label("Programming - You know who it is >:)")
