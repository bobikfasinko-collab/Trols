local player = game.Players.LocalPlayer
local gui = script.Parent
local event = game.ReplicatedStorage:WaitForChild("AdminEvent")

-- UI
local keyFrame = gui.KeyFrame
local main = gui.MainUI

local keyBox = keyFrame.KeyBox
local submit = keyFrame.Submit

local panel = main.Panel
local tabs = panel.Tabs
local pages = panel.Pages

local correctKey = "Hub+"

print("привет " .. player.Name .. "!")

-- ======================
-- KEY SYSTEM
-- ======================
submit.Activated:Connect(function()
	if keyBox.Text == correctKey then
		keyFrame.Visible = false
		main.Visible = true
		print(player.Name .. " наслаждайтесь Hub+!")
	else
		keyBox.Text = ""
		keyBox.PlaceholderText = "Wrong Key!"
		print(player.Name .. " кажется вы ввели не тот ключ!")
	end
end)

main.Visible = false
keyFrame.Visible = true

-- ======================
-- TAB SYSTEM
-- ======================
local function openPage(name)
	for _, p in pairs(pages:GetChildren()) do
		if p:IsA("Frame") or p:IsA("ScrollingFrame") then
			p.Visible = (p.Name == name)
		end
	end
end

tabs.Player.Activated:Connect(function()
	openPage("PlayerPage")
end)

tabs.Server.Activated:Connect(function()
	openPage("ServerPage")
end)

openPage("PlayerPage")

-- ======================
-- FUNCTIONS
-- ======================
local function run(action, target)
	event:FireServer(action, target)
end

-- PLAYER PAGE
pages.PlayerPage.Heal.Activated:Connect(function()
	run("heal", pages.PlayerPage.TargetBox.Text)
end)

pages.PlayerPage.Speed.Activated:Connect(function()
	run("speed", pages.PlayerPage.TargetBox.Text)
end)

pages.PlayerPage.Jump.Activated:Connect(function()
	run("jump", pages.PlayerPage.TargetBox.Text)
end)

-- SERVER PAGE
pages.ServerPage.Kick.Activated:Connect(function()
	run("kick", pages.ServerPage.TargetBox.Text)
end)
