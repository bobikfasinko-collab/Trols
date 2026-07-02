-- ============================================
-- 🔥 MEGA CHIT PANEL v3.1 (FIXED)
-- Исправлено для Delta Mobile
-- ============================================

-- ОБХОД ОШИБОК ДЛЯ MOBILE
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ПРОВЕРКА НА СУЩЕСТВОВАНИЕ ПЕРСОНАЖА
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================

local speedEnabled = false
local currentSpeed = 16
local flyEnabled = false
local flySpeed = 50
local bodyVelocity = nil
local espEnabled = false
local espObjects = {}
local jumpEnabled = false
local infJumpEnabled = false
local noClipEnabled = false
local currentTab = "Speed"
local panelVisible = true
local isMobile = UserInputService.TouchEnabled

-- ============================================
-- СОЗДАНИЕ GUI (БЕЗ ОШИБОК)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegaPanel"
ScreenGui.ResetOnSpawn = false  -- ВАЖНО ДЛЯ MOBILE!
ScreenGui.Parent = Player.PlayerGui

-- ============================================
-- ОСНОВНАЯ ПАНЕЛЬ
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(80, 80, 255)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

-- ============================================
-- ЗАГОЛОВОК
-- ============================================

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔥 MEGA PANEL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- ============================================
-- КНОПКА ПОКАЗА (ПЛАВАЮЩАЯ)
-- ============================================

local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 60, 0, 60)
ShowButton.Position = UDim2.new(0, 15, 1, -80)
ShowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
ShowButton.Text = "🔥"
ShowButton.TextColor3 = Color3.fromRGB(255, 200, 0)
ShowButton.TextSize = 30
ShowButton.Font = Enum.Font.GothamBold
ShowButton.BorderSizePixel = 2
ShowButton.BorderColor3 = Color3.fromRGB(255, 200, 0)
ShowButton.Visible = false
ShowButton.Parent = ScreenGui

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(1, 0)
ShowCorner.Parent = ShowButton

-- ============================================
-- ВКЛАДКИ
-- ============================================

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local tabs = {"Speed", "Fly", "ESP", "Misc"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, -2, 1, -4)
    btn.Position = UDim2.new((i-1) * 0.25, 2, 0, 2)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 65)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = isMobile and 14 or 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentTab = tabName
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 40, 65)
        end
        updateTabs()
    end)
end

-- ============================================
-- КОНТЕЙНЕР ДЛЯ ВКЛАДОК
-- ============================================

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -10, 1, -135)
TabContainer.Position = UDim2.new(0, 5, 0, 95)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabContainer.BackgroundTransparency = 0.3
TabContainer.BorderSizePixel = 1
TabContainer.BorderColor3 = Color3.fromRGB(60, 60, 120)
TabContainer.ScrollBarThickness = 3
TabContainer.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 10)
ContainerCorner.Parent = TabContainer

-- ============================================
-- ФУНКЦИЯ ОЧИСТКИ КОНТЕЙНЕРА
-- ============================================

local function clearContainer()
    for _, child in ipairs(TabContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") or child:IsA("ScrollingFrame") then
            pcall(function() child:Destroy() end)
        end
    end
end

-- ============================================
-- ФУНКЦИЯ ОБНОВЛЕНИЯ ВКЛАДОК
-- ============================================

function updateTabs()
    clearContainer()
    
    if currentTab == "Speed" then
        createSpeedTab()
    elseif currentTab == "Fly" then
        createFlyTab()
    elseif currentTab == "ESP" then
        createESPTab()
    elseif currentTab == "Misc" then
        createMiscTab()
    end
end

-- ============================================
-- ВКЛАДКА SPEED
-- ============================================

function createSpeedTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    -- Кнопка SPEED
    local speedBtn = createButton(container, speedEnabled and "🟢 SPEED: ON" or "🔴 SPEED: OFF", speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50))
    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedBtn.Text = speedEnabled and "🟢 SPEED: ON" or "🔴 SPEED: OFF"
        speedBtn.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        if speedEnabled then
            pcall(function() Humanoid.WalkSpeed = currentSpeed end)
        else
            pcall(function() Humanoid.WalkSpeed = 16 end)
        end
    end)
    
    -- Дисплей
    local display = createLabel(container, "Скорость: " .. currentSpeed)
    
    -- Ползунок
    local slider = createSlider(container, currentSpeed, 1, 1000, function(val)
        currentSpeed = math.floor(val)
        display.Text = "Скорость: " .. currentSpeed
        if speedEnabled then
            pcall(function() Humanoid.WalkSpeed = currentSpeed end)
        end
    end)
    
    -- Кнопка сброса
    local resetBtn = createButton(container, "🔄 СБРОСИТЬ (16)", Color3.fromRGB(255, 180, 0))
    resetBtn.MouseButton1Click:Connect(function()
        currentSpeed = 16
        display.Text = "Скорость: 16"
        if speedEnabled then
            pcall(function() Humanoid.WalkSpeed = 16 end)
        end
        -- Обновляем ползунок
        for _, child in ipairs(container:GetChildren()) do
            if child.Name == "SliderFrame" then
                child:Destroy()
            end
        end
        slider = createSlider(container, 16, 1, 1000, function(val)
            currentSpeed = math.floor(val)
            display.Text = "Скорость: " .. currentSpeed
            if speedEnabled then
                pcall(function() Humanoid.WalkSpeed = currentSpeed end)
            end
        end)
    end)
end

