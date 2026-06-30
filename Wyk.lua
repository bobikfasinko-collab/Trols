--[[
  GREGOO ULTRA V4 — МОБИЛЬНАЯ ВЕРСИЯ
  Оптимизировано для телефона
--]]

if getgenv().GregooUltraV4 then return end
getgenv().GregooUltraV4 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- ===== ПЕРЕМЕННЫЕ =====
local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local flyEnabled = false
local speedEnabled = false
local speedValue = 25
local trollMenuOpen = false
local flyVelocity, flyGyro = nil, nil
local espHighlights = {}
local trollFrame = nil
local menuVisible = true

-- ===== СОЗДАНИЕ GUI (адаптивное) =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooUltraV4"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное меню (занимает почти весь экран)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.85, 0)  -- 90% ширины, 85% высоты
MainFrame.Position = UDim2.new(0.05, 0, 0.07, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.12, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ GREGOO ⚡"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextSize = 30
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MainFrame

-- Подзаголовок
local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, 0, 0.07, 0)
Sub.Position = UDim2.new(0, 0, 0.12, 0)
Sub.BackgroundTransparency = 1
Sub.Text = "by Gregoo"
Sub.TextColor3 = Color3.fromRGB(150, 150, 200)
Sub.TextSize = 16
Sub.TextScaled = true
Sub.Font = Enum.Font.Gotham
Sub.Parent = MainFrame

-- Кнопка закрытия (большая для пальцев)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 60, 0, 60)
Close.Position = UDim2.new(1, -70, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 30
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
    if flyEnabled then ToggleFly() end
end)

-- Кнопка показа меню (всегда видна)
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 70, 0, 70)
ShowBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ShowBtn.Text = "📋"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 35
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowBtn
ShowBtn.Parent = ScreenGui
ShowBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

-- Контейнер для кнопок (скроллинг)
local BtnContainer = Instance.new("ScrollingFrame")
BtnContainer.Size = UDim2.new(1, -20, 1, -0.25)
BtnContainer.Position = UDim2.new(0, 10, 0.2, 0)
BtnContainer.BackgroundTransparency = 1
BtnContainer.CanvasSize = UDim2.new(0, 0, 0, 600)
BtnContainer.ScrollBarThickness = 8
BtnContainer.Parent = MainFrame

-- Функция создания большой кнопки
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 65)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 55)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 22
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    btn.Parent = BtnContainer
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. ESP
local espBtn = createButton("👁️ ESP (ВЫКЛ)", 0, function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "👁️ ESP (ВКЛ)"
        espBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        espBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
        ApplyESP()
    else
        espBtn.Text = "👁️ ESP (ВЫКЛ)"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        espBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        RemoveESP()
    end
end)
-- Кнопка смены цвета ESP
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0.25, 0, 0, 45)
colorBtn.Position = UDim2.new(0.7, 0, 0, 10)
colorBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
colorBtn.Text = "🎨"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.TextSize = 25
colorBtn.Font = Enum.Font.GothamBold
colorBtn.BorderSizePixel = 0
local colCorner = Instance.new("UICorner")
colCorner.CornerRadius = UDim.new(0, 8)
colCorner.Parent = colorBtn
colorBtn.Parent = espBtn
colorBtn.MouseButton1Click:Connect(function()
    espColor = Color3.fromHSV(math.random(), 0.8, 0.8)
    if espEnabled then ApplyESP() end
end)

-- 2. Fly
local flyBtn = createButton("🪂 Fly (ВЫКЛ)", 75, function()
    ToggleFly()
    if flyEnabled then
        flyBtn.Text = "🪂 Fly (ВКЛ)"
        flyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
        flyBtn.BorderColor3 = Color3.fromRGB(0, 255, 255)
    else
        flyBtn.Text = "🪂 Fly (ВЫКЛ)"
        flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        flyBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
    end
end)

-- 3. Speed
local speedBtn = createButton("💨 Speed ("..speedValue..")", 150, function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "💨 Speed ("..speedValue..") ✅"
        speedBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        speedBtn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        Humanoid.WalkSpeed = speedValue
    else
        speedBtn.Text = "💨 Speed ("..speedValue..")"
        speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedBtn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        Humanoid.WalkSpeed = 16
    end
end)
-- + и - на телефоне
local sUp = Instance.new("TextButton")
sUp.Size = UDim2.new(0.13, 0, 0, 40)
sUp.Position = UDim2.new(0.7, 0, 0, 12)
sUp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
sUp.Text = "+"
sUp.TextColor3 = Color3.fromRGB(255,255,255)
sUp.TextSize = 28
sUp.Font = Enum.Font.GothamBold
sUp.BorderSizePixel = 0
local supCorner = Instance.new("UICorner")
supCorner.CornerRadius = UDim.new(0, 8)
supCorner.Parent = sUp
sUp.Parent = speedBtn
sUp.MouseButton1Click:Connect(function()
    speedValue = math.min(speedValue + 5, 100)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed ("..speedValue..")" .. (speedEnabled and " ✅" or "")
end)

