-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Создаем главную панель (скроллируемую)
local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0, 220, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.CanvasSize = UDim2.new(0, 0, 0, 600)
frame.ScrollBarThickness = 5
frame.Parent = screenGui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = frame

local function createButton(text, color, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local btnCorners = Instance.new("UICorner")
    btnCorners.CornerRadius = UDim.new(0, 8)
    btnCorners.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Счетчик нажатий
local clickCount = 0
local isCoconutRage = false

-- === ОБНОВЛЕННАЯ КНОПКА "КОКОС" ===
createButton("🥥 КОКОС-РАДУГА 🥥", Color3.fromRGB(139, 69, 19), 10, function()
    if isCoconutRage then return end
    isCoconutRage = true
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- 1. СОЗДАЕМ 50 КОКОСОВ ПО ВСЕМУ ЭКРАНУ
    local coconuts = {}
    for i = 1, 50 do
        local coconut = Instance.new("Part")
        coconut.Size = Vector3.new(1.5, 1.5, 1.5)
        local randomPos = hrp.Position + Vector3.new(
            math.random(-80, 80),
            math.random(5, 50),
            math.random(-80, 80)
        )
        coconut.Position = randomPos
        coconut.Shape = Enum.PartType.Ball
        coconut.Material = Enum.Material.SmoothPlastic
        coconut.CanCollide = false
        coconut.Anchored = true
        coconut.Transparency = 0
        coconut.Parent = workspace
        table.insert(coconuts, coconut)
        
        -- Эффект появления
        coconut.Size = Vector3.new(0.1, 0.1, 0.1)
        game:GetService("TweenService"):Create(coconut, TweenInfo.new(0.3), {Size = Vector3.new(1.5, 1.5, 1.5)}):Play()
    end
    
    -- 2. РАДУЖНЫЙ ЭФФЕКТ НА ВСЕ КОКОСЫ
    local rainbowScript = Instance.new("Script")
    rainbowScript.Source = [[
        local coconuts = script.Parent:GetChildren()
        local duration = 10
        local startTime = tick()
        
        while tick() - startTime < duration do
            local hue = (tick() - startTime) / duration
            for _, coconut in pairs(coconuts) do
                if coconut:IsA("Part") then
                    local color = Color3.fromHSV((hue + coconut.Name) % 1, 1, 1)
                    coconut.Color = color
                    
                    -- Пульсация
                    local scale = 1 + math.sin((tick() - startTime) * 8 + coconut.Name) * 0.15
                    coconut.Size = Vector3.new(1.5 * scale, 1.5 * scale, 1.5 * scale)
                end
            end
            wait(0.03)
        end
        
        for _, coconut in pairs(coconuts) do
            coconut:Destroy()
        end
    ]]
    
    local coconutGroup = Instance.new("Folder")
    coconutGroup.Name = "Coconuts"
    for i, coconut in pairs(coconuts) do
        coconut.Name = tostring(i)
        coconut.Parent = coconutGroup
    end
    rainbowScript.Parent = coconutGroup
    coconutGroup.Parent = workspace
    
    -- 3. ВЗЛЕТАЕМ В КОСМОС
    local startPos = hrp.Position
    local targetPos = startPos + Vector3.new(0, 500, 0)
    
    -- Эффект взлета
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 150, 0)
    bodyVelocity.Parent = hrp
    
    -- Плавный разгон
    for i = 1, 30 do
        bodyVelocity.Velocity = Vector3.new(
            math.sin(i/5) * 20,
            150 + i * 5,
            math.cos(i/5) * 20
        )
        wait(0.05)
    end
    
    -- 4. РАДУЖНЫЙ ЭФФЕКТ НА ВЕСЬ ЭКРАН (Bloom эффект)
    local lighting = game:GetService("Lighting")
    local originalBrightness = lighting.Brightness
    local originalClockTime = lighting.ClockTime
    
    -- Создаем радужный свет
    for i = 1, 30 do
        local hue = i / 30
        lighting.Ambient = Color3.fromHSV(hue, 0.8, 0.8)
        lighting.Brightness = 1.5 + math.sin(i/3) * 0.5
        lighting.ClockTime = 12 + math.sin(i/2) * 2
        wait(0.1)
    end
    
    -- 5. ФИНАЛ - ВЗРЫВ КОКОСОВ
    wait(1)
    for _, coconut in pairs(coconuts) do
        local explosion = Instance.new("Explosion")
        explosion.Position = coconut.Position
        explosion.BlastRadius = 5
        explosion.BlastPressure = 0
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        explosion:Destroy()
        wait(0.02)
    end
    
    -- Очистка
    wait(5)
    bodyVelocity:Destroy()
    lighting.Ambient = Color3.fromRGB(0, 0, 0)
    lighting.Brightness = originalBrightness
    lighting.ClockTime = originalClockTime
    coconutGroup:Destroy()
    isCoconutRage = false
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌴 КОКОС-ШТОРМ!",
        Text = "Ты улетел в космос на кокосовой ракете!",
        Duration = 4
    })
