--[[
  СКРИПТ: Troll Push + GUI + Ключ
  Создатель: Gregoo
  Версия: 2.0 (Исправленная)
--]]

if getgenv().TrollGUI then return end
getgenv().TrollGUI = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ====================================================
-- НАСТРОЙКИ (можно менять)
-- ====================================================
local PUSH_FORCE = 5000      -- Сила отбрасывания
local PUSH_RADIUS = 15       -- Радиус действия

-- ====================================================
-- 1. ГЛАВНОЕ МЕНЮ (GUI) + БЛОКИРОВКА
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(200, 200, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleLabel.BackgroundTransparency = 0.4
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "создатель тролль-чита Gregoo"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Линия
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 50)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
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
end)

-- ====================================================
-- 2. СИСТЕМА КЛЮЧА
-- ====================================================
local Unlocked = false  -- Заблокировано по умолчанию

-- Панель ввода ключа
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, -40, 0, 80)
KeyFrame.Position = UDim2.new(0, 20, 0, 70)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyFrame.BackgroundTransparency = 0.3
KeyFrame.BorderSizePixel = 1
KeyFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyFrame
KeyFrame.Parent = MainFrame

-- Текст "Введите ключ:"
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, 0, 0, 30)
KeyLabel.Position = UDim2.new(0, 0, 0, 5)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "🔑 Введите ключ для разблокировки:"
KeyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyLabel.TextSize = 18
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.Parent = KeyFrame

-- Поле ввода
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.6, 0, 0, 35)
KeyBox.Position = UDim2.new(0, 10, 0, 35)
KeyBox.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
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

-- Кнопка "Разблокировать"
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

-- Сообщение об ошибке
local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, 0, 0, 25)
ErrorLabel.Position = UDim2.new(0, 0, 0, 72)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
ErrorLabel.TextSize = 16
ErrorLabel.Font = Enum.Font.GothamBold
ErrorLabel.Parent = KeyFrame

-- Действие при нажатии "Войти"
UnlockButton.MouseButton1Click:Connect(function()
    local inputKey = KeyBox.Text
    if inputKey == "Gr12" then
        Unlocked = true
        ErrorLabel.Text = "✅ Ключ принят! Читы разблокированы!"
        ErrorLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        KeyFrame.Visible = false  -- Скрываем панель ввода
        ShowButtons()  -- Показываем кнопки
    else
        ErrorLabel.Text = "❌ НЕВЕРНЫЙ КЛЮЧ! Попробуйте снова."
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        KeyBox.Text = ""
    end
end)

-- ====================================================
-- 3. КНОПКИ (появляются после разблокировки)
-- ====================================================
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 1, -180)
ButtonContainer.Position = UDim2.new(0, 20, 0, 170)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Visible = false  -- Скрыты по умолчанию
ButtonContainer.Parent = MainFrame

local ButtonNames = {"🚀 Откинуть", "⚡ Супер-удар", "💥 Мега-волна", "🌀 Торнадо"}
local ButtonColors = {
    Color3.fromRGB(255, 80, 80),
    Color3.fromRGB(80, 200, 255),
    Color3.fromRGB(80, 255, 120),
    Color3.fromRGB(255, 200, 80)
}

function ShowButtons()
    ButtonContainer.Visible = true
    -- Создаем кнопки, если их еще нет
    if #ButtonContainer:GetChildren() == 0 then
        for i = 1, 4 do
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 60)
            Button.Position = UDim2.new(0, 0, 0, (i-1) * 75)
            Button.BackgroundColor3 = ButtonColors[i]
            Button.Text = ButtonNames[i]
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 22
            Button.Font = Enum.Font.GothamBold
            Button.BorderSizePixel = 0
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            
            Button.BackgroundTransparency = 0.2
            
            Button.MouseEnter:Connect(function()
                Button.BackgroundTransparency = 0.05
                Button.Size = UDim2.new(1, 5, 0, 65)
            end)
            Button.MouseLeave:Connect(function()
                Button.BackgroundTransparency = 0.2
                Button.Size = UDim2.new(1, 0, 0, 60)
            end)
            
            -- КНОПКА -> ОТБРАСЫВАЕМ ИГРОКОВ
            Button.MouseButton1Click:Connect(function()
                if Unlocked then
                    local force = PUSH_FORCE * (1 + (i-1) * 0.5)
                    PushPlayers(force)
                end
            end)
            
            Button.Parent = ButtonContainer
        end
    end
end

-- ====================================================
-- 4. ФУНКЦИЯ ОТБРАСЫВАНИЯ ИГРОКОВ (исправлена!)
-- ====================================================
function PushPlayers(force)
    if not Unlocked then return end  -- Если не разблокировано - не работает
    
    -- Обновляем персонажа
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then  -- ИСКЛЮЧАЕМ СЕБЯ
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local dist = (RootPart.Position - otherRoot.Position).Magnitude
                    if dist <= PUSH_RADIUS then
                        -- Вектор ОТ НАС к игроку (но не трогаем себя)
                        local direction = (otherRoot.Position - RootPart.Position).Unit
                        local upForce = Vector3.new(0, 2.0, 0)  -- Хорошо подбрасываем
                        
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bodyVelocity.Velocity = (direction * force) + (upForce * force * 0.4)
                        bodyVelocity.Parent = otherRoot
                        
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.6)
                    end
                end
            end
        end
    end
end

-- ====================================================
-- 5. КЛАВИША E (работает ТОЛЬКО после разблокировки)
-- ====================================================
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.E and Unlocked then
        PushPlayers(PUSH_FORCE)
    end
end)

-- ====================================================
-- 6. ОБНОВЛЕНИЕ ПЕРСОНАЖА ПРИ РЕСПАВНЕ
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

print("✅ Скрипт Gregoo загружен! Введите ключ 'Gr12' для активации.")
