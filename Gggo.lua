-- МОБИЛЬНАЯ ВЕРСИЯ ДЛЯ ТЕЛЕФОНА
-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Главная панель (скролл для телефона)
local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0, 280, 0, 550) -- Больше для пальцев
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.CanvasSize = UDim2.new(0, 0, 0, 1300) -- Больше места
frame.ScrollBarThickness = 8
frame.Parent = screenGui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 15)
corners.Parent = frame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 260, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "📱 КОКОС-КОНТРОЛ"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.BackgroundTransparency = 1
title.Font = Enum.Font.Bold
title.Parent = frame

-- Функция создания кнопок (увеличенные для телефона)
local function createButton(text, color, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 55) -- Большие кнопки
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorners = Instance.new("UICorner")
    btnCorners.CornerRadius = UDim.new(0, 12)
    btnCorners.Parent = btn
    
    -- Анимация нажатия для телефона
    btn.MouseButton1Down:Connect(function()
        btn.Size = UDim2.new(0, 240, 0, 50)
        wait(0.1)
        btn.Size = UDim2.new(0, 250, 0, 55)
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==== ВСЕ ФУНКЦИИ ====

-- 1. KOKO ВЗРЫВ (ТВОЯ КНОПКА)
createButton("💥 KOKO ВЗРЫВ", Color3.fromRGB(255, 0, 100), 55, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Взрыв
    local explosion = Instance.new("Explosion")
    explosion.Position = hrp.Position
    explosion.BlastRadius = 20
    explosion.BlastPressure = 0
    explosion.ExplosionType = Enum.ExplosionType.NoCraters
    explosion.Parent = workspace
    
    -- 40 кокосов вокруг
    local coconuts = {}
    for i = 1, 40 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1.5, 1.5, 1.5)
        local angle = (i / 40) * math.pi * 2
        local radius = math.random(3, 25)
        coconut.Position = hrp.Position + Vector3.new(
            math.cos(angle) * radius,
            math.random(-3, 15),
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
            math.random(-30, 30),
            math.random(10, 40),
            math.random(-30, 30)
        )
        game:GetService("TweenService"):Create(coconut, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
            Position = targetPos
        }):Play()
    end
    
    -- Радуга для кокосов
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 10 do
            local hue = (tick() - startTime) / 10
            for _, coconut in pairs(coconuts) do
                if coconut and coconut.Parent then
                    coconut.Color = Color3.fromHSV((hue + coconut.Name) % 1, 1, 1)
                    local scale = 1 + math.sin((tick() - startTime) * 6 + coconut.Name) * 0.2
                    coconut.Size = Vector3.new(1.5 * scale, 1.5 * scale, 1.5 * scale)
                end
            end
            wait(0.03)
        end
        for _, coconut in pairs(coconuts) do
            coconut:Destroy()
        end
    end)
    
    -- Отбрасывание
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(5000, 5000, 5000)
    bodyVel.Velocity = Vector3.new(math.random(-40, 40), math.random(60, 120), math.random(-40, 40))
    bodyVel.Parent = hrp
    wait(2)
    bodyVel:Destroy()
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "💥 KOKO ВЗРЫВ",
        Text = "40 кокосов разлетелись!",
        Duration = 3
    })
end)

-- 2. КОКОС-РАДУГА
createButton("🥥 КОКОС-РАДУГА", Color3.fromRGB(139, 69, 19), 120, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local coconuts = {}
    for i = 1, 50 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1.5, 1.5, 1.5)
        coconut.Position = hrp.Position + Vector3.new(
            math.random(-80, 80),
            math.random(5, 50),
            math.random(-80, 80)
        )
        coconut.Shape = Enum.PartType.Ball
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.CanCollide = false
        coconut.Anchored = true
        coconut.Parent = workspace
        table.insert(coconuts, coconut)
    end
    
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 12 do
            local hue = (tick() - startTime) / 12
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
    
    -- Полет
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVel.Velocity = Vector3.new(0, 250, 0)
    bodyVel.Parent = hrp
    wait(2.5)
    bodyVel:Destroy()