local sDown = Instance.new("TextButton")
sDown.Size = UDim2.new(0.13, 0, 0, 40)
sDown.Position = UDim2.new(0.85, 0, 0, 12)
sDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
sDown.Text = "-"
sDown.TextColor3 = Color3.fromRGB(255,255,255)
sDown.TextSize = 28
sDown.Font = Enum.Font.GothamBold
sDown.BorderSizePixel = 0
local sdownCorner = Instance.new("UICorner")
sdownCorner.CornerRadius = UDim.new(0, 8)
sdownCorner.Parent = sDown
sDown.Parent = speedBtn
sDown.MouseButton1Click:Connect(function()
    speedValue = math.max(speedValue - 5, 10)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed ("..speedValue..")" .. (speedEnabled and " ✅" or "")
end)

-- 4. Troll
local trollBtn = createButton("💀 Troll (выкинуть)", 225, function()
    ToggleTrollMenu()
end)

-- ===== ФУНКЦИИ =====
function ApplyESP()
    RemoveESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hl = Instance.new("Highlight")
                hl.Name = "GregooESP"
                hl.FillColor = espColor
                hl.FillTransparency = 0.4
                hl.OutlineColor = espColor
                hl.OutlineTransparency = 0.2
                hl.Parent = char
                table.insert(espHighlights, hl)
            end
        end
    end
end

function RemoveESP()
    for _, h in pairs(espHighlights) do
        if h and h.Parent then h:Destroy() end
    end
    espHighlights = {}
end

function ToggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyVelocity.Velocity = Vector3.new(0,0,0)
        flyVelocity.Parent = RootPart
        flyGyro = Instance.new("BodyGyro")
        flyGyro.P = 1e6
        flyGyro.D = 500
        flyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
        flyGyro.CFrame = RootPart.CFrame
        flyGyro.Parent = RootPart
        
        RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            if not RootPart or not RootPart.Parent then return end
            local move = Vector3.new(0,0,0)
            -- На телефоне используем виртуальные кнопки (джойстик не делаем, но можно добавить)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 50, 0) end
            flyVelocity.Velocity = move
            flyGyro.CFrame = RootPart.CFrame
        end)
    else
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    end
end

function ToggleTrollMenu()
    if trollMenuOpen then
        if trollFrame then trollFrame:Destroy() end
        trollMenuOpen = false
        return
    end
    trollMenuOpen = true
    
    trollFrame = Instance.new("Frame")
    trollFrame.Size = UDim2.new(0.85, 0, 0.7, 0)
    trollFrame.Position = UDim2.new(0.075, 0, 0.15, 0)
    trollFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 30)
    trollFrame.BackgroundTransparency = 0.1
    trollFrame.BorderSizePixel = 3
    trollFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = trollFrame
    trollFrame.Parent = ScreenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.12, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Выберите жертву"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 24
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = trollFrame
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -0.15)
    container.Position = UDim2.new(0, 5, 0.12, 0)
    container.BackgroundTransparency = 1
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.ScrollBarThickness = 8
    container.Parent = trollFrame
    
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 55)
            btn.Position = UDim2.new(0,0,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,80)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextSize = 22
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 2
            btn.BorderColor3 = Color3.fromRGB(255,255,255)
            local corner2 = Instance.new("UICorner")
            corner2.CornerRadius = UDim.new(0, 10)
            corner2.Parent = btn
            btn.Parent = container
            btn.MouseButton1Click:Connect(function()
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.Position = Vector3.new(0, -500, 0)
                    wait(1)
                    hrp.Position = Vector3.new(math.random(-5000,5000), -1000, math.random(-5000,5000))
                end
                if trollFrame then trollFrame:Destroy() end
                trollMenuOpen = false
            end)
            y = y + 60
            container.CanvasSize = UDim2.new(0,0,0,y)
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1,0,0,50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200,200,200)
        none.TextSize = 20
        none.Font = Enum.Font.Gotham
        none.Parent = container
    end
end

-- Обновление персонажа
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    if flyEnabled then ToggleFly() end
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
end)

print("✅ Gregoo Ultra V4 (Мобильная) загружена!")
print("📱 Нажми кнопку 📋 чтобы показать/скрыть меню")
