-- ============================================
-- ⚠️ ТЮРЬМА 5.0 (DELTA MOBILE FIX)
-- ПОЛНОСТЬЮ ПЕРЕРАБОТАНО ДЛЯ ТЕЛЕФОНА
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Ждём загрузку
repeat task.wait() until game:IsLoaded()
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character

local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Переменные
local isInPrison = false
local isGameOver = false
local prisonTimer = 10
local oldSpeed = 16
local playerName = LocalPlayer.DisplayName or LocalPlayer.Name

-- ============================================
-- УДАЛЯЕМ СТАРЫЙ GUI
-- ============================================

local oldGui = LocalPlayer.PlayerGui:FindFirstChild("PrisonGame5")
if oldGui then oldGui:Destroy() end

-- ============================================
-- СОЗДАЁМ GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrisonGame5"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- ============================================
-- ГЛАВНОЕ МЕНЮ
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 340)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ ТЮРЬМА 5.0 ⚠️"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Текст с именем
local Message = Instance.new("TextLabel")
Message.Size = UDim2.new(1, -20, 0, 50)
Message.Position = UDim2.new(0, 10, 0, 50)
Message.BackgroundTransparency = 1
Message.Text = "🔴 " .. playerName .. " спиздил жевачку!\n45 лет в тюрьме!"
Message.TextColor3 = Color3.fromRGB(255, 200, 0)
Message.TextSize = 16
Message.Font = Enum.Font.GothamBold
Message.TextWrapped = true
Message.Parent = MainFrame

-- Кнопка 1: Отбыть срок
local PrisonBtn = Instance.new("TextButton")
PrisonBtn.Size = UDim2.new(0.45, -5, 0, 40)
PrisonBtn.Position = UDim2.new(0.03, 0, 0.35, 0)
PrisonBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
PrisonBtn.Text = "🔗 ОТБЫТЬ"
PrisonBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PrisonBtn.TextSize = 16
PrisonBtn.Font = Enum.Font.GothamBold
PrisonBtn.BorderSizePixel = 0
PrisonBtn.Parent = MainFrame

local PrisonCorner = Instance.new("UICorner")
PrisonCorner.CornerRadius = UDim.new(0, 8)
PrisonCorner.Parent = PrisonBtn

-- Кнопка 2: Побег
local EscapeBtn = Instance.new("TextButton")
EscapeBtn.Size = UDim2.new(0.45, -5, 0, 40)
EscapeBtn.Position = UDim2.new(0.52, 0, 0.35, 0)
EscapeBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
EscapeBtn.Text = "💨 ПОБЕГ"
EscapeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EscapeBtn.TextSize = 16
EscapeBtn.Font = Enum.Font.GothamBold
EscapeBtn.BorderSizePixel = 0
EscapeBtn.Parent = MainFrame

local EscapeCorner = Instance.new("UICorner")
EscapeCorner.CornerRadius = UDim.new(0, 8)
EscapeCorner.Parent = EscapeBtn

-- Кнопка 3: Подкуп
local BribeBtn = Instance.new("TextButton")
BribeBtn.Size = UDim2.new(0.45, -5, 0, 40)
BribeBtn.Position = UDim2.new(0.03, 0, 0.6, 0)
BribeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
BribeBtn.Text = "💰 ПОДКУП"
BribeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BribeBtn.TextSize = 16
BribeBtn.Font = Enum.Font.GothamBold
BribeBtn.BorderSizePixel = 0
BribeBtn.Parent = MainFrame

local BribeCorner = Instance.new("UICorner")
BribeCorner.CornerRadius = UDim.new(0, 8)
BribeCorner.Parent = BribeBtn

-- Кнопка 4: Игнор
local IgnoreBtn = Instance.new("TextButton")
IgnoreBtn.Size = UDim2.new(0.45, -5, 0, 40)
IgnoreBtn.Position = UDim2.new(0.52, 0, 0.6, 0)
IgnoreBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
IgnoreBtn.Text = "🙈 ИГНОР"
IgnoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IgnoreBtn.TextSize = 16
IgnoreBtn.Font = Enum.Font.GothamBold
IgnoreBtn.BorderSizePixel = 0
IgnoreBtn.Parent = MainFrame

local IgnoreCorner = Instance.new("UICorner")
IgnoreCorner.CornerRadius = UDim.new(0, 8)
IgnoreCorner.Parent = IgnoreBtn

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
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

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================

local function deleteGUI()
    for _, child in ipairs(ScreenGui:GetChildren()) do
        if child:IsA("Frame") and child ~= MainFrame and child ~= ShowBtn then
            child:Destroy()
        end
        if child:IsA("TextLabel") and child ~= Message and child ~= Title then
            child:Destroy()
        end
    end
end

-- ============================================
-- ФУНКЦИЯ ТЮРЬМЫ
-- ============================================

