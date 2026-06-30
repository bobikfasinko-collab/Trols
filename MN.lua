--[[
  ⚡ GREGOO MOBILE ⚡
  Простая и надёжная версия для Tecno
--]]

if getgenv().GregooSimple then return end
getgenv().GregooSimple = true

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
local flyEnabled = false
local speedEnabled = false
local infiniteJumpEnabled = false
local espEnabled = false
local espHighlight = nil
local kokosActive = false
local flyVelocity = nil
local flyGyro = nil
local menuVisible = true

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ (максимально простое)
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooSimple"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Фон
local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Background.BackgroundTransparency = 0.5
Background.Parent = ScreenGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ GREGOO ⚡"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Приветствие
local Greet = Instance.new("TextLabel")
Greet.Size = UDim2.new(1, 0, 0.08, 0)
Greet.Position = UDim2.new(0, 0, 0.1, 0)
Greet.BackgroundTransparency = 1
Greet.Text = "Привет, " .. LocalPlayer.Name
Greet.TextColor3 = Color3.fromRGB(0, 255, 100)
Greet.TextScaled = true
Greet.Font = Enum.Font.GothamBold
Greet.Parent = MainFrame

-- Автор
local Author = Instance.new("TextLabel")
Author.Size = UDim2.new(1, 0, 0.06, 0)
Author.Position = UDim2.new(0, 0, 0.94, 0)
Author.BackgroundTransparency = 1
Author.Text = "Создано Gregoo"
Author.TextColor3 = Color3.fromRGB(255, 200, 100)
Author.TextScaled = true
Author.Font = Enum.Font.Gotham
Author.Parent = MainFrame

-- ====================================================
-- 2. КОНТЕЙНЕР ДЛЯ КНОПОК
-- ====================================================
local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -20, 1, -0.2)
BtnContainer.Position = UDim2.new(0, 10, 0.19, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame

-- ====================================================
-- 3. ФУНКЦИЯ СОЗДАНИЯ КНОПКИ (с двойным кликом)
-- ====================================================
local function makeButton(text, y, color, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.3
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
    
    -- Двойной клик для надёжности
    btn.MouseButton1Click:Connect(func)
    btn.TouchTap:Connect(func)
    
    return btn
end

-- ====================================================
-- 4. СОЗДАЁМ КНОПКИ
-- ====================================================

-- FLY
local flyBtn = makeButton("🪂 FLY", 0, Color3.fromRGB(0, 100, 200), function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyBtn.Text = "🪂 FLY ✅"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        -- Включаем полёт
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
        flyBtn.Text = "🪂 FLY"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    end
end)

-- SPEED
local speedBtn = makeButton("💨 SPEED", 65, Color3.fromRGB(200, 150, 0), function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "💨 SPEED ✅"
        speedBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        Humanoid.WalkSpeed = 50
    else
        speedBtn.Text = "💨 SPEED"
        speedBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
        Humanoid.WalkSpeed = 16
    end
end)

-- KOKOS
local kokosBtn = makeButton("🥥 KOKOS", 130, Color3.fromRGB(200, 50, 200), function()
    if kokosActive then return end
    kokosActive = true
    
    local coconut = Instance.new("TextLabel")
    coconut.Size = UDim2.new(0, 150, 0, 150)
    coconut.Position = UDim2.new(0.5, -75, 0.35, 0)
    coconut.BackgroundTransparency = 1
    coconut.Text = "🥥"
    coconut.TextScaled = true
    coconut.Font = Enum.Font.GothamBold
    coconut.Parent = ScreenGui
    
    local start = tick()
    RunService.Heartbeat:Connect(function()
        if tick() - start > 3 then
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

-- JUMP
local jumpBtn = makeButton("🔄 JUMP", 195, Color3.fromRGB(0, 150, 150), function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    if infiniteJumpEnabled then
        jumpBtn.Text = "🔄 JUMP ✅"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        jumpBtn.Text = "🔄 JUMP"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    end
end)

-- ESP
local espBtn = makeButton("👁️ ESP", 260, Color3.fromRGB(0, 200, 0), function()
    if espEnabled then
        espEnabled = false
        if espHighlight then espHighlight:Destroy(); espHighlight = nil end
        espBtn.Text = "👁️ ESP"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        return
    end
    
    -- Выбор игрока через простой список
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.5, 0)
    frame.Position = UDim2.new(0.1, 0, 0.25, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 40)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    local fcorner = Instance.new("UICorner")
    fcorner.CornerRadius = UDim.new(0, 12)
    fcorner.Parent = frame
    frame.Parent = ScreenGui
    
    local ftitle = Instance.new("TextLabel")
    ftitle.Size = UDim2.new(1, 0, 0.12, 0)
    ftitle.BackgroundTransparency = 1
    ftitle.Text = "Выберите игрока"
    ftitle.TextColor3 = Color3.fromRGB(0, 255, 100)
    ftitle.TextScaled = true
    ftitle.Font = Enum.Font.GothamBold
    ftitle.Parent = frame
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 1, -0.15)
    container.Position = UDim2.new(0, 5, 0.12, 0)
    container.BackgroundTransparency = 1
    container.Parent = frame
    
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 50)
            b.Position = UDim2.new(0, 0, 0, y)
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            b.Text = plr.Name
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.TextScaled = true
            b.Font = Enum.Font.Gotham
            b.BorderSizePixel = 1
            b.BorderColor3 = Color3.fromRGB(255, 255, 255)
            local bcorner = Instance.new("UICorner")
            bcorner.CornerRadius = UDim.new(0, 6)
            bcorner.Parent = b
            b.Parent = container
            
            b.MouseButton1Click:Connect(function()
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
                frame:Destroy()
            end)
            b.TouchTap:Connect(function()
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
                frame:Destroy()
            end)
            
            y = y + 55
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1, 0, 0, 50)
        none.BackgroundTransparency = 1
        none.Text = "Нет игроков"
        none.TextColor3 = Color3.fromRGB(200, 200, 200)
        none.TextScaled = true
        none.Font = Enum.Font.Gotham
        none.Parent = container
    end
end)

-- ====================================================
-- 5. КНОПКИ УПРАВЛЕНИЯ МЕНЮ
-- ====================================================

-- Скрыть меню
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.3, 0, 0.07, 0)
HideBtn.Position = UDim2.new(0.68, 0, 0.92, 0)
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

-- Показать меню (кнопка в углу)
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 60, 0, 60)
ShowBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
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
-- 6. БЕСКОНЕЧНЫЙ ПРЫЖОК
-- ====================================================
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====================================================
-- 7. ОБНОВЛЕНИЕ ПЕРСОНАЖА
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
end)

print("✅ Gregoo Simple загружен!")
print("📱 Кнопки: Fly, Speed, Kokos, Jump, ESP")
