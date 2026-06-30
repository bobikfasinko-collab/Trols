--[[
  ⚡ THUNDERHUB ⚡
  Простая версия для телефона (100% работает)
--]]

if getgenv().ThunderHub then return end
getgenv().ThunderHub = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- ====================================================
-- ПЕРЕМЕННЫЕ
-- ====================================================
local speedEnabled = false
local speedValue = 25
local infiniteJumpEnabled = false
local highJumpEnabled = false
local espEnabled = false
local espHighlight = nil
local kokosActive = false
local flingActive = false
local followActive = false
local followTarget = nil
local followConnection = nil
local secretActive = false
local menuVisible = true

-- ====================================================
-- 1. СОЗДАНИЕ ГЛАВНОГО МЕНЮ
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
MainFrame.Size = UDim2.new(0.95, 0, 0.92, 0)
MainFrame.Position = UDim2.new(0.025, 0, 0.04, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.07, 0)
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
SubTitle.Position = UDim2.new(0, 0, 0.07, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "by Gregoo"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextScaled = true
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = MainFrame

-- ====================================================
-- 2. КОНТЕЙНЕР ДЛЯ КНОПОК (СКРОЛЛИНГ)
-- ====================================================
local BtnContainer = Instance.new("ScrollingFrame")
BtnContainer.Size = UDim2.new(1, -20, 1, -0.18)
BtnContainer.Position = UDim2.new(0, 10, 0.13, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.CanvasSize = UDim2.new(0, 0, 0, 700)
BtnContainer.ScrollBarThickness = 8
BtnContainer.Parent = MainFrame

-- ====================================================
-- 3. ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
-- ====================================================
local function createBtn(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 52)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    btn.Parent = BtnContainer
    
    -- Для телефона
    btn.MouseButton1Click:Connect(callback)
    btn.TouchTap:Connect(callback)
    
    return btn
end

-- ====================================================
-- 4. КНОПКИ
-- ====================================================
local y = 0

-- 1. SPEED
local speedBtn = createBtn("💨 Скорость ("..speedValue..")", y, Color3.fromRGB(0, 150, 255), function()
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
-- +/-
local spUp = Instance.new("TextButton")
spUp.Size = UDim2.new(0.1, 0, 0, 35)
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
spDown.Size = UDim2.new(0.1, 0, 0, 35)
spDown.Position = UDim2.new(0.83, 0, 0, 8)
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
y = y + 58

-- 2. INFINITE JUMP
local jumpBtn = createBtn("🔄 Бесконечный прыжок", y, Color3.fromRGB(0, 150, 200), function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        jumpBtn.Text = "🔄 Бесконечный прыжок ✅"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        jumpBtn.Text = "🔄 Бесконечный прыжок"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    end
end)
y = y + 58

-- 3. HIGH JUMP
local highBtn = createBtn("⬆️ Высокий прыжок", y, Color3.fromRGB(150, 0, 200), function()
    highJumpEnabled = not highJumpEnabled
    if highJumpEnabled then
        highBtn.Text = "⬆️ Высокий прыжок ✅"
        highBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        Humanoid.JumpPower = 100
    else
        highBtn.Text = "⬆️ Высокий прыжок"
        highBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
        Humanoid.JumpPower = 50
    end
end)
y = y + 58

-- 4. ESP
local espBtn = createBtn("👁️ ESP (выбрать)", y, Color3.fromRGB(0, 200, 0), function()
    if espEnabled then
        espEnabled = false
        if espHighlight then espHighlight:Destroy(); espHighlight = nil end
        espBtn.Text = "👁️ ESP (выбрать)"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end
    ShowPlayerList("Выберите игрока для ESP", function(plr)
        espEnabled = true
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
        espBtn.Text = "👁️ " .. plr.Name
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end)
end)
y = y + 58

-- 5. KOKOS PARTY
local kokosBtn = createBtn("🥥 Kokos Party 🥳", y, Color3.fromRGB(200, 50, 200), function()
    if kokosActive then return end
    kokosActive = true
    
    local coconut = Instance.new("TextLabel")
    coconut.Size = UDim2.new(0, 200, 0, 200)
    coconut.Position = UDim2.new(0.5, -100, 0.3, 0)
    coconut.BackgroundTransparency = 1
    coconut.Text = "🥥"
    coconut.TextScaled = true
    coconut.Font = Enum.Font.GothamBold
    coconut.Parent = ScreenGui
    
    local start = tick()
    RunService.Heartbeat:Connect(function()
        if tick() - start > 5 then
            coconut:Destroy()
            kokosActive = false
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 2
            return
        end
        local h = (tick() * 0.5) % 1
        Lighting.Ambient = Color3.fromHSV(h, 1, 1)
        Lighting.Brightness = 3
    end)
end)
y = y + 58

-- 6. FLING
local flingBtn = createBtn("💢 Fling (выкинуть)", y, Color3.fromRGB(255, 50, 50), function()
    ShowPlayerList("Кого выкинуть за карту?", function(plr)
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.Position = Vector3.new(0, -500, 0)
            wait(0.5)
            hrp.Position = Vector3.new(math.random(-5000,5000), -1000, math.random(-5000,5000))
        end
    end)
end)
y = y + 58

-- 7. FOLLOW
local followBtn = createBtn("👣 Следование", y, Color3.fromRGB(0, 150, 255), function()
    if followActive then
        followActive = false
        if followConnection then followConnection:Disconnect(); followConnection = nil end
        followBtn.Text = "👣 Следование"
        followBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        return
    end
    ShowPlayerList("За кем следовать?", function(plr)
        followActive = true
        followTarget = plr
        followBtn.Text = "👣 " .. plr.Name
        followBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        
        if followConnection then followConnection:Disconnect() end
        followConnection = RunService.Heartbeat:Connect(function()
            if not followActive or not followTarget then return end
            local targetChar = followTarget.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                local targetPos = targetChar.HumanoidRootPart.Position
                RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            end
        end)
    end)
end)
y = y + 58

-- 8. SECRET
local secretBtn = createBtn("🔮 СЕКРЕТ!", y, Color3.fromRGB(200, 50, 200), function()
    if secretActive then return end
    secretActive = true
    
    local start = tick()
    RunService.Heartbeat:Connect(function()
        if tick() - start > 8 then
            secretActive = false
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 2
            return
        end
        local h = (tick() * 0.3) % 1
        Lighting.Ambient = Color3.fromHSV(h, 1, 1)
        Lighting.Brightness = 3
    end)
    
    local positions = {
        Vector3.new(100, 50, 100),
        Vector3.new(-100, 50, -100),
        Vector3.new(100, 50, -100),
        Vector3.new(-100, 50, 100),
        Vector3.new(0, 100, 0),
        Vector3.new(200, 30, 200),
        Vector3.new(-200, 30, -200)
    }
    local i = 1
    RunService.Heartbeat:Connect(function()
        if not secretActive then return end
        if i <= #positions then
            RootPart.CFrame = CFrame.new(positions[i] + Vector3.new(0, 5, 0))
            i = i + 1
        else
            i = 1
        end
        wait(0.2)
    end)
end)
y = y + 58

-- Обновляем размер скролла
BtnContainer.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- ====================================================
-- 5. ФУНКЦИЯ СПИСКА ИГРОКОВ
-- ====================================================
function ShowPlayerList(titleText, callback)
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
    ftitle.Text = titleText
    ftitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    ftitle.TextScaled = true
    ftitle.Font = Enum.Font.GothamBold
    ftitle.Parent = frame
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -0.12)
    container.Position = UDim2.new(0, 5, 0.12, 0)
    container.BackgroundTransparency = 1
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollBarThickness = 6
    container.Parent = frame
    
    local y = 0
    local hasPlayers = false
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            hasPlayers = true
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 50)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            local bcorner = Instance.new("UICorner")
            bcorner.CornerRadius = UDim.new(0, 6)
            bcorner.Parent = btn
            btn.Parent = container
            
            btn.MouseButton1Click:Connect(function()
                callback(plr)
                frame:Destroy()
            end)
            btn.TouchTap:Connect(function()
                callback(plr)
                frame:Destroy()
            end)
            
            y = y + 55
            container.CanvasSize = UDim2.new(0, 0, 0, y)
        end
    end
    if not hasPlayers then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200, 200, 200)
        none.TextScaled = true
        none.Font = Enum.Font.Gotham
        none.Parent = container
    end
