-- ============================================
-- 🌱 GROW A GARDEN 2 - AUTO FARM v3.0
-- ИСПРАВЛЕНО ДЛЯ DELTA MOBILE
-- ============================================

-- ОБХОД ОШИБОК ДЛЯ MOBILE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ПРОВЕРКА ЗАГРУЗКИ ИГРЫ
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
}

-- ============================================
-- СОЗДАНИЕ GUI (С ПРОВЕРКОЙ)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GardenGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ПЫТАЕМСЯ УСТАНОВИТЬ GUI
local success, err = pcall(function()
    ScreenGui.Parent = LocalPlayer.PlayerGui
end)

if not success then
    -- ЕСЛИ НЕ ПОЛУЧИЛОСЬ, ПРОБУЕМ ЧЕРЕЗ WAIT
    LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

print("✅ GUI создан!")

-- ============================================
-- ГЛАВНОЕ ОКНО
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
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
-- ЗАГОЛОВОК
-- ============================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 50, 25)
Title.Text = "🌱 GARDEN AUTO FARM"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- ============================================
-- КНОПКА ЗАКРЫТИЯ (РАБОТАЕТ)
-- ============================================

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
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

-- ПЕРЕКЛЮЧЕНИЕ ВИДИМОСТИ
local panelVisible = true

CloseBtn.MouseButton1Click:Connect(function()
    panelVisible = not panelVisible
    MainFrame.Visible = panelVisible
    print("Панель " .. (panelVisible and "показана" or "скрыта"))
end)

-- ============================================
-- ИНФОРМАЦИОННАЯ ПАНЕЛЬ
-- ============================================

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 180, 0, 70)
InfoFrame.Position = UDim2.new(0, 10, 0, 10)
InfoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InfoFrame.BackgroundTransparency = 0.6
InfoFrame.BorderSizePixel = 1
InfoFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
InfoFrame.Parent = ScreenGui

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "🌱 GARDEN FARM\n✅ " .. Settings.SelectedSeed .. "\n🟢 РАБОТАЕТ"
InfoLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.Parent = InfoFrame

-- ============================================
-- КОНТЕЙНЕР С КНОПКАМИ
-- ============================================

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -95)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Container

-- ============================================
-- КНОПКА СТАТУСА
-- ============================================

local farmEnabled = true

local StatusBtn = Instance.new("TextButton")
StatusBtn.Size = UDim2.new(1, 0, 0, 40)
StatusBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
StatusBtn.Text = "🟢 АВТОФАРМ ВКЛ"
StatusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusBtn.TextSize = 17
StatusBtn.Font = Enum.Font.GothamBold
StatusBtn.BorderSizePixel = 0
StatusBtn.Parent = Container

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBtn

StatusBtn.MouseButton1Click:Connect(function()
    farmEnabled = not farmEnabled
    StatusBtn.Text = farmEnabled and "🟢 АВТОФАРМ ВКЛ" or "🔴 АВТОФАРМ ВЫКЛ"
    StatusBtn.BackgroundColor3 = farmEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    InfoLabel.Text = farmEnabled and "🌱 GARDEN FARM\n✅ " .. Settings.SelectedSeed .. "\n🟢 РАБОТАЕТ" or "🌱 GARDEN FARM\n⛔ ОСТАНОВЛЕН"
end)

-- ============================================
-- СПИСОК СЕМЯН
-- ============================================

local Seeds = {
    "Bamboo", "Rose", "Sunflower", "Pumpkin",
    "Watermelon", "Tomato", "Potato", "Carrot",
    "Wheat", "Corn", "Strawberry", "Blueberry",
    "Pepper", "Onion", "Garlic"
}

for _, seed in ipairs(Seeds) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = (Settings.SelectedSeed == seed) and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(35, 55, 35)
    btn.Text = "🌱 " .. seed .. (Settings.SelectedSeed == seed and " ✅" or "")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        Settings.SelectedSeed = seed
        InfoLabel.Text = farmEnabled and "🌱 GARDEN FARM\n✅ " .. seed .. "\n🟢 РАБОТАЕТ" or "🌱 GARDEN FARM\n⛔ ОСТАНОВЛЕН"
        
        -- Обновляем все кнопки
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("TextButton") and child ~= StatusBtn then
                local text = child.Text:gsub(" ✅", "")
                if text == "🌱 " .. seed then
                    child.Text = "🌱 " .. seed .. " ✅"
                    child.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                else
                    child.Text = text
                    child.BackgroundColor3 = Color3.fromRGB(35, 55, 35)
                end
            end
        end
        print("🌱 Выбраны семена: " .. seed)
    end)
end

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
            local shop = getSeedShop()
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
            for _, spot in ipairs(soil:GetChildren()) do
                if spot:IsA("Part") and not spot:FindFirstChild("Crop") then
                    local prompt = spot:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.2)
                    end
                    local plantRemote = ReplicatedStorage:FindFirstChild("PlantSeed", true)
                    if plantRemote then
                        plantRemote:FireServer(spot, Settings.SelectedSeed)
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
        if not farmEnabled or not Settings.AutoWater then continue end
        pcall(function()
            local plot = getMyPlot()
            if not plot then return end
            local crops = plot:FindFirstChild("Crops")
            if not crops then return end
            for _, crop in ipairs(crops:GetChildren()) do
                local water = crop:FindFirstChild("Water")
                if water and water.Value < 50 then
                    local prompt = crop:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                    end
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
            local camera = workspace.CurrentCamera
            if camera then
                local newCFrame = camera.CFrame * CFrame.Angles(0, 0.01, 0)
                camera.CFrame = newCFrame
            end
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
-- ИНФОРМАЦИЯ В КОНСОЛИ
-- ============================================

print("=========================================")
print("🌱 GROW A GARDEN 2 - AUTO FARM v3.0")
print("✅ ЗАГРУЖЕНО ДЛЯ DELTA MOBILE!")
print("✅ Выберите семена в панели")
print("✅ Нажмите ✕ для скрытия/показа")
print("✅ Нажмите кнопку статуса для ВКЛ/ВЫКЛ")
print("=========================================")
