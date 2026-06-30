local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 420)
main.Position = UDim2.new(0.5, -140, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

------------------------------------------------
-- RAINBOW BORDER
------------------------------------------------
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = main

local hue = 0
RunService.RenderStepped:Connect(function()
	hue += 0.004
	if hue > 1 then hue = 0 end

	local c = Color3.fromHSV(hue,1,1)
	stroke.Color = c
end)

------------------------------------------------
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "создатель Gergoo"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = main

RunService.RenderStepped:Connect(function()
	title.TextColor3 = Color3.fromHSV(hue,1,1)
end)

------------------------------------------------
-- TOGGLE BUTTON
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,55,0,55)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "≡"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBlack
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

------------------------------------------------
-- BUTTON CREATOR (SMALL + ANIMATED)
------------------------------------------------
local function createBtn(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-15,0,28)
	b.Position = UDim2.new(0,8,0,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = main

	local corner = Instance.new("UICorner", b)
	corner.CornerRadius = UDim.new(0,6)

	-- click animation
	b.MouseButton1Click:Connect(function()
		b:TweenSize(UDim2.new(1,-10,0,24), "Out", "Quad", 0.1, true)
		task.wait(0.1)
		b:TweenSize(UDim2.new(1,-15,0,28), "Out", "Quad", 0.1, true)
	end)

	return b
end

------------------------------------------------
-- FEATURES
------------------------------------------------
local esp, noclip, fly = false,false,false
local speed = 16
local jump = false
local invisible = false

------------------------------------------------
-- ESP
------------------------------------------------
local function ESP()
	esp = not esp

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if esp then
				local h = Instance.new("Highlight")
				h.FillColor = Color3.fromRGB(0,255,0)
				h.Parent = p.Character
			else
				for _,v in pairs(p.Character:GetChildren()) do
					if v:IsA("Highlight") then v:Destroy() end
				end
			end
		end
	end
end

------------------------------------------------
-- ADMIN FLY (UP/DOWN CONTROL)
------------------------------------------------
local function Fly()
	fly = not fly

	while fly do
		local move = Vector3.new()

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end

		-- 🔼🔽 UP / DOWN
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		hrp.AssemblyLinearVelocity = move * 70
		task.wait()
	end
end

------------------------------------------------
-- BUTTONS (SMALL UI)
------------------------------------------------
local y = 45

local espBtn = createBtn("ESP", y) y += 32
local speedBtn = createBtn("Speed +", y) y += 32
local jumpBtn = createBtn("Infinite Jump", y) y += 32
local flyBtn = createBtn("Fly (UP/DOWN)", y) y += 32
local noclipBtn = createBtn("Noclip", y) y += 32
local invisBtn = createBtn("Invisible", y) y += 32
local tpBtn = createBtn("Teleport Player", y) y += 32
local fovBtn = createBtn("FOV +", y) y += 32
local resetBtn = createBtn("Reset", y) y += 32
local healBtn = createBtn("Heal", y) y += 32
local freezeBtn = createBtn("Freeze Players", y) y += 32
local godBtn = createBtn("God Mode", y) y += 32
local superJumpBtn = createBtn("Super Jump", y) y += 32
local rainbowBtn = createBtn("Rainbow Body", y) y += 32
local sitBtn = createBtn("Sit", y)

------------------------------------------------
-- ACTIONS (10+ NEW FEATURES)
------------------------------------------------

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	speed += 25
	if speed > 500 then speed = 16 end
	hum.WalkSpeed = speed
end)

-- JUMP
jumpBtn.MouseButton1Click:Connect(function()
	jump = not jump
end)

UIS.JumpRequest:Connect(function()
	if jump then hum:ChangeState("Jumping") end
end)

-- FLY
flyBtn.MouseButton1Click:Connect(Fly)

-- NOCLIP
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- INVISIBLE
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = invisible and 1 or 0
		end
	end
end)

-- TELEPORT
tpBtn.MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			hrp.CFrame = p.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)

-- FOV
local fov = 70
fovBtn.MouseButton1Click:Connect(function()
	fov += 10
	if fov > 120 then fov = 70 end
	cam.FieldOfView = fov
end)

RunService.RenderStepped:Connect(function()
	cam.FieldOfView = fov
end)

-- RESET
resetBtn.MouseButton1Click:Connect(function()
	char:BreakJoints()
end)

-- HEAL
healBtn.MouseButton1Click:Connect(function()
	hum.Health = hum.MaxHealth
end)

-- FREEZE ALL PLAYERS (LOCAL VISUAL)
freezeBtn.MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character and p ~= player then
			p.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 0
		end
	end
end)

-- GOD MODE (LOCAL)
godBtn.MouseButton1Click:Connect(function()
	hum.MaxHealth = math.huge
	hum.Health = math.huge
end)

-- SUPER JUMP
superJumpBtn.MouseButton1Click:Connect(function()
	hum.JumpPower = 150
end)

-- RAINBOW BODY
rainbowBtn.MouseButton1Click:Connect(function()
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Color = Color3.fromHSV(hue,1,1)
		end
	end
end)

-- SIT
sitBtn.MouseButton1Click:Connect(function()
	hum.Sit = true
end)
