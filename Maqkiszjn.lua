-- ============================================
-- ROBLOX SPEED HACK PANEL v2.0
-- С RGB подсветкой и управлением скоростью
-- Работает на телефонах и ПК
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ============================================
-- СОЗДАНИЕ GUI (Графический интерфейс)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedPanel"
ScreenGui.Parent = Player.PlayerGui

-- ============================================
-- ОСНОВНОЕ ОКНО (панель)
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Скругление углов
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- ============================================
-- ЗАГОЛОВОК
-- ============================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ SPEED PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- ============================================
-- КНОПКА ЗАКРЫТИЯ/ОТКРЫТИЯ (сворачивание)
-- ============================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 35, 0, 35)
ToggleButton.Position = UDim2.new(1, -45, 0, 2.5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
ToggleButton.Text = "✕"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = TitleBar

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

-- ============================================
-- КНОПКА ВКЛ/ВЫКЛ СПИДХАКА
-- ============================================

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Size = UDim2.new(0, 120, 0, 45)
SpeedToggle.Position = UDim2.new(0, 15, 0, 60)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
SpeedToggle.Text = "🟢 ВКЛ"
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.TextSize = 18
SpeedToggle.Font = Enum.Font.GothamBold
SpeedToggle.BorderSizePixel = 0
SpeedToggle.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedToggle

-- ============================================
-- ТЕКУЩАЯ СКОРОСТЬ (дисплей)
-- ============================================

local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Size = UDim2.new(0, 180, 0, 45)
SpeedDisplay.Position = UDim2.new(1, -195, 0, 60)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SpeedDisplay.BackgroundTransparency = 0.3
SpeedDisplay.Text = "Скорость: 16"
SpeedDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedDisplay.TextSize = 20
SpeedDisplay.Font = Enum.Font.GothamBold
SpeedDisplay.BorderSizePixel = 1
SpeedDisplay.BorderColor3 = Color3.fromRGB(80, 80, 150)
SpeedDisplay.Parent = MainFrame

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 8)
DisplayCorner.Parent = SpeedDisplay

-- ============================================
-- ПОЛЗУНОК СКОРОСТИ (Slider)
-- ============================================

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(0, 320, 0, 40)
SpeedSlider.Position = UDim2.new(0, 15, 0, 125)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedSlider.BackgroundTransparency = 0.5
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = MainFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 8)
SliderCorner.Parent = SpeedSlider

-- Фон ползунка
local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.9, 0, 0, 8)
SliderBar.Position = UDim2.new(0.05, 0, 0.5, -4)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SpeedSlider

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = SliderBar

-- Заполнение ползунка
local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

-- Круглая ручка
local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 25, 0, 25)
SliderKnob.Position = UDim2.new(0.5, -12.5, 0.5, -12.5)
SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderKnob.Text = ""
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SpeedSlider

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SliderKnob

-- ============================================
-- ОТОБРАЖЕНИЕ МИНИМУМА/МАКСИМУМА
-- ============================================

local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(0, 30, 0, 20)
MinLabel.Position = UDim2.new(0, 5, 0, 15)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "1"
MinLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
MinLabel.TextSize = 14
MinLabel.Font = Enum.Font.Gotham
MinLabel.Parent = SpeedSlider

local MaxLabel = Instance.new("TextLabel")
MaxLabel.Size = UDim2.new(0, 40, 0, 20)
MaxLabel.Position = UDim2.new(1, -40, 0, 15)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Text = "1000"
MaxLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
MaxLabel.TextSize = 14
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.Parent = SpeedSlider

-- ============================================
-- КНОПКА СБРОСА (Reset)
-- ============================================

local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.new(0, 320, 0, 40)
ResetButton.Position = UDim2.new(0, 15, 0, 185)
ResetButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
ResetButton.Text = "🔄 СБРОСИТЬ (16)"
ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetButton.TextSize = 18
ResetButton.Font = Enum.Font.GothamBold
ResetButton.BorderSizePixel = 0
ResetButton.Parent = MainFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 8)
ResetCorner.Parent = ResetButton

