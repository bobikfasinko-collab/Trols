-- ============================================
-- 🌱 GROW A GARDEN 2 - AUTO FARM v2.0
-- Функции: Автосбор | Автопокупка | Анти-AFK
-- Выбор семян через GUI
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============================================
-- НАСТРОЙКИ (МЕНЯЙТЕ ЗДЕСЬ)
-- ============================================

local Settings = {
    AutoHarvest = true,      -- Автосбор урожая
    AutoPlant = true,        -- Автопосадка
    AutoBuy = true,          -- Автопокупка семян
    AutoWater = true,        -- Автополив
    SelectedSeed = "Bamboo", -- Какой вид семян покупать
    HarvestRange = 60,       -- Радиус сбора
    AntiAFK = true,          -- Анти-AFK
    BuyAmount = 100,         -- Сколько семян покупать за раз
}

-- ============================================
-- GUI ДЛЯ ВЫБОРА СЕМЯН
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GardenGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
Title.Text = "🌱 GARDEN AUTO FARM"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Контейнер для кнопок
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 5
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Container

-- ============================================
-- СПИСОК ДОСТУПНЫХ СЕМЯН
-- ============================================

local Seeds = {
    "Bamboo",
    "Rose",
    "Sunflower",
    "Pumpkin",
    "Watermelon",
    "Tomato",
    "Potato",
    "Carrot",
    "Wheat",
    "Corn",
    "Strawberry",
    "Blueberry",
    "Pepper",
    "Onion",
    "Garlic"
}

-- ============================================
-- СОЗДАНИЕ КНОПОК СЕМЯН
-- ============================================

local function createSeedButton(seedName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = (Settings.SelectedSeed == seedName) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 60, 40)
    btn.Text = "🌱 " .. seedName .. (Settings.SelectedSeed == seedName and " ✅" or "")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings.SelectedSeed = seedName
        -- Обновляем все кнопки
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("TextButton") then
                local text = child.Text:gsub(" ✅", "")
                if text == "🌱 " .. seedName then
                    child.Text = "🌱 " .. seedName .. " ✅"
                    child.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                else
                    child.Text = text
                    child.BackgroundColor3 = Color3.fromRGB(40, 60, 40)
                end
            end
        end
        print("🌱 Выбраны семена: " .. seedName)
    end)
end

-- Создаем кнопки для всех семян
for _, seed in ipairs(Seeds) do
    createSeedButton(seed)
end

-- ============================================
-- КНОПКА СТАТУСА (ВКЛ/ВЫКЛ)
-- ============================================

local StatusBtn = Instance.new("TextButton")
StatusBtn.Size = UDim2.new(1, 0, 0, 40)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
StatusBtn.Text = "🟢 АВТОФАРМ ВКЛ"
StatusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusBtn.TextSize = 18
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.BorderSizePixel = 0
StatusBtn.Parent = Container

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBtn

local farmEnabled = true

StatusBtn.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    StatusBtn.Text = farmEnabled and "🟢 АВТОФАРМ ВКЛ" or "🔴 АВТОФАРМ ВЫКЛ"
    StatusBtn.BackgroundColor3 = farmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    print("Статус фермы: " .. (farmEnabled and "ВКЛ" or "ВЫКЛ"))
end)

-- ============================================
-- ОСНОВНЫЕ ФУНКЦИИ
-- ============================================

-- Поиск участка игрока
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

-- Поиск магазина семян
local function getSeedShop()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("ShopGui") then
            return obj
        end
        if obj.Name == "SeedShop" or obj.Name == "Shop" then
            return obj
        end
    end
    return nil
end

-- ============================================
-- АВТОСБОР УРОЖАЯ
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
                    -- Пытаемся собрать через ProximityPrompt
                    local prompt = crop:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                    end
                    
                    -- Альтернативный метод через RemoteEvent
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
-- АВТОПОКУПКА СЕМЯН
-- ============================================

