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
mainFrame.Size = UDim2.new(0, 380, 0, 180)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Transparency = 0.92
uiStroke.Thickness = 0.5
uiStroke.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = -1
shadow.Parent = mainFrame

local accentLine = Instance.new("Frame")
accentLine.Name = "AccentLine"
accentLine.Size = UDim2.new(0, 3, 1, -16)
accentLine.Position = UDim2.new(0, 0, 0, 8)
accentLine.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
accentLine.BorderSizePixel = 0
accentLine.Parent = mainFrame

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(1, 0)
accentCorner.Parent = accentLine

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -24, 1, -24)
contentFrame.Position = UDim2.new(0, 16, 0, 12)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 22)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "CHANGELOG Nebula"
titleLabel.TextColor3 = Color3.fromRGB(180, 185, 210)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = contentFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(1, -60, 0, 24)
versionLabel.Position = UDim2.new(0, 0, 0, 24)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.4.0"
versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
versionLabel.TextSize = 20
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextTransparency = 1
versionLabel.Parent = contentFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name = "MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 64)
messageLabel.Position = UDim2.new(0, 0, 0, 52)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "• Nouvelle interface optimisée\n• Nouvelles options de configuration\n• Corrections de bugs"
messageLabel.TextColor3 = Color3.fromRGB(140, 145, 170)
messageLabel.TextSize = 12
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextXAlignment = Enum.TextXAlignment.Left
messageLabel.TextYAlignment = Enum.TextYAlignment.Top
messageLabel.TextWrapped = true
messageLabel.LineHeight = 1.5
messageLabel.TextTransparency = 1
messageLabel.Parent = contentFrame

local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 124)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.94
divider.BorderSizePixel = 0
divider.Parent = contentFrame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 80, 0, 28)
closeButton.Position = UDim2.new(0, 0, 0, 136)
closeButton.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
closeButton.BackgroundTransparency = 0.9
closeButton.BorderSizePixel = 0
closeButton.Text = "Compris"
closeButton.TextColor3 = Color3.fromRGB(200, 205, 230)
closeButton.TextSize = 11
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.AutoButtonColor = false
closeButton.Parent = contentFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = closeButton

local isClosing = false

local function closeGui()
    if isClosing then return end
    isClosing = true
    
    local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
    local elementsOut = TweenService:Create(contentFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(0, 16, 0, 16) })
    local scaleOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(0, 360, 0, 160) })
    
    for _, element in pairs(contentFrame:GetChildren()) do
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            TweenService:Create(element, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { TextTransparency = 1 }):Play()
        end
    end
    
    TweenService:Create(accentLine, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(uiStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Transparency = 1 }):Play()
    
    fadeOut:Play()
    elementsOut:Play()
    scaleOut:Play()
    
    scaleOut.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local fadeIn = TweenService:Create(mainFrame, tweenInfo, { BackgroundTransparency = 0.35 })
local elementsIn = TweenService:Create(contentFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(0, 16, 0, 12) })
local scaleIn = TweenService:Create(mainFrame, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 380, 0, 180) })

contentFrame.Position = UDim2.new(0, 16, 0, 16)
mainFrame.Size = UDim2.new(0, 350, 0, 155)

local allTextElements = {}
for _, element in pairs(contentFrame:GetChildren()) do
    if element:IsA("TextLabel") or element:IsA("TextButton") then
        table.insert(allTextElements, element)
    end
end

fadeIn:Play()
elementsIn:Play()
scaleIn:Play()

for i, element in ipairs(allTextElements) do
    task.delay(i * 0.06, function()
        TweenService:Create(element, tweenInfo, { TextTransparency = 0 }):Play()
    end)
end

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { 
        BackgroundTransparency = 0.8,
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { 
        BackgroundTransparency = 0.9,
        TextColor3 = Color3.fromRGB(200, 205, 230)
    }):Play()
end)

closeButton.MouseButton1Click:Connect(closeGui)

task.delay(6, function()
    if not isClosing then
        closeGui()
    end
end)
