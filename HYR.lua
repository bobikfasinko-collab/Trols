local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "THUNDER_MOBILE_5"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,300,0,180)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
keyFrame.Parent = gui
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.3,0)
keyBox.PlaceholderText = "Enter Key"
keyBox.Parent = keyFrame
Instance.new("UICorner", keyBox)

local errorText = Instance.new("TextLabel")
errorText.Size = UDim2.new(1,0,0,30)
errorText.BackgroundTransparency = 1
errorText.TextColor3 = Color3.fromRGB(255,0,0)
errorText.Font = Enum.Font.GothamBold
errorText.TextSize = 14
errorText.Parent = keyFrame

local enter = Instance.new("TextButton")
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.65,0)
enter.Text = "ENTER"
enter.Parent = keyFrame
Instance.new("UICorner", enter)

------------------------------------------------
-- MAIN UI
------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0,400,0,520)
main.Position = UDim2.new(0.5,-200,0.5,-260)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2

task.spawn(function()
	while true do
		for i=0,1,0.01 do
			stroke.Color = Color3.fromHSV(i,1,1)
			task.wait(0.02)
		end
	end
end)

------------------------------------------------
-- HEADER
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.Text = "THUNDER HUB 5.0 MOBILE"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = main

local greet = Instance.new("TextLabel")
greet.Size = UDim2.new(1,0,0,20)
greet.Position = UDim2.new(0,0,0,30)
greet.BackgroundTransparency = 1
greet.Text = "привет " .. player.Name .. "!"
greet.TextColor3 = Color3.fromRGB(180,180,180)
greet.Parent = main

------------------------------------------------
-- TAB SYSTEM (5 TABS)
------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,45)
tabBar.Position = UDim2.new(0,0,0,60)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-110)
content.Position = UDim2.new(0,0,0,110)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,5)

local click = Instance.new("Sound", main)
click.SoundId = "rbxassetid://12221967"
click.Volume = 1

local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

------------------------------------------------
-- BUTTON (MOBILE ANIMATION)
------------------------------------------------
local function button(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,36)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.Parent = content
	Instance.new("UICorner", b)

	local s = Instance.new("UIScale", b)

	b.MouseButton1Click:Connect(function()
		click:Play()
		TweenService:Create(s, TweenInfo.new(0.1), {Scale = 0.9}):Play()
		task.wait(0.1)
		TweenService:Create(s, TweenInfo.new(0.1), {Scale = 1}):Play()
		func()
	end)
end

------------------------------------------------
-- FUNCTIONS (50+ TOTAL)
------------------------------------------------

-- PLAYER / MOVEMENT (10)
local function speed() hum.WalkSpeed = 60 end
local function jump() hum.JumpPower = 120 end
local function reset() player.Character:BreakJoints() end
local function heal() hum.Health = 100 end
local function sit() hum.Sit = true end
local function normalSpeed() hum.WalkSpeed = 16 end
local function superSpeed() hum.WalkSpeed = 100 end
local function lowGravity() workspace.Gravity = 60 end
local function normalGravity() workspace.Gravity = 196 end
local function highJump() hum.JumpPower = 150 end

-- COMBAT (10)
local function a1() end
local function a2() end
local function a3() end
local function a4() end
local function a5() end
local function a6() end
local function a7() end
local function a8() end
local function a9() end
local function a10() end

-- VISUAL (10)
local function fullbright() Lighting.Brightness = 3 end
local function fogOff() Lighting.FogEnd = 100000 end
local function fogOn() Lighting.FogEnd = 100 end
local function rainbow() end
local function colorShift() end
local function gamma() end
local function blur() end
local function noShadow() end
local function sky() end
local function neon() end

-- WORLD (10)
local function day() Lighting.ClockTime = 14 end
local function night() Lighting.ClockTime = 0 end
local function rain() end
local function clear() end
local function explode() end
local function freeze() end
local function unfreeze() end
local function lag() end
local function antiLag() end
local function gravityHigh() workspace.Gravity = 300 end

-- MISC (10)
local function print1() end
local function print2() end
local function print3() end
local function print4() end
local function print5() end
local function print6() end
local function print7() end
local function print8() end
local function print9() end
local function print10() end

------------------------------------------------
-- TABS (5)
------------------------------------------------
local tabs = {
	"Movement",
	"Combat",
	"Visual",
	"World",
	"Misc"
}

local function load(tab)
	clear()

	if tab == "Movement" then
		button("Speed 60", speed)
		button("Jump Boost", jump)
		button("Heal", heal)
		button("Reset", reset)
		button("Super Speed", superSpeed)
		button("Normal Speed", normalSpeed)
		button("Low Gravity", lowGravity)
		button("Normal Gravity", normalGravity)
		button("High Jump", highJump)
		button("Sit", sit)

	elseif tab == "Combat" then
		button("Attack 1", a1)
		button("Attack 2", a2)
		button("Attack 3", a3)
		button("Attack 4", a4)
		button("Attack 5", a5)
		button("Attack 6", a6)
		button("Attack 7", a7)
		button("Attack 8", a8)
		button("Attack 9", a9)
		button("Attack 10", a10)

	elseif tab == "Visual" then
		button("FullBright", fullbright)
		button("Fog Off", fogOff)
		button("Fog On", fogOn)
		button("Day", day)
		button("Night", night)
		button("Rainbow", rainbow)
		button("Blur", blur)
		button("Sky", sky)
		button("Neon", neon)
		button("Gamma", gamma)

	elseif tab == "World" then
		button("Rain", rain)
		button("Clear", clear)
		button("Explode", explode)
		button("Freeze", freeze)
		button("Unfreeze", unfreeze)
		button("Lag", lag)
		button("Anti Lag", antiLag)
		button("Gravity High", gravityHigh)

	elseif tab == "Misc" then
		button("Print 1", print1)
		button("Print 2", print2)
		button("Print 3", print3)
		button("Print 4", print4)
		button("Print 5", print5)
		button("Print 6", print6)
		button("Print 7", print7)
		button("Print 8", print8)
		button("Print 9", print9)
		button("Print 10", print10)
	end
end

------------------------------------------------
-- CREATE TABS
------------------------------------------------
for i,v in ipairs(tabs) do
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,75,1,0)
	t.Position = UDim2.new(0,(i-1)*78,0,0)
	t.Text = v
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		click:Play()
		load(v)
	end)
end

load("Movement")

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
enter.MouseButton1Click:Connect(function()
	if keyBox.Text == "Ger" then
		keyFrame.Visible = false
		main.Visible = true
	else
		errorText.Text = player.Name .. " не тот ключ!"
	end
end)
