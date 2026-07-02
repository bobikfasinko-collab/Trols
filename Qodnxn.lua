-- ============================================
-- ⚠️ ТЮРЬМА 6.0 (РАБОЧАЯ ВЕРСИЯ ДЛЯ DELTA)
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

repeat task.wait() until game:IsLoaded()
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character

local Character = LocalPlayer.Character
local Humanoid = Character:FindFirstChild("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

if not Humanoid or not RootPart then
    print("❌ Ошибка: персонаж не найден")
    return
end

local isInPrison = false
local isGameOver = false
local oldSpeed = 16
local playerName = LocalPlayer.DisplayName or LocalPlayer.Name

-- Удаляем старый GUI
local oldGui = LocalPlayer.PlayerGui:FindFirstChild("PrisonGUI")
if oldGui then oldGui:Destroy() end

-- ============================================
-- GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrisonGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
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
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
Title.Text = "⚠️ ТЮРЬМА ⚠️"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

local Msg = Instance.new("TextLabel")
Msg.Size = UDim2.new(1, -20, 0, 40)
Msg.Position = UDim2.new(0, 10, 0, 45)
Msg.BackgroundTransparency = 1
Msg.Text = "🔴 " .. playerName .. " спиздил жевачку!"
Msg.TextColor3 = Color3.fromRGB(255, 200, 0)
Msg.TextSize = 16
Msg.Font = Enum.Font.GothamBold
Msg.Parent = MainFrame

local Btn1 = Instance.new("TextButton")
Btn1.Size = UDim2.new(0.45, -5, 0, 40)
Btn1.Position = UDim2.new(0.03, 0, 0.3, 0)
Btn1.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
Btn1.Text = "🔗 ОТБЫТЬ"
Btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn1.TextSize = 15
Btn1.Font = Enum.Font.GothamBold
Btn1.BorderSizePixel = 0
Btn1.Parent = MainFrame

local Btn1Corner = Instance.new("UICorner")
Btn1Corner.CornerRadius = UDim.new(0, 8)
Btn1Corner.Parent = Btn1

local Btn2 = Instance.new("TextButton")
Btn2.Size = UDim2.new(0.45, -5, 0, 40)
Btn2.Position = UDim2.new(0.52, 0, 0.3, 0)
Btn2.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
Btn2.Text = "💨 ПОБЕГ"
Btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn2.TextSize = 15
Btn2.Font = Enum.Font.GothamBold
Btn2.BorderSizePixel = 0
Btn2.Parent = MainFrame

local Btn2Corner = Instance.new("UICorner")
Btn2Corner.CornerRadius = UDim.new(0, 8)
Btn2Corner.Parent = Btn2

local Btn3 = Instance.new("TextButton")
Btn3.Size = UDim2.new(0.45, -5, 0, 40)
Btn3.Position = UDim2.new(0.03, 0, 0.55, 0)
Btn3.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
Btn3.Text = "💰 ПОДКУП"
Btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn3.TextSize = 15
Btn3.Font = Enum.Font.GothamBold
Btn3.BorderSizePixel = 0
Btn3.Parent = MainFrame

local Btn3Corner = Instance.new("UICorner")
Btn3Corner.CornerRadius = UDim.new(0, 8)
Btn3Corner.Parent = Btn3

local Btn4 = Instance.new("TextButton")
Btn4.Size = UDim2.new(0.45, -5, 0, 40)
Btn4.Position = UDim2.new(0.52, 0, 0.55, 0)
Btn4.BackgroundColor3 = Color3.fromRGB(150, 50, 150)
Btn4.Text = "🙈 ИГНОР"
Btn4.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn4.TextSize = 15
Btn4.Font = Enum.Font.GothamBold
Btn4.BorderSizePixel = 0
Btn4.Parent = MainFrame

local Btn4Corner = Instance.new("UICorner")
Btn4Corner.CornerRadius = UDim.new(0, 8)
Btn4Corner.Parent = Btn4

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

local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 50, 0, 50)
ShowBtn.Position = UDim2.new(0, 15, 1, -70)
ShowBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ShowBtn.Text = "⚠️"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 25
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
-- ФУНКЦИЯ ТЮРЬМЫ
-- ============================================

