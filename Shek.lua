local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_7"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
local keyUI = Instance.new("Frame")
keyUI.Size = UDim2.new(0,320,0,190)
keyUI.Position = UDim2.new(0.5,-160,0.5,-95)
keyUI.BackgroundColor3 = Color3.fromRGB(25,25,25)
keyUI.Parent = gui
Instance.new("UICorner", keyUI)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Enter Key"
keyBox.Text = ""
keyBox.Parent = keyUI
Instance.new("UICorner", keyBox)

local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1,0,0,25)
errorText.BackgroundTransparency = 1
errorText.TextColor3 = Color3.fromRGB(255,60,60)
errorText.Font = Enum.Font.GothamBold
errorText.TextSize = 14
errorText.Parent = keyUI

local enter = Instance.new("TextButton")
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.7,0)
enter.Text = "ENTER"
enter.Parent = keyUI
Instance.new("UICorner", enter)

------------------------------------------------
-- MAIN UI (GLASS STYLE)
------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0,420,0,520)
main.Position = UDim2.new(0.5,-210,0.5,-260)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

-- glow border
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

------------------------------------------------
-- TOP BAR
------------------------------------------------
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,50)
top.BackgroundTransparency = 0.4
top.BackgroundColor3 = Color3.fromRGB(30,30,35)
top.Parent = main
Instance.new("UICorner", top)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB 7.0 PRO"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = top

------------------------------------------------
-- TOGGLE UI
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,120,0,30)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "OPEN / CLOSE"
toggle.Parent = gui
Instance.new("UICorner", toggle)

local open = true

toggle.MouseButton1Click:Connect(function()
	open = not open
	main.Visible = open
end)

------------------------------------------------
-- TAB SYSTEM
------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,45)
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

------------------------------------------------
-- CLEAN
------------------------------------------------
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

------------------------------------------------
-- BUTTON (SMOOTH UI)
------------------------------------------------
local function button(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,38)
	b.BackgroundColor3 = Color3.fromRGB(40,40,50)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
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
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 0.9}):Play()
		task.wait(0.1)
		TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1}):Play()
		func()
	end)
end

------------------------------------------------
-- REAL FLY SYSTEM (FIXED + MOBILE FRIENDLY)
------------------------------------------------
local flying = false
local flySpeed = 50
local bodyGyro
local bodyVelocity

local function startFly()
	if flying then return end
	flying = true

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bodyGyro.CFrame = root.CFrame
	bodyGyro.Parent = root

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
	bodyVelocity.Parent = root

	RunService.RenderStepped:Connect(function()
		if not flying then return end
		local cam = workspace.CurrentCamera
		bodyGyro.CFrame = cam.CFrame

		local move = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			move = move + cam.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			move = move - cam.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			move = move - cam.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			move = move + cam.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			move = move + Vector3.new(0,1,0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			move = move - Vector3.new(0,1,0)
		end

		bodyVelocity.Velocity = move.Unit * flySpeed
	end)
end

local function stopFly()
	flying = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVelocity then bodyVelocity:Destroy() end
end

local function toggleFly()
	if flying then
		stopFly()
	else
		startFly()
	end
end

------------------------------------------------
-- KEY CHECK
------------------------------------------------
enter.MouseButton1Click:Connect(function()
	if keyBox.Text == "Ger" then
		keyUI.Visible = false
		main.Visible = true
	else
		errorText.Text = player.Name .. " не тот ключ!"
	end
end)

------------------------------------------------
-- TABS (SIMPLE CLEAN)
------------------------------------------------
local function load(tab)
	clear()

	if tab == "Movement" then
		button("Fly Toggle", toggleFly)
		button("Speed 60", function() hum.WalkSpeed = 60 end)
		button("Jump Boost", function() hum.JumpPower = 120 end)
		button("Reset", function() player.Character:BreakJoints() end)

	elseif tab == "Visual" then
		button("FullBright", function()
			game.Lighting.Brightness = 3
		end)

	elseif tab == "Player" then
		button("Heal", function() hum.Health = 100 end)
	end
end

------------------------------------------------
-- TAB BUTTONS
------------------------------------------------
local tabs = {"Movement","Visual","Player"}

for i,v in ipairs(tabs) do
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,110,1,0)
	t.Position = UDim2.new(0,(i-1)*115,0,0)
	t.Text = v
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		click:Play()
		load(v)
	end)
end

load("Movement")
