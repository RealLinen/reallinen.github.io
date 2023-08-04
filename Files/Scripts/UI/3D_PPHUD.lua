-- Original Thread/Credits: https://v3rmillion.net/showthread.php?tid=1188164
-- GET UPDATES: https://discord.gg/rc3TDqKmjN
-- VERSION 0.1

-- PPHUD UI Library, Modified by Linen#3485: https://v3rmillion.net/showthread.php?tid=1214090
--[[ Usage Example By Linen#3485

    Window = Library:Window({ Text = "Name" })

    Tab = Window:Tab({ Text = "Main" })
    Tab:Select() [ selects the tab ]

    Section = Tab:Section({ Text = "Example", Side = Right/Left })


    Section:Dropdown{
        Text: string,
        List: table,
        ChangeText: boolean, [ if false, when an option is selected the dropdowns text wont change ]
        SaveText: boolean, [ if true, when they select an option, it will say "(DropdownText): selected_option" ] [ custom function by Linen#3485 ]
        Callback: function(option: string)
    } -> 
        {
            Select: function(v -> userinput),
            Add: function(v -> userinput),
            Remove: function(v -> userinput), [ removes an element from the dropdown ] [ custom function by Linen#3485 ]
            Refresh: function(table -> userinput),
            Toggle: function(boolean -> userinput), [ show/hide dropdown ]
            Get: function(v -> userinput) [ trys to find 'v' in the dropdown ] [ custom function by Linen#3485 ]
        }

    Section:Label{
        Text: string,
        Color: Color3.fromRGB [ optional ]
    } ->
        {
            Set: function(text: string, color: Color3.fromRGB)
        }

    Section:Slider{
        Text: string,
        Minimum: number,
        Maximum: number, 
        Default: number,
        Callback: function(value: number)
    }

    Section:Button{
        Text: string,
        Callback: function() [ when the button is clicked, callback is fired ]
    }

    Section:Toggle{
        Text: string,
        Callback: function(value: boolean) [ when the toggle is toggled, this fires with the new value of the toggle as the first argument 'value' ]
    } -> 
        {
            Set: function(boolean -> userinput)
        }

    Section:Textbox{ [ The textbox was created entirely by Linen since the UI Library didn't feature it ]
      Text: string,
      Color: Color3.fromRGB, [ optional ]
      Callback: function(str: string),

      TextXAlignment: Enum.TextXAlignment,
      TextYAlignment: Enum.TextYAlignment,
      Properties: table [ custom properties you want the Textbox to have, example: { TextSize = 20 } -- will set the Textbox's TextSize to 20 ]
    } ->
        {
          Set: function(text -> userinput, color [ optional ] -> userinput),
          Get: function() [ gets the text of the textbox ]
        }

]]

local __original_require = require
local function require(link)

    if type(link)=="number" then return __original_require(link) end
    if type(link)~="string" then return nil; end
    local suc,err = pcall(function() return game:HttpGet(link) end)
    -- >.< Deku Demz Is Gay  --
    if suc then return err; end
    return nil

end

pcall(loadstring(require("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua"))) -- Basically try to make it undetectable

local LinenModule: { print: "function( ... )", Loop: "function( func, seconds, yeild, ... )" } = loadstring(require("https://reallinen.github.io/Files/Scripts/LinenModule.lua"))()
local Storage: { Data: {}, Load: "function( folder_name: string )" }, Http: { GET: "function( link: string )" }, Cache: { add: "function( name: string, object: anything/dynamic )", del: "function( name: string )" } = LinenModule["Storage"], LinenModule["Http"], LinenModule["Cache"]
   
for i,v in next, LinenModule do
    if i=="print" then continue; end
    getgenv()[i] = v
end

LinenModule:Load()
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local TS, UIS = game:GetService("TweenService"), game:GetService("UserInputService")
local Player = game:GetService("Players").LocalPlayer

local Character: Model, Head: Part, HumanoidRootPart: Part, Humanoid: Humanoid, Torso: Part, PlayerGui: PlayerGui = Player.Character or Player.CharacterAdded:Wait(), nil, nil, nil, nil, Player:FindFirstChild("PlayerGui");
local Football, CatchHand, CatchHand2;
local Module, LData = {}, {}

Loop(function() 
    Character = Player.Character or nil
    if typeof(Character)~="Instance" then return; end;     
    Head, HumanoidRootPart, Humanoid, Torso, PlayerGui = Character:FindFirstChild("Head"), Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChild("Humanoid"), (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("LowerTorso")), Player:FindFirstChild("PlayerGui"); 
end)

local function HandleEvent(BindableEvent, callback)
	return BindableEvent and type(callback)=="function" and (function() local event = BindableEvent:Connect(callback); Cache.add(event); return event end)() or (function() Cache.add(BindableEvent);return BindableEvent end)()
end
local function WrapFunction(callback, ...)
	return typeof(callback)=="function" and coroutine.wrap(callback)(...) or false
end
--========================== LinUI Library Example --==========================--
if httpget and not (pcall(function() return game.HttpGet() end)) then
    loadstring(httpget("https://linenapi.linenporches.repl.co/Files/Scripts/CeleryHttpFix.lua"))()
end

local library = {
    flags = {},
    WindowToggleKey = Enum.KeyCode.G
}

library.Flags = library.flags

--// Dependences --//
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ViewportSize = workspace.CurrentCamera.ViewportSize
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Utilities = {}

local SCALE = 0.01
local LookView = Vector3.new(0, .1, -11)

--// Compatibility //--
local DropIndex = 9999
local request = syn and syn.request or http and http.request or http_request or request or httprequest
pcall(loadstring(require("https://api.irisapp.ca/Scripts/IrisInstanceProtect.lua")))
--//

function Utilities:Create(Inst, Properties, Childs)

    local Instance = Instance.new(Inst)
    Cache.add(Instance)

    if type(ProtectInstance)=="function" and ((Instance:IsA("ScreenGui") or Instance:IsA("SurfaceGui")) or Instance.ClassName:match("Part")) then
        ProtectInstance(Instance)
    end

    local Properties = Properties or {}
    local Childs = Childs or {}

    local BlacklistedProps = {
        BorderSizePixel = 0,
        Text = "",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }

    for blprop, v in next, BlacklistedProps do
        pcall(
            function()
                Instance[blprop] = v
            end
        )
    end

    for prop, v in next, Properties do
        Instance[prop] = v
    end

    for _, child in next, Childs do
        child.Parent = Instance
    end

    return Instance
end

function Utilities:Round(Number, Increment)
    Increment = 1 / Increment

    return math.round(Number * Increment) / Increment
end

function Utilities:Tween(Inst, Speed, Properties, Style, Direction)
    local Instance = Inst or error("#1 argument: instance expected.")
    local Speed = Speed or .125
    local Properties =
        typeof(Properties) == "table" and Properties or
        error("#3 argument: table expected, got: " .. typeof(Properties))
    local Style = Style or Enum.EasingStyle.Linear
    local Direction = Direction or Enum.EasingDirection.Out

    local Tween = TweenService:Create(Instance, TweenInfo.new(Speed, Style, Direction), Properties)
    Tween:Play()

    return Tween
end

function Utilities:GetXY(GuiObject, x, y)
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py =
        math.clamp((x or Mouse.X) - GuiObject.AbsolutePosition.X, 0, Max),
        math.clamp((y or Mouse.Y )- GuiObject.AbsolutePosition.Y, 0, May)
    return Px / Max, Py / May
end

function Utilities:GetMouse()
    return Vector2.new(Mouse.X, UserInputService:GetMouseLocation().Y - 35)
end

--//

--// Colors --//
local Colors = {
    Primary = Color3.fromRGB(27, 25, 27),
    Secondary = Color3.fromRGB(42, 40, 42),
    Tertiary = Color3.fromRGB(74, 73, 74),
    Divider = Color3.fromRGB(46, 45, 46),
    AccentDivider = Color3.fromRGB(54, 54, 54),
    PrimaryText = Color3.fromRGB(211, 211, 211),
    SecondaryText = Color3.fromRGB(122, 122, 122),
    TertiaryText = Color3.fromRGB(158, 158, 158),
    Hovering = Color3.fromRGB(56, 53, 56),
    Accent = Color3.fromRGB(100, 190, 31),
    DarkerAccent = Color3.fromRGB(87, 167, 26),
    AccentText = Color3.fromRGB(235, 235, 235)
}
--//

function library:Window(WindowArgs)
    WindowArgs.Text = WindowArgs.Text or "Window"

    local WindowTable = {}
    WindowTable.__index = WindowTable

    self.Tabs = 0
    self.Hovering = false

    local SelectedTab = nil
    local generatedName = "LU_"..HttpService:GenerateGUID()

    local Part = Instance.new("Part")
    Cache.add(Part)

    Part.Name = generatedName
    Part.Anchored = true
    Part.CanCollide = false
    Part.Locked = true
    Part.Transparency = 1
    Part.Size = Vector3.new(22.517, 11.59, 2)
    
    if type(ProtectInstance)=="function" then -- If ur exploit doesn't support and you get detected, oh well, read documentation to see what ur exploit has to support to avoid most detections
        ProtectInstance(Part) -- Thanks Iris <3
    end
    
    Cache.add(game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    
        local sizeX = mouse.ViewSizeX
        local sizeY = mouse.ViewSizeY
    
        local mouseX = (mouse.X-mouse.ViewSizeX/2) * SCALE
        local mouseY = (mouse.Y-mouse.ViewSizeY/2) * SCALE
        
        TS:Create(Part, TweenInfo.new(deltaTime), { CFrame =  workspace.CurrentCamera.CFrame * CFrame.new(LookView.X, LookView.Y, LookView.Z) * CFrame.Angles(0, math.rad(mouseX), 0) * CFrame.Angles(math.rad(mouseY) , 0 , 0) }):Play()
        task.wait(deltaTime)
        local scalingFactor = (workspace.CurrentCamera.CFrame.Position - Part.CFrame.Position).Magnitude - LookView.Z	
        --Part.Size = Part.Size / Vector3.new(scalingFactor, 0, scalingFactor)
    
    end));Part.Parent = workspace

    local Window =
        Utilities:Create(
        "SurfaceGui",
        {
            Name = "PPHUD",
            ZIndexBehavior = Enum.ZIndexBehavior.Global
        },
        {
            Utilities:Create(
                "Frame",
                {
                    Name = "Main",
                    Size = UDim2.new(0.6960000276565552, 0, .8, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255), -- Colors.Primary
                    --ClipsDescendants = true,
                    Position = UDim2.new(0.15000001072883606, 0, 0, 0),
                    --Position = UDim2.new(0, 600, 0, 270)
                },
                {
                    Utilities:Create(
                        "UIGradient",
                        {
                            Color = ColorSequence.new(
                                {
                                    ColorSequenceKeypoint.new(0, Color3.fromRGB(27, 25, 27)),
                                    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 12))
                                }
                            ),
                            Offset = Vector2.new(0, 0.65),
                            Rotation = 90
                        }
                    ),
                    Utilities:Create(
                        "Frame",
                        {
                            Name = "Containers",
                            Size = UDim2.new(1, 0, 1, -50),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 0, 0, 26)
                        }
                    ),
                    Utilities:Create(
                        "Frame",
                        {
                            Name = "Bottom",
                            Size = UDim2.new(1, 0, 0, 24),
                            AnchorPoint = Vector2.new(.5, 1),
                            Position = UDim2.new(.5, 0, 1, 0),
                            BackgroundColor3 = Colors.Secondary,
                            ZIndex = DropIndex + 5
                        },
                        {
                            Utilities:Create(
                                "Frame",
                                {
                                    Name = "Divider",
                                    Size = UDim2.new(1, 0, 0, 1),
                                    AnchorPoint = Vector2.new(.5, 0),
                                    BackgroundColor3 = Colors.Divider,
                                    Position = UDim2.new(.5, 0, 0, 0),
                                    ZIndex = DropIndex + 5
                                }
                            ),
                            Utilities:Create(
                                "ImageLabel",
                                {
                                    Name = "ResizeIcon",
                                    Size = UDim2.new(0, 10, 0, 10),
                                    BackgroundTransparency = 1,
                                    Image = "rbxassetid://13438141392",
                                    AnchorPoint = Vector2.new(1, 1),
                                    Position = UDim2.new(1, 0, 1, 0),
                                    ZIndex = DropIndex + 5
                                },
                                {
                                    Utilities:Create(
                                        "TextButton",
                                        {
                                            Name = "ResizeButton",
                                            Size = UDim2.new(0, 10, 0, 10),
                                            BackgroundTransparency = 1,
                                            ZIndex = DropIndex + 5
                                        }
                                    )
                                }
                            ),
                            Utilities:Create(
                                "TextLabel",
                                {
                                    Name = "BottomText",
                                    Text = WindowArgs.Text,
                                    Size = UDim2.new(1, -10, 0, 24),
                                    BackgroundTransparency = 1,
                                    Position = UDim2.new(0, 8, 0, 0),
                                    RichText = true,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextSize = 13,
                                    Font = Enum.Font.SourceSansBold,
                                    TextColor3 = Colors.PrimaryText,
                                    ZIndex = DropIndex + 5
                                },
                                {
                                    Utilities:Create(
                                        "TextButton",
                                        {
                                            Name = "CloseConsole",
                                            BackgroundTransparency = 1,
                                            Text = "",
                                            Size = UDim2.new(1, -10, 0, 24),
                                            ZIndex = 11001
                                        }
                                    )
                                }
                            )
                        }
                    ),
                    Utilities:Create(
                        "Frame",
                        {
                            Name = "Topbar",
                            AnchorPoint = Vector2.new(.5, 0),
                            Position = UDim2.new(.5, 0, 0, 0),
                            BackgroundColor3 = Colors.Secondary,
                            Size = UDim2.new(1, 0, 0, 26)
                        },
                        {
                            Utilities:Create(
                                "Frame",
                                {
                                    Name = "Divider",
                                    Size = UDim2.new(1, 0, 0, 1),
                                    BackgroundColor3 = Colors.Divider,
                                    AnchorPoint = Vector2.new(0.5, 1),
                                    ZIndex = 2,
                                    Position = UDim2.new(.5, 0, 1, 0)
                                }
                            ),
                            Utilities:Create(
                                "Frame",
                                {
                                    Name = "TabContainer",
                                    Size = UDim2.new(1, 0, 0, 26),
                                    BackgroundTransparency = 1,
                                    ClipsDescendants = true
                                },
                                {
                                    Utilities:Create(
                                        "UIListLayout",
                                        {
                                            FillDirection = Enum.FillDirection.Horizontal
                                        }
                                    )
                                }
                            )
                        }
                    )
                }
            )
        }
    )

    HandleEvent(
        UserInputService.InputBegan:Connect(
            function(Input, GameProcessed)
                if GameProcessed then
                    return
                end
                if Input.KeyCode == (library.WindowToggleKey or Enum.KeyCode.G) and not GameProcessed then
                    Window.Enabled = not Window.Enabled
                end
            end
        )
    )

    local Console =
        Utilities:Create(
        "Frame",
        {
            Name = "Console",
            Size = UDim2.new(0, 500, 0, 300),
            Parent = Window.Main,
            AnchorPoint = Vector2.new(.5, .5),
            Visible = false,
            ZIndex = 11000,
            Position = UDim2.fromScale(.5, .5),
            BackgroundColor3 = Colors.Primary
        },
        {
            Utilities:Create(
                "UIStroke",
                {
                    Color = Colors.Divider
                }
            ),
            Utilities:Create(
                "ScrollingFrame",
                {
                    Name = "ConsoleContainer",
                    Size = UDim2.new(0, 500, 0, 276),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Position = UDim2.new(0, 0, 0, 24),
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    ZIndex = 11001
                },
                {
                    Utilities:Create("UIListLayout")
                }
            ),
            Utilities:Create(
                "Frame",
                {
                    Name = "ConsoleTopbar",
                    AnchorPoint = Vector2.new(.5, 0),
                    Position = UDim2.new(.5, 0, 0, 0),
                    BackgroundColor3 = Colors.Secondary,
                    ZIndex = 11001,
                    Size = UDim2.new(1, 0, 0, 24)
                },
                {
                    Utilities:Create(
                        "TextLabel",
                        {
                            Name = "ConsoleText",
                            Text = "Console",
                            Size = UDim2.new(1, -10, 0, 24),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 8, 0, 0),
                            RichText = true,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextSize = 13,
                            Font = Enum.Font.SourceSansBold,
                            TextColor3 = Colors.PrimaryText,
                            ZIndex = 11001
                        }
                    )
                }
            )
        }
    )

    local consoleContainer = Console.ConsoleContainer
    local bottomText = Window.Main.Bottom.BottomText
    local coloredMessage = true
    local scrollSize

    HandleEvent(
        consoleContainer.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                scrollSize = consoleContainer.UIListLayout.AbsoluteContentSize.Y

                consoleContainer.CanvasPosition = Vector2.new(0, scrollSize)
            end
        )
    )

    HandleEvent(
        bottomText.MouseEnter:Connect(
            function()
                Utilities:Tween(bottomText, .125, {TextColor3 = Colors.Accent})
            end
        )
    )

    HandleEvent(
        bottomText.MouseLeave:Connect(
            function()
                Utilities:Tween(bottomText, .125, {TextColor3 = Colors.PrimaryText})
            end
        )
    )

    HandleEvent(
        bottomText.CloseConsole.MouseButton1Click:Connect(
            function()
                --WindowTable:ToggleConsole()
            end
        )
    )

    function WindowTable:ToggleConsole()
        Console.Visible = not Console.Visible
    end

    function WindowTable:Message(consoleArgs)
        consoleArgs.Text = consoleArgs.Text or "Message"
        consoleArgs.Color = consoleArgs.Color or Colors.PrimaryText

        coloredMessage = not coloredMessage

        local currentDate = os.date("%X")

        local finalMessage = string.format("[%s] %s", currentDate, consoleArgs.Text)

        local Message =
            Utilities:Create(
            "Frame",
            {
                Name = "ConsoleMessage",
                BackgroundColor3 = Colors.Divider,
                BackgroundTransparency = coloredMessage and 0 or 1,
                Size = UDim2.new(0, 500, 0, 23),
                ZIndex = 11002,
                Parent = Console.ConsoleContainer
            },
            {
                Utilities:Create(
                    "TextLabel",
                    {
                        Name = "MessageText",
                        Text = finalMessage,
                        Size = UDim2.new(1, 0, 0, 23),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 3, 0, 0),
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 13,
                        Font = Enum.Font.SourceSansBold,
                        TextColor3 = consoleArgs.Color,
                        ZIndex = 11002
                    }
                )
            }
        )
    end
    
    Window["ResetOnSpawn"] = false
	Window["Face"] = Enum.NormalId.Back
	Window["SizingMode"] = Enum.SurfaceGuiSizingMode.PixelsPerStud
	Window["ClipsDescendants"] = true
	Window["Adornee"] = Part
	Window["Name"] = "UI"
	Window["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
	Window["AlwaysOnTop"] = true
	Window["Parent"] = Part
    Window.Parent = Part

    local function dragify(Frame)
        local dragToggle = nil
        local dragSpeed = .45
        local dragInput = nil
        local dragStart = nil
        local dragPos = nil

        local startPos, Delta, Position

        local function updateInput(input)
            Delta = input.Position - dragStart
            Position =
                UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
        end

        HandleEvent(
            Frame.InputBegan:Connect(
                function(input)
                    if
                        (input.UserInputType == Enum.UserInputType.MouseButton1 or
                            input.UserInputType == Enum.UserInputType.Touch)
                     then
                        dragToggle = true
                        dragStart = input.Position
                        startPos = Frame.Position
                        input.Changed:Connect(
                            function()
                                if (input.UserInputState == Enum.UserInputState.End) then
                                    dragToggle = false
                                end
                            end
                        )
                    end
                end
            )
        )

        HandleEvent(
            Frame.InputChanged:Connect(
                function(input)
                    if
                        (input.UserInputType == Enum.UserInputType.MouseMovement or
                            input.UserInputType == Enum.UserInputType.Touch)
                     then
                        dragInput = input
                    end
                end
            )
        )

        HandleEvent(
            UserInputService.InputChanged:Connect(
                function(input)
                    if (input == dragInput and dragToggle) then
                        updateInput(input)
                    end
                end
            )
        )
    end

    local ResizeButton = Window.Main.Bottom.ResizeIcon.ResizeButton
    local TabContainer = Window.Main.Topbar.TabContainer
    local Containers = Window.Main.Containers

    dragify(TabContainer)

    local SizeX = Instance.new("NumberValue", Window.Main)
    SizeX.Name = "X"

    local SizeY = Instance.new("NumberValue", Window.Main)
    SizeY.Name = "Y"

    local function ResizeTabs()
        local TabSize = 1 / self.Tabs

        task.spawn(
            function()
                for _, v in next, TabContainer:GetChildren() do
                    if v.ClassName == "Frame" then
                        v.Size = UDim2.new(TabSize, 0, 0, 26)
                    end
                end
            end
        )
    end

    local function Resize()
        local MouseLocation = Utilities:GetMouse()
        local X = math.clamp(MouseLocation.X - Window.Main.AbsolutePosition.X, 300, 1300)
        local Y = math.clamp(MouseLocation.Y - Window.Main.AbsolutePosition.Y, 165, 730)

        SizeX.Value = X
        SizeY.Value = Y

        Utilities:Tween(Window.Main, .05, {Size = UDim2.new(0, X, 0, Y)})

        ResizeTabs()
    end

    HandleEvent(
        ResizeButton.MouseButton1Down:Connect(
            function()
                local ResizeMove, ResizeKill

                Utilities:Tween(Window.Main.Bottom.ResizeIcon, .125, {ImageColor3 = Colors.Accent})

                ResizeMove =
                    HandleEvent(
                    Mouse.Move:Connect(
                        function()
                            Resize()
                        end
                    )
                )

                ResizeKill =
                    HandleEvent(
                    UserInputService.InputEnded:Connect(
                        function(UserInput)
                            if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
                                ResizeMove:Disconnect()
                                ResizeKill:Disconnect()

                                Utilities:Tween(
                                    Window.Main.Bottom.ResizeIcon,
                                    .125,
                                    {ImageColor3 = Color3.fromRGB(255, 255, 255)}
                                )
                            end
                        end
                    )
                )
                --TweenService:Create(Window.Mai, TweenInfo.new(0.09, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(Scale,0,0,14)}):Play()
            end
        )
    )

    HandleEvent(
        TabContainer.ChildAdded:Connect(
            function()
                self.Tabs = self.Tabs + 1

                ResizeTabs()
            end
        )
    )

    --dragify(Window.Main)

    function WindowTable:Exit()
        Window:Destroy()
    end

    function WindowTable:Toggle()
        Window.Enabled = not Window.Enabled
    end

    function WindowTable:Tab(TabArgs)
        TabArgs.Text = TabArgs.Text or "Tab"

        local TabTable = {}

        local Tab =
            Utilities:Create(
            "Frame",
            {
                Name = "Tab",
                Parent = TabContainer,
                Size = UDim2.new(0, 200, 0, 26),
                BackgroundTransparency = 1
            },
            {
                Utilities:Create(
                    "Frame",
                    {
                        Name = "Divider",
                        AnchorPoint = Vector2.new(.5, 1),
                        Position = UDim2.new(.5, 0, 1, 0),
                        Size = UDim2.new(1, 0, 0, 1),
                        ZIndex = 3,
                        BackgroundColor3 = Colors.Divider
                    }
                ),
                Utilities:Create(
                    "TextLabel",
                    {
                        Name = "TabText",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Text = TabArgs.Text,
                        RichText = true,
                        Font = Enum.Font.SourceSansBold,
                        TextColor3 = Colors.SecondaryText,
                        TextSize = 14,
                        ZIndex = 2
                    }
                ),
                Utilities:Create(
                    "TextButton",
                    {
                        Name = "TabButton",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1
                    }
                )
            }
        )

        dragify(Tab)
        dragify(Tab.Divider)
        ResizeTabs()

        local ContainerHolder =
            Utilities:Create(
            "Frame",
            {
                Name = "ContainerHolder",
                Size = UDim2.new(1, 0, 1, 0),
                Parent = Containers,
                BackgroundTransparency = 1
            },
            {
                Utilities:Create(
                    "UIListLayout",
                    {
                        FillDirection = Enum.FillDirection.Horizontal
                    }
                )
            }
        )

        local Left =
            Utilities:Create(
            "ScrollingFrame",
            {
                Name = "Left",
                BackgroundTransparency = 1,
                Visible = false,
                BackgroundColor3 = Color3.fromRGB(167, 54, 54),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
                ScrollBarThickness = 0,
                Parent = ContainerHolder,
                Size = UDim2.new(.5, 0, 0, 350)
            },
            {
                Utilities:Create("UIListLayout"),
                Utilities:Create(
                    "UIPadding",
                    {
                        PaddingLeft = UDim.new(0, 8)
                    }
                )
            }
        )

        local Right =
            Utilities:Create(
            "ScrollingFrame",
            {
                Name = "Right",
                BackgroundTransparency = 1,
                Visible = false,
                BackgroundColor3 = Color3.fromRGB(45, 175, 62),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
                ScrollBarThickness = 0,
                Parent = ContainerHolder,
                Size = UDim2.new(.5, 0, 0, 350),
                Position = UDim2.new(0, 300, 0, 0)
            },
            {
                Utilities:Create("UIListLayout"),
                Utilities:Create(
                    "UIPadding",
                    {
                        PaddingLeft = UDim.new(0, 6)
                    }
                )
            }
        )

        HandleEvent(
            Tab.MouseEnter:Connect(
                function()
                    if SelectedTab == nil or SelectedTab ~= Tab then
                        Utilities:Tween(Tab.Divider, .125, {BackgroundColor3 = Colors.Tertiary})
                        Utilities:Tween(Tab.TabText, .125, {TextColor3 = Colors.PrimaryText})
                    end
                end
            )
        )

        HandleEvent(
            Tab.MouseLeave:Connect(
                function()
                    if SelectedTab == nil or Tab ~= SelectedTab then
                        Utilities:Tween(Tab.Divider, .125, {BackgroundColor3 = Colors.Divider})
                        Utilities:Tween(Tab.TabText, .125, {TextColor3 = Colors.SecondaryText})
                    end
                end
            )
        )

        function TabTable:Select()
            SelectedTab = Tab

            task.spawn(
                function()
                    for _, v in next, Containers:GetChildren() do
                        if v.Name == "ContainerHolder" then
                            if v.Left ~= Left then
                                v.Left.Visible = false
                                v.Right.Visible = false
                            end
                        end
                    end

                    for _, v in next, TabContainer:GetChildren() do
                        if v.ClassName == "Frame" and v ~= Tab then
                            Utilities:Tween(v.Divider, .125, {BackgroundColor3 = Colors.Divider})
                            Utilities:Tween(v.TabText, .125, {TextColor3 = Colors.SecondaryText})
                        end
                    end
                end
            )

            Left.Visible = true
            Right.Visible = true
            Utilities:Tween(Tab.Divider, .125, {BackgroundColor3 = Colors.DarkerAccent})
            Utilities:Tween(Tab.TabText, .125, {TextColor3 = Colors.AccentText})
        end

        HandleEvent(
            Tab.TabButton.MouseButton1Click:Connect(
                function()
                    TabTable:Select()
                end
            )
        )
        HandleEvent(
            Tab.MouseLeave:Connect(
                function()
                    if SelectedTab == nil or Tab ~= SelectedTab then
                        Utilities:Tween(Tab.Divider, .125, {BackgroundColor3 = Colors.Divider})
                        Utilities:Tween(Tab.TabText, .125, {TextColor3 = Colors.SecondaryText})
                    end
                end
            )
        )

        function TabTable:Section(SectionArgs)
            SectionArgs.Text = SectionArgs.Text or "Section"
            SectionArgs.Side = SectionArgs.Side or "Left"

            local SectionTable = {}

            local Section =
                Utilities:Create(
                "Frame",
                {
                    Name = "Section",
                    Parent = SectionArgs.Side == "Left" and Left or Right,
                    BackgroundColor3 = Color3.fromRGB(167, 54, 54),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 286, 0, 36) -- +64
                },
                {
                    Utilities:Create(
                        "TextLabel",
                        {
                            Name = "SectionText",
                            Size = UDim2.new(0, 286, 0, 26),
                            Text = SectionArgs.Text,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextSize = 14,
                            BackgroundTransparency = 1,
                            TextColor3 = Colors.PrimaryText,
                            RichText = true,
                            Font = Enum.Font.SourceSansBold,
                            ZIndex = 2
                        }
                    ),
                    Utilities:Create(
                        "Frame",
                        {
                            Name = "Divider",
                            Position = UDim2.new(0, 0, 0, 28),
                            Size = UDim2.new(0, 286, 0, 1),
                            BackgroundColor3 = Colors.Divider
                        }
                    ),
                    Utilities:Create(
                        "Frame",
                        {
                            Name = "Container",
                            Size = UDim2.new(0, 286, 0, 0),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 0, 0, 38)
                        },
                        {
                            Utilities:Create(
                                "UIListLayout",
                                {
                                    SortOrder = Enum.SortOrder.LayoutOrder
                                }
                            )
                        }
                    )
                }
            )

            local SectionY = 36

            HandleEvent(
                SizeX:GetPropertyChangedSignal("Value"):Connect(
                    function()
                        local Size = SizeX.Value / 2 - 14
                        Section.Size = UDim2.new(0, Size, 0, SectionY)
                        Section.Divider.Size = UDim2.new(0, Size, 0, 1)
                    end
                )
            )

            local SectionContainer = Section.Container

            HandleEvent(
                SectionContainer.ChildAdded:Connect(
                    function()
                        SectionY = SectionY + 21

                        Section.Size = UDim2.new(0, 286, 0, SectionY)
                        SectionContainer.Size = UDim2.new(0, 286, 0, SectionY)
                    end
                )
            )

            function SectionTable:Toggle(CheckArgs)
                CheckArgs.Text = CheckArgs.Text or "Check"
                CheckArgs.Flag = CheckArgs.Flag or nil
                CheckArgs.Default = CheckArgs.Default or false
                CheckArgs.Callback = CheckArgs.Callback or function()
                    end

                local State = false

                local CheckTable = {}

                local Check =
                    Utilities:Create(
                    "Frame",
                    {
                        Name = "Check",
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21),
                        BackgroundTransparency = 1
                    },
                    {
                        Utilities:Create(
                            "TextButton",
                            {
                                Name = "CheckButton",
                                Size = UDim2.new(0, 14, 0, 14),
                                BackgroundTransparency = 1
                            }
                        ),
                        Utilities:Create(
                            "Frame",
                            {
                                Name = "CheckFrame",
                                Size = UDim2.new(0, 14, 0, 14),
                                BackgroundTransparency = 1
                            },
                            {
                                Utilities:Create(
                                    "TextLabel",
                                    {
                                        Name = "CheckText",
                                        Text = CheckArgs.Text,
                                        TextSize = 13,
                                        RichText = true,
                                        Font = Enum.Font.SourceSansBold,
                                        Size = UDim2.new(0, 14, 0, 14),
                                        TextXAlignment = Enum.TextXAlignment.Left,
                                        Position = UDim2.new(0, 20, 0, 0),
                                        TextColor3 = Colors.PrimaryText,
                                        BackgroundTransparency = 1
                                    }
                                ),
                                Utilities:Create(
                                    "Frame",
                                    {
                                        Name = "CheckInner",
                                        AnchorPoint = Vector2.new(.5, .5),
                                        Position = UDim2.new(.5, 0, .5, 0),
                                        Size = UDim2.new(0, 12, 0, 12),
                                        BackgroundColor3 = Colors.Secondary
                                    }
                                ),
                                Utilities:Create(
                                    "UIStroke",
                                    {
                                        Color = Colors.Divider
                                    }
                                )
                            }
                        )
                    }
                )

                local CheckButton = Check.CheckButton

                local TextBounds = Check.CheckFrame.CheckText.TextBounds
                local ButtonSize = TextBounds.X ~= "" and TextBounds.X + 20 or 14

                HandleEvent(
                    CheckButton.MouseEnter:Connect(
                        function()
                            if not State then
                                Utilities:Tween(Check.CheckFrame.UIStroke, .125, {Color = Colors.Tertiary})
                                Utilities:Tween(Check.CheckFrame.CheckInner, .125, {BackgroundColor3 = Colors.Hovering})
                            end
                        end
                    )
                )

                HandleEvent(
                    CheckButton.MouseLeave:Connect(
                        function()
                            if not State then
                                Utilities:Tween(Check.CheckFrame.UIStroke, .125, {Color = Colors.Divider})
                                Utilities:Tween(
                                    Check.CheckFrame.CheckInner,
                                    .125,
                                    {BackgroundColor3 = Colors.Secondary}
                                )
                            end
                        end
                    )
                )

                CheckButton.Size = UDim2.new(0, ButtonSize, 0, 14)

                function CheckTable:Set(bool)
                    task.spawn(CheckArgs.Callback, bool)
                    State = bool
                    if CheckArgs.Flag ~= nil then
                        library.Flags[CheckArgs.Flag] = bool
                    end

                    if State then
                        Utilities:Tween(Check.CheckFrame.UIStroke, .125, {Color = Colors.Accent})
                        Utilities:Tween(Check.CheckFrame.CheckInner, .125, {BackgroundColor3 = Colors.Accent})
                    else
                        Utilities:Tween(Check.CheckFrame.UIStroke, .125, {Color = Colors.Divider})
                        Utilities:Tween(Check.CheckFrame.CheckInner, .125, {BackgroundColor3 = Colors.Secondary})
                    end
                end

                HandleEvent(
                    CheckButton.MouseButton1Click:Connect(
                        function()
                            State = not State

                            CheckTable:Set(State)
                        end
                    )
                )

                return CheckTable
            end

            function SectionTable:Button(Info)
                Info.Text = Info.Text or "Button"
                Info.Callback = Info.Callback or function()
                    end

                local Button =
                    Utilities:Create(
                    "Frame",
                    {
                        Name = "Button",
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21),
                        BackgroundTransparency = 1
                    },
                    {
                        Utilities:Create(
                            "Frame",
                            {
                                Name = "ButtonFrame",
                                BackgroundColor3 = Colors.Secondary,
                                Size = UDim2.new(0, 14, 0, 14)
                            },
                            {
                                Utilities:Create(
                                    "UIStroke",
                                    {
                                        Color = Colors.Divider
                                    }
                                ),
                                Utilities:Create(
                                    "TextLabel",
                                    {
                                        Name = "ButtonText",
                                        Size = UDim2.new(1, 0, 1, 0),
                                        Text = Info.Text,
                                        RichText = true,
                                        Font = Enum.Font.SourceSansBold,
                                        BackgroundTransparency = 1,
                                        TextSize = 13,
                                        TextColor3 = Colors.PrimaryText
                                    }
                                ),
                                Utilities:Create(
                                    "TextButton",
                                    {
                                        Name = "ButtonButton",
                                        Size = UDim2.new(1, 0, 1, 0),
                                        BackgroundTransparency = 1
                                    }
                                )
                            }
                        )
                    }
                )

                local Hovering = false

                HandleEvent(
                    Button.ButtonFrame.MouseEnter:Connect(
                        function()
                            Hovering = true
                            Utilities:Tween(Button.ButtonFrame, .125, {BackgroundColor3 = Colors.Hovering})
                            Utilities:Tween(Button.ButtonFrame.UIStroke, .125, {Color = Colors.AccentDivider})
                        end
                    )
                )

                HandleEvent(
                    Button.ButtonFrame.MouseLeave:Connect(
                        function()
                            Hovering = false
                            Utilities:Tween(Button.ButtonFrame, .125, {BackgroundColor3 = Colors.Secondary})
                            Utilities:Tween(Button.ButtonFrame.UIStroke, .125, {Color = Colors.Divider})
                        end
                    )
                )

                local TextX = math.clamp(Button.ButtonFrame.ButtonText.TextBounds.X, 15, 1000)

                Button.ButtonFrame.Size = UDim2.new(0, TextX + 10, 0, 14)

                HandleEvent(
                    Button.ButtonFrame.ButtonButton.MouseButton1Down:Connect(
                        function()
                            Utilities:Tween(Button.ButtonFrame.UIStroke, .1, {Color = Colors.Accent})
                            Utilities:Tween(Button.ButtonFrame.ButtonText, .1, {TextColor3 = Colors.AccentText})
                        end
                    )
                )

                HandleEvent(
                    Button.ButtonFrame.ButtonButton.MouseButton1Up:Connect(
                        function()
                            Utilities:Tween(Button.ButtonFrame.ButtonText, .1, {TextColor3 = Colors.PrimaryText})
                            if Hovering then
                                Utilities:Tween(Button.ButtonFrame.UIStroke, .125, {Color = Colors.AccentDivider})
                            else
                                Utilities:Tween(Button.ButtonFrame.UIStroke, .125, {Color = Colors.Divider})
                            end
                        end
                    )
                )

                HandleEvent(
                    Button.ButtonFrame.ButtonButton.MouseButton1Click:Connect(
                        function()
                            task.spawn(Info.Callback)
                        end
                    )
                )
            end

            function SectionTable:Slider(Info)
                Info.Text = Info.Text or "Slider"
                Info.Flag = Info.Flag or nil
                Info.Default = Info.Default or 10
                Info.Minimum = Info.Minimum or 5
                Info.Maximum = Info.Maximum or 20
                Info.Incrementation = Info.Incrementation or 1
                Info.Postfix = Info.Postfix or ""
                Info.Callback = Info.Callback or function()
                    end

                if Info.Minimum > Info.Maximum then
                    local ValueBefore = Info.Minimum
                    Info.Minimum, Info.Maximum = Info.Maximum, ValueBefore
                end

                local DefaultValue = math.clamp(Info.Default, Info.Minimum, Info.Maximum)
                local Rounded = Utilities:Round(DefaultValue, Info.Incrementation)

                local DefaultScale = (Rounded - Info.Minimum) / (Info.Maximum - Info.Minimum)

                local StepFormat = "%d"
                local Step = Info.Incrementation

                for i = 1, 10 do
                    if Step == 1 then
                        break
                    end

                    StepFormat = "%." .. i .. "f"
                    if StepFormat:format(Step) == tostring(Step) then
                        break
                    end
                end

                local Slider = Utilities:Create(
                    "Frame",
                    {
                        Name = "Slider",
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21),
                        BackgroundTransparency = 1
                    },
                    {
                        Utilities:Create(
                            "Frame",
                            {
                                Name = "SliderOuter",
                                BackgroundColor3 = Colors.Secondary,
                                Size = UDim2.new(.6, 3, 0, 14)
                            },
                            {
                                Utilities:Create(
                                    "UIStroke",
                                    {
                                        Color = Colors.AccentDivider
                                    }
                                ),
                                Utilities:Create(
                                    "Frame",
                                    {
                                        Name = "SliderInner",
                                        BackgroundColor3 = Colors.DarkerAccent,
                                        Size = UDim2.fromScale(DefaultScale, 1)
                                    }
                                ),
                                Utilities:Create(
                                    "TextLabel",
                                    {
                                        Name = "SliderValueText",
                                        Text = StepFormat:format(Rounded) .. Info.Postfix,
                                        TextSize = 13,
                                        Font = Enum.Font.SourceSansBold,
                                        RichText = true,
                                        Size = UDim2.new(1, 0, 0, 14),
                                        TextColor3 = Color3.fromRGB(255, 255, 255),
                                        BackgroundTransparency = 1
                                    }
                                ),
                                Utilities:Create(
                                    "TextButton",
                                    {
                                        Name = "SliderButton",
                                        Size = UDim2.new(1, 0, 1, 0),
                                        BackgroundTransparency = 1
                                    }
                                ),
                                Utilities:Create(
                                    "TextLabel",
                                    {
                                        Name = "SliderText",
                                        Text = Info.Text,
                                        TextSize = 13,
                                        Font = Enum.Font.SourceSansBold,
                                        RichText = true,
                                        Size = UDim2.new(1, 0, 0, 14),
                                        TextXAlignment = Enum.TextXAlignment.Left,
                                        Position = UDim2.new(1, 6, 0, 0),
                                        TextColor3 = Colors.PrimaryText,
                                        BackgroundTransparency = 1
                                    }
                                )
                            }
                        )
                    }
                )

                HandleEvent(
                    SizeX:GetPropertyChangedSignal("Value"):Connect(
                        function()
                            local Size = SizeX.Value / 2 - 14
                            --Slider.Size = UDim2.new(0, Size, 0, 21)
                        end
                    )
                )

                HandleEvent(
                    Slider.SliderOuter.MouseEnter:Connect(
                        function()
                            Utilities:Tween(Slider.SliderOuter.UIStroke, .125, {Color = Colors.Tertiary})
                            Utilities:Tween(Slider.SliderOuter, .125, {BackgroundColor3 = Colors.Hovering})
                        end
                    )
                )

                HandleEvent(
                    Slider.SliderOuter.MouseLeave:Connect(
                        function()
                            Utilities:Tween(Slider.SliderOuter.UIStroke, .125, {Color = Colors.AccentDivider})
                            Utilities:Tween(Slider.SliderOuter, .125, {BackgroundColor3 = Colors.Secondary})
                            Utilities:Tween(
                                Slider.SliderOuter.SliderInner,
                                .125,
                                {BackgroundColor3 = Colors.DarkerAccent}
                            )
                        end
                    )
                )

                HandleEvent(
                    Slider.SliderOuter.SliderButton.MouseButton1Down:Connect(
                        function()
                            Utilities:Tween(Slider.SliderOuter.SliderInner, .125, {BackgroundColor3 = Colors.Accent})
                        end
                    )
                )

                HandleEvent(
                    Slider.SliderOuter.SliderButton.MouseButton1Up:Connect(
                        function()
                            Utilities:Tween(
                                Slider.SliderOuter.SliderInner,
                                .125,
                                {BackgroundColor3 = Colors.DarkerAccent}
                            )
                        end
                    )
                )

                local MinSize = 0
                local MaxSize = 1

                local SliderInner: Frame = Slider.SliderOuter.SliderInner
                local SliderButton: TextButton = Slider.SliderOuter.SliderButton

                local SizeFromScale = (MinSize + (MaxSize - MinSize)) * DefaultScale
                SizeFromScale = SizeFromScale - (SizeFromScale % 2)

                HandleEvent(
                    SliderButton.MouseMoved:Connect(function(x, y)

                        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return end
                        local Px = Utilities:GetXY(Slider.SliderOuter, x, y)
                        local ScaledValue = Px * (Info.Maximum - Info.Minimum) + Info.Minimum
                        local RoundedValue = Utilities:Round(ScaledValue, Info.Incrementation)
                        local FinalValue = math.clamp(RoundedValue, Info.Minimum, Info.Maximum)
                        local SizeX = (FinalValue - Info.Minimum) / (Info.Maximum - Info.Minimum)

                        Utilities:Tween(SliderInner, 0.09, {
                                Size = UDim2.new(SizeX, 0, 1, 0)
                        })

                        if Info.Flag then
                            library.Flags[Info.Flag] = FinalValue
                        end

                        Slider.SliderOuter.SliderValueText.Text = StepFormat:format(FinalValue) .. Info.Postfix
                        task.spawn(Info.Callback, FinalValue)
                    end)
                )
                
            end

            function SectionTable:Label(Info)
                Info.Text = Info.Text or "Label"
                Info.Color = Info.Color or Colors.PrimaryText

                local LabelTable = {}

                local Label =
                    Utilities:Create(
                    "Frame",
                    {
                        Name = "Label",
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21),
                        BackgroundTransparency = 1
                    },
                    {
                        Utilities:Create(
                            "TextLabel",
                            {
                                Name = "LabelText",
                                Text = Info.Text,
                                TextColor3 = Info.Color,
                                RichText = true,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(0, 286, 0, 14),
                                TextXAlignment = Enum.TextXAlignment.Left,
                                TextSize = 13,
                                Font = Enum.Font.SourceSansBold
                            }
                        )
                    }
                )

                function LabelTable:Set(str, color)
                    str = str or Label.LabelText.Text
                    color = color or Info.Color

                    Label.LabelText.Text = str
                    Label.LabelText.TextColor3 = color
                end

                return LabelTable
            end

            function SectionTable:Textbox(Info)
                Info.Text = Info.Text or "Label"
                Info.Color = Info.Color or Colors.PrimaryText
                Info.Callback = Info.Callback or function(...)
                        return (...)
                    end
                Info.TextXAlignment =
                    typeof(Info.TextXAlignment) == "Enum" and Info.TextXAlignment or Enum.TextXAlignment.Center
                Info.TextYAlignment =
                    typeof(Info.TextYAlignment) == "Enum" and Info.TextYAlignment or Enum.TextYAlignment.Center
                Info.Properties = type(Info.Properties) == "table" and Info.Properties or {}

                local TextboxTable = {}

                local Label =
                    Utilities:Create(
                    "Frame",
                    {
                        Name = "Label",
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21),
                        BackgroundColor3 = Colors.Secondary,
                        BackgroundTransparency = 0.5
                    },
                    {
                        Utilities:Create(
                            "TextBox",
                            {
                                Name = "LabelText",
                                Text = Info.Text,
                                TextColor3 = Info.Color,
                                RichText = true,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(0, 286, 0, 14),
                                TextXAlignment = (Info.TextXAlignment or Enum.TextXAlignment.Center),
                                TextYAlignment = (Info.TextYAlignment or Enum.TextYAlignment.Center),
                                TextSize = 13,
                                Font = Enum.Font.SourceSansBold
                            }
                        )
                    }
                )

                for i, v in next, Info.Properties do
                    if type(i) == "string" then
                        pcall(
                            function()
                                Label.LabelText[i] = v
                            end
                        )
                    end
                end

                local TxtBox: TextBox = Label.LabelText
                HandleEvent(
                    TxtBox.FocusLost:Connect(function()
                        if TxtBox.Text:gsub(" ", "")~="" then
                            Info.Callback(TxtBox.Text)
                        end
                    end)
                )

                function TextboxTable:Set(str, color)
                    str = str or TxtBox.Text
                    color = color or Info.Color

                    Info.Callback(str)
                    TxtBox.Text = str
                    TxtBox.TextColor3 = color
                end

                function TextboxTable:Get()
                    return Label.LabelText.Text
                end

                return TextboxTable
            end

            function SectionTable:Dropdown(Info)
                Info.Text = Info.Text or "Dropdown"
                Info.Flag = Info.Flag or nil
                Info.Multi = Info.Multi or false
                Info.Default = Info.Default or nil
                Info.List = Info.List or {}
                Info.ChangeText = type(Info.ChangeText) == "nil" and true or Info.ChangeText

                local State = false

                local DropdownTable = {}
                DropdownTable.Index = DropIndex
                local DropdownY = 0

                local Dropdown =
                    Utilities:Create(
                    "Frame",
                    {
                        Name = "Dropdown",
                        BackgroundTransparency = 1,
                        Parent = SectionContainer,
                        Size = UDim2.new(0, 286, 0, 21)
                    },
                    {
                        Utilities:Create(
                            "Frame",
                            {
                                Name = "DropdownFrame",
                                Size = UDim2.new(.6, 3, 0, 14),
                                BackgroundColor3 = Colors.Secondary,
                                ClipsDescendants = true,
                                ZIndex = DropdownTable.Index
                            },
                            {
                                Utilities:Create(
                                    "UIStroke",
                                    {
                                        Color = Colors.AccentDivider
                                    }
                                ),
                                Utilities:Create(
                                    "TextLabel",
                                    {
                                        Name = "DropdownText",
                                        BackgroundTransparency = 1,
                                        Text = Info.Text,
                                        Size = UDim2.new(1, 0, 0, 14),
                                        TextXAlignment = Enum.TextXAlignment.Left,
                                        RichText = true,
                                        Position = UDim2.new(0, 4, 0, 0),
                                        TextSize = 13,
                                        TextColor3 = Colors.TertiaryText,
                                        Font = Enum.Font.SourceSansBold,
                                        ZIndex = DropdownTable.Index
                                    }
                                ),
                                Utilities:Create(
                                    "TextButton",
                                    {
                                        Name = "DropdownButton",
                                        BackgroundTransparency = 1,
                                        Size = UDim2.new(1, 0, 0, 14),
                                        ZIndex = DropdownTable.Index
                                    }
                                ),
                                Utilities:Create(
                                    "Frame",
                                    {
                                        Name = "DropdownContainer",
                                        Size = UDim2.new(1, 0, 0, 0),
                                        BackgroundTransparency = 1,
                                        ClipsDescendants = true,
                                        Position = UDim2.new(0, 0, 0, 14),
                                        ZIndex = DropdownTable.Index
                                    },
                                    {
                                        Utilities:Create("UIListLayout")
                                    }
                                ),
                                Utilities:Create(
                                    "Frame",
                                    {
                                        Name = "GradientHolder",
                                        Size = UDim2.new(0, 20, 0, 14),
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                        Position = UDim2.new(1, -41, 0, 0),
                                        ZIndex = DropdownTable.Index
                                    },
                                    {
                                        Utilities:Create(
                                            "UIGradient",
                                            {
                                                Color = ColorSequence.new(
                                                    {
                                                        ColorSequenceKeypoint.new(0, Colors.Secondary),
                                                        ColorSequenceKeypoint.new(1, Colors.Secondary)
                                                    }
                                                ),
                                                Transparency = NumberSequence.new(
                                                    {
                                                        NumberSequenceKeypoint.new(0, 1),
                                                        NumberSequenceKeypoint.new(1, 0)
                                                    }
                                                )
                                            }
                                        )
                                    }
                                ),
                                Utilities:Create(
                                    "Frame",
                                    {
                                        Name = "DropdownImageContainer",
                                        Size = UDim2.new(0, 21, 0, 14),
                                        BackgroundColor3 = Colors.Tertiary,
                                        Position = UDim2.new(1, -21, 0, 0),
                                        ZIndex = DropdownTable.Index
                                    },
                                    {
                                        Utilities:Create(
                                            "UIStroke",
                                            {
                                                Color = Colors.AccentDivider
                                            }
                                        ),
                                        Utilities:Create(
                                            "ImageLabel",
                                            {
                                                Name = "DropdownImage",
                                                Size = UDim2.new(0, 10, 0, 10),
                                                BackgroundTransparency = 1,
                                                Rotation = 0, -- 180
                                                Image = "rbxassetid://13438142817",
                                                AnchorPoint = Vector2.new(.5, .5),
                                                Position = UDim2.new(.5, 0, .5, 0),
                                                ZIndex = DropdownTable.Index
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )

                HandleEvent(
                    SizeX:GetPropertyChangedSignal("Value"):Connect(
                        function()
                            local Size = SizeX.Value / 2 - 14
                            Dropdown.Size = UDim2.new(0, Size, 0, 21)
                        end
                    )
                )

                HandleEvent(
                    Dropdown.DropdownFrame.MouseEnter:Connect(
                        function()
                            if not State then
                                Utilities:Tween(Dropdown.DropdownFrame, .125, {BackgroundColor3 = Colors.Hovering})
                            end
                        end
                    )
                )

                HandleEvent(
                    Dropdown.DropdownFrame.MouseLeave:Connect(
                        function()
                            if not State then
                                Utilities:Tween(Dropdown.DropdownFrame, .125, {BackgroundColor3 = Colors.Secondary})
                            end
                        end
                    )
                )

                local DropdownContainer = Dropdown.DropdownFrame.DropdownContainer
                local DropdownImage = Dropdown.DropdownFrame.DropdownImageContainer.DropdownImage

                function DropdownTable:Toggle(bool)
                    State = bool

                    if State then
                        Utilities:Tween(Dropdown.DropdownFrame, .2, {BackgroundColor3 = Colors.Secondary})
                        DropdownContainer.Size = DropdownContainer.Size + UDim2.fromOffset(0, DropdownY)
                        Dropdown.DropdownFrame.Size = Dropdown.DropdownFrame.Size + UDim2.fromOffset(0, DropdownY)
                        DropdownImage.Rotation = 90
                    else
                        DropdownContainer.Size = DropdownContainer.Size - UDim2.fromOffset(0, DropdownY)
                        Dropdown.DropdownFrame.Size = Dropdown.DropdownFrame.Size - UDim2.fromOffset(0, DropdownY)
                        DropdownImage.Rotation = 0
                    end
                end

                if Info.Default then
                    task.spawn(Info.Callback, Info.Default)
                    if Info.Flag then
                        library[Info.Flag] = Info.Default
                    end
                    if Info.ChangeText then
                        Dropdown.DropdownFrame.DropdownText.Text = Info.Default
                    end
                end

                function DropdownTable:Select(v)
                    task.spawn(Info.Callback, v)

                    if Info.ChangeText then
                        Dropdown.DropdownFrame.DropdownText.Text =
                            (Info.SaveText and ("%s: %s"):format(Info.Text, v) or v)
                    end
                end

                local MultiTable = {}

                local function OnPick(v)
                    if Info.Multi then
                        if not table.find(MultiTable, v.DropdownElementText.Text) then
                            Utilities:Tween(v, .125, {BackgroundTransparency = .95})
                            Utilities:Tween(v.DropdownElementText, .125, {TextColor3 = Colors.Accent})
                            table.insert(MultiTable, v.DropdownElementText.Text)
                        else
                            Utilities:Tween(v, .125, {BackgroundTransparency = 1})
                            Utilities:Tween(v.DropdownElementText, .125, {TextColor3 = Colors.PrimaryText})
                            for i, e in next, MultiTable do
                                if v.DropdownElementText.Text == e then
                                    table.remove(MultiTable, i)
                                end
                            end
                        end
                        task.spawn(Info.Callback, MultiTable)

                        if Info.ChangeText then
                            Dropdown.DropdownFrame.DropdownText.Text = ""
                            for i, z in next, MultiTable do
                                Dropdown.DropdownFrame.DropdownText.Text =
                                    Dropdown.DropdownFrame.DropdownText.Text .. (i ~= #MultiTable and z .. ", " or z)
                            end
                            if string.len(Dropdown.DropdownFrame.DropdownText.Text) == 0 then
                                Dropdown.DropdownFrame.DropdownText.Text = Info.Text
                            end
                        end
                    else
                        DropdownTable:Select(v.DropdownElementText.Text)
                        DropdownTable:Toggle(false)
                    end
                end

                function DropdownTable:Refresh(table)
                    for _, v in next, DropdownContainer:GetChildren() do
                        if v.ClassName == "Frame" then
                            v:Destroy()
                            DropdownY = DropdownY - 14

                            if State then
                                DropdownContainer.Size = DropdownContainer.Size - UDim2.fromOffset(0, 14)
                                Dropdown.DropdownFrame.Size = Dropdown.DropdownFrame.Size - UDim2.fromOffset(0, 14)
                            end
                        end
                    end

                    for _, v in next, table do
                        DropdownTable:Add(v)
                    end
                end

                function DropdownTable:Get(str)
                    str = type(str) == "string" and str or nil
                    if not str then
                        return false
                    end
                    for i, v in next, DropdownContainer:GetChildren() do
                        local element =
                            v.Name == "DropdownElement" and v:FindFirstChild("DropdownElementText") and v or nil
                        if element and element.DropdownElementText.Text:lower() == str:lower() then
                            return element
                        end
                    end
                    return nil
                end
                function DropdownTable:Remove(str)
                    local element = DropdownTable:Get(str)
                    if not element then
                        return false
                    end
                    -------------------
                    DropdownY = DropdownY - 14
                    if State then
                        DropdownContainer.Size = DropdownContainer.Size - UDim2.fromOffset(0, 14)
                        Dropdown.DropdownFrame.Size = Dropdown.DropdownFrame.Size - UDim2.fromOffset(0, 14)
                    end
                    -------------------
                    element:Destroy()
                end
                function DropdownTable:Add(str)
                    DropdownY = DropdownY + 14

                    if State then
                        DropdownContainer.Size = DropdownContainer.Size + UDim2.fromOffset(0, 14)
                        Dropdown.DropdownFrame.Size = Dropdown.DropdownFrame.Size + UDim2.fromOffset(0, 14)
                    end

                    local DropdownElement =
                        Utilities:Create(
                        "Frame",
                        {
                            Name = "DropdownElement",
                            Size = UDim2.new(1, 0, 0, 14),
                            Parent = DropdownContainer,
                            BackgroundTransparency = 1,
                            ZIndex = DropdownTable.Index
                        },
                        {
                            Utilities:Create(
                                "TextLabel",
                                {
                                    Name = "DropdownElementText",
                                    Text = str,
                                    Size = UDim2.new(1, 0, 1, 0),
                                    TextSize = 13,
                                    BackgroundTransparency = 1,
                                    RichText = true,
                                    TextColor3 = Colors.PrimaryText,
                                    Font = Enum.Font.SourceSansBold,
                                    ZIndex = DropdownTable.Index
                                }
                            ),
                            Utilities:Create(
                                "TextButton",
                                {
                                    Name = "DropdownElementButton",
                                    Size = UDim2.new(1, 0, 1, 0),
                                    BackgroundTransparency = 1,
                                    ZIndex = DropdownTable.Index
                                }
                            )
                        }
                    )

                    HandleEvent(
                        DropdownElement.MouseEnter:Connect(
                            function()
                                if not table.find(MultiTable, DropdownElement.DropdownElementText.Text) then
                                    Utilities:Tween(DropdownElement, .125, {BackgroundTransparency = .95})
                                    Utilities:Tween(
                                        DropdownElement.DropdownElementText,
                                        .125,
                                        {TextColor3 = Colors.Accent}
                                    )
                                end
                            end
                        )
                    )

                    HandleEvent(
                        DropdownElement.MouseLeave:Connect(
                            function()
                                if not table.find(MultiTable, DropdownElement.DropdownElementText.Text) then
                                    Utilities:Tween(DropdownElement, .125, {BackgroundTransparency = 1})
                                    Utilities:Tween(
                                        DropdownElement.DropdownElementText,
                                        .125,
                                        {TextColor3 = Colors.PrimaryText}
                                    )
                                end
                            end
                        )
                    )

                    HandleEvent(
                        DropdownElement.DropdownElementButton.MouseButton1Click:Connect(
                            function()
                                OnPick(DropdownElement)
                            end
                        )
                    )
                end

                for _, v in next, Info.List do
                    DropdownTable:Add(v)
                end

                HandleEvent(
                    Dropdown.DropdownFrame.DropdownButton.MouseButton1Click:Connect(
                        function()
                            State = not State

                            DropdownTable:Toggle(State)
                        end
                    )
                )

                DropIndex = DropIndex - 1

                return DropdownTable
            end

            return SectionTable
        end

        return TabTable
    end

    return WindowTable
end
----------------------------------------------------
return library
