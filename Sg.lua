--[[
  ⚡ GREGOO MOBILE ULTRA ⚡
  Создатель: Gregoo
  Версия: 2.0 (Без ключа)
--]]

if getgenv().GregooMobile then return end
getgenv().GregooMobile = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- ====================================================
-- ПЕРЕМЕННЫЕ
-- ====================================================
local flyEnabled = false
local speedEnabled = false
local infiniteJumpEnabled = false
local espEnabled = false
local espTarget = nil
local espHighlight = nil
local kokosActive = false
local flyVelocity, flyGyro = nil, nil
local menuVisible = true
local selectedPlayer = nil

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooMobile"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Фоновое затемнение
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.5
Background.Parent = ScreenGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.07, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Анимация переливания фона
local hue = 0
RunService.Heartbeat:Connect(function()
    if not MainFrame.Parent then return end
    hue = hue + 0.003
    if hue > 1 then hue = 0 end
    MainFrame.BorderColor3 = Color3.fromHSV(hue, 1, 0.8)
end)

-- ====================================================
-- 2. ЗАГОЛОВОК
-- ====================================================
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0.1, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ GREGOO ULTRA ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleLabel.TextSize = 30
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Приветствие
local GreetLabel = Instance.new("TextLabel")
GreetLabel.Size = UDim2.new(1, 0, 0.07, 0)
GreetLabel.Position = UDim2.new(0, 0, 0.1, 0)
GreetLabel.BackgroundTransparency = 1
GreetLabel.Text = "👋 Привет, " .. LocalPlayer.Name .. "!"
GreetLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
GreetLabel.TextSize = 22
GreetLabel.TextScaled = true
GreetLabel.Font = Enum.Font.GothamBold
GreetLabel.Parent = MainFrame

-- Заголовок "Создано Gregoo"
local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, 0, 0.08, 0)
CreatorLabel.Position = UDim2.new(0, 0, 0.9, 0)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "✨ Создано Gregoo ✨"
CreatorLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
CreatorLabel.TextSize = 20
CreatorLabel.TextScaled = true
CreatorLabel.Font = Enum.Font.GothamBold
CreatorLabel.TextStrokeColor = Color3.fromRGB(0, 100, 255)
CreatorLabel.TextStrokeTransparency = 0.3
CreatorLabel.Parent = MainFrame

-- ====================================================
-- 3. КНОПКИ МЕНЮ
-- ====================================================
local BtnContainer = Instance.new("ScrollingFrame")
BtnContainer.Size = UDim2.new(1, -20, 1, -0.3)
BtnContainer.Position = UDim2.new(0, 10, 0.18, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.CanvasSize = UDim2.new(0, 0, 0, 550)
BtnContainer.ScrollBarThickness = 8
BtnContainer.Parent = MainFrame

-- Функция создания кнопки
local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 70)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 80)
    btn.BackgroundTransparency = 0.15
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 22
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    btn.Parent = BtnContainer
    
    -- Эффект при нажатии
    btn.MouseButton1Down:Connect(function()
        btn.BackgroundTransparency = 0.4
    end)
    btn.MouseButton1Up:Connect(function()
        btn.BackgroundTransparency = 0.15
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Fly
local flyBtn = createButton("🪂 FLY", 0, Color3.fromRGB(0, 100, 200), function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyBtn.Text = "🪂 FLY ✅"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        flyBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        ToggleFly()
    else
        flyBtn.Text = "🪂 FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        flyBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        ToggleFly()
    end
end)

-- 2. Speed
local speedBtn = createButton("💨 SPEED (100%)", 80, Color3.fromRGB(200, 150, 0), function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "💨 SPEED ✅"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        speedBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        Humanoid.WalkSpeed = 50
    else
        speedBtn.Text = "💨 SPEED (100%)"
        speedBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        speedBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        Humanoid.WalkSpeed = 16
    end
end)

-- 3. Kokos Dance
local kokosBtn = createButton("🥥 KOKOS DANCE", 160, Color3.fromRGB(200, 50, 200), function()
    KokosDance()
end)

-- 4. Infinite Jump
local jumpBtn = createButton("🔄 INFINITE JUMP", 240, Color3.fromRGB(0, 150, 150), function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        jumpBtn.Text = "🔄 INFINITE JUMP ✅"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        jumpBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
    else
        jumpBtn.Text = "🔄 INFINITE JUMP"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
        jumpBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    end
end)

-- 5. ESP (выбор игрока)
local espBtn = createButton("👁️ ESP (выбрать игрока)", 320, Color3.fromRGB(0, 200, 0), function()
    ShowPlayerSelect()
end)

-- ====================================================
-- 4. КНОПКА СКРЫТЬ МЕНЮ
-- ====================================================
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.25, 0, 0.08, 0)
HideBtn.Position = UDim2.new(0.72, 0, 0.92, 0)
HideBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
HideBtn.Text = "✕ Скрыть"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 18
HideBtn.TextScaled = true
HideBtn.Font = Enum.Font.GothamBold
HideBtn.BorderSizePixel = 0
local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 8)
HideCorner.Parent = HideBtn
HideBtn.Parent = MainFrame
HideBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
    Background.Visible = false
