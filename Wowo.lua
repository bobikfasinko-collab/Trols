local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_UI_3"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 460)
main.Position = UDim2.new(0.5, -180, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Parent = gui
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

-- RGB border
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
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB 3.0"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

-- GREETING
local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,20)
greet.Position = UDim2.new(0,0,0,35)
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
content.Size = UDim2.new(1,0,1,-100)
content.Position = UDim2.new(0,0,0,100)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,6)

local click = Instance.new("Sound", main)
click.SoundId = "rbxassetid://12221967"
click.Volume = 1

-- STATES
local fly = false
local speedOn = false
local noclip = false

local speedVal = 16

-- CLEAN UI
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

-- BUTTON
local function button(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,40)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Parent = content
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		click:Play()
		func()
	end)
end

-- SPEED
local function toggleSpeed()
	speedOn = not speedOn

	if speedOn then
		hum.WalkSpeed = 60
	else
		hum.WalkSpeed = 16
	end
end

-- JUMP
local function toggleJump()
	if hum.UseJumpPower then
		hum.JumpPower = 120
	else
		hum.JumpHeight = 25
	end
end

-- FLY (simple)
local bodyVel
local function toggleFly()
	fly = not fly

	if fly then
		bodyVel = Instance.new("BodyVelocity")
		bodyVel.MaxForce = Vector3.new(999999,999999,999999)
		bodyVel.Velocity = Vector3.zero
		bodyVel.Parent = char:WaitForChild("HumanoidRootPart")

		RunService.RenderStepped:Connect(function()
			if fly and bodyVel then
				bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
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

-- TABS
local function loadTab(tab)
	clear()

	if tab == "Visual" then
		button("Full Bright", function()
			game.Lighting.Brightness = 3
			game.Lighting.ClockTime = 14
		end)

	elseif tab == "Combat" then
		button("Speed Toggle", toggleSpeed)
		button("Jump Boost", toggleJump)
		button("Fly Toggle", toggleFly)

	elseif tab == "Player" then
		button("Noclip Toggle", function()
			noclip = not noclip
		end)

	elseif tab == "Misc" then
		button("Reset Character", function()
			player.Character:BreakJoints()
		end)
	end
end

-- CREATE TAB BUTTONS
local function tab(name, x)
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,85,1,0)
	t.Position = UDim2.new(0,x,0,0)
	t.Text = name
	t.BackgroundColor3 = Color3.fromRGB(30,30,30)
	t.TextColor3 = Color3.new(1,1,1)
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		click:Play()
		loadTab(name)
	end)
end

tab("Visual", 0)
tab("Combat", 90)
tab("Player", 180)
tab("Misc", 270)

loadTab("Visual")

-- TOGGLE UI
local open = true
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,120,0,30)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "UI"
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	open = not open
	main.Visible = open
	click:Play()
end)
