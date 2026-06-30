--[[
  СКРИПТ: Troll Push + Кручение + Premium (Полёт)
  Создатель: Gregoo
  Версия: 3.0
--]]

if getgenv().TrollGUI then return end
getgenv().TrollGUI = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ====================================================
-- НАСТРОЙКИ
-- ====================================================
local PUSH_FORCE = 6000
local PUSH_RADIUS = 18
local SPIN_SPEED = 2.5  -- Об/сек

-- ====================================================
-- ПЕРЕМЕННЫЕ
-- ====================================================
local Unlocked = false
local PremiumUnlocked = false
local isSpinning = false
local spinConnection = nil
local flyConnection = nil
local isFlying = false

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 580)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(150, 150, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 55)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
TitleLabel.BackgroundTransparency = 0.3
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "создатель тролль-чита Gregoo"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 3)
Line.Position = UDim2.new(0, 0, 0, 55)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 25
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    StopSpin()
    StopFly()
end)

-- ====================================================
-- 2. СИСТЕМА КЛЮЧА ДЛЯ ОТБРАСЫВАНИЯ
-- ====================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, -40, 0, 90)
KeyFrame.Position = UDim2.new(0, 20, 0, 70)
KeyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
KeyFrame.BackgroundTransparency = 0.2
KeyFrame.BorderSizePixel = 1
KeyFrame.BorderColor3 = Color3.fromRGB(200, 200, 255)
local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame
KeyFrame.Parent = MainFrame

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, 0, 0, 25)
KeyLabel.Position = UDim2.new(0, 0, 0, 5)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "🔑 Введите ключ для разблокировки читов:"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 16
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.Parent = KeyFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.55, 0, 0, 35)
KeyBox.Position = UDim2.new(0, 10, 0, 35)
KeyBox.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Text = "Введите ключ..."
KeyBox.TextSize = 18
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.BorderSizePixel = 1
KeyBox.BorderColor3 = Color3.fromRGB(100, 100, 200)
local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = KeyBox
KeyBox.Parent = KeyFrame

local UnlockButton = Instance.new("TextButton")
UnlockButton.Size = UDim2.new(0.25, 0, 0, 35)
UnlockButton.Position = UDim2.new(0.7, 5, 0, 35)
UnlockButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
UnlockButton.Text = "✅ Войти"
UnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockButton.TextSize = 18
UnlockButton.Font = Enum.Font.GothamBold
UnlockButton.BorderSizePixel = 0
local UnlockCorner = Instance.new("UICorner")
UnlockCorner.CornerRadius = UDim.new(0, 6)
UnlockCorner.Parent = UnlockButton
UnlockButton.Parent = KeyFrame

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, 0, 0, 25)
ErrorLabel.Position = UDim2.new(0, 0, 0, 72)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
ErrorLabel.TextSize = 15
ErrorLabel.Font = Enum.Font.GothamBold
ErrorLabel.Parent = KeyFrame

-- ====================================================
-- 3. PREMIUM КНОПКА (ключ 67 для полёта)
-- ====================================================
local PremiumFrame = Instance.new("Frame")
PremiumFrame.Size = UDim2.new(1, -40, 0, 90)
PremiumFrame.Position = UDim2.new(0, 20, 0, 175)
PremiumFrame.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
PremiumFrame.BackgroundTransparency = 0.3
PremiumFrame.BorderSizePixel = 2
PremiumFrame.BorderColor3 = Color3.fromRGB(255, 200, 0)
local PremiumCorner = Instance.new("UICorner")
PremiumCorner.CornerRadius = UDim.new(0, 10)
PremiumCorner.Parent = PremiumFrame
PremiumFrame.Parent = MainFrame

local PremiumLabel = Instance.new("TextLabel")
PremiumLabel.Size = UDim2.new(1, 0, 0, 25)
PremiumLabel.Position = UDim2.new(0, 0, 0, 5)
PremiumLabel.BackgroundTransparency = 1
PremiumLabel.Text = "⭐ PREMIUM (Полёт) ⭐"
PremiumLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
PremiumLabel.TextSize = 20
PremiumLabel.Font = Enum.Font.GothamBold
PremiumLabel.Parent = PremiumFrame

local PremiumKeyBox = Instance.new("TextBox")
PremiumKeyBox.Size = UDim2.new(0.55, 0, 0, 35)
PremiumKeyBox.Position = UDim2.new(0, 10, 0, 35)
PremiumKeyBox.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
PremiumKeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PremiumKeyBox.Text = "Введите PREMIUM ключ..."
PremiumKeyBox.TextSize = 18
PremiumKeyBox.Font = Enum.Font.Gotham
PremiumKeyBox.ClearTextOnFocus = false
PremiumKeyBox.BorderSizePixel = 1
PremiumKeyBox.BorderColor3 = Color3.fromRGB(255, 200, 0)
local PremBoxCorner = Instance.new("UICorner")
PremBoxCorner.CornerRadius = UDim.new(0, 6)
PremBoxCorner.Parent = PremiumKeyBox
PremiumKeyBox.Parent = PremiumFrame

