--[[
    🚢 MEGA SCRIPT для Build a Boat for Treasure (BBFT)
    📱 ОПТИМИЗИРОВАН ДЛЯ ТЕЛЕФОНА!
    ✅ Большие кнопки
    ✅ Простое управление
    ✅ Автофарм
--]]

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- ========================================
-- ПЕРЕМЕННЫЕ
-- ========================================
local FarmActive = false
local FarmConnections = {}
local NoClipActive = false
local SpeedHackActive = false
local FlyActive = false
local AutoClickActive = false

-- ========================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ========================================
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
-- 📱 СОЗДАНИЕ БОЛЬШОГО МОБИЛЬНОГО GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BBFT_Mobile"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- ГЛАВНОЕ МЕНЮ (выдвижное)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Заголовок с кнопкой закрытия
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Title.Text = "🚢 BBFT MEGA (ТЕЛЕФОН)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 45, 0, 45)
CloseBtn.Position = UDim2.new(1, -50, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 24
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Контент с прокруткой
local Scrolling = Instance.new("ScrollingFrame")
Scrolling.Size = UDim2.new(1, 0, 1, -55)
Scrolling.Position = UDim2.new(0, 0, 0, 55)
Scrolling.BackgroundTransparency = 1
Scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
Scrolling.ScrollBarThickness = 8
Scrolling.Parent = MainFrame

-- Создание большой кнопки для телефона
local function createBigButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 120, 220)
    btn.BackgroundTransparency = 0.15
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Scrolling
    btn.MouseButton1Click:Connect(callback)
    
    -- Анимация нажатия
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.15}):Play()
    end)
    return btn
end

-- Создание большой кнопки-переключателя
local function createBigToggle(text, yPos, callback, default)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(150, 50, 50)
    btn.BackgroundTransparency = 0.15
    btn.Text = text .. (default and " ✅" or " ❌")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Scrolling
    
    local state = default or false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(150, 50, 50)
        btn.Text = text .. (state and " ✅" or " ❌")
        callback(state)
    end)
    return btn
end

-- ========================================
-- 📌 СОЗДАНИЕ КНОПОК
-- ========================================
local yPos = 10

-- === АВТОФАРМ ===
createBigToggle("🤖 АВТОФАРМ", yPos, function(state)
    FarmActive = state
    if state then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end, false)
yPos = yPos + 65

createBigButton("💰 Собрать монеты", yPos, function()
    for _, coin in ipairs(workspace:GetDescendants()) do
        if coin:IsA("Part") and coin.Name:find("Coin") then
            local tool = coin:FindFirstChild("Tool")
            if tool and tool:IsA("Tool") then
                game:GetService("ReplicatedStorage").Events.Collect:FireServer(tool)
            end
        end
    end
end)
yPos = yPos + 65

createBigButton("🔨 Авто-клик (50 раз)", yPos, function()
    local tool = getTool("stick")
    if tool then
        for i = 1, 50 do
            tool:Activate()
            task.wait(0.05)
        end
    end
end)
yPos = yPos + 65

