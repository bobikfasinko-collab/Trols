local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- ================= BLACK PANEL =================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,360,0,0)
panel.Position = UDim2.new(0.5,-180,0.5,-200)
panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 1
stroke.Parent = panel

-- ================= OPEN BUTTON =================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,140,0,55)
openBtn.Position = UDim2.new(0,10,0.5,-27)
openBtn.Text = "☰ MENU"
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.TextColor3 = Color3.fromRGB(255,255,255)
openBtn.Parent = gui

Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,10)

-- ================= OPEN/CLOSE =================
local opened = false

openBtn.MouseButton1Click:Connect(function()
	opened = not opened

	if opened then
		panel.Visible = true
		TweenService:Create(panel, TweenInfo.new(0.25), {
			Size = UDim2.new(0,360,0,420)
		}):Play()
	else
		local t = TweenService:Create(panel, TweenInfo.new(0.25), {
			Size = UDim2.new(0,360,0,0)
		})
		t:Play()
		t.Completed:Wait()
		panel.Visible = false
	end
end)

-- ================= TOP BAR =================
local top = Instance.new("TextLabel")
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1
top.Text = "BLACK ADMIN PANEL"
top.TextColor3 = Color3.fromRGB(255,255,255)
top.TextScaled = true
top.Parent = panel

-- ================= TABS =================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = panel

local function makeTab(name,x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,110,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = name
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(25,25,25)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = tabFrame
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local visualTab = makeTab("VISUAL",0)
local combatTab = makeTab("COMBAT",120)
local moveTab   = makeTab("MOVE",240)

-- ================= SCROLL =================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-90)
scroll.Position = UDim2.new(0,0,0,90)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = panel

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- ================= UTIL =================
local function char()
	return player.Character or player.CharacterAdded:Wait()
end

local function clear()
	for _,v in pairs(scroll:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

-- ================= TOGGLE SYSTEM =================
local function toggle(name, func)
	local state = false

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,45)
	b.Text = name.." [OFF]"
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Parent = scroll
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = name.." ["..(state and "ON" or "OFF").."]"
		func(state)
	end)
end

-- ================= VISUAL (3 FUNCS) =================
visualTab.MouseButton1Click:Connect(function()
	clear()

	toggle("👁 ESP", function(on)
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character then
				if on then
					local h = Instance.new("Highlight")
					h.Name = "ESP"
					h.Parent = v.Character
				else
					if v.Character:FindFirstChild("ESP") then
						v.Character.ESP:Destroy()
					end
				end
			end
		end
	end)

	toggle("🌈 Rainbow Body", function(on)
		if on then
			task.spawn(function()
				while on do
					for _,p in pairs(char():GetChildren()) do
						if p:IsA("BasePart") then
							p.Color = Color3.fromHSV(tick()%1,1,1)
						end
					end
					task.wait(0.2)
				end
			end)
		end
	end)

	toggle("✨ Glow Effect", function(on)
		local h = char():FindFirstChildOfClass("Highlight")
		if on then
			if not h then
				h = Instance.new("Highlight")
				h.Parent = char()
			end
			h.FillTransparency = 0.3
		else
			if h then h:Destroy() end
		end
	end)
end)

-- ================= COMBAT (3 FUNCS) =================
combatTab.MouseButton1Click:Connect(function()
	clear()

	toggle("💥 Fling All", function(on)
		if on then
			local r = char().HumanoidRootPart
			for _,v in pairs(Players:GetPlayers()) do
				if v ~= player and v.Character then
					v.Character.HumanoidRootPart.Velocity = Vector3.new(0,120,0)
				end
			end
		end
	end)

	toggle("❤️ Auto Heal", function(on)
		if on then
			task.spawn(function()
				while on do
					char().Humanoid.Health = 100
					task.wait(1)
				end
			end)
		end
	end)

	toggle("🔥 Mega Knock", function(on)
		if on then
			for _,v in pairs(Players:GetPlayers()) do
				if v ~= player and v.Character then
					v.Character.HumanoidRootPart.Velocity = Vector3.new(0,200,0)
				end
			end
		end
	end)
end)

-- ================= MOVE (3 FUNCS) =================
moveTab.MouseButton1Click:Connect(function()
	clear()

	toggle("⚡ Speed Boost", function(on)
		char().Humanoid.WalkSpeed = on and 60 or 16
	end)

	toggle("🦘 Jump Boost", function(on)
		char().Humanoid.JumpPower = on and 120 or 50
	end)

	toggle("👻 NoClip", function(on)
		if on then
			task.spawn(function()
				while on do
					for _,v in pairs(char():GetDescendants()) do
						if v:IsA("BasePart") then
							v.CanCollide = false
						end
					end
					task.wait(0.1)
				end
			end)
		end
	end)
end)
