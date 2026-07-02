-- ============================================
-- ⚠️ ТЮРЬМА ДЛЯ ОДНОГО ИГРОКА (ЛОКАЛЬНО)
-- ВНИМАНИЕ: ТОЛЬКО ДЛЯ ВАШЕГО ПЕРСОНАЖА!
-- НЕ ИСПОЛЬЗУЙТЕ В ПУБЛИЧНЫХ СЕРВЕРАХ!
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Ждём персонажа
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Переменные состояния
local prisonActive = false
local escapeTimer = 10
local isInPrison = false
local isGameOver = false

-- ============================================
-- СОЗДАЁМ GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrisonGame"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- ГЛАВНОЕ МЕНЮ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ ТЮРЬМА 3.0 ⚠️"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Текст
local playerName = LocalPlayer.DisplayName or LocalPlayer.Name
local Message = Instance.new("TextLabel")
Message.Size = UDim2.new(1, -20, 0, 60)
Message.Position = UDim2.new(0, 10, 0, 55)
Message.BackgroundTransparency = 1
Message.Text = "🔴 " .. playerName .. " спиздил жевачку!\n45 лет в тюрьме!"
Message.TextColor3 = Color3.fromRGB(255, 200, 0)
Message.TextSize = 18
Message.Font = Enum.Font.GothamBold
Message.TextWrapped = true
Message.Parent = MainFrame

-- Кнопка 1: Отбыть срок
local PrisonBtn = Instance.new("TextButton")
PrisonBtn.Size = UDim2.new(0.3, -5, 0, 45)
PrisonBtn.Position = UDim2.new(0.03, 0, 0.7, 0)
PrisonBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
PrisonBtn.Text = "🔗\nОТБЫТЬ"
PrisonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrisonBtn.TextSize = 14
PrisonBtn.Font = Enum.Font.GothamBold
PrisonBtn.BorderSizePixel = 0
PrisonBtn.Parent = MainFrame

local PrisonCorner = Instance.new("UICorner")
PrisonCorner.CornerRadius = UDim.new(0, 8)
PrisonCorner.Parent = PrisonBtn

-- Кнопка 2: Побег
local EscapeBtn = Instance.new("TextButton")
EscapeBtn.Size = UDim2.new(0.3, -5, 0, 45)
EscapeBtn.Position = UDim2.new(0.35, 0, 0.7, 0)
EscapeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
EscapeBtn.Text = "💨\nПОБЕГ"
EscapeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EscapeBtn.TextSize = 14
EscapeBtn.Font = Enum.Font.GothamBold
EscapeBtn.BorderSizePixel = 0
EscapeBtn.Parent = MainFrame

local EscapeCorner = Instance.new("UICorner")
EscapeCorner.CornerRadius = UDim.new(0, 8)
EscapeCorner.Parent = EscapeBtn

-- Кнопка 3: Подкуп
local BribeBtn = Instance.new("TextButton")
BribeBtn.Size = UDim2.new(0.3, -5, 0, 45)
BribeBtn.Position = UDim2.new(0.67, 0, 0.7, 0)
BribeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
BribeBtn.Text = "💰\nПОДКУП"
BribeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BribeBtn.TextSize = 14
BribeBtn.Font = Enum.Font.GothamBold
BribeBtn.BorderSizePixel = 0
BribeBtn.Parent = MainFrame

local BribeCorner = Instance.new("UICorner")
BribeCorner.CornerRadius = UDim.new(0, 8)
BribeCorner.Parent = BribeBtn

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
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
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

-- Плавающая кнопка
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 55, 0, 55)
ShowBtn.Position = UDim2.new(0, 15, 1, -80)
ShowBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ShowBtn.Text = "⚠️"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 30
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
ShowBtn.Visible = false
ShowBtn.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowBtn

ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

-- ============================================
-- ФУНКЦИЯ: ПОМЕСТИТЬ В ТЮРЬМУ (НАСТОЯЩАЯ)
-- ============================================

