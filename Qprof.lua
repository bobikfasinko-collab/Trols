-- ============================================
-- 🔥 MEGA CHIT PANEL v3.0 🔥
-- Вкладки: Speed | Fly | ESP | Misc
-- С анимацией открытия/закрытия
-- Для Roblox (Mobile/PC)
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- ПЕРЕМЕННЫЕ ДЛЯ ФУНКЦИЙ
-- ============================================

local speedEnabled = false
local currentSpeed = 16
local flyEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local espEnabled = false
local espObjects = {}
local jumpPower = 50
local jumpEnabled = false
local infJumpEnabled = false
local noClipEnabled = false
local currentTab = "Speed"
local panelVisible = true

-- ============================================
-- GUI СОЗДАНИЕ
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegaPanel"
ScreenGui.Parent = Player.PlayerGui

-- ============================================
-- ОСНОВНАЯ ПАНЕЛЬ С АНИМАЦИЕЙ
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 550)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Тень
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.7
Shadow.BorderSizePixel = 0
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 18)
ShadowCorner.Parent = Shadow

-- ============================================
-- ЗАГОЛОВОК С КНОПКОЙ ЗАКРЫТИЯ
-- ============================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔥 MEGA PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Кнопка закрытия с анимацией
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -50, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- ============================================
-- КНОПКА ПОКАЗА (плавающая)
-- ============================================

local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 65, 0, 65)
ShowButton.Position = UDim2.new(0, 20, 1, -85)
ShowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
ShowButton.Text = "🔥"
ShowButton.TextColor3 = Color3.fromRGB(255, 200, 0)
ShowButton.TextSize = 35
ShowButton.Font = Enum.Font.GothamBold
ShowButton.BorderSizePixel = 2
ShowButton.BorderColor3 = Color3.fromRGB(255, 200, 0)
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowButton

-- ============================================
-- ВКЛАДКИ
-- ============================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.Position = UDim2.new(0, 0, 0, 50)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

-- Кнопки вкладок
local tabs = {"Speed", "Fly", "ESP", "Misc"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, -4)
    btn.Position = UDim2.new((i-1) * 0.25, 2, 0, 2)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 65)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 65)
        end
        updateTabs()
    end)
end

-- ============================================
-- КОНТЕЙНЕР ДЛЯ ВКЛАДОК
-- ============================================

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 1, -140)
TabContainer.Position = UDim2.new(0, 10, 0, 105)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabContainer.BackgroundTransparency = 0.3
TabContainer.BorderSizePixel = 1
TabContainer.BorderColor3 = Color3.fromRGB(60, 60, 120)
TabContainer.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 10)
ContainerCorner.Parent = TabContainer

-- ============================================
-- ФУНКЦИЯ ОБНОВЛЕНИЯ ВКЛАДОК
-- ============================================

