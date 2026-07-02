-- ============================================
-- ПРОСТАЯ ТЮРЬМА ДЛЯ DELTA (РАБОЧАЯ)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ждём загрузку
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character

local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if not Humanoid or not RootPart then
    print("❌ Ошибка: персонаж не найден")
    return
end

print("✅ Скрипт запущен!")

-- ============================================
-- СОЗДАЁМ ПРОСТОЕ МЕНЮ
-- ============================================

local playerName = LocalPlayer.DisplayName or LocalPlayer.Name

-- Удаляем старый GUI
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("SimplePrison")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimplePrison"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ ТЮРЬМА"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Текст с именем
local Msg = Instance.new("TextLabel")
Msg.Size = UDim2.new(1, -20, 0, 35)
Msg.Position = UDim2.new(0, 10, 0, 40)
Msg.BackgroundTransparency = 1
Msg.Text = playerName .. " спиздил жевачку!"
Msg.TextColor3 = Color3.fromRGB(255, 200, 0)
Msg.TextSize = 15
Msg.Font = Enum.Font.GothamBold
Msg.Parent = MainFrame

-- Кнопка 1
local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(0.8, 0, 0, 35)
Btn1.Position = UDim2.new(0.1, 0, 0.3, 0)
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

-- Кнопка 2
local Btn2 = Instance.new("TextButton")
Btn2.Size = UDim2.new(0.8, 0, 0, 35)
Btn2.Position = UDim2.new(0.1, 0, 0.5, 0)
Btn2.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
Btn2.Text = "💨 ПОБЕГ"
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn2.TextSize = 14
Btn2.Font = Enum.Font.GothamBold
Btn2.BorderSizePixel = 0
Btn2.Parent = MainFrame

local Btn2Corner = Instance.new("UICorner")
Btn2Corner.CornerRadius = UDim.new(0, 8)
Btn2Corner.Parent = Btn2

-- Кнопка 3
local Btn3 = Instance.new("TextButton")
Btn3.Size = UDim2.new(0.8, 0, 0, 35)
Btn3.Position = UDim2.new(0.1, 0, 0.7, 0)
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

-- Кнопка показа
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

print("✅ Меню создано!")

-- ============================================
-- ФУНКЦИЯ ТЮРЬМЫ
-- ============================================

local function goToPrison(seconds)
    print("🔒 В тюрьму на " .. seconds .. " секунд")
    
    -- Скрываем меню
    MainFrame.Visible = false
    
    -- Запоминаем старую скорость
    local oldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    
    -- Телепорт в клетку
    local pos = RootPart.Position + Vector3.new(0, 2, 0)
    RootPart.CFrame = CFrame.new(pos)
    
    -- Создаём клетку
    local cage = Instance.new("Part")
    cage.Size = Vector3.new(4, 4, 4)
    cage.Position = pos
    cage.Anchored = true
    cage.CanCollide = true
    cage.Material = Enum.Material.Glass
    cage.Transparency = 0.3
    cage.Color = Color3.fromRGB(255, 0, 0)
    cage.Parent = workspace
    
    -- Текст над головой
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 40)
    bill.Adornee = RootPart
    bill.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⛓️ ТЮРЬМА!"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    -- Таймер
    for i = seconds, 1, -1 do
        label.Text = "⛓️ " .. i .. "с"
        task.wait(1)
    end
    
    -- Освобождение
    cage:Destroy()
    bill:Destroy()
    
    Humanoid.WalkSpeed = oldSpeed
    Humanoid.JumpPower = 50
    
    -- Телепорт на землю
    local ray = Ray.new(RootPart.Position, Vector3.new(0, -100, 0))
    local hit, groundPos = workspace:FindPartOnRay(ray, Character)
    if groundPos then
        RootPart.CFrame = CFrame.new(groundPos + Vector3.new(0, 2, 0))
    end
    
    print("✅ Освобождён!")
    MainFrame.Visible = true
end

