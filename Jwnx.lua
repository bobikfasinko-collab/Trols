-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Создаем главную панель
local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0, 240, 0, 500)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.CanvasSize = UDim2.new(0, 0, 0, 1000)
frame.ScrollBarThickness = 6
frame.Parent = screenGui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = frame

-- Создаем заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "🚀 КОКОС-КОНТРОЛЬ"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.Bold
title.Parent = frame

local function createButton(text, color, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 45)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorners = Instance.new("UICorner")
    btnCorners.CornerRadius = UDim.new(0, 8)
    btnCorners.Parent = btn
    
    -- Эффект наведения
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = color + Color3.fromRGB(30, 30, 30)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = color
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- === ТВОЯ НОВАЯ КНОПКА "KOKO" ===
createButton("💥 KOKO (ВЗРЫВ КОКОСОВ)", Color3.fromRGB(255, 0, 100), 45, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- 1. ВЗРЫВ (эффект)
    local explosion = Instance.new("Explosion")
    explosion.Position = hrp.Position
    explosion.BlastRadius = 15
    explosion.BlastPressure = 0
    explosion.ExplosionType = Enum.ExplosionType.NoCraters
    explosion.Parent = workspace
    
    -- 2. ОТБРАСЫВАЕМ ИГРОКА
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(5000, 5000, 5000)
    bodyVel.Velocity = Vector3.new(
        math.random(-50, 50),
        math.random(50, 100),
        math.random(-50, 50)
    )
    bodyVel.Parent = hrp
    
    -- 3. СОЗДАЕМ 30 КОКОСОВ ВОКРУГ
    local coconuts = {}
    for i = 1, 30 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1.5, 1.5, 1.5)
        local angle = (i / 30) * math.pi * 2
        local radius = math.random(5, 20)
        local height = math.random(-5, 10)
        
        coconut.Position = hrp.Position + Vector3.new(
            math.cos(angle) * radius,
            height,
            math.sin(angle) * radius
        )
        coconut.Shape = Enum.PartType.Ball
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.Color = Color3.fromRGB(139, 69, 19)
        coconut.CanCollide = false
        coconut.Anchored = true
        coconut.Parent = workspace
        table.insert(coconuts, coconut)
        
        -- Анимация вылета
        local targetPos = coconut.Position + Vector3.new(
            math.random(-20, 20),
            math.random(10, 30),
            math.random(-20, 20)
        )
        local tween = game:GetService("TweenService"):Create(coconut, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPos,
            Size = Vector3.new(2, 2, 2)
        })
        tween:Play()
    end
    
    -- 4. РАДУЖНЫЙ ЭФФЕКТ ДЛЯ КОКОСОВ
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 8 do
            local hue = (tick() - startTime) / 8
            for _, coconut in pairs(coconuts) do
                if coconut and coconut.Parent then
                    local color = Color3.fromHSV((hue + coconut.Name) % 1, 1, 1)
                    coconut.Color = color
                    -- Пульсация
                    local scale = 1 + math.sin((tick() - startTime) * 6 + coconut.Name) * 0.2
                    coconut.Size = Vector3.new(1.5 * scale, 1.5 * scale, 1.5 * scale)
                end
            end
            wait(0.03)
        end
        
        -- Удаляем кокосы
        for _, coconut in pairs(coconuts) do
            if coconut and coconut.Parent then
                local tween = game:GetService("TweenService"):Create(coconut, TweenInfo.new(0.3), {
                    Transparency = 1,
                    Size = Vector3.new(0.1, 0.1, 0.1)
                })
                tween:Play()
                wait(0.02)
                coconut:Destroy()
            end
        end
    end)
    
    -- 5. УБИРАЕМ СКОРОСТЬ
    wait(1.5)
    bodyVel:Destroy()
    
    -- Уведомление
    game.StarterGui:SetCore("SendNotification", {
        Title = "💥 KOKO ВЗРЫВ!",
        Text = "Ты взорвался и создал 30 кокосов!",
        Duration = 3
    })
end)

-- === ОСТАЛЬНЫЕ ФУНКЦИИ ===

-- 1. КОКОС-РАДУГА (улучшенная)
createButton("🥥 КОКОС-РАДУГА", Color3.fromRGB(139, 69, 19), 100, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Создаем 40 кокосов
    local coconuts = {}
    for i = 1, 40 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1.5, 1.5, 1.5)
        coconut.Position = hrp.Position + Vector3.new(
            math.random(-70, 70),
            math.random(5, 40),
            math.random(-70, 70)
        )
        coconut.Shape = Enum.PartType.Ball
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.CanCollide = false
        coconut.Anchored = true
        coconut.Parent = workspace
        table.insert(coconuts, coconut)
    end
    
    -- Радужный эффект
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 10 do
            local hue = (tick() - startTime) / 10
            for _, coconut in pairs(coconuts) do
                if coconut and coconut.Parent then
                    coconut.Color = Color3.fromHSV((hue + coconut.Name) % 1, 1, 1)
                    local scale = 1 + math.sin((tick() - startTime) * 5 + coconut.Name) * 0.15
                    coconut.Size = Vector3.new(1.5 * scale, 1.5 * scale, 1.5 * scale)
                end
            end
            wait(0.03)
        end
        
        for _, coconut in pairs(coconuts) do
            coconut:Destroy()
        end
    end)
    
    -- Улетаем
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVel.Velocity = Vector3.new(0, 200, 0)
    bodyVel.Parent = hrp
    wait(2)
    bodyVel:Destroy()
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🥥 КОКОС-РАДУГА",
        Text = "40 кокосов и ты в космосе!",
        Duration = 3
    })
