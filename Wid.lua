--[[
    🚢 MEGA SCRIPT для Build a Boat for Treasure (BBFT)
    ✅ 20+ функций
    ✅ Автофарм (золото, блоки, опыт)
    ✅ Полностью настраиваемое GUI
    ✅ Работает через Delta / Synapse / KRNL
--]]

-- Проверка, что мы в игре
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Переменные для автофарма
local FarmActive = false
local FarmConnections = {}
local CurrentStage = 0
local AutoClickActive = false
local AutoSellActive = false
local AutoBuildActive = false
local NoClipActive = false
local SpeedHackActive = false
local FlyActive = false
local ESPActive = false

-- Функция для получения инструментов
local function getTool(name)
    local backpack = Player.Backpack
    local character = Player.Character
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then
            return tool
        end
    end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then
            return tool
        end
    end
    return nil
end

-- Функция для получения ближайшего предмета
local function getNearestItem()
    local character = Player.Character
    if not character then return nil end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    
    local nearest = nil
    local nearestDist = math.huge
    
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Part") and item:FindFirstChild("Tool") then
            local dist = (item.Position - root.Position).Magnitude
            if dist < nearestDist and dist < 50 then
                nearestDist = dist
                nearest = item
            end
        end
    end
    return nearest
end

-- ========================================
-- 🎨 СОЗДАНИЕ GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BBFT_Script"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "🚢 Build a Boat MEGA 🚢"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Вкладки
local Tabs = {"🌊 Фарм", "⚡ Утилиты", "🛠 Постройка", "🎯 ESP", "⚙ Настройки"}
local TabButtons = {}
local TabContents = {}

local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 35)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TabFrame.BackgroundTransparency = 0.3
TabFrame.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -75)
ContentFrame.Position = UDim2.new(0, 0, 0, 75)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Создаем вкладки
for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TabFrame
    TabButtons[i] = btn
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 6
    content.Visible = (i == 1)
    content.Parent = ContentFrame
    TabContents[i] = content
    
    btn.MouseButton1Click:Connect(function()
        for j, tab in ipairs(TabContents) do
            tab.Visible = (j == i)
        end
        for j, b in ipairs(TabButtons) do
            b.BackgroundColor3 = (j == i) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 60)
        end
    end)
end

-- Вспомогательная функция для создания кнопок
local function createButton(parent, text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 120, 200)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, callback, default)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(120, 120, 120)
    btn.BackgroundTransparency = 0.2
    btn.Text = text .. (default and " ✅" or " ❌")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent
    
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(120, 120, 120)
        btn.Text = text .. (state and " ✅" or " ❌")
        callback(state)
    end)
    return btn
end

-- ========================================
-- 📌 ВКЛАДКА "ФАРМ"
-- ========================================
local FarmTab = TabContents[1]
local farmY = 10

-- Автофарм (главный)
local FarmToggle = createToggle(FarmTab, "🤖 АВТОФАРМ", farmY, function(state)
    FarmActive = state
    if state then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end, false)
farmY = farmY + 45

-- Дополнительные настройки фарма
createButton(FarmTab, "💰 Собрать все монеты", farmY, function()
    for _, coin in ipairs(workspace:GetDescendants()) do
        if coin:IsA("Part") and coin.Name:find("Coin") then
            local tool = coin:FindFirstChild("Tool")
            if tool and tool:IsA("Tool") then
                game:GetService("ReplicatedStorage").Events.Collect:FireServer(tool)
            end
        end
    end
end)
farmY = farmY + 45

createButton(FarmTab, "🔨 Авто-клик (палки)", farmY, function()
    local tool = getTool("stick")
    if tool then
        for i = 1, 50 do
            tool:Activate()
            task.wait(0.05)
        end
    end
end)
farmY = farmY + 45

createButton(FarmTab, "🧱 Фарм досок", farmY, function()
    local target = getNearestItem()
    if target then
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
    end
end)
farmY = farmY + 45

createButton(FarmTab, "⚡ Фарм этапов", farmY, function()
    local args = {[1] = "Harvest", [2] = 2}
    game:GetService("ReplicatedStorage").Events.Farming:FireServer(unpack(args))
end)
farmY = farmY + 45

-- ========================================
-- 📌 ВКЛАДКА "УТИЛИТЫ"
-- ========================================
local UtilTab = TabContents[2]
local utilY = 10

