-- KEY SYSTEM
local correctKey = "Ger67"
local player = game.Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -10, 0, 30)
keyBox.Position = UDim2.new(0, 5, 0, 5)
keyBox.PlaceholderText = "Enter Key"
keyBox.Parent = frame

local enterBtn = Instance.new("TextButton")
enterBtn.Size = UDim2.new(1, -10, 0, 30)
enterBtn.Position = UDim2.new(0, 5, 0, 40)
enterBtn.Text = "Enter"
enterBtn.Parent = frame

local function createButton(text, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -10, 0, 40)
	b.Position = UDim2.new(0, 5, 0, pos)
	b.Text = text
	b.Parent = frame
	return b
end

local espBtn = createButton("ESP", 80)
local speedBtn = createButton("Speed 16", 130)
local jumpBtn = createButton("Infinite Jump", 180)

local allowed = false
local espEnabled = false
local speed = 16
local jumpEnabled = false

-- KEY CHECK
enterBtn.MouseButton1Click:Connect(function()
	if keyBox.Text == correctKey then
		allowed = true
		frame.Visible = true
	else
		frame.Visible = false
	end
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	if not allowed then return end

	speed = speed + 20
	if speed > 500 then speed = 16 end

	player.Character.Humanoid.WalkSpeed = speed
	speedBtn.Text = "Speed: " .. speed
end)

-- INFINITE JUMP
jumpBtn.MouseButton1Click:Connect(function()
	if not allowed then return end
	jumpEnabled = not jumpEnabled
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if jumpEnabled and allowed then
		player.Character.Humanoid:ChangeState("Jumping")
	end
end)

-- SIMPLE ESP (highlight players)
espBtn.MouseButton1Click:Connect(function()
	if not allowed then return end

	espEnabled = not espEnabled

	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= player and plr.Character then

			if espEnabled then
				local h = Instance.new("Highlight")
				h.FillColor = Color3.fromRGB(0,255,0)
				h.OutlineColor = Color3.fromRGB(0,255,0)
				h.Parent = plr.Character
			else
				for _, obj in pairs(plr.Character:GetChildren()) do
					if obj:IsA("Highlight") then
						obj:Destroy()
					end
				end
			end
		end
	end
end)
