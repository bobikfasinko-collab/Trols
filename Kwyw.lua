--[[
  ⚡ ОПРОСНИК ДЛЯ ДРУГА ⚡
  by Gregoo
--]]

if getgenv().QuizGame then return end
getgenv().QuizGame = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuizGame"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- ====================================================
-- 1. ГЛАВНОЕ ОКНО
-- ====================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame
MainFrame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.12, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "📋 ОПРОСНИК"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Контейнер для контента
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -0.15)
Content.Position = UDim2.new(0, 10, 0.13, 0)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- ====================================================
-- 2. ПЕРЕМЕННЫЕ
-- ====================================================
local currentQuestion = 1
local totalQuestions = 3
local answers = {
    [1] = { text = "кокос", correct = true },
    [2] = { text = "анюта", correct = true },
    [3] = { text = "девушка", correct = false }  -- false = правильный ответ "друзья"
}
local userAnswers = {}

-- ====================================================
-- 3. ФУНКЦИЯ ОЧИСТКИ КОНТЕНТА
-- ====================================================
local function clearContent()
    for _, child in pairs(Content:GetChildren()) do
        child:Destroy()
    end
end

-- ====================================================
-- 4. ФУНКЦИЯ ПОКАЗА ВОПРОСА
-- ====================================================
local function showQuestion()
    clearContent()
    
    local questionText = Instance.new("TextLabel")
    questionText.Size = UDim2.new(1, 0, 0.2, 0)
    questionText.Position = UDim2.new(0, 0, 0, 0)
    questionText.BackgroundTransparency = 1
    questionText.TextColor3 = Color3.fromRGB(255, 255, 255)
    questionText.TextScaled = true
    questionText.Font = Enum.Font.GothamBold
    questionText.Parent = Content
    
    if currentQuestion == 1 then
        questionText.Text = "1/3 как тебя зовут?"
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0.8, 0, 0.2, 0)
        input.Position = UDim2.new(0.1, 0, 0.3, 0)
        input.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.PlaceholderText = "Введи имя..."
        input.TextScaled = true
        input.Font = Enum.Font.Gotham
        input.BorderSizePixel = 2
        input.BorderColor3 = Color3.fromRGB(100, 100, 200)
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 8)
        inputCorner.Parent = input
        input.Parent = Content
        
        local submitBtn = Instance.new("TextButton")
        submitBtn.Size = UDim2.new(0.5, 0, 0.15, 0)
        submitBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        submitBtn.Text = "✅ Ответить"
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.TextScaled = true
        submitBtn.Font = Enum.Font.GothamBold
        submitBtn.BorderSizePixel = 0
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = submitBtn
        submitBtn.Parent = Content
        
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, 0, 0.15, 0)
        resultLabel.Position = UDim2.new(0, 0, 0.8, 0)
        resultLabel.BackgroundTransparency = 1
        resultLabel.Text = ""
        resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        resultLabel.TextScaled = true
        resultLabel.Font = Enum.Font.GothamBold
        resultLabel.Parent = Content
        
        submitBtn.MouseButton1Click:Connect(function()
            local answer = string.lower(input.Text)
            if answer == "кокос" then
                resultLabel.Text = "✅ Правельно!"
                resultLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                userAnswers[currentQuestion] = true
                wait(0.8)
                currentQuestion = 2
                showQuestion()
            else
                resultLabel.Text = "❌ Неправильно!!"
                resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                input.Text = ""
            end
        end)
        submitBtn.TouchTap:Connect(function()
            local answer = string.lower(input.Text)
            if answer == "кокос" then
                resultLabel.Text = "✅ Правельно!"
                resultLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                userAnswers[currentQuestion] = true
                wait(0.8)
                currentQuestion = 2
                showQuestion()
            else
                resultLabel.Text = "❌ Неправильно!!"
                resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                input.Text = ""
            end
        end)
        
    elseif currentQuestion == 2 then
        questionText.Text = "2/3 кто тебя бесит?"
        
        local input = Instance.new("TextBox")
        input.Size = UDim2.new(0.8, 0, 0.2, 0)
        input.Position = UDim2.new(0.1, 0, 0.3, 0)
        input.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        input.TextColor3 = Color3.fromRGB(255, 255, 255)
        input.PlaceholderText = "Введи имя..."
        input.TextScaled = true
        input.Font = Enum.Font.Gotham
        input.BorderSizePixel = 2
        input.BorderColor3 = Color3.fromRGB(100, 100, 200)
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, 8)
        inputCorner.Parent = input
        input.Parent = Content
        
        local submitBtn = Instance.new("TextButton")
        submitBtn.Size = UDim2.new(0.5, 0, 0.15, 0)
        submitBtn.Position = UDim2.new(0.25, 0, 0.6, 0)
        submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        submitBtn.Text = "✅ Ответить"
        submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        submitBtn.TextScaled = true
        submitBtn.Font = Enum.Font.GothamBold
        submitBtn.BorderSizePixel = 0
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = submitBtn
        submitBtn.Parent = Content
        
        local resultLabel = Instance.new("TextLabel")
        resultLabel.Size = UDim2.new(1, 0, 0.15, 0)
        resultLabel.Position = UDim2.new(0, 0, 0.8, 0)
        resultLabel.BackgroundTransparency = 1
        resultLabel.Text = ""
        resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        resultLabel.TextScaled = true
        resultLabel.Font = Enum.Font.GothamBold
        resultLabel.Parent = Content
        
        submitBtn.MouseButton1Click:Connect(function()
            local answer = string.lower(input.Text)
            if answer == "анюта" then
                resultLabel.Text = "✅ Молодец!"
                resultLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                userAnswers[currentQuestion] = true
                wait(0.8)
                currentQuestion = 3
                showQuestion()
            else
                resultLabel.Text = "❌ ты знаеш кто тебя бесит"
                resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                input.Text = ""
            end
        end)
        submitBtn.TouchTap:Connect(function()
            local answer = string.lower(input.Text)
            if answer == "анюта" then
                resultLabel.Text = "✅ Молодец!"
                resultLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                userAnswers[currentQuestion] = true
                wait(0.8)
                currentQuestion = 3
                showQuestion()
            else
                resultLabel.Text = "❌ ты знаеш кто тебя бесит"
                resultLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                input.Text = ""
            end
        end)
        
    elseif currentQuestion == 3 then
        questionText.Text = "3/3 кто?"
        questionText.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        -- Кнопка "друзья"
        local friendsBtn = Instance.new("TextButton")
        friendsBtn.Size = UDim2.new(0.4, 0, 0.25, 0)
        friendsBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
        friendsBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        friendsBtn.Text = "👫 Друзья"
        friendsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        friendsBtn.TextScaled = true
        friendsBtn.Font = Enum.Font.GothamBold
        friendsBtn.BorderSizePixel = 2
        friendsBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        local fCorner = Instance.new("UICorner")
        fCorner.CornerRadius = UDim.new(0, 10)
        fCorner.Parent = friendsBtn
        friendsBtn.Parent = Content
        
        friendsBtn.MouseButton1Click:Connect(function()
            showFinalResult("friends")
        end)
        friendsBtn.TouchTap:Connect(function()
            showFinalResult("friends")
        end)
        
        -- Кнопка "девушка"
        local girlBtn = Instance.new("TextButton")
        girlBtn.Size = UDim2.new(0.4, 0, 0.25, 0)
        girlBtn.Position = UDim2.new(0.55, 0, 0.3, 0)
        girlBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        girlBtn.Text = "💕 Девушка"
        girlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        girlBtn.TextScaled = true
        girlBtn.Font = Enum.Font.GothamBold
        girlBtn.BorderSizePixel = 2
        girlBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
        local gCorner = Instance.new("UICorner")
        gCorner.CornerRadius = UDim.new(0, 10)
        gCorner.Parent = girlBtn
        girlBtn.Parent = Content
        
        girlBtn.MouseButton1Click:Connect(function()
            showFinalResult("girl")
        end)
        girlBtn.TouchTap:Connect(function()
            showFinalResult("girl")
        end)
    end
