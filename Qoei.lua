local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- ================= UI =================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,140,0,50)
openBtn.Position = UDim2.new(0,10,0.5,-25)
openBtn.Text = "🍉 MENU"
openBtn.Parent = gui

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,320,0,380)
panel.Position = UDim2.new(0.5,-160,0.5,-190)
panel.BackgroundColor3 = Color3.fromRGB(30,30,30)
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

-- ================= TOGGLE MENU =================
local opened = false

openBtn.MouseButton1Click:Connect(function()
	opened = not opened
	panel.Visible = opened
end)

-- ================= VIP SYSTEM =================
local vipClicks = 0
local vipUnlocked = false

local vipBtn = Instance.new("TextButton")
vipBtn.Size = UDim2.new(1,0,0,60)
vipBtn.Position = UDim2.new(0,0,0,0)
vipBtn.Text = "VIP panel 🥊💳"
vipBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
vipBtn.Parent = panel

local function createButton(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,50)
	b.Position = UDim2.new(0,0,0,y)
	b.Text = text
	b.Parent = panel
	return b
end

local msg = Instance.new("TextLabel")
msg.Size = UDim2.new(1,0,0,40)
msg.Position = UDim2.new(0,0,0,60)
msg.Text = ""
msg.TextColor3 = Color3.fromRGB(255,255,255)
msg.Parent = panel

-- ================= UNLOCK =================
vipBtn.MouseButton1Click:Connect(function()
	if vipUnlocked then return end

	vipClicks += 1
	msg.Text = "разблокируйте! ("..vipClicks.."/5)"

	if vipClicks >= 5 then
		vipUnlocked = true
		msg.Text = "VIP UNLOCKED!"
	end
end)

-- ================= CHARACTER =================
local function char()
	return player.Character or player.CharacterAdded:Wait()
end

-- ================= FLING =================
local flingBtn = createButton("💥 Fling!", 110)

flingBtn.MouseButton1Click:Connect(function()
	local c = char()
	local root = c:FindFirstChild("HumanoidRootPart")

	local target = nil
	for _,v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local d = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
			if d < 10 then
				target = v
				break
			end
		end
	end

	if target then
		target.Character.HumanoidRootPart.Velocity = Vector3.new(0,120,0)
	end
end)

-- ================= VIP FEATURES =================

local espOn = false
local speedOn = false
local jumpOn = false

local espBtn = createButton("👁 ESP", 170)
local speedBtn = createButton("⚡ Speed", 220)
local jumpBtn = createButton("🦘 Jump NF", 270)
local megaFlingBtn = createButton("💥 Mega Fling", 320)

-- ================= ESP =================
espBtn.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end

	espOn = not espOn

	for _,v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character then
			if espOn then
				local h = Instance.new("Highlight")
				h.Parent = v.Character
			else
				for _,obj in pairs(v.Character:GetChildren()) do
					if obj:IsA("Highlight") then
						obj:Destroy()
					end
				end
			end
		end
	end
end)

-- ================= SPEED =================
speedBtn.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end

	speedOn = not speedOn
	char().Humanoid.WalkSpeed = speedOn and 50 or 16
end)

-- ================= JUMP =================
jumpBtn.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end

	jumpOn = not jumpOn
	char().Humanoid.JumpPower = jumpOn and 120 or 50
end)

-- ================= MEGA FLING =================
megaFlingBtn.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end

	local inputPower = 150

	local c = char()
	local root = c:FindFirstChild("HumanoidRootPart")

	for _,v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			local d = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
			if d < 15 then
				v.Character.HumanoidRootPart.Velocity = Vector3.new(0,inputPower,0)
			end
		end
	end
end)
