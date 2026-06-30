--[[
  GREGOO ULTRA V3 — Неоновый стиль
  Исправленное меню, которое точно появится
--]]

if getgenv().GregooUltraV3 then return end
getgenv().GregooUltraV3 = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

-- ===== НАСТРОЙКИ ЦВЕТОВ (можешь менять) =====
local MAIN_COLOR = Color3.fromRGB(0, 200, 255)   -- основной неоновый
local BG_COLOR = Color3.fromRGB(10, 10, 25)      -- фон
local BUTTON_COLOR = Color3.fromRGB(30, 30, 60)  -- кнопки

-- ===== ПЕРЕМЕННЫЕ =====
local espEnabled = false
local espColor = Color3.fromRGB(0, 255, 0)
local flyEnabled = false
local speedEnabled = false
local speedValue = 16
local trollMenuOpen = false
local flyVelocity, flyGyro = nil, nil
local espHighlights = {}
local trollFrame = nil

-- ===== СОЗДАНИЕ GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GregooUltraV3"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно (тёмное, с неоновой рамкой)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 480)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = BG_COLOR
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = MAIN_COLOR
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ GREGOO ULTRA ⚡"
Title.TextColor3 = MAIN_COLOR
Title.TextSize = 32
Title.Font = Enum.Font.GothamBold
Title.TextStrokeColor = Color3.fromRGB(0, 100, 200)
Title.TextStrokeTransparency = 0.3
Title.Parent = MainFrame

-- Подзаголовок
local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, 0, 0, 25)
Sub.Position = UDim2.new(0, 0, 0, 50)
Sub.BackgroundTransparency = 1
Sub.Text = "created by Gregoo"
Sub.TextColor3 = Color3.fromRGB(150, 150, 200)
Sub.TextSize = 14
Sub.Font = Enum.Font.Gotham
Sub.TextStrokeTransparency = 0.5
Sub.Parent = MainFrame

-- Кнопка закрытия (крестик)
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close
Close.Parent = MainFrame
Close.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    if flyEnabled then ToggleFly() end
end)

-- Контейнер для кнопок
local BtnContainer = Instance.new("Frame")
BtnContainer.Size = UDim2.new(1, -30, 1, -90)
BtnContainer.Position = UDim2.new(0, 15, 0, 80)
BtnContainer.BackgroundTransparency = 1
BtnContainer.Parent = MainFrame

-- Функция создания кнопки
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = BUTTON_COLOR
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = MAIN_COLOR
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.Parent = BtnContainer
    
    -- Эффект при наведении
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0.1
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.3
        btn.BorderColor3 = MAIN_COLOR
    end)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. ESP
local espBtn = createButton("👁️ ESP (выкл)", 0, function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "👁️ ESP (вкл)"
        espBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
        ApplyESP()
    else
        espBtn.Text = "👁️ ESP (выкл)"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RemoveESP()
    end
end)

-- Кнопка смены цвета ESP (прямо на кнопке)
local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(0.25, 0, 0, 30)
colorBtn.Position = UDim2.new(0.7, 0, 0, 10)
colorBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
colorBtn.Text = "цвет"
colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
colorBtn.TextSize = 16
colorBtn.Font = Enum.Font.GothamBold
colorBtn.BorderSizePixel = 0
local colCorner = Instance.new("UICorner")
colCorner.CornerRadius = UDim.new(0, 6)
colCorner.Parent = colorBtn
colorBtn.Parent = espBtn
colorBtn.MouseButton1Click:Connect(function()
    espColor = Color3.fromHSV(math.random(), 0.8, 0.8)
    if espEnabled then ApplyESP() end
end)

