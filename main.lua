local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name = "BackgroundBlur"
blur.Size = 0
blur.Parent = screenGui

local darkOverlay = Instance.new("Frame")
darkOverlay.Name = "DarkOverlay"
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkOverlay.BackgroundTransparency = 1
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 0
darkOverlay.Parent = screenGui

local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 420, 0, 210)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundTransparency = 1
mainContainer.BorderSizePixel = 0
mainContainer.ZIndex = 1
mainContainer.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 1
mainFrame.Parent = mainContainer

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Transparency = 0.93
uiStroke.Thickness = 0.5
uiStroke.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.65
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0
shadow.Parent = mainFrame

local accentGlow = Instance.new("Frame")
accentGlow.Name = "AccentGlow"
accentGlow.Size = UDim2.new(0, 4, 1, -20)
accentGlow.Position = UDim2.new(0, 0, 0, 10)
accentGlow.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
accentGlow.BorderSizePixel = 0
accentGlow.ZIndex = 2
accentGlow.Parent = mainFrame

local accentGlowCorner = Instance.new("UICorner")
accentGlowCorner.CornerRadius = UDim.new(1, 0)
accentGlowCorner.Parent = accentGlow

local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255))
})
accentGradient.Rotation = 180
accentGradient.Parent = accentGlow

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -32, 1, -28)
contentFrame.Position = UDim2.new(0, 22, 0, 16)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 1
contentFrame.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 28)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Name = "DotIndicator"
dotIndicator.Size = UDim2.new(0, 6, 0, 6)
dotIndicator.Position = UDim2.new(0, 0, 0, 4)
dotIndicator.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = headerFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 100, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "CHANGELOG"
titleLabel.TextColor3 = Color3.fromRGB(160, 165, 190)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = headerFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 0, 32)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "Nebula Hub Update"
versionLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
versionLabel.TextSize = 22
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextTransparency = 1
versionLabel.Parent = contentFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 72)
messageLabel.Position = UDim2.new(0, 0, 0, 68)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "• Nouvelles options/catégorie ajoutées\n• Fix bugs\n• Nouveaux Exploits\n• Nebula revient prochainement 😉"
messageLabel.TextColor3 = Color3.fromRGB(135, 140, 165)
messageLabel.TextSize = 12
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.TextYAlignment = Enum.TextYAlignment.Top
messageLabel.TextWrapped = true
messageLabel.LineHeight = 1.55
messageLabel.TextTransparency = 1
messageLabel.Parent = contentFrame

local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 148)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.95
divider.BorderSizePixel = 0
divider.Parent = contentFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 90, 0, 30)
closeButton.Position = UDim2.new(0, 0, 0, 158)
closeButton.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
closeButton.BackgroundTransparency = 0.88
closeButton.BorderSizePixel = 0
closeButton.Text = "Compris"
closeButton.TextColor3 = Color3.fromRGB(210, 210, 230)
closeButton.TextSize = 11
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.AutoButtonColor = false
closeButton.ZIndex = 1
closeButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 5)
buttonCorner.Parent = closeButton

local buttonGradient = Instance.new("UIGradient")
buttonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 160, 245))
})
buttonGradient.Rotation = 90
buttonGradient.Parent = closeButton

local isClosing = false

local function closeGui()
    if isClosing then return end
    isClosing = true

    TweenService:Create(blur, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = 0 }):Play()
    TweenService:Create(darkOverlay, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
    
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
    local scaleOut = TweenService:Create(mainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(0, 380, 0, 185) })
    local posOut = TweenService:Create(mainContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0.5, 0, 0.52, 0) })

    for _, element in pairs(contentFrame:GetChildren()) do
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            TweenService:Create(element, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { TextTransparency = 1 }):Play()
        end
    end

    TweenService:Create(accentGlow, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Transparency = 1 }):Play()
    TweenService:Create(dotIndicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()

    fadeOut:Play()
    scaleOut:Play()
    posOut:Play()

    posOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

TweenService:Create(blur, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = 8 }):Play()
TweenService:Create(darkOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.45 }):Play()

local fadeIn = TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = 0.3 })
local scaleIn = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 420, 0, 210) })
local posIn = TweenService:Create(mainContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) })

mainContainer.Size = UDim2.new(0, 370, 0, 175)
mainContainer.Position = UDim2.new(0.5, 0, 0.52, 0)

local allTextElements = {}
for _, element in pairs(contentFrame:GetChildren()) do
    if element:IsA("TextLabel") or element:IsA("TextButton") then
        table.insert(allTextElements, element)
    end
end
table.insert(allTextElements, titleLabel)
table.insert(allTextElements, dotIndicator)

fadeIn:Play()
scaleIn:Play()
posIn:Play()

for i, element in ipairs(allTextElements) do
    task.delay(i * 0.05, function()
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            TweenService:Create(element, tweenInfo, { TextTransparency = 0 }):Play()
        elseif element.Name == "DotIndicator" then
            TweenService:Create(element, tweenInfo, { BackgroundTransparency = 0 }):Play()
        end
    end)
end

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.78,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    TweenService:Create(buttonGradient, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 140, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 180, 255))
        })
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.88,
        TextColor3 = Color3.fromRGB(210, 210, 230)
    }):Play()
    TweenService:Create(buttonGradient, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 120, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 160, 245))
        })
    }):Play()
end)

closeButton.MouseButton1Click:Connect(closeGui)
