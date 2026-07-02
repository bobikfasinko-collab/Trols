-- ============================================
-- БОЛЬШАЯ ТЮРЬМА + ПОДКУП (ДЛЯ DELTA)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character

local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if not Humanoid or not RootPart then
    print("❌ Ошибка: персонаж не найден")
    return
end

local playerName = LocalPlayer.DisplayName or LocalPlayer.Name
local isInPrison = false
local oldSpeed = 16

-- Удаляем старый GUI
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("BigPrison")
if oldGui then oldGui:Destroy() end

-- ============================================
-- СОЗДАЁМ GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BigPrison"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ БОЛЬШАЯ ТЮРЬМА"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Msg = Instance.new("TextLabel")
Msg.Size = UDim2.new(1, -20, 0, 30)
Msg.Position = UDim2.new(0, 10, 0, 40)
Msg.BackgroundTransparency = 1
Msg.Text = "🔴 " .. playerName .. " спиздил жевачку!"
Msg.TextColor3 = Color3.fromRGB(255, 200, 0)
Msg.TextSize = 14
Msg.Font = Enum.Font.GothamBold
Msg.Parent = MainFrame

-- Кнопка 1: Отбыть
local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(0.8, 0, 0, 35)
Btn1.Position = UDim2.new(0.1, 0, 0.28, 0)
Btn1.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
Btn1.Text = "🔗 ОТБЫТЬ (10 сек)"
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn1.TextSize = 14
Btn1.Font = Enum.Font.GothamBold
Btn1.BorderSizePixel = 0
Btn1.Parent = MainFrame

local Btn1Corner = Instance.new("UICorner")
Btn1Corner.CornerRadius = UDim.new(0, 8)
Btn1Corner.Parent = Btn1

-- Кнопка 2: Побег
local Btn2 = Instance.new("TextButton")
Btn2.Size = UDim2.new(0.8, 0, 0, 35)
Btn2.Position = UDim2.new(0.1, 0, 0.48, 0)
Btn2.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
Btn2.Text = "💨 ПОБЕГ (10 сек)"
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn2.TextSize = 14
Btn2.Font = Enum.Font.GothamBold
Btn2.BorderSizePixel = 0
Btn2.Parent = MainFrame

local Btn2Corner = Instance.new("UICorner")
Btn2Corner.CornerRadius = UDim.new(0, 8)
Btn2Corner.Parent = Btn2

-- Кнопка 3: Подкуп (НОВАЯ)
local Btn3 = Instance.new("TextButton")
Btn3.Size = UDim2.new(0.8, 0, 0, 35)
Btn3.Position = UDim2.new(0.1, 0, 0.68, 0)
Btn3.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
Btn3.Text = "💰 ПОДКУП"
Btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn3.TextSize = 14
Btn3.Font = Enum.Font.GothamBold
Btn3.BorderSizePixel = 0
Btn3.Parent = MainFrame

local Btn3Corner = Instance.new("UICorner")
Btn3Corner.CornerRadius = UDim.new(0, 8)
Btn3Corner.Parent = Btn3

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 50, 0, 50)
ShowBtn.Position = UDim2.new(0, 10, 1, -70)
ShowBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ShowBtn.Text = "⚠️"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 24
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
ShowBtn.Visible = false
ShowBtn.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowBtn.Visible = true
end)

ShowBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowBtn.Visible = false
end)

-- ============================================
-- ФУНКЦИЯ ТЮРЬМЫ (БОЛЬШАЯ)
-- ============================================

