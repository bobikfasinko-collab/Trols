--[[
  ⚡ GREGOO ULTRA V2 ⚡
  Красивое переливающееся меню + 4 мощные функции
  Создатель: Gregoo
--]]

if getgenv().GregooUltraV2 then return end
getgenv().GregooUltraV2 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ====================================================
-- 1. ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ====================================================
local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local flyEnabled = false
local speedEnabled = false
local speedValue = 16
local trollMenuOpen = false

local flyVelocity = nil
local flyGyro = nil
local espHighlights = {}
local trollListFrame = nil

-- ====================================================
-- 2. СОЗДАНИЕ ГЛАВНОГО МЕНЮ (переливающийся фон)
-- ====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooUltraV2"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 520)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Скругление углов
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Эффект переливания (анимируем цвет фона)
local hue = 0
RunService.Heartbeat:Connect(function()
    if not MainFrame.Parent then return end
    hue = hue + 0.005
    if hue > 1 then hue = 0 end
    local color = Color3.fromHSV(hue, 0.8, 0.3)
    MainFrame.BackgroundColor3 = color
end)

-- Заголовок с необычным шрифтом (используем Outline и большой размер)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 70)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ GREGOO ULTRA ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 40
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextStrokeColor = Color3.fromRGB(0, 200, 255)
TitleLabel.TextStrokeTransparency = 0.2
TitleLabel.TextScaled = false
TitleLabel.Parent = MainFrame

-- Подзаголовок (автор)
local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.Position = UDim2.new(0, 0, 0, 70)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "создатель тролль-чита Gregoo"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextSize = 18
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextStrokeColor = Color3.fromRGB(0, 100, 255)
SubTitle.TextStrokeTransparency = 0.5
SubTitle.Parent = MainFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 45, 0, 45)
CloseButton.Position = UDim2.new(1, -55, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 30
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    if flyEnabled then ToggleFly() end
end)

-- ====================================================
-- 3. КНОПКИ С ПЕРЕЛИВАНИЕМ
-- ====================================================
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, -40, 1, -130)
ButtonContainer.Position = UDim2.new(0, 20, 0, 110)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

-- Функция создания кнопки с анимацией цвета
local function createButton(text, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 60)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromHSV(0.5, 0.8, 0.6)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    btn.TextStrokeColor = Color3.fromRGB(0, 0, 0)
    btn.TextStrokeTransparency = 0.3
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    -- Анимация переливания цвета кнопки
    local hueOffset = yPos * 0.1 + 0.2
    RunService.Heartbeat:Connect(function()
        if not btn.Parent then return end
        local h = (tick() * 0.1 + hueOffset) % 1
        btn.BackgroundColor3 = Color3.fromHSV(h, 0.8, 0.6)
    end)
    
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- 1. ESP
local espBtn = createButton("👁️ ESP (вкл/выкл)", 0, function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "👁️ ESP ВКЛ (цвет: зеленый)"
        espBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        ApplyESP()
    else
        espBtn.Text = "👁️ ESP (вкл/выкл)"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RemoveESP()
    end
end)

-- Кнопка смены цвета ESP
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0.3, 0, 0, 40)
colorBtn.Position = UDim2.new(0.7, 0, 0, 5)
colorBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
colorBtn.Text = "🎨 цвет"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.TextSize = 18
colorBtn.Font = Enum.Font.GothamBold
colorBtn.BorderSizePixel = 0
local colorCorner = Instance.new("UICorner")
colorCorner.CornerRadius = UDim.new(0, 8)
colorCorner.Parent = colorBtn
colorBtn.Parent = espBtn

colorBtn.MouseButton1Click:Connect(function()
    espColor = Color3.fromHSV(math.random(), 0.8, 0.8)
    if espEnabled then
        ApplyESP()
        espBtn.Text = "👁️ ESP ВКЛ (цвет: " .. tostring(espColor) .. ")"
    end
end)

-- 2. Fly
local flyBtn = createButton("🪂 Fly (вкл/выкл)", 70, function()
    ToggleFly()
    if flyEnabled then
        flyBtn.Text = "🪂 Fly ВКЛ (WASD/Пробел)"
        flyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        flyBtn.Text = "🪂 Fly (вкл/выкл)"
        flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 3. Speed Hack
local speedBtn = createButton("💨 Speed Hack (" .. speedValue .. ")", 140, function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "💨 Speed ВКЛ (" .. speedValue .. ")"
        speedBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        Humanoid.WalkSpeed = speedValue
    else
        speedBtn.Text = "💨 Speed Hack (" .. speedValue .. ")"
        speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Humanoid.WalkSpeed = 16
    end
end)

-- Кнопки изменения скорости
local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.15, 0, 0, 35)
speedUp.Position = UDim2.new(0.7, 0, 0, 5)
speedUp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 25
speedUp.Font = Enum.Font.GothamBold
speedUp.BorderSizePixel = 0
local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = speedUp
speedUp.Parent = speedBtn

