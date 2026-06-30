--[[
    Скрипт для Roblox Delta
    Создаёт кнопку "Секрет" на экране.
    При нажатии: эффект предупреждения + взрыв/полёт игрока.
--]]

-- Проверка, что скрипт запущен в клиенте (для GUI)
if game:GetService("RunService"):IsServer() then
    warn("Этот скрипт должен выполняться на клиенте (LocalScript)")
    return
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Создаём основной ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecretButtonGui"
ScreenGui.Parent = Player.PlayerGui  -- или game.CoreGui для всегда поверх

-- Создаём кнопку
local Button = Instance.new("TextButton")
Button.Name = "SecretButton"
Button.Size = UDim2.new(0, 150, 0, 50)
Button.Position = UDim2.new(0.5, -75, 0.8, 0)  -- центр, чуть ниже середины
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.BackgroundTransparency = 0.2
Button.BorderSizePixel = 2
Button.BorderColor3 = Color3.fromRGB(255, 200, 0)
Button.Text = "🔮 СЕКРЕТ"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 20
Button.Font = Enum.Font.GothamBold
Button.Parent = ScreenGui

-- Эффект "дрожания" кнопки (привлекает внимание)
game:GetService("TweenService"):Create(
    Button,
    TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.1}
):Play()

-- Функция "взрыва" (разлетаются все части)
local function ExplodeCharacter()
    local character = Player.Character
    if not character then return end
    
    -- Сохраняем все части тела
    local parts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(parts, part)
        end
    end
    
    -- Отключаем Humanoid, чтобы тело не контролировалось
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid:BreakJoints()
    end
    
    -- Разбрасываем части с силой
    for _, part in ipairs(parts) do
        local velocity = Vector3.new(
            math.random(-80, 80),
            math.random(30, 100),
            math.random(-80, 80)
        )
        part.Velocity = velocity
        part.RotVelocity = Vector3.new(
            math.random(-50, 50),
            math.random(-50, 50),
            math.random(-50, 50)
        )
        -- Добавляем огонёк для эффекта
        local fire = Instance.new("Fire")
        fire.Size = 5
        fire.Heat = 10
        fire.Parent = part
        -- Удаляем огонь через 3 секунды
        game:GetService("Debris"):AddItem(fire, 3)
    end
    
    -- Через 3 секунды возрождаем персонажа (опционально)
    task.wait(3)
    Player:LoadCharacter()
end

-- Функция "улететь" (как от взрывной волны)
local function FlyAway()
    local character = Player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    
    humanoid.PlatformStand = true
    
    -- Резкий толчок вверх и в сторону
    root.Velocity = Vector3.new(math.random(-40, 40), 120, math.random(-40, 40))
    root.RotVelocity = Vector3.new(10, 20, 10)
    
    -- Добавляем эффект взрыва вокруг игрока
    local explosion = Instance.new("Explosion")
    explosion.Position = root.Position
    explosion.BlastRadius = 10
    explosion.BlastPressure = 0  -- чтобы не навредило другим
    explosion.Parent = workspace
    
    -- Через 2 секунды убираем платформенную стойку
    task.wait(2)
    humanoid.PlatformStand = false
end

-- Обработчик нажатия кнопки
Button.MouseButton1Click:Connect(function()
    -- Блокируем повторные нажатия на время анимации
    Button.Enabled = false
    
    -- Создаём текстовое предупреждение
    local WarningLabel = Instance.new("TextLabel")
    WarningLabel.Name = "WarningLabel"
    WarningLabel.Size = UDim2.new(0, 500, 0, 80)
    WarningLabel.Position = UDim2.new(0.5, -250, 0.3, 0)
    WarningLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    WarningLabel.BackgroundTransparency = 0.3
    WarningLabel.BorderSizePixel = 3
    WarningLabel.BorderColor3 = Color3.fromRGB(255, 200, 0)
    WarningLabel.Text = "⚠️🥥 КОКОСОВАЯ ОПАСНОСТЬ 🥥⚠️"
    WarningLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    WarningLabel.TextSize = 28
    WarningLabel.Font = Enum.Font.GothamBlack
    WarningLabel.TextScaled = true
    WarningLabel.Parent = ScreenGui
    
    -- Анимация появления (увеличение + мигание)
    WarningLabel.Size = UDim2.new(0, 0, 0, 0)
    game:GetService("TweenService"):Create(
        WarningLabel,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 500, 0, 80)}
    ):Play()
    
    -- Звуковой эффект (если есть)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120399975"  -- звук взрыва/предупреждения
    sound.Volume = 0.8
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
    
    -- Ждём 1.5 секунды, чтобы игрок прочитал
    task.wait(1.5)
    
    -- Убираем предупреждение с анимацией
    game:GetService("TweenService"):Create(
        WarningLabel,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0)}
    ):Play()
    task.wait(0.3)
    WarningLabel:Destroy()
    
    -- Выбираем случайный эффект: 50% взрыв, 50% улететь
    if math.random(1, 2) == 1 then
        ExplodeCharacter()
    else
        FlyAway()
    end
    
    -- Разблокируем кнопку через 2 секунды (после возрождения)
    task.wait(2)
    Button.Enabled = true
end)

print("✅ Секретная кнопка загружена!")
