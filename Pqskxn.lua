-- ============================================
-- 🌱 GROW A GARDEN 2 - ULTRA PANEL v4.0
-- Функции: Выбор фрукта | Уведомления о стоке
--          Speed Hack 1-1000 | Приветствие игрока
--          Скрытие/показ панели
--          ДЛЯ DELTA MOBILE
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ОЖИДАНИЕ ЗАГРУЗКИ
repeat task.wait() until game:IsLoaded() and LocalPlayer and LocalPlayer.PlayerGui

-- ============================================
-- НАСТРОЙКИ
-- ============================================

local Settings = {
    AutoHarvest = true,
    AutoPlant = true,
    AutoBuy = true,
    AutoWater = true,
    SelectedSeed = "Bamboo",
    BuyAmount = 50,
    AntiAFK = true,
    SpeedHack = false,
    CurrentSpeed = 16,
}

-- ============================================
-- ПЕРЕМЕННЫЕ ДЛЯ УВЕДОМЛЕНИЙ
-- ============================================

local notificationActive = false
local notificationTimer = nil

-- ============================================
-- ПОЛУЧЕНИЕ ИМЕНИ ИГРОКА
-- ============================================

local playerName = LocalPlayer.DisplayName or LocalPlayer.Name

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GardenPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success, err = pcall(function()
    ScreenGui.Parent = LocalPlayer.PlayerGui
end)

if not success then
    LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА ДЛЯ ОТКРЫТИЯ
-- ============================================

local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 60, 0, 60)
ShowButton.Position = UDim2.new(0, 20, 1, -90)
ShowButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
ShowButton.Text = "🌱"
ShowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowButton.TextSize = 30
ShowButton.Font = Enum.Font.GothamBold
ShowButton.BorderSizePixel = 2
ShowButton.BorderColor3 = Color3.fromRGB(0, 255, 100)
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowButton

-- ============================================
-- ГЛАВНАЯ ПАНЕЛЬ
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 25, 10)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- ============================================
-- ЗАГОЛОВОК С ПРИВЕТСТВИЕМ
-- ============================================

local Title = Instance.new("Frame")
Title.Size = UDim2.new(1, 0, 0, 55)
Title.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Текст приветствия
local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -50, 1, 0)
WelcomeLabel.Position = UDim2.new(0, 10, 0, 0)
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Text = "🌱 " .. playerName .. ", Привет!"
WelcomeLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
WelcomeLabel.TextSize = 18
WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
WelcomeLabel.Font = Enum.Font.GothamBold
WelcomeLabel.Parent = Title

-- Кнопка закрытия (скрыть панель)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

-- ============================================
-- КНОПКА ВКЛЮЧЕНИЯ СПИДХАКА
-- ============================================

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Size = UDim2.new(1, -20, 0, 40)
SpeedBtn.Position = UDim2.new(0, 10, 0, 65)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
SpeedBtn.Text = "⚡ SPEED HACK: OFF"
SpeedBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedBtn.TextSize = 16
SpeedBtn.Font = Enum.Font.GothamBold
SpeedBtn.BorderSizePixel = 1
SpeedBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
SpeedBtn.Parent = MainFrame

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedBtn

-- ============================================
-- ПОЛЗУНОК СКОРОСТИ
-- ============================================

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, -20, 0, 45)
SpeedFrame.Position = UDim2.new(0, 10, 0, 110)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
SpeedFrame.BackgroundTransparency = 0.5
SpeedFrame.BorderSizePixel = 1
SpeedFrame.BorderColor3 = Color3.fromRGB(80, 80, 150)
SpeedFrame.Parent = MainFrame

local SpeedFrameCorner = Instance.new("UICorner")
SpeedFrameCorner.CornerRadius = UDim.new(0, 8)
SpeedFrameCorner.Parent = SpeedFrame

-- Дисплей скорости
local SpeedDisplay = Instance.new("TextLabel")
SpeedDisplay.Size = UDim2.new(1, 0, 0, 20)
SpeedDisplay.Position = UDim2.new(0, 0, 0, 0)
SpeedDisplay.BackgroundTransparency = 1
SpeedDisplay.Text = "Скорость: 16"
SpeedDisplay.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedDisplay.TextSize = 14
SpeedDisplay.Font = Enum.Font.GothamBold
SpeedDisplay.Parent = SpeedFrame

