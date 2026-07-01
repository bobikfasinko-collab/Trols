local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- ================= LOADING SCREEN =================
local loading = Instance.new("Frame")
loading.Size = UDim2.new(1,0,1,0)
loading.BackgroundColor3 = Color3.fromRGB(0,0,0)
loading.Parent = gui

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1,0,0,100)
text.Position = UDim2.new(0,0,0.4,0)
text.BackgroundTransparency = 1
text.TextScaled = true
text.TextColor3 = Color3.fromRGB(255,255,255)
text.Text = "функции загружаются!\nА пока ждёте подпишитесь на наш ТГ\nGregooRBXscript"
text.Parent = loading

-- ================= PANEL =================
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0,340,0,0)
panel.Position = UDim2.new(0.5,-170,0.5,-200)
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

-- ================= OPEN / CLOSE =================
local opened = false

openBtn.MouseButton1Click:Connect(function()
	opened = not opened

	if opened then
		panel.Visible = true
		TweenService:Create(panel, TweenInfo.new(0.3), {
			Size = UDim2.new(0,340,0,420)
		}):Play()
	else
		local t = TweenService:Create(panel, TweenInfo.new(0.3), {
			Size = UDim2.new(0,340,0,0)
		})
		t:Play()
		t.Completed:Wait()
		panel.Visible = false
	end
end)

-- ================= WAIT 6 SECONDS =================
task.wait(6)

TweenService:Create(loading, TweenInfo.new(0.5), {
	BackgroundTransparency = 1
}):Play()

text:Destroy()
task.wait(0.5)
loading:Destroy()

-- ================= SCROLL MENU =================
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-90)
scroll.Position = UDim2.new(0,0,0,90)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.Parent = panel

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,5)

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

-- ================= HELPERS =================
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

local function add(text,func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,50)
	b.Text = text
	b.TextScaled = true
	b.Parent = scroll
	b.MouseButton1Click:Connect(func)
end

-- ================= VISUAL =================
visual.MouseButton1Click:Connect(function()
	clear()

	add("👁 ESP", function()
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character then
				local h = Instance.new("Highlight")
				h.Parent = v.Character
			end
		end
	end)

	add("🌈 Rainbow", function()
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
combat.MouseButton1Click:Connect(function()
	clear()

	add("💥 Fling", function()
		local r = char().HumanoidRootPart
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= player and v.Character then
				v.Character.HumanoidRootPart.Velocity = Vector3.new(0,120,0)
			end
		end
	end)

	add("❤️ Heal", function()
		char().Humanoid.Health = 100
	end)
end)

-- ================= MOVE =================
move.MouseButton1Click:Connect(function()
	clear()

	add("⚡ Speed", function()
		char().Humanoid.WalkSpeed = 60
	end)

	add("🦘 Jump", function()
		char().Humanoid.JumpPower = 120
	end)

	add("👻 NoClip", function()
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