local function goToPrison(seconds)
    if isInPrison then return end
    isInPrison = true
    MainFrame.Visible = false
    ShowBtn.Visible = false
    
    print("🔒 В тюрьму на " .. seconds .. " сек")
    
    oldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.PlatformStand = true
    
    local prisonPos = RootPart.Position + Vector3.new(0, 3, 0)
    RootPart.CFrame = CFrame.new(prisonPos)
    
    -- БОЛЬШАЯ КЛЕТКА (6x6)
    local cageSize = 6
    local cage = Instance.new("Part")
    cage.Size = Vector3.new(cageSize, cageSize, cageSize)
    cage.Position = prisonPos
    cage.Anchored = true
    cage.CanCollide = true
    cage.Material = Enum.Material.Glass
    cage.Transparency = 0.2
    cage.Color = Color3.fromRGB(255, 0, 0)
    cage.Parent = workspace
    
    local walls = {}
    local wallPositions = {
        {cageSize/2, 0, 0},
        {-cageSize/2, 0, 0},
        {0, 0, cageSize/2},
        {0, 0, -cageSize/2}
    }
    
    for _, pos in ipairs(wallPositions) do
        local wall = Instance.new("Part")
        wall.Size = Vector3.new(0.3, cageSize, cageSize)
        wall.Position = prisonPos + Vector3.new(pos[1], pos[2], pos[3])
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.Glass
        wall.Transparency = 0.4
        wall.Color = Color3.fromRGB(200, 0, 0)
        wall.Parent = workspace
        table.insert(walls, wall)
    end
    
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(cageSize, 0.3, cageSize)
    floor.Position = prisonPos + Vector3.new(0, -cageSize/2, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Material = Enum.Material.Glass
    floor.Transparency = 0.5
    floor.Color = Color3.fromRGB(100, 0, 0)
    floor.Parent = workspace
    table.insert(walls, floor)
    
    local roof = floor:Clone()
    roof.Position = prisonPos + Vector3.new(0, cageSize/2, 0)
    roof.Parent = workspace
    table.insert(walls, roof)
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 40)
    bill.Adornee = RootPart
    bill.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛓️ В ТЮРЬМЕ!"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    for i = seconds, 1, -1 do
        if not isInPrison then break end
        label.Text = "⛓️ " .. i .. "с"
        task.wait(1)
    end
    
    if isInPrison then
        isInPrison = false
        cage:Destroy()
        for _, w in ipairs(walls) do w:Destroy() end
        bill:Destroy()
        
        Humanoid.WalkSpeed = oldSpeed
        Humanoid.JumpPower = 50
        Humanoid.PlatformStand = false
        
        local ray = Ray.new(RootPart.Position, Vector3.new(0, -100, 0))
        local hit, groundPos = workspace:FindPartOnRay(ray, Character)
        if groundPos then
            RootPart.CFrame = CFrame.new(groundPos + Vector3.new(0, 2, 0))
        end
        
        print("✅ Освобождён!")
        MainFrame.Visible = true
    end
end

-- ============================================
-- ФУНКЦИЯ ПОБЕГА С ШАРИКАМИ
-- ============================================

local function escapeWithBalls()
    if isInPrison then return end
    isInPrison = true
    MainFrame.Visible = false
    ShowBtn.Visible = false
    
    print("💨 ПОБЕГ! Шарики бегут 10 секунд!")
    
    oldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.PlatformStand = true
    
    local ray = Ray.new(RootPart.Position, Vector3.new(0, -100, 0))
    local hit, groundPos = workspace:FindPartOnRay(ray, Character)
    if groundPos then
        RootPart.CFrame = CFrame.new(groundPos + Vector3.new(0, 2, 0))
    end
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 40)
    bill.Adornee = RootPart
    bill.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "💨 ПОБЕГ!"
    label.TextColor3 = Color3.fromRGB(0, 255, 0)
    label.TextSize = 30
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    local balls = {}
    local caught = false
    
    for i = 1, 10 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(1.5, 1.5, 1.5)
        ball.Shape = Enum.PartType.Ball
        ball.Color = Color3.fromRGB(255, 200, 0)
        ball.Material = Enum.Material.Neon
        ball.Anchored = false
        ball.CanCollide = false
        
        local angle = (i / 10) * 2 * math.pi
        local radius = 15
        local x = RootPart.Position.X + radius * math.cos(angle)
        local z = RootPart.Position.Z + radius * math.sin(angle)
        local y = RootPart.Position.Y - 1
        
        ball.Position = Vector3.new(x, y, z)
        ball.Parent = workspace
        table.insert(balls, ball)
        
        task.spawn(function()
            while ball and not caught do
                local dir = (RootPart.Position - ball.Position).Unit
                ball.Velocity = Vector3.new(dir.X * 3, 0, dir.Z * 3)
                task.wait(0.05)
            end
        end)
    end
    
    local startTime = tick()
    
    repeat
        task.wait(0.1)
        
        for _, ball in ipairs(balls) do
            if ball and (ball.Position - RootPart.Position).Magnitude < 2.5 then
                caught = true
                break
            end
        end
        
        local timeLeft = 10 - math.floor(tick() - startTime)
        if timeLeft > 0 then
            label.Text = "💨 ПОБЕГ! " .. timeLeft .. "с"
        end
        
    until caught or (tick() - startTime) > 10
    
    for _, ball in ipairs(balls) do
        ball:Destroy()
    end
    bill:Destroy()
    
    if caught then
        print("💥 Шарики догнали! Взрыв!")
        
        local exp = Instance.new("Explosion")
        exp.Position = RootPart.Position
        exp.BlastRadius = 5
        exp.ExplosionType = Enum.ExplosionType.NoCraters
        exp.Parent = workspace
        
        local boomText = Instance.new("TextLabel")
        boomText.Size = UDim2.new(0, 300, 0, 50)
        boomText.Position = UDim2.new(0.5, -150, 0.3, 0)
        boomText.BackgroundTransparency = 0.2
        boomText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        boomText.Text = "💥 ВАС ПОЙМАЛИ!"
        boomText.TextColor3 = Color3.fromRGB(255, 255, 255)
        boomText.TextSize = 30
        boomText.Font = Enum.Font.GothamBold
        boomText.Parent = ScreenGui
        
        task.wait(1)
        boomText:Destroy()
        
        isInPrison = false
        goToPrison(10)
    else
        print("🏃 УСПЕШНЫЙ ПОБЕГ!")
        
        local winText = Instance.new("TextLabel")
        winText.Size = UDim2.new(0, 400, 0, 60)
        winText.Position = UDim2.new(0.5, -200, 0.3, 0)
        winText.BackgroundTransparency = 0.2
        winText.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        winText.Text = "🏃 " .. playerName .. " вы збежали от закона!"
        winText.TextColor3 = Color3.fromRGB(255, 255, 255)
        winText.TextSize = 24
        winText.Font = Enum.Font.GothamBold
        winText.Parent = ScreenGui
        
        isInPrison = false
        Humanoid.WalkSpeed = oldSpeed
        Humanoid.JumpPower = 50
        Humanoid.PlatformStand = false
        
        task.wait(3)
        winText:Destroy()
        MainFrame.Visible = true
    end
