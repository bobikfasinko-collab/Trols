local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_10_FULL"
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
keyBox.Parent = keyUI
Instance.new("UICorner", keyBox)

local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1,0,0,25)
errorText.BackgroundTransparency = 1
errorText.TextColor3 = Color3.fromRGB(255,0,0)
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
-- MAIN UI
------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0,450,0,560)
main.Position = UDim2.new(0.5,-225,0.5,-280)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

------------------------------------------------
-- RGB BORDER
------------------------------------------------
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
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB 10.0 FULL"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.Parent = main

local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,20)
greet.Position = UDim2.new(0,0,0,30)
greet.BackgroundTransparency = 1
greet.Text = "привет " .. player.Name .. "!"
greet.TextColor3 = Color3.fromRGB(180,180,180)
greet.Parent = main

------------------------------------------------
-- TOGGLE (SMOOTH)
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,130,0,30)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "OPEN / CLOSE"
toggle.Parent = gui
Instance.new("UICorner", toggle)

local opened = false

local function openUI()
	main.Visible = true
	TweenService:Create(main, TweenInfo.new(0.25), {
		Size = UDim2.new(0,450,0,560),
		BackgroundTransparency = 0
	}):Play()
	opened = true
end

local function closeUI()
	local t = TweenService:Create(main, TweenInfo.new(0.25), {
		Size = UDim2.new(0,0,0,0),
		BackgroundTransparency = 1
	})
	t:Play()
	t.Completed:Connect(function()
		main.Visible = false
	end)
	opened = false
end

toggle.MouseButton1Click:Connect(function()
	if opened then closeUI() else openUI() end
end)

------------------------------------------------
-- TABS
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

local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

------------------------------------------------
-- BUTTON
------------------------------------------------
local function button(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,38)
	b.BackgroundColor3 = Color3.fromRGB(40,40,50)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.Parent = content
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(func)
end

------------------------------------------------
-- REAL FLY
------------------------------------------------
local flying = false
local gyro, vel

local function startFly()
	if flying then return end
	flying = true

	gyro = Instance.new("BodyGyro", root)
	gyro.P = 9e4
	gyro.MaxTorque = Vector3.new(9e9,9e9,9e9)

	vel = Instance.new("BodyVelocity", root)
	vel.MaxForce = Vector3.new(9e9,9e9,9e9)

	RunService.RenderStepped:Connect(function()
		if not flying then return end
		local cam = workspace.CurrentCamera
		gyro.CFrame = cam.CFrame

		local move = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

		vel.Velocity = move.Unit * 60
	end)
end

local function stopFly()
	flying = false
	if gyro then gyro:Destroy() end
	if vel then vel:Destroy() end
end

------------------------------------------------
-- AIM TRAINING SYSTEM
------------------------------------------------
local targets = {}
local hits = 0

local function spawnTarget()
	local p = Instance.new("Part")
	p.Shape = Enum.PartType.Ball
	p.Size = Vector3.new(2,2,2)
	p.Anchored = true
	p.Material = Enum.Material.Neon
	p.Color = Color3.fromRGB(255,0,0)
	p.Position = Vector3.new(math.random(-25,25),5,math.random(-25,25))
	p.Parent = workspace

	p.Touched:Connect(function(hit)
		if hit.Parent == player.Character then
			hits += 1
			p:Destroy()
		end
	end)

	table.insert(targets,p)
end

local function startTraining()
	for i=1,15 do
		spawnTarget()
	end
end

local aimAssist = false

RunService.RenderStepped:Connect(function()
	if not aimAssist then return end

	local closest
	local dist = 999

	for _,t in pairs(targets) do
		if t and t.Parent then
			local d = (t.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
			if d < dist then
				dist = d
				closest = t
			end
		end
	end

	if closest then
		workspace.CurrentCamera.CFrame =
			workspace.CurrentCamera.CFrame:Lerp(
			CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Position),
			0.06
		)
	end
end)

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
-- TABS
------------------------------------------------
local tabs = {"Movement","Aim","Training","Visual","World"}

for i,v in ipairs(tabs) do
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,85,1,0)
	t.Position = UDim2.new(0,(i-1)*90,0,0)
	t.Text = v
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		clear()

		if v == "Movement" then
			button("Fly Toggle", function()
				if flying then stopFly() else startFly() end
			end)
			button("Speed 60", function() hum.WalkSpeed = 60 end)

		elseif v == "Aim" then
			button("Aim Assist", function()
				aimAssist = not aimAssist
			end)

		elseif v == "Training" then
			button("Spawn Targets", startTraining)
			button("Reset Hits", function() hits = 0 end)

		elseif v == "Visual" then
			button("FullBright", function()
				Lighting.Brightness = 3
			end)

		elseif v == "World" then
			button("Gravity Low", function()
				workspace.Gravity = 60
			end)
		end
	end)
end