local function clearContainer()
    for _, child in ipairs(TabContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("ScrollingFrame") then
            child:Destroy()
        end
    end
end

function updateTabs()
    clearContainer()
    
    if currentTab == "Speed" then
        createSpeedTab()
    elseif currentTab == "Fly" then
        createFlyTab()
    elseif currentTab == "ESP" then
        createESPTab()
    elseif currentTab == "Misc" then
        createMiscTab()
    end
end

-- ============================================
-- ВКЛАДКА SPEED (Скорость)
-- ============================================

function createSpeedTab()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 5
    frame.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
    
    -- Кнопка включения скорости
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(1, -20, 0, 45)
    speedBtn.Position = UDim2.new(0, 10, 0, 5)
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    speedBtn.Text = speedEnabled and "🟢 SPEED: ON" or "🔴 SPEED: OFF"
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 18
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.BorderSizePixel = 0
    speedBtn.Parent = frame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedBtn
    
    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedBtn.Text = speedEnabled and "🟢 SPEED: ON" or "🔴 SPEED: OFF"
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        if speedEnabled then
            Humanoid.WalkSpeed = currentSpeed
        else
            Humanoid.WalkSpeed = 16
        end
    end)
    
    -- Дисплей скорости
    local speedDisplay = Instance.new("TextLabel")
    speedDisplay.Size = UDim2.new(1, -20, 0, 40)
    speedDisplay.Position = UDim2.new(0, 10, 0, 60)
    speedDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    speedDisplay.BackgroundTransparency = 0.3
    speedDisplay.Text = "Скорость: " .. currentSpeed
    speedDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
    speedDisplay.TextSize = 20
    speedDisplay.Font = Enum.Font.GothamBold
    speedDisplay.BorderSizePixel = 1
    speedDisplay.BorderColor3 = Color3.fromRGB(80, 80, 150)
    speedDisplay.Parent = frame
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = UDim.new(0, 8)
    displayCorner.Parent = speedDisplay
    
    -- Ползунок скорости
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 45)
    sliderFrame.Position = UDim2.new(0, 10, 0, 110)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    sliderFrame.BackgroundTransparency = 0.5
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.9, 0, 0, 8)
    sliderBar.Position = UDim2.new(0.05, 0, 0.5, -4)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentSpeed - 1) / 999, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("TextButton")
    sliderKnob.Size = UDim2.new(0, 25, 0, 25)
    sliderKnob.Position = UDim2.new((currentSpeed - 1) / 999, -12.5, 0.5, -12.5)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sliderKnob.Text = ""
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    sliderKnob.MouseButton1Down:Connect(function()
        local dragging = true
        local mouse = Player:GetMouse()
        
        local function update()
            if not dragging then return end
            local relX = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local val = math.floor(1 + relX * 999)
            currentSpeed = val
            speedDisplay.Text = "Скорость: " .. val
            sliderFill.Size = UDim2.new((val - 1) / 999, 0, 1, 0)
            sliderKnob.Position = UDim2.new((val - 1) / 999, -12.5, 0.5, -12.5)
            if speedEnabled then
                Humanoid.WalkSpeed = val
            end
        end
        
        local conn1 = mouse.Move:Connect(update)
        local conn2 = mouse.Button1Up:Connect(function()
            dragging = false
            conn1:Disconnect()
            conn2:Disconnect()
        end)
    end)
    
    -- Кнопка сброса
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, -20, 0, 40)
    resetBtn.Position = UDim2.new(0, 10, 0, 170)
    resetBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
    resetBtn.Text = "🔄 СБРОСИТЬ (16)"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.TextSize = 18
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.BorderSizePixel = 0
    resetBtn.Parent = frame
    
    local resetCorner = Instance.new("UICorner")
    resetCorner.CornerRadius = UDim.new(0, 8)
    resetCorner.Parent = resetBtn
    
    resetBtn.MouseButton1Click:Connect(function()
        currentSpeed = 16
        speedDisplay.Text = "Скорость: 16"
        sliderFill.Size = UDim2.new(15/999, 0, 1, 0)
        sliderKnob.Position = UDim2.new(15/999, -12.5, 0.5, -12.5)
        if speedEnabled then
            Humanoid.WalkSpeed = 16
        end
    end)
end

-- ============================================
-- ВКЛАДКА FLY (Полет)
-- ============================================