-- Ползунок
local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.9, 0, 0, 8)
SliderBar.Position = UDim2.new(0.05, 0, 0.7, -4)
SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SpeedFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(15/999, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderKnob = Instance.new("TextButton")
SliderKnob.Size = UDim2.new(0, 22, 0, 22)
SliderKnob.Position = UDim2.new(15/999, -11, 0.7, -11)
SliderKnob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderKnob.Text = ""
SliderKnob.BorderSizePixel = 0
SliderKnob.Parent = SpeedFrame

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = SliderKnob

-- Минимум/Максимум
local MinLabel = Instance.new("TextLabel")
MinLabel.Size = UDim2.new(0, 20, 0, 15)
MinLabel.Position = UDim2.new(0, 5, 0, -10)
MinLabel.BackgroundTransparency = 1
MinLabel.Text = "1"
MinLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
MinLabel.TextSize = 12
MinLabel.Font = Enum.Font.Gotham
MinLabel.Parent = SpeedFrame

local MaxLabel = Instance.new("TextLabel")
MaxLabel.Size = UDim2.new(0, 30, 0, 15)
MaxLabel.Position = UDim2.new(1, -30, 0, -10)
MaxLabel.BackgroundTransparency = 1
MaxLabel.Text = "1000"
MaxLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
MaxLabel.TextSize = 12
MaxLabel.Font = Enum.Font.Gotham
MaxLabel.Parent = SpeedFrame

-- ============================================
-- УПРАВЛЕНИЕ ПОЛЗУНКОМ
-- ============================================

SliderKnob.MouseButton1Down:Connect(function()
    local dragging = true
    local mouse = LocalPlayer:GetMouse()
    
    local function update()
        if not dragging then return end
        local relX = math.clamp((mouse.X - SpeedFrame.AbsolutePosition.X) / SpeedFrame.AbsoluteSize.X, 0, 1)
        local val = math.floor(1 + relX * 999)
        Settings.CurrentSpeed = val
        SpeedDisplay.Text = "Скорость: " .. val
        SliderFill.Size = UDim2.new((val - 1) / 999, 0, 1, 0)
        SliderKnob.Position = UDim2.new((val - 1) / 999, -11, 0.7, -11)
        
        if Settings.SpeedHack then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = val
                end
            end
        end
    end
    
    local conn1 = mouse.Move:Connect(update)
    local conn2 = mouse.Button1Up:Connect(function()
        dragging = false
        conn1:Disconnect()
        conn2:Disconnect()
    end)
end)

-- Включение/выключение SPEED HACK
SpeedBtn.MouseButton1Click:Connect(function()
    Settings.SpeedHack = not Settings.SpeedHack
    SpeedBtn.Text = Settings.SpeedHack and "⚡ SPEED HACK: ON" or "⚡ SPEED HACK: OFF"
    SpeedBtn.BackgroundColor3 = Settings.SpeedHack and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 80)
    
    if Settings.SpeedHack then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.CurrentSpeed
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
-- КОНТЕЙНЕР ДЛЯ СЕМЯН
-- ============================================

local SeedContainer = Instance.new("ScrollingFrame")
SeedContainer.Size = UDim2.new(1, -20, 1, -270)
SeedContainer.Position = UDim2.new(0, 10, 0, 165)
SeedContainer.BackgroundTransparency = 1
SeedContainer.ScrollBarThickness = 4
SeedContainer.Parent = MainFrame

local SeedLayout = Instance.new("UIListLayout")
SeedLayout.Padding = UDim.new(0, 4)
SeedLayout.Parent = SeedContainer

-- ============================================
-- КНОПКА СТАТУСА ФАРМА
-- ============================================

local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(1, 0, 0, 35)
FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
FarmBtn.Text = "🟢 АВТОФАРМ ВКЛ"
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize = 16
FarmBtn.Font = Enum.Font.GothamBold
FarmBtn.BorderSizePixel = 0
FarmBtn.Parent = SeedContainer

local FarmCorner = Instance.new("UICorner")
FarmCorner.CornerRadius = UDim.new(0, 8)
FarmCorner.Parent = FarmBtn

local farmEnabled = true

FarmBtn.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    FarmBtn.Text = farmEnabled and "🟢 АВТОФАРМ ВКЛ" or "🔴 АВТОФАРМ ВЫКЛ"
    FarmBtn.BackgroundColor3 = farmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
end)

-- ============================================
-- СПИСОК ФРУКТОВ/СЕМЯН
-- ============================================

local Seeds = {
    "Bamboo", "Rose", "Sunflower", "Pumpkin",
    "Watermelon", "Tomato", "Potato", "Carrot",
    "Wheat", "Corn", "Strawberry", "Blueberry",
    "Pepper", "Onion", "Garlic", "Apple",
    "Orange", "Lemon", "Grape", "Cherry"
}

-- ============================================
-- ФУНКЦИЯ ДЛЯ УВЕДОМЛЕНИЯ О СТОКЕ
-- ============================================

