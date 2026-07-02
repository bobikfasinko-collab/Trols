-- ============================================
-- 🌱 GROW A GARDEN 2 - DELTA FIX v5.0
-- ПОЛНОСТЬЮ ПЕРЕРАБОТАНО ДЛЯ MOBILE
-- ============================================

-- ОБХОД ВСЕХ ОШИБОК
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ЖДЁМ ПОЛНУЮ ЗАГРУЗКУ
repeat task.wait() until game:IsLoaded()
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.PlayerGui

print("✅ Игра загружена, создаю GUI...")

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local playerName = LocalPlayer.DisplayName or LocalPlayer.Name
local farmEnabled = true
local speedEnabled = false
local currentSpeed = 16
local selectedSeed = "Bamboo"
local panelVisible = true

-- ============================================
-- ФУНКЦИЯ БЕЗОПАСНОГО СОЗДАНИЯ GUI
-- ============================================

local function createGUI()
    -- УДАЛЯЕМ СТАРЫЙ GUI ЕСЛИ ЕСТЬ
    local oldGui = LocalPlayer.PlayerGui:FindFirstChild("GardenPanel")
    if oldGui then
        oldGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GardenPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer.PlayerGui
    
    return ScreenGui
end

local screenGui = createGUI()
print("✅ GUI создан!")

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА
-- ============================================

local showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 55, 0, 55)
showBtn.Position = UDim2.new(0, 15, 1, -80)
showBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
showBtn.Text = "🌱"
showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
showBtn.TextSize = 28
showBtn.Font = Enum.Font.GothamBold
showBtn.BorderSizePixel = 2
showBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
showBtn.Visible = false
showBtn.Parent = screenGui

local showCorner = Instance.new("UICorner")
showCorner.CornerRadius = UDim.new(1, 0)
showCorner.Parent = showBtn

-- ============================================
-- ОСНОВНАЯ ПАНЕЛЬ
-- ============================================

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 480)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 25, 10)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- ============================================
-- ЗАГОЛОВОК
-- ============================================

local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = titleFrame

-- Приветствие
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -50, 1, 0)
welcomeLabel.Position = UDim2.new(0, 10, 0, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "🌱 " .. playerName .. ", Привет!"
welcomeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
welcomeLabel.TextSize = 18
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.Parent = titleFrame

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- ============================================
-- КНОПКА SPEED HACK
-- ============================================

local speedBtn = Instance.new("TextButton")
speedBtn.Size = UDim2.new(1, -20, 0, 38)
speedBtn.Position = UDim2.new(0, 10, 0, 58)
speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
speedBtn.Text = "⚡ SPEED: OFF"
speedBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
speedBtn.TextSize = 16
speedBtn.Font = Enum.Font.GothamBold
speedBtn.BorderSizePixel = 1
speedBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
speedBtn.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBtn

-- ============================================
-- ПОЛЗУНОК СКОРОСТИ
-- ============================================

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -20, 0, 50)
sliderFrame.Position = UDim2.new(0, 10, 0, 102)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
sliderFrame.BackgroundTransparency = 0.3
sliderFrame.BorderSizePixel = 1
sliderFrame.BorderColor3 = Color3.fromRGB(80, 80, 150)
sliderFrame.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 8)
sliderCorner.Parent = sliderFrame

-- Дисплей
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(1, 0, 0, 20)
speedDisplay.Position = UDim2.new(0, 0, 0, 2)
speedDisplay.BackgroundTransparency = 1
speedDisplay.Text = "Скорость: 16"
speedDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
speedDisplay.TextSize = 14
speedDisplay.Font = Enum.Font.GothamBold
speedDisplay.Parent = sliderFrame

-- Полоса
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.9, 0, 0, 6)
bar.Position = UDim2.new(0.05, 0, 0.75, -3)
bar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
bar.BorderSizePixel = 0
bar.Parent = sliderFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

