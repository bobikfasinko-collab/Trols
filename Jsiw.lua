local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ProMobileMenu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local isMobile = UserInputService.TouchEnabled

-- SOUND
local click = Instance.new("Sound")
click.SoundId = "rbxassetid://9118823101"
click.Volume = 1
click.Parent = gui

local function play()
	click:Play()
end

-- =======================
-- MENU FRAME
-- =======================
local main = Instance.new("Frame")
main.Size = UDim2.new(0, isMobile and 340 or 600, 0, isMobile and 460 or 380)
main.Position = UDim2.new(0.5, 0, 1.2, 0)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

-- OPEN BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 140, 0, 45)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "MENU"
toggle.Parent = gui
Instance.new("UICorner", toggle)

-- ANIMATIONS
local openTween = TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5, 0, 0.5, 0)})

local closeTween = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
	{Position = UDim2.new(0.5, 0, 1.2, 0)})

local opened = false

toggle.MouseButton1Click:Connect(function()
	play()

	if opened then
		closeTween:Play()
		task.wait(0.3)
		main.Visible = false
	else
		main.Visible = true
		openTween:Play()
	end

	opened = not opened
end)

-- =======================
-- KEY SYSTEM
-- =======================
local function keySystem()
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0,260,0,160)
	f.Position = UDim2.new(0.5,0,0.5,0)
	f.AnchorPoint = Vector2.new(0.5,0.5)
	f.BackgroundColor3 = Color3.fromRGB(30,30,30)
	f.Parent = gui
	Instance.new("UICorner", f)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0,200,0,40)
	box.Position = UDim2.new(0.5,0,0.35,0)
	box.AnchorPoint = Vector2.new(0.5,0.5)
	box.PlaceholderText = "Enter Key"
	box.Parent = f

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,200,0,40)
	btn.Position = UDim2.new(0.5,0,0.7,0)
	btn.AnchorPoint = Vector2.new(0.5,0.5)
	btn.Text = "Confirm"
	btn.Parent = f
	Instance.new("UICorner", btn)

	local msg = Instance.new("TextLabel")
	msg.Size = UDim2.new(1,0,0,30)
	msg.Position = UDim2.new(0,0,1,0)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1,1,1)
	msg.Parent = f

	btn.MouseButton1Click:Connect(function()
		play()

		if box.Text == "Gero" then
			msg.Text = "добро пожаловать " .. player.Name
			task.wait(1)
			f:Destroy()
		else
			msg.Text = player.Name .. " неправильный ключ"
		end
	end)
end

keySystem()

-- =======================
-- MAIN UI STRUCTURE
-- =======================
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(0, isMobile and 110 or 140, 1, 0)
tabsFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
tabsFrame.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-120,1,0)
content.Position = UDim2.new(0,120,0,0)
content.BackgroundTransparency = 1
content.Parent = main

-- =======================
-- PLAYER FEATURES (REAL)
-- =======================

-- SPEED
local speedOn = false
local function toggleSpeed()
	speedOn = not speedOn
	hum.WalkSpeed = speedOn and 40 or 16
end

-- FLY
local flying = false
local flyConn
local bv

local function toggleFly()
	flying = not flying

	if flying then
		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(999999,999999,999999)
		bv.Velocity = Vector3.zero
		bv.Parent = root

		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local move = Vector3.zero

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then
				move += cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				move -= cam.CFrame.LookVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				move -= cam.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				move += cam.CFrame.RightVector
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				move += Vector3.new(0,1,0)
			end

			bv.Velocity = move * 60
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if bv then bv:Destroy() end
	end
end

-- ESP
local espEnabled = false
local espObjects = {}

local function addESP(plr)
	if plr == player then return end

	local function create()
		local hl = Instance.new("Highlight")
		hl.FillColor = Color3.fromRGB(255,0,0)
		hl.OutlineColor = Color3.fromRGB(255,255,255)
		hl.Parent = plr.Character
		espObjects[plr] = hl
	end

	if plr.Character then
		create()
	end

	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then
			create()
		end
	end)
end

local function toggleESP()
	espEnabled = not espEnabled

	if espEnabled then
		for _,p in pairs(Players:GetPlayers()) do
			addESP(p)
		end
	else
		for _,v in pairs(espObjects) do
			if v then v:Destroy() end
		end
		espObjects = {}
	end
end

Players.PlayerAdded:Connect(function(p)
	if espEnabled then
		addESP(p)
	end
end)

-- =======================
-- UI BUTTON SYSTEM
-- =======================
local function button(parent,text,y,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,isMobile and 230 or 260,0,38)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = parent
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		play()
		func()
	end)
end

local function tab(name)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1,0,1,0)
	f.BackgroundTransparency = 1
	f.Visible = false
	f.Parent = content

	-- REAL FEATURES
	button(f,"Speed Toggle",0,function() toggleSpeed() end)
	button(f,"Fly Toggle",45,function() toggleFly() end)
	button(f,"ESP Toggle",90,function() toggleESP() end)

	-- 12 EXTRA FUNCTIONS (fun placeholders)
	for i=1,12 do
		button(f,name.." Func "..i,90+i*40,function()
			print(name.." "..i)
		end)
	end

	return f
end

local tabs = {
	tab("Movement"),
	tab("Combat"),
	tab("Visual"),
	tab("Utility"),
	tab("Fun")
}

tabs[1].Visible = true

-- TAB BUTTONS
for i=1,5 do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,45)
	b.Position = UDim2.new(0,5,0,(i-1)*50)
	b.Text = "Tab "..i
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = tabsFrame
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		play()
		for _,t in pairs(tabs) do
			t.Visible = false
		end
		tabs[i].Visible = true
	end)
end