end)

-- === НОВЫЕ ФУНКЦИИ ===

-- 1. ФАРМ МОНЕТ (улучшенный)
local farming = false
local farmConnection
local farmBtn

farmBtn = createButton("💰 АВТОФАРМ (ВКЛ)", Color3.fromRGB(0, 128, 0), 65, function()
    farming = not farming
    
    if farming then
        farmBtn.Text = "💰 АВТОФАРМ (ВЫКЛ)"
        farmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "💰 АВТОФАРМ",
            Text = "Автосбор монет включен!",
            Duration = 2
        })
        
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
                local tween = game:GetService("TweenService"):Create(hrp, TweenInfo.new(0.5), {CFrame = CFrame.new(nearestCoin.Position + Vector3.new(0, 2, 0))})
                tween:Play()
            end
        end)
    else
        farmBtn.Text = "💰 АВТОФАРМ (ВКЛ)"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "⏹ ФАРМ ОСТАНОВЛЕН",
            Text = "Автосбор монет выключен!",
            Duration = 2
        })
    end
end)

-- 2. СУПЕР-ПРЫЖОК
createButton("🦘 СУПЕР-ПРЫЖОК", Color3.fromRGB(255, 140, 0), 120, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    wait(0.1)
    local bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVel.Velocity = Vector3.new(0, 200, 0)
    bodyVel.Parent = hrp
    
    game:GetService("TweenService"):Create(bodyVel, TweenInfo.new(1), {Velocity = Vector3.new(0, 0, 0)}):Play()
    wait(2)
    bodyVel:Destroy()
end)

-- 3. НЕВИДИМОСТЬ
local invisible = false
local invisBtn

invisBtn = createButton("👻 НЕВИДИМОСТЬ", Color3.fromRGB(128, 0, 128), 175, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    invisible = not invisible
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = invisible and 1 or 0
        end
    end
    
    invisBtn.Text = invisible and "👻 ВИДИМЫЙ" or "👻 НЕВИДИМОСТЬ"
    invisBtn.BackgroundColor3 = invisible and Color3.fromRGB(200, 0, 200) or Color3.fromRGB(128, 0, 128)
end)

-- 4. ТЕЛЕПОРТ НА БАЗУ
createButton("🏠 НА БАЗУ", Color3.fromRGB(0, 100, 255), 230, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local base = workspace:FindFirstChild("Baseplate") or workspace:FindFirstChild("SpawnLocation")
    if base then
        hrp.CFrame = CFrame.new(base.Position + Vector3.new(0, 5, 0))
        game.StarterGui:SetCore("SendNotification", {
            Title = "🏠 НА БАЗЕ",
            Text = "Ты вернулся на базу!",
            Duration = 2
        })
    end
end)

-- 5. УСКОРЕНИЕ ВРЕМЕНИ (для фарма)
createButton("⏩ УСКОРЕНИЕ x2", Color3.fromRGB(0, 200, 200), 285, function()
    game:GetService("RunService"):SetThrottleEnabled(true)
    game:GetService("RunService").RenderStepped:Connect(function()
        if game:GetService("RunService"):IsThrottleEnabled() then
            game:GetService("RunService"):SetThrottleEnabled(false)
        end
    end)
    game.StarterGui:SetCore("SendNotification", {
        Title = "⚡ УСКОРЕНИЕ",
        Text = "Скорость игры увеличена!",
        Duration = 2
    })
end)