end

-- ====================================================
-- 5. ФУНКЦИЯ ФИНАЛЬНОГО РЕЗУЛЬТАТА
-- ====================================================
function showFinalResult(choice)
    clearContent()
    
    if choice == "girl" then
        -- Чёрный экран на весь экран
        local blackScreen = Instance.new("Frame")
        blackScreen.Size = UDim2.new(1, 0, 1, 0)
        blackScreen.Position = UDim2.new(0, 0, 0, 0)
        blackScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        blackScreen.BackgroundTransparency = 0
        blackScreen.ZIndex = 10
        blackScreen.Parent = ScreenGui
        
        local sadText = Instance.new("TextLabel")
        sadText.Size = UDim2.new(1, 0, 0.3, 0)
        sadText.Position = UDim2.new(0, 0, 0.35, 0)
        sadText.BackgroundTransparency = 1
        sadText.Text = "ты был избранником!\nНо ты предал нас☹️😢"
        sadText.TextColor3 = Color3.fromRGB(255, 255, 255)
        sadText.TextScaled = true
        sadText.Font = Enum.Font.GothamBold
        sadText.TextStrokeColor = Color3.fromRGB(255, 0, 0)
        sadText.TextStrokeTransparency = 0.2
        sadText.ZIndex = 11
        sadText.Parent = ScreenGui
        
        -- Кнопка закрыть
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0.4, 0, 0.08, 0)
        closeBtn.Position = UDim2.new(0.3, 0, 0.8, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Text = "✕ Закрыть"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextScaled = true
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 8)
        cCorner.Parent = closeBtn
        closeBtn.ZIndex = 11
        closeBtn.Parent = ScreenGui
        
        closeBtn.MouseButton1Click:Connect(function()
            blackScreen:Destroy()
            sadText:Destroy()
            closeBtn:Destroy()
            MainFrame.Visible = false
        end)
        closeBtn.TouchTap:Connect(function()
            blackScreen:Destroy()
            sadText:Destroy()
            closeBtn:Destroy()
            MainFrame.Visible = false
        end)
        
    else
        -- Друзья
        local winText = Instance.new("TextLabel")
        winText.Size = UDim2.new(1, 0, 0.2, 0)
        winText.Position = UDim2.new(0, 0, 0.3, 0)
        winText.BackgroundTransparency = 1
        winText.Text = "✅ Молодец!"
        winText.TextColor3 = Color3.fromRGB(0, 255, 100)
        winText.TextScaled = true
        winText.Font = Enum.Font.GothamBold
        winText.Parent = Content
        
        local subText = Instance.new("TextLabel")
        subText.Size = UDim2.new(1, 0, 0.15, 0)
        subText.Position = UDim2.new(0, 0, 0.5, 0)
        subText.BackgroundTransparency = 1
        subText.Text = "Ты выбрал друзей! 🎉"
        subText.TextColor3 = Color3.fromRGB(255, 200, 100)
        subText.TextScaled = true
        subText.Font = Enum.Font.Gotham
        subText.Parent = Content
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0.4, 0, 0.12, 0)
        closeBtn.Position = UDim2.new(0.3, 0, 0.7, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        closeBtn.Text = "✅ Закрыть"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextScaled = true
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.BorderSizePixel = 0
        local cCorner = Instance.new("UICorner")
        cCorner.CornerRadius = UDim.new(0, 8)
        cCorner.Parent = closeBtn
        closeBtn.Parent = Content
        
        closeBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = false
        end)
        closeBtn.TouchTap:Connect(function()
            MainFrame.Visible = false
        end)
    end
end

-- ====================================================
-- 6. ЗАПУСК ОПРОСА
-- ====================================================
showQuestion()

-- ====================================================
-- 7. КНОПКА ПОКАЗА/СКРЫТИЯ МЕНЮ
-- ====================================================
local ShowBtn = Instance.new("TextButton")
ShowBtn.Size = UDim2.new(0, 60, 0, 60)
ShowBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
ShowBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ShowBtn.Text = "📋"
ShowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowBtn.TextSize = 30
ShowBtn.Font = Enum.Font.GothamBold
ShowBtn.BorderSizePixel = 2
ShowBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
local showCorner = Instance.new("UICorner")
showCorner.CornerRadius = UDim.new(1, 0)
showCorner.Parent = ShowBtn
ShowBtn.Parent = ScreenGui

ShowBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
    end
end)
ShowBtn.TouchTap:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
    end
end)

print("✅ Опросник загружен!")
print("📋 Нажми 📋 чтобы показать/скрыть")
