-- Revamped by Linen
-- Discord: reallinens
-- .17
--[[ .17 FLAGS UPDATE
    Flux.Flags:Get() -- get the flags in a JSON format so you can store and load it using Flux.Flags:Load() [ SUPPORTS Color3, Vector3, EnumItems and etc ]
    Flux.FLags:Load(flags <string>) -- load the stringified JSON/flags
]]

--[[
    * Less detectable
    * Old ui removes on re-execution and disconnects all :Connect events [ less connections, but they prob get removed when the instance gets set to nil so fjiweuhbgjiwjg lmao ]
	@@ -395,7 +400,7 @@ function Flux:Window(config)
		CloseBtn.Size = UDim2.new(0, 366, 0, 43)
		CloseBtn.AutoButtonColor = false
		CloseBtn.Font = Enum.Font.Gotham
		CloseBtn.Text = buttontitle or "ÃƒÂ¢Ã…â€œÃ¢â‚¬Â¦"
		CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CloseBtn.TextSize = 15.000
		CloseBtn.TextTransparency = 1
	@@ -507,6 +512,161 @@ function Flux:Window(config)
			{BackgroundTransparency = 0}
		):Play()
	end

    -- THIS IS CHATGPT CODE CUZ I WAS NOT ABOUT TO WRITE THIS BS
    local HttpService = game:GetService("HttpService")

    -- Custom function to encode Roblox objects
    local function encodeRobloxObject(value)
        if typeof(value) == "Vector3" then
            return { type = "Vector3", x = value.X, y = value.Y, z = value.Z }
        elseif typeof(value) == "Vector2" then
            return { type = "Vector2", x = value.X, y = value.Y }
        elseif typeof(value) == "UDim2" then
            return {
                type = "UDim2",
                xScale = value.X.Scale,
                xOffset = value.X.Offset,
                yScale = value.Y.Scale,
                yOffset = value.Y.Offset
            }
        elseif typeof(value) == "Color3" then
            return { type = "Color3", r = value.R, g = value.G, b = value.B }
        elseif typeof(value) == "CFrame" then
            return { type = "CFrame", matrix = { value:GetComponents() } } -- Store components
        elseif typeof(value) == "BrickColor" then
            return { type = "BrickColor", color = value.Name }
        elseif typeof(value) == "Ray" then
            return { type = "Ray", origin = encodeRobloxObject(value.Origin), direction = encodeRobloxObject(value.Direction) }
        elseif typeof(value) == "NumberRange" then
            return { type = "NumberRange", min = value.Min, max = value.Max }
        elseif typeof(value) == "NumberSequence" then
            local keypoints = {}
            for _, kp in ipairs(value.Keypoints) do
                table.insert(keypoints, { time = kp.Time, value = kp.Value })
            end
            return { type = "NumberSequence", keypoints = keypoints }
        elseif typeof(value) == "PhysicalProperties" then
            return { 
                type = "PhysicalProperties",
                density = value.Density,
                friction = value.Friction,
                elasticity = value.Elasticity,
                frictionWeight = value.FrictionWeight,
                elasticityWeight = value.ElasticityWeight
            }
        elseif typeof(value) == "TweenInfo" then
            return { 
                type = "TweenInfo",
                time = value.Time,
                delayTime = value.DelayTime,
                easingStyle = value.EasingStyle.Name,
                easingDirection = value.EasingDirection.Name,
                repeatCount = value.RepeatCount,
                reverses = value.Reverses
            }
        elseif typeof(value) == "EnumItem" then
            return { type = "EnumItem", enum = value.Enum.Name, value = value.Name }
        else
            return value
        end
    end

    -- Custom function to decode Roblox objects
    local function decodeRobloxObject(value)
        if type(value) == "table" then
            if value.type == "Vector3" then
                return Vector3.new(value.x, value.y, value.z)
            elseif value.type == "Vector2" then
                return Vector2.new(value.x, value.y)
            elseif value.type == "UDim2" then
                return UDim2.new(value.xScale, value.xOffset, value.yScale, value.yOffset)
            elseif value.type == "Color3" then
                return Color3.new(value.r, value.g, value.b)
            elseif value.type == "CFrame" then
                return CFrame.new(unpack(value.matrix))
            elseif value.type == "BrickColor" then
                return BrickColor.new(value.color)
            elseif value.type == "Ray" then
                return Ray.new(decodeRobloxObject(value.origin), decodeRobloxObject(value.direction))
            elseif value.type == "NumberRange" then
                return NumberRange.new(value.min, value.max)
            elseif value.type == "NumberSequence" then
                local keypoints = {}
                for _, kp in ipairs(value.keypoints) do
                    table.insert(keypoints, NumberSequenceKeypoint.new(kp.time, kp.value))
                end
                return NumberSequence.new(keypoints)
            elseif value.type == "PhysicalProperties" then
                return PhysicalProperties.new(
                    value.density,
                    value.friction,
                    value.elasticity,
                    value.frictionWeight,
                    value.elasticityWeight
                )
            elseif value.type == "TweenInfo" then
                return TweenInfo.new(
                    value.time,
                    Enum.EasingStyle[value.easingStyle],
                    Enum.EasingDirection[value.easingDirection],
                    value.repeatCount,
                    value.reverses,
                    value.delayTime
                )
            elseif value.type == "EnumItem" then
                return Enum[value.enum][value.value]
            end
        end
        return value
    end

    -- JSONEncode function that uses the custom encoder
    local function customJSONEncode(object)
        local function recursiveEncode(obj)
            if type(obj) == "table" then
                local newTable = {}
                for k, v in pairs(obj) do
                    newTable[k] = recursiveEncode(v)
                end
                return encodeRobloxObject(newTable)
            else
                return encodeRobloxObject(obj)
            end
        end
        return HttpService:JSONEncode(recursiveEncode(object))
    end

    -- JSONDecode function that uses the custom decoder
    local function customJSONDecode(json)
        local function recursiveDecode(obj)
            if type(obj) == "table" then
                local newTable = {}
                for k, v in pairs(obj) do
                    newTable[k] = recursiveDecode(v)
                end
                return decodeRobloxObject(newTable)
            else
                return decodeRobloxObject(obj)
            end
        end
        return recursiveDecode(HttpService:JSONDecode(json))
    end

    -- Flags
    function Flux.Flags:Get()
        return customJSONEncode(Flux.Flags)
    end
    function Flux.Flags:Load(v)
        if type(v) == "table" then
            Flux.Flags = v
            return true
        elseif typeof(v) == "string" then
            Flux.Flags = customJSONDecode(v)
            return true
        end
        return false
    end
    Flux.Notify = function(a, b, c)
        if a == Flux then -- :Namecall
            Flux:Notification(b, c)
	@@ -936,6 +1096,10 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                if not (config.noflag or config.Noflag or config.NoFlag or config.noFlag) and typeof(Flux.Flags[config.Flag]) ~= "nil" then
                    config.State = Flux.Flags[config.Flag]
                end
            end

            local text, desc, default, callback = config.Name, config.Description, config.State, config.Callback
	@@ -1226,6 +1390,10 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                if not (config.noflag or config.Noflag or config.NoFlag or config.noFlag) and typeof(Flux.Flags[config.Flag]) ~= "nil" then
                    config.Value = Flux.Flags[config.Flag]
                end
            end

            local text, desc, min, max, start, callback = config.Name, config.Description, config.Min, config.Max, config.Value, config.Callback
	@@ -1547,6 +1715,8 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                -- coming soon
            end

            local text, list, callback = config.Name, config.List, config.Callback
	@@ -2043,6 +2213,10 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                if not (config.noflag or config.Noflag or config.NoFlag or config.noFlag) and typeof(Flux.Flags[config.Flag]) ~= "nil" then
                    config.Value = Flux.Flags[config.Flag]
                end
            end

            local text, preset, callback = config.Name, config.Value, config.Callback
	@@ -2549,6 +2723,7 @@ function Flux:Window(config)
            config.Callback = config.Callback or config.callback or config.cb or config.CB or function(...) return ... end
            config.Description = config.Description or config.Desc or config.description or config.desc or ""
            config.Disappear = (config.Disappear==nil and config.disappear==nil) and true or config.Disappear or config.disappear
            config.Text = config.Text or config.text or config.Default or config.default or config.Value or config.value

            if type(config.Flag) == "string" or type(config.Flag) == "boolean" then
                config.Flag = type(config.Flag) == "string" and config.Flag or config.Name
	@@ -2560,6 +2735,10 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                if not (config.noflag or config.Noflag or config.NoFlag or config.noFlag) and typeof(Flux.Flags[config.Flag]) ~= "nil" then
                    config.Text = Flux.Flags[config.Flag]
                end
            end

            local text, desc, disapper, callback = config.Name, config.Description, config.Disappear, config.Callback
	@@ -2665,6 +2844,10 @@ function Flux:Window(config)
			TextBox.Size = UDim2.new(0, 161, 0, 26)
			TextBox.Font = Enum.Font.Gotham
			TextBox.Text = ""
            if (config.Text) then
                TextBox.Text = config.Text
                pcall(config.Callback, TextBox.Text)
            end
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 15.000
			TextBox.TextTransparency = 0.300
	@@ -2811,6 +2994,10 @@ function Flux:Window(config)
                    end
                    return old(...) -- return old callback
                end

                if not (config.noflag or config.Noflag or config.NoFlag or config.noFlag) and typeof(Flux.Flags[config.Flag]) ~= "nil" then
                    config.Value = Flux.Flags[config.Flag]
                end
            end

            if not config.Value then
                return "Must have the index/key 'Bind' set to a Enum.Keycode or Enum.UserInputType in a table and pass it as the first argument!";
            end
            local text, presetbind, callback = config.Name, config.Value, config.Callback
			local Key = presetbind.Name
			local Bind = Instance.new("TextButton")
			local BindCorner = Instance.new("UICorner")
			local Title = Instance.new("TextLabel")
			local Circle = Instance.new("Frame")
			local CircleCorner = Instance.new("UICorner")
			local CircleSmall = Instance.new("Frame")
			local CircleSmallCorner = Instance.new("UICorner")
			local BindLabel = Instance.new("TextLabel")
			Bind.Name = "Bind"
			Bind.Parent = Container
			Bind.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
			Bind.ClipsDescendants = true
			Bind.Position = UDim2.new(0.40625, 0, 0.828947306, 0)
			Bind.Size = UDim2.new(0, 457, 0, 43)
			Bind.AutoButtonColor = false
			Bind.Font = Enum.Font.SourceSans
			Bind.Text = ""
			Bind.TextColor3 = Color3.fromRGB(0, 0, 0)
			Bind.TextSize = 14.000
			BindCorner.CornerRadius = UDim.new(0, 4)
			BindCorner.Name = "BindCorner"
			BindCorner.Parent = Bind
			Title.Name = "Title"
			Title.Parent = Bind
			Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Title.BackgroundTransparency = 1.000
			Title.Position = UDim2.new(0.0822437406, 0, 0, 0)
			Title.Size = UDim2.new(0, 113, 0, 42)
			Title.Font = Enum.Font.Gotham
			Title.Text = text
			Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			Title.TextSize = 15.000
			Title.TextTransparency = 0.300
			Title.TextXAlignment = Enum.TextXAlignment.Left
			Circle.Name = "Circle"
			Circle.Parent = Title
			Circle.Active = true
			Circle.AnchorPoint = Vector2.new(0.5, 0.5)
			Circle.BackgroundColor3 = Color3.fromRGB(211, 211, 211)
			Circle.Position = UDim2.new(-0.150690272, 0, 0.503000021, 0)
			Circle.Size = UDim2.new(0, 11, 0, 11)
			CircleCorner.CornerRadius = UDim.new(2, 6)
			CircleCorner.Name = "CircleCorner"
			CircleCorner.Parent = Circle
			CircleSmall.Name = "CircleSmall"
			CircleSmall.Parent = Circle
			CircleSmall.Active = true
			CircleSmall.AnchorPoint = Vector2.new(0.5, 0.5)
			CircleSmall.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
			CircleSmall.BackgroundTransparency = 1.000
			CircleSmall.Position = UDim2.new(0.485673368, 0, 0.503000021, 0)
			CircleSmall.Size = UDim2.new(0, 9, 0, 9)
			CircleSmallCorner.CornerRadius = UDim.new(2, 6)
			CircleSmallCorner.Name = "CircleSmallCorner"
			CircleSmallCorner.Parent = CircleSmall
			BindLabel.Name = "BindLabel"
			BindLabel.Parent = Title
			BindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			BindLabel.BackgroundTransparency = 1.000
			BindLabel.Position = UDim2.new(2.56011987, 0, 0, 0)
			BindLabel.Size = UDim2.new(0, 113, 0, 42)
			BindLabel.Font = Enum.Font.Gotham
			BindLabel.Text = Key
			BindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			BindLabel.TextSize = 15.000
			BindLabel.TextTransparency = 0.300
			BindLabel.TextXAlignment = Enum.TextXAlignment.Right
			
			Flux.Cache(Bind.MouseEnter:Connect(function()
				TweenService:Create(
					Title,
					TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()
			end))
			Flux.Cache(Bind.MouseLeave:Connect(function()
				TweenService:Create(
					Title,
					TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0.3}
				):Play()
			end))
			Flux.Cache(Bind.MouseButton1Click:Connect(
				function()
					TweenService:Create(
						Title,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = PresetColor}
					):Play()
					TweenService:Create(
						BindLabel,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = PresetColor}
					):Play()
					TweenService:Create(
						Circle,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = PresetColor}
					):Play()
					TweenService:Create(
						CircleSmall,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundTransparency = 0}
					):Play()
					TweenService:Create(
						Title,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextTransparency = 0}
					):Play()
					TweenService:Create(
						BindLabel,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextTransparency = 0}
					):Play()
					BindLabel.Text = "..."
					local inputwait = game:GetService("UserInputService").InputBegan:wait()
					if inputwait.KeyCode.Name ~= "Unknown" then
						BindLabel.Text = inputwait .KeyCode.Name
						Key = inputwait .KeyCode.Name
					end
					TweenService:Create(
						Title,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = Color3.fromRGB(255,255,255)}
					):Play()
					TweenService:Create(
						BindLabel,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextColor3 = Color3.fromRGB(255,255,255)}
					):Play()
					TweenService:Create(
						Circle,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundColor3 = Color3.fromRGB(211, 211, 211)}
					):Play()
					TweenService:Create(
						CircleSmall,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{BackgroundTransparency = 1}
					):Play()
					TweenService:Create(
						Title,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextTransparency = 0.3}
					):Play()
					TweenService:Create(
						BindLabel,
						TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{TextTransparency = 0.3}
					):Play()
				end
			))
			Flux.Cache(game:GetService("UserInputService").InputBegan:Connect(
			function(current, pressed)
				if not pressed then
					if current.KeyCode.Name == Key then
						pcall(callback)
					end
				end
			end
			))
			
			Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y)
		end
		return ContainerContent
	end
	return Tabs
