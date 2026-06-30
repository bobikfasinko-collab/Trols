local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ThunderStyleUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0.5, -160, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

-- RAINBOW BORDER
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = frame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "THUNDER STYLE UI"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

-- GREETING
local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,25)
greet.Position = UDim2.new(0,0,0,40)
greet.BackgroundTransparency = 1
greet.Text = "привет " .. player.Name .. "!"
greet.TextColor3 = Color3.fromRGB(180,180,180)
greet.Font = Enum.Font.Gotham
greet.TextSize = 14
greet.Parent = frame

-- SCROLL AREA FOR BUTTONS
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-70)
scroll.Position = UDim2.new(0,0,0,70)
scroll.CanvasSize = UDim2.new(0,0,5,0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0,6)

-- CLICK SOUND
local click = Instance.new("Sound")
click.SoundId = "rbxassetid://12221967"
click.Volume = 1
click.Parent = frame

-- RGB LOOP
task.spawn(function()
	while true do
		for i = 0,1,0.01 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait(0.03)
		end
	end
end)

-- BUTTON FUNCTION
local function createButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = scroll

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		click:Play()

		-- click animation
		TweenService:Create(btn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(80,80,80)
		}):Play()

		task.wait(0.1)

		TweenService:Create(btn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(35,35,35)
		}):Play()

		callback()
	end)
end

-- TOGGLE PANEL
local open = true
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,120,0,30)
toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.Text = "OPEN / CLOSE"
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
	click:Play()
end)

-- EXAMPLE FEATURES (заготовки)
createButton("Speed (toggle)", function()
	print("speed toggled")
end)

createButton("Fly (toggle)", function()
	print("fly toggled")
end)

createButton("Infinite Jump", function()
	print("infinite jump toggled")
end)

createButton("Test Feature 4", function()
	print("feature")
end)

-- AUTO GENERATE +100 BUTTONS (заглушки)
for i = 5, 105 do
	createButton("Feature "..i, function()
		print("Feature "..i)
	end)
end

-- KEEP AFTER DEATH (already handled by ResetOnSpawn=false)