-- ============================================
-- RGB ПОДСВЕТКА (для фона)
-- ============================================

local RGBFrame = Instance.new("Frame")
RGBFrame.Size = UDim2.new(0, 320, 0, 120)
RGBFrame.Position = UDim2.new(0, 15, 0, 245)
RGBFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
RGBFrame.BackgroundTransparency = 0.5
RGBFrame.BorderSizePixel = 1
RGBFrame.BorderColor3 = Color3.fromRGB(80, 80, 150)
RGBFrame.Parent = MainFrame

local RGBCorner = Instance.new("UICorner")
RGBCorner.CornerRadius = UDim.new(0, 8)
RGBCorner.Parent = RGBFrame

-- Заголовок RGB
local RGBLabel = Instance.new("TextLabel")
RGBLabel.Size = UDim2.new(1, 0, 0, 30)
RGBLabel.Position = UDim2.new(0, 0, 0, 5)
RGBLabel.BackgroundTransparency = 1
RGBLabel.Text = "🌈 RGB ПОДСВЕТКА"
RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBLabel.TextSize = 16
RGBLabel.Font = Enum.Font.GothamBold
RGBLabel.Parent = RGBFrame

-- RGB Кнопка включения
local RGBToggle = Instance.new("TextButton")
RGBToggle.Size = UDim2.new(0, 140, 0, 40)
RGBToggle.Position = UDim2.new(0, 10, 0, 40)
RGBToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
RGBToggle.Text = "🟢 ВКЛ"
RGBToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBToggle.TextSize = 16
RGBToggle.Font = Enum.Font.GothamBold
RGBToggle.BorderSizePixel = 0
RGBToggle.Parent = RGBFrame

local RGBToggleCorner = Instance.new("UICorner")
RGBToggleCorner.CornerRadius = UDim.new(0, 8)
RGBToggleCorner.Parent = RGBToggle

-- RGB Кнопка выключения
local RGBOff = Instance.new("TextButton")
RGBOff.Size = UDim2.new(0, 140, 0, 40)
RGBOff.Position = UDim2.new(1, -150, 0, 40)
RGBOff.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
RGBOff.Text = "🔴 ВЫКЛ"
RGBOff.TextColor3 = Color3.fromRGB(255, 255, 255)
RGBOff.TextSize = 16
RGBOff.Font = Enum.Font.GothamBold
RGBOff.BorderSizePixel = 0
RGBOff.Parent = RGBFrame

local RGBOffCorner = Instance.new("UICorner")
RGBOffCorner.CornerRadius = UDim.new(0, 8)
RGBOffCorner.Parent = RGBOff

-- Индикатор RGB цвета (кружок)
local RGBIndicator = Instance.new("Frame")
RGBIndicator.Size = UDim2.new(0, 50, 0, 50)
RGBIndicator.Position = UDim2.new(0.5, -25, 1, -60)
RGBIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
RGBIndicator.BorderSizePixel = 2
RGBIndicator.BorderColor3 = Color3.fromRGB(255, 255, 255)
RGBIndicator.Parent = RGBFrame

local IndicatorCorner = Instance.new("UICorner")
IndicatorCorner.CornerRadius = UDim.new(1, 0)
IndicatorCorner.Parent = RGBIndicator

-- ============================================
-- КНОПКА ПОКАЗАТЬ/СКРЫТЬ (ПЛАВАЮЩАЯ)
-- ============================================

local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 60, 0, 60)
ShowButton.Position = UDim2.new(0, 20, 1, -80)
ShowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
ShowButton.Text = "⚡"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 30
ShowButton.Font = Enum.Font.GothamBold
ShowButton.BorderSizePixel = 2
ShowButton.BorderColor3 = Color3.fromRGB(100, 100, 255)
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowButton

-- ============================================
-- ПЕРЕМЕННЫЕ ДЛЯ ЛОГИКИ
-- ============================================

local speedEnabled = false
local currentSpeed = 16
local rgbEnabled = false
local rgbConnection = nil
local panelVisible = true

