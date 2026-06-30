-- [[ СКРИПТ С ГРАФИЧЕСКИМ МЕНЮ ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- [[ НАСТРОЙКИ ПО УМОЛЧАНИЮ ]] --
local Settings = {
    Enabled = false,
    PushForce = 50,
    Range = 15
}

-- [[ СОЗДАНИЕ ГЛАВНОГО МЕНЮ ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PushMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Фон меню (главное окно)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Размытый фон (эффект стекла)
local Blur = Instance.new("Frame")
Blur.Size = UDim2.new(1, 0, 1, 0)
Blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Blur.BackgroundTransparency = 0.45
Blur.BorderSizePixel = 0
Blur.Parent = MainFrame

-- Заголовок с именем
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 50)
TitleFrame.BackgroundColor3 = Color3.fromRGB(45, 25, 65)
TitleFrame.BackgroundTransparency = 0.3
TitleFrame.BorderSizePixel = 0
TitleFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Created Gergoo"
TitleLabel.TextColor3 = Color3.fromRGB(210, 180, 255)
TitleLabel.TextScaled = false
TitleLabel.TextSize = 24
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.TextStrokeTransparency = 0.3
TitleLabel.Parent = TitleFrame

-- Декоративная линия под заголовком
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0.9, 0, 0, 2)
Line.Position = UDim2.new(0.05, 0, 1, -2)
Line.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
Line.BackgroundTransparency = 0.4
Line.BorderSizePixel = 0
Line.Parent = TitleFrame

-- Контейнер для элементов
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- [[ КНОПКА ВКЛЮЧЕНИЯ ]] --
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 50)
ToggleButton.Position = UDim2.new(0, 0, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "🔘 ВЫКЛЮЧЕНО"
ToggleButton.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Parent = ContentFrame

-- Скругление кнопки
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

-- [[ ПОЛЗУНКИ ДЛЯ НАСТРОЕК ]] --
-- Сила отталкивания
local ForceLabel = Instance.new("TextLabel")
ForceLabel.Size = UDim2.new(1, 0, 0, 25)
ForceLabel.Position = UDim2.new(0, 0, 0, 80)
ForceLabel.BackgroundTransparency = 1
ForceLabel.Text = "💥 Сила: " .. Settings.PushForce
ForceLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
ForceLabel.TextSize = 17
ForceLabel.TextXAlignment = Enum.TextXAlignment.Left
ForceLabel.Font = Enum.Font.Gotham
ForceLabel.Parent = ContentFrame

local ForceSlider = Instance.new("TextBox")
ForceSlider.Size = UDim2.new(1, 0, 0, 30)
ForceSlider.Position = UDim2.new(0, 0, 0, 108)
ForceSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
ForceSlider.BackgroundTransparency = 0.3
ForceSlider.BorderSizePixel = 0
ForceSlider.Text = tostring(Settings.PushForce)
ForceSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
ForceSlider.TextSize = 18
ForceSlider.Font = Enum.Font.Gotham
ForceSlider.Parent = ContentFrame

local Corner2 = Instance.new("UICorner")
Corner2.CornerRadius = UDim.new(0, 6)
Corner2.Parent = ForceSlider

-- Радиус действия
local RangeLabel = Instance.new("TextLabel")
RangeLabel.Size = UDim2.new(1, 0, 0, 25)
RangeLabel.Position = UDim2.new(0, 0, 0, 158)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "📏 Радиус: " .. Settings.Range
RangeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
RangeLabel.TextSize = 17
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.Font = Enum.Font.Gotham
RangeLabel.Parent = ContentFrame

local RangeSlider = Instance.new("TextBox")
RangeSlider.Size = UDim2.new(1, 0, 0, 30)
RangeSlider.Position = UDim2.new(0, 0, 0, 186)
RangeSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
RangeSlider.BackgroundTransparency = 0.3
RangeSlider.BorderSizePixel = 0
RangeSlider.Text = tostring(Settings.Range)
RangeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeSlider.TextSize = 18
RangeSlider.Font = Enum.Font.Gotham
RangeSlider.Parent = ContentFrame

local Corner3 = Instance.new("UICorner")
Corner3.CornerRadius = UDim.new(0, 6)
Corner3.Parent = RangeSlider

-- [[ ОБРАБОТЧИКИ КНОПОК ]] --
-- Включение/выключение
ToggleButton.MouseButton1Click:Connect(function()
    Settings.Enabled = not Settings.Enabled
    ToggleButton.Text = Settings.Enabled and "✅ ВКЛЮЧЕНО" or "🔘 ВЫКЛЮЧЕНО"
    ToggleButton.TextColor3 = Settings.Enabled and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    ToggleButton.BackgroundColor3 = Settings.Enabled and Color3.fromRGB(30, 80, 40) or Color3.fromRGB(60, 40, 80)
    
    LocalPlayer:Chat(Settings.Enabled and "[ВКЛ] Отбрасывание" or "[ВЫКЛ] Отбрасывание")
end)

-- Изменение силы
ForceSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(ForceSlider.Text)
        if num and num >= 1 and num <= 200 then
            Settings.PushForce = math.floor(num)
            ForceLabel.Text = "💥 Сила: " .. Settings.PushForce
            ForceSlider.Text = tostring(Settings.PushForce)
        else
            ForceSlider.Text = tostring(Settings.PushForce)
            ForceLabel.Text = "💥 Сила: " .. Settings.PushForce
        end
    end
end)

-- Изменение радиуса
RangeSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(RangeSlider.Text)
        if num and num >= 1 and num <= 100 then
            Settings.Range = math.floor(num)
            RangeLabel.Text = "📏 Радиус: " .. Settings.Range
            RangeSlider.Text = tostring(Settings.Range)
        else
            RangeSlider.Text = tostring(Settings.Range)
            RangeLabel.Text = "📏 Радиус: " .. Settings.Range
        end
    end
end)

-- [[ ОСНОВНАЯ ЛОГИКА ОТБРАСЫВАНИЯ ]] --
local function PushPlayers()
    if not Settings.Enabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local targetChar = player.Character
            if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                local targetPart = targetChar.HumanoidRootPart
                local distance = (HumanoidRootPart.Position - targetPart.Position).Magnitude
                
                if distance <= Settings.Range then
                    local direction = (targetPart.Position - HumanoidRootPart.Position).Unit
                    targetPart.Velocity = Vector3.new(0, 15, 0) + direction * Settings.PushForce
                end
            end
        end
    end
end

-- Запуск основного цикла
RunService.Heartbeat:Connect(PushPlayers)

print("✅ Скрипт 'Created Gergoo' загружен! Меню открыто.")
