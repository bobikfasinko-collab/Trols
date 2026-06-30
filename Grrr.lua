local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local cam = workspace.CurrentCamera

------------------------------------------------
-- KEY
------------------------------------------------
local KEY = "Ger67"
local attempts = 3

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
-- MAIN PANEL
------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 450)
main.Position = UDim2.new(0.5, -160, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

------------------------------------------------
-- RAINBOW TITLE
------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "создатель Gergoo"
title.TextScaled = true
title.Parent = main

------------------------------------------------
-- RAINBOW EFFECT
------------------------------------------------
local hue = 0

RunService.RenderStepped:Connect(function()
	hue += 0.005
	if hue > 1 then hue = 0 end

	local color = Color3.fromHSV(hue,1,1)

	title.TextColor3 = color
	main.BorderColor3 = color
end)

------------------------------------------------
-- TOGGLE BUTTON (HIDE MENU)
------------------------------------------------
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,60,0,60)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "≡"
toggle.TextScaled = true
toggle.Parent = gui

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

------------------------------------------------
-- KEY FRAME
------------------------------------------------
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0,250,0,150)
keyFrame.Position = UDim2.new(0.5,-125,0.5,-75)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
keyFrame.Parent = gui

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1,-20,0,40)
keyBox.Position = UDim2.new(0,10,0,10)
keyBox.PlaceholderText = "Enter Key"
keyBox.Parent = keyFrame

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1,-20,0,40)
keyBtn.Position = UDim2.new(0,10,0,60)
keyBtn.Text = "Unlock"
keyBtn.Parent = keyFrame

local info = Instance.new("TextLabel")
info.Size = UDim2
