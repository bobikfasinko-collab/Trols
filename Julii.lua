--[[
  СКРИПТ: Troll Push + Мобильный полёт + Авто-Fling
  Создатель: Gregoo
  Версия: 4.0 FULL (Mobile Ready)
--]]

if getgenv().TrollGUI then return end
getgenv().TrollGUI = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ====================================================
-- НАСТРОЙКИ
-- ====================================================
local PUSH_FORCE = 6000
local PUSH_RADIUS = 18
local SPIN_SPEED = 2.5
local FLING_RADIUS = 12
local FLING_FORCE = 8000

-- ====================================================
-- ПЕРЕМЕННЫЕ
-- ====================================================
local Unlocked = false
local PremiumUnlocked = false
local isSpinning = false
local spinConnection = nil
local flyConnection = nil
local isFlying = false
local flingActive = false
local flingConnection = nil
local menuVisible = true

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 700)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -350)
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

-- Кнопка закрытия (крестик)
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
    menuVisible = false
    MainFrame.Visible = false
    StopSpin()
    StopFly()
end)

-- ====================================================
-- 2. КНОПКА ПОКАЗА МЕНЮ (всегда в углу)
-- ====================================================
local ShowMenuButton = Instance.new("TextButton")
ShowMenuButton.Size = UDim2.new(0, 60, 0, 60)
ShowMenuButton.Position = UDim2.new(0, 10, 0, 10)
ShowMenuButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ShowMenuButton.Text = "📋"
ShowMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowMenuButton.TextSize = 30
ShowMenuButton.Font = Enum.Font.GothamBold
ShowMenuButton.BorderSizePixel = 2
ShowMenuButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowMenuButton
ShowMenuButton.Parent = ScreenGui

ShowMenuButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    if menuVisible then
        ShowMenuButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        ShowMenuButton.Text = "📋"
    else
        ShowMenuButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ShowMenuButton.Text = "📌"
    end
end)

-- ====================================================
-- 3. СИСТЕМА КЛЮЧА
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
KeyLabel.Text = "🔑 Введите ключ для разблокировки:"
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
-- 4. PREMIUM КНОПКА
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
-- 5. КНОПКИ (появляются после ключа)
-- ====================================================
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 0, 320)
ButtonContainer.Position = UDim2.new(0, 20, 0, 280)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Visible = false
ButtonContainer.Parent = MainFrame

local ButtonNames = {
    "🌀 Крутить + Откидывать",
    "⚡ Супер-удар",
    "💥 Мега-волна",
    "🔄 Только крутить",
    "💢 АВТО-FLING (вкл/выкл)"
}
local ButtonColors = {
    Color3.fromRGB(255, 80, 255),
    Color3.fromRGB(80, 200, 255),
    Color3.fromRGB(80, 255, 120),
    Color3.fromRGB(255, 200, 80),
    Color3.fromRGB(255, 50, 50)
}

function ShowButtons()
    ButtonContainer.Visible = true
    if #ButtonContainer:GetChildren() == 0 then
        for i = 1, 5 do
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 48)
            Button.Position = UDim2.new(0, 0, 0, (i-1) * 53)
            Button.BackgroundColor3 = ButtonColors[i]
            Button.Text = ButtonNames[i]
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 16
            Button.Font = Enum.Font.GothamBold
            Button.BorderSizePixel = 0
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            Button.BackgroundTransparency = 0.2
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundTransparency = 0.05
                Button.Size = UDim2.new(1, 5, 0, 51)
            end)
            Button.MouseLeave:Connect(function()
                Button.BackgroundTransparency = 0.2
                Button.Size = UDim2.new(1, 0, 0, 48)
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
                elseif i == 5 then
                    ToggleFling()
                end
            end)
            
            Button.Parent = ButtonContainer
        end
    end
end