local function createPrison(seconds, permanent)
    if isInPrison then return end
    isInPrison = true
    MainFrame.Visible = false
    ShowBtn.Visible = false
    
    oldSpeed = Humanoid.WalkSpeed
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.PlatformStand = true
    
    local pos = RootPart.Position + Vector3.new(0, 3, 0)
    RootPart.CFrame = CFrame.new(pos)
    
    local cage = Instance.new("Part")
    cage.Size = Vector3.new(4, 4, 4)
    cage.Position = pos
    cage.Anchored = true
    cage.CanCollide = true
    cage.Material = Enum.Material.Glass
    cage.Transparency = 0.3
    cage.Color = Color3.fromRGB(255, 0, 0)
    cage.Parent = workspace
    
    local walls = {}
    for i = 1, 4 do
        local w = Instance.new("Part")
        w.Size = Vector3.new(0.2, 4, 4)
        w.Position = pos + Vector3.new(2 * (i%2==0 and 1 or -1), 0, 2 * (i>2 and 1 or -1))
        w.Anchored = true
        w.CanCollide = true
        w.Material = Enum.Material.Glass
        w.Transparency = 0.5
        w.Color = Color3.fromRGB(200, 0, 0)
        w.Parent = workspace
        table.insert(walls, w)
    end
    
    local floor = Instance.new("Part")
    floor.Size = Vector3.new(4, 0.2, 4)
    floor.Position = pos + Vector3.new(0, -2, 0)
    floor.Anchored = true
    floor.CanCollide = true
    floor.Material = Enum.Material.Glass
    floor.Transparency = 0.5
    floor.Color = Color3.fromRGB(100, 0, 0)
    floor.Parent = workspace
    table.insert(walls, floor)
    
    local roof = floor:Clone()
    roof.Position = pos + Vector3.new(0, 2, 0)
    roof.Parent = workspace
    table.insert(walls, roof)
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.Adornee = RootPart
    bill.Parent = RootPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = permanent and "⛓️ ПОЖИЗНЕННОЕ!" or "⛓️ В ТЮРЬМЕ! " .. seconds .. "с"
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.TextSize = 24
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    if permanent then
        print("🔒 Вечная тюрьма!")
        return
    end
    
    task.spawn(function()
        for i = seconds, 1, -1 do
            if not isInPrison then break end
            label.Text = "⛓️ В ТЮРЬМЕ! " .. i .. "с"
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
            local hit, pos2 = workspace:FindPartOnRay(ray, Character)
            if pos2 then RootPart.CFrame = CFrame.new(pos2 + Vector3.new(0, 2, 0)) end
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
    
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 200, 0, 50)
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
        ball.Position = Vector3.new(x, RootPart.Position.Y - 2, z)
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
    
    local start = tick()
    repeat
        task.wait(0.1)
        for _, ball in ipairs(balls) do
            if ball and (ball.Position - RootPart.Position).Magnitude < 3 then
                caught = true
                break
            end
        end
    until caught or tick() - start > 10
    
    for _, ball in ipairs(balls) do ball:Destroy() end
    bill:Destroy()
    
    if caught then
        local exp = Instance.new("Explosion")
        exp.Position = RootPart.Position
        exp.BlastRadius = 5
        exp.ExplosionType = Enum.ExplosionType.NoCraters
        exp.Parent = workspace
        task.wait(0.5)
        isGameOver = true
        createPrison(0, true)
    else
        local win = Instance.new("TextLabel")
        win.Size = UDim2.new(0, 350, 0, 60)
        win.Position = UDim2.new(0.5, -175, 0.3, 0)
        win.BackgroundTransparency = 0.2
        win.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        win.Text = "🏃 " .. playerName .. " вы збежали!"
        win.TextColor3 = Color3.fromRGB(255, 255, 255)
        win.TextSize = 26
        win.Font = Enum.Font.GothamBold
        win.Parent = ScreenGui
        task.wait(3)
        win:Destroy()
        MainFrame.Visible = true
    end
end

-- ============================================
-- ФУНКЦИЯ ПОДКУПА
-- ============================================