-- 6. ФАРМ ДЕРЕВЬЕВ (создает деревья с монетами)
createButton("🌴 ПОСАДИТЬ ДЕРЕВО", Color3.fromRGB(0, 150, 0), 340, function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for i = 1, 10 do
        local tree = Instance.new("Part")
        tree.Size = Vector3.new(1, 6, 1)
        tree.Position = hrp.Position + Vector3.new(math.random(-15, 15), 2, math.random(-15, 15))
        tree.Color = Color3.fromRGB(34, 139, 34)
        tree.Material = Enum.Material.Wood
        tree.Anchored = true
        tree.Parent = workspace
        
        -- Шапка дерева
        local leaves = Instance.new("Part")
        leaves.Size = Vector3.new(4, 2, 4)
        leaves.Position = tree.Position + Vector3.new(0, 4, 0)
        leaves.Color = Color3.fromRGB(0, 200, 0)
        leaves.Shape = Enum.PartType.Ball
        leaves.Anchored = true
        leaves.Parent = workspace
        
        -- Монетка на дереве
        local coin = Instance.new("Part")
        coin.Size = Vector3.new(0.5, 0.1, 0.5)
        coin.Position = tree.Position + Vector3.new(0, 5, 0)
        coin.Color = Color3.fromRGB(255, 215, 0)
        coin.Shape = Enum.PartType.Cylinder
        coin.Anchored = true
        coin.Name = "Coin"
        coin.Parent = workspace
        
        wait(0.1)
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌴 ЛЕС ПОСАЖЕН",
        Text = "Теперь собирай монеты с деревьев!",
        Duration = 3
    })
end)

-- 7. КАРЛИК/ВЕЛИКАН
local scale = 1
createButton("📏 ИЗМЕНИТЬ РАЗМЕР", Color3.fromRGB(255, 20, 147), 395, function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    scale = scale == 1 and 0.3 or 1
    hrp.Size = hrp.Size * (scale == 0.3 and 0.3 or 3.33)
    char.Torso.Size = char.Torso.Size * (scale == 0.3 and 0.3 or 3.33)
    char.Head.Size = char.Head.Size * (scale == 0.3 and 0.3 or 3.33)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = scale == 0.3 and "🐭 КАРЛИК!" or "🦍 ВЕЛИКАН!",
        Text = scale == 0.3 and "Ты стал маленьким!" or "Ты стал огромным!",
        Duration = 2
    })
end)

-- 8. МАГНИТ ДЛЯ МОНЕТ
local magnetActive = false
local magnetBtn

magnetBtn = createButton("🧲 МАГНИТ (ВКЛ)", Color3.fromRGB(255, 215, 0), 450, function()
    magnetActive = not magnetActive
    
    if magnetActive then
        magnetBtn.Text = "🧲 МАГНИТ (ВЫКЛ)"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        game:GetService("RunService").Heartbeat:Connect(function()
            if not magnetActive then return end
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name == "Coin" then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < 30 then
                        part.Position = part.Position + (hrp.Position - part.Position).Unit * 3
                    end
                end
            end
        end)
    else
        magnetBtn.Text = "🧲 МАГНИТ (ВКЛ)"
        magnetBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end
end)

-- 9. ПОЛЕТ
local flying = false
local flyBtn

flyBtn = createButton("✈️ РЕЖИМ ПОЛЕТА", Color3.fromRGB(0, 150, 255), 505, function()
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
        
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if not flying then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.W then
                    hrp.Velocity = hrp.CFrame.LookVector * 50
                elseif input.KeyCode == Enum.KeyCode.S then
                    hrp.Velocity = -hrp.CFrame.LookVector * 50
                elseif input.KeyCode == Enum.KeyCode.Space then
                    hrp.Velocity = Vector3.new(0, 50, 0)
                end
            end
        end)
    else
        flyBtn.Text = "✈️ РЕЖИМ ПОЛЕТА"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        humanoid.PlatformStand = false
    end
end)

-- === УВЕДОМЛЕНИЕ О ЗАГРУЗКЕ ===
wait(2)
game.StarterGui:SetCore("SendNotification", {
    Title = "🚀 СКРИПТ ЗАГРУЖЕН",
    Text = "9 функций доступно! Нажми 🥥 КОКОС-РАДУГА!",
    Duration = 5
})

-- Контр-уведомление
game.StarterGui:SetCore("SendNotification", {
    Title = "🥥 НОВЫЙ КОКОС!",
    Text = "При нажатии ты улетишь в космос с 50 кокосами!",
    Duration = 4
})