speedUp.MouseButton1Click:Connect(function()
    speedValue = math.min(speedValue + 5, 100)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed Hack (" .. speedValue .. ")"
end)

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.15, 0, 0, 35)
speedDown.Position = UDim2.new(0.87, 0, 0, 5)
speedDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 25
speedDown.Font = Enum.Font.GothamBold
speedDown.BorderSizePixel = 0
local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = speedDown
speedDown.Parent = speedBtn

speedDown.MouseButton1Click:Connect(function()
    speedValue = math.max(speedValue - 5, 10)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed Hack (" .. speedValue .. ")"
end)

-- 4. Troll
local trollBtn = createButton("💀 Troll (выкинуть игрока)", 210, function()
    ToggleTrollMenu()
end)

-- ====================================================
-- 4. ФУНКЦИЯ ESP
-- ====================================================
function ApplyESP()
    RemoveESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GregooESP"
                highlight.FillColor = espColor
                highlight.FillTransparency = 0.4
                highlight.OutlineColor = espColor
                highlight.OutlineTransparency = 0.2
                highlight.Parent = char
                table.insert(espHighlights, highlight)
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

-- Обновляем ESP при появлении новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        if espEnabled then
            wait(0.5)
            ApplyESP()
        end
    end)
end)

-- ====================================================
-- 5. ФУНКЦИЯ ПОЛЁТА
-- ====================================================
function ToggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = RootPart
        
        flyGyro = Instance.new("BodyGyro")
        flyGyro.P = 1e6
        flyGyro.D = 500
        flyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        flyGyro.CFrame = RootPart.CFrame
        flyGyro.Parent = RootPart
        
        -- Управление
        RunService.Heartbeat:Connect(function()
            if not flyEnabled then return end
            if not RootPart or not RootPart.Parent then return end
            
            local move = Vector3.new(0, 0, 0)
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
        if flyVelocity then flyVelocity:Destroy() end
        if flyGyro then flyGyro:Destroy() end
    end
end

-- ====================================================
-- 6. ФУНКЦИЯ TROLL (список игроков)
-- ====================================================
function ToggleTrollMenu()
    if trollMenuOpen then
        if trollListFrame then trollListFrame:Destroy() end
        trollMenuOpen = false
        return
    end
    
    trollMenuOpen = true
    trollListFrame = Instance.new("Frame")
    trollListFrame.Size = UDim2.new(0, 250, 0, 300)
    trollListFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    trollListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    trollListFrame.BackgroundTransparency = 0.1
    trollListFrame.BorderSizePixel = 2
    trollListFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = trollListFrame
    trollListFrame.Parent = ScreenGui
    
    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, 0, 0, 40)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "Выберите игрока для выкидывания"
    listTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    listTitle.TextSize = 18
    listTitle.Font = Enum.Font.GothamBold
    listTitle.Parent = trollListFrame
    
    local listContainer = Instance.new("ScrollingFrame")
    listContainer.Size = UDim2.new(1, -10, 1, -50)
    listContainer.Position = UDim2.new(0, 5, 0, 45)
    listContainer.BackgroundTransparency = 1
    listContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    listContainer.ScrollBarThickness = 6
    listContainer.Parent = trollListFrame
    
    local y = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            btn.Text = player.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 18
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- Выкидываем за карту (далеко вниз)
                        hrp.Position = Vector3.new(0, -500, 0)
                        wait(1)
                        hrp.Position = Vector3.new(math.random(-5000, 5000), -1000, math.random(-5000, 5000))
                    end
                end
                if trollListFrame then trollListFrame:Destroy() end
                trollMenuOpen = false
            end)
            
            btn.Parent = listContainer
            y = y + 45
            listContainer.CanvasSize = UDim2.new(0, 0, 0, y)
        end
    end
    
    if y == 0 then
        local noPlayers = Instance.new("TextLabel")
        noPlayers.Size = UDim2.new(1, 0, 0, 50)
        noPlayers.BackgroundTransparency = 1
        noPlayers.Text = "Нет других игроков"
        noPlayers.TextColor3 = Color3.fromRGB(200, 200, 200)
        noPlayers.TextSize = 20
        noPlayers.Font = Enum.Font.Gotham
        noPlayers.Parent = listContainer
    end
end

-- ====================================================
-- 7. ЗАКРЫТИЕ TROLL MENU при нажатии вне его
-- ====================================================
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if trollListFrame and trollMenuOpen then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = trollListFrame.AbsolutePosition
            local frameSize = trollListFrame.AbsoluteSize
            if not (mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                    mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y) then
                trollListFrame:Destroy()
                trollMenuOpen = false
            end
        end
    end
end)

-- ====================================================
-- 8. ОБНОВЛЕНИЕ ПЕРСОНАЖА
-- ====================================================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    if flyEnabled then ToggleFly() end
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
end)

print("✅ Gregoo Ultra V2 загружен!")
print("🎮 Наслаждайся читами!")
print("💀 Troll: выкидывает игроков за карту")