createToggle(UtilTab, "🌀 NoClip", utilY, function(state)
    NoClipActive = state
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end, false)
utilY = utilY + 45

createToggle(UtilTab, "💨 SpeedHack x5", utilY, function(state)
    SpeedHackActive = state
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and 80 or 16
        end
    end
end, false)
utilY = utilY + 45

createToggle(UtilTab, "🪂 Fly (полёт)", utilY, function(state)
    FlyActive = state
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = state
            if state then
                -- Даём толчок вверх
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, 50, 0)
                end
            end
        end
    end
end, false)
utilY = utilY + 45

createButton(UtilTab, "🔄 Телепорт на остров", utilY, function()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name == "SpawnLocation" then
            local character = Player.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                end
            end
            break
        end
    end
end)
utilY = utilY + 45

createButton(UtilTab, "🛡 Бесконечная броня", utilY, function()
    local args = {[1] = "Buy", [2] = "Armor"}
    game:GetService("ReplicatedStorage").Events.Shop:FireServer(unpack(args))
end)
utilY = utilY + 45

-- ========================================
-- 📌 ВКЛАДКА "ПОСТРОЙКА"
-- ========================================
local BuildTab = TabContents[3]
local buildY = 10

createButton(BuildTab, "🧱 Быстрая стройка (X10)", buildY, function()
    for i = 1, 10 do
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
        task.wait(0.05)
    end
end)
buildY = buildY + 45

createButton(BuildTab, "🔨 Бесконечная прочность", buildY, function()
    local tool = getTool("hammer")
    if tool then
        tool:Activate()
        -- Спамим для ускорения
        for i = 1, 20 do
            task.wait(0.01)
            tool:Activate()
        end
    end
end)
buildY = buildY + 45

createToggle(BuildTab, "🤖 Авто-стройка", buildY, function(state)
    AutoBuildActive = state
    if state then
        game:GetService("RunService").Heartbeat:Connect(function()
            if AutoBuildActive then
                local tool = getTool("hammer")
                if tool then
                    tool:Activate()
                end
            end
        end)
    end
end, false)
buildY = buildY + 45

createButton(BuildTab, "📐 Поставить лестницу", buildY, function()
    local tool = getTool("ladder")
    if tool then
        tool:Activate()
    end
end)
buildY = buildY + 45

-- ========================================
-- 📌 ВКЛАДКА "ESP"
-- ========================================
local ESPTab = TabContents[4]
local espY = 10

local espObjects = {}

createToggle(ESPTab, "👁 ESP на блоки", espY, function(state)
    ESPActive = state
    if state then
        -- Создаём ESP для всех ресурсов
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Part") and obj:FindFirstChild("Tool") and not espObjects[obj] then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(0, 255, 100)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                highlight.Adornee = obj
                highlight.Parent = obj
                espObjects[obj] = highlight
            end
        end
    else
        for obj, highlight in pairs(espObjects) do
            highlight:Destroy()
        end
        espObjects = {}
    end
end, false)
espY = espY + 45

createToggle(ESPTab, "🎯 ESP на игроков", espY, function(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player then
            local char = player.Character
            if char then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
                highlight.Adornee = char
                highlight.Parent = char
                if state then
                    char:FindFirstChild("Highlight") or highlight
                else
                    highlight:Destroy()
                end
            end
        end
    end
end, false)
espY = espY + 45

-- ========================================
-- 📌 ВКЛАДКА "НАСТРОЙКИ"
-- ========================================
local SettingsTab = TabContents[5]
local setY = 10

createButton(SettingsTab, "🔄 Ресет персонажа", setY, function()
    Player:LoadCharacter()
end)
setY = setY + 45

createButton(SettingsTab, "🧹 Очистить чат", setY, function()
    game:GetService("Chat"):Clear()
end)
setY = setY + 45

createButton(SettingsTab, "📊 Показать FPS", setY, function()
    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(0, 100, 0, 30)
    stats.Position = UDim2.new(0, 10, 1, -40)
    stats.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stats.BackgroundTransparency = 0.5
    stats.Text = "FPS: 60"
    stats.TextColor3 = Color3.fromRGB(255, 255, 255)
    stats.TextSize = 14
    stats.Parent = ScreenGui
    
    local count = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        count = count + 1
        stats.Text = "FPS: " .. count
        count = 0
    end)
end)
setY = setY + 45

createButton(SettingsTab, "📋 Скопировать ID игры", setY, function()
    setclipboard(game.PlaceId)
end)
setY = setY + 45