end)

-- 2. АВТОФАРМ
local farming = false
local farmConnection
local farmBtn

farmBtn = createButton("💰 АВТОФАРМ (ВКЛ)", Color3.fromRGB(0, 128, 0), 155, function()
    farming = not farming
    
    if farming then
        farmBtn.Text = "💰 АВТОФАРМ (ВЫКЛ)"
        farmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        farmConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local nearestCoin = nil
            local nearestDist = 100
            
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and (part.Name:lower():find("coin") or part.Name:lower():find("монет") or part.Name:lower():find("money")) then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestCoin = part
                    end
                end
            end
            
            if nearestCoin then
                hrp.CFrame = CFrame.new(nearestCoin.Position + Vector3.new(0, 2, 0))
            end
        end)
    else
        farmBtn.Text = "💰 АВТОФАРМ (ВКЛ)"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- 3. СУПЕР-ПРЫЖОК
createButton("🦘 СУПЕР-ПРЫЖОК", Color3.fromRGB(255, 140, 0), 210, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.1)
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(5000, 5000, 5000)
    bodyVel.Velocity = Vector3.new(0, 250, 0)
    bodyVel.Parent = hrp
    wait(1.5)
    bodyVel:Destroy()
end)

-- 4. ТЕЛЕПОРТ В СЛУЧАЙНОЕ МЕСТО
createButton("🌀 ТЕЛЕПОРТ", Color3.fromRGB(75, 0, 130), 265, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = CFrame.new(
        math.random(-150, 150),
        math.random(5, 30),
        math.random(-150, 150)
    )
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌀 ТЕЛЕПОРТ",
        Text = "Ты телепортирован!",
        Duration = 2
    })
end)

-- 5. НЕВИДИМОСТЬ
local invisible = false
local invisBtn

invisBtn = createButton("👻 НЕВИДИМОСТЬ", Color3.fromRGB(128, 0, 128), 320, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    invisible = not invisible
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = invisible and 1 or 0
        end
    end
    
    invisBtn.Text = invisible and "👻 ВИДИМЫЙ" or "👻 НЕВИДИМОСТЬ"
end)

-- 6. ФАРМ ДЕРЕВЬЕВ
createButton("🌴 ПОСАДИТЬ 20 ДЕРЕВЬЕВ", Color3.fromRGB(0, 150, 0), 375, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 20 do
        local tree = Instance.new("Part")
        tree.Size = Vector3.new(1, 6, 1)
        tree.Position = hrp.Position + Vector3.new(math.random(-30, 30), 2, math.random(-30, 30))
        tree.Color = Color3.fromRGB(34, 139, 34)
        tree.Material = Enum.Material.Wood
        tree.Anchored = true
        tree.Parent = workspace
        
        local leaves = Instance.new("Part")
        leaves.Size = Vector3.new(4, 2, 4)
        leaves.Position = tree.Position + Vector3.new(0, 4, 0)
        leaves.Color = Color3.fromRGB(0, 200, 0)
        leaves.Shape = Enum.PartType.Ball
        leaves.Anchored = true
        leaves.Parent = workspace
        
        local coin = Instance.new("Part")
        coin.Size = Vector3.new(0.5, 0.1, 0.5)
        coin.Position = tree.Position + Vector3.new(0, 5, 0)
        coin.Color = Color3.fromRGB(255, 215, 0)
        coin.Shape = Enum.PartType.Cylinder
        coin.Anchored = true
        coin.Name = "Coin"
        coin.Parent = workspace
        
        wait(0.05)
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌴 20 ДЕРЕВЬЕВ",
        Text = "Лес с монетами посажен!",
        Duration = 2
    })
end)

-- 7. ИЗМЕНЕНИЕ РАЗМЕРА
local scale = 1
createButton("📏 КАРЛИК/ВЕЛИКАН", Color3.fromRGB(255, 20, 147), 430, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    scale = scale == 1 and 0.3 or 1
    local newScale = scale == 0.3 and 0.3 or 3.33
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * newScale
        end
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = scale == 0.3 and "🐭 КАРЛИК!" or "🦍 ВЕЛИКАН!",
        Text = scale == 0.3 and "Ты стал маленьким!" or "Ты стал огромным!",
        Duration = 2
    })
end)

-- 8. МАГНИТ
local magnetActive = false
local magnetBtn
local magnetConnection

