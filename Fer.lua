--[[
  ⚡ THUNDERHUB MM2 ⚡
  Создатель: Gregoo
  Версия: 1.0 (Mobile)
--]]

if getgenv().ThunderHub then return end
getgenv().ThunderHub = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- ====================================================
-- ПЕРЕМЕННЫЕ
-- ====================================================
local currentTab = "Обычное"
local flyEnabled = false
local speedEnabled = false
local speedValue = 25
local infiniteJumpEnabled = false
local highJumpEnabled = false
local espEnabled = false
local espTarget = nil
local espHighlight = nil
local flingEnabled = false
local followEnabled = false
local followTarget = nil
local secretActive = false
local flyVelocity = nil
local flyGyro = nil
local menuVisible = true
local tabButtons = {}
local flingConnection = nil
local followConnection = nil

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThunderHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Фон
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.4
Background.Parent = ScreenGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.92, 0, 0.9, 0)
MainFrame.Position = UDim2.new(0.04, 0, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ THUNDERHUB ⚡"
Title.TextColor3 = Color3.fromRGB(255, 200, 0)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Подзаголовок
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0.05, 0)
SubTitle.Position = UDim2.new(0, 0, 0.08, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by Gregoo"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = MainFrame

-- ====================================================
-- 2. ВКЛАДКИ
-- ====================================================
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -10, 0.08, 0)
TabContainer.Position = UDim2.new(0, 5, 0.13, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabs = {"Обычное", "Визуал", "Троллинг💀", "Прикол"}
local tabColors = {
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(0, 255, 100),
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(200, 50, 200)
}

local function createTab(text, index, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((index-1) * 0.25, 0, 0, 0)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    btn.Parent = TabContainer
    
    btn.MouseButton1Click:Connect(function()
        SwitchTab(text)
    end)
    btn.TouchTap:Connect(function()
        SwitchTab(text)
    end)
    
    table.insert(tabButtons, btn)
    return btn
end

for i, tab in pairs(tabs) do
    createTab(tab, i, tabColors[i])
end

-- ====================================================
-- 3. КОНТЕЙНЕР ДЛЯ КНОПОК ВКЛАДОК
-- ====================================================
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -20, 1, -0.27)
ContentContainer.Position = UDim2.new(0, 10, 0.22, 0)
ContentContainer.BackgroundTransparency = 1
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollBarThickness = 6
ContentContainer.Parent = MainFrame

-- ====================================================
-- 4. ФУНКЦИЯ ПЕРЕКЛЮЧЕНИЯ ВКЛАДОК
-- ====================================================
function SwitchTab(tab)
    currentTab = tab
    for _, btn in pairs(tabButtons) do
        btn.BackgroundTransparency = 0.3
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end
    for i, btn in pairs(tabButtons) do
        if tabs[i] == tab then
            btn.BackgroundTransparency = 0.1
            btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
    UpdateContent()
end

-- ====================================================
-- 5. ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
-- ====================================================
local function createContentButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.Parent = ContentContainer
    
    btn.MouseButton1Click:Connect(callback)
    btn.TouchTap:Connect(callback)
    return btn
end

-- ====================================================
-- 6. ОБНОВЛЕНИЕ КОНТЕНТА ВКЛАДКИ
-- ====================================================
function UpdateContent()
    for _, child in pairs(ContentContainer:GetChildren()) do
        child:Destroy()
    end
    
    local y = 0
    
    if currentTab == "Обычное" then
        -- Speed
        local speedBtn = createContentButton("💨 Скорость ("..speedValue..")", y, Color3.fromRGB(0, 150, 255), function()
            speedEnabled = not speedEnabled
            if speedEnabled then
                speedBtn.Text = "💨 Скорость ("..speedValue..") ✅"
                speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                Humanoid.WalkSpeed = speedValue
            else
                speedBtn.Text = "💨 Скорость ("..speedValue..")"
                speedBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                Humanoid.WalkSpeed = 16
            end
        end)
        y = y + 55
        
        -- Speed +/- 
        local spUp = Instance.new("TextButton")
        spUp.Size = UDim2.new(0.12, 0, 0, 35)
        spUp.Position = UDim2.new(0.7, 0, 0, 8)
        spUp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spUp.Text = "+"
        spUp.TextColor3 = Color3.fromRGB(255,255,255)
        spUp.TextScaled = true
        spUp.Font = Enum.Font.GothamBold
        spUp.BorderSizePixel = 0
        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 6)
        upCorner.Parent = spUp
        spUp.Parent = speedBtn
        spUp.MouseButton1Click:Connect(function()
            speedValue = math.min(speedValue + 5, 100)
            if speedEnabled then Humanoid.WalkSpeed = speedValue end
            speedBtn.Text = "💨 Скорость ("..speedValue..")" .. (speedEnabled and " ✅" or "")
        end)
        spUp.TouchTap:Connect(function()
            speedValue = math.min(speedValue + 5, 100)
            if speedEnabled then Humanoid.WalkSpeed = speedValue end
            speedBtn.Text = "💨 Скорость ("..speedValue..")" .. (speedEnabled and " ✅" or "")
        end)
        
        local spDown = Instance.new("TextButton")
        spDown.Size = UDim2.new(0.12, 0, 0, 35)
        spDown.Position = UDim2.new(0.85, 0, 0, 8)
        spDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        spDown.Text = "-"
        spDown.TextColor3 = Color3.fromRGB(255,255,255)
        spDown.TextScaled = true
        spDown.Font = Enum.Font.GothamBold
        spDown.BorderSizePixel = 0
        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 6)
        downCorner.Parent = spDown
        spDown.Parent = speedBtn
        spDown.MouseButton1Click:Connect(function()
            speedValue = math.max(speedValue - 5, 10)
            if speedEnabled then Humanoid.WalkSpeed = speedValue end
            speedBtn.Text = "💨 Скорость ("..speedValue..")" .. (speedEnabled and " ✅" or "")
        end)
        spDown.TouchTap:Connect(function()
            speedValue = math.max(speedValue - 5, 10)
            if speedEnabled then Humanoid.WalkSpeed = speedValue end
            speedBtn.Text = "💨 Скорость ("..speedValue..")" .. (speedEnabled and " ✅" or "")
        end)
        
        -- Infinite Jump
        local jumpBtn = createContentButton("🔄 Бесконечный прыжок", y, Color3.fromRGB(0, 150, 200), function()
            infiniteJumpEnabled = not infiniteJumpEnabled
            if infiniteJumpEnabled then
                jumpBtn.Text = "🔄 Бесконечный прыжок ✅"
                jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            else
                jumpBtn.Text = "🔄 Бесконечный прыжок"
                jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
            end
        end)
        y = y + 55
        
        -- High Jump
        local highJumpBtn = createContentButton("⬆️ Высокий прыжок", y, Color3.fromRGB(150, 0, 200), function()
            highJumpEnabled = not highJumpEnabled
            if highJumpEnabled then
                highJumpBtn.Text = "⬆️ Высокий прыжок ✅"
                highJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                Humanoid.JumpPower = 100
            else
                highJumpBtn.Text = "⬆️ Высокий прыжок"
                highJumpBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
                Humanoid.JumpPower = 50
            end
        end)
        y = y + 55
        
    elseif currentTab == "Визуал" then
        -- ESP
        local espBtn = createContentButton("👁️ ESP (выбрать игрока)", y, Color3.fromRGB(0, 200, 0), function()
            ShowESPSelect(espBtn)
        end)
        y = y + 55
        
        -- Kokos Party
        local kokosBtn = createContentButton("🥥 Kokos Party 🥳", y, Color3.fromRGB(200, 50, 200), function()
            KokosParty()
        end)
        y = y + 55
        
    elseif currentTab == "Троллинг💀" then
        -- Fling
        local flingBtn = createContentButton("💢 Fling (выкинуть игрока)", y, Color3.fromRGB(255, 50, 50), function()
            ShowFlingSelect()
        end)
        y = y + 55
        
        -- Follow
        local followBtn = createContentButton("👣 Следование за игроком", y, Color3.fromRGB(0, 150, 255), function()
            ShowFollowSelect(followBtn)
        end)
        y = y + 55
        
    elseif currentTab == "Прикол" then
        -- Secret
        local secretBtn = createContentButton("🔮 СЕКРЕТ!", y, Color3.fromRGB(200, 50, 200), function()
            SecretMode()
        end)
        y = y + 55
    end
    
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, y + 20)
end

