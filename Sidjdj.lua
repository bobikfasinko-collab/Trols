local player = game.Players.LocalPlayer
local gui = script.Parent

local keyFrame = gui.KeyFrame
local mainUI = gui.MainUI

local keyBox = keyFrame.KeyBox
local submit = keyFrame.Submit

local panel = mainUI.Panel
local tabs = panel.Tabs
local pages = panel.Pages

local correctKey = "HUB-1234"

print("привет " .. player.Name .. "!")

-- =========================
-- KEY SYSTEM
-- =========================
submit.MouseButton1Click:Connect(function()
	if keyBox.Text == correctKey then
		print(player.Name .. " наслаждайтесь панелью!")
		keyFrame.Visible = false
		mainUI.Visible = true
	else
		print(player.Name .. " кажется вы ввели не тот ключ!")
		keyBox.Text = ""
	end
end)

mainUI.Visible = false
keyFrame.Visible = true

-- =========================
-- TAB SWITCH
-- =========================
local function openPage(name)
	for _, p in pairs(pages:GetChildren()) do
		if p:IsA("ScrollingFrame") then
			p.Visible = (p.Name == name)
		end
	end
end

tabs.Visual.MouseButton1Click:Connect(function() openPage("VisualPage") end)
tabs.Server.MouseButton1Click:Connect(function() openPage("ServerPage") end)
tabs.Player.MouseButton1Click:Connect(function() openPage("PlayerPage") end)
tabs.Troll.MouseButton1Click:Connect(function() openPage("TrollPage") end)
tabs.Fun.MouseButton1Click:Connect(function() openPage("FunPage") end)
tabs.Soon.MouseButton1Click:Connect(function() openPage("SoonPage") end)

openPage("VisualPage")

-- =========================
-- FUNCTION SYSTEM (100+ TOGGLES)
-- =========================
local function createToggle(page, name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = "[OFF] " .. name
	btn.BackgroundTransparency = 0.3
	btn.Parent = page

	local state = false

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = (state and "[ON] " or "[OFF] ") .. name

		-- сюда ты подключаешь ЛОГИКУ своей игры
		-- example:
		-- if name == "Speed Boost" then player.Character.Humanoid.WalkSpeed = 32 end
	end)
end

-- =========================
-- FUNCTION LISTS (100+)
-- =========================

local visual = pages.VisualPage
local server = pages.ServerPage
local playerPage = pages.PlayerPage
local troll = pages.TrollPage
local fun = pages.FunPage
local soon = pages.SoonPage

-- VISUAL (20)
for i = 1, 20 do
	createToggle(visual, "Visual Feature " .. i)
end

-- SERVER (20)
for i = 1, 20 do
	createToggle(server, "Server Tool " .. i)
end

-- PLAYER (20)
for i = 1, 20 do
	createToggle(playerPage, "Player Ability " .. i)
end

-- TROLL (15)
for i = 1, 15 do
	createToggle(troll, "Troll Option " .. i)
end

-- FUN (15)
for i = 1, 15 do
	createToggle(fun, "Fun Mode " .. i)
end

-- SOON (10)
for i = 1, 10 do
	createToggle(soon, "Coming Soon " .. i)
end