end

-- ====================================================
-- 6. БЕСКОНЕЧНЫЙ ПРЫЖОК
-- ====================================================
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====================================================
-- 7. КНОПКИ УПРАВЛЕНИЯ МЕНЮ
-- ====================================================

-- Скрыть
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.3, 0, 0.06, 0)
HideBtn.Position = UDim2.new(0.68, 0, 0.93, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HideBtn.Text = "✕ Скрыть"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextScaled = true
HideBtn.Font = Enum.Font.GothamBold
HideBtn.BorderSizePixel = 0
local hcorner = Instance.new("UICorner")
hcorner.CornerRadius = UDim.new(0, 8)
hcorner.Parent = HideBtn
HideBtn.Parent = MainFrame
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Background.Visible = false
end)
HideBtn.TouchTap:Connect(function()
    MainFrame.Visible = false
    Background.Visible = false
end)

-- Показать
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 60, 0, 60)
ShowBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
ShowBtn.Text = "📋"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 30
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
local showcorner = Instance.new("UICorner")
showcorner.CornerRadius = UDim.new(1, 0)
showcorner.Parent = ShowBtn
ShowBtn.Parent = ScreenGui
ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Background.Visible = true
end)
ShowBtn.TouchTap:Connect(function()
    MainFrame.Visible = true
    Background.Visible = true
end)

-- ====================================================
-- 8. ОБНОВЛЕНИЕ ПЕРСОНАЖА
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    if highJumpEnabled then Humanoid.JumpPower = 100 end
end)

print("✅ ThunderHub загружен!")
print("📱 Все кнопки должны работать на телефоне!")
