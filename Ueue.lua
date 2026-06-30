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
local esp = false
local fly = false
local noclip = false
local speed = 16
local jumpPower = 50

------------------------------------------------
-- GUI BASE
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 500)
main.Position = UDim2.new(0.5, -210, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

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
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "ADMIN PANEL V2"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = main

RunService.RenderStepped:Connect(function()
	title.TextColor3 = Color3.fromHSV(hue,1,1)
end)

------------------------------------------------
-- TABS
------------------------------------------------
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = main

local pages = {}

local function createTab(name, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,100,0,30)
	b.Position = UDim2.new(0,x,0,5)
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = tabFrame

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,-80)
	page.Position = UDim2.new(0,0,0,80)
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
local movement = createTab("Movement", 10)
local visual = createTab("Visual", 120)
local playerTab = createTab("Player", 230)
local server = createTab("Server", 340)

------------------------------------------------
-- BUTTON CREATOR
------------------------------------------------
local function btn(parent,text,y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,30)
	b.Position = UDim2.new(0,10,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = parent

	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0,6)

	return b
end

------------------------------------------------
-- MOVEMENT TAB
------------------------------------------------
btn(movement,"Fly Toggle",10).MouseButton1Click:Connect(function()
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

		bv.Velocity = move * 70
		task.wait()
	end

	bv:Destroy()
end)

btn(movement,"Speed +",50).MouseButton1Click:Connect(function()
	speed += 20
	if speed > 500 then speed = 16 end
	hum.WalkSpeed = speed
end)

btn(movement,"Jump Boost",90).MouseButton1Click:Connect(function()
	hum.JumpPower = 120
end)

btn(movement,"Noclip",130).MouseButton1Click:Connect(function()
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
-- VISUAL TAB
------------------------------------------------
btn(visual,"ESP Toggle",10).MouseButton1Click:Connect(function()
	esp = not esp
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = Instance.new("Highlight")
			h.FillColor = Color3.fromRGB(0,255,0)
			h.Parent = p.Character
		end
	end
end)

btn(visual,"Invisible",50).MouseButton1Click:Connect(function()
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
		end
	end
end)

btn(visual,"FOV +",90).MouseButton1Click:Connect(function()
	cam.FieldOfView = cam.FieldOfView + 10
end)

------------------------------------------------
-- PLAYER TAB
------------------------------------------------
btn(playerTab,"Heal",10).MouseButton1Click:Connect(function()
	hum.Health = hum.MaxHealth
end)

btn(playerTab,"Reset",50).MouseButton1Click:Connect(function()
	char:BreakJoints()
end)

btn(playerTab,"Teleport To Player",90).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			hrp.CFrame = p.Character.HumanoidRootPart.CFrame
			break
		end
	end
end)

btn(playerTab,"Kill Player",130).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if h then h.Health = 0 end
		end
	end
end)

------------------------------------------------
-- SERVER TAB (LOCAL SIMULATION)
------------------------------------------------
btn(server,"Freeze All",10).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character and p ~= player then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if h then
				h.WalkSpeed = 0
				h.JumpPower = 0
			end
		end
	end
end)

btn(server,"Heal All",50).MouseButton1Click:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character then
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if h then h.Health = h.MaxHealth end
		end
	end
end)

btn(server,"Anti AFK",90).MouseButton1Click:Connect(function()
	local vu = game:GetService("VirtualUser")
	player.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end)
end)
