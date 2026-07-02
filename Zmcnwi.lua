-- ============================================
-- ВИЗУАЛЬНАЯ ШУТКА (ТОЛЬКО ДЛЯ ВАС!)
-- НИКТО НЕ СТРАДАЕТ! ТОЛЬКО ВИЗУАЛ!
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Ждём персонажа
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================
-- СОЗДАЁМ GUI (ТОЛЬКО ДЛЯ ВАС)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JokePanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- ГЛАВНАЯ ПАНЕЛЬ
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ ТЮРЬМА 2.0 ⚠️"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- ТЕКСТ С ИМЕНЕМ ИГРОКА
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

-- ============================================
-- КНОПКА 1: ОТБЫТЬ СРОК (ВИЗУАЛЬНО!)
-- ============================================

local PrisonBtn = Instance.new("TextButton")
PrisonBtn.Size = UDim2.new(0.4, -10, 0, 50)
PrisonBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
PrisonBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
PrisonBtn.Text = "🔗 ОТБЫТЬ\nСРОК"
PrisonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrisonBtn.TextSize = 16
PrisonBtn.Font = Enum.Font.GothamBold
PrisonBtn.BorderSizePixel = 0
PrisonBtn.Parent = MainFrame

local PrisonCorner = Instance.new("UICorner")
PrisonCorner.CornerRadius = UDim.new(0, 8)
PrisonCorner.Parent = PrisonBtn

-- ============================================
-- КНОПКА 2: ПОБЕГ (ВИЗУАЛЬНО!)
-- ============================================

local EscapeBtn = Instance.new("TextButton")
EscapeBtn.Size = UDim2.new(0.4, -10, 0, 50)
EscapeBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
EscapeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
EscapeBtn.Text = "💨 ПОБЕГ"
EscapeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EscapeBtn.TextSize = 18
EscapeBtn.Font = Enum.Font.GothamBold
EscapeBtn.BorderSizePixel = 0
EscapeBtn.Parent = MainFrame

local EscapeCorner = Instance.new("UICorner")
EscapeCorner.CornerRadius = UDim.new(0, 8)
EscapeCorner.Parent = EscapeBtn

-- ============================================
-- КНОПКА ЗАКРЫТИЯ
-- ============================================

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
end)

-- ============================================
-- ФУНКЦИЯ: ВИЗУАЛЬНАЯ ТЮРЬМА
-- ============================================

local function visualPrison()
    print("🔗 Визуальная тюрьма активирована!")
    
    -- Скрываем меню
    MainFrame.Visible = false
    
    -- Создаём визуальную клетку (только для вас!)
    local cage = Instance.new("Part")
    cage.Size = Vector3.new(6, 6, 6)
    cage.Position = RootPart.Position + Vector3.new(0, 0, 0)
    cage.Anchored = true
    cage.CanCollide = false
    cage.Material = Enum.Material.Glass
    cage.Transparency = 0.5
    cage.Color = Color3.fromRGB(255, 0, 0)
    cage.Parent = workspace
    
    -- Текст над головой (только вы видите!)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = RootPart
    billboard.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛓️ В ТЮРЬМЕ! 10 СЕКУНД"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 20
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    -- Считаем 10 секунд (визуально)
    for i = 10, 1, -1 do
        label.Text = "⛓️ В ТЮРЬМЕ! " .. i .. " СЕКУНД"
        task.wait(1)
    end
    
    -- Убираем визуал
    cage:Destroy()
    billboard:Destroy()
    
    print("✅ Визуальная тюрьма закончилась!")
    
    -- Возвращаем меню
    MainFrame.Visible = true
end

-- ============================================
-- ФУНКЦИЯ: ВИЗУАЛЬНЫЙ ПОБЕГ
-- ============================================

local function visualEscape()
    print("💨 Визуальный побег активирован!")
    
    -- Скрываем меню
    MainFrame.Visible = false
    
    -- Текст над головой
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
    
    -- Визуальные шарики (красиво!)
    for i = 1, 20 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(1, 1, 1)
        ball.Shape = Enum.PartType.Ball
        ball.Color = Color3.fromRGB(255, 200, 0)
        ball.Material = Enum.Material.Neon
        ball.Position = RootPart.Position + Vector3.new(math.random(-10, 10), math.random(-5, 5), math.random(-10, 10))
        ball.Anchored = true
        ball.CanCollide = false
        ball.Parent = workspace
        
        -- Летят к игроку (визуально)
        local startPos = ball.Position
        for j = 1, 20 do
            local newPos = startPos:Lerp(RootPart.Position, j/20)
            ball.Position = newPos
            task.wait(0.02)
        end
        
        ball:Destroy()
        
        -- Взрыв (визуальный!)
        if i % 5 == 0 then
            local explosion = Instance.new("Explosion")
            explosion.Position = RootPart.Position
            explosion.BlastRadius = 3
            explosion.ExplosionType = Enum.ExplosionType.NoCraters
            explosion.Parent = workspace
            task.wait(0.1)
        end
    end
    
    billboard:Destroy()
    
    print("💨 Побег завершён!")
    
    -- Текст "ПОБЕДИЛ!"
    local winText = Instance.new("TextLabel")
    winText.Size = UDim2.new(0, 300, 0, 80)
    winText.Position = UDim2.new(0.5, -150, 0.3, 0)
    winText.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    winText.BackgroundTransparency = 0.2
    winText.Text = "🏆 ПОБЕГ УДАЛСЯ!"
    winText.TextColor3 = Color3.fromRGB(255, 255, 255)
    winText.TextSize = 40
    winText.Font = Enum.Font.GothamBold
    winText.Parent = LocalPlayer.PlayerGui
    
    task.wait(2)
    winText:Destroy()
    
    -- Возвращаем меню
    MainFrame.Visible = true
end

-- ============================================
-- ПРИВЯЗКА К КНОПКАМ
-- ============================================

PrisonBtn.MouseButton1Click:Connect(function()
    visualPrison()
end)

EscapeBtn.MouseButton1Click:Connect(function()
    visualEscape()
end)

-- ============================================
-- ПЛАВАЮЩАЯ КНОПКА ДЛЯ ОТКРЫТИЯ
-- ============================================

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

-- Если скрыли меню через крестик, показываем кнопку
local originalClose = CloseBtn.MouseButton1Click
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

-- ============================================
-- ЗАПУСК
-- ============================================

print("=========================================")
print("⚠️ ВИЗУАЛЬНАЯ ШУТКА ЗАГРУЖЕНА!")
print("✅ ТОЛЬКО ДЛЯ ВАС! НИКТО НЕ СТРАДАЕТ!")
print("✅ Нажмите кнопки для визуального эффекта")
print("=========================================")
