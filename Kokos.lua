-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Создаем главную панель
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Закругление углов
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = frame

-- Кнопка "Кокос"
local coconutButton = Instance.new("TextButton")
coconutButton.Size = UDim2.new(0, 180, 0, 50)
coconutButton.Position = UDim2.new(0, 10, 0, 20)
coconutButton.Text = "🥥 КОКОС"
coconutButton.TextColor3 = Color3.fromRGB(255, 255, 255)
coconutButton.TextScaled = true
coconutButton.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
coconutButton.BorderSizePixel = 0
coconutButton.Parent = frame

local btnCorners = Instance.new("UICorner")
btnCorners.CornerRadius = UDim.new(0, 8)
btnCorners.Parent = coconutButton

-- Кнопка автофарма
local farmButton = Instance.new("TextButton")
farmButton.Size = UDim2.new(0, 180, 0, 50)
farmButton.Position = UDim2.new(0, 10, 0, 85)
farmButton.Text = "💰 АВТОФАРМ"
farmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
farmButton.TextScaled = true
farmButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
farmButton.BorderSizePixel = 0
farmButton.Parent = frame

local farmCorners = Instance.new("UICorner")
farmCorners.CornerRadius = UDim.new(0, 8)
farmCorners.Parent = farmButton

-- Кнопка сбора монет
local collectButton = Instance.new("TextButton")
collectButton.Size = UDim2.new(0, 180, 0, 50)
collectButton.Position = UDim2.new(0, 10, 0, 150)
collectButton.Text = "🪙 СОБРАТЬ МОНЕТЫ"
collectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collectButton.TextScaled = true
collectButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
collectButton.BorderSizePixel = 0
collectButton.Parent = frame

local collectCorners = Instance.new("UICorner")
collectCorners.CornerRadius = UDim.new(0, 8)
collectCorners.Parent = collectButton

-- Кнопка телепортации
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 180, 0, 50)
teleportButton.Position = UDim2.new(0, 10, 0, 215)
teleportButton.Text = "🌀 ТЕЛЕПОРТ"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
teleportButton.BorderSizePixel = 0
teleportButton.Parent = frame

local teleportCorners = Instance.new("UICorner")
teleportCorners.CornerRadius = UDim.new(0, 8)
teleportCorners.Parent = teleportButton

-- === ТВОЯ КНОПКА "КОКОС" ===
coconutButton.MouseButton1Click:Connect(function()
    -- Создаем кокос
    local coconut = Instance.new("Part")
    coconut.Size = Vector3.new(2, 2, 2)
    coconut.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
    coconut.Shape = Enum.PartType.Ball
    coconut.Material = Enum.Material.SmoothPlastic
    coconut.CanCollide = false
    coconut.Anchored = true
    coconut.Parent = workspace
    
    -- Добавляем радужный эффект
    local rainbowEffect = Instance.new("Script")
    rainbowEffect.Source = [[
        local coconut = script.Parent
        local startTime = tick()
        local duration = 10
        
        while tick() - startTime < duration do
            local hue = (tick() - startTime) / duration
            local color = Color3.fromHSV(hue % 1, 1, 1)
            coconut.Color = color
            
            -- Изменяем размер для эффекта пульсации
            local scale = 1 + math.sin((tick() - startTime) * 5) * 0.1
            coconut.Size = Vector3.new(2 * scale, 2 * scale, 2 * scale)
            
            wait(0.05)
        end
        
        coconut:Destroy()
    ]]
    rainbowEffect.Parent = coconut
    
    -- Анимация появления
    for i = 0, 1, 0.05 do
        coconut.Transparency = 1 - i
        wait(0.02)
    end
    
    -- Уведомление
    game.StarterGui:SetCore("SendNotification", {
        Title = "🥥 КОКОС!",
        Text = "Радужный кокос появился на 10 секунд!",
        Duration = 3
    })
end)

-- === АВТОФАРМ МОНЕТ ===
local farming = false
local farmConnection

farmButton.MouseButton1Click:Connect(function()
    farming = not farming
    
    if farming then
        farmButton.Text = "⏹ ОСТАНОВИТЬ ФАРМ"
        farmButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "💰 АВТОФАРМ",
            Text = "Автосбор монет включен!",
            Duration = 2
        })
        
        farmConnection = game:GetService("RunService").Heartbeat:Connect(function()
            -- Ищем монеты поблизости
            local player = game.Players.LocalPlayer
            local char = player.Character
            if not char then return end
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name:lower():find("coin") or part.Name:lower():find("монет") then
                    local distance = (hrp.Position - part.Position).Magnitude
                    if distance < 50 then
                        -- Телепортируемся к монете
                        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                        wait(0.1)
                    end
                end
            end
        end)
    else
        farmButton.Text = "💰 АВТОФАРМ"
        farmButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "⏹ ФАРМ ОСТАНОВЛЕН",
            Text = "Автосбор монет выключен!",
            Duration = 2
        })
        
        if farmConnection then
            farmConnection:Disconnect()
            farmConnection = nil
        end
    end
end)

-- === СБОР ВСЕХ МОНЕТ ===
collectButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local count = 0
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name:lower():find("coin") or part.Name:lower():find("монет") then
            hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
            count = count + 1
            wait(0.05)
        end
    end
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🪙 СБОР ЗАВЕРШЕН",
        Text = "Собрано " .. count .. " монет!",
        Duration = 3
    })
end)

-- === ТЕЛЕПОРТ ===
teleportButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local randomX = math.random(-100, 100)
    local randomZ = math.random(-100, 100)
    hrp.CFrame = CFrame.new(randomX, 10, randomZ)
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "🌀 ТЕЛЕПОРТ",
        Text = "Вы телепортированы!",
        Duration = 2
    })
end)

-- === УТИЛИТА: АВТОПРИСОЕДИНЕНИЕ К ИГРЕ ===
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ СКРИПТ ЗАГРУЖЕН",
        Text = "Используй кнопки для управления!",
        Duration = 3
    })
end)

-- Первое уведомление
wait(2)
game.StarterGui:SetCore("SendNotification", {
    Title = "🚀 СКРИПТ АКТИВИРОВАН",
    Text = "Нажми 🥥 КОКОС для радужного эффекта!",
    Duration = 4
})
