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
main.Size = UDim2.new(0, 340, 0, 480)
main.Position = UDim2.new(0.5, -170, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

------------------------------------------------
-- RAINBOW TITLE
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "создатель Gergoo"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = main

local hue = 0
RunService.RenderStepped:Connect(function()
	hue += 0.004
	if hue > 1 then hue = 0 end
	title.TextColor3 = Color3.fromHSV(hue,1,1)
end)

------------------------------------------------
-- TOGGLE MENU
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "≡"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBlack
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

------------------------------------------------
-- BUTTON CREATOR (MOBILE FRIENDLY)
------------------------------------------------
local function btn(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,40)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = main

	-- click effect
	b.MouseButton1Click:Connect(function()
		b.BackgroundColor3 = Color3.fromRGB(0,255,150)
		task.wait(0.1)
		b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	end)

	return b
end

------------------------------------------------
-- FEATURES
------------------------------------------------
local esp = false
local noclip = false
local fly = false
local invisible = false
local speed = 16
local fov = 70

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
-- ADMIN FLY (SMOOTH)
------------------------------------------------
local function Fly()
	fly = not fly

	while fly do
		local move = Vector3.new()

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

		hrp.AssemblyLinearVelocity = move * 60
		task.wait()
	end
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
local espBtn = btn("ESP", 60)
local speedBtn = btn("Speed +", 110)
local jumpBtn = btn("Infinite Jump", 160)
local flyBtn = btn("Admin Fly", 210)
local noclipBtn = btn("Noclip", 260)
local invisBtn = btn("Invisible", 310)
local tpBtn = btn("Teleport Player", 360)
local resetBtn = btn("Reset", 410)

------------------------------------------------
-- SPEED
------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
	speed += 25
	if speed > 500 then speed = 16 end
	hum.WalkSpeed = speed
end)

------------------------------------------------
-- INFINITE JUMP
------------------------------------------------
local jump = false
jumpBtn.MouseButton1Click:Connect(function()
	jump = not jump
end)

UIS.JumpRequest:Connect(function()
	if jump then
		hum:ChangeState("Jumping")
	end
end)

------------------------------------------------
-- FLY
------------------------------------------------
flyBtn.MouseButton1Click:Connect(Fly)

------------------------------------------------
-- NOCLIP
------------------------------------------------
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

------------------------------------------------
-- INVISIBLE
------------------------------------------------
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = invisible and 1 or 0
		end
	end
end)

------------------------------------------------
-- TELEPORT
------------------------------------------------
tpBtn.MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			hrp.CFrame = p.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)

------------------------------------------------
-- RESET
------------------------------------------------
resetBtn.MouseButton1Click:Connect(function()
	char:BreakJoints()
end)

------------------------------------------------
-- FOV LOOP
------------------------------------------------
RunService.RenderStepped:Connect(function()
	cam.FieldOfView = fov
end)
