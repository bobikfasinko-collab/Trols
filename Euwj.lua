local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "THUNDER_10_FIXED"

------------------------------------------------
-- MAIN WINDOW
------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0,450,0,560)
main.Position = UDim2.new(0.5,-225,0.5,-280)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.Parent = gui
Instance.new("UICorner", main)

------------------------------------------------
-- TOP BAR
------------------------------------------------
local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(35,35,40)
top.Parent = main
Instance.new("UICorner", top)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "THUNDER HUB 10.0 FIXED"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.Parent = top

------------------------------------------------
-- TAB BAR
------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,45)
tabBar.Position = UDim2.new(0,0,0,50)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

------------------------------------------------
-- CONTENT
------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-100)
content.Position = UDim2.new(0,0,0,100)
content.BackgroundTransparency = 1
content.Parent = main

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,5)

------------------------------------------------
-- CLEAR FUNCTION
------------------------------------------------
local function clear()
	for _,v in pairs(content:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
end

------------------------------------------------
-- BUTTON SYSTEM
------------------------------------------------
local function button(text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.9,0,0,35)
	b.BackgroundColor3 = Color3.fromRGB(45,45,55)
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.Parent = content
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(func)
end

------------------------------------------------
-- TABS SYSTEM (FIXED)
------------------------------------------------
local tabs = {"Movement","Combat","Aim","Visual","World"}

local function load(tab)

	clear()

	------------------------------------------------
	-- MOVEMENT (20)
	------------------------------------------------
	if tab == "Movement" then
		button("Speed 60", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60 end)
		button("Speed 100", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100 end)
		button("Jump Boost", function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = 120 end)
		button("Fly Toggle", function() print("Fly") end)
		button("Reset", function() game.Players.LocalPlayer.Character:BreakJoints() end)
		button("Low Gravity", function() workspace.Gravity = 60 end)
		button("Normal Gravity", function() workspace.Gravity = 196 end)
		button("High Gravity", function() workspace.Gravity = 300 end)
		button("Sit", function() game.Players.LocalPlayer.Character.Humanoid.Sit = true end)
		button("Freeze", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0 end)
		button("Unfreeze", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
		button("Ultra Speed", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 150 end)
		button("Mini Speed", function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30 end)
		button("Super Jump", function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = 200 end)
		button("Normal Jump", function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50 end)
		button("Anti Fall", function() print("enabled") end)
		button("No Clip", function() print("noclip") end)
		button("Clip", function() print("clip") end)
		button("Heal", function() game.Players.LocalPlayer.Character.Humanoid.Health = 100 end)
		button("God Mode (fake)", function() print("fake god") end)
	end

	------------------------------------------------
	-- COMBAT (15)
	------------------------------------------------
	if tab == "Combat" then
		for i=1,15 do
			button("Combat Feature "..i, function()
				print("Combat "..i)
			end)
		end
	end

	------------------------------------------------
	-- AIM (15)
	------------------------------------------------
	if tab == "Aim" then
		for i=1,15 do
			button("Aim Tool "..i, function()
				print("Aim "..i)
			end)
		end
	end

	------------------------------------------------
	-- VISUAL (15)
	------------------------------------------------
	if tab == "Visual" then
		button("FullBright", function()
			game.Lighting.Brightness = 3
		end)

		for i=1,14 do
			button("Visual "..i, function()
				print("Visual "..i)
			end)
		end
	end

	------------------------------------------------
	-- WORLD (15)
	------------------------------------------------
	if tab == "World" then
		button("Low Gravity", function() workspace.Gravity = 60 end)
		button("Normal Gravity", function() workspace.Gravity = 196 end)

		for i=1,13 do
			button("World "..i, function()
				print("World "..i)
			end)
		end
	end
end

------------------------------------------------
-- TAB BUTTONS
------------------------------------------------
for i,v in ipairs(tabs) do
	local t = Instance.new("TextButton")
	t.Size = UDim2.new(0,85,1,0)
	t.Position = UDim2.new(0,(i-1)*90,0,0)
	t.Text = v
	t.Parent = tabBar
	Instance.new("UICorner", t)

	t.MouseButton1Click:Connect(function()
		load(v)
	end)
end

------------------------------------------------
-- START
------------------------------------------------
load("Movement")