-- ============================================
-- ВКЛАДКА FLY
-- ============================================

function createFlyTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    local flyBtn = createButton(container, flyEnabled and "🟢 FLY: ON" or "🔴 FLY: OFF", flyEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50))
    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        flyBtn.Text = flyEnabled and "🟢 FLY: ON" or "🔴 FLY: OFF"
        flyBtn.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        
        if flyEnabled then
            if bodyVelocity then pcall(function() bodyVelocity:Destroy() end) end
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            pcall(function() 
                bodyVelocity.Parent = Character:WaitForChild("HumanoidRootPart") 
            end)
            
            -- Простой полет вверх
            local flyConnection
            flyConnection = RunService.Heartbeat:Connect(function()
                if not flyEnabled or not bodyVelocity then
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                pcall(function()
                    bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
                end)
            end)
        else
            if bodyVelocity then
                pcall(function() bodyVelocity:Destroy() end)
                bodyVelocity = nil
            end
        end
    end)
    
    local display = createLabel(container, "Скорость полета: " .. flySpeed)
    
    createSlider(container, flySpeed, 10, 250, function(val)
        flySpeed = math.floor(val)
        display.Text = "Скорость полета: " .. flySpeed
    end)
end

-- ============================================
-- ВКЛАДКА ESP
-- ============================================

function createESPTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    local espBtn = createButton(container, espEnabled and "🟢 ESP: ON" or "🔴 ESP: OFF", espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50))
    espBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espBtn.Text = espEnabled and "🟢 ESP: ON" or "🔴 ESP: OFF"
        espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 50, 50)
        
        if espEnabled then
            pcall(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.OutlineTransparency = 0
                        table.insert(espObjects, highlight)
                    end
                end
            end)
        else
            pcall(function()
                for _, obj in ipairs(espObjects) do
                    if obj and obj:IsA("Highlight") then
                        obj:Destroy()
                    elseif obj and obj:IsA("RBXScriptConnection") then
                        obj:Disconnect()
                    end
                end
                espObjects = {}
            end)
        end
    end)
    
    local info = createLabel(container, "📡 Подсвечивает всех игроков")
    info.TextSize = 15
end

-- ============================================
-- ВКЛАДКА MISC
-- ============================================

function createMiscTab()
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container
    
    local jumpBtn = createButton(container, "🦘 Супер прыжок (OFF)", Color3.fromRGB(40, 40, 70))
    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        jumpBtn.Text = jumpEnabled and "🦘 Супер прыжок (ON)" or "🦘 Супер прыжок (OFF)"
        jumpBtn.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 70)
        pcall(function()
            Humanoid.JumpPower = jumpEnabled and 100 or 50
        end)
    end)
    
    local infJumpBtn = createButton(container, "♾️ Бесконечные прыжки (OFF)", Color3.fromRGB(40, 40, 70))
    infJumpBtn.MouseButton1Click:Connect(function()
        infJumpEnabled = not infJumpEnabled
        infJumpBtn.Text = infJumpEnabled and "♾️ Бесконечные прыжки (ON)" or "♾️ Бесконечные прыжки (OFF)"
        infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 70)
        if infJumpEnabled then
            pcall(function()
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    end
                end
            end)
        end
    end)
    
    local noclipBtn = createButton(container, "🔓 Noclip (OFF)", Color3.fromRGB(40, 40, 70))
    noclipBtn.MouseButton1Click:Connect(function()
        noClipEnabled = not noClipEnabled
        noclipBtn.Text = noClipEnabled and "🔓 Noclip (ON)" or "🔓 Noclip (OFF)"
        noclipBtn.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(40, 40, 70)
        pcall(function()
            local char = Player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not noClipEnabled
                    end
                end
            end
        end)
    end)
end

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (СОЗДАНИЕ ЭЛЕМЕНТОВ)
-- ============================================

function createButton(parent, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
    btn.Text = text or "Button"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = isMobile and 15 or 17
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    return btn
end

function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 35)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
    label.BackgroundTransparency = 0.3
    label.Text = text or "Label"
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.TextSize = isMobile and 16 or 18
    label.Font = Enum.Font.GothamBold
    label.BorderSizePixel = 1
    label.BorderColor3 = Color3.fromRGB(80, 80, 150)
    label.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    
    return label
end

function createSlider(parent, initial, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Name = "SliderFrame"
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.9, 0, 0, 6)
    bar.Position = UDim2.new(0.05, 0, 0.5, -3)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local knob = Instance.new("TextButton")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.Position = UDim2.new((initial - min) / (max - min), -11, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.Parent = frame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    knob.MouseButton1Down:Connect(function()
        local dragging = true
        local mouse = Player:GetMouse()
        
        local function update()
            if not dragging then return end
            local relX = math.clamp((mouse.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
            local val = min + relX * (max - min)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            knob.Position = UDim2.new(relX, -11, 0.5, -11)
            if callback then callback(val) end
        end
        
        local conn1 = mouse.Move:Connect(update)
        local conn2 = mouse.Button1Up:Connect(function()
            dragging = false
            conn1:Disconnect()
            conn2:Disconnect()
        end)
    end)
    
    return frame
end

-- ============================================
-- АНИМАЦИЯ ОТКРЫТИЯ/ЗАКРЫТИЯ (УПРОЩЕННАЯ)
-- ============================================

local function animatePanel(visible)
    if visible then
        MainFrame.Visible = true
        ShowButton.Visible = false
    else
        MainFrame.Visible = false
      