-- Заполнение
local fill = Instance.new("Frame")
fill.Size = UDim2.new(15/999, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
fill.BorderSizePixel = 0
fill.Parent = bar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = fill

-- Ручка
local knob = Instance.new("TextButton")
knob.Size = UDim2.new(0, 20, 0, 20)
knob.Position = UDim2.new(15/999, -10, 0.75, -10)
knob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
knob.Text = ""
knob.BorderSizePixel = 0
knob.Parent = sliderFrame

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = knob

-- Минимум/Максимум
local minLabel = Instance.new("TextLabel")
minLabel.Size = UDim2.new(0, 20, 0, 15)
minLabel.Position = UDim2.new(0, 5, 0, 30)
minLabel.BackgroundTransparency = 1
minLabel.Text = "1"
minLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
minLabel.TextSize = 11
minLabel.Font = Enum.Font.Gotham
minLabel.Parent = sliderFrame

local maxLabel = Instance.new("TextLabel")
maxLabel.Size = UDim2.new(0, 30, 0, 15)
maxLabel.Position = UDim2.new(1, -30, 0, 30)
maxLabel.BackgroundTransparency = 1
maxLabel.Text = "1000"
maxLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
maxLabel.TextSize = 11
maxLabel.Font = Enum.Font.Gotham
maxLabel.Parent = sliderFrame

-- ============================================
-- УПРАВЛЕНИЕ ПОЛЗУНКОМ
-- ============================================

local function updateSpeed(val)
    val = math.floor(val)
    currentSpeed = val
    speedDisplay.Text = "Скорость: " .. val
    local pos = (val - 1) / 999
    fill.Size = UDim2.new(pos, 0, 1, 0)
    knob.Position = UDim2.new(pos, -10, 0.75, -10)
    
    if speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = val
            end
        end
    end
end

knob.MouseButton1Down:Connect(function()
    local dragging = true
    local mouse = LocalPlayer:GetMouse()
    
    local conn1 = mouse.Move:Connect(function()
        if not dragging then return end
        local relX = math.clamp((mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
        updateSpeed(1 + relX * 999)
    end)
    
    local conn2 = mouse.Button1Up:Connect(function()
        dragging = false
        conn1:Disconnect()
        conn2:Disconnect()
    end)
end)

-- ============================================
-- ВКЛЮЧЕНИЕ SPEED HACK
-- ============================================

speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedBtn.Text = speedEnabled and "⚡ SPEED: ON" or "⚡ SPEED: OFF"
    speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 80)
    
    if speedEnabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = currentSpeed
            end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
end)

-- ============================================
-- КОНТЕЙНЕР ДЛЯ ФРУКТОВ
-- ============================================

local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -220)
container.Position = UDim2.new(0, 10, 0, 160)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 3
container.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = container

-- ============================================
-- КНОПКА ФАРМА
-- ============================================

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1, 0, 0, 36)
farmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
farmBtn.Text = "🟢 АВТОФАРМ ВКЛ"
farmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
farmBtn.TextSize = 16
farmBtn.Font = Enum.Font.GothamBold
farmBtn.BorderSizePixel = 0
farmBtn.Parent = container

local farmCorner = Instance.new("UICorner")
farmCorner.CornerRadius = UDim.new(0, 8)
farmCorner.Parent = farmBtn

farmBtn.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    farmBtn.Text = farmEnabled and "🟢 АВТОФАРМ ВКЛ" or "🔴 АВТОФАРМ ВЫКЛ"
    farmBtn.BackgroundColor3 = farmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- ============================================
-- СПИСОК ФРУКТОВ
-- ============================================

local seedsList = {
    "Bamboo", "Rose", "Sunflower", "Pumpkin",
    "Watermelon", "Tomato", "Potato", "Carrot",
    "Wheat", "Corn", "Strawberry", "Blueberry",
    "Pepper", "Onion", "Garlic"
}

-- ============================================
-- ФУНКЦИЯ УВЕДОМЛЕНИЯ
-- ============================================

local function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 230, 0, 40)
    notif.Position = UDim2.new(1, -245, 0, 70)
    notif.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    notif.BackgroundTransparency = 0.1
    notif.Text = "✅ " .. text .. " в стоке!"
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 16
    notif.Font = Enum.Font.GothamBold
    notif.BorderSizePixel = 2
    notif.BorderColor3 = Color3.fromRGB(255, 200, 0)
    notif.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    task.wait(5)
    notif:Destroy()