-- ====================================================
-- 7. ВСЕ ФУНКЦИИ
-- ====================================================

-- ESP SELECT
function ShowESPSelect(btn)
    if espEnabled then
        espEnabled = false
        if espHighlight then espHighlight:Destroy(); espHighlight = nil end
        btn.Text = "👁️ ESP (выбрать игрока)"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end
    
    local frame = CreateSelectFrame("Выберите игрока для ESP")
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = CreatePlayerButton(plr, frame, y)
            b.MouseButton1Click:Connect(function()
                espEnabled = true
                espTarget = plr
                if espHighlight then espHighlight:Destroy() end
                local char = plr.Character
                if char then
                    espHighlight = Instance.new("Highlight")
                    espHighlight.FillColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.FillTransparency = 0.3
                    espHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.OutlineTransparency = 0.1
                    espHighlight.Parent = char
                end
                btn.Text = "👁️ " .. plr.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                frame:Destroy()
            end)
            b.TouchTap:Connect(function()
                espEnabled = true
                espTarget = plr
                if espHighlight then espHighlight:Destroy() end
                local char = plr.Character
                if char then
                    espHighlight = Instance.new("Highlight")
                    espHighlight.FillColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.FillTransparency = 0.3
                    espHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.OutlineTransparency = 0.1
                    espHighlight.Parent = char
                end
                btn.Text = "👁️ " .. plr.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                frame:Destroy()
            end)
            y = y + 55
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200,200,200)
        none.TextScaled = true
        none.Font = Enum.Font.Gotham
        none.Parent = frame:FindFirstChild("Container")
    end