local function bribe()
    if isInPrison or isGameOver then return end
    MainFrame.Visible = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 160)
    frame.Position = UDim2.new(0.5, -150, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 200, 100)
    frame.ClipsDescendants = true
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = frame
    
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
    
    local yes = Instance.new("TextButton")
    yes.Size = UDim2.new(0.4, -10, 0, 40)
    yes.Position = UDim2.new(0.05, 0, 0.65, 0)
    yes.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    yes.Text = "✅ ДА"
    yes.TextColor3 = Color3.fromRGB(255, 255, 255)
    yes.TextSize = 18
    yes.Font = Enum.Font.GothamBold
    yes.BorderSizePixel = 0
    yes.Parent = frame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yes
    
    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0.4, -10, 0, 40)
    no.Position = UDim2.new(0.55, 0, 0.65, 0)
    no.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    no.Text = "❌ НЕТ"
    no.TextColor3 = Color3.fromRGB(255, 255, 255)
    no.TextSize = 18
    no.Font = Enum.Font.GothamBold
    no.BorderSizePixel = 0
    no.Parent = frame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = no
    
    yes.MouseButton1Click:Connect(function()
        frame:Destroy()
        local force = Instance.new("BodyVelocity")
        force.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        force.Velocity = Vector3.new(0, 30, 0)
        force.Parent = RootPart
        task.wait(0.5)
        force:Destroy()
        MainFrame.Visible = true
    end)
    
    no.MouseButton1Click:Connect(function()
        frame:Destroy()
        local exp = Instance.new("Explosion")
        exp.Position = RootPart.Position
        exp.BlastRadius = 5
        exp.ExplosionType = Enum.ExplosionType.NoCraters
        exp.Parent = workspace
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
    
    local frame1 = Instance.new("Frame")
    frame1.Size = UDim2.new(0, 300, 0, 160)
    frame1.Position = UDim2.new(0.5, -150, 0.5, -80)
    frame1.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    frame1.BackgroundTransparency = 0
    frame1.BorderSizePixel = 2
    frame1.BorderColor3 = Color3.fromRGB(150, 50, 150)
    frame1.ClipsDescendants = true
    frame1.Parent = ScreenGui
    
    local corner1 = Instance.new("UICorner")
    corner1.CornerRadius = UDim.new(0, 15)
    corner1.Parent = frame1
    
    local txt1 = Instance.new("TextLabel")
    txt1.Size = UDim2.new(1, -20, 0, 50)
    txt1.Position = UDim2.new(0, 10, 0, 15)
    txt1.BackgroundTransparency = 1
    txt1.Text = "🙈 " .. playerName .. " не Игнорь!"
    txt1.TextColor3 = Color3.fromRGB(255, 200, 200)
    txt1.TextSize = 20
    txt1.Font = Enum.Font.GothamBold
    txt1.TextWrapped = true
    txt1.Parent = frame1
    
    local ans1 = Instance.new("TextButton")
    ans1.Size = UDim2.new(0.4, -10, 0, 40)
    ans1.Position = UDim2.new(0.05, 0, 0.65, 0)
    ans1.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    ans1.Text = "💬 ОТВЕТИТЬ"
    ans1.TextColor3 = Color3.fromRGB(255, 255, 255)
    ans1.TextSize = 14
    ans1.Font = Enum.Font.GothamBold
    ans1.BorderSizePixel = 0
    ans1.Parent = frame1
    
    local ans1Corner = Instance.new("UICorner")
    ans1Corner.CornerRadius = UDim.new(0, 8)
    ans1Corner.Parent = ans1
    
    local fck1 = Instance.new("TextButton")
    fck1.Size = UDim2.new(0.4, -10, 0, 40)
    fck1.Position = UDim2.new(0.55, 0, 0.65, 0)
    fck1.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fck1.Text = "😤 ПОХУЙ"
    fck1.TextColor3 = Color3.fromRGB(255, 255, 255)
    fck1.TextSize = 14
    fck1.Font = Enum.Font.GothamBold
    fck1.BorderSizePixel = 0
    fck1.Parent = frame1
    
    local fck1Corner = Instance.new("UICorner")
    fck1Corner.CornerRadius = UDim.new(0, 8)
    fck1Corner.Parent = fck1
    
    ans1.MouseButton1Click:Connect(function()
        frame1:Destroy()
        local dlg = Instance.new("Frame")
        dlg.Size = UDim2.new(0, 300, 0, 120)
        dlg.Position = UDim2.new(0.5, -150, 0.5, -60)
        dlg.BackgroundColor3 = Color3.fromRGB(20, 30, 20)
        dlg.BackgroundTransparency = 0
        dlg.BorderSizePixel = 2
        dlg.BorderColor3 = Color3.fromRGB(0, 200, 100)
        dlg.ClipsDescendants = true
        dlg.Parent = ScreenGui
        
        local dlgCorner = Instance.new("UICorner")
        dlgCorner.CornerRadius = UDim.new(0, 15)
        dlgCorner.Parent = dlg
        
        local dlgTxt = Instance.new("TextLabel")
        dlgTxt.Size = UDim2.new(1, -20, 0, 50)
        dlgTxt.Position = UDim2.new(0, 10, 0, 10)
        dlgTxt.BackgroundTransparency = 1
        dlgTxt.Text = "💬 Шарик: за то что игнорил посижу дольше!"
        dlgTxt.TextColor3 = Color3.fromRGB(255, 255, 200)
        dlgTxt.TextSize = 16
        dlgTxt.Font = Enum.Font.GothamBold
        dlgTxt.TextWrapped = true
        dlgTxt.Parent = dlg
        
        local ok = Instance.new("TextButton")
        ok.Size = UDim2.new(0.6, 0, 0, 35)
        ok.Position = UDim2.new(0.2, 0, 0.7, 0)
        ok.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        ok.Text = "😢 ОК"
        ok.TextColor3 = Color3.fromRGB(255, 255, 255)
        ok.TextSize = 18
        ok.Font = Enum.Font.GothamBold
        ok.BorderSizePixel = 0
        ok.Parent = dlg
        
        local okCorner = Instance.new("UICorner")
        okCorner.CornerRadius = UDim.new(0, 8)
        okCorner.Parent = ok
        
        ok.MouseButton1Click:Connect(function()
            dlg:Destroy()
            createPrison(15, false)
        end)
    end)
    
    fck1.MouseButton1Click:Connect(function()
        frame1:Destroy()
        
        local frame2 = Instance.new("Frame")
        frame2.Size = UDim2.new(0, 300, 0, 160)
        frame2.Position = UDim2.new(0.5, -150, 0.5, -80)
        frame2.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        frame2.BackgroundTransparency = 0
        frame2.BorderSizePixel = 2
        frame2.BorderColor3 = Color3.fromRGB(255, 0, 0)
        frame2.ClipsDescendants = true
        frame2.Parent = ScreenGui
        
        local corner2 = Instance.new("UICorner")
        corner2.CornerRadius = UDim.new(0, 15)
        corner2.Parent = frame2
        
        local txt2 = Instance.new("TextLabel")
        txt2.Size = UDim2.new(1, -20, 0, 50)
        txt2.Position = UDim2.new(0, 10, 0, 15)
        txt2.BackgroundTransparency = 1
        txt2.Text = "😡 Шарик: ответь!!"
        txt2.TextColor3 = Color3.fromRGB(255, 100, 100)
        txt2.TextSize = 22
        txt2.Font = Enum.Font.GothamBold
        txt2.TextWrapped = true
        txt2.Parent = frame2
        
        local ans2 = Instance.new("TextButton")
        ans2.Size = UDim2.new(0.4, -10, 0, 40)
        ans2.Position = UDim2.new(0.05, 0, 0.65, 0)
        ans2.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        ans2.Text = "💬 ОТВЕТИТЬ"
        ans2.TextColor3 = Color3.fromRGB(255, 255, 255)
        ans2.TextSize = 14
        ans2.Font = Enum.Font.GothamBold
        ans2.BorderSizePixel = 0
        ans2.Parent = frame2
        
        local ans2Corner = Instance.new("UICorner")
        ans2Corner.CornerRadius = UDim.new(0, 8)
        ans2Corner.Parent = ans2
        
        local ins = Instance.new("TextButton")
        ins.Size = UDim2.new(0.4, -10, 0, 40)
        ins.Position = UDim2.new(0.55, 0, 0.65, 0)
        ins.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
      