-- ============================================
-- ФУНКЦИЯ ОБНОВЛЕНИЯ СКОРОСТИ
-- ============================================

local function updateSpeed(value)
    currentSpeed = math.floor(value)
    SpeedDisplay.Text = "Скорость: " .. currentSpeed
    SliderFill.Size = UDim2.new((currentSpeed - 1) / 999, 0, 1, 0)
    SliderKnob.Position = UDim2.new((currentSpeed - 1) / 999, -12.5, 0.5, -12.5)
    
    if speedEnabled then
        Humanoid.WalkSpeed = currentSpeed
    end
end

-- ============================================
-- ФУНКЦИЯ RGB ПОДСВЕТКИ
-- ============================================

local function startRGB()
    if rgbConnection then
        rgbConnection:Disconnect()
        rgbConnection = nil
    end
    
    rgbConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local hue = tick() % 1
        local color = Color3.fromHSV(hue, 1, 1)
        
        MainFrame.BorderColor3 = color
        SpeedToggle.BackgroundColor3 = color
        SliderFill.BackgroundColor3 = color
        SliderKnob.BackgroundColor3 = color
        RGBIndicator.BackgroundColor3 = color
        ResetButton.BackgroundColor3 = color
        
        -- Меняем цвет текста кнопок
        SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

local function stopRGB()
    if rgbConnection then
        rgbConnection:Disconnect()
        rgbConnection = nil
    end
    
    -- Возвращаем стандартные цвета
    MainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
    SpeedToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    RGBIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ResetButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
end

-- ============================================
-- ОБРАБОТЧИКИ КНОПОК
-- ============================================

-- Включение/выключение скорости
SpeedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        SpeedToggle.Text = "🔴 ВЫКЛ"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        Humanoid.WalkSpeed = currentSpeed
        print("Speed HACK ВКЛЮЧЕН: " .. currentSpeed)
    else
        SpeedToggle.Text = "🟢 ВКЛ"
        SpeedToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        Humanoid.WalkSpeed = 16
        print("Speed HACK ВЫКЛЮЧЕН")
    end
end)

-- Ползунок (перетаскивание)
SliderKnob.MouseButton1Down:Connect(function()
    local dragging = true
    local mouse = Player:GetMouse()
    
    local function update()
        if not dragging then return end
        local relativeX = math.clamp((mouse.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
        local speedValue = math.floor(1 + relativeX * 999)
        updateSpeed(speedValue)
    end
    
    local connection1 = mouse.Move:Connect(update)
    local connection2 = mouse.Button1Up:Connect(function()
        dragging = false
        connection1:Disconnect()
        connection2:Disconnect()
    end)
end)

-- Сброс скорости
ResetButton.MouseButton1Click:Connect(function()
    updateSpeed(16)
    if speedEnabled then
        Humanoid.WalkSpeed = 16
    end
    print("Скорость сброшена до 16")
end)

-- RGB Включить
RGBToggle.MouseButton1Click:Connect(function()
    rgbEnabled = true
    RGBToggle.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    RGBOff.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    startRGB()
    print("RGB подсветка ВКЛЮЧЕНА")
end)

-- RGB Выключить
RGBOff.MouseButton1Click:Connect(function()
    rgbEnabled = false
    RGBToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    RGBOff.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    stopRGB()
    print("RGB подсветка ВЫКЛЮЧЕНА")
end)

-- Скрыть панель
ToggleButton.MouseButton1Click:Connect(function()
    panelVisible = false
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

-- Показать панель
ShowButton.MouseButton1Click:Connect(function()
    panelVisible = true
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- ============================================
-- ПЕРЕХВАТ СМЕНЫ ПЕРСОНАЖА
-- ============================================

Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    
    if speedEnabled then
        Humanoid.WalkSpeed = currentSpeed
    end
end)

-- ============================================
-- ИНИЦИАЛИЗАЦИЯ
-- ============================================

updateSpeed(16)
print("⚡ Speed Panel загружен!")
print("✅ Нажмите ✕ в углу чтобы скрыть панель")
print("✅ Кнопка ⚡ покажет панель обратно")