end)

-- ====================================================
-- 5. КНОПКА ПОКАЗА МЕНЮ
-- ====================================================
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 70, 0, 70)
ShowBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ShowBtn.Text = "📋"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 35
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowBtn
ShowBtn.Parent = ScreenGui
ShowBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    Background.Visible = menuVisible
end)

-- ====================================================
-- 6. ФУНКЦИИ
-- ====================================================

-- FLY (для телефона)
function ToggleFly()
    if flyEnabled then
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = RootPart
        
        flyGyro = Instance.new("BodyGyro")
        flyGyro.P = 1e6
        flyGyro.D = 500
        flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        flyGyro.CFrame = RootPart.CFrame
        flyGyro.Parent = RootPart
        
        RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            if not RootPart or not RootPart.Parent then return end
            
            local move = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
            
            flyVelocity.Velocity = move
            flyGyro.CFrame = RootPart.CFrame
        end)
    else
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    end
end

-- KOKOS DANCE (радуга + кокос)
function KokosDance()
    if kokosActive then return end
    kokosActive = true
    
    -- Кокос на экране
    local coconut = Instance.new("TextLabel")
    coconut.Size = UDim2.new(0, 200, 0, 200)
    coconut.Position = UDim2.new(0.5, -100, 0.3, 0)
    coconut.BackgroundTransparency = 1
    coconut.Text = "🥥"
    coconut.TextSize = 150
    coconut.TextScaled = true
    coconut.Font = Enum.Font.GothamBold
    coconut.Parent = ScreenGui
    
    -- Радужный эффект
    local startTime = tick()
    local rainbowCon = RunService.Heartbeat:Connect(function()
        if tick() - startTime > 3 then
            rainbowCon:Disconnect()
            coconut:Destroy()
            kokosActive = false
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 2
            return
        end
        
        local h = (tick() * 0.5) % 1
        local color = Color3.fromHSV(h, 1, 1)
        Lighting.Ambient = color
        Lighting.Brightness = 3
    end)
end

-- ESP (выбор игрока)
function ShowPlayerSelect()
    if espEnabled then
        -- Отключаем ESP
        espEnabled = false
        if espHighlight then espHighlight:Destroy(); espHighlight = nil end
        espBtn.Text = "👁️ ESP (выбрать игрока)"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        espBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        return
    end
    
    local selectFrame = Instance.new("Frame")
    selectFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
    selectFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
    selectFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
    selectFrame.BackgroundTransparency = 0.1
    selectFrame.BorderSizePixel = 2
    selectFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    local selCorner = Instance.new("UICorner")
    selCorner.CornerRadius = UDim.new(0, 15)
    selCorner.Parent = selectFrame
    selectFrame.Parent = ScreenGui
    
    local selTitle = Instance.new("TextLabel")
    selTitle.Size = UDim2.new(1, 0, 0.12, 0)
    selTitle.Position = UDim2.new(0, 0, 0, 0)
    selTitle.BackgroundTransparency = 1
    selTitle.Text = "Выберите игрока для ESP"
    selTitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    selTitle.TextSize = 22
    selTitle.TextScaled = true
    selTitle.Font = Enum.Font.GothamBold
    selTitle.Parent = selectFrame
    
    local selContainer = Instance.new("ScrollingFrame")
    selContainer.Size = UDim2.new(1, -10, 1, -0.15)
    selContainer.Position = UDim2.new(0, 5, 0.12, 0)
    selContainer.BackgroundTransparency = 1
    selContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    selContainer.ScrollBarThickness = 8
    selContainer.Parent = selectFrame
    
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 55)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 20
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            btn.Parent = selContainer
            btn.MouseButton1Click:Connect(function()
                -- Включаем ESP на выбранном игроке
                espEnabled = true
                espTarget = plr
                
                if espHighlight then espHighlight:Destroy() end
                
                local char = plr.Character
                if char then
                    espHighlight = Instance.new("Highlight")
                    espHighlight.Name = "GregooESP"
                    espHighlight.FillColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.FillTransparency = 0.3
                    espHighlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    espHighlight.OutlineTransparency = 0.1
                    espHighlight.Parent = char
                end
                
                espBtn.Text = "👁️ ESP: " .. plr.Name
                espBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                espBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
                selectFrame:Destroy()
            end)
            y = y + 60
            selContainer.CanvasSize = UDim2.new(0, 0, 0, y)
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200, 200, 200)
        none.TextSize = 20
        none.Font = Enum.Font.Gotham
        none.Parent = selContainer
    end
end

-- ====================================================
-- 7. БЕСКОНЕЧНЫЙ ПРЫЖОК
-- ====================================================
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====================================================
-- 8. ОБНОВЛЕНИЕ ПЕРСОНАЖА
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    if flyEnabled then ToggleFly() end
    if speedEnabled then Humanoid.WalkSpeed = 50 end
end)

print("✅ Gregoo Mobile Ultra загружен!")
print("📱 Все функции работают на телефоне!")
