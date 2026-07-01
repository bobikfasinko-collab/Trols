local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedMenu"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Кнопка открытия
local openButton = Instance.new("TextButton")
openButton.Parent = gui
openButton.Size = UDim2.new(0,40,0,40)
openButton.Position = UDim2.new(0,10,0.5,-20)
openButton.Text = "≡"
openButton.TextScaled = true
openButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
openButton.TextColor3 = Color3.new(1,1,1)
openButton.BorderSizePixel = 0
Instance.new("UICorner",openButton).CornerRadius = UDim.new(0,8)

-- Меню
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,220,0,150)
frame.Position = UDim2.new(0,60,0.5,-75)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 2

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)

-- RGB Обводка
RunService.RenderStepped:Connect(function()
	local t = tick()*2
	frame.BorderColor3 = Color3.fromHSV((t%6)/6,1,1)
end)

-- Заголовок
local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = player.Name.." привет!"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- Поле скорости
local box = Instance.new("TextBox")
box.Parent = frame
box.Size = UDim2.new(0,180,0,30)
box.Position = UDim2.new(0.5,-90,0,45)
box.PlaceholderText = "1 - 1000"
box.Text = "16"
box.TextScaled = true
box.BackgroundColor3 = Color3.fromRGB(35,35,35)
box.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",box).CornerRadius = UDim.new(0,6)

-- Кнопка ON/OFF
local toggle = Instance.new("TextButton")
toggle.Parent = frame
toggle.Size = UDim2.new(0,180,0,30)
toggle.Position = UDim2.new(0.5,-90,0,90)
toggle.Text = "Скорость: OFF"
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",toggle).CornerRadius = UDim.new(0,6)

local enabled = false

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggle.Text = "Скорость: ON"
	else
		toggle.Text = "Скорость: OFF"
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = 16
		end
	end
end)

local function applySpeed()
	if enabled then
		local char = player.Character
		if char and char:FindFirstChild("Humanoid") then
			local speed = tonumber(box.Text)
			if speed then
				speed = math.clamp(speed,1,1000)
				char.Humanoid.WalkSpeed = speed
			end
		end
	end
end

box.FocusLost:Connect(applySpeed)

player.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid")
	wait(0.2)
	applySpeed()
end)

RunService.RenderStepped:Connect(function()
	if enabled then
		applySpeed()
	end
end)

local opened = true

openButton.MouseButton1Click:Connect(function()
	opened = not opened
	if opened then
		TweenService:Create(frame,TweenInfo.new(0.25),{
			Position = UDim2.new(0,60,0.5,-75)
		}):Play()
	else
		TweenService:Create(frame,TweenInfo.new(0.25),{
			Position = UDim2.new(-1,0,0.5,-75)
		}):Play()
	end
end)