createBigButton("🧱 Собрать ресурсы", yPos, function()
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
yPos = yPos + 65

-- === УТИЛИТЫ ===
createBigToggle("🌀 NoClip", yPos, function(state)
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
yPos = yPos + 65

createBigToggle("💨 SpeedHack x5", yPos, function(state)
    SpeedHackActive = state
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and 80 or 16
        end
    end
end, false)
yPos = yPos + 65

createBigToggle("🪂 Fly (полёт)", yPos, function(state)
    FlyActive = state
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = state
            if state then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, 50, 0)
                end
            end
        end
    end
end, false)
yPos = yPos + 65

createBigButton("🔄 На остров", yPos, function()
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
yPos = yPos + 65

-- === ПОСТРОЙКА ===
createBigButton("🧱 Быстрая стройка x20", yPos, function()
    for i = 1, 20 do
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
        task.wait(0.03)
    end
end)
yPos = yPos + 65

createBigButton("🛠 Авто-стройка (вкл)", yPos, function()
    AutoClickActive = not AutoClickActive
    if AutoClickActive then
        game:GetService("RunService").Heartbeat:Connect(function()
            if AutoClickActive then
                local tool = getTool("hammer")
                if tool then
                    tool:Activate()
                end
            end
        end)
    end
end)
yPos = yPos + 65

createBigButton("📐 Поставить лестницу", yPos, function()
    local tool = getTool("ladder")
    if tool then
        tool:Activate()
    end
end)
yPos = yPos + 65

-- === НАСТРОЙКИ ===
createBigButton("🔄 Ресет", yPos, function()
    Player:LoadCharacter()
end)
yPos = yPos + 65

createBigButton("🛡 Броня", yPos, function()
    local args = {[1] = "Buy", [2] = "Armor"}
    game:GetService("ReplicatedStorage").Events.Shop:FireServer(unpack(args))
end)
yPos = yPos + 65

-- Обновляем размер Canvas
Scrolling.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- ⚙️ КНОПКА БЫСТРОГО ДОСТУПА (ПЛАВАЮЩАЯ)
-- ========================================
local FloatingBtn = Instance.new("ImageButton")
FloatingBtn.Size = UDim2.new(0, 70, 0, 70)
FloatingBtn.Position = UDim2.new(0, 10, 0.9, 0)
FloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FloatingBtn.BackgroundTransparency = 0.2
FloatingBtn.Image = "rbxassetid://6023426926" -- Иконка меню
FloatingBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Parent = ScreenGui

-- Перетаскивание кнопки (для телефона)
local dragging = false
local dragStart = nil
local startPos = nil

FloatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingBtn.Position
    end
end)

FloatingBtn.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        FloatingBtn.Position = UDim2.new(
            startPos.X.Scale + delta.X / ScreenGui.AbsoluteSize.X,
            0,
            startPos.Y.Scale + delta.Y / ScreenGui.AbsoluteSize.Y,
            0
        )
    end
end)

FloatingBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        -- Если не было перетаскивания, открываем меню
        if (input.Position - dragStart).Magnitude < 10 then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- ========================================
-- ⚙️ ЯДРО АВТОФАРМА
-- ========================================
function startAutoFarm()
    stopAutoFarm()
    
    -- Фарм монет
    FarmConnections[1] = RunService.Heartbeat:Connect(function()
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
    
    -- Автоклик
    FarmConnections[2] = RunService.Heartbeat:Connect(function()
        if not FarmActive then return end
        local tool = getTool("hammer")
        if tool then
            tool:Activate()
        end
    end)
    
    print("✅ Автофарм запущен!")
end

function stopAutoFarm()
    for _, connection in ipairs(FarmConnections) do
        connection:Disconnect()
    end
    FarmConnections = {}
    print("⏹ Автофарм остановлен")
end

-- ========================================
-- ⌨️ ГОРЯЧИЕ КЛАВИШИ (ДЛЯ КЛАВИАТУРЫ)
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        MainFrame.Visible = not MainFrame.Visible
    end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        FarmActive = not FarmActive
        if FarmActive then
            startAutoFarm()
        else
            stopAutoFarm()
        end
    end
end)

-- ========================================
-- 🎨 ИНФО-ПАНЕЛЬ
-- ========================================
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(0, 180, 0, 40)
Info.Position = UDim2.new(1, -190, 0, 10)
Info.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Info.BackgroundTransparency = 0.5
Info.Text = "📱 BBFT MEGA\nНажми 🟦 для меню"
Info.TextColor3 = Color3.fromRGB(0, 255, 100)
Info.TextSize = 13
Info.Font = Enum.Font.Gotham
Info.TextScaled = true
Info.Parent = ScreenGui

print("🚢 Build a Boat MEGA (Телефон) загружен!")
print("📱 Нажмите синюю кнопку для меню")
print("📱 Нажмите F1 для меню (если есть клава)")
print("📱 Нажмите F2 для автофарма")