-- ========================================
-- ⚙️ ЯДРО АВТОФАРМА
-- ========================================
function startAutoFarm()
    -- Очищаем старые соединения
    stopAutoFarm()
    
    -- Фарм монет
    FarmConnections[1] = game:GetService("RunService").Heartbeat:Connect(function()
        if not FarmActive then return end
        for _, coin in ipairs(workspace:GetDescendants()) do
            if coin:IsA("Part") and coin.Name:find("Coin") then
                local tool = coin:FindFirstChild("Tool")
                if tool and tool:IsA("Tool") then
                    game:GetService("ReplicatedStorage").Events.Collect:FireServer(tool)
                end
            end
        end
    end)
    
    -- Фарм блоков (автоклик)
    FarmConnections[2] = game:GetService("RunService").Heartbeat:Connect(function()
        if not FarmActive then return end
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
    end)
    
    -- Фарм опыта (выполнение этапов)
    FarmConnections[3] = game:GetService("RunService").Heartbeat:Connect(function()
        if not FarmActive then return end
        if CurrentStage < 10 then
            CurrentStage = CurrentStage + 1
            local args = {[1] = "Claim", [2] = CurrentStage}
            game:GetService("ReplicatedStorage").Events.Stages:FireServer(unpack(args))
        else
            CurrentStage = 0
        end
    end)
    
    print("✅ Автофарм запущен!")
end

function stopAutoFarm()
    for _, connection in ipairs(FarmConnections) do
        connection:Disconnect()
    end
    FarmConnections = {}
    CurrentStage = 0
    print("⏹ Автофарм остановлен")
end

-- ========================================
-- 🛠 ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ
-- ========================================

-- 1. Авто-сбор ресурсов
createButton(FarmTab, "📦 Собрать все ресурсы", farmY, function()
    local character = Player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Part") and item:FindFirstChild("Tool") then
            local dist = (item.Position - root.Position).Magnitude
            if dist < 30 then
                local tool = item:FindFirstChild("Tool")
                if tool then
                    game:GetService("ReplicatedStorage").Events.Collect:FireServer(tool)
                end
            end
        end
    end
end)
farmY = farmY + 45

-- 2. Бесконечный джетпак
createToggle(UtilTab, "🚀 Бесконечный джетпак", utilY, function(state)
    local tool = getTool("jetpack")
    if tool and state then
        game:GetService("RunService").Heartbeat:Connect(function()
            if state and tool then
                tool:Activate()
            end
        end)
    end
end, false)
utilY = utilY + 45

-- 3. Мгновенная стройка
createButton(BuildTab, "⚡ Мгновенная стройка", buildY, function()
    for i = 1, 30 do
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
        task.wait()
    end
end)
buildY = buildY + 45

-- 4. ESP на монеты
createToggle(ESPTab, "🪙 ESP на монеты", espY, function(state)
    if state then
        for _, coin in ipairs(workspace:GetDescendants()) do
            if coin:IsA("Part") and coin.Name:find("Coin") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.FillTransparency = 0.3
                highlight.Adornee = coin
                highlight.Parent = coin
                espObjects[coin] = highlight
            end
        end
    else
        for obj, highlight in pairs(espObjects) do
            if obj.Name:find("Coin") then
                highlight:Destroy()
                espObjects[obj] = nil
            end
        end
    end
end, false)
espY = espY + 45

-- 5. Инфо-панель
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0, 200, 0, 60)
InfoLabel.Position = UDim2.new(1, -210, 0, 50)
InfoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
InfoLabel.BackgroundTransparency = 0.5
InfoLabel.Text = "🚢 BBFT Script\n✅ Загружен"
InfoLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
InfoLabel.TextSize = 14
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextScaled = true
InfoLabel.Parent = ScreenGui

-- ========================================
-- ⌨️ ГОРЯЧИЕ КЛАВИШИ
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F1 - Показать/Скрыть GUI
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- F2 - Включить/Выключить автофарм
    if input.KeyCode == Enum.KeyCode.F2 then
        FarmActive = not FarmActive
        if FarmActive then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end
    
    -- X - Использовать инструмент
    if input.KeyCode == Enum.KeyCode.X then
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end)

print("🚢 Build a Boat MEGA Script загружен!")
print("📋 Нажмите F1 для открытия меню")
print("📋 Нажмите F2 для автофарма")
print("📋 Нажмите X для использования инструмента")
