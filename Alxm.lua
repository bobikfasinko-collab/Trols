local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- ================= LOADING SCREEN =================
local load = Instance.new("Frame")
load.Size = UDim2.new(1,0,1,0)
load.BackgroundColor3 = Color3.new(0,0,0)
load.Parent = gui

local txt = Instance.new("TextLabel")
txt.Size = UDim2.new(1,0,1,0)
txt.TextScaled = true
txt.TextColor3 = Color3.new(1,1,1)
txt.Text = "ЗАГРУЗКА ФУНКЦИЙ...\nGregooRBXscript"
txt.Parent = load

task.wait(4)
load:Destroy()

-- ================= PANEL =================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,360,0,0)
panel.Position = UDim2.new(0.5,-180,0.5,-200)
panel.BackgroundColor3 = Color3.fromRGB(25,25,25)
panel.Visible = false
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)

-- RGB
task.spawn(function()
	while true do
		for i=0,1,0.01 do
			panel.BackgroundColor3 = Color3.fromHSV(i,1,1)
			task.wait(0.03)
		end
	end
end)

-- ================= OPEN BUTTON =================
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,140,0,55)
openBtn.Position = UDim2.new(0,10,0.5,-27)
openBtn.Text = "🍉 MENU"
openBtn.TextScaled = true
openBtn.Parent = gui

local opened = false

openBtn.MouseButton1Click:Connect(function()
	opened = not opened

	if opened then
		panel.Visible = true
		TweenService:Create(panel, TweenInfo.new(0.3), {
			Size = UDim2.new(0,360,0,450)
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

-- ================= TABS =================
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1,0,0,40)
tabFrame.Position = UDim2.new(0,0,0,40)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = panel

local function tab(name,x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,110,1,0)
	b.Position = UDim2.new(0,x,0,0)
	b.Text = name
	b.TextScaled = true
	b.Parent = tabFrame
	return b
end

local visual = tab("VISUAL",0)
local combat = tab("COMBAT",120)
local move = tab("MOVE",240)

-- ================= SCROLL =================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-90)
scroll.Position = UDim2.new(0,0,0,90)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.Parent = panel

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)

-- ================= UTILS =================
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
local function toggleButton(name, callback)
	local state = false

	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,50)
	b.Text = name.." [OFF]"
	b.TextScaled = true
	b.Parent = scroll

	b.MouseButton1Click:Connect(function()
		state = not state

		if state then
			b.Text = name.." [ON]"
			callback(true)
		else
			b.Text = name.." [OFF]"
			callback(false)
		end
	end)
end

-- ================= VISUAL =================
visual.MouseButton1Click:Connect(function()
	clear()

	toggleButton("👁 ESP", function(on)
		if on then
			for _,v in pairs(Players:GetPlayers()) do
				if v ~= player and v.Character then
					local h = Instance.new("Highlight")
					h.Name = "ESP"
					h.Parent = v.Character
				end
			end
		else
			for _,v in pairs(Players:GetPlayers()) do
				if v.Character and v.Character:FindFirstChild("ESP") then
					v.Character.ESP:Destroy()
				end
			end
		end
	end)

	toggleButton("🌈 Rainbow", function(on)
		if on then
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
		end
	end)
end)

-- ================= COMBAT =================
combat.MouseButton1Click:Connect(function()
	clear()

	toggleButton("💥 Fling All", function(on)
		if on then
			local r = char().HumanoidRootPart
			for _,v in pairs(Players:GetPlayers()) do
				if v ~= player and v.Character then
					v.Character.HumanoidRootPart.Velocity = Vector3.new(0,120,0)
				end
			end
		end
	end)

	toggleButton("❤️ Auto Heal", function(on)
		if on then
			task.spawn(function()
				while on do
					char().Humanoid.Health = 100
					task.wait(1)
				end
			end)
		end
	end)
end)

-- ================= MOVE =================
move.MouseButton1Click:Connect(function()
	clear()

	toggleButton("⚡ Speed", function(on)
		if on then
			char().Humanoid.WalkSpeed = 60
		else
			char().Humanoid.WalkSpeed = 16
		end
	end)

	toggleButton("🦘 Jump Boost", function(on)
		if on then
			char().Humanoid.JumpPower = 120
		else
			char().Humanoid.JumpPower = 50
		end
	end)

	toggleButton("👻 NoClip", function(on)
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