function createFlyTab()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 5
    frame.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
    
    -- Включение полета
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(1, -20, 0, 45)
    flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    flyBtn.Text = flyEnabled and "🟢 FLY: ON" or "🔴 FLY: OFF"
    flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.TextSize = 18
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.BorderSizePixel = 0
    flyBtn.Parent = frame
    
    local flyCorner = Instance.new("UICorner")
    flyCorner.CornerRadius = UDim.new(0, 8)
    flyCorner.Parent = flyBtn
    
    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        flyBtn.Text = flyEnabled and "🟢 FLY: ON" or "🔴 FLY: OFF"
        flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        
        if flyEnabled then
            if bodyVelocity then bodyVelocity:Destroy() end
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = Character:WaitForChild("HumanoidRootPart")
            
            -- Управление полетом (WASD + Space)
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled or not bodyVelocity then
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                local moveDirection = Vector3.new()
                local camera = workspace.CurrentCamera
                
                if UserInputService then
                    -- TODO: Добавить управление для мобильных
                end
                
                -- Для мобильных: полет вверх при нажатии на экран
                bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
            end)
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end)
    
    -- Ползунок скорости полета
    local flySpeedDisplay = Instance.new("TextLabel")
    flySpeedDisplay.Size = UDim2.new(1, -20, 0, 35)
    flySpeedDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    flySpeedDisplay.BackgroundTransparency = 0.3
    flySpeedDisplay.Text = "Скорость полета: " .. flySpeed
    flySpeedDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
    flySpeedDisplay.TextSize = 18
    flySpeedDisplay.Font = Enum.Font.GothamBold
    flySpeedDisplay.BorderSizePixel = 1
    flySpeedDisplay.BorderColor3 = Color3.fromRGB(80, 80, 150)
    flySpeedDisplay.Parent = frame
    
    local flyDisplayCorner = Instance.new("UICorner")
    flyDisplayCorner.CornerRadius = UDim.new(0, 8)
    flyDisplayCorner.Parent = flySpeedDisplay
    
    local flySlider = Instance.new("Frame")
    flySlider.Size = UDim2.new(1, -20, 0, 40)
    flySlider.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    flySlider.BackgroundTransparency = 0.5
    flySlider.BorderSizePixel = 0
    flySlider.Parent = frame
    
    local flySliderCorner = Instance.new("UICorner")
    flySliderCorner.CornerRadius = UDim.new(0, 8)
    flySliderCorner.Parent = flySlider
    
    local flyBar = Instance.new("Frame")
    flyBar.Size = UDim2.new(0.9, 0, 0, 8)
    flyBar.Position = UDim2.new(0.05, 0, 0.5, -4)
    flyBar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    flyBar.BorderSizePixel = 0
    flyBar.Parent = flySlider
    
    local flyBarCorner = Instance.new("UICorner")
    flyBarCorner.CornerRadius = UDim.new(1, 0)
    flyBarCorner.Parent = flyBar
    
    local flyFill = Instance.new("Frame")
    flyFill.Size = UDim2.new((flySpeed - 10) / 240, 0, 1, 0)
    flyFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    flyFill.BorderSizePixel = 0
    flyFill.Parent = flyBar
    
    local flyFillCorner = Instance.new("UICorner")
    flyFillCorner.CornerRadius = UDim.new(1, 0)
    flyFillCorner.Parent = flyFill
    
    local flyKnob = Instance.new("TextButton")
    flyKnob.Size = UDim2.new(0, 25, 0, 25)
    flyKnob.Position = UDim2.new((flySpeed - 10) / 240, -12.5, 0.5, -12.5)
    flyKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    flyKnob.Text = ""
    flyKnob.BorderSizePixel = 0
    flyKnob.Parent = flySlider
    
    local flyKnobCorner = Instance.new("UICorner")
    flyKnobCorner.CornerRadius = UDim.new(1, 0)
    flyKnobCorner.Parent = flyKnob
    
    flyKnob.MouseButton1Down:Connect(function()
        local dragging = true
        local mouse = Player:GetMouse()
        
        local function update()
            if not dragging then return end
            local relX = math.clamp((mouse.X - flySlider.AbsolutePosition.X) / flySlider.AbsoluteSize.X, 0, 1)
            local val = math.floor(10 + relX * 240)
            flySpeed = val
            flySpeedDisplay.Text = "Скорость полета: " .. val
            flyFill.Size = UDim2.new((val - 10) / 240, 0, 1, 0)
            flyKnob.Position = UDim2.new((val - 10) / 240, -12.5, 0.5, -12.5)
        end
        
        local conn1 = mouse.Move:Connect(update)
        local conn2 = mouse.Button1Up:Connect(function()
            dragging = false
            conn1:Disconnect()
            conn2:Disconnect()
        end)
    end)
end

-- ============================================
-- ВКЛАДКА ESP (Подсветка игроков)
-- ============================================

function createESPTab()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 5
    frame.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = frame
    
    -- Включение ESP
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(1, -20, 0, 45)
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
    espBtn.Text = espEnabled and "🟢 ESP: ON" or "🔴 ESP: OFF"
    espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    espBtn.TextSize = 18
    espBtn.Font = Enum.Font.GothamBold
    espBtn.BorderSizePixel = 0
    espBtn.Parent = frame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espBtn
    
    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "🟢 ESP: ON" or "🔴 ESP: OFF"
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        
        if espEnabled then
        