local function createPrison(seconds, permanent)
    if isInPrison then return end
    isInPrison = true
    
    -- Скрываем всё
    MainFrame.Visible = false
    ShowBtn.Visible = false
    deleteGUI()
    
    -- Блокируем движение
    oldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.PlatformStand = true
    
    -- Телепорт в клетку
    local prisonPos = RootPart.Position + Vector3.new(0, 3, 0)
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
    label.Text = permanent and "⛓️ ПОЖИЗНЕННОЕ!" or "⛓️ В ТЮРЬМЕ! " .. seconds .. "с"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    if permanent then
        print("🔒 Вечная тюрьма!")
        return
    end
    
    -- Таймер
    task.spawn(function()
        for i = seconds, 1, -1 do
            if not isInPrison then break end
            label.Text = "⛓️ В ТЮРЬМЕ! " .. i .. "с"
            task.wait(1)
        end
        
        if isInPrison then
            isInPrison = false
            cage:Destroy()
            for _, w in ipairs(walls) do
                w:Destroy()
            end
            billboard:Destroy()
            
            Humanoid.WalkSpeed = oldSpeed
            Humanoid.JumpPower = 50
            Humanoid.PlatformStand = false
            
            local ray = Ray.new(RootPart.Position, Vector3.new(0, -100, 0))
            local hit, pos = workspace:FindPartOnRay(ray, Character)
            if pos then
                RootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
            end
            
            print("✅ Освобождён!")
            MainFrame.Visible = true
        end
    end)
end

-- ============================================
-- ФУНКЦИЯ ПОБЕГА
-- ============================================

local function escapeWithBalls()
    if isInPrison or isGameOver then return end
    
    MainFrame.Visible = false
    deleteGUI()
    
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
    
    local balls = {}
    local caught = false
    
    for i = 1, 8 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(1.5, 1.5, 1.5)
        ball.Shape = Enum.PartType.Ball
        ball.Color = Color3.fromRGB(255, 200, 0)
        ball.Material = Enum.Material.Neon
        ball.Anchored = false
        ball.CanCollide = false
        
        local angle = (i/8) * 2 * math.pi
        local radius = 15
        local x = RootPart.Position.X + radius * math.cos(angle)
        local z = RootPart.Position.Z + radius * math.sin(angle)
        local y = RootPart.Position.Y - 2
        ball.Position = Vector3.new(x, y, z)
        ball.Parent = workspace
        table.insert(balls, ball)
        
        task.spawn(function()
            while ball and not caught do
                local dir = (RootPart.Position - ball.Position).Unit
                ball.Velocity = Vector3.new(dir.X * 2.5, 0, dir.Z * 2.5)
                task.wait(0.1)
            end
        end)
    end
    
    local startTime = tick()
    
    repeat
        task.wait(0.1)
        for _, ball in ipairs(balls) do
            if ball and (ball.Position - RootPart.Position).Magnitude < 3 then
                caught = true
                break
            end
        end
        if caught then break end
    until tick() - startTime > 10
    
    for _, ball in ipairs(balls) do
        ball:Destroy()
    end
    billboard:Destroy()
    
    if caught then
        local explosion = Instance.new("Explosion")
        explosion.Position = RootPart.Position
        explosion.BlastRadius = 5
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        task.wait(0.5)
        isGameOver = true
        createPrison(0, true)
    else
        local winText = Instance.new("TextLabel")
        winText.Size = UDim2.new(0, 380, 0, 80)
        winText.Position = UDim2.new(0.5, -190, 0.3, 0)
        winText.BackgroundTransparency = 0.2
        winText.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        winText.Text = "🏃 " .. playerName .. " вы збежали!"
        winText.TextColor3 = Color3.fromRGB(255, 255, 255)
        winText.TextSize = 28
        winText.Font = Enum.Font.GothamBold
        winText.Parent = ScreenGui
        task.wait(3)
        winText:Destroy()
        MainFrame.Visible = true
    end
end

-- ============================================
-- ФУНКЦИЯ ПОДКУПА
-- ============================================

local function bribe()
    if isInPrison or isGameOver then return end
    
    MainFrame.Visible = false
    deleteGUI()
    
    local bribeFrame = Instance.new("Frame")
    bribeFrame.Size = UDim2.new(0, 300, 0, 180)
    bribeFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    bribeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bribeFrame.BackgroundTransparency = 0
    bribeFrame.BorderSizePixel = 2
    bribeFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
    bribeFrame.ClipsDescendants = true
    bribeFrame.Parent = ScreenGui
    
    local bribeCorner = Instance.new("UICorner")
    bribeCorner.CornerRadius = UDim.new(0, 15)
    bribeCorner.Parent = bribeFrame
    
    local dialog = Instance.new("TextLabel")
    dialog.Size = UDim2.new(1, -20, 0, 50)
    dialog.Position = UDim2.new(0, 10, 0, 15)
    dialog.BackgroundTransparency = 1
    dialog.Text = "💰 Шарик: дай 10 манет и отпущу."
    dialog.TextColor3 = Color3.fromRGB(255, 255, 200)
    dialog.TextSize = 17
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
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        force.Velocity = Vector3.new(0, 30, 0)
        force.Parent = RootPart
        task.wait(0.5)
        force:Destroy()
        MainFrame.Visible = true
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        bribeFrame:Destroy()
        local explosion = Instance.new("Explosion")
        explosion.Position = RootPart.Position
        explosion.BlastRadius = 5
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        task.wait(0.5)
        isGameOver = true
        createPrison(0, true)
    end)
