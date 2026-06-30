local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_4"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 500)
main.Position = UDim2.new(0.5, -190, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Parent = gui
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

task.spawn(function()
	while true do
		for i=0,1,0.01 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait(0.02)
		end
	end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB 4.0"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

-- GREETING
local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,20)
greet.Position = UDim2.new(0,0,0,30)
greet.BackgroundTransparency = 1
greet.Text = "привет " .. player.Name .. "!"
greet.TextColor3 = Color3.fromRGB(180,180,180)
greet.Font = Enum.Font.Gotham
greet.TextSize = 13
greet.Parent = main

-- TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.Position = UDim2.new(0,0,0,60)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-110)
content.Position = UDim2.new(0,0,0,110)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,6)

local click = Instance.new("Sound", main)
click.SoundId = "rbxassetid://12221967"
click.Volume = 1

-- STATES
local speedOn = false
local fly = false
local noclip = false
local infJump = false

-- CLEAR UI
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

-- 🔥 BUTTON WITH ANIMATION
local function button(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,38)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Parent = content
	Instance.new("UICorner", b)

	local scale = Instance.new("UIScale", b)

	b.MouseEnter:Connect(function()
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1.05}):Play()
	end)

	b.MouseLeave:Connect(function()
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1}):Play()
	end)

	b.MouseButton1Click:Connect(function()
		click:Play()

		-- click animation
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 0.9}):Play()
		task.wait(0.1)
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1}):Play()

		callback()
	end)
end

-- MOVEMENT
local function toggleSpeed()
	speedOn = not speedOn
	hum.WalkSpeed = speedOn and 60 or 16
end

local function toggleJump()
	hum.JumpPower = 120
end

local function toggleInfJump()
	infJump = not infJump
end

RunService.Jumping:Connect(function()
	if infJump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- FLY
local bodyVel
local function toggleFly()
	fly = not fly

	if fly then
		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(999999,999999,999999)
		bodyVel.Parent = char:WaitForChild("HumanoidRootPart")

		RunService.RenderStepped:Connect(function()
			if fly and bodyVel then
				bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
			end
		end)
	else
		if bodyVel then bodyVel:Destroy() end
	end
end

-- NOCLIP
RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- WORLD
local function fullBright()
	Lighting.Brightness = 3
	Lighting.ClockTime = 14
end

local function lowG()
	workspace.Gravity = 50
end

local function normalG()
	workspace.Gravity = 196
end

-- FUN EFFECTS
local function rainbowSky()
	for i=0,1,0.01 do
		Lighting.Ambient = Color3.fromHSV(i,1,1)
		task.wait(0.05)
	end
end

-- TABS
local function loadTab(tab)
	clear()

	if tab == "Movement" then
		button("Speed 60", toggleSpeed)
		button("Fly Toggle", toggleFly)
		button("Infinite Jump", toggleInfJump)
		button("Jump Boost", toggleJump)

	elseif tab == "Combat" then
		button("Auto Click (fake)", function() end)
		button("Hitbox Expand (visual)", function() end)
		button("Aim Assist (visual)", function() end)

	elseif tab == "Visual" then
		button("Full Bright", fullBright)
		button("Low Gravity", lowG)
		button("Normal Gravity", normalG)
		button("Rainbow Lighting", rainbowSky)

	elseif tab == "Player" then
		button("Noclip Toggle", function()
			noclip = not noclip
		end)

	elseif tab == "World" then
		button("Destroy Fog", function()
			Lighting.FogEnd = 100000
		end)

	elseif tab == "Misc" then
		button("Reset Character", function()
			player.Character:BreakJoints()
		end)
	end
end

-- TABS UI
local tabs = {
	"Movement","Combat","Visual","Player","World","Misc"
}

for i,v in ipairs(tabs) do
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,60,1,0)
	t.Position = UDim2.new(0,(i-1)*62,0,0)
	t.Text = v
	t.BackgroundColor3 = Color3.fromRGB(30,30,30)
	t.TextColor3 = Color3.new(1,1,1)
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		click:Play()
		loadTab(v)
	end)
end

loadTab("Movement")

-- TOGGLE UI
local open = true
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,100,0,30)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "UI"
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	open = not open
	main.Visible = open
	click:Play()
end)