-- ====================================================
-- 6. ФУНКЦИИ КРУЧЕНИЯ
-- ====================================================
function StartSpinWithPush(force)
    if isSpinning then return end
    isSpinning = true
    
    spinConnection = RunService.Heartbeat:Connect(function()
        if not RootPart or not RootPart.Parent then
            StopSpin()
            return
        end
        local currentCFrame = RootPart.CFrame
        local newCFrame = currentCFrame * CFrame.Angles(0, SPIN_SPEED * 0.1, 0)
        RootPart.CFrame = newCFrame
    end)
    
    local pushTimer = 0
    local pushConnection = RunService.Heartbeat:Connect(function(dt)
        pushTimer = pushTimer + dt
        if pushTimer >= 0.3 then
            pushTimer = 0
            PushPlayers(force)
        end
    end)
    
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

-- ====================================================
-- 7. ФУНКЦИЯ ОТБРАСЫВАНИЯ
-- ====================================================
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
-- 8. АВТО-FLING
-- ====================================================
function ToggleFling()
    if not Unlocked then return end
    flingActive = not flingActive
    
    if flingActive then
        flingConnection = RunService.Heartbeat:Connect(function()
            if not flingActive then return end
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
                            if dist <= FLING_RADIUS then
                                local direction = (otherRoot.Position - RootPart.Position).Unit
                                local upForce = Vector3.new(0, 3.0, 0)
                                
                                local bodyVelocity = Instance.new("BodyVelocity")
                                bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                                bodyVelocity.Velocity = (direction * FLING_FORCE) + (upForce * FLING_FORCE * 0.6)
                                bodyVelocity.Parent = otherRoot
                                
                                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
                            end
                        end
                    end
                end
            end
        end)
        
        for _, btn in pairs(ButtonContainer:GetChildren()) do
            if btn:IsA("TextButton") and btn.Text == "💢 АВТО-FLING (вкл/выкл)" then
                btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                btn.Text = "💢 АВТО-FLING ВКЛЮЧЁН"
            end
        end
    else
        if flingConnection then
            flingConnection:Disconnect()
            flingConnection = nil
        end
        for _, btn in pairs(ButtonContainer:GetChildren()) do
            if btn:IsA("TextButton") and btn.Text == "💢 АВТО-FLING ВКЛЮЧЁН" then
                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                btn.Text = "💢 АВТО-FLING (вкл/выкл)"
            end
        end
    end
end

-- ====================================================
-- 9. МОБИЛЬНЫЙ ПОЛЁТ (джойстик + кнопки)
-- ====================================================
local FlyJoystick = nil
local FlyUpButton = nil
local FlyDownButton = nil
local joystickOffset = Vector2.new(0, 0)

function CreateFlyControls()
    if FlyJoystick then return end
    
    local FlyContainer = Instance.new("Frame")
    FlyContainer.Size = UDim2.new(0, 200, 0, 200)
    FlyContainer.Position = UDim2.new(0, 10, 1, -220)
    FlyContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FlyContainer.BackgroundTransparency = 0.8
    FlyContainer.BorderSizePixel = 2
    FlyContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local FlyCorner = Instance.new("UICorner")
    FlyCorner.CornerRadius = UDim.new(1, 0)
    FlyCorner.Parent = FlyContainer
    FlyContainer.Parent = ScreenGui
    FlyContainer.Visible = false
    
    local JoystickBase = Instance.new("Frame")
    JoystickBase.Size = UDim2.new(0, 120, 0, 120)
    JoystickBase.Position = UDim2.new(0.5, -60, 0.5, -60)
    JoystickBase.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    JoystickBase.BackgroundTransparency = 0.5
    JoystickBase.BorderSizePixel = 2
    JoystickBase.BorderColor3 = Color3.fromRGB(200, 200, 255)
    local JoyCorner = Instance.new("UICorner")
    JoyCorner.CornerRadius = UDim.new(1, 0)
    JoyCorner.Parent = JoystickBase
    JoystickBase.Parent = FlyContainer
    
    local JoystickKnob = Instance.new("Frame")
    JoystickKnob.Size = UDim2.new(0, 40, 0, 40)
    JoystickKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
    JoystickKnob.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    JoystickKnob.BackgroundTransparency = 0.3
    JoystickKnob.BorderSizePixel = 2
    JoystickKnob.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = JoystickKnob
    JoystickKnob.Parent = JoystickBase
    
    FlyUpButton = Instance.new("TextButton")
    FlyUpButton.Size = UDim2.new(0, 60, 0, 60)
    FlyUpB