end

-- ============================================
-- ФУНКЦИЯ ИГНОРА
-- ============================================

local function ignoreFunction()
    if isInPrison or isGameOver then return end
    
    MainFrame.Visible = false
    deleteGUI()
    
    -- Меню 1
    local ignoreFrame = Instance.new("Frame")
    ignoreFrame.Size = UDim2.new(0, 300, 0, 180)
    ignoreFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
    ignoreFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    ignoreFrame.BackgroundTransparency = 0
    ignoreFrame.BorderSizePixel = 2
    ignoreFrame.BorderColor3 = Color3.fromRGB(150, 50, 150)
    ignoreFrame.ClipsDescendants = true
    ignoreFrame.Parent = ScreenGui
    
    local ignoreCorner = Instance.new("UICorner")
    ignoreCorner.CornerRadius = UDim.new(0, 15)
    ignoreCorner.Parent = ignoreFrame
    
    local ignoreText = Instance.new("TextLabel")
    ignoreText.Size = UDim2.new(1, -20, 0, 50)
    ignoreText.Position = UDim2.new(0, 10, 0, 15)
    ignoreText.BackgroundTransparency = 1
    ignoreText.Text = "🙈 " .. playerName .. " не Игнорь!"
    ignoreText.TextColor3 = Color3.fromRGB(255, 200, 200)
    ignoreText.TextSize = 20
    ignoreText.Font = Enum.Font.GothamBold
    ignoreText.TextWrapped = true
    ignoreText.Parent = ignoreFrame
    
    local answerBtn = Instance.new("TextButton")
    answerBtn.Size = UDim2.new(0.4, -10, 0, 45)
    answerBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    answerBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    answerBtn.Text = "💬 ОТВЕТИТЬ"
    answerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    answerBtn.TextSize = 14
    answerBtn.Font = Enum.Font.GothamBold
    answerBtn.BorderSizePixel = 0
    answerBtn.Parent = ignoreFrame
    
    local answerCorner = Instance.new("UICorner")
    answerCorner.CornerRadius = UDim.new(0, 8)
    answerCorner.Parent = answerBtn
    
    local fckBtn = Instance.new("TextButton")
    fckBtn.Size = UDim2.new(0.4, -10, 0, 45)
    fckBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
    fckBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fckBtn.Text = "😤 ПОХУЙ"
    fckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fckBtn.TextSize = 14
    fckBtn.Font = Enum.Font.GothamBold
    fckBtn.BorderSizePixel = 0
    fckBtn.Parent = ignoreFrame
    
    local fckCorner = Instance.new("UICorner")
    fckCorner.CornerRadius = UDim.new(0, 8)
    fckCorner.Parent = fckBtn
    
    answerBtn.MouseButton1Click:Connect(function()
        ignoreFrame:Destroy()
        
        local dialogFrame = Instance.new("Frame")
        dialogFrame.Size = UDim2.new(0, 300, 0, 120)
        dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
        dialogFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
        dialogFrame.BackgroundTransparency = 0
        dialogFrame.BorderSizePixel = 2
        dialogFrame.BorderColor3 = Color3.fromRGB(0, 200, 100)
        dialogFrame.ClipsDescendants = true
        dialogFrame.Parent = ScreenGui
        
        local dialogCorner = Instance.new("UICorner")
        dialogCorner.CornerRadius = UDim.new(0, 15)
        dialogCorner.Parent = dialogFrame
        
        local dialogText = Instance.new("TextLabel")
        dialogText.Size = UDim2.new(1, -20, 0, 50)
        dialogText.Position = UDim2.new(0, 10, 0, 10)
        dialogText.BackgroundTransparency = 1
        dialogText.Text = "💬 Шарик: за то что игнорил посижу дольше!"
        dialogText.TextColor3 = Color3.fromRGB(255, 255, 200)
        dialogText.TextSize = 16
        dialogText.Font = Enum.Font.GothamBold
        dialogText.TextWrapped = true
        dialogText.Parent = dialogFrame
        
        local okBtn = Instance.new("TextButton")
        okBtn.Size = UDim2.new(0.6, 0, 0, 35)
        okBtn.Position = UDim2.new(0.2, 0, 0.7, 0)
        okBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        okBtn.Text = "😢 ОК"
        okBtn.TextColor3 = Color3.fromRGB(255, 25