end
--[[
    -- All elements support flags
    local Flux = loadstring(game:HttpGet("https://reallinen.github.io/Files/Scripts/UI/FluxUIRevamped.lua"))()
    local Window = Flux:Window({
        Name = "Baseplate",
        Name2 = "Flux UI",
        Toggle = Enum.KeyCode.LeftAlt -- To toggle the UI visible/not visible
    })
    local Tab = Window:Tab({
        Text = "Tab 1",
        Icon = "rbxassetid://6023426915"
    })
   -- : Button
    Tab:Button({
        Text = "Click me",
        Description = "A button that notify's when you click it",
        Callback = function()
            Flux:Notification("You clicked me!")
        end
    })
    -- : Label
    Tab:Label("This is a label.")
    -- : Line
    Tab:Line()
    -- : Toggle
    Tab:Toggle({
        Text = "Auto-Farm Coins",
        Description = "Collect all the coins in the game [un-functional]",
        Callback = function(value)
            print("Auto-Farm Coins set to:", value)
        end
    })
    -- : Slider
    Tab:Slider({
        Text = "Walkspeed",
        Description = "Makes you faster [un-functional]",
        Default = 16, -- default value
        Min = 1,
        Max = 50,
        Callback = function(value)
            print("Walkspeed:", value)
        end
    })
    -- : Dropdown
    Tab:Dropdown({
        Text = "Part to aim at",
        Callback = function(selection)
            print("Dropdown value:", selection)
        end,
        List = {
            "Torso",
            "Head",
            "Penis"
        }
    })
    -- : Colorpicker
    Tab:Colorpicker({
        Text = "Esp Color",
        Color = Color3.fromRGB(255,1,1),
        Callback = function(color)
            print("New esp color:", color)
        end
    })
    -- : Textbox
    Tab:Textbox({
        Text = "Gun Power",
        Description = "This textbox changes your gun power, so you can kill everyone faster and easier. [un-functional]",
        Callback = function(value)
            print("Gun Power Text:", value)
        end
    })
    -- : Bind
    Tab:Bind({
        Text = "Example Keybind",
        Default = Enum.KeyCode.Q,
        Flag = true, -- if flag is set to true and not a string, it will set the flag's name as the Text, so the flag would be Flux.Flags["Example KeyBind"], else the flag will be the value thats a string
        Callback = function()
            print("Keybind clicked!")
        end
    })
    -- : New Tab
    Window:Tab({ Text = "Tab 2", Icon = "6022668888" })
]]
return Flux