local function sendToPrison(permanent)
    if isInPrison then return end
    isInPrison = true
    prisonActive = true
    
    -- Скрываем меню
    MainFrame.Visible = false
    ShowBtn.Visible = false
    
    -- Сохраняем старую скорость
    local oldSpeed = Humanoid.WalkSpeed
    
    -- Блокируем движение
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.PlatformStand = true
    
    -- Телепортируем в клетку (в воздух)
    local prisonPos = RootPart.Position + Vector3.new(0, 5, 0)
    RootPart.CFrame = CFrame.new(prisonPos)
    
    -- Создаём клетку
    local cage = Instance.new("Part")
    cage.Size = Vector3.new(4, 4, 4)
    cage.Position = prisonPos
    cage.Anchored = true
    cage.CanCollide = true
    cage.Material = Enum.Material.Glass
    cage.Transparency = 0.3
    cage.Color = Color3.fromRGB(255, 0, 0)
    cage.Parent = workspace
    
    -- Стеклянные стены
    local walls = {}
    for i = 1, 4 do
        local wall = Instance.new("Part")
        wall.Size = Vector3.new(0.2, 4, 4)
        wall.Position = prisonPos + Vector3.new(2 * (i%2==0 and 1 or -1), 0, 2 * (i>2 and 1 or -1))
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.Glass
        wall.Transparency = 0.5
        wall.Color = Color3.fromRGB(200, 0, 0)
        wall.Parent = workspace
        table.insert(walls, wall)
    end
    -- Пол и потолок
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(4, 0.2, 4)
    floor.Position = prisonPos + Vector3.new(0, -2, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Material = Enum.Material.Glass
    floor.Transparency = 0.5
    floor.Color = Color3.fromRGB(100, 0, 0)
    floor.Parent = workspace
    table.insert(walls, floor)
    
    local roof = floor:Clone()
    roof.Position = prisonPos + Vector3.new(0, 2, 0)
    roof.Parent = workspace
    table.insert(walls, roof)
    
    -- Текст над головой
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = RootPart
    billboard.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛓️ В ТЮРЬМЕ!"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    if permanent then
        -- Вечная тюрьма
        label.Text = "⛓️ ПОЖИЗНЕННОЕ!"
        print("🔒 Вечная тюрьма активирована!")
        -- Нет выхода
    else
        -- Временная тюрьма с таймером
        for i = escapeTimer, 1, -1 do
            if not isInPrison then break end
            label.Text = "⛓️ В ТЮРЬМЕ! " .. i .. "с"
            task.wait(1)
        end
        -- Освобождение
        if isInPrison then
            releasePrisoner(cage, walls, billboard, oldSpeed)
        end
    end
end

-- ============================================
-- ФУНКЦИЯ: ОСВОБОЖДЕНИЕ
-- ============================================

local function releasePrisoner(cage, walls, billboard, oldSpeed)
    isInPrison = false
    prisonActive = false
    
    -- Убираем клетку
    cage:Destroy()
    for _, w in ipairs(walls) do
        w:Destroy()
    end
    billboard:Destroy()
    
    -- Возвращаем способности
    Humanoid.WalkSpeed = oldSpeed
    Humanoid.JumpPower = 50
    Humanoid.PlatformStand = false
    
    -- Телепортируем на землю
    local ray = Ray.new(RootPart.Position, Vector3.new(0, -100, 0))
    local hit, pos = workspace:FindPartOnRay(ray, Character)
    if pos then
        RootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
    end
    
    print("✅ Освобождён!")
    
    -- Возвращаем меню
    MainFrame.Visible = true
    ShowBtn.Visible = false
end

-- ============================================
-- ФУНКЦИЯ: ПОБЕГ С ШАРИКАМИ
-- ============================================

local function escapeWithBalls()
    if isInPrison or isGameOver then return end
    
    -- Скрываем меню
    MainFrame.Visible = false
    
    -- Текст "ПОБЕГ!"
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = RootPart
    billboard.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "💨 ПОБЕГ!"
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.TextSize = 30
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    -- Создаём шарики, бегущие по земле
    local balls = {}
    local caught = false
    
    -- Запускаем 10 шариков с разных сторон
    for i = 1, 10 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(1.5, 1.5, 1.5)
        ball.Shape = Enum.PartType.Ball
        ball.Color = Color3.fromRGB(255, 200, 0)
        ball.Material = Enum.Material.Neon
        ball.Anchored = false
        ball.CanCollide = false
        ball.BrickColor = BrickColor.new("Bright orange")
        
        -- Позиция на земле вокруг игрока
        local angle = (i/10) * 2 * math.pi
        local radius = 20
        local x = RootPart.Position.X + radius * math.cos(angle)
        local z = RootPart.Position.Z + radius * math.sin(angle)
        local y = RootPart.Position.Y - 2 -- на земле
        ball.Position = Vector3.new(x, y, z)
        ball.Parent = workspace
        table.insert(balls, ball)
        
        -- Запускаем движение к игроку (медленно)
        task.spawn(function()
            local speed = 3 -- медленно
            while ball and not caught do
                local dir = (RootPart.Position - ball.Position).Unit
                ball.Velocity = Vector3.new(dir.X * speed, 0, dir.Z * speed)
                task.wait(0.1)
            end
        end)
    end
    
    -- Таймер 10 секунд
    local startTime = tick()
    local escaped = false
    
    repeat
        task.wait(0.1)
        -- Проверяем, не коснулся ли шарик игрока
        for _, ball in ipairs(balls) do
            if ball and (ball.Position - RootPart.Position).Magnitude < 3 then
                caught = true
                break
            end
        end
        if caught then break end
    until tick() - startTime > escapeTimer
    
    -- Удаляем шарики
    for _, ball in ipairs(balls) do
        ball:Destroy()
    end
    
    billboard:Destroy()
    
    if caught then
        -- Взрыв и вечная тюрьма
        local explosion = Instance.new("Explosion")
        explosion.Position = RootPart.Position
        explosion.BlastRadius = 5
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        task.wait(0.5)
        isGameOver = true
        sendToPrison(true) -- вечная тюрьма
    else
        -- Успешный побег
        local winText = Instance.new("TextLabel")
        winText.Size = UDim2.new(0, 400, 0, 80)
        winText.Position = UDim2.new(0.5, -200, 0.3, 0)
        winText.BackgroundTransparency = 0.2
        winText.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        winText.Text = "🏃 " .. playerName .. " вы збежали от закона!"
        winText.TextColor3 = Color3.fromRGB(255, 255, 255)
        winText.TextSize = 30
        winText.Font = Enum.Font.GothamBold
        winText.Parent = ScreenGui
        task.wait(3)
        winText:Destroy()
        MainFrame.Visible = true
    end
end

-- ============================================
-- ФУНКЦИЯ: ПОДКУП
-- ============================================

local function bribe()
    if isInPrison or isGameOver then return end
    
    -- Скрываем основное меню
    MainFrame.Visible = false
    
    -- Меню подкупа
    local bribeFrame = Instance.new("Frame")
    bribeFrame.Size = UDim2.new(0, 300, 0, 200)
    bribeFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    bribeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bribeFrame.BackgroundTransparency = 0.1
    bribeFrame.BorderSizePixel = 2
    bribeFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
    bribeFrame.ClipsDescendants = true
    bribeFrame.Parent = ScreenGui
    
    local bribeCorner = Instance.new("UICorner")
    bribeCorner.CornerRadius = UDim.new(0, 15)
    bribeCorner.Parent = bribeFrame
    
    local dialog = Instance.new("TextLabel")
    dialog.Size = UDim2.new(1, -20, 0, 60)
    dialog.Position = UDim2.new(0, 10, 0, 20)
    dialog.BackgroundTransparency = 1
    dialog.Text = "💰 Шарик: дай 10 манет и отпущу."
    dialog.TextColor3 = Color3.fromRGB(255, 255, 200)
    dialog.TextSize = 18
    dialog.Font = Enum.Font.GothamBold
    dialog.TextWrapped = true
    dialog.Parent = bribeFrame
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -10, 0, 45)
    yesBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    yesBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    yesBtn.Text = "✅ ДА"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 18
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.BorderSizePixel = 0
    yesBtn.Parent = bribeFrame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -10, 0, 45)
    noBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
    noBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    noBtn.Text = "❌ НЕТ"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 18
    noBtn.Font = Enum.Font.GothamBold
    noBtn.BorderSizePixel = 0
    noBtn.Parent = bribeFrame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        bribeFrame:Destroy()
        -- Шарик пинает игрока (визуально)
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        force.Velocity = Vector3.new(0, 30, 0)
        force.Parent = RootPart
        task.wait(0.5)
        force:Destroy()
        print("💵 Подкуп удался! Шарик отпустил.")
        MainFrame.Visible = true
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        bribeFrame:Destroy()
        -- Взрыв и вечная тюрьма
        local explosion = Instance.new("Explosion")
        explosion.Position = RootPart.Position
        explosion.BlastRadius = 5
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        task.wait(0.5)
        isGameOver = true
        sendToPrison(true)
    end)
end

-- ============================================
-- ПРИВЯЗКА КНОПОК
-- ============================================

PrisonBtn.MouseButton1Click:Connect(function()
    sendToPrison(false)
end)

EscapeBtn.MouseButton1Click:Connect(function()
    escapeWithBalls()
end)

BribeBtn.MouseButton1Click:Connect(function()
    bribe()
end)

-- ============================================
-- ЗАПУСК
-- ============================================

print("=========================================")
print("⚠️ ТЮРЬМА 3.0 (ЛОКАЛЬНАЯ)")
print("✅ ТОЛЬКО ДЛЯ ВАШЕГО ПЕРСОНАЖА!")
print("✅ Вечная тюрьма при провале")
print("✅ Шарики и подкуп")
print("=========================================")