end

-- FLING SELECT
function ShowFlingSelect()
    local frame = CreateSelectFrame("Кого выкинуть за карту?")
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = CreatePlayerButton(plr, frame, y)
            b.MouseButton1Click:Connect(function()
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.Position = Vector3.new(0, -500, 0)
                    wait(0.5)
                    hrp.Position = Vector3.new(math.random(-5000,5000), -1000, math.random(-5000,5000))
                end
                frame:Destroy()
            end)
            b.TouchTap:Connect(function()
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.Position = Vector3.new(0, -500, 0)
                    wait(0.5)
                    hrp.Position = Vector3.new(math.random(-5000,5000), -1000, math.random(-5000,5000))
                end
                frame:Destroy()
            end)
            y = y + 55
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200,200,200)
        none.TextScaled = true
        none.Font = Enum.Font.Gotham
        none.Parent = frame:FindFirstChild("Container")
    end
end

-- FOLLOW SELECT
function ShowFollowSelect(btn)
    if followEnabled then
        followEnabled = false
        if followConnection then followConnection:Disconnect(); followConnection = nil end
        btn.Text = "👣 Следование за игроком"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        return
    end
    
    local frame = CreateSelectFrame("За кем следовать?")
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = CreatePlayerButton(plr, frame, y)
            b.MouseButton1Click:Connect(function()
                followEnabled = true
                followTarget = plr
                btn.Text = "👣 Следование: " .. plr.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                frame:Destroy()
                
                if followConnection then followConnection:Disconnect() end
                followConnection = RunService.Heartbeat:Connect(function()
                    if not followEnabled or not followTarget then return end
                    local targetChar = followTarget.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local targetPos = targetChar.HumanoidRootPart.Position
                        RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    end
                end)
            end)
            b.TouchTap:Connect(function()
                followEnabled = true
                followTarget = plr
                btn.Text = "👣 Следование: " .. plr.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                frame:Destroy()
                
                if followConnection then followConnection:Disconnect() end
                followConnection = RunService.Heartbeat:Connect(function()
                    if not followEnabled or not followTarget then return end
                    local targetChar = followTarget.Character
                    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                        local targetPos = targetChar.HumanoidRootPart.Position
                        RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    end
                end)
            end)
            y = y + 55
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200,200,200)
        none.TextScaled = true
        none.Font = Enum.Font.Gotham
        none.Parent = frame:FindFirstChild("Container")
    end
end

-- Создание окна выбора
function CreateSelectFrame(title)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.85, 0, 0.6, 0)
    frame.Position = UDim2.new(0.075, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 200, 0)
    local fcorner = Instance.new("UICorner")
    fcorner.CornerRadius = UDim.new(0, 12)
    fcorner.Parent = frame
    frame.Parent = ScreenGui
    
    local ftitle = Instance.new("TextLabel")
    ftitle.Size = UDim2.new(1, 0, 0.1, 0)
    ftitle.BackgroundTransparency = 1
    ftitle.Text = title
    ftitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    ftitle.TextScaled = true
    ftitle.Font = Enum.Font.GothamBold
    ftitle.Parent = frame
    
    local container = Instance.new("ScrollingFrame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -10, 1, -0.12)
    co