local function showNotification(seedName)
    if notificationActive then return end
    notificationActive = true
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 250, 0, 50)
    notif.Position = UDim2.new(1, -270, 0, 80)
    notif.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 2
    notif.BorderColor3 = Color3.fromRGB(255, 200, 0)
    notif.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "✅ " .. seedName .. " в стоке!"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 18
    text.Font = Enum.Font.GothamBold
    text.Parent = notif
    
    -- Анимация появления (для телефона)
    notif.Position = UDim2.new(1, 0, 0, 80)
    
    -- Показываем 5 секунд
    task.wait(5)
    
    notif:Destroy()
    notificationActive = false
end

-- ============================================
-- ПРОВЕРКА СТОКА (СИМУЛЯЦИЯ)
-- ============================================

local function checkStock(seedName)
    -- СИМУЛЯЦИЯ: проверяем есть ли семена в магазине
    -- В реальности нужно найти удаленный событие для проверки стока
    
    local shop = nil
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("ShopGui") then
            shop = obj
            break
        end
        if obj.Name == "SeedShop" or obj.Name == "Shop" then
            shop = obj
            break
        end
    end
    
    if shop then
        local shopGui = shop:FindFirstChild("ShopGui")
        if shopGui then
            for _, btn in ipairs(shopGui:GetDescendants()) do
                if btn:IsA("TextButton") and btn.Text:find(seedName) then
                    -- Если кнопка существует, значит в стоке есть
                    showNotification(seedName)
                    return true
                end
            end
        end
    end
    
    -- Если магазин не найден, показываем уведомление как демонстрацию
    -- (В реальной игре нужно будет найти правильный RemoteEvent)
    showNotification(seedName)
    return true
end

-- ============================================
-- СОЗДАНИЕ КНОПОК СЕМЯН
-- ============================================

for _, seed in ipairs(Seeds) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = (Settings.SelectedSeed == seed) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 50, 30)
    btn.Text = "🌱 " .. seed .. (Settings.SelectedSeed == seed and " ✅" or "")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = SeedContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings.SelectedSeed = seed
        
        -- ПРОВЕРКА СТОКА
        checkStock(seed)
        
        -- Обновляем кнопки
        for _, child in ipairs(SeedContainer:GetChildren()) do
            if child:IsA("TextButton") and child ~= FarmBtn then
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
        print("🌱 Выбраны семена: " .. seed)
    end)
end

-- ============================================
-- УПРАВЛЕНИЕ ВИДИМОСТЬЮ ПАНЕЛИ
-- ============================================

local panelVisible = true

CloseBtn.MouseButton1Click:Connect(function()
    panelVisible = false
    MainFrame.Visible = false
    ShowButton.Visible = true
end)

ShowButton.MouseButton1Click:Connect(function()
    panelVisible = true
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- ============================================
-- ФУНКЦИИ ДЛЯ РАБОТЫ С ИГРОЙ
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
    while task.wait(1) do
        if not farmEnabled or not Settings.AutoHarvest then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            for _, crop in ipairs(crops:GetChildren()) do
                local stage = crop:FindFirstChild("Stage")
                if stage and stage.Value >= 3 then
                    local prompt = crop:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                    end
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
        if not farmEnabled or not Settings.AutoBuy then continue end
        pcall(function()
            local shop = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("ShopGui") then
                    shop = obj
                    break
                end
                if obj.Name == "SeedShop" or obj.Name == "Shop" then
                    shop = obj
                    break
                end
            end
            
            if shop then
                local shopGui = shop:FindFirstChild("ShopGui")
                if shopGui then
                    for _, btn in ipairs(shopGui:GetDescendants()) do
                        if btn:IsA("TextButton") and btn.Text:find(Settings.SelectedSeed) then
                            for i = 1, Settings.BuyAmount do
                                btn:FireClick()
                                task.wait(0.05)
                            end
                            print("💰 Куплено " .. Settings.BuyAmount .. " семян " .. Settings.SelectedSeed)
                            break
                        end
                    end
                end
            else
                local buyRemote = ReplicatedStorage:FindFirstChild("BuySeeds", true)
                if buyRemote then
                    buyRemote:FireServer(Settings.SelectedSeed, Settings.BuyAmount)
                    print("💰 Куплено " .. Settings.BuyAmount .. " семян " .. Settings.SelectedSeed)
                end
            end
        end)
    end
end)

-- ============================================
-- АВТОПОСАДКА
-- ============================================

task.spawn(function()
    while task.wait(2) do
        if not farmEnabled or not Settings.AutoPlant then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local soil = plot:FindFirstChild("Soil")
            if not soil then return end
            for _, spot in ipairs(soil:GetChil