local PremiumUnlockButton = Instance.new("TextButton")
PremiumUnlockButton.Size = UDim2.new(0.25, 0, 0, 35)
PremiumUnlockButton.Position = UDim2.new(0.7, 5, 0, 35)
PremiumUnlockButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
PremiumUnlockButton.Text = "💎 Активировать"
PremiumUnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PremiumUnlockButton.TextSize = 16
PremiumUnlockButton.Font = Enum.Font.GothamBold
PremiumUnlockButton.BorderSizePixel = 0
local PremUnlockCorner = Instance.new("UICorner")
PremUnlockCorner.CornerRadius = UDim.new(0, 6)
PremUnlockCorner.Parent = PremiumUnlockButton
PremiumUnlockButton.Parent = PremiumFrame

local PremiumErrorLabel = Instance.new("TextLabel")
PremiumErrorLabel.Size = UDim2.new(1, 0, 0, 25)
PremiumErrorLabel.Position = UDim2.new(0, 0, 0, 72)
PremiumErrorLabel.BackgroundTransparency = 1
PremiumErrorLabel.Text = ""
PremiumErrorLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
PremiumErrorLabel.TextSize = 15
PremiumErrorLabel.Font = Enum.Font.GothamBold
PremiumErrorLabel.Parent = PremiumFrame

-- ====================================================
-- 4. ОСНОВНЫЕ КНОПКИ (появляются после ключа)
-- ====================================================
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 0, 200)
ButtonContainer.Position = UDim2.new(0, 20, 0, 280)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Visible = false
ButtonContainer.Parent = MainFrame

local ButtonNames = {"🌀 Крутить + Откидывать", "⚡ Супер-удар", "💥 Мега-волна", "🔄 Только крутить"}
local ButtonColors = {
    Color3.fromRGB(255, 80, 255),  -- Розовый
    Color3.fromRGB(80, 200, 255),  -- Голубой
    Color3.fromRGB(80, 255, 120),  -- Зеленый
    Color3.fromRGB(255, 200, 80)   -- Оранжевый
}

function ShowButtons()
    ButtonContainer.Visible = true
    if #ButtonContainer:GetChildren() == 0 then
        for i = 1, 4 do
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 45)
            Button.Position = UDim2.new(0, 0, 0, (i-1) * 50)
            Button.BackgroundColor3 = ButtonColors[i]
            Button.Text = ButtonNames[i]
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 18
            Button.Font = Enum.Font.GothamBold
            Button.BorderSizePixel = 0
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            Button.BackgroundTransparency = 0.2
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundTransparency = 0.05
                Button.Size = UDim2.new(1, 5, 0, 48)
            end)
            Button.MouseLeave:Connect(function()
                Button.BackgroundTransparency = 0.2
                Button.Size = UDim2.new(1, 0, 0, 45)
            end)
            
            Button.MouseButton1Click:Connect(function()
                if not Unlocked then return end
                
                if i == 1 then
                    StartSpinWithPush(PUSH_FORCE * 1.2)
                elseif i == 2 then
                    StartSpinWithPush(PUSH_FORCE * 2.0)
                elseif i == 3 then
                    StartSpinWithPush(PUSH_FORCE * 3.0)
                elseif i == 4 then
                    StartSpinOnly()
                end
            end)
            
            Button.Parent = ButtonContainer
        end
    end
end

-- ====================================================
-- 5. ФУНКЦИИ КРУЧЕНИЯ И ОТБРАСЫВАНИЯ
-- ====================================================
function StartSpinWithPush(force)
    if isSpinning then return end
    isSpinning = true
    
    -- Включаем кручение
    spinConnection = RunService.Heartbeat:Connect(function()
        if not RootPart or not RootPart.Parent then
            StopSpin()
            return
        end
        -- Поворачиваем персонажа
        local currentCFrame = RootPart.CFrame
        local newCFrame = currentCFrame * CFrame.Angles(0, SPIN_SPEED * 0.1, 0)
        RootPart.CFrame = newCFrame
    end)
    
    -- Отбрасываем игроков каждые 0.3 сек
    local pushTimer = 0
    local pushConnection = RunService.Heartbeat:Connect(function(dt)
        pushTimer = pushTimer + dt
        if pushTimer >= 0.3 then
            pushTimer = 0
            PushPlayers(force)
        end
    end)
    
    -- Сохраняем ссылку для остановки
    spinConnection = {spinConnection, pushConnection}
end

function StartSpinOnly()
    if isSpinning then 
        StopSpin()
        return
    end
    isSpinning = true
    
    spinConnection = RunService.Heartbeat:Connect(function()
        if not RootPart or not RootPart.Parent then
            StopSpin()
            return
        end
        local currentCFrame = RootPart.CFrame
        local newCFrame = currentCFrame * CFrame.Angles(0, SPIN_SPEED * 0.12, 0)
        RootPart.CFrame = newCFrame
    end)
