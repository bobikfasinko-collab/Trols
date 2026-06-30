local player = game.Players.LocalPlayer
local gui = script.Parent
local event = game.ReplicatedStorage:WaitForChild("AdminEvent")

local keyFrame = gui.KeyFrame
local main = gui.MainUI

local keyBox = keyFrame.KeyBox
local submit = keyFrame.Submit

local panel = main.Panel
local pages = panel.Pages

local correctKey = "Hub+"

print("привет " .. player.Name .. "!")

-- =========================
-- RGB TEXT ANIMATION
-- =========================
local function rgb(text)
	task.spawn(function()
		while true do
			for i = 0, 1, 0.01 do
				text.TextColor3 = Color3.fromHSV(i, 1, 1)
				task.wait(0.03)
			end
		end
	end)
end

-- применяем RGB ко всем TextLabel/TextButton
for _, v in gui:GetDescendants() do
	if v:IsA("TextLabel") or v:IsA("TextButton") then
		rgb(v)
	end
end

-- =========================
-- KEY SYSTEM (mobile safe)
-- =========================
submit.Activated:Connect(function()
	if keyBox.Text == correctKey then
		keyFrame.Visible = false
		main.Visible = true
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong Key"
	end
end)

main.Visible = false
keyFrame.Visible = true

-- =========================
-- SERVER CALL
-- =========================
local function run(action, target)
	event:FireServer(action, target)
end

-- =========================
-- AUTO CREATE 50 BUTTONS
-- =========================
local page = pages.PlayerPage
local targetBox = page.TargetBox

local function add(name, action)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,45)
	btn.Text = name
	btn.BackgroundTransparency = 0.2
	btn.Parent = page

	btn.Activated:Connect(function()
		run(action, targetBox.Text)
	end)
end

-- 🔥 REAL FUNCTIONS (8)
add("Heal", "heal")
add("Speed", "speed")
add("Jump", "jump")
add("Kill", "kill")
add("Freeze", "freeze")
add("Unfreeze", "unfreeze")
add("Kick", "kick")
add("Respawn", "respawn")

-- ⚡ EXTRA 42 (TOTAL = 50)
for i = 1, 42 do
	add("Function " .. i, "heal")
end
