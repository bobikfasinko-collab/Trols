local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- ================= OPEN BUTTON =================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,140,0,50)
openBtn.Position = UDim2.new(0,10,0.5,-25)
openBtn.Text = "🍉 MENU"
openBtn.Parent = gui

-- ================= PANEL =================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,360,0,0)
panel.Position = UDim2.new(0.5,-180,0.5,-200)
panel.BackgroundColor3 = Color3.fromRGB(25,25,25)
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

-- smooth open/close
local opened = false

openBtn.MouseButton1Click:Connect(function()
	opened = not opened

	if opened then
		panel.Visible = true
		TweenService:Create(panel, TweenInfo.new(0.3), {
			Size = UDim2.new(0,360,0,420)
		}):Play()
	else
		local t = TweenService:Create(panel, TweenInfo.new(0.3), {
			Size = UDim2.new(0,360,0,0)
		})
		t:Play()
		t.Completed:Wait()
		panel.Visible = false
	end
end)

-- ================= VIP SYSTEM =================
local vipClicks = 0
local vipUnlocked = false

local vipBtn = Instance.new("TextButton")
vipBtn.Size = UDim2.new(1,0,0,50)
vipBtn.Text = "VIP PANEL 🥊💳 (click 5x)"
vipBtn.BackgroundColor3 = Color3.fromRGB(255,200,0)
vipBtn.Parent = panel

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,0,0,25)
info.Position = UDim2.new(0,0,0,50)
info.TextColor3 = Color3.fromRGB(255,255,255)
info.Text = ""
info.Parent = panel

vipBtn.MouseButton1Click:Connect(function()
	if vipUnlocked then return end

	vipClicks += 1
	info.Text = "разблокируйте! "..vipClicks.."/5"

	if vipClicks >= 5 then
		vipUnlocked = true
		info.Text = "VIP UNLOCKED!"
	end
end)

-- ================= TABS =================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,75)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = panel

local function makeTab(name, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,110,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = name
	b.Parent = tabFrame
	return b
end

local visualTab = makeTab("VISUAL", 0)
local combatTab = makeTab("COMBAT", 120)
local moveTab = makeTab("MOVE", 240)

-- ================= SCROLL AREA =================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-120)
scroll.Position = UDim2.new(0,0,0,120)
scroll.CanvasSize = UDim2.new(0,0,0,1200)
scroll.ScrollBarThickness = 6
scroll.Parent = panel

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)

-- ================= PLAYER =================
local function char()
	return player.Character or player.CharacterAdded:Wait()
end

-- ================= FEATURES =================

local function add(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,50)
	b.Text = text
	b.Parent = scroll
	b.MouseButton1Click:Connect(func)
end

-- ================= VISUAL =================
visualTab.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end
	scroll:ClearAllChildren()
	layout.Parent = scroll

	add("👁 ESP (Highlight)", function()
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character then
				local h = Instance.new("Highlight")
				h.Parent = v.Character
			end
		end
	end)

	add("🌈 Rainbow Character", function()
		task.spawn(function()
			while true do
				for _,p in pairs(char():GetChildren()) do
					if p:IsA("BasePart") then
						p.Color = Color3.fromHSV(tick()%1,1,1)
					end
				end
				task.wait(0.2)
			end
		end)
	end)
end)

-- ================= COMBAT =================
combatTab.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end
	scroll:ClearAllChildren()
	layout.Parent = scroll

	add("💥 Fling Nearby", function()
		local r = char().HumanoidRootPart
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				local d = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
				if d < 12 then
					v.Character.HumanoidRootPart.Velocity = Vector3.new(0,120,0)
				end
			end
		end
	end)

	add("🔥 Mega Fling", function()
		local r = char().HumanoidRootPart
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character then
				v.Character.HumanoidRootPart.Velocity = Vector3.new(0,200,0)
			end
		end
	end)

	add("❤️ Heal", function()
		char().Humanoid.Health = 100
	end)
end)

-- ================= MOVE =================
moveTab.MouseButton1Click:Connect(function()
	if not vipUnlocked then return end
	scroll:ClearAllChildren()
	layout.Parent = scroll

	add("⚡ Speed", function()
		char().Humanoid.WalkSpeed = 60
	end)

	add("🦘 Jump Boost", function()
		char().Humanoid.JumpPower = 120
	end)

	add("🧊 Freeze Player", function()
		char().HumanoidRootPart.Anchored = true
		task.wait(2)
		char().HumanoidRootPart.Anchored = false
	end)

	add("👻 NoClip (ghost)", function()
		task.spawn(function()
			while true do
				for _,v in pairs(char():GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
				task.wait(0.1)
			end
		end)
	end)
end)