end

function StopSpin()
    isSpinning = false
    if spinConnection then
        if type(spinConnection) == "table" then
            for _, conn in pairs(spinConnection) do
                if conn and conn.Disconnect then conn:Disconnect() end
            end
        elseif spinConnection.Disconnect then
            spinConnection:Disconnect()
        end
        spinConnection = nil
    end
end

function PushPlayers(force)
    if not Unlocked then return end
    
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (RootPart.Position - otherRoot.Position).Magnitude
                    if dist <= PUSH_RADIUS then
                        local direction = (otherRoot.Position - RootPart.Position).Unit
                        local upForce = Vector3.new(0, 2.5, 0)
                        
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bodyVelocity.Velocity = (direction * force) + (upForce * force * 0.5)
                        bodyVelocity.Parent = otherRoot
                        
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.6)
                    end
                end
            end
        end
    end
end

-- ====================================================
-- 6. PREMIUM: ПОЛЁТ
-- ====================================================
function StartFly()
    if isFlying then return end
    if not PremiumUnlocked then
        PremiumErrorLabel.Text = "❌ Сначала активируйте PREMIUM ключом!"
        PremiumErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        return
    end
    
    isFlying = true
    local bodyGyro = Instance.new("BodyGyro")
    local bodyVelocity = Instance.new("BodyVelocity")
    
    bodyGyro.P = 1e6
    bodyGyro.D = 500
    bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bodyGyro.CFrame = RootPart.CFrame
    bodyGyro.Parent = RootPart
    
    bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = RootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not RootPart or not RootPart.Parent then
            StopFly()
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        -- WASD + Пробел + Shift
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + RootPart.CFrame.LookVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - RootPart.CFrame.LookVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - RootPart.CFrame.RightVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + RootPart.CFrame.RightVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 50, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 50, 0)
        end
        
        bodyVelocity.Velocity = moveDirection
        bodyGyro.CFrame = RootPart.CFrame
    end)
end

function StopFly()
    isFlying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    for _, v in pairs(RootPart:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
            v:Destroy()
        end
    end
end

-- ====================================================
-- 7. ОБРАБОТЧИКИ КНОПОК
-- ====================================================

-- Обычный ключ (Gr12)
UnlockButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == "Gr12" then
        Unlocked = true
        ErrorLabel.Text = "✅ Читы разблокированы!"
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        KeyFrame.Visible = false
        ShowButtons()
    else
        ErrorLabel.Text = "❌ НЕВЕРНЫЙ КЛЮЧ!"
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        KeyBox.Text = ""
    end
end)

-- PREMIUM ключ (67)
PremiumUnlockButton.MouseButton1Click:Connect(function()
    if PremiumKeyBox.Text == "67" then
        PremiumUnlocked = true
        PremiumErrorLabel.Text = "⭐ PREMIUM АКТИВИРОВАН! Нажми 'P' для полёта"
        PremiumErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        PremiumFrame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        PremiumFrame.BackgroundTransparency = 0.3
        PremiumKeyBox.Text = "✅ Активировано!"
        PremiumKeyBox.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        PremiumErrorLabel.Text = "❌ Неверный PREMIUM ключ! (подсказка: 67)"
        PremiumErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        PremiumKeyBox.Text = ""
    end
end)

-- ====================================================
-- 8. КЛАВИШИ
-- ====================================================
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    
    -- E = откинуть (если разблокировано)
    if input.KeyCode == Enum.KeyCode.E and Unlocked then
        PushPlayers(PUSH_FORCE)
    end
    
    -- P = включить/выключить полёт (PREMIUM)
    if input.KeyCode == Enum.KeyCode.P then
        if PremiumUnlocked then
            if isFlying then
                StopFly()
                PremiumErrorLabel.Text = "✈️ Полёт выключен"
                PremiumErrorLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            else
                StartFly()
                PremiumErrorLabel.Text = "✈️ Полёт включён (WASD/Пробел/Shift)"
                PremiumErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            end
        else
            PremiumErrorLabel.Text = "❌ Активируйте PREMIUM ключом!"
            PremiumErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    
    -- X = остановить кручение
    if input.KeyCode == Enum.KeyCode.X then
        StopSpin()
    end
end)

-- ====================================================
-- 9. ОБНОВЛЕНИЕ ПЕРСОНАЖА
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    StopSpin()
    StopFly()
end)

print("✅ Gregoo Troll v3.0 загружен!")
print("🔑 Ключ читов: Gr12")
print("⭐ PREMIUM ключ: 67 (для полёта)")
print("🔄 E - откинуть | P - полёт (PREMIUM) | X - остановить кручение")