end

-- ============================================
-- ФУНКЦИЯ ПОДКУПА
-- ============================================

local function bribe()
    if isInPrison then return end
    
    MainFrame.Visible = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 160)
    frame.Position = UDim2.new(0.5, -140, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 200, 100)
    frame.ClipsDescendants = true
    frame.Parent = ScreenGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 15)
    frameCorner.Parent = frame
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -20, 0, 50)
    txt.Position = UDim2.new(0, 10, 0, 15)
    txt.BackgroundTransparency = 1
    txt.Text = "💰 Шарик: дай 10 манет и отпущу."
    txt.TextColor3 = Color3.fromRGB(255, 255, 200)
    txt.TextSize = 17
    txt.Font = Enum.Font.GothamBold
    txt.TextWrapped = true
    txt.Parent = frame
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, -10, 0, 40)
    yesBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    yesBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    yesBtn.Text = "✅ ДА"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 18
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.BorderSizePixel = 0
    yesBtn.Parent = frame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, -10, 0, 40)
    noBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
    noBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    noBtn.Text = "❌ НЕТ"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 18
    noBtn.Font = Enum.Font.GothamBold
    noBtn.BorderSizePixel = 0
    noBtn.Parent = frame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn
    
    yesBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
        
        -- Шарик пинает игрока (взлетает)
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        force.Velocity = Vector3.new(0, 40, 0)
        force.Parent = RootPart
        task.wait(0.5)
        force:Destroy()
        
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(0, 250, 0, 40)
        msg.Position = UDim2.new(0.5, -125, 0.3, 0)
        msg.BackgroundTransparency = 0.2
        msg.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        msg.Text = "🤑 Тебя отпустили!"
        msg.TextColor3 = Color3.fromRGB(255, 255, 255)
        msg.TextSize = 20
        msg.Font = Enum.Font.GothamBold
        msg.Parent = ScreenGui
        
        task.wait(2)
        msg:Destroy()
        MainFrame.Visible = true
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
        
        local exp = Instance.new("Explosion")
        exp.Position = RootPart.Position
        exp.BlastRadius = 5
        exp.ExplosionType = Enum.ExplosionType.NoCraters
        exp.Parent = workspace
        
        local boomText = Instance.new("TextLabel")
        boomText.Size = UDim2.new(0, 300, 0, 50)
        boomText.Position = UDim2.new(0.5, -150, 0.3, 0)
        boomText.BackgroundTransparency = 0.2
        boomText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        boomText.Text = "💥 ТЫ ОТКАЗАЛСЯ!"
        boomText.TextColor3 = Color3.fromRGB(255, 255, 255)
        boomText.TextSize = 30
        boomText.Font = Enum.Font.GothamBold
        boomText.Parent = ScreenGui
        
        task.wait(1)
        boomText:Destroy()
        
        goToPrison(10)
    end)
end

-- ============================================
-- ПРИВЯЗКА КНОПОК
-- ============================================

Btn1.MouseButton1Click:Connect(function()
    goToPrison(10)
end)

Btn2.MouseButton1Click:Connect(function()
    escapeWithBalls()
end)

Btn3.MouseButton1Click:Connect(function()
    bribe()
end)

print("=========================================")
print("⚠️ БОЛЬШАЯ ТЮРЬМА + ПОДКУП")
print("✅ 3 кнопки: Отбыть | Побег | Подкуп")
print("✅ Ты внутри клетки!")
print("✅ Шарики бегут за тобой 10 секунд")
print("=========================================")