magnetBtn = createButton("🧲 МАГНИТ (ВКЛ)", Color3.fromRGB(255, 215, 0), 485, function()
    magnetActive = not magnetActive
    
    if magnetActive then
        magnetBtn.Text = "🧲 МАГНИТ (ВЫКЛ)"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        magnetConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not magnetActive then return end
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and (part.Name:lower():find("coin") or part.Name:lower():find("монет")) then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < 40 then
                        part.Position = part.Position + (hrp.Position - part.Position).Unit * 5
                    end
                end
            end
        end)
    else
        magnetBtn.Text = "🧲 МАГНИТ (ВКЛ)"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

-- 9. ПОЛЕТ
local flying = false
local flyBtn
local flyConnection

flyBtn = createButton("✈️ РЕЖИМ ПОЛЕТА", Color3.fromRGB(0, 150, 255), 540, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    flying = not flying
    
    if flying then
        flyBtn.Text = "✈️ ПОЛЕТ (ВЫКЛ)"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        humanoid.PlatformStand = true
        
        flyConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if not flying then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then
                    hrp.Velocity = hrp.CFrame.LookVector * 70
                elseif input.KeyCode == Enum.KeyCode.S then
                    hrp.Velocity = -hrp.CFrame.LookVector * 70
                elseif input.KeyCode == Enum.KeyCode.A then
                    hrp.Velocity = -hrp.CFrame.RightVector * 70
                elseif input.KeyCode == Enum.KeyCode.D then
                    hrp.Velocity = hrp.CFrame.RightVector * 70
                elseif input.KeyCode == Enum.KeyCode.Space then
                    hrp.Velocity = Vector3.new(0, 70, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    hrp.Velocity = Vector3.new(0, -70, 0)
                end
            end
        end)
    else
        flyBtn.Text = "✈️ РЕЖИМ ПОЛЕТА"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        humanoid.PlatformStand = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
    end
end)

-- 10. СОЗДАТЬ МОНЕТЫ
createButton("🪙 СОЗДАТЬ 50 МОНЕТ", Color3.fromRGB(255, 215, 0), 595, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 50 do
        local coin = Instance.new("Part")
        coin.Size = Vector3.new(1, 0.2, 1)
        coin.Position = hrp.Position + Vector3.new(
            math.random(-50, 50),
            math.random(2, 10),
            math.random(-50, 50)
        )
        coin.Shape = Enum.PartType.Cylinder
        coin.Color = Color3.fromRGB(255, 215, 0)
        coin.Material = Enum.Material.Neon
        coin.Anchored = true
        coin.Name = "Coin"
        coin.Parent = workspace
        
        -- Эффект вращения
        spawn(function()
            local spin = 0
            while coin and coin.Parent do
                spin = spin + 0.1
                coin.CFrame = coin.CFrame * CFrame.Angles(0, 0.1, 0)
                wait(0.05)
            end
        end)
        wait(0.02)
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🪙 50 МОНЕТ",
        Text = "Монеты созданы вокруг тебя!",
        Duration = 2
    })
end)

-- 11. КОКОС-ДОЖДЬ
createButton("🌧️ КОКОС-ДОЖДЬ", Color3.fromRGB(0, 100, 200), 650, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 80 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1, 1, 1)
        coconut.Position = hrp.Position + Vector3.new(
            math.random(-60, 60),
            math.random(30, 70),
            math.random(-60, 60)
        )
        coconut.Shape = Enum.PartType.Ball
        coconut.Color = Color3.fromRGB(139, 69, 19)
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.CanCollide = false
        coconut.Anchored = false
        coconut.Parent = workspace
        
        -- Гравитация для дождя
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1000, 1000, 1000)
        bodyVel.Velocity = Vector3.new(0, -30, 0)
        bodyVel.Parent = coconut
        
        wait(0.02)
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌧️ КОКОС-ДОЖДЬ",
        Text = "Кокосы падают с неба!",
        Duration = 2
    })
end)

-- 12. ФАРМ СКОРОСТИ
local speedActive = false
local speedBtn

speedBtn = createButton("⚡ РЕЖИМ СКОРОСТИ", Color3.fromRGB(255, 255, 0), 705, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    speedActive = not speedActive
    
    if speedActive then
        speedBtn.Text = "⚡ СКОРОСТЬ (ВЫКЛ)"
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        humanoid.WalkSpeed = 100
    else
        speedBtn.Text = "⚡ РЕЖИМ СКОРОСТИ"
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        humanoid.WalkSpeed = 16
    end
end)

-- 13. ИНВЕРТИРОВАТЬ УПРАВЛЕНИЕ
local inverted = false
createButton("🔄 ИНВЕРТИЯ", Color3.fromRGB(255, 100, 0), 760, function()
    inverted = not inverted
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if not inverted then return end
        if input.KeyCode == Enum.KeyCode.W then
            input.KeyCode = Enum.KeyCode.S
        elseif input.KeyCode == Enum.KeyCode.S then
            input.KeyCode = Enum.KeyCode.W
     