-- ============================================
-- ПРИВЯЗКА КНОПОК
-- ============================================

Btn1.MouseButton1Click:Connect(function()
    goToPrison(10)
end)

Btn2.MouseButton1Click:Connect(function()
    print("💨 ПОБЕГ (визуальный эффект)")
    MainFrame.Visible = false
    
    -- Создаём шарики
    for i = 1, 10 do
        local ball = Instance.new("Part")
        ball.Size = Vector3.new(1, 1, 1)
        ball.Shape = Enum.PartType.Ball
        ball.Color = Color3.fromRGB(255, 200, 0)
        ball.Material = Enum.Material.Neon
        ball.Anchored = false
        ball.CanCollide = false
        ball.Position = RootPart.Position + Vector3.new(math.random(-20, 20), -2, math.random(-20, 20))
        ball.Parent = workspace
        
        -- Летят к игроку
        task.spawn(function()
            for j = 1, 10 do
                if not ball then break end
                local dir = (RootPart.Position - ball.Position).Unit
                ball.Velocity = Vector3.new(dir.X * 3, 0, dir.Z * 3)
                task.wait(0.05)
            end
            if ball then ball:Destroy() end
        end)
        
        task.wait(0.1)
    end
    
    task.wait(3)
    
    -- Победа!
    local win = Instance.new("TextLabel")
    win.Size = UDim2.new(0, 300, 0, 50)
    win.Position = UDim2.new(0.5, -150, 0.3, 0)
    win.BackgroundTransparency = 0.2
    win.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    win.Text = "🏃 " .. playerName .. " вы збежали!"
    win.TextColor3 = Color3.fromRGB(255, 255, 255)
    win.TextSize = 22
    win.Font = Enum.Font.GothamBold
    win.Parent = ScreenGui
    
    task.wait(2)
    win:Destroy()
    MainFrame.Visible = true
end)

Btn3.MouseButton1Click:Connect(function()
    print("💰 ПОДКУП")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 130)
    frame.Position = UDim2.new(0.5, -125, 0.5, -65)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 200, 100)
    frame.Parent = ScreenGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -20, 0, 40)
    txt.Position = UDim2.new(0, 10, 0, 10)
    txt.BackgroundTransparency = 1
    txt.Text = "💰 Дай 10 манет!"
    txt.TextColor3 = Color3.fromRGB(255, 255, 200)
    txt.TextSize = 16
    txt.Font = Enum.Font.GothamBold
    txt.Parent = frame
    
    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0.4, -10, 0, 35)
    yes.Position = UDim2.new(0.05, 0, 0.6, 0)
    yes.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    yes.Text = "✅ ДА"
    yes.TextColor3 = Color3.fromRGB(255, 255, 255)
    yes.TextSize = 16
    yes.Font = Enum.Font.GothamBold
    yes.BorderSizePixel = 0
    yes.Parent = frame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yes
    
    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0.4, -10, 0, 35)
    no.Position = UDim2.new(0.55, 0, 0.6, 0)
    no.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    no.Text = "❌ НЕТ"
    no.TextColor3 = Color3.fromRGB(255, 255, 255)
    no.TextSize = 16
    no.Font = Enum.Font.GothamBold
    no.BorderSizePixel = 0
    no.Parent = frame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = no
    
    yes.MouseButton1Click:Connect(function()
        frame:Destroy()
        print("✅ Подкуп удался!")
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
    
    no.MouseButton1Click:Connect(function()
        frame:Destroy()
        print("💥 ВЗРЫВ!")
        local exp = Instance.new("Explosion")
        exp.Position = RootPart.Position
        exp.BlastRadius = 5
        exp.ExplosionType = Enum.ExplosionType.NoCraters
        exp.Parent = workspace
        task.wait(1)
        goToPrison(10)
    end)
end)

print("=========================================")
print("⚠️ ТЮРЬМА (РАБОЧАЯ ВЕРСИЯ)")
print("✅ Нажмите кнопки для теста")
print("=========================================")