task.spawn(function()
    while task.wait(2) do
        if not farmEnabled or not Settings.AutoBuy then continue end
        
        pcall(function()
            local shop = getSeedShop()
            if not shop then
                -- Если магазин не найден, пробуем через ReplicatedStorage
                local buyRemote = ReplicatedStorage:FindFirstChild("BuySeeds", true)
                if buyRemote then
                    buyRemote:FireServer(Settings.SelectedSeed, Settings.BuyAmount)
                    print("💰 Куплено " .. Settings.BuyAmount .. " семян " .. Settings.SelectedSeed)
                end
                return
            end
            
            -- Ищем кнопку покупки нужных семян
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
            
            -- Находим свободные грядки
            local soil = plot:FindFirstChild("Soil")
            if not soil then return end
            
            local emptySpots = {}
            for _, spot in ipairs(soil:GetChildren()) do
                if spot:IsA("Part") and not spot:FindFirstChild("Crop") then
                    table.insert(emptySpots, spot)
                end
            end
            
            -- Сажаем на пустые места
            for _, spot in ipairs(emptySpots) do
                local prompt = spot:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                    task.wait(0.2)
                end
                
                -- Альтернативный метод
                local plantRemote = ReplicatedStorage:FindFirstChild("PlantSeed", true)
                if plantRemote then
                    plantRemote:FireServer(spot, Settings.SelectedSeed)
                    task.wait(0.2)
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
        if not farmEnabled or not Settings.AutoWater then continue end
        
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            
            for _, crop in ipairs(crops:GetChildren()) do
                local water = crop:FindFirstChild("Water")
                if water and water.Value < 50 then
                    local waterBtn = crop:FindFirstChildOfClass("ProximityPrompt")
                    if waterBtn then
                        fireproximityprompt(waterBtn)
                        task.wait(0.1)
                    end
                    
                    -- Альтернативный метод
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
        if not Settings.AntiAFK then continue end
        
        pcall(function()
            -- Симуляция движения (поворот камеры)
            local camera = workspace.CurrentCamera
            if camera then
                local newCFrame = camera.CFrame * CFrame.Angles(0, 0.01, 0)
                camera.CFrame = newCFrame
            end
            
            -- Симуляция нажатия клавиши
            local VirtualInputManager = game:GetService("VirtualInputManager")
            if VirtualInputManager then
                VirtualInputManager:SendKeyEvent(true, "W", false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "W", false, game)
            end
            
            -- Движение персонажа
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local moveVector = hrp.CFrame.LookVector * 0.1
                    hrp.Velocity = Vector3.new(moveVector.X, 0, moveVector.Z)
                end
            end
        end)
    end
end)

-- ============================================
-- ИНФОРМАЦИОННАЯ ПАНЕЛЬ
-- ============================================

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 200, 0, 80)
InfoFrame.Position = UDim2.new(0, 10, 0, 10)
InfoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InfoFrame.BackgroundTransparency = 0.5
InfoFrame.BorderSizePixel = 1
InfoFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
InfoFrame.Parent = ScreenGui

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "🌱 GARDEN FARM\n✅ Активен: " .. Settings.SelectedSeed
InfoLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.Parent = InfoFrame

-- Обновление информации
task.spawn(function()
    while task.wait(5) do
        InfoLabel.Text = "🌱 GARDEN FARM\n✅ Активен: " .. Settings.SelectedSeed .. "\n🟢 Статус: " .. (farmEnabled and "РАБОТАЕТ" : "ВЫКЛ")
    end
end)

-- ============================================
-- ЗАПУСК
-- ============================================

print("=========================================")
print("🌱 GROW A GARDEN 2 - AUTO FARM v2.0")
print("✅ Загружено!")
print("✅ Выберите семена в GUI")
print("✅ Нажмите на кнопку статуса для ВКЛ/ВЫКЛ")
print("=========================================")