end)

-- 3. АВТОФАРМ
local farming = false
local farmConnection
local farmBtn

farmBtn = createButton("💰 АВТОФАРМ", Color3.fromRGB(0, 128, 0), 185, function()
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
        farmBtn.Text = "💰 АВТОФАРМ"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- 4. СУПЕР-ПРЫЖОК
createButton("🦘 СУПЕР-ПРЫЖОК", Color3.fromRGB(255, 140, 0), 250, function()
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
    bodyVel.Velocity = Vector3.new(0, 300, 0)
    bodyVel.Parent = hrp
    wait(1.5)
    bodyVel:Destroy()
end)

-- 5. ТЕЛЕПОРТ
createButton("🌀 ТЕЛЕПОРТ", Color3.fromRGB(75, 0, 130), 315, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = CFrame.new(
        math.random(-200, 200),
        math.random(5, 50),
        math.random(-200, 200)
    )
end)

-- 6. НЕВИДИМОСТЬ
local invisible = false
local invisBtn

invisBtn = createButton("👻 НЕВИДИМОСТЬ", Color3.fromRGB(128, 0, 128), 380, function()
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

-- 7. ПОСАДИТЬ ДЕРЕВЬЯ
createButton("🌴 30 ДЕРЕВЬЕВ", Color3.fromRGB(0, 150, 0), 445, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 30 do
        local tree = Instance.new("Part")
        tree.Size = Vector3.new(1, 6, 1)
        tree.Position = hrp.Position + Vector3.new(math.random(-40, 40), 2, math.random(-40, 40))
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
        
        wait(0.03)
    end
end)

-- 8. КАРЛИК/ВЕЛИКАН
local scale = 1
createButton("📏 КАРЛИК/ВЕЛИКАН", Color3.fromRGB(255, 20, 147), 510, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    scale = scale == 1 and 0.3 or 1
    local newScale = scale == 0.3 and 0.3 or 3.33
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * newScale
        end
    end
end)

-- 9. МАГНИТ
local magnetActive = false
local magnetBtn
local magnetConnection

magnetBtn = createButton("🧲 МАГНИТ", Color3.fromRGB(255, 215, 0), 575, function()
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
                    if dist < 50 then
                        part.Position = part.Position + (hrp.Position - part.Position).Unit * 8
                    end
                end
            end
        end)
    else
        magnetBtn.Text = "🧲 МАГНИТ"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

-- 10. ПОЛЕТ
local flying = false
local flyBtn
local flyConnection

flyBtn = createButton("✈️ РЕЖИМ ПОЛЕТА", Color3.fromRGB(0, 150, 255), 640, function()
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
        
        -- Управление через касание экрана (для телефона)
        local touchControls = {
            up = false, down = false, left = false, right = false, jump = false
        }
        
        flyConnection = game:GetService("UserInputService").TouchStarted:Connect(function(touch)
            local screenPos = touch.Position
            local screenSize = game:GetService("UserInputService").ViewportSize
            local centerX = screenSize.X / 2
            local centerY = screenSize.Y / 2
            
            -- Левая половина - движение
            if screenPos.X < centerX then
                if screenPos.Y < centerY then
                    touchControls.up = true
                else
                    touchControls.down = true
                end
            else
                if screenPos.Y < centerY then
                    touchControls.left = true
                else
                    touchControls.right = true
                end
            end
        end)
        
        game:GetService("UserInputService").TouchEnded:Connect(function()
            touchControls.up = false
            touchControls.down = false
            touchControls.left = false
            touchControls.right = false
        end)
        
        -- Движение в полете
        spawn(function()
            while flying do
                if touchControls.up then
                    hrp.Velocity = hrp.CFrame.LookVector * 80
                elseif touchControls.down then
                    hrp.Velocity = -hrp.CFrame.LookVector * 80
                elseif touchControls.left then
                    hrp.Velocity = -hrp.CFrame.RightVector * 80
                elseif touchControls.right then
                    hrp.Velocity = hrp.CFrame.RightVector * 80
                end
                wait(0.05)
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

-- 11. СОЗДАТЬ МОНЕТЫ
createButton("🪙 100 МОНЕТ", Color3.fromRGB(255, 215, 0), 705, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 100 do
        local coin = Instance.new("Part")
        coin.Size = Vector3.new(1, 0.2, 1)
        coin.Position = hrp.Position + Vector3.new(
            math.random(-70, 70),
            math.random(2, 15),
            math.random(-70, 70)
        )
        coin.Shape = Enum.PartType.Cylinder
        coin.Color = Color3.fromRGB(255, 215, 0)
        coin.Material = Enum.Material.Neon
        coin.Anchored = true
        coin.Name = "Coin"
        coin.Parent = workspace
        wait(0.01)
    end
end)

-- 12. КОКОС-ДОЖДЬ
createButton("🌧️ КОКОС-ДОЖДЬ", Color3.fromRGB(0, 100, 200), 770, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 100 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1, 1, 1)
        coconut.Position = hrp.Position + Vector3.new(
            math.random(-80, 80),
            math.random(40, 100),
            math.random(-80, 80)
        )
        coconut.Shape = Enum.PartType.Ball
        coconut.Color = Color3.fromRGB(139, 69, 19)
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.CanCollide = false
        coconut.Anchored = false
        coconut.Parent = workspace
        
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1000, 1000, 1000)
        bodyVel.Velocity = Vector3.new(0, -40, 0)
        bodyVel.Parent = coconut
        wait(0.02)
    end
end)

-- 13. РЕЖИМ СКОРОСТИ
local speedActive = false
local speedBtn

speedBtn = createButton("⚡ СУПЕР-СКОРОСТЬ", Color3.fromRGB(255, 255, 0), 835, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    speedActive = not speedActive
    
    if speedActive then
        speedBtn.Text = "⚡ СКОРОСТЬ (ВЫКЛ)"
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        humanoid.WalkSpeed = 120
        humanoid.JumpPower = 100
    else
        speedBtn.Text = "⚡ СУПЕР-СКОРОСТЬ"
        speedBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end)

-- 14. ГИГАНТСКИЙ КОКОС
createButton("🍈 ГИГАНТ-КОКОС", Color3.fromRGB(0, 200, 100), 900, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local coconut = Instance.new("Part")
    coconut.Size = Vector3.new(25, 25, 25)
    coconut.Position = hrp.Position + Vector3.new(0, 20, 0)
    coconut.Shape = Enum.PartType.Ball
    coconut.Color = Color3.fromRGB(139, 69, 19)
    coconut.Material = Enum.Material.Neon
    coconut.Anchored = true
    coconut.CanCollide = false
    coconut.Transparency = 0.3
    coconut.Parent = workspace
    
    spawn(function()
        local startTime = tick()
        while tick() - startTime < 12 do
            local hue = (tick() - startTime) / 12
            coconut.Color = Color3.fromHSV(hue, 1, 1)
            coconut.Size = Vector3.new(
                25 + math.sin((tick() - startTime) * 3) * 3,
                25 + math.sin((tick() - startTime) * 3) * 3,
                25 + math.sin((tick() - startTime) * 3) * 3
            )
            wait(0.05)
        end
        coconut:Destroy()
    end)
end)

-- 15. КОКОС-ЩИТ
local shieldActive = false
local shieldBtn
local shieldCoconuts = {}

shieldBtn = createButton("🛡️ КОКОС-ЩИТ", Color3.fromRGB(0, 200, 255), 965, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    shieldActive = not shieldActive
    
    if shieldActive then
        shieldBtn.Text = "🛡️ ЩИТ (ВЫКЛ)"
        shieldBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        for i = 1, 24 do
   
