local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existingGui = playerGui:FindFirstChild("UpdateGui")
if existingGui then
    existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UpdateGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 340, 0, 200)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Transparency = 0.85
uiStroke.Thickness = 1.2
uiStroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -30, 0, 32)
titleLabel.Position = UDim2.new(0, 15, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ MISE À JOUR"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = mainFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Size = UDim2.new(1, -30, 0, 80)
messageLabel.Position = UDim2.new(0, 15, 0, 55)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "• Nouvelle mise à jour !\n• Nouveau GUI\n• Nouvelles Options\n• Nouveau Exploit"
messageLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
messageLabel.TextSize = 14
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.TextYAlignment = Enum.TextYAlignment.Top
messageLabel.TextWrapped = true
messageLabel.LineHeight = 1.4
messageLabel.TextTransparency = 1
messageLabel.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, -30, 0, 1)
divider.Position = UDim2.new(0, 15, 0, 142)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.9
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(1, -30, 0, 36)
closeButton.Position = UDim2.new(0, 15, 0, 150)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 0.92
closeButton.BorderSizePixel = 0
closeButton.Text = "FERMER"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.AutoButtonColor = false
closeButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = closeButton

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 60, 230))
})
buttonGradient.Rotation = 90
buttonGradient.Parent = closeButton

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local fadeIn = TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = 0.15 })
local titleIn = TweenService:Create(titleLabel, tweenInfo, { TextTransparency = 0 })
local messageIn = TweenService:Create(messageLabel, tweenInfo, { TextTransparency = 0 })
local closeIn = TweenService:Create(closeButton, tweenInfo, { TextTransparency = 0 })
local scaleIn = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 340, 0, 200) })

mainFrame.Size = UDim2.new(0, 300, 0, 160)

fadeIn:Play()
titleIn:Play()
messageIn:Play()
closeIn:Play()
scaleIn:Play()

local isClosing = false

local function closeGui()
    if isClosing then return end
    isClosing = true
    
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
    local titleOut = TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { TextTransparency = 1 })
    local messageOut = TweenService:Create(messageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { TextTransparency = 1 })
    local closeOut = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { TextTransparency = 1 })
    local scaleOut = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 280, 0, 140) })
    
    fadeOut:Play()
    titleOut:Play()
    messageOut:Play()
    closeOut:Play()
    scaleOut:Play()
    
    scaleOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.85 }):Play()
    TweenService:Create(buttonGradient, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 80, 245))
        })
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.92 }):Play()
    TweenService:Create(buttonGradient, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 80, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 60, 230))
        })
    }):Play()
end)

closeButton.MouseButton1Click:Connect(closeGui)

task.delay(6, function()
    if not isClosing then
        closeGui()
    end
end)
