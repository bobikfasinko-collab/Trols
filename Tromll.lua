--[[
  СКРИПТ: Troll Push + GUI
  Создатель: Gregoo
  Для: Delta Executor / Synapse / Krnl
--]]

-- Проверка, чтобы скрипт не запускался дважды
if getgenv().TrollGUI then return end
getgenv().TrollGUI = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Настройки
local PUSH_FORCE = 5000 -- Сила отбрасывания
local PUSH_RADIUS = 15 -- Радиус действия (в студиях)

-- Блокировка повторного нажатия
local Debounce = false

-- ====================================================
-- 1. СОЗДАНИЕ ГЛАВНОГО МЕНЮ (GUI)
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Фон окна
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true -- Чтобы можно было перетаскивать мышкой
MainFrame.Parent = ScreenGui

-- Углы закругления (эффект Glassmorphism)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Заголовок (Создатель)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TitleLabel.BackgroundTransparency = 0.6
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "создатель тролль-чита Gregoo"
TitleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Линия под заголовком
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 50)
Line.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Кнопка ЗАКРЫТЬ (Крестик)
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

-- Действие для закрытия
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ScreenGui.Enabled = false -- Полностью отключает GUI (можно вернуть через консоль)
end)

-- ====================================================
-- 2. СОЗДАНИЕ РАЗНОЦВЕТНЫХ КНОПОК
-- ====================================================
local ButtonNames = {"🚀 Откинуть", "⚡ Супер-удар", "💥 Мега-волна", "🌀 Торнадо"}
local ButtonColors = {
    Color3.fromRGB(255, 80, 80),   -- Красный
    Color3.fromRGB(80, 200, 255),  -- Голубой
    Color3.fromRGB(80, 255, 120),  -- Зеленый
    Color3.fromRGB(255, 200, 80)   -- Оранжевый
}

-- Контейнер для кнопок (чтобы они не растягивались)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 1, -100)
ButtonContainer.Position = UDim2.new(0, 20, 0, 70)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- Создаем 4 кнопки в столбик (с отступами)
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
    
    -- Закругление кнопок
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    -- Легкая тень (эффект)
    Button.BackgroundTransparency = 0.2
    
    -- Анимация при наведении
    Button.MouseEnter:Connect(function()
        Button.BackgroundTransparency = 0.1
        Button.Size = UDim2.new(1, 5, 0, 65)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundTransparency = 0.2
        Button.Size = UDim2.new(1, 0, 0, 60)
    end)
    
    -- Действие при клике
    Button.MouseButton1Click:Connect(function()
        -- Вызываем функцию толчка с разной силой (для красоты)
        local force = PUSH_FORCE * (1 + (i-1) * 0.5) 
        PushPlayers(force)
    end)
    
    Button.Parent = ButtonContainer
end

-- ====================================================
-- 3. ОСНОВНАЯ ФУНКЦИЯ ОТБРАСЫВАНИЯ
-- ====================================================
function PushPlayers(force)
    if Debounce then return end
    Debounce = true
    
    -- Обновляем персонажа (на случай респавна)
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then Debounce = false return end
    
    -- Ищем всех игроков в радиусе
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= LocalPlayer then
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    -- Проверка расстояния
                    local dist = (RootPart.Position - otherRoot.Position).Magnitude
                    if dist <= PUSH_RADIUS then
                        -- Вектор от нас к игроку (с небольшим подъемом вверх)
                        local direction = (otherRoot.Position - RootPart.Position).Unit
                        local upForce = Vector3.new(0, 1.5, 0) -- Подбрасываем
                        
                        -- Применяем импульс (Velocity)
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bodyVelocity.Velocity = (direction * force) + (upForce * force * 0.5)
                        bodyVelocity.Parent = otherRoot
                        
                        -- Автоудаление через 0.5 сек (чтобы не лагать)
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
                    end
                end
            end
        end
    end
    
    -- Вибрация / Вспышка экрана (эффект)
    RunService.Heartbeat:Wait()
    Debounce = false
end

-- ====================================================
-- 4. УПРАВЛЕНИЕ С КЛАВИАТУРЫ (Кнопка E)
-- ====================================================
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.KeyCode == Enum.KeyCode.E then
        PushPlayers(PUSH_FORCE)
    end
end)

-- ====================================================
-- 5. ПОВТОРНАЯ ПРИВЯЗКА ПРИ РЕСПАВНЕ
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Вывод в консоль (для проверки)
print("✅ Скрипт от Gregoo загружен! Нажми E или кликни по кнопке.")
