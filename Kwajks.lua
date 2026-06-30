local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
local KEY = "Ger67"
local attempts = 3

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "AdminMenu"
gui.Parent = player:WaitForChild("PlayerGui")

-- KEY FRAME
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 250, 0, 150)
keyFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
keyFrame.Parent = gui

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 10)
keyBox.PlaceholderText = "Enter Key"
keyBox.Parent = keyFrame

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1, -20, 0, 40)
keyBtn.Position = UDim2.new(0, 10, 0, 60)
keyBtn.Text = "Unlock"
keyBtn.Parent = keyFrame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 110)
status.Text = "Attempts: 3"
status.Parent = keyFrame

------------------------------------------------
-- MAIN MENU
------------------------------------------------
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 320, 0, 420)
menu.Position = UDim2.new(0, 50, 0, 100)
menu.BackgroundColor3 = Color3.fromRGB(20,20,20)
menu.Visible = false
menu.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = menu

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ADMIN PANEL"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1
title.Parent = menu

------------------------------------------------
-- DRAG MENU
------------------------------------------------
local dragging, dragInput, dragStart, startPos

menu.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = menu.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

------------------------------------------------
-- FUNCTIONS
------------------------------------------------
local espEnabled = false
local flyEnabled = false
local noclip = false
local speed = 16

local function ESP()
	espEnabled = not espEnabled

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if espEnabled then
				local h = Instance.new("Highlight")
				h.FillColor = Color3.fromRGB(0,255,0)
				h.Parent = p.Character
			else
				for _, v in pairs(p.Character:GetChildren()) do
					if v:IsA("Highlight") then v:Destroy() end
				end
			end
		end
	end
end

local function setSpeed(val)
	hum.WalkSpeed = val
end

------------------------------------------------
-- KEY CHECK
------------------------------------------------
keyBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == KEY and attempts > 0 then
		keyFrame.Visible = false
		menu.Visible = true
	else
		attempts -= 1
		status.Text = "Attempts: "..attempts
		if attempts <= 0 then
			keyBtn.Text = "LOCKED"
			keyBtn.Active = false
		end
	end
end)

------------------------------------------------
-- BUTTONS
------------------------------------------------
local function makeButton(text, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 40)
	b.Position = UDim2.new(0, 10, 0, pos)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = menu
	return b
end

local espBtn = makeButton("ESP", 60)
local speedBtn = makeButton("Speed: 16", 110)
local jumpBtn = makeButton("Infinite Jump", 160)
local flyBtn = makeButton("Fly", 210)
local noclipBtn = makeButton("Noclip", 260)
local resetBtn = makeButton("Reset", 310)

------------------------------------------------
-- ACTIONS
------------------------------------------------
espBtn.MouseButton1Click:Connect(ESP)

speedBtn.MouseButton1Click:Connect(function()
	speed += 20
	if speed > 500 then speed = 16 end
	setSpeed(speed)
	speedBtn.Text = "Speed: "..speed
end)

local jumpEnabled = false
jumpBtn.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
end)

UIS.JumpRequest:Connect(function()
	if jumpEnabled then
		hum:ChangeState("Jumping")
	end
end)

-- Fly (simple)
flyBtn.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	local hrp = char:WaitForChild("HumanoidRootPart")

	while flyEnabled do
		hrp.Velocity = Vector3.new(0,50,0)
		task.wait()
	end
end)

-- Noclip
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip and char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

resetBtn.MouseButton1Click:Connect(function()
	char:BreakJoints()
end)