-- 2. Fly
local flyBtn = createButton("🪂 Fly (выкл)", 60, function()
    ToggleFly()
    if flyEnabled then
        flyBtn.Text = "🪂 Fly (вкл)"
        flyBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    else
        flyBtn.Text = "🪂 Fly (выкл)"
        flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 3. Speed Hack
local speedBtn = createButton("💨 Speed ("..speedValue..")", 120, function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedBtn.Text = "💨 Speed ("..speedValue..") [ON]"
        speedBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        Humanoid.WalkSpeed = speedValue
    else
        speedBtn.Text = "💨 Speed ("..speedValue..")"
        speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Humanoid.WalkSpeed = 16
    end
end)
-- кнопки +/-
local sUp = Instance.new("TextButton")
sUp.Size = UDim2.new(0.12, 0, 0, 28)
sUp.Position = UDim2.new(0.7, 0, 0, 11)
sUp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
sUp.Text = "+"
sUp.TextColor3 = Color3.fromRGB(255,255,255)
sUp.TextSize = 22
sUp.Font = Enum.Font.GothamBold
sUp.BorderSizePixel = 0
sUp.Parent = speedBtn
sUp.MouseButton1Click:Connect(function()
    speedValue = math.min(speedValue + 5, 100)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed ("..speedValue..")" .. (speedEnabled and " [ON]" or "")
end)
local sDown = Instance.new("TextButton")
sDown.Size = UDim2.new(0.12, 0, 0, 28)
sDown.Position = UDim2.new(0.85, 0, 0, 11)
sDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
sDown.Text = "-"
sDown.TextColor3 = Color3.fromRGB(255,255,255)
sDown.TextSize = 22
sDown.Font = Enum.Font.GothamBold
sDown.BorderSizePixel = 0
sDown.Parent = speedBtn
sDown.MouseButton1Click:Connect(function()
    speedValue = math.max(speedValue - 5, 10)
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
    speedBtn.Text = "💨 Speed ("..speedValue..")" .. (speedEnabled and " [ON]" or "")
end)

-- 4. Troll
local trollBtn = createButton("💀 Troll (выкинуть)", 180, function()
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
    trollFrame.Size = UDim2.new(0, 250, 0, 300)
    trollFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    trollFrame.BackgroundColor3 = BG_COLOR
    trollFrame.BackgroundTransparency = 0.1
    trollFrame.BorderSizePixel = 2
    trollFrame.BorderColor3 = Color3.fromRGB(255, 100, 100)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = trollFrame
    trollFrame.Parent = ScreenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "Выберите жертву"
    title.TextColor3 = Color3.fromRGB(255, 200, 100)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = trollFrame
    
    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -10, 1, -50)
    container.Position = UDim2.new(0, 5, 0, 45)
    container.BackgroundTransparency = 1
    container.CanvasSize = UDim2.new(0,0,0,0)
    container.ScrollBarThickness = 6
    container.Parent = trollFrame
    
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.Position = UDim2.new(0,0,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,80)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.TextSize = 18
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 1
            btn.BorderColor3 = Color3.fromRGB(255,255,255)
            local corner2 = Instance.new("UICorner")
            corner2.CornerRadius = UDim.new(0, 6)
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
            y = y + 45
            container.CanvasSize = UDim2.new(0,0,0,y)
        end
    end
    if y == 0 then
        local none = Instance.new("TextLabel")
        none.Size = UDim2.new(1,0,0,50)
        none.BackgroundTransparency = 1
        none.Text = "Нет других игроков"
        none.TextColor3 = Color3.fromRGB(200,200,200)
        none.TextSize = 18
        none.Font = Enum.Font.Gotham
        none.Parent = container
    end
end

-- Закрытие Troll меню при клике вне
UserInputService.InputBegan:Connect(function(input, isTyping)
    if isTyping then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and trollFrame and trollMenuOpen then
        local pos = UserInputService:GetMouseLocation()
        local abs = trollFrame.AbsolutePosition
        local size = trollFrame.AbsoluteSize
        if not (pos.X >= abs.X and pos.X <= abs.X + size.X and pos.Y >= abs.Y and pos.Y <= abs.Y + size.Y) then
            trollFrame:Destroy()
            trollMenuOpen = false
        end
    end
end)

-- Обновление персонажа
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    if flyEnabled then ToggleFly() end
    if speedEnabled then Humanoid.WalkSpeed = speedValue end
end)

print("✅ Gregoo Ultra V3 загружен! Стильный неон.")
