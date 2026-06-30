local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_HUB_KEY"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- KEY FRAME
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,300,0,180)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
keyFrame.Parent = gui
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.3,0)
keyBox.PlaceholderText = "Enter key..."
keyBox.Text = ""
keyBox.Parent = keyFrame

Instance.new("UICorner", keyBox)

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0.8,0,0,40)
keyBtn.Position = UDim2.new(0.1,0,0.65,0)
keyBtn.Text = "ENTER"
keyBtn.Parent = keyFrame
Instance.new("UICorner", keyBtn)

local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1,0,0,30)
errorText.Position = UDim2.new(0,0,0,0)
errorText.BackgroundTransparency = 1
errorText.TextColor3 = Color3.fromRGB(255,0,0)
errorText.Font = Enum.Font.GothamBold
errorText.TextSize = 14
errorText.Text = ""
errorText.Parent = keyFrame

-- MAIN UI (hidden until key)
local main = Instance.new("Frame")
main.Size = UDim2.new(0,380,0,500)
main.Position = UDim2.new(0.5,-190,0.5,-250)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

-- RGB border
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

task.spawn(function()
	while true do
		for i=0,1,0.02 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait(0.02)
		end
	end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

-- GREETING
local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,20)
greet.Position = UDim2.new(0,0,0,30)
greet.BackgroundTransparency = 1
greet.Text = "привет " .. player.Name .. "!"
greet.TextColor3 = Color3.fromRGB(180,180,180)
greet.Parent = main

-- TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,40)
tabBar.Position = UDim2.new(0,0,0,60)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-110)
content.Position = UDim2.new(0,0,0,110)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,6)

-- CLICK SOUND
local click = Instance.new("Sound", main)
click.SoundId = "rbxassetid://12221967"
click.Volume = 1

-- STATES
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

local function button(text, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,38)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.Parent = content
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		click:Play()

		-- animation fix
		b:TweenSize(UDim2.new(0.85,0,0,34), "Out", "Quad", 0.1, true)
		task.wait(0.1)
		b:TweenSize(UDim2.new(0.9,0,0,38), "Out", "Quad", 0.1, true)

		callback()
	end)
end

-- TABS
local function loadTab(tab)
	clear()

	if tab == "Visual" then
		button("Full Bright", function()
			game.Lighting.Brightness = 3
		end)

	elseif tab == "Combat" then
		button("Speed", function()
			player.Character.Humanoid.WalkSpeed = 60
		end)

	elseif tab == "Player" then
		button("Reset", function()
			player.Character:BreakJoints()
		end)
	end
end

-- TAB BUTTONS
local function tab(name, x)
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,100,1,0)
	t.Position = UDim2.new(0,x,0,0)
	t.Text = name
	t.BackgroundColor3 = Color3.fromRGB(30,30,30)
	t.TextColor3 = Color3.new(1,1,1)
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		click:Play()
		loadTab(name)
	end)
end

tab("Visual", 0)
tab("Combat", 110)
tab("Player", 220)

-- KEY SYSTEM
keyBtn.MouseButton1Click:Connect(function()
	local key = keyBox.Text

	if key == "Ger" then
		keyFrame.Visible = false
		main.Visible = true
	else
		errorText.Text = player.Name .. " не тот ключ!"
	end
end)

loadTab("Visual")
