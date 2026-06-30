local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

------------------------------------------------
-- DATA
------------------------------------------------
local fly = false
local noclip = false
local esp = false
local speed = 16
local jumpBoost = false

------------------------------------------------
-- GUI (SMALLER + CLEAN)
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 340)
main.Position = UDim2.new(0.5, -130, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = main

------------------------------------------------
-- RAINBOW
------------------------------------------------
local hue = 0
RunService.RenderStepped:Connect(function()
	hue += 0.003
	if hue > 1 then hue = 0 end
	local c = Color3.fromHSV(hue,1,1)
	stroke.Color = c
end)

------------------------------------------------
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,28)
title.BackgroundTransparency = 1
title.Text = "ADMIN PANEL"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = main

RunService.RenderStepped:Connect(function()
	title.TextColor3 = Color3.fromHSV(hue,1,1)
end)

------------------------------------------------
-- WELCOME MESSAGE
------------------------------------------------
local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1,0,0,20)
welcome.Position = UDim2.new(0,0,0,28)
welcome.BackgroundTransparency = 1
welcome.TextScaled = true
welcome.Font = Enum.Font.Gotham
welcome.Text = "Добро пожаловать, "..player.Name.." в панель"
welcome.TextColor3 = Color3.fromRGB(200,200,200)
welcome.Parent = main

------------------------------------------------
-- TOGGLE BUTTON (OPEN / CLOSE)
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,50,0,50)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "≡"
toggle.TextScaled = true
toggle.Font = Enum.Font.GothamBlack
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

------------------------------------------------
-- TABS
------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,25)
tabBar.Position = UDim2.new(0,0,0,50)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local pages = {}

local function makeTab(name, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,80,0,22)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = tabBar

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,-75)
	page.Position = UDim2.new(0,0,0,75)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = main

	pages[name] = page

	b.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible = false end
		page.Visible = true
	end)

	return page
end

------------------------------------------------
-- PAGES
------------------------------------------------
local movement = makeTab("Move", 5)
local visual = makeTab("Visual", 90)
local playerTab = makeTab("Player", 175)

------------------------------------------------
-- BUTTON CREATOR
------------------------------------------------
local function btn(parent,text,y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,22)
	b.Position = UDim2.new(0,5,0,y)
	b.Text = text
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	b.BackgroundColor3 = Color3.fromRGB(25,25,25)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = parent

	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0,5)

	return b
end

------------------------------------------------
-- MOVEMENT (5 FUNCTIONS)
------------------------------------------------
btn(movement,"Fly Toggle",0).MouseButton1Click:Connect(function()
	fly = not fly
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)
	bv.Parent = hrp

	while fly do
		local move = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
		bv.Velocity = move * 60
		task.wait()
	end
	bv:Destroy()
end)

btn(movement,"Speed Boost",25).MouseButton1Click:Connect(function()
	speed += 30
	if speed > 500 then speed = 16 end
	hum.WalkSpeed = speed
end)

btn(movement,"Jump Boost",50).MouseButton1Click:Connect(function()
	hum.JumpPower = 120
end)

btn(movement,"Noclip",75).MouseButton1Click:Connect(function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

btn(movement,"Low Gravity",100).MouseButton1Click:Connect(function()
	workspace.Gravity = 50
end)

------------------------------------------------
-- VISUAL (5 FUNCTIONS)
------------------------------------------------
btn(visual,"ESP Toggle",0).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = Instance.new("Highlight")
			h.FillColor = Color3.fromRGB(0,255,0)
			h.Parent = p.Character
		end
	end
end)

btn(visual,"Invisible",25).MouseButton1Click:Connect(function()
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then v.Transparency = 1 end
	end
end)

btn(visual,"FOV +",50).MouseButton1Click:Connect(function()
	cam.FieldOfView += 10
end)

btn(visual,"Rainbow Body",75).MouseButton1Click:Connect(function()
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Color = Color3.fromHSV(hue,1,1)
		end
	end
end)

btn(visual,"Full Bright",100).MouseButton1Click:Connect(function()
	game.Lighting.Brightness = 3
end)

------------------------------------------------
-- PLAYER (5 FUNCTIONS)
------------------------------------------------
btn(playerTab,"Heal",0).MouseButton1Click:Connect(function()
	hum.Health = hum.MaxHealth
end)

btn(playerTab,"Reset",25).MouseButton1Click:Connect(function()
	char:BreakJoints()
end)

btn(playerTab,"Teleport",50).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			hrp.CFrame = p.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)

btn(playerTab,"God Mode",75).MouseButton1Click:Connect(function()
	hum.MaxHealth = math.huge
	hum.Health = math.huge
end)

btn(playerTab,"Sit",100).MouseButton1Click:Connect(function()
	hum.Sit = true
end)