end

-- ============================================
-- СОЗДАНИЕ КНОПОК ФРУКТОВ
-- ============================================

for _, seed in ipairs(seedsList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = (selectedSeed == seed) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 50, 30)
    btn.Text = "🌱 " .. seed .. (selectedSeed == seed and " ✅" or "")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedSeed = seed
        showNotification(seed)
        
        -- Обновляем все кнопки
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("TextButton") and child ~= farmBtn then
                local text = child.Text:gsub(" ✅", "")
                if text == "🌱 " .. seed then
                    child.Text = "🌱 " .. seed .. " ✅"
                    child.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                else
                    child.Text = text
                    child.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
                end
            end
        end
    end)
end

-- ============================================
-- УПРАВЛЕНИЕ ВИДИМОСТЬЮ
-- ============================================

closeBtn.MouseButton1Click:Connect(function()
    panelVisible = false
    mainFrame.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    panelVisible = true
    mainFrame.Visible = true
    showBtn.Visible = false
end)

-- ============================================
-- ОСНОВНЫЕ ФУНКЦИИ ДЛЯ ФАРМА
-- ============================================

local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner")
        if owner and owner.Value == LocalPlayer.Name then
            return plot
        end
    end
    return nil
end

-- ============================================
-- АВТОСБОР
-- ============================================

task.spawn(function()
    while task.wait(1.5) do
        if not farmEnabled then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            for _, crop in ipairs(crops:GetChildren()) do
                local stage = crop:FindFirstChild("Stage")
                if stage and stage.Value >= 3 then
                    local harvestRemote = ReplicatedStorage:FindFirstChild("HarvestCrop", true)
                    if harvestRemote then
                        harvestRemote:FireServer(crop)
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)

-- ============================================
-- АВТОПОКУПКА
-- ============================================

task.spawn(function()
    while task.wait(2) do
        if not farmEnabled then continue end
        pcall(function()
            local buyRemote = ReplicatedStorage:FindFirstChild("BuySeeds", true)
            if buyRemote then
                buyRemote:FireServer(selectedSeed, 50)
            end
        end)
    end
end)

-- ============================================
-- АВТОПОСАДКА
-- ============================================

task.spawn(function()
    while task.wait(2.5) do
        if not farmEnabled then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local soil = plot:FindFirstChild("Soil")
            if not soil then return end
            for _, spot in ipairs(soil:GetChildren()) do
                if spot:IsA("Part") and not spot:FindFirstChild("Crop") then
                    local plantRemote = ReplicatedStorage:FindFirstChild("PlantSeed", true)
                    if plantRemote then
                        plantRemote:FireServer(spot, selectedSeed)
                        task.wait(0.2)
                    end
                end
            end
        end)
    end
end)

-- ============================================
-- АВТОПОЛИВ
-- ============================================

task.spawn(function()
    while task.wait(3) do
        if not farmEnabled then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            for _, crop in ipairs(crops:GetChildren()) do
                local water = crop:FindFirstChild("Water")
                if water and water.Value < 50 then
                    local waterRemote = ReplicatedStorage:FindFirstChild("WaterCrop", true)
                    if waterRemote then
                        waterRemote:FireServer(crop)
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
end)

-- ============================================
-- АНТИ-AFK
-- ============================================

task.spawn(function()
    while task.wait(60) do
        pcall(function()
            local camera = workspace.CurrentCamera
            if camera then
                camera.CFrame = camera.CFrame * CFrame.Angles(0, 0.01, 0)
            end
        end)
    end
end)

-- ============================================
-- ПЕРЕХВАТ ПЕРСОНАЖА
-- ============================================

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(2)
    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = currentSpeed
        end
    end
end)

-- ============================================
-- ИНФОРМАЦИЯ В КОНСОЛИ
-- ============================================

print("=========================================")
print("🌱 GROW A GARDEN 2 - DELTA FIX v5.0")
print("✅ Привет, " .. playerName .. "!")
print("✅ Панель создана для телефона")
print("✅ Нажмите ✕ для скрытия")
print("✅ Нажмите 🌱 для показа")
print("=========================================")
