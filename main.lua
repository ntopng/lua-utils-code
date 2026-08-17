local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
HttpService = game:GetService("HttpService")
TeleportService = game:GetService("TeleportService")
ProximityPromptService = game:GetService("ProximityPromptService")
UserService = game:GetService("UserService")
local LocalPlayer = Players.LocalPlayer
Camera = workspace.CurrentCamera
Lighting = game:GetService("Lighting")

Nebula = {
    Version ="1.0",
    Open = true,
    TeleportPoints = {}
}

flick_script = [[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local ESPDistance_Enabled = false
local Skeleton_Enabled = false
local Tracer_Enabled = false
local HealthBar_Enabled = false
local Aimlock_Enabled = false
local ESP_Objects = {}
local ESP_Connections = {}
local FOV_RADIUS = 150
local PredictionBoost = 1.2
local PredictionTravelTime = 0.08
local PredictionDistanceFactor = 1 / 1800
local fovCircle = nil
local fovCrosshair = nil
local draggingSlider = false
local camera = workspace.CurrentCamera
local aimlockConnection = nil
local AimlockKey = Enum.UserInputType.MouseButton1
local waitingForKey = false
local isMouseButton = true
local guiVisible = true
local fovCircleVisible = false
local currentTarget = nil

local Whitelist = {}
local WhitelistDropdownOpen = false
local WhitelistDropdown = nil

local dragging = false
local dragStartPos = nil
local frameStartPos = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name ="EternalFlick_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = game:GetService("CoreGui")

local BackgroundDimmer = Instance.new("Frame")
BackgroundDimmer.Name = "BackgroundDimmer"
BackgroundDimmer.Size = UDim2.new(1, 0, 1, 0)
BackgroundDimmer.Position = UDim2.new(0, 0, 0, 0)
BackgroundDimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundDimmer.BackgroundTransparency = 0.2
BackgroundDimmer.BorderSizePixel = 0
BackgroundDimmer.ZIndex = 1
BackgroundDimmer.Active = false
BackgroundDimmer.Parent = ScreenGui

local BubblesContainer = Instance.new("Frame")
BubblesContainer.Name = "BubblesContainer"
BubblesContainer.Size = UDim2.new(1, 0, 1, 0)
BubblesContainer.Position = UDim2.new(0, 0, 0, 0)
BubblesContainer.BackgroundTransparency = 1
BubblesContainer.ClipsDescendants = true
BubblesContainer.ZIndex = 2
BubblesContainer.Active = false
BubblesContainer.Parent = ScreenGui

local bubbles = {}
local numBubbles = 26
for i = 1, numBubbles do
    local b = Instance.new("Frame")
    local size = math.random(8, 26)
    b.Size = UDim2.new(0, size, 0, size)
    b.BackgroundColor3 = (math.random() > 0.45) and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(120, 200, 255)
    b.BackgroundTransparency = math.random(60, 85) / 100
    b.BorderSizePixel = 0
    b.ZIndex = 2
    b.Parent = BubblesContainer
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(1, 0)
    bc.Parent = b
    local bs = Instance.new("UIStroke")
    bs.Color = Color3.fromRGB(255, 255, 255)
    bs.Transparency = math.random(75, 92) / 100
    bs.Thickness = 1
    bs.Parent = b
    local bubbleData = {
        frame = b,
        x = math.random(),
        y = math.random(),
        speed = math.random(35, 95) / 1000,
        swaySpeed = math.random(12, 28) / 10,
        swayAmp = math.random(6, 20) / 1000,
        offset = math.random() * math.pi * 2
    }
    b.Position = UDim2.new(bubbleData.x, 0, bubbleData.y, 0)
    table.insert(bubbles, bubbleData)
end

RunService.RenderStepped:Connect(function(dt)
    if not guiVisible then return end
    local t = tick()
    for _, b in ipairs(bubbles) do
        b.y = b.y + b.speed * dt
        if b.y > 1.05 then
            b.y = -0.05
            b.x = math.random()
        end
        local curX = b.x + math.sin(t * b.swaySpeed + b.offset) * b.swayAmp
        b.frame.Position = UDim2.new(curX, 0, b.y, 0)
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 420)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 12)
MainFrameCorner.Parent = MainFrame

local MainFrameStroke = Instance.new("UIStroke")
MainFrameStroke.Color = Color3.fromRGB(40, 40, 58)
MainFrameStroke.Thickness = 1.5
MainFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainFrameStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundTransparency = 1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 2)
AccentBar.Position = UDim2.new(0, 0, 0, 0)
AccentBar.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
AccentBar.BorderSizePixel = 0
AccentBar.Parent = TitleBar

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -2)
Sidebar.Position = UDim2.new(0, 0, 0, 2)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Color3.fromRGB(30, 30, 40)
SidebarStroke.Thickness = 1
SidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SidebarStroke.Parent = Sidebar

local SidebarHeader = Instance.new("Frame")
SidebarHeader.Size = UDim2.new(1, 0, 0, 56)
SidebarHeader.Position = UDim2.new(0, 0, 0, 0)
SidebarHeader.BackgroundTransparency = 1
SidebarHeader.BorderSizePixel = 0
SidebarHeader.Parent = Sidebar

local SidebarHeaderSep = Instance.new("Frame")
SidebarHeaderSep.Size = UDim2.new(1, 0, 0, 1)
SidebarHeaderSep.Position = UDim2.new(0, 0, 1, -1)
SidebarHeaderSep.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SidebarHeaderSep.BorderSizePixel = 0
SidebarHeaderSep.Parent = SidebarHeader

local TitleLine1 = Instance.new("TextLabel")
TitleLine1.Size = UDim2.new(1, -10, 0, 18)
TitleLine1.Position = UDim2.new(0, 10, 0, 10)
TitleLine1.BackgroundTransparency = 1
TitleLine1.Text ="ETERNAL"
TitleLine1.TextColor3 = Color3.fromRGB(60, 160, 255)
TitleLine1.Font = Enum.Font.Code
TitleLine1.TextSize = 13
TitleLine1.TextXAlignment = Enum.TextXAlignment.Left
TitleLine1.Parent = SidebarHeader

local TitleLine2 = Instance.new("TextLabel")
TitleLine2.Size = UDim2.new(1, -10, 0, 16)
TitleLine2.Position = UDim2.new(0, 10, 0, 28)
TitleLine2.BackgroundTransparency = 1
TitleLine2.Text ="FLICK"
TitleLine2.TextColor3 = Color3.fromRGB(60, 160, 255)
TitleLine2.Font = Enum.Font.Code
TitleLine2.TextSize = 13
TitleLine2.TextXAlignment = Enum.TextXAlignment.Left
TitleLine2.Parent = SidebarHeader

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, -10, 0, 12)
VersionLabel.Position = UDim2.new(0, 10, 0, 42)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text ="v2.0"
VersionLabel.TextColor3 = Color3.fromRGB(50, 50, 65)
VersionLabel.Font = Enum.Font.Code
VersionLabel.TextSize = 11
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = SidebarHeader

local NavMenu = Instance.new("Frame")
NavMenu.Size = UDim2.new(1, -12, 0, 128)
NavMenu.Position = UDim2.new(0, 6, 0, 60)
NavMenu.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
NavMenu.BorderSizePixel = 0
NavMenu.Parent = Sidebar

local NavMenuCorner = Instance.new("UICorner")
NavMenuCorner.CornerRadius = UDim.new(0, 8)
NavMenuCorner.Parent = NavMenu

local NavMenuStroke = Instance.new("UIStroke")
NavMenuStroke.Color = Color3.fromRGB(38, 38, 54)
NavMenuStroke.Thickness = 1
NavMenuStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
NavMenuStroke.Parent = NavMenu

local NavMenuPad = Instance.new("UIPadding")
NavMenuPad.PaddingTop = UDim.new(0, 4)
NavMenuPad.PaddingBottom = UDim.new(0, 4)
NavMenuPad.PaddingLeft = UDim.new(0, 4)
NavMenuPad.PaddingRight = UDim.new(0, 4)
NavMenuPad.Parent = NavMenu

local NavMenuLayout = Instance.new("UIListLayout")
NavMenuLayout.Padding = UDim.new(0, 3)
NavMenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavMenuLayout.Parent = NavMenu

local AimNavBtn = Instance.new("TextButton")
AimNavBtn.Size = UDim2.new(1, 0, 0, 34)
AimNavBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
AimNavBtn.BackgroundTransparency = 0.88
AimNavBtn.BorderSizePixel = 0
AimNavBtn.Text ="AIM"
AimNavBtn.TextColor3 = Color3.fromRGB(60, 160, 255)
AimNavBtn.Font = Enum.Font.Code
AimNavBtn.TextSize = 12
AimNavBtn.TextXAlignment = Enum.TextXAlignment.Left
AimNavBtn.LayoutOrder = 1
AimNavBtn.Parent = NavMenu
local AimNavCorner = Instance.new("UICorner")
AimNavCorner.CornerRadius = UDim.new(0, 6)
AimNavCorner.Parent = AimNavBtn

local AimNavAccent = Instance.new("Frame")
AimNavAccent.Size = UDim2.new(0, 2, 1, 0)
AimNavAccent.Position = UDim2.new(0, 0, 0, 0)
AimNavAccent.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
AimNavAccent.BorderSizePixel = 0
AimNavAccent.Parent = AimNavBtn

local AimNavPad = Instance.new("UIPadding")
AimNavPad.PaddingLeft = UDim.new(0, 14)
AimNavPad.Parent = AimNavBtn

local VisualNavBtn = Instance.new("TextButton")
VisualNavBtn.Size = UDim2.new(1, 0, 0, 34)
VisualNavBtn.BackgroundTransparency = 1
VisualNavBtn.BorderSizePixel = 0
VisualNavBtn.Text ="VISUAL"
VisualNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
VisualNavBtn.Font = Enum.Font.Code
VisualNavBtn.TextSize = 12
VisualNavBtn.TextXAlignment = Enum.TextXAlignment.Left
VisualNavBtn.LayoutOrder = 2
VisualNavBtn.Parent = NavMenu
local VisualNavCorner = Instance.new("UICorner")
VisualNavCorner.CornerRadius = UDim.new(0, 6)
VisualNavCorner.Parent = VisualNavBtn

local VisualNavAccent = Instance.new("Frame")
VisualNavAccent.Size = UDim2.new(0, 2, 1, 0)
VisualNavAccent.Position = UDim2.new(0, 0, 0, 0)
VisualNavAccent.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
VisualNavAccent.BorderSizePixel = 0
VisualNavAccent.Visible = false
VisualNavAccent.Parent = VisualNavBtn

local VisualNavPad = Instance.new("UIPadding")
VisualNavPad.PaddingLeft = UDim.new(0, 14)
VisualNavPad.Parent = VisualNavBtn

local WhitelistNavBtn = Instance.new("TextButton")
WhitelistNavBtn.Size = UDim2.new(1, 0, 0, 34)
WhitelistNavBtn.BackgroundTransparency = 1
WhitelistNavBtn.BorderSizePixel = 0
WhitelistNavBtn.Text ="WHITELIST"
WhitelistNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
WhitelistNavBtn.Font = Enum.Font.Code
WhitelistNavBtn.TextSize = 12
WhitelistNavBtn.TextXAlignment = Enum.TextXAlignment.Left
WhitelistNavBtn.LayoutOrder = 3
WhitelistNavBtn.Parent = NavMenu
local WhitelistNavCorner = Instance.new("UICorner")
WhitelistNavCorner.CornerRadius = UDim.new(0, 6)
WhitelistNavCorner.Parent = WhitelistNavBtn

local WhitelistNavAccent = Instance.new("Frame")
WhitelistNavAccent.Size = UDim2.new(0, 2, 1, 0)
WhitelistNavAccent.Position = UDim2.new(0, 0, 0, 0)
WhitelistNavAccent.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
WhitelistNavAccent.BorderSizePixel = 0
WhitelistNavAccent.Visible = false
WhitelistNavAccent.Parent = WhitelistNavBtn

local WhitelistNavPad = Instance.new("UIPadding")
WhitelistNavPad.PaddingLeft = UDim.new(0, 14)
WhitelistNavPad.Parent = WhitelistNavBtn

local AccountBlock = Instance.new("Frame")
AccountBlock.Size = UDim2.new(1, 0, 0, 92)
AccountBlock.Position = UDim2.new(0, 0, 1, -92)
AccountBlock.BackgroundTransparency = 1
AccountBlock.Parent = Sidebar

local AvatarRing = Instance.new("Frame")
AvatarRing.Size = UDim2.new(0, 46, 0, 46)
AvatarRing.Position = UDim2.new(0.5, -23, 0, 4)
AvatarRing.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
AvatarRing.BorderSizePixel = 0
AvatarRing.Parent = AccountBlock
local AvatarRingCorner = Instance.new("UICorner")
AvatarRingCorner.CornerRadius = UDim.new(1, 0)
AvatarRingCorner.Parent = AvatarRing
local AvatarRingStroke = Instance.new("UIStroke")
AvatarRingStroke.Color = Color3.fromRGB(60, 160, 255)
AvatarRingStroke.Thickness = 2
AvatarRingStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
AvatarRingStroke.Parent = AvatarRing

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.BorderSizePixel = 0
AvatarImage.ScaleType = Enum.ScaleType.Crop
AvatarImage.Parent = AvatarRing
local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

pcall(function()
    local thumb = game:GetService("Thumbnails"):GetPlayerThumbnail(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    if thumb and thumb ~= "" then
        AvatarImage.Image = thumb
    end
end)

local AccountName = Instance.new("TextLabel")
AccountName.Size = UDim2.new(1, -8, 0, 16)
AccountName.Position = UDim2.new(0, 4, 0, 54)
AccountName.BackgroundTransparency = 1
AccountName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
AccountName.TextColor3 = Color3.fromRGB(210, 210, 220)
AccountName.Font = Enum.Font.Code
AccountName.TextSize = 10
AccountName.TextXAlignment = Enum.TextXAlignment.Center
AccountName.TextTruncate = Enum.TextTruncate.AtEnd
AccountName.Parent = AccountBlock

local AccountUser = Instance.new("TextLabel")
AccountUser.Size = UDim2.new(1, -8, 0, 13)
AccountUser.Position = UDim2.new(0, 4, 0, 70)
AccountUser.BackgroundTransparency = 1
AccountUser.Text = "@" .. LocalPlayer.Name
AccountUser.TextColor3 = Color3.fromRGB(70, 70, 90)
AccountUser.Font = Enum.Font.Code
AccountUser.TextSize = 9
AccountUser.TextXAlignment = Enum.TextXAlignment.Center
AccountUser.TextTruncate = Enum.TextTruncate.AtEnd
AccountUser.Parent = AccountBlock

local InsertHint = Instance.new("TextLabel")
InsertHint.Size = UDim2.new(1, -10, 0, 14)
InsertHint.Position = UDim2.new(0, 5, 0, 0)
InsertHint.BackgroundTransparency = 1
InsertHint.Text ="INSERT = show/hide"
InsertHint.TextColor3 = Color3.fromRGB(38, 38, 52)
InsertHint.Font = Enum.Font.Code
InsertHint.TextSize = 9
InsertHint.TextXAlignment = Enum.TextXAlignment.Center
InsertHint.Parent = AccountBlock

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -118, 1, -2)
ContentArea.Position = UDim2.new(0, 114, 0, 2)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local AimPanel = Instance.new("ScrollingFrame")
AimPanel.Size = UDim2.new(1, 0, 1, -30)
AimPanel.Position = UDim2.new(0, 0, 0, 0)
AimPanel.BackgroundTransparency = 1
AimPanel.BorderSizePixel = 0
AimPanel.ScrollBarThickness = 3
AimPanel.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
AimPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
AimPanel.Visible = true
AimPanel.Parent = ContentArea

local AimPanelLayout = Instance.new("UIListLayout")
AimPanelLayout.Padding = UDim.new(0, 0)
AimPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
AimPanelLayout.Parent = AimPanel

local AimPanelPad = Instance.new("UIPadding")
AimPanelPad.PaddingTop = UDim.new(0, 12)
AimPanelPad.PaddingLeft = UDim.new(0, 12)
AimPanelPad.PaddingRight = UDim.new(0, 12)
AimPanelPad.Parent = AimPanel

local VisualPanel = Instance.new("ScrollingFrame")
VisualPanel.Size = UDim2.new(1, 0, 1, -30)
VisualPanel.Position = UDim2.new(0, 0, 0, 0)
VisualPanel.BackgroundTransparency = 1
VisualPanel.BorderSizePixel = 0
VisualPanel.ScrollBarThickness = 3
VisualPanel.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
VisualPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
VisualPanel.Visible = false
VisualPanel.Parent = ContentArea

local VisualPanelLayout = Instance.new("UIListLayout")
VisualPanelLayout.Padding = UDim.new(0, 0)
VisualPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualPanelLayout.Parent = VisualPanel

local VisualPanelPad = Instance.new("UIPadding")
VisualPanelPad.PaddingTop = UDim.new(0, 12)
VisualPanelPad.PaddingLeft = UDim.new(0, 12)
VisualPanelPad.PaddingRight = UDim.new(0, 12)
VisualPanelPad.Parent = VisualPanel

local WhitelistPanel = Instance.new("ScrollingFrame")
WhitelistPanel.Size = UDim2.new(1, 0, 1, -30)
WhitelistPanel.Position = UDim2.new(0, 0, 0, 0)
WhitelistPanel.BackgroundTransparency = 1
WhitelistPanel.BorderSizePixel = 0
WhitelistPanel.ScrollBarThickness = 3
WhitelistPanel.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
WhitelistPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
WhitelistPanel.Visible = false
WhitelistPanel.Parent = ContentArea

local WhitelistPanelLayout = Instance.new("UIListLayout")
WhitelistPanelLayout.Padding = UDim.new(0, 0)
WhitelistPanelLayout.SortOrder = Enum.SortOrder.LayoutOrder
WhitelistPanelLayout.Parent = WhitelistPanel

local WhitelistPanelPad = Instance.new("UIPadding")
WhitelistPanelPad.PaddingTop = UDim.new(0, 12)
WhitelistPanelPad.PaddingLeft = UDim.new(0, 12)
WhitelistPanelPad.PaddingRight = UDim.new(0, 12)
WhitelistPanelPad.Parent = WhitelistPanel

local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 28)
Footer.Position = UDim2.new(0, 0, 0, 1)
Footer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Footer.BorderSizePixel = 0
Footer.Parent = MainFrame

local FooterSep = Instance.new("Frame")
FooterSep.Size = UDim2.new(1, 0, 0, 1)
FooterSep.Position = UDim2.new(0, 0, 0, 0)
FooterSep.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
FooterSep.BorderSizePixel = 0
FooterSep.Parent = Footer

local FooterDot = Instance.new("Frame")
FooterDot.Size = UDim2.new(0, 6, 0, 6)
FooterDot.Position = UDim2.new(0, 10, 0.5, -3)
FooterDot.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
FooterDot.BorderSizePixel = 0
FooterDot.Parent = Footer
local FooterDotCorner = Instance.new("UICorner")
FooterDotCorner.CornerRadius = UDim.new(1, 0)
FooterDotCorner.Parent = FooterDot

local FooterLabel = Instance.new("TextLabel")
FooterLabel.Size = UDim2.new(0, 160, 1, 0)
FooterLabel.Position = UDim2.new(0, 22, 0, 0)
FooterLabel.BackgroundTransparency = 1
FooterLabel.Text ="ETERNAL FLICK"
FooterLabel.TextColor3 = Color3.fromRGB(60, 160, 255)
FooterLabel.Font = Enum.Font.Code
FooterLabel.TextSize = 11
FooterLabel.TextXAlignment = Enum.TextXAlignment.Left
FooterLabel.Parent = Footer

local function createSectionLabel(parent, text, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 28)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = Color3.fromRGB(60, 160, 255)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order or 0
    lbl.Parent = parent
    return lbl
end

local function createRow(parent, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order or 0
    row.Parent = parent
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 1)
    sep.Position = UDim2.new(0, 0, 1, -1)
    sep.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    sep.BorderSizePixel = 0
    sep.Parent = row
    return row
end

local function addRowLabel(row, text, subtext)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 0, 18)
    lbl.Position = UDim2.new(0, 0, 0, 6)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(210, 210, 220)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    if subtext then
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(0.6, 0, 0, 13)
        sub.Position = UDim2.new(0, 0, 0, 24)
        sub.BackgroundTransparency = 1
        sub.Text = subtext
        sub.TextColor3 = Color3.fromRGB(55, 55, 70)
        sub.Font = Enum.Font.Code
        sub.TextSize = 10
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Parent = row
    end
end

local function createToggleInRow(row)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 42, 0, 22)
    track.Position = UDim2.new(1, -42, 0.5, -11)
    track.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    track.BorderSizePixel = 0
    track.Parent = row
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 11)
    tc.Parent = track
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = UDim2.new(0, 2, 0.5, -9)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    local thc = Instance.new("UICorner")
    thc.CornerRadius = UDim.new(1, 0)
    thc.Parent = thumb
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text =""
    btn.Parent = track
    return track, thumb, btn
end

local function AnimateToggle(track, thumb, enabled)
    if not track or not thumb then return end
    local thumbPos = enabled and UDim2.new(0, 22, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    local trackColor = enabled and Color3.fromRGB(60, 160, 255) or Color3.fromRGB(55, 55, 65)
    TweenService:Create(thumb, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = thumbPos}):Play()
    TweenService:Create(track, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = trackColor}):Play()
end

local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = MainFrame.Position
    end
end

local function onDrag(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        local newX = frameStartPos.X.Offset + delta.X
        local newY = frameStartPos.Y.Offset + delta.Y
        MainFrame.Position = UDim2.new(frameStartPos.X.Scale, newX, frameStartPos.Y.Scale, newY)
    end
end

local function stopDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end

TitleBar.InputBegan:Connect(startDrag)
UserInputService.InputChanged:Connect(onDrag)
UserInputService.InputEnded:Connect(stopDrag)

local function IsPlayerVisible(targetCharacter)
    if not LocalPlayer.Character then return false end
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not localRoot or not targetRoot then return false end
    local targetPart = targetHead or targetRoot
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
    local raycastResult = workspace:Raycast(localRoot.Position, (targetPart.Position - localRoot.Position), raycastParams)
    return raycastResult == nil
end

local function GetDistance(player)
    if not LocalPlayer.Character or not player.Character then return nil end
    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot or not targetRoot then return nil end
    return math.floor((localRoot.Position - targetRoot.Position).Magnitude)
end

local function IsInFOV(player)
    if not player.Character or not camera then return false end
    local head = player.Character:FindFirstChild("Head")
    if not head then return false end
    local mouseLoc = UserInputService:GetMouseLocation()
    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
    if onScreen and screenPos.Z > 0 then
        local dx = screenPos.X - mouseLoc.X
        local dy = screenPos.Y - mouseLoc.Y
        local dist = math.sqrt(dx*dx + dy*dy)
        return dist <= FOV_RADIUS
    end
    return false
end

local function IsWhitelisted(player)
    for _, wl in ipairs(Whitelist) do
        if wl == player then return true end
    end
    return false
end

local function UpdateESPColor(highlight, isVisible, isInFOV, isWhitelisted)
    if isWhitelisted then
        highlight.FillColor = Color3.fromRGB(220, 220, 255)
        highlight.OutlineColor = Color3.fromRGB(180, 180, 220)
        highlight.FillTransparency = 0.2
        highlight.OutlineTransparency = 0.05
    elseif isVisible and isInFOV then
        highlight.FillColor = Color3.fromRGB(0, 200, 50)
        highlight.OutlineColor = Color3.fromRGB(0, 150, 30)
        highlight.FillTransparency = 0.25
        highlight.OutlineTransparency = 0.05
    elseif isVisible then
        highlight.FillColor = Color3.fromRGB(20, 50, 200)
        highlight.OutlineColor = Color3.fromRGB(15, 40, 160)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0.1
    else
        highlight.FillColor = Color3.fromRGB(180, 30, 30)
        highlight.OutlineColor = Color3.fromRGB(140, 20, 20)
        highlight.FillTransparency = 0.35
        highlight.OutlineTransparency = 0.15
    end
end

local function UpdateNameColor(nameText, distanceText, isVisible, isInFOV, isWhitelisted)
    local col
    if isWhitelisted then
        col = Color3.fromRGB(255, 255, 255)
    elseif isVisible and isInFOV then
        col = Color3.fromRGB(0, 220, 80)
    elseif isVisible then
        col = Color3.fromRGB(20, 100, 220)
    else
        col = Color3.fromRGB(200, 40, 40)
    end
    nameText.TextColor3 = col
    if distanceText then distanceText.TextColor3 = Color3.fromRGB(255, 255, 255) end
end

local ESPTrack, ESPThumb, ESPBtn = nil, nil, nil
local ESPDistTrack, ESPDistThumb, ESPDistBtn = nil, nil, nil
local FOVCircleTrack, FOVCircleThumb, FOVCircleBtn = nil, nil, nil
local HealthBarTrack, HealthBarThumb, HealthBarBtn = nil, nil, nil
local SkeletonTrack, SkeletonThumb, SkeletonBtn = nil, nil, nil
local TracerTrack, TracerThumb, TracerBtn = nil, nil, nil

local function RefreshESP()
    if ESP_Enabled then
        for player, data in pairs(ESP_Objects) do
            if data and data.Billboard and data.Billboard.Parent then
                if data.DistanceFrame then
                    data.DistanceFrame.Visible = ESPDistance_Enabled
                end
                if data.HealthBar then
                    data.HealthBar.Visible = HealthBar_Enabled
                end
            end
        end
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if ESP_Objects[player] then return end
    
    local function OnCharacterAdded(character)
        if not ESP_Enabled or not character or not character.Parent then return end
        
        local oldData = ESP_Objects[player]
        if oldData then
            if oldData.Highlight then oldData.Highlight:Destroy() end
            if oldData.Billboard then oldData.Billboard:Destroy() end
            if oldData.UpdateConnection then oldData.UpdateConnection:Disconnect() end
            if oldData.DistanceFrame then oldData.DistanceFrame:Destroy() end
            if oldData.SkeletonFolder then oldData.SkeletonFolder:Destroy() end
            ESP_Objects[player] = nil
        end
        
        local humanoid, rootPart, head
        for i = 1, 10 do
            humanoid = character:FindFirstChild("Humanoid")
            rootPart = character:FindFirstChild("HumanoidRootPart")
            head = character:FindFirstChild("Head")
            if humanoid and rootPart then break end
            task.wait(0.1)
        end
        if not humanoid or not rootPart then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name ="ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(180, 30, 30)
        highlight.OutlineColor = Color3.fromRGB(140, 20, 20)
        highlight.FillTransparency = 0.35
        highlight.OutlineTransparency = 0.15
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        highlight.Parent = character

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name ="ESP_NameTag"
        billboardGui.Size = UDim2.new(0, 200, 0, 28)
        billboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.LightInfluence = 0
        billboardGui.MaxDistance = 300
        billboardGui.Adornee = head or rootPart
        billboardGui.Parent = character

        local nameBg = Instance.new("Frame")
        nameBg.Size = UDim2.new(1, -10, 1, 0)
        nameBg.Position = UDim2.new(0, 9, 0, 0)
        nameBg.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
        nameBg.BackgroundTransparency = 0.45
        nameBg.BorderSizePixel = 0
        nameBg.Parent = billboardGui
        local nameBgCorner = Instance.new("UICorner")
        nameBgCorner.CornerRadius = UDim.new(0, 4)
        nameBgCorner.Parent = nameBg

        local mainContainer = Instance.new("Frame")
        mainContainer.Name ="mainContainer"
        mainContainer.Size = UDim2.new(1, -10, 1, 0)
        mainContainer.Position = UDim2.new(0, 9, 0, 0)
        mainContainer.BackgroundTransparency = 1
        mainContainer.Parent = billboardGui

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name ="NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 4, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(200, 40, 40)
        nameLabel.TextStrokeTransparency = 0.4
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Text = player.Name
        nameLabel.Font = Enum.Font.Code
        nameLabel.TextSize = 12
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Parent = mainContainer

        local distanceFrame = nil
        local distanceText = nil
        if ESPDistance_Enabled then
            distanceFrame = Instance.new("Frame")
            distanceFrame.Size = UDim2.new(1, -10, 0, 14)
            distanceFrame.Position = UDim2.new(0, 9, 1, -14)
            distanceFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
            distanceFrame.BackgroundTransparency = 0.45
            distanceFrame.BorderSizePixel = 0
            distanceFrame.Parent = billboardGui
            local dfc = Instance.new("UICorner")
            dfc.CornerRadius = UDim.new(0, 4)
            dfc.Parent = distanceFrame
            distanceText = Instance.new("TextLabel")
            distanceText.Size = UDim2.new(1, 0, 1, 0)
            distanceText.BackgroundTransparency = 1
            distanceText.TextColor3 = Color3.fromRGB(255, 255, 255)
            distanceText.TextStrokeTransparency = 0.4
            distanceText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distanceText.Font = Enum.Font.Code
            distanceText.TextSize = 10
            distanceText.Text = (GetDistance(player) or"?") .."m"
            distanceText.TextXAlignment = Enum.TextXAlignment.Center
            distanceText.TextYAlignment = Enum.TextYAlignment.Center
            distanceText.Parent = distanceFrame
        end

        local healthBarBg = Instance.new("Frame")
        healthBarBg.Name ="ESP_HealthBarBg"
        healthBarBg.Size = UDim2.new(0, 5, 0, 28)
        healthBarBg.Position = UDim2.new(0, 1, 0, 0)
        healthBarBg.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
        healthBarBg.BackgroundTransparency = 0.15
        healthBarBg.BorderSizePixel = 0
        healthBarBg.ZIndex = 3
        healthBarBg.Visible = HealthBar_Enabled
        healthBarBg.Parent = billboardGui

        local healthBarStroke = Instance.new("UIStroke")
        healthBarStroke.Color = Color3.fromRGB(255, 255, 255)
        healthBarStroke.Thickness = 1
        healthBarStroke.Transparency = 0.6
        healthBarStroke.Parent = healthBarBg

        local healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.AnchorPoint = Vector2.new(0.5, 1)
        healthFill.Position = UDim2.new(0.5, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBarBg

        local function UpdateESPVisuals()
            if not ESP_Enabled or not character.Parent or not LocalPlayer.Character then return end
            local isVisible = IsPlayerVisible(character)
            local isInFOV = IsInFOV(player)
            local isWhitelisted = IsWhitelisted(player)
            UpdateESPColor(highlight, isVisible, isInFOV, isWhitelisted)
            UpdateNameColor(nameLabel, distanceText, isVisible, isInFOV, isWhitelisted)
            if humanoid and healthFill then
                local ratio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
                healthFill.Size = UDim2.new(1, 0, ratio, 0)
                healthFill.BackgroundColor3 = Color3.fromRGB(
                    math.floor(220 * (1 - ratio)),
                    math.floor(200 * ratio) + 40,
                    40
                )
            end
            if ESPDistance_Enabled and distanceText then
                local dist = GetDistance(player)
                if dist then distanceText.Text = dist .."m"end
            end
        end

        local updateConnection
        updateConnection = RunService.RenderStepped:Connect(UpdateESPVisuals)

        ESP_Objects[player] = {
            Highlight = highlight,
            Billboard = billboardGui,
            UpdateConnection = updateConnection,
            Character = character,
            DistanceFrame = distanceFrame,
            HealthBar = healthBarBg,
            mainContainer = mainContainer,
            nameLabel = nameLabel
        }
    end
    
    if player.Character and player.Character.Parent then
        OnCharacterAdded(player.Character)
    end
    local conn = player.CharacterAdded:Connect(OnCharacterAdded)
    ESP_Connections[player] = conn
end

local function CleanPlayer(player)
    local data = ESP_Objects[player]
    if not data then return end
    if data.Highlight then data.Highlight:Destroy() end
    if data.Billboard then data.Billboard:Destroy() end
    if data.UpdateConnection then data.UpdateConnection:Disconnect() end
    if data.DistanceFrame then data.DistanceFrame:Destroy() end
    if data.SkeletonFolder then data.SkeletonFolder:Destroy() end
    ESP_Objects[player] = nil
end

local function ClearESP()
    for player in pairs(ESP_Objects) do CleanPlayer(player) end
    for player, conn in pairs(ESP_Connections) do 
        if conn then 
            conn:Disconnect() 
        end 
    end
    ESP_Connections = {}
end

local function ToggleESP()
    ESP_Enabled = not ESP_Enabled
    AnimateToggle(ESPTrack, ESPThumb, ESP_Enabled)
    if ESP_Enabled then
        ClearESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then CreateESP(plr) end
        end
    else
        ClearESP()
    end
end

local function ToggleESPDistance()
    ESPDistance_Enabled = not ESPDistance_Enabled
    AnimateToggle(ESPDistTrack, ESPDistThumb, ESPDistance_Enabled)
    RefreshESP()
end

local function ToggleHealthBar()
    HealthBar_Enabled = not HealthBar_Enabled
    AnimateToggle(HealthBarTrack, HealthBarThumb, HealthBar_Enabled)
    RefreshESP()
end

local function ToggleSkeleton()
    Skeleton_Enabled = not Skeleton_Enabled
    AnimateToggle(SkeletonTrack, SkeletonThumb, Skeleton_Enabled)
end

local function ToggleTracer()
    Tracer_Enabled = not Tracer_Enabled
    AnimateToggle(TracerTrack, TracerThumb, Tracer_Enabled)
end

local espOverlayGui = nil
local espOverlayConnection = nil
local ESP_LINE_THICKNESS = 2

local function GetOverlayGui()
    if espOverlayGui and espOverlayGui.Parent then return espOverlayGui end
    local gui = Instance.new("ScreenGui")
    gui.Name ="ESP_OverlayGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    if gethui then gui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(gui); gui.Parent = game:GetService("CoreGui")
    else gui.Parent = game:GetService("CoreGui") end
    espOverlayGui = gui
    return gui
end

local function GetSkeletonJoints(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.RigType == Enum.HumanoidRigType.R15 then
        return {
            {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
            {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
            {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
            {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
            {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"}
        }
    end
    return {
        {"Head","Torso"},
        {"Torso","Left Arm"}, {"Torso","Right Arm"},
        {"Torso","Left Leg"}, {"Torso","Right Leg"}
    }
end

local function PositionLineFrame(line, cache, from, to)
    local x1 = math.floor(from.X + 0.5)
    local y1 = math.floor(from.Y + 0.5)
    local x2 = math.floor(to.X + 0.5)
    local y2 = math.floor(to.Y + 0.5)
    if x1 == x2 and y1 == y2 then
        line.Visible = false
        return
    end
    if cache and cache.X1 == x1 and cache.Y1 == y1 and cache.X2 == x2 and cache.Y2 == y2 then
        if not line.Visible then line.Visible = true end
        return
    end
    line.Size = UDim2.new(0, math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2), 0, ESP_LINE_THICKNESS)
    line.Position = UDim2.new(0, (x1 + x2) / 2, 0, (y1 + y2) / 2)
    line.Rotation = math.deg(math.atan2(y2 - y1, x2 - x1))
    line.Visible = true
    if cache then
        cache.X1, cache.Y1, cache.X2, cache.Y2 = x1, y1, x2, y2
    end
end

local function GetOrCreateLine(data, index)
    local line = data.SkeletonLines[index]
    if not line then
        line = Instance.new("Frame")
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.Parent = data.SkeletonFolder
        data.SkeletonLines[index] = line
        data.LineCaches[index] = {}
    end
    return line, data.LineCaches[index]
end

local function HideESPOverlayLines(data)
    if data.SkeletonLines then
        for _, line in ipairs(data.SkeletonLines) do line.Visible = false end
    end
    if data.TracerLine then data.TracerLine.Visible = false end
end

local espOverlayTick = 0

local function UpdateESPOverlays()
    if not camera then return end

    local drawSkeleton = Skeleton_Enabled
    local drawTracer = Tracer_Enabled

    if not drawSkeleton and not drawTracer then
        for _, data in pairs(ESP_Objects) do
            if data then HideESPOverlayLines(data) end
        end
        return
    end

    espOverlayTick = espOverlayTick + 1
    if espOverlayTick % 2 ~= 0 then return end

    local viewportSize = camera.ViewportSize
    local localRoot = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Head"))

    for player, data in pairs(ESP_Objects) do
        if not data or not data.Character or not data.Character.Parent then
            if data then HideESPOverlayLines(data) end
            continue
        end

        if not data.SkeletonFolder then
            local folder = Instance.new("Folder")
            folder.Name ="ESP_OverlayLines"
            folder.Parent = GetOverlayGui()
            data.SkeletonFolder = folder
            data.SkeletonLines = {}
            data.LineCaches = {}
            data.Joints = GetSkeletonJoints(data.Character)
        end

        local character = data.Character
        local head = character:FindFirstChild("Head")
        local root = character:FindFirstChild("HumanoidRootPart")
        local anchor = head or root
        if not anchor then
            HideESPOverlayLines(data)
            continue
        end

        if localRoot and (localRoot.Position - anchor.Position).Magnitude > 400 then
            HideESPOverlayLines(data)
            continue
        end

        if drawSkeleton then
            local lineIdx = 0
            for _, pair in ipairs(data.Joints) do
                local partA = character:FindFirstChild(pair[1])
                local partB = character:FindFirstChild(pair[2])
                if partA and partB then
                    local posA, onScreenA = camera:WorldToViewportPoint(partA.Position)
                    local posB, onScreenB = camera:WorldToViewportPoint(partB.Position)
                    if onScreenA and onScreenB and posA.Z > 0 and posB.Z > 0 then
                        lineIdx = lineIdx + 1
                        local line, cache = GetOrCreateLine(data, lineIdx)
                        PositionLineFrame(line, cache, Vector2.new(posA.X, posA.Y), Vector2.new(posB.X, posB.Y))
                    end
                end
            end
            for i = lineIdx + 1, #data.SkeletonLines do
                data.SkeletonLines[i].Visible = false
            end
        else
            for _, line in ipairs(data.SkeletonLines) do line.Visible = false end
        end

        if drawTracer then
            local pos, onScreen = camera:WorldToViewportPoint(anchor.Position)
            if onScreen and pos.Z > 0 then
                if not data.TracerLine then
                    data.TracerLine = Instance.new("Frame")
                    data.TracerLine.BorderSizePixel = 0
                    data.TracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
                    data.TracerLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    data.TracerLine.Parent = data.SkeletonFolder
                    data.TracerCache = {}
                end
                PositionLineFrame(data.TracerLine, data.TracerCache, Vector2.new(viewportSize.X / 2, viewportSize.Y), Vector2.new(pos.X, pos.Y))
            elseif data.TracerLine then
                data.TracerLine.Visible = false
            end
        elseif data.TracerLine then
            data.TracerLine.Visible = false
        end
    end
end

espOverlayConnection = RunService.RenderStepped:Connect(UpdateESPOverlays)

createSectionLabel(AimPanel,"Aimlock", 1)

local aimRow = createRow(AimPanel, 2)
addRowLabel(aimRow,"Aimlock","Maintenir pour activer")

local HoldBadge = Instance.new("TextLabel")
HoldBadge.Size = UDim2.new(0, 36, 0, 16)
HoldBadge.Position = UDim2.new(1, -88, 0.5, -8)
HoldBadge.BackgroundColor3 = Color3.fromRGB(22, 18, 0)
HoldBadge.Text ="HOLD"
HoldBadge.TextColor3 = Color3.fromRGB(255, 160, 0)
HoldBadge.Font = Enum.Font.Code
HoldBadge.TextSize = 9
HoldBadge.BorderSizePixel = 0
HoldBadge.Parent = aimRow
local HoldCorner = Instance.new("UICorner")
HoldCorner.CornerRadius = UDim.new(0, 3)
HoldCorner.Parent = HoldBadge
local HoldStroke = Instance.new("UIStroke")
HoldStroke.Color = Color3.fromRGB(80, 55, 0)
HoldStroke.Thickness = 1
HoldStroke.Parent = HoldBadge

local AimlockTrack, AimlockThumb, AimlockBtn = createToggleInRow(aimRow)
AimlockTrack.Position = UDim2.new(1, -42, 0.5, -11)

local keyRow = createRow(AimPanel, 3)
addRowLabel(keyRow,"Clic Aimlock")

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0, 80, 0, 24)
KeyButton.Position = UDim2.new(1, -82, 0.5, -12)
KeyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
KeyButton.BorderSizePixel = 0
KeyButton.Text ="M1"
KeyButton.TextColor3 = Color3.fromRGB(60, 160, 255)
KeyButton.Font = Enum.Font.Code
KeyButton.TextSize = 12
KeyButton.Parent = keyRow
local KBCorner = Instance.new("UICorner")
KBCorner.CornerRadius = UDim.new(0, 5)
KBCorner.Parent = KeyButton
local KBStroke = Instance.new("UIStroke")
KBStroke.Color = Color3.fromRGB(35, 35, 52)
KBStroke.Thickness = 1
KBStroke.Parent = KeyButton

createSectionLabel(AimPanel,"FOV", 4)

local fovSliderRow = Instance.new("Frame")
fovSliderRow.Size = UDim2.new(1, 0, 0, 52)
fovSliderRow.BackgroundTransparency = 1
fovSliderRow.LayoutOrder = 5
fovSliderRow.Parent = AimPanel

local FOVTitleLabel = Instance.new("TextLabel")
FOVTitleLabel.Size = UDim2.new(0.6, 0, 0, 14)
FOVTitleLabel.Position = UDim2.new(0, 0, 0, 4)
FOVTitleLabel.BackgroundTransparency = 1
FOVTitleLabel.Text ="Taille du FOV"
FOVTitleLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
FOVTitleLabel.Font = Enum.Font.Code
FOVTitleLabel.TextSize = 11
FOVTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVTitleLabel.Parent = fovSliderRow

local FOVValLabel = Instance.new("TextLabel")
FOVValLabel.Size = UDim2.new(0.4, 0, 0, 14)
FOVValLabel.Position = UDim2.new(0.6, 0, 0, 4)
FOVValLabel.BackgroundTransparency = 1
FOVValLabel.Text ="150px"
FOVValLabel.TextColor3 = Color3.fromRGB(60, 160, 255)
FOVValLabel.Font = Enum.Font.Code
FOVValLabel.TextSize = 11
FOVValLabel.TextXAlignment = Enum.TextXAlignment.Right
FOVValLabel.Parent = fovSliderRow

local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(1, 0, 0, 4)
SliderTrack.Position = UDim2.new(0, 0, 0, 28)
SliderTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = fovSliderRow
local SliderTrackCorner = Instance.new("UICorner")
SliderTrackCorner.CornerRadius = UDim.new(1, 0)
SliderTrackCorner.Parent = SliderTrack

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((FOV_RADIUS - 30) / 270, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderTrack
local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderThumb = Instance.new("Frame")
SliderThumb.Size = UDim2.new(0, 13, 0, 13)
SliderThumb.Position = UDim2.new((FOV_RADIUS - 30) / 270, -6, 0.5, -6)
SliderThumb.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
SliderThumb.BorderSizePixel = 0
SliderThumb.Parent = SliderTrack
local SliderThumbCorner = Instance.new("UICorner")
SliderThumbCorner.CornerRadius = UDim.new(1, 0)
SliderThumbCorner.Parent = SliderThumb
local SliderThumbStroke = Instance.new("UIStroke")
SliderThumbStroke.Color = Color3.fromRGB(255, 255, 255)
SliderThumbStroke.Thickness = 2
SliderThumbStroke.Parent = SliderThumb

local fovCircleRow = createRow(AimPanel, 6)
addRowLabel(fovCircleRow,"Afficher le cercle FOV","Montre la zone d'aimlock")
FOVCircleTrack, FOVCircleThumb, FOVCircleBtn = createToggleInRow(fovCircleRow)

createSectionLabel(VisualPanel,"ESP", 1)

local espRow = createRow(VisualPanel, 2)
addRowLabel(espRow,"ESP Joueurs","Highlight + Nametag")
ESPTrack, ESPThumb, ESPBtn = createToggleInRow(espRow)

local espDistRow = createRow(VisualPanel, 3)
addRowLabel(espDistRow,"ESP Distance","Afficher la distance (m)")
ESPDistTrack, ESPDistThumb, ESPDistBtn = createToggleInRow(espDistRow)

local healthBarRow = createRow(VisualPanel, 4)
addRowLabel(healthBarRow,"ESP Health Bar","Barre de vie au-dessus du nametag")
HealthBarTrack, HealthBarThumb, HealthBarBtn = createToggleInRow(healthBarRow)

local skeletonRow = createRow(VisualPanel, 5)
addRowLabel(skeletonRow,"ESP Skeleton","Squelette du joueur à travers les murs")
SkeletonTrack, SkeletonThumb, SkeletonBtn = createToggleInRow(skeletonRow)

local tracerRow = createRow(VisualPanel, 6)
addRowLabel(tracerRow,"ESP Tracer","Ligne depuis le bas de l'écran")
TracerTrack, TracerThumb, TracerBtn = createToggleInRow(tracerRow)

createSectionLabel(WhitelistPanel,"Whitelist", 1)

local whitelistInfoRow = createRow(WhitelistPanel, 2)
addRowLabel(whitelistInfoRow,"Joueurs Whitelistés","ESP blanc - Aimlock ignoré")

local whitelistDisplayRow = createRow(WhitelistPanel, 3)
addRowLabel(whitelistDisplayRow,"Whitelist actuelle","")

local WhitelistDisplayLabel = Instance.new("TextLabel")
WhitelistDisplayLabel.Size = UDim2.new(1, -20, 0, 36)
WhitelistDisplayLabel.Position = UDim2.new(0, 10, 0.5, -18)
WhitelistDisplayLabel.BackgroundTransparency = 1
WhitelistDisplayLabel.Text ="Aucun"
WhitelistDisplayLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
WhitelistDisplayLabel.Font = Enum.Font.Code
WhitelistDisplayLabel.TextSize = 11
WhitelistDisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
WhitelistDisplayLabel.TextWrapped = true
WhitelistDisplayLabel.Parent = whitelistDisplayRow

local whitelistSelectRow = createRow(WhitelistPanel, 4)
addRowLabel(whitelistSelectRow,"Ajouter/Retirer","Cliquez sur un joueur")

local PlayerDropdownButton = Instance.new("TextButton")
PlayerDropdownButton.Size = UDim2.new(0, 160, 0, 32)
PlayerDropdownButton.Position = UDim2.new(1, -170, 0.5, -16)
PlayerDropdownButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
PlayerDropdownButton.BorderSizePixel = 0
PlayerDropdownButton.Text ="Sélectionner..."
PlayerDropdownButton.TextColor3 = Color3.fromRGB(140, 140, 160)
PlayerDropdownButton.Font = Enum.Font.Code
PlayerDropdownButton.TextSize = 11
PlayerDropdownButton.Parent = whitelistSelectRow
local PDCorner = Instance.new("UICorner")
PDCorner.CornerRadius = UDim.new(0, 5)
PDCorner.Parent = PlayerDropdownButton

local function UpdateWhitelistDisplay()
    local playersList = {}
    for _, player in ipairs(Whitelist) do
        table.insert(playersList, player.Name)
    end
    if #playersList == 0 then
        WhitelistDisplayLabel.Text ="Aucun"
        WhitelistDisplayLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    else
        WhitelistDisplayLabel.Text = table.concat(playersList,",")
        WhitelistDisplayLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end

local function CreatePlayerDropdown()
    if WhitelistDropdown then WhitelistDropdown:Destroy() end
    
    WhitelistDropdown = Instance.new("Frame")
    WhitelistDropdown.Size = UDim2.new(0, 160, 0, 150)
    WhitelistDropdown.Position = UDim2.new(1, -170, 0, 36)
    WhitelistDropdown.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    WhitelistDropdown.BorderSizePixel = 0
    WhitelistDropdown.ClipsDescendants = true
    WhitelistDropdown.Visible = false
    WhitelistDropdown.Parent = whitelistSelectRow
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 5)
    dropdownCorner.Parent = WhitelistDropdown
    
    local dropdownStroke = Instance.new("UIStroke")
    dropdownStroke.Color = Color3.fromRGB(40, 40, 55)
    dropdownStroke.Thickness = 1
    dropdownStroke.Parent = WhitelistDropdown
    
    local scroller = Instance.new("ScrollingFrame")
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = 3
    scroller.Parent = WhitelistDropdown
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 0)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroller
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            btn.BorderSizePixel = 0
            btn.Text = player.Name
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.Font = Enum.Font.Code
            btn.TextSize = 11
            btn.Parent = scroller
            
            local isWhitelisted = false
            for _, wl in ipairs(Whitelist) do
                if wl == player then isWhitelisted = true break end
            end
            
            if isWhitelisted then
                btn.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
                btn.TextColor3 = Color3.fromRGB(0, 200, 80)
                btn.Text ="[]".. player.Name
            end
            
            btn.MouseButton1Click:Connect(function()
                local found = false
                for i, wl in ipairs(Whitelist) do
                    if wl == player then
                        table.remove(Whitelist, i)
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(Whitelist, player)
                end
                UpdateWhitelistDisplay()
                RefreshESP()
                WhitelistDropdown.Visible = false
                WhitelistDropdownOpen = false
            end)
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            end)
            btn.MouseLeave:Connect(function()
                local isWl = false
                for _, wl in ipairs(Whitelist) do
                    if wl == player then isWl = true break end
                end
                if isWl then
                    btn.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                end
            end)
        end
    end
end

PlayerDropdownButton.MouseButton1Click:Connect(function()
    if WhitelistDropdownOpen then
        WhitelistDropdown.Visible = false
        WhitelistDropdownOpen = false
    else
        if WhitelistDropdown then WhitelistDropdown:Destroy() end
        CreatePlayerDropdown()
        WhitelistDropdown.Visible = true
        WhitelistDropdownOpen = true
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and WhitelistDropdownOpen then
        local mousePos = input.Position
        local dropdownPos = WhitelistDropdown and WhitelistDropdown.AbsolutePosition
        local dropdownSize = WhitelistDropdown and WhitelistDropdown.AbsoluteSize
        if dropdownPos and dropdownSize then
            if not (mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                    mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y) then
                WhitelistDropdown.Visible = false
                WhitelistDropdownOpen = false
            end
        end
    end
end)

local function SwitchToAim()
    AimPanel.Visible = true
    VisualPanel.Visible = false
    WhitelistPanel.Visible = false
    AimNavBtn.BackgroundTransparency = 0.88
    AimNavBtn.TextColor3 = Color3.fromRGB(60, 160, 255)
    AimNavAccent.Visible = true
    VisualNavBtn.BackgroundTransparency = 1
    VisualNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    VisualNavAccent.Visible = false
    WhitelistNavBtn.BackgroundTransparency = 1
    WhitelistNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    WhitelistNavAccent.Visible = false
end

local function SwitchToVisual()
    AimPanel.Visible = false
    VisualPanel.Visible = true
    WhitelistPanel.Visible = false
    AimNavBtn.BackgroundTransparency = 1
    AimNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    AimNavAccent.Visible = false
    VisualNavBtn.BackgroundTransparency = 0.88
    VisualNavBtn.TextColor3 = Color3.fromRGB(60, 160, 255)
    VisualNavAccent.Visible = true
    WhitelistNavBtn.BackgroundTransparency = 1
    WhitelistNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    WhitelistNavAccent.Visible = false
end

local function SwitchToWhitelist()
    AimPanel.Visible = false
    VisualPanel.Visible = false
    WhitelistPanel.Visible = true
    AimNavBtn.BackgroundTransparency = 1
    AimNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    AimNavAccent.Visible = false
    VisualNavBtn.BackgroundTransparency = 1
    VisualNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
    VisualNavAccent.Visible = false
    WhitelistNavBtn.BackgroundTransparency = 0.88
    WhitelistNavBtn.TextColor3 = Color3.fromRGB(60, 160, 255)
    WhitelistNavAccent.Visible = true
end

AimNavBtn.MouseButton1Click:Connect(SwitchToAim)
VisualNavBtn.MouseButton1Click:Connect(SwitchToVisual)
WhitelistNavBtn.MouseButton1Click:Connect(SwitchToWhitelist)

local function CreateFOVCircle()
    if fovCircle then
        if fovCircle.Parent then fovCircle.Parent:Destroy() end
        fovCircle = nil
    end
    if fovCrosshair then
        if fovCrosshair.Parent then fovCrosshair.Parent:Destroy() end
        fovCrosshair = nil
    end
    
    local circleGui = Instance.new("ScreenGui")
    circleGui.Name ="FOVCircleGui"
    circleGui.ResetOnSpawn = false
    circleGui.IgnoreGuiInset = true
    circleGui.Parent = ScreenGui
    
    fovCircle = Instance.new("Frame")
    fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
    fovCircle.Position = UDim2.new(0.5, -FOV_RADIUS, 0.5, -FOV_RADIUS)
    fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovCircle.BackgroundTransparency = 0.85
    fovCircle.BorderSizePixel = 2
    fovCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    fovCircle.Parent = circleGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = fovCircle
    
    fovCrosshair = Instance.new("Frame")
    fovCrosshair.Size = UDim2.new(0, 20, 0, 2)
    fovCrosshair.Position = UDim2.new(0.5, -10, 0.5, -1)
    fovCrosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fovCrosshair.BorderSizePixel = 1
    fovCrosshair.BorderColor3 = Color3.fromRGB(0, 0, 0)
    fovCrosshair.Parent = circleGui
    
    local crosshairVertical = Instance.new("Frame")
    crosshairVertical.Size = UDim2.new(0, 2, 0, 20)
    crosshairVertical.Position = UDim2.new(0.5, -1, 0.5, -10)
    crosshairVertical.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    crosshairVertical.BorderSizePixel = 1
    crosshairVertical.BorderColor3 = Color3.fromRGB(0, 0, 0)
    crosshairVertical.Parent = circleGui
    
    return circleGui
end

local fovCircleGui = CreateFOVCircle()
fovCircleGui.Enabled = false

local function SetFOVCircleVisible(visible)
    fovCircleVisible = visible
    if fovCircleGui then
        fovCircleGui.Enabled = visible
    end
end

local function ToggleFOVCircle()
    SetFOVCircleVisible(not fovCircleVisible)
    AnimateToggle(FOVCircleTrack, FOVCircleThumb, fovCircleVisible)
end

local function UpdateFOVCircle()
    if fovCircle and fovCircle.Parent then
        fovCircle.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
        fovCircle.Position = UDim2.new(0.5, -FOV_RADIUS, 0.5, -FOV_RADIUS)
    end
    FOVValLabel.Text = FOV_RADIUS .."px"
    local pct = (FOV_RADIUS - 30) / 270
    SliderFill.Size = UDim2.new(pct, 0, 1, 0)
    SliderThumb.Position = UDim2.new(pct, -6, 0.5, -6)
end

local function UpdateFOVFromMouse(mousePos)
    local trackPos = SliderTrack.AbsolutePosition.X
    local trackWidth = SliderTrack.AbsoluteSize.X
    if trackWidth > 0 then
        local pct = math.clamp((mousePos.X - trackPos) / trackWidth, 0, 1)
        FOV_RADIUS = math.floor(30 + pct * 270)
        UpdateFOVCircle()
    end
end

local function onSliderInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        UpdateFOVFromMouse(input.Position)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingSlider = false end
        end)
    end
end

SliderThumb.InputBegan:Connect(onSliderInputBegan)
SliderTrack.InputBegan:Connect(onSliderInputBegan)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        UpdateFOVFromMouse(input.Position)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
end)

local function GetBestTarget()
    if not Aimlock_Enabled or not LocalPlayer.Character or not camera then return nil end
    local mouseLoc = UserInputService:GetMouseLocation()
    local bestTarget, bestDist = nil, FOV_RADIUS
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if IsWhitelisted(player) then continue end
            local head = player.Character:FindFirstChild("Head")
            local hum = player.Character:FindFirstChild("Humanoid")
            if head and hum and hum.Health > 0 then
                if not IsPlayerVisible(player.Character) then continue end
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen and screenPos.Z > 0 then
                    local dx = screenPos.X - mouseLoc.X
                    local dy = screenPos.Y - mouseLoc.Y
                    local dist = math.sqrt(dx*dx + dy*dy)
                    if dist <= FOV_RADIUS and dist < bestDist then
                        bestDist = dist
                        bestTarget = player
                    end
                end
            end
        end
    end
    return bestTarget
end

local function IsTargetStillValid(target)
    if not target or not target.Parent then return false end
    if target == LocalPlayer then return false end
    if not target.Character or not target.Character.Parent then return false end
    local head = target.Character:FindFirstChild("Head")
    local hum = target.Character:FindFirstChild("Humanoid")
    if not head or not hum or hum.Health <= 0 then return false end
    return true
end

local function GetPredictedTargetPosition(target)
    if not target or not target.Character then return nil, nil end
    local head = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if not head then return nil, nil end
    local targetPos = head.Position
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        local targetVelocity = rootPart.AssemblyLinearVelocity or rootPart.Velocity or Vector3.new()
        if targetVelocity then
            local shotDistance = (camera.CFrame.Position - targetPos).Magnitude
            local travelTime = PredictionTravelTime + shotDistance * PredictionDistanceFactor
            local lead = Vector3.new(targetVelocity.X, 0, targetVelocity.Z) * travelTime * PredictionBoost
            if lead.Magnitude > 18 then lead = lead.Unit * 18 end
            targetPos = targetPos + lead
        end
    end
    return targetPos, head
end

local function Aimlock()
    if not Aimlock_Enabled then return end
    if not IsTargetStillValid(currentTarget) then
        currentTarget = GetBestTarget()
    end
    if IsTargetStillValid(currentTarget) and currentTarget.Character then
        local targetPos = GetPredictedTargetPosition(currentTarget)
        if targetPos then
            local currentPos = camera.CFrame.Position
            if (targetPos - currentPos).Magnitude > 0.5 then
                local targetCFrame = CFrame.lookAt(currentPos, targetPos, camera.CFrame.UpVector)
                camera.CFrame = targetCFrame
            end
        end
    else
        currentTarget = nil
    end
end

local function StartAimlock()
    if aimlockConnection then aimlockConnection:Disconnect(); aimlockConnection = nil end
    if Aimlock_Enabled then aimlockConnection = RunService:BindToRenderStep("NebulaAimlock", 250, Aimlock) end
end

local function ToggleAimlock()
    Aimlock_Enabled = not Aimlock_Enabled
    AnimateToggle(AimlockTrack, AimlockThumb, Aimlock_Enabled)
    if Aimlock_Enabled then
        StartAimlock()
    else
        if aimlockConnection then aimlockConnection:Disconnect(); aimlockConnection = nil end
    end
end

AimlockBtn.MouseButton1Click:Connect(ToggleAimlock)

local function GetKeyName(key)
    if typeof(key) =="EnumItem"then
        if key == Enum.UserInputType.MouseButton1 then return"M1"
        elseif key == Enum.UserInputType.MouseButton2 then return"M2"
        elseif key == Enum.UserInputType.MouseButton3 then return"M3"
        else return string.sub(tostring(key), 10) end
    end
    return tostring(key)
end

KeyButton.MouseButton1Click:Connect(function()
    waitingForKey = true
    KeyButton.Text ="..."
    KeyButton.TextColor3 = Color3.fromRGB(255, 170, 0)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if waitingForKey then
        local key, isMouse = nil, false
        if input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode; isMouse = false
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then key = Enum.UserInputType.MouseButton1; isMouse = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then key = Enum.UserInputType.MouseButton2; isMouse = true
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then key = Enum.UserInputType.MouseButton3; isMouse = true
        end
        if key then
            AimlockKey = key; isMouseButton = isMouse
            KeyButton.Text = GetKeyName(key)
            KeyButton.TextColor3 = Color3.fromRGB(60, 160, 255)
            waitingForKey = false
        end
        return
    end
    local function isMouseOverMenu()
        if BloxFruitsPanel and BloxFruitsPanel.Visible then
            local mp = UserInputService:GetMouseLocation()
            local pos = BloxFruitsPanel.AbsolutePosition
            local size = BloxFruitsPanel.AbsoluteSize
            return mp.X >= pos.X and mp.X <= pos.X + size.X and mp.Y >= pos.Y and mp.Y <= pos.Y + size.Y
        end
        return false
    end
    if not waitingForKey then
        local pressed = false
        if isMouseButton and AimlockKey then
            if input.UserInputType == AimlockKey then pressed = true end
        elseif not isMouseButton and AimlockKey then
            if input.KeyCode == AimlockKey then pressed = true end
        end
        if pressed and not Aimlock_Enabled and not isMouseOverMenu() then ToggleAimlock() end

        if input.KeyCode == Enum.KeyCode.Insert then
            guiVisible = not guiVisible
            MainFrame.Visible = guiVisible
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not waitingForKey then
        local released = false
        if isMouseButton and AimlockKey then
            if input.UserInputType == AimlockKey then released = true end
        elseif not isMouseButton and AimlockKey then
            if input.KeyCode == AimlockKey then released = true end
        end
        if released and Aimlock_Enabled and not isMouseOverMenu() then ToggleAimlock() end
    end
end)

Players.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    if ESP_Enabled and player ~= LocalPlayer then CreateESP(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    CleanPlayer(player)
    for i, wl in ipairs(Whitelist) do
        if wl == player then
            table.remove(Whitelist, i)
            UpdateWhitelistDisplay()
            break
        end
    end
    if ESP_Connections[player] then 
        ESP_Connections[player]:Disconnect() 
        ESP_Connections[player] = nil 
    end
end)

ESPBtn.MouseButton1Click:Connect(ToggleESP)
ESPDistBtn.MouseButton1Click:Connect(ToggleESPDistance)
FOVCircleBtn.MouseButton1Click:Connect(ToggleFOVCircle)
HealthBarBtn.MouseButton1Click:Connect(ToggleHealthBar)
SkeletonBtn.MouseButton1Click:Connect(ToggleSkeleton)
TracerBtn.MouseButton1Click:Connect(ToggleTracer)

AnimateToggle(ESPTrack, ESPThumb, false)
AnimateToggle(ESPDistTrack, ESPDistThumb, false)
AnimateToggle(FOVCircleTrack, FOVCircleThumb, false)
AnimateToggle(HealthBarTrack, HealthBarThumb, false)
AnimateToggle(SkeletonTrack, SkeletonThumb, false)
AnimateToggle(TracerTrack, TracerThumb, false)
AnimateToggle(AimlockTrack, AimlockThumb, false)

SwitchToAim()
]]

murder_mystery = [[
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
screenGui.Name ="UpdateGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name ="BackgroundBlur"
blur.Size = 0
blur.Parent = screenGui

local darkOverlay = Instance.new("Frame")
darkOverlay.Name ="DarkOverlay"
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkOverlay.BackgroundTransparency = 1
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 0
darkOverlay.Parent = screenGui

local mainContainer = Instance.new("Frame")
mainContainer.Name ="MainContainer"
mainContainer.Size = UDim2.new(0, 420, 0, 210)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundTransparency = 1
mainContainer.BorderSizePixel = 0
mainContainer.ZIndex = 1
mainContainer.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name ="MainFrame"
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
shadow.Name ="Shadow"
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image ="rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.65
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0
shadow.Parent = mainFrame

local accentGlow = Instance.new("Frame")
accentGlow.Name ="AccentGlow"
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
contentFrame.Name ="ContentFrame"
contentFrame.Size = UDim2.new(1, -32, 1, -28)
contentFrame.Position = UDim2.new(0, 22, 0, 16)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 1
contentFrame.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Name ="HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 28)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Name ="DotIndicator"
dotIndicator.Size = UDim2.new(0, 6, 0, 6)
dotIndicator.Position = UDim2.new(0, 0, 0, 4)
dotIndicator.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = headerFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local titleLabel = Instance.new("TextLabel")
titleLabel.Name ="TitleLabel"
titleLabel.Size = UDim2.new(0, 100, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text ="NOTIFICATION"
titleLabel.TextColor3 = Color3.fromRGB(160, 165, 190)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = headerFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name ="VersionLabel"
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 0, 32)
versionLabel.BackgroundTransparency = 1
versionLabel.Text ="Information"
versionLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
versionLabel.TextSize = 22
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextTransparency = 1
versionLabel.Parent = contentFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name ="MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 72)
messageLabel.Position = UDim2.new(0, 0, 0, 68)
messageLabel.BackgroundTransparency = 1
messageLabel.Text ="Options pas ajouté"
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
divider.Name ="Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 148)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.95
divider.BorderSizePixel = 0
divider.Parent = contentFrame

local closeButton = Instance.new("TextButton")
closeButton.Name ="CloseButton"
closeButton.Size = UDim2.new(0, 90, 0, 30)
closeButton.Position = UDim2.new(0, 0, 0, 158)
closeButton.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
closeButton.BackgroundTransparency = 0.88
closeButton.BorderSizePixel = 0
closeButton.Text ="Compris"
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
        elseif element.Name =="DotIndicator"then
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
]]

grow_garden = [[
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
screenGui.Name ="UpdateGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name ="BackgroundBlur"
blur.Size = 0
blur.Parent = screenGui

local darkOverlay = Instance.new("Frame")
darkOverlay.Name ="DarkOverlay"
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkOverlay.BackgroundTransparency = 1
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 0
darkOverlay.Parent = screenGui

local mainContainer = Instance.new("Frame")
mainContainer.Name ="MainContainer"
mainContainer.Size = UDim2.new(0, 420, 0, 210)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundTransparency = 1
mainContainer.BorderSizePixel = 0
mainContainer.ZIndex = 1
mainContainer.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name ="MainFrame"
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
shadow.Name ="Shadow"
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image ="rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.65
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0
shadow.Parent = mainFrame

local accentGlow = Instance.new("Frame")
accentGlow.Name ="AccentGlow"
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
contentFrame.Name ="ContentFrame"
contentFrame.Size = UDim2.new(1, -32, 1, -28)
contentFrame.Position = UDim2.new(0, 22, 0, 16)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 1
contentFrame.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Name ="HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 28)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Name ="DotIndicator"
dotIndicator.Size = UDim2.new(0, 6, 0, 6)
dotIndicator.Position = UDim2.new(0, 0, 0, 4)
dotIndicator.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = headerFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local titleLabel = Instance.new("TextLabel")
titleLabel.Name ="TitleLabel"
titleLabel.Size = UDim2.new(0, 100, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text ="NOTIFICATION"
titleLabel.TextColor3 = Color3.fromRGB(160, 165, 190)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = headerFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name ="VersionLabel"
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 0, 32)
versionLabel.BackgroundTransparency = 1
versionLabel.Text ="Information"
versionLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
versionLabel.TextSize = 22
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextTransparency = 1
versionLabel.Parent = contentFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name ="MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 72)
messageLabel.Position = UDim2.new(0, 0, 0, 68)
messageLabel.BackgroundTransparency = 1
messageLabel.Text ="Options pas ajouté"
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
divider.Name ="Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 148)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.95
divider.BorderSizePixel = 0
divider.Parent = contentFrame

local closeButton = Instance.new("TextButton")
closeButton.Name ="CloseButton"
closeButton.Size = UDim2.new(0, 90, 0, 30)
closeButton.Position = UDim2.new(0, 0, 0, 158)
closeButton.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
closeButton.BackgroundTransparency = 0.88
closeButton.BorderSizePixel = 0
closeButton.Text ="Compris"
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
        elseif element.Name =="DotIndicator"then
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
]]

tsunami_brainrot = [[
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
screenGui.Name ="UpdateGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local blur = Instance.new("BlurEffect")
blur.Name ="BackgroundBlur"
blur.Size = 0
blur.Parent = screenGui

local darkOverlay = Instance.new("Frame")
darkOverlay.Name ="DarkOverlay"
darkOverlay.Size = UDim2.new(1, 0, 1, 0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
darkOverlay.BackgroundTransparency = 1
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 0
darkOverlay.Parent = screenGui

local mainContainer = Instance.new("Frame")
mainContainer.Name ="MainContainer"
mainContainer.Size = UDim2.new(0, 420, 0, 210)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.BackgroundTransparency = 1
mainContainer.BorderSizePixel = 0
mainContainer.ZIndex = 1
mainContainer.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Name ="MainFrame"
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
shadow.Name ="Shadow"
shadow.Size = UDim2.new(1, 24, 1, 24)
shadow.Position = UDim2.new(0, -12, 0, -12)
shadow.BackgroundTransparency = 1
shadow.Image ="rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.65
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0
shadow.Parent = mainFrame

local accentGlow = Instance.new("Frame")
accentGlow.Name ="AccentGlow"
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
contentFrame.Name ="ContentFrame"
contentFrame.Size = UDim2.new(1, -32, 1, -28)
contentFrame.Position = UDim2.new(0, 22, 0, 16)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 1
contentFrame.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Name ="HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 28)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = contentFrame

local dotIndicator = Instance.new("Frame")
dotIndicator.Name ="DotIndicator"
dotIndicator.Size = UDim2.new(0, 6, 0, 6)
dotIndicator.Position = UDim2.new(0, 0, 0, 4)
dotIndicator.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
dotIndicator.BorderSizePixel = 0
dotIndicator.Parent = headerFrame

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dotIndicator

local titleLabel = Instance.new("TextLabel")
titleLabel.Name ="TitleLabel"
titleLabel.Size = UDim2.new(0, 100, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text ="NOTIFICATION"
titleLabel.TextColor3 = Color3.fromRGB(160, 165, 190)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextTransparency = 1
titleLabel.Parent = headerFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Name ="VersionLabel"
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 0, 32)
versionLabel.BackgroundTransparency = 1
versionLabel.Text ="Information"
versionLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
versionLabel.TextSize = 22
versionLabel.Font = Enum.Font.GothamBold
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextTransparency = 1
versionLabel.Parent = contentFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Name ="MessageLabel"
messageLabel.Size = UDim2.new(1, 0, 0, 72)
messageLabel.Position = UDim2.new(0, 0, 0, 68)
messageLabel.BackgroundTransparency = 1
messageLabel.Text ="Options pas ajouté"
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
divider.Name ="Divider"
divider.Size = UDim2.new(1, 0, 0, 1)
divider.Position = UDim2.new(0, 0, 0, 148)
divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
divider.BackgroundTransparency = 0.95
divider.BorderSizePixel = 0
divider.Parent = contentFrame

local closeButton = Instance.new("TextButton")
closeButton.Name ="CloseButton"
closeButton.Size = UDim2.new(0, 90, 0, 30)
closeButton.Position = UDim2.new(0, 0, 0, 158)
closeButton.BackgroundColor3 = Color3.fromRGB(140, 120, 255)
closeButton.BackgroundTransparency = 0.88
closeButton.BorderSizePixel = 0
closeButton.Text ="Compris"
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
        elseif element.Name =="DotIndicator"then
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
]]

V = {}
C = { All = {} }
Cache = { Distances = {}, FPSBoost = {}, Lighting = nil, PostEffects = {} }
ConfigRegistry = {}

Keybinds = {
    Fly = Enum.KeyCode.F,
    Noclip = Enum.KeyCode.V,
    Invisible = Enum.KeyCode.C,
    DesyncFly = Enum.KeyCode.G,
    ESP = Enum.KeyCode.E,
    Speed = Enum.KeyCode.R,
    Respawn = Enum.KeyCode.B,
    Menu = Enum.KeyCode.Insert,
    Freecam = Enum.KeyCode.X,
    VehicleFly = Enum.KeyCode.H,
    VehicleBoost = Enum.KeyCode.T,
    InstantBrake = Enum.KeyCode.N,
    VehicleSeatTP = Enum.KeyCode.J,
    VehicleAutoFlip = Enum.KeyCode.K,
    VehicleExplode = Enum.KeyCode.L,
    VehiclePropulse = Enum.KeyCode.P
}

KeybindCallbacks = {}
KeybindButtons = {}
KeybindSystem = { Binding = false, BindingName = nil, BindingBtn = nil }

V.INVISIBILITY_POSITION = Vector3.new(0, 100000, 0)
V.FOV = 70

DefaultConfig = {
    Speed = 16, SpeedEnabled = true, SpeedMethod ="Humanoid", Jump = 50, JumpEnabled = true, 
    CFrameSpeed = false, WallClimb = false, AutoBhop = false,
    Fly = false, FlySpeed = 150, DesyncFly = false, DesyncFlySpeed = 150,
    AntiRagdoll = false, Noclip = false, NoAnim = false, Invis = false, InfJump = false, AntiVoid = false, Godmode = false,
    InstInteract = false, InfRange = false,
    ESP = false, ESPSelf = false, ESPBox = false, ESPFilled = false, ESPName = false, ESPDist = false,
    ESPSkeleton = false, ESPHealth = false, ESPWeapon = false, ESPDropped = false, ESPTracerOrigin ="Bottom",
    VehicleSpeed = 1, VehicleFly = false, VehicleFlySpeed = 150, VehicleNoclip = false, VehicleBoost = false, VehicleExplodeEnabled = false,
    KeybindHUD = false, UITransparency = 3, AccentColor ="Blue", Streamproof = false,
    ChatTranslator = false, AntiCheatAlert = false, UncensoredChat = false, PlayerJoinLeaveNotifs = false,
    Fullbright = false, FPSBoost = false,
    Force1st = false, Force3rd = false, UnlockZoom = false,
    FOV = 70,
    SpinSpeed = 100, Spin = false, ClickTP = false,
    AntiAFK = false, Notif = true, Watermark = false
}

function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
function getHumanoid()
    local char = getCharacter()
    return char:WaitForChild("Humanoid")
end
function getRoot()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local parent = (gethui and gethui()) or game:GetService("CoreGui")

if getgenv().BloxFruitsUILoaded then
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "BloxFruitsUI" or child.Name == "NebulaUpdateUI" or child.Name == "NebulaFreecamMenu" or child.Name == "NebulaFreecamCrosshair" then
            child:Destroy()
        end
    end
    if V then
        if C and C.All then
            for _, conn in ipairs(C.All) do
                pcall(function() conn:Disconnect() end)
            end
            C.All = {}
        end
        if V.FreecamConn then V.FreecamConn:Disconnect() V.FreecamConn = nil end
        if V.FreecamInputConn then V.FreecamInputConn:Disconnect() V.FreecamInputConn = nil end
        if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() V.FreecamMenuConn = nil end
        if V.FreecamTeleportConn then V.FreecamTeleportConn:Disconnect() V.FreecamTeleportConn = nil end
        if V.UnifiedInputConn then V.UnifiedInputConn:Disconnect() V.UnifiedInputConn = nil end
        if V.ToggleKeyConn then V.ToggleKeyConn:Disconnect() V.ToggleKeyConn = nil end
        if V.RailHWheelConn then V.RailHWheelConn:Disconnect() V.RailHWheelConn = nil end
        if V.RailHHeartbeatConn then V.RailHHeartbeatConn:Disconnect() V.RailHHeartbeatConn = nil end
        if V.InspectorClickConn then V.InspectorClickConn:Disconnect() V.InspectorClickConn = nil end
        if V.RailFollowConn then V.RailFollowConn:Disconnect() V.RailFollowConn = nil end
        V.RailAttached = nil
        if V.HitboxConn then V.HitboxConn:Disconnect() V.HitboxConn = nil end
        if V.BhopConn then V.BhopConn:Disconnect() V.BhopConn = nil end
        if V.VehicleBoostHoldConn then V.VehicleBoostHoldConn:Disconnect() V.VehicleBoostHoldConn = nil end
        if V.VehicleBoostEndConn then V.VehicleBoostEndConn:Disconnect() V.VehicleBoostEndConn = nil end
        V.Freecam = false
    end
end
getgenv().BloxFruitsUILoaded = true

local theme = {
    text = Color3.fromRGB(235, 235, 242),
    sub = Color3.fromRGB(130, 134, 152),
    panel = Color3.fromRGB(14, 15, 22),
    panel2 = Color3.fromRGB(18, 19, 28),
    card = Color3.fromRGB(23, 24, 35),
    cardHover = Color3.fromRGB(31, 33, 47),
    border = Color3.fromRGB(44, 46, 62),
    accent = Color3.fromRGB(145, 120, 255),
    accent2 = Color3.fromRGB(90, 160, 255),
    danger = Color3.fromRGB(220, 60, 60),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NebulaUpdateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = parent

local function makeCorner(gui, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = gui
    return corner
end

local function makeStroke(gui, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or theme.border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = gui
    return stroke
end

local function makeGradient(gui, from, to, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, from),
        ColorSequenceKeypoint.new(1, to),
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = gui
    return gradient
end

-- ============================= BACKGROUND & BUBBLES =============================

local BackgroundDimmer = Instance.new("Frame")
BackgroundDimmer.Name = "BackgroundDimmer"
BackgroundDimmer.Size = UDim2.new(1, 0, 1, 0)
BackgroundDimmer.Position = UDim2.new(0, 0, 0, 0)
BackgroundDimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundDimmer.BackgroundTransparency = 0.2 -- 80% opacity deep black
BackgroundDimmer.BorderSizePixel = 0
BackgroundDimmer.ZIndex = 1
BackgroundDimmer.Active = false
BackgroundDimmer.Parent = ScreenGui

local BubblesContainer = Instance.new("Frame")
BubblesContainer.Name = "BubblesContainer"
BubblesContainer.Size = UDim2.new(1, 0, 1, 0)
BubblesContainer.Position = UDim2.new(0, 0, 0, 0)
BubblesContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BubblesContainer.BackgroundTransparency = 1
BubblesContainer.ClipsDescendants = true
BubblesContainer.ZIndex = 2
BubblesContainer.Active = false
BubblesContainer.Parent = ScreenGui

local bubbles = {}
local numBubbles = 60

for i = 1, numBubbles do
    local b = Instance.new("Frame")
    local size = math.random(7, 30)
    b.Size = UDim2.new(0, size, 0, size)
    local randCol = math.random()
    if randCol > 0.65 then
        b.BackgroundColor3 = theme.accent -- Color3.fromRGB(145, 120, 255)
    elseif randCol > 0.35 then
        b.BackgroundColor3 = Color3.fromRGB(175, 145, 255)
    else
        b.BackgroundColor3 = Color3.fromRGB(125, 95, 245)
    end
    b.BackgroundTransparency = math.random(55, 80) / 100
    b.BorderSizePixel = 0
    b.ZIndex = 2
    b.Parent = BubblesContainer
    makeCorner(b, 50)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = math.random(70, 90) / 100
    stroke.Thickness = 1
    stroke.Parent = b

    local bubbleData = {
        frame = b,
        x = math.random(),
        y = math.random(),
        speed = math.random(30, 95) / 1000,
        swaySpeed = math.random(10, 28) / 10,
        swayAmp = math.random(6, 22) / 1000,
        offset = math.random() * math.pi * 2
    }
    b.Position = UDim2.new(bubbleData.x, 0, bubbleData.y, 0)
    table.insert(bubbles, bubbleData)
end

local menuSound = nil

local function playClick()
    pcall(function()
        if not menuSound or not menuSound.Parent then
            menuSound = Instance.new("Sound")
            menuSound.SoundId = "rbxassetid://12222010"
            menuSound.Volume = 0.18
            menuSound.PlaybackSpeed = 0.9
            menuSound.Parent = game:GetService("SoundService")
        end
        menuSound:Play()
    end)
end

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -24)
NotificationContainer.Position = UDim2.new(1, -316, 0, 12)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ZIndex = 50
NotificationContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Parent = NotificationContainer

initStep = "notify"
local function notify(title, text, color)
    color = color or theme.accent

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 300, 0, 56)
    card.Position = UDim2.new(0, 320, 0, 0)
    card.BackgroundColor3 = theme.panel
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ZIndex = 51
    card.Parent = NotificationContainer
    makeCorner(card, 10)
    makeStroke(card, theme.border, 1)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.ZIndex = 52
    bar.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -24, 0, 16)
    titleLabel.Position = UDim2.new(0, 14, 0, 7)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 52
    titleLabel.Parent = card

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -24, 0, 16)
    textLabel.Position = UDim2.new(0, 14, 0, 25)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = theme.sub
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextSize = 10
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextTruncate = Enum.TextTruncate.AtEnd
    textLabel.ZIndex = 52
    textLabel.Parent = card

    TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    task.delay(3, function()
        pcall(function()
            TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, 320, 0, 0)}):Play()
        end)
        task.delay(0.3, function()
            pcall(function() card:Destroy() end)
        end)
    end)
end

-- ============================= MAIN PANEL & SIDEBAR =============================

local defaultWindowSize = UDim2.new(0, 780, 0, 530)
local defaultWindowPos = UDim2.new(0.5, -390, 0.5, -265)

local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = defaultWindowSize
Panel.Position = defaultWindowPos
Panel.BackgroundColor3 = theme.panel
Panel.BackgroundTransparency = 0
Panel.BorderSizePixel = 0
Panel.ClipsDescendants = true
Panel.Visible = false
Panel.Active = true
Panel.ZIndex = 5
Panel.Parent = ScreenGui
makeCorner(Panel, 14)
makeStroke(Panel, theme.border, 1.2)

local PanelScale = Instance.new("UIScale")
PanelScale.Scale = 1
PanelScale.Parent = Panel

BloxFruitsPanel = Panel

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 195, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = theme.panel2
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 6
Sidebar.Parent = Panel
makeCorner(Sidebar, 14)

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Name = "SidebarDivider"
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BackgroundColor3 = theme.border
SidebarDivider.BackgroundTransparency = 0.4
SidebarDivider.BorderSizePixel = 0
SidebarDivider.ZIndex = 7
SidebarDivider.Parent = Sidebar

local LogoFrame = Instance.new("Frame")
LogoFrame.Name = "LogoFrame"
LogoFrame.Size = UDim2.new(1, 0, 0, 56)
LogoFrame.Position = UDim2.new(0, 0, 0, 0)
LogoFrame.BackgroundTransparency = 1
LogoFrame.ZIndex = 7
LogoFrame.Parent = Sidebar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -20, 0, 24)
Logo.Position = UDim2.new(0, 14, 0, 12)
Logo.BackgroundTransparency = 1
Logo.Text = "NEBULA"
Logo.TextColor3 = theme.accent
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 20
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.ZIndex = 8
Logo.Parent = LogoFrame

local LogoSub = Instance.new("TextLabel")
LogoSub.Size = UDim2.new(1, -20, 0, 14)
LogoSub.Position = UDim2.new(0, 14, 0, 36)
LogoSub.BackgroundTransparency = 1
LogoSub.Text = "ROBLOX HUB v2.0"
LogoSub.TextColor3 = theme.sub
LogoSub.Font = Enum.Font.Code
LogoSub.TextSize = 9
LogoSub.TextXAlignment = Enum.TextXAlignment.Left
LogoSub.ZIndex = 8
LogoSub.Parent = LogoFrame

local LogoSep = Instance.new("Frame")
LogoSep.Size = UDim2.new(1, -20, 0, 1)
LogoSep.Position = UDim2.new(0, 10, 1, -1)
LogoSep.BackgroundColor3 = theme.border
LogoSep.BackgroundTransparency = 0.5
LogoSep.BorderSizePixel = 0
LogoSep.ZIndex = 7
LogoSep.Parent = LogoFrame

-- Scrollable Navigation Container
local NavScroll = Instance.new("ScrollingFrame")
NavScroll.Name = "NavScroll"
NavScroll.Size = UDim2.new(1, -12, 1, -146)
NavScroll.Position = UDim2.new(0, 6, 0, 62)
NavScroll.BackgroundTransparency = 1
NavScroll.BorderSizePixel = 0
NavScroll.ScrollBarThickness = 3
NavScroll.ScrollBarImageColor3 = theme.border
NavScroll.ScrollBarImageTransparency = 0.3
NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
NavScroll.ZIndex = 7
NavScroll.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0, 4)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Parent = NavScroll

local NavPad = Instance.new("UIPadding")
NavPad.PaddingTop = UDim.new(0, 4)
NavPad.PaddingBottom = UDim.new(0, 6)
NavPad.PaddingLeft = UDim.new(0, 2)
NavPad.PaddingRight = UDim.new(0, 4)
NavPad.Parent = NavScroll

-- Account Profile Block at Bottom of Sidebar
local AccountBlock = Instance.new("Frame")
AccountBlock.Name = "AccountBlock"
AccountBlock.Size = UDim2.new(1, -12, 0, 68)
AccountBlock.Position = UDim2.new(0, 6, 1, -74)
AccountBlock.BackgroundColor3 = theme.card
AccountBlock.BorderSizePixel = 0
AccountBlock.ZIndex = 7
AccountBlock.Parent = Sidebar
makeCorner(AccountBlock, 10)
makeStroke(AccountBlock, theme.border, 1)

local AvatarRing = Instance.new("Frame")
AvatarRing.Name = "AvatarRing"
AvatarRing.Size = UDim2.new(0, 42, 0, 42)
AvatarRing.Position = UDim2.new(0, 8, 0.5, -21)
AvatarRing.BackgroundColor3 = theme.cardHover
AvatarRing.BorderSizePixel = 0
AvatarRing.ZIndex = 8
AvatarRing.Parent = AccountBlock
makeCorner(AvatarRing, 50)
makeStroke(AvatarRing, theme.accent, 1.5, 0.2)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.BorderSizePixel = 0
AvatarImage.ScaleType = Enum.ScaleType.Crop
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
AvatarImage.ZIndex = 9
AvatarImage.Parent = AvatarRing
makeCorner(AvatarImage, 50)

pcall(function()
    local thumb = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    if thumb and thumb ~= "" then
        AvatarImage.Image = thumb
    end
end)

local AccountName = Instance.new("TextLabel")
AccountName.Name = "AccountName"
AccountName.Size = UDim2.new(1, -62, 0, 16)
AccountName.Position = UDim2.new(0, 56, 0, 14)
AccountName.BackgroundTransparency = 1
AccountName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
AccountName.TextColor3 = theme.text
AccountName.Font = Enum.Font.GothamBold
AccountName.TextSize = 11
AccountName.TextXAlignment = Enum.TextXAlignment.Left
AccountName.TextTruncate = Enum.TextTruncate.AtEnd
AccountName.ZIndex = 8
AccountName.Parent = AccountBlock

local AccountUser = Instance.new("TextLabel")
AccountUser.Name = "AccountUser"
AccountUser.Size = UDim2.new(1, -62, 0, 14)
AccountUser.Position = UDim2.new(0, 56, 0, 32)
AccountUser.BackgroundTransparency = 1
AccountUser.Text = "@" .. LocalPlayer.Name
AccountUser.TextColor3 = theme.sub
AccountUser.Font = Enum.Font.Code
AccountUser.TextSize = 9
AccountUser.TextXAlignment = Enum.TextXAlignment.Left
AccountUser.TextTruncate = Enum.TextTruncate.AtEnd
AccountUser.ZIndex = 8
AccountUser.Parent = AccountBlock

local StatusDot = Instance.new("Frame")
StatusDot.Name = "StatusDot"
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(1, -14, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 9
StatusDot.Parent = AccountBlock
makeCorner(StatusDot, 50)

-- TopBar / Header of Content
local PanelHeader = Instance.new("Frame")
PanelHeader.Name = "PanelHeader"
PanelHeader.Size = UDim2.new(1, -195, 0, 44)
PanelHeader.Position = UDim2.new(0, 195, 0, 0)
PanelHeader.BackgroundTransparency = 1
PanelHeader.Active = true
PanelHeader.ZIndex = 8
PanelHeader.Parent = Panel

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(1, -120, 1, 0)
PanelTitle.Position = UDim2.new(0, 16, 0, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "MOVEMENT"
PanelTitle.TextColor3 = theme.text
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.TextSize = 14
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 9
PanelTitle.Parent = PanelHeader

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 26)
MinBtn.Position = UDim2.new(1, -66, 0.5, -13)
MinBtn.BackgroundColor3 = theme.card
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextColor3 = theme.sub
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.ZIndex = 10
MinBtn.Parent = PanelHeader
makeCorner(MinBtn, 7)
makeStroke(MinBtn, theme.border, 1)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = theme.card
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.TextColor3 = theme.sub
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.ZIndex = 10
CloseBtn.Parent = PanelHeader
makeCorner(CloseBtn, 7)
makeStroke(CloseBtn, theme.border, 1)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.danger, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.card, TextColor3 = theme.sub}):Play()
end)

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
HeaderDivider.BackgroundColor3 = theme.border
HeaderDivider.BackgroundTransparency = 0.5
HeaderDivider.BorderSizePixel = 0
HeaderDivider.ZIndex = 7
HeaderDivider.Parent = PanelHeader

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -207, 1, -48)
ContentArea.Position = UDim2.new(0, 199, 0, 44)
ContentArea.BackgroundTransparency = 1
ContentArea.ZIndex = 6
ContentArea.Parent = Panel

local panels = {}

local function createPanel(name)
    local panel = Instance.new("ScrollingFrame")
    panel.Name = name
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.BorderSizePixel = 0
    panel.ScrollBarThickness = 3
    panel.ScrollBarImageColor3 = theme.border
    panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
    panel.CanvasSize = UDim2.new(1, 0, 0, 0)
    panel.Visible = false
    panel.ZIndex = 6
    panel.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = panel

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent = panel

    panels[name] = panel
    return panel
end

local function createCard(parent, order, height)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, height or 46)
    card.BackgroundColor3 = theme.card
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 0
    card.ZIndex = 7
    card.Parent = parent
    makeCorner(card, 10)
    makeStroke(card, theme.border, 1)

    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = theme.card}):Play()
    end)

    return card
end

local function createSectionHeader(parent, title, order)
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 24)
    header.BackgroundTransparency = 1
    header.LayoutOrder = order or 0
    header.ZIndex = 7
    header.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = title:upper()
    lbl.TextColor3 = theme.accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 8
    lbl.Parent = header

    return header
end

local function setToggleBtn(btn, value)
    if not btn then return end
    btn.Text = value and "ON" or "OFF"
    TweenService:Create(btn, TweenInfo.new(0.15), {
        BackgroundColor3 = value and theme.accent or theme.cardHover,
        TextColor3 = value and Color3.fromRGB(255, 255, 255) or theme.sub,
    }):Play()
end

local function createToggleCard(parent, text, subtext, order, getter, setter)
    local card = createCard(parent, order, subtext and 54 or 44)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 16)
    title.Position = UDim2.new(0, 12, 0, subtext and 6 or 14)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = theme.text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 8
    title.Parent = card

    if subtext then
        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -80, 0, 13)
        sub.Position = UDim2.new(0, 12, 0, 24)
        sub.BackgroundTransparency = 1
        sub.Text = subtext
        sub.TextColor3 = theme.sub
        sub.Font = Enum.Font.Gotham
        sub.TextSize = 9
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 8
        sub.Parent = card
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 58, 0, 28)
    btn.Position = UDim2.new(1, -70, 0.5, -14)
    btn.BackgroundColor3 = theme.cardHover
    btn.BorderSizePixel = 0
    btn.Text = "OFF"
    btn.TextColor3 = theme.sub
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 9
    btn.Parent = card
    makeCorner(btn, 9)
    makeStroke(btn, theme.border, 1)

    btn.MouseButton1Click:Connect(function()
        playClick()
        local newVal = not getter()
        setter(newVal)
        setToggleBtn(btn, newVal)
        notify(text, newVal and "Activé" or "Désactivé", newVal and theme.accent or theme.danger)
    end)

    setToggleBtn(btn, getter())

    return card, btn
end

local categories = {
    { key = "Movement", title = "Movement" },
    { key = "Me", title = "Me" },
    { key = "Protection", title = "Protection" },
    { key = "ESP", title = "ESP" },
    { key = "Teleport", title = "Teleport" },
    { key = "Joueur", title = "Joueur" },
    { key = "Chat", title = "Chat" },
    { key = "Server", title = "Server" },
    { key = "Vehicle", title = "Vehicle" },
    { key = "Fun", title = "Fun" },
    { key = "Scripts", title = "Scripts" },
    { key = "Settings", title = "Settings" },
    { key = "Config", title = "Config" },
    { key = "Code", title = "Code" },
}

local minimized = false
local panelPos = defaultWindowPos
local setMinimized = nil
local currentCategory = "Movement"
local railButtons = {}

local function switchCategory(key)
    currentCategory = key
    for name, panel in pairs(panels) do
        if name == key then
            panel.Visible = true
            panel.Position = UDim2.new(0, 14, 0, 0)
            TweenService:Create(panel, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        else
            panel.Visible = false
        end
    end
    for _, cat in ipairs(categories) do
        local data = railButtons[cat.key]
        if data then
            local isActive = cat.key == key
            TweenService:Create(data.btn, TweenInfo.new(0.2), {
                BackgroundColor3 = isActive and theme.accent or Color3.fromRGB(24, 25, 36),
                TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or theme.sub,
            }):Play()
            if data.accent then
                data.accent.Visible = isActive
            end
        end
    end
    for _, cat in ipairs(categories) do
        if cat.key == key then
            PanelTitle.Text = cat.title
            break
        end
    end
end

local function createCategoryButton(cat, index, parentContainer)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = (cat.key == currentCategory) and theme.accent or Color3.fromRGB(24, 25, 36)
    btn.BorderSizePixel = 0
    btn.Text = cat.title
    btn.TextColor3 = (cat.key == currentCategory) and Color3.fromRGB(255, 255, 255) or theme.sub
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = index
    btn.ZIndex = 8
    btn.Parent = parentContainer
    makeCorner(btn, 8)
    makeStroke(btn, theme.border, 1, 0.5)

    local btnPad = Instance.new("UIPadding")
    btnPad.PaddingLeft = UDim.new(0, 14)
    btnPad.Parent = btn

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0.6, 0)
    accentBar.Position = UDim2.new(0, -10, 0.2, 0)
    accentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accentBar.BorderSizePixel = 0
    accentBar.Visible = (cat.key == currentCategory)
    accentBar.ZIndex = 9
    accentBar.Parent = btn
    makeCorner(accentBar, 2)

    local scale = Instance.new("UIScale")
    scale.Parent = btn

    btn.MouseEnter:Connect(function()
        if cat.key ~= currentCategory then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover, TextColor3 = theme.text}):Play()
        end
        TweenService:Create(scale, TweenInfo.new(0.15), {Scale = 1.02}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if cat.key ~= currentCategory then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 25, 36), TextColor3 = theme.sub}):Play()
        end
        TweenService:Create(scale, TweenInfo.new(0.15), {Scale = 1}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        playClick()
        if minimized then
            setMinimized(false)
        end
        switchCategory(cat.key)
    end)

    railButtons[cat.key] = { btn = btn, accent = accentBar, index = index }
    return btn
end

for index, cat in ipairs(categories) do
    createCategoryButton(cat, index, NavScroll)
    createPanel(cat.key)
end

function setAccentColor(col)
    theme.accent = col
    PanelTitle.TextColor3 = col
    Logo.TextColor3 = col
    AvatarRing.UIStroke.Color = col
    local data = railButtons[currentCategory]
    if data and data.btn then
        data.btn.BackgroundColor3 = col
    end
end

ContentFrames = {}
for _, cat in ipairs(categories) do
    local panel = panels[cat.key]
    ContentFrames[cat.key] = panel
end

activeNSlider = nil

function createToggle(name, default, callback, parent, configKey)
    local card = createCard(parent, 0, 44)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 16)
    title.Position = UDim2.new(0, 12, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = theme.text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 8
    title.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 0, 24)
    btn.Position = UDim2.new(1, -62, 0.5, -12)
    btn.BackgroundColor3 = theme.cardHover
    btn.BorderSizePixel = 0
    btn.Text = "OFF"
    btn.TextColor3 = theme.sub
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.ZIndex = 9
    btn.Parent = card
    makeCorner(btn, 8)
    makeStroke(btn, theme.border, 1)

    local enabled = default or false
    setToggleBtn(btn, enabled)

    local function setToggleState(value)
        enabled = value
        setToggleBtn(btn, enabled)
        pcall(callback, enabled)
    end

    local function toggleState()
        setToggleState(not enabled)
    end

    btn.MouseButton1Click:Connect(function()
        playClick()
        toggleState()
    end)

    if configKey then
        ConfigRegistry[configKey] = setToggleState
    end

    return card, setToggleState, toggleState
end

function createSlider(name, min, max, default, callback, parent, configKey)
    local card = createCard(parent, 0, 52)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, -10, 0, 16)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = theme.text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 8
    title.Parent = card

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 40, 0, 16)
    valLbl.Position = UDim2.new(1, -52, 0, 6)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = theme.accent2
    valLbl.Font = Enum.Font.Code
    valLbl.TextSize = 10
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 8
    valLbl.Parent = card

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0, 38)
    track.BackgroundColor3 = theme.cardHover
    track.BorderSizePixel = 0
    track.ZIndex = 8
    track.Parent = card
    makeCorner(track, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = theme.accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 9
    fill.Parent = track
    makeCorner(fill, 2)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 10, 0, 10)
    thumb.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    thumb.BackgroundColor3 = theme.text
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 10
    thumb.Parent = track
    makeCorner(thumb, 5)

    local function updateFromX(x)
        local trackPos = track.AbsolutePosition.X
        local trackWidth = track.AbsoluteSize.X
        if trackWidth <= 0 then return end
        local pct = math.clamp((x - trackPos) / trackWidth, 0, 1)
        local value = math.floor(min + pct * (max - min))
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, -5, 0.5, -5)
        pcall(callback, value)
    end

    local function setSliderValue(value)
        value = math.clamp(value, min, max)
        local pct = (value - min) / (max - min)
        valLbl.Text = tostring(value)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, -5, 0.5, -5)
        pcall(callback, value)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            activeNSlider = updateFromX
            updateFromX(input.Position.X)
        end
    end)
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            activeNSlider = updateFromX
            updateFromX(input.Position.X)
        end
    end)

    if configKey then
        ConfigRegistry[configKey] = setSliderValue
    end

    return card, setSliderValue
end

function createButton(name, callback, parent)
    local card = createCard(parent, 0, 42)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 16)
    title.Position = UDim2.new(0, 12, 0, 13)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = theme.text
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 8
    title.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 64, 0, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = theme.cardHover
    btn.BorderSizePixel = 0
    btn.Text = "Lancer"
    btn.TextColor3 = theme.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.ZIndex = 9
    btn.Parent = card
    makeCorner(btn, 7)
    makeStroke(btn, theme.border, 1)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover, TextColor3 = theme.text}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        playClick()
        if callback then
            pcall(callback)
        end
    end)

    return card
end

function createLabel(text, parent)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(120, 120, 132)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 9
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 8
    Label.Parent = parent
    return Label
end

nSliderMoveConn = UserInputService.InputChanged:Connect(function(input)
    if activeNSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        activeNSlider(input.Position.X)
    end
end)
nSliderEndConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        activeNSlider = nil
    end
end)



local savedWindowSize = defaultWindowSize
local savedWindowPos = defaultWindowPos
local menuOpen = true

function toggleMenu(forceState)
    if forceState ~= nil then
        menuOpen = forceState
    else
        menuOpen = not menuOpen
    end

    if menuOpen then
        minimized = false
        Panel.Visible = true
        Sidebar.Visible = true
        ContentArea.Visible = true
        PanelHeader.Size = UDim2.new(1, -195, 0, 44)
        PanelHeader.Position = UDim2.new(0, 195, 0, 0)
        PanelTitle.Text = currentCategory
        BubblesContainer.Visible = true
        BubblesContainer.BackgroundTransparency = 1
        BackgroundDimmer.Visible = true
        BackgroundDimmer.BackgroundTransparency = 1
        TweenService:Create(BackgroundDimmer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
        local restorePos = savedWindowPos or defaultWindowPos
        local restoreSize = savedWindowSize or defaultWindowSize
        Panel.Size = restoreSize
        Panel.Position = restorePos + UDim2.new(0, 0, 0, 16)
        PanelScale.Scale = 0.88
        TweenService:Create(PanelScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = restorePos
        }):Play()
    else
        minimized = false
        TweenService:Create(BackgroundDimmer, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(PanelScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0.85}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = (savedWindowPos or defaultWindowPos) + UDim2.new(0, 0, 0, 16)
        }):Play()
        task.delay(0.22, function()
            if not menuOpen then
                Panel.Visible = false
                BubblesContainer.Visible = false
                BackgroundDimmer.Visible = false
            end
        end)
    end
end
_G.toggleNebulaMenu = toggleMenu

setMinimized = function(value)
    minimized = value
    if value then
        savedWindowSize = Panel.Size
        savedWindowPos = Panel.Position
        Sidebar.Visible = false
        ContentArea.Visible = false
        PanelHeader.Size = UDim2.new(1, 0, 1, 0)
        PanelHeader.Position = UDim2.new(0, 0, 0, 0)
        PanelTitle.Text = "NEBULA  |  " .. currentCategory

        BubblesContainer.Visible = false
        TweenService:Create(BackgroundDimmer, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        task.delay(0.2, function()
            if minimized then
                BackgroundDimmer.Visible = false
            end
        end)
        TweenService:Create(PanelScale, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 230, 0, 44),
            Position = UDim2.new(0.5, -115, 1, -56)
        }):Play()
    else
        PanelHeader.Size = UDim2.new(1, -195, 0, 44)
        PanelHeader.Position = UDim2.new(0, 195, 0, 0)
        PanelTitle.Text = currentCategory
        Sidebar.Visible = true
        ContentArea.Visible = true
        BubblesContainer.Visible = true
        BubblesContainer.BackgroundTransparency = 1
        BackgroundDimmer.Visible = true
        BackgroundDimmer.BackgroundTransparency = 1
        TweenService:Create(BackgroundDimmer, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
        local restorePos = savedWindowPos or defaultWindowPos
        local restoreSize = savedWindowSize or defaultWindowSize
        PanelScale.Scale = 0.92
        TweenService:Create(PanelScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = restoreSize,
            Position = restorePos
        }):Play()
    end
end

MinBtn.MouseButton1Click:Connect(function()
    playClick()
    setMinimized(not minimized)
end)
MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.card, TextColor3 = theme.sub}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    playClick()
    toggleMenu(false)
end)

-- Bubble animation RenderStepped loop
local bubbleRenderConn = RunService.RenderStepped:Connect(function(dt)
    if menuOpen and not minimized and Panel.Visible then
        local t = tick()
        for _, b in ipairs(bubbles) do
            b.y = b.y + b.speed * dt
            if b.y > 1.05 then
                b.y = -0.05
                b.x = math.random()
            end
            local curX = b.x + math.sin(t * b.swaySpeed + b.offset) * b.swayAmp
            b.frame.Position = UDim2.new(curX, 0, b.y, 0)
        end
    end
end)

local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    Panel.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
    if not minimized then
        savedWindowPos = Panel.Position
    end
end

local function enableDrag(frame)
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Panel.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
end

enableDrag(PanelHeader)
enableDrag(LogoFrame)

local dragConn = UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 24, 0, 24)
ResizeHandle.Position = UDim2.new(1, -26, 1, -26)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = ""
ResizeHandle.ZIndex = 15
ResizeHandle.Parent = Panel

local resizing = false

ResizeHandle.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not minimized then
        resizing = true
    end
end)
local resizeChangedConn = UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local newWidth = math.max(620, input.Position.X - Panel.AbsolutePosition.X)
        local newHeight = math.max(420, input.Position.Y - Panel.AbsolutePosition.Y)
        Panel.Size = UDim2.new(0, newWidth, 0, newHeight)
        savedWindowSize = Panel.Size
    end
end)
local resizeEndedConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

function performFullUnload()
    pcall(function() RunService:UnbindFromRenderStep("NebulaAimlock") end)
    pcall(function() RunService:UnbindFromRenderStep("NebulaFreecam") end)

    pcall(function() if V and V.Fly and stopFly then stopFly() end end)
    pcall(function() if V and V.DesyncFly and stopDesyncFly then stopDesyncFly() end end)
    pcall(function() if V and V.Noclip and stopNoclip then stopNoclip() end end)
    pcall(function() if V and V.Invis and toggleInvisibility then toggleInvisibility(false) end end)
    pcall(function() if V and V.NoAnim and disableNoAnim then disableNoAnim() end end)
    pcall(function() if V and V.Flinging and stopFling then stopFling() end end)
    pcall(function() if V and V.Spectate and stopSpectate then stopSpectate() end end)
    pcall(function() if V and V.InfRange and toggleInfiniteRange then toggleInfiniteRange(false) end end)
    pcall(function() if V and V.FPSBoost and toggleFPSBooster then toggleFPSBooster(false) end end)
    pcall(function() if V and V.Fullbright and toggleFullbright then toggleFullbright(false) end end)
    pcall(function() if V and V.ClickTP and toggleClickTP then toggleClickTP(false) end end)

    pcall(function()
        if V then V.ESP = false end
        if clearESP then clearESP() end
        if ClearESP then ClearESP() end
        if ESPGui then ESPGui:Destroy() end
    end)

    pcall(function()
        if V and V.HitboxConn then V.HitboxConn:Disconnect(); V.HitboxConn = nil end
        if V then V.HitboxExtender = false end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                for _, desc in pairs(p.Character:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        if desc.Name == "HumanoidRootPart" then
                            desc.Size = Vector3.new(2, 2, 1)
                            desc.Transparency = 1
                            desc.Material = Enum.Material.Plastic
                            desc.CanCollide = false
                        elseif desc.Name == "Head" then
                            desc.Size = Vector3.new(2, 1, 1)
                            desc.Transparency = 0
                            desc.Material = Enum.Material.Plastic
                            local mesh = desc:FindFirstChildOfClass("SpecialMesh")
                            if mesh then mesh.Scale = Vector3.new(1.25, 1.25, 1.25) end
                        else
                            desc.Transparency = 0
                            desc.Material = Enum.Material.Plastic
                        end
                    elseif desc:IsA("Highlight") or desc:IsA("SelectionBox") or desc:IsA("BoxHandleAdornment") then
                        desc:Destroy()
                    end
                end
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local hs = hum:FindFirstChild("HeadScale")
                    if hs then hs.Value = 1 end
                    local bws = hum:FindFirstChild("BodyWidthScale")
                    if bws then bws.Value = 1 end
                    local bhs = hum:FindFirstChild("BodyHeightScale")
                    if bhs then bhs.Value = 1 end
                    local bds = hum:FindFirstChild("BodyDepthScale")
                    if bds then bds.Value = 1 end
                end
            end
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate = true
                hum.Sit = false
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.JumpHeight = 7.2
                hum.UseJumpPower = true
                hum.HipHeight = 0
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                for _, obj in pairs(hrp:GetChildren()) do
                    if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("LinearVelocity") or obj:IsA("VectorForce") then
                        obj:Destroy()
                    end
                end
            end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end)

    pcall(function()
        workspace.Gravity = 196.2
        if Camera then
            Camera.FieldOfView = 70
            Camera.CameraType = Enum.CameraType.Custom
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
        end
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end)

    pcall(function()
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        Lighting.ClockTime = 14
        Lighting.ExposureCompensation = 0
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then effect.Enabled = true end
        end
    end)

    pcall(function()
        if bubbleRenderConn then bubbleRenderConn:Disconnect() end
        if dragConn then dragConn:Disconnect() end
        if resizeChangedConn then resizeChangedConn:Disconnect() end
        if resizeEndedConn then resizeEndedConn:Disconnect() end
        if nSliderMoveConn then nSliderMoveConn:Disconnect() end
        if nSliderEndConn then nSliderEndConn:Disconnect() end
        if V and V.UnifiedInputConn then V.UnifiedInputConn:Disconnect(); V.UnifiedInputConn = nil end
        if V and V.InspectorClickConn then V.InspectorClickConn:Disconnect(); V.InspectorClickConn = nil end
        if V and V.RailHWheelConn then V.RailHWheelConn:Disconnect(); V.RailHWheelConn = nil end
        if V and V.RailHHeartbeatConn then V.RailHHeartbeatConn:Disconnect(); V.RailHHeartbeatConn = nil end
        if V and V.VehicleBoostHoldConn then V.VehicleBoostHoldConn:Disconnect(); V.VehicleBoostHoldConn = nil end
        if V and V.VehicleBoostEndConn then V.VehicleBoostEndConn:Disconnect(); V.VehicleBoostEndConn = nil end
        if V and V.SpinConn then V.SpinConn:Disconnect(); V.SpinConn = nil end
        if V and V.AttachConn then V.AttachConn:Disconnect(); V.AttachConn = nil end
        if V and V.BhopConn then V.BhopConn:Disconnect(); V.BhopConn = nil end

        for _, conn in pairs(C and C.All or {}) do
            pcall(function() conn:Disconnect() end)
        end
        if C then C.All = {} end
        for _, conn in pairs(V and V.Connections or {}) do
            pcall(function() conn:Disconnect() end)
        end
        if V then V.Connections = {} end
    end)

    pcall(function()
        if ScreenGui then ScreenGui:Destroy() end
    end)
    pcall(function()
        for _, child in pairs(parentTarget:GetChildren()) do
            if child:IsA("ScreenGui") and (child.Name == "NebulaUpdateUI" or child.Name == "EternalFlick_GUI" or child.Name == "NebulaFreecamMenu" or child.Name == "NebulaFreecamCrosshair" or child.Name == "NebulaPlayerInspector" or child.Name == "NebulaESP") then
                child:Destroy()
            end
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
            char:BreakJoints()
        end
    end)

    getgenv().BloxFruitsUILoaded = false
    _G.NebulaLoaded = false
    _G.toggleNebulaMenu = nil
end
unloadMenu = performFullUnload
unloadNebula = performFullUnload

task.delay(0.3, function()
    menuOpen = true
    Panel.Visible = true
    BubblesContainer.Visible = true
    BubblesContainer.BackgroundTransparency = 1
    BackgroundDimmer.Visible = true
    BackgroundDimmer.BackgroundTransparency = 1
    TweenService:Create(BackgroundDimmer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
    PanelScale.Scale = 0.88
    Panel.Position = panelPos + UDim2.new(0, 0, 0, 16)
    TweenService:Create(PanelScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    TweenService:Create(Panel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = panelPos}):Play()
    switchCategory("Movement")
end)

local ChatContent = ContentFrames["Chat"]
local SpyContent = ContentFrames["Spy"]
local ProtectionContent = ContentFrames["Protection"]
local MovementContent = ContentFrames["Movement"]
local MeContent = ContentFrames["Me"]
local ESPContent = ContentFrames["ESP"]
local TeleportContent = ContentFrames["Teleport"]
local JoueurContent = ContentFrames["Joueur"]
local ServerContent = ContentFrames["Server"]
local FunContent = ContentFrames["Fun"]
local ScriptsContent = ContentFrames["Scripts"]
local SettingsContent = ContentFrames["Settings"]
local ConfigContent = ContentFrames["Config"]
local VehicleContent = ContentFrames["Vehicle"]
local CodeContent = ContentFrames["Code"]

local function initFeatures()
initStep = "V defaults"
V.Speed = 16
V.SpeedEnabled = true
V.SpeedMethod = "Humanoid"
V.Jump = 50
V.JumpEnabled = true
V.FlySpeed = 150
V.DesyncFlySpeed = 150
V.Fly = false
V.Noclip = false
V.InfJump = false
V.DesyncFly = false
V.CFrameSpeed = false
V.WallClimb = false
V.Invis = false
V.InvisConn = nil
V.Notif = true
V.AntiAFK = false
V.NoAnim = false
V.Spin = false
V.SpinSpeed = 100
V.Watermark = false
V.AntiRagdoll = false
V.InstInteract = false
V.InfRange = false
V.FPSBoost = false
V.Fullbright = false
V.ESP = false
V.ESPBox = false
V.ESPGlow = false
V.ESPFilled = false
V.ESPName = false
V.ESPDist = false
V.ESPSelf = false
V.AntiFling = false
V.RapidFire = false
V.InfAmmo = false
V.FastReload = false
V.HitboxExtender = false
V.HitboxSize = 25
V.BodyHeightScale = 10
V.BodyWidthScale = 10
V.RightClickInspect = false
V.ESPTracer = false
V.ESPSkeleton = false
V.ESPHealth = false
V.ESPWeapon = false
V.ESPDropped = false
V.ESPTracerOrigin ="Bottom"
V.AutoBhop = false
V.AntiVoid = false
V.Godmode = false
V.VehicleGhost = false
V.VehicleNitroFlame = false
V.VehicleExplodeEnabled = false
V.VehicleRampKey = Enum.KeyCode.U
V.VehicleSpeed = 1
V.VehicleFly = false
V.VehicleFlySpeed = 150
V.VehicleNoclip = false
V.VehicleBoostSpeed = 250
V.VehicleBoosting = false
V.KeybindHUD = false
V.UITransparency = 3
V.AccentColor = Color3.fromRGB(60, 160, 255)
V.ESPColor = Color3.fromRGB(145, 120, 255)
V.ESPObjects = {}
V.OrigAnim = nil
V.SelPlayer = nil
V.Spectate = false
V.SpecConn = nil
V.Attached = nil
V.NoAnimConn = nil
V.AttachConn = nil
V.SpinConn = nil
V.AntiRagdollConn = nil
V.Inst1 = nil
V.Inst2 = nil
V.Inf1 = nil
V.Inf2 = nil
V.InfRangeConn = nil
V.FPSBoost1 = nil
V.FPSBoost2 = nil
V.ToggleKeyConn = nil
V.ClickTP = false
V.ClickTPTool = nil
V.Flinging = false
V.FlingTarget = nil
V.FlingConn = nil
V.Freecam = false
V.FreecamSpeed = 50
V.FreecamConn = nil
V.AutoRejoin = false
V.AutoRejoinConn = nil
V.LagSwitch = false
V.LagSwitchConn = nil
V.LagSwitchOrigin = nil
V.Desync = false
V.DesyncConn = nil
V.DesyncOrigin = nil

initStep = "connexions base"
local parentTarget = (gethui and gethui()) or game:GetService("CoreGui")

local Debris = game:GetService("Debris")

function addConnection(conn)
    table.insert(C.All, conn)
end

V.AntiBlockConn = RunService.Heartbeat:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local parts = workspace:GetPartBoundsInBox(hrp.CFrame, Vector3.new(8, 8, 8))
                for _, part in ipairs(parts) do
                    local name = part.Name:lower()
                    local isBarrier = (name:match("block") or name:match("trap") or name:match("barrier") or name:match("anticheat")) and part.Size.Magnitude < 6
                    if isBarrier then
                        if part.Parent ~= char and not part:IsDescendantOf(char) then
                            part:Destroy()
                        end
                    end
                end
            end
        end
    end)
end)
addConnection(V.AntiBlockConn)

currentFPS = 60
frames = 0
lastTime = os.clock()
V.FPSConn = RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local currentTime = os.clock()
    if currentTime - lastTime >= 0.5 then
        currentFPS = math.floor(frames / (currentTime - lastTime))
        frames = 0
        lastTime = currentTime
    end
    if Camera.FieldOfView ~= V.FOV then
        Camera.FieldOfView = V.FOV
    end
end)
addConnection(V.FPSConn)

NotificationContainer = Instance.new("Frame")
NotificationContainer.Name ="NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -20)
NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

NotifList = Instance.new("UIListLayout")
NotifList.Padding = UDim.new(0, 10)
NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
NotifList.Parent = NotificationContainer

lastNotifyKey = nil
lastNotifyTime = 0

function notify(title, text, color)
    if not V.Notif then return end
    local key = title .. "|" .. text
    if key == lastNotifyKey and os.clock() - lastNotifyTime < 1.5 then
        return
    end
    lastNotifyKey = key
    lastNotifyTime = os.clock()
    color = color or Color3.fromRGB(180, 180, 195)

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Thickness = 1
    NotifStroke.Color = color
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotifFrame

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -20, 0, 20)
    TitleLbl.Position = UDim2.new(0, 10, 0, 8)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = color
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 14
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.TextTransparency = 1
    TitleLbl.Parent = NotifFrame

    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -20, 0, 20)
    TextLbl.Position = UDim2.new(0, 10, 0, 30)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(195, 195, 208)
    TextLbl.Font = Enum.Font.GothamMedium
    TextLbl.TextSize = 12
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.TextTransparency = 1
    TextLbl.Parent = NotifFrame

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(NotifFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(NotifStroke, tweenInfo, {Transparency = 0}):Play()
    TweenService:Create(TitleLbl, tweenInfo, {TextTransparency = 0}):Play()
    TweenService:Create(TextLbl, tweenInfo, {TextTransparency = 0}):Play()

    task.delay(3, function()
        local tweenOut = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        TweenService:Create(NotifFrame, tweenOut, {BackgroundTransparency = 1}):Play()
        TweenService:Create(NotifStroke, tweenOut, {Transparency = 1}):Play()
        TweenService:Create(TitleLbl, tweenOut, {TextTransparency = 1}):Play()
        TweenService:Create(TextLbl, tweenOut, {TextTransparency = 1}):Play()
        task.wait(0.6)
        NotifFrame:Destroy()
    end)
end

initStep = "definitions fonctions"
function startFly()
    if V.DesyncFly then SetDesyncToggle(false) end
    V.Fly = true
    pcall(function()
        local char = getCharacter()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        if humanoid then humanoid.PlatformStand = true end

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name ="NebulaFlyGyro"
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.CFrame = Camera.CFrame
        bodyGyro.Parent = root

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name ="NebulaFlyVel"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root

        local flyConn = RunService.RenderStepped:Connect(function()
            if not V.Fly or not root or not root.Parent then
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                if humanoid then humanoid.PlatformStand = false end
                return
            end

            local camCF = Camera.CFrame
            local moveVector = Vector3.new(0, 0, 0)
            local speed = V.FlySpeed or 150

            if UserInputService:IsKeyDown(Enum.KeyCode.Z) or UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end

            if moveVector.Magnitude > 0 then
                bodyVelocity.Velocity = moveVector.Unit * speed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            bodyGyro.CFrame = camCF
        end)
        addConnection(flyConn)
    end)
end

function stopFly()
    V.Fly = false
    pcall(function()
        local char = getCharacter()
        local root = char:FindFirstChild("HumanoidRootPart")
        for _, obj in pairs(root:GetChildren()) do
            if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then obj:Destroy() end
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        if not V.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)
end

function startNoclip()
    V.Noclip = true
    local noclipConn = RunService.Stepped:Connect(function()
        if not V.Noclip then noclipConn:Disconnect() return end
        local char = getCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    addConnection(noclipConn)
end

function stopNoclip()
    V.Noclip = false
    pcall(function()
        local char = getCharacter()
        if char and not V.Fly then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end)
end

invisSound = Instance.new("Sound")
invisSound.SoundId ="rbxassetid://942127495"
invisSound.Volume = 0.5
invisSound.Parent = game:GetService("Workspace")

function toggleInvisibility(enabled)
    V.Invis = enabled
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        invisSound:Play()

        if V.Invis then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            hum.BreakJointsOnDeath = false
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            
            local savedPosition = hrp.CFrame
            local INVISIBILITY_POSITION = Vector3.new(-25.95, 84, 3537.55)
            
            char:MoveTo(INVISIBILITY_POSITION)
            task.wait(0.15)
            
            local seat = Instance.new("Seat")
            seat.Name ="NebulaInvisChair"
            seat.Anchored = false
            seat.CanCollide = false
            seat.Transparency = 1
            seat.Position = INVISIBILITY_POSITION
            seat.Parent = workspace
            
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = seat
            weld.Part1 = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
            weld.Parent = seat
            
            task.wait()
            seat.CFrame = savedPosition
            
            if V.InvisConn then V.InvisConn:Disconnect() end
            V.InvisConn = RunService.RenderStepped:Connect(function()
                local c = LocalPlayer.Character
                if c and c:FindFirstChildOfClass("Humanoid") then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    h.MaxHealth = 100
                    if h.Health < 100 then
                        h.Health = 100
                    end
                    local state = h:GetState()
                    if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Dead then
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    for _, p in pairs(c:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~="HumanoidRootPart"then
                            if p.Transparency ~= 1 then p.Transparency = 1 end
                        elseif p:IsA("Decal") then
                            if p.Transparency ~= 1 then p.Transparency = 1 end
                        end
                    end
                end
            end)
            addConnection(V.InvisConn)
            
            notify("Invisibility","Invisible ON", Color3.fromRGB(80, 200, 120))
        else
            if V.InvisConn then V.InvisConn:Disconnect() V.InvisConn = nil end
            
            local invisChair = workspace:FindFirstChild("NebulaInvisChair")
            if invisChair then invisChair:Destroy() end
            
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~="HumanoidRootPart"then
                    p.Transparency = 0
                elseif p:IsA("Decal") then
                    p.Transparency = 0
                end
            end
            
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            
            notify("Invisibility","Invisible OFF", Color3.fromRGB(255, 90, 90))
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if V.AntiRagdoll then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            hum.PlatformStand = false
        end
    end
end)

function startDesyncFly()
    if V.Fly then SetFlyToggle(false) end
    V.DesyncFly = true
    pcall(function()
        local char = getCharacter()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        humanoid.PlatformStand = true
        hrp.Anchored = true
        local lastPosition = hrp.Position

        local desyncConn = RunService.Heartbeat:Connect(function(dt)
            if not V.DesyncFly then desyncConn:Disconnect() return end
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

            if moveDirection.Magnitude > 0 then
                lastPosition = lastPosition + (moveDirection.Unit * V.DesyncFlySpeed * dt)
                hrp.CFrame = CFrame.new(lastPosition, lastPosition + cam.CFrame.LookVector)
            end
        end)
        addConnection(desyncConn)
    end)
end

function stopDesyncFly()
    V.DesyncFly = false
    pcall(function()
        local hrp = getRoot()
        local humanoid = getHumanoid()
        hrp.Anchored = false
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
end

function enableNoAnim()
    V.NoAnim = true
    local char = getCharacter()

    local animate = char:FindFirstChild("Animate")
    if animate then
        V.OrigAnim = animate:Clone()
        animate:Destroy()
    end

    V.NoAnimConn = RunService.RenderStepped:Connect(function()
        if not V.NoAnim then return end
        local char = getCharacter()
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end
    end)
    addConnection(V.NoAnimConn)
    notify("Me","No Animations ON", Color3.fromRGB(80, 200, 120))
end

function disableNoAnim()
    V.NoAnim = false
    if V.NoAnimConn then V.NoAnimConn:Disconnect() V.NoAnimConn = nil end

    local char = LocalPlayer.Character
    if char then
        local animate = char:FindFirstChild("Animate")
        if animate then animate:Destroy() end
        if V.OrigAnim then
            local newAnimate = V.OrigAnim:Clone()
            newAnimate.Parent = char
            V.OrigAnim = nil
        end
    end
    notify("Me","No Animations OFF", Color3.fromRGB(255, 90, 90))
end

function startSpectate(player)
    if V.Spectate then stopSpectate() end
    V.Spectate = true
    V.SelPlayer = player
    
    if V.SpecConn then V.SpecConn:Disconnect() end
    V.SpecConn = RunService.RenderStepped:Connect(function()
        if not V.Spectate or not V.SelPlayer or not V.SelPlayer.Parent then
            stopSpectate()
            return
        end
        if V.SelPlayer.Character then
            local hum = V.SelPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and Camera.CameraSubject ~= hum then
                Camera.CameraSubject = hum
            end
        end
    end)
    addConnection(V.SpecConn)
    notify("Spectate","Spectating".. player.Name, Color3.fromRGB(80, 200, 120))
end

function stopSpectate()
    V.Spectate = false
    V.SelPlayer = nil
    if V.SpecConn then V.SpecConn:Disconnect() V.SpecConn = nil end
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
        end
    end)
    notify("Spectate","Spectate OFF", Color3.fromRGB(255, 90, 90))
end

function startFling(player)
    if V.Flinging then return end
    V.Flinging = true
    V.FlingTarget = player
    local char = getCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if hrp and hum then
        hum.PlatformStand = true
        local rotAngle = 0

        V.FlingConn = RunService.Heartbeat:Connect(function()
            if not V.Flinging or not V.FlingTarget or not V.FlingTarget.Character then
                stopFling()
                return
            end
            local tHrp = V.FlingTarget.Character:FindFirstChild("HumanoidRootPart") or V.FlingTarget.Character:FindFirstChild("Torso") or V.FlingTarget.Character:FindFirstChild("UpperTorso")
            if tHrp and hrp then
                pcall(function()
                    rotAngle = rotAngle + 100
                    
                    local offset = Vector3.new(math.sin(rotAngle) * 1.5, (rotAngle % 3) - 1, math.cos(rotAngle) * 1.5)
                    hrp.CFrame = tHrp.CFrame * CFrame.new(offset) * CFrame.Angles(math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)), math.rad(math.random(-180, 180)))
                    hrp.AssemblyAngularVelocity = Vector3.new(500000, 500000, 500000)
                    hrp.AssemblyLinearVelocity = Vector3.new(500000, 500000, 500000)

                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end
        end)
        addConnection(V.FlingConn)
        notify("Troll","Fling 100% Max Power ->".. player.Name, Color3.fromRGB(255, 80, 80))
    end
end

function stopFling()
    V.Flinging = false
    V.FlingTarget = nil
    if V.FlingConn then V.FlingConn:Disconnect() V.FlingConn = nil end
    pcall(function()
        local char = getCharacter()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if hrp then
            hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~="HumanoidRootPart"then
                    part.CanCollide = true
                end
            end
        end
    end)
    notify("Troll","Fling arrêté.", Color3.fromRGB(255, 80, 80))
end

movementConn = RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if humanoid and (humanoid.SeatPart or humanoid.Sit) then return end 
            if humanoid and hrp then
                
                if V.Freecam then
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                    hrp.Velocity = Vector3.zero
                    return
                end

                humanoid.UseJumpPower = true
                humanoid.JumpPower = V.JumpEnabled and V.Jump or 50

                local currentSpeed = V.SpeedEnabled and V.Speed or 16

                if V.CFrameSpeed and humanoid.MoveDirection.Magnitude > 0 then
                    humanoid.WalkSpeed = 0
                    local moveVec = humanoid.MoveDirection
                    hrp.CFrame = hrp.CFrame + (moveVec * currentSpeed * dt)
                else
                    humanoid.WalkSpeed = currentSpeed
                    if humanoid.MoveDirection.Magnitude > 0 then
                        local yVel = hrp.Velocity.Y
                        hrp.Velocity = Vector3.new(humanoid.MoveDirection.X * currentSpeed, yVel, humanoid.MoveDirection.Z * currentSpeed)
                    end
                end

                if V.WallClimb and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {char}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, rayParams)
                    if result then
                        hrp.CFrame = hrp.CFrame * CFrame.new(0, currentSpeed * dt, 0)
                    end
                end
            end
        end
    end)
end)
addConnection(movementConn)

function toggleAntiRagdoll(enabled)
    V.AntiRagdoll = enabled
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if enabled then
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end

            V.AntiRagdollConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid and (humanoid.SeatPart or humanoid.Sit) then return end
                        if hrp and humanoid then
                            if hrp.AssemblyAngularVelocity.Magnitude > 30 then
                                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            end
                            if hrp.AssemblyLinearVelocity.Magnitude > 500 then
                                hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                            end
                            if humanoid.PlatformStand then
                                humanoid.PlatformStand = false
                                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                            end
                            local state = humanoid:GetState()
                            if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding then
                                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                            end
                        end
                    end
                end)
            end)
            addConnection(V.AntiRagdollConn)
            notify("Me","Anti-Ragdoll ON (Ultra)", Color3.fromRGB(80, 200, 120))
        else
            if V.AntiRagdollConn then V.AntiRagdollConn:Disconnect() V.AntiRagdollConn = nil end
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            end
            notify("Me","Anti-Ragdoll OFF", Color3.fromRGB(255, 90, 90))
        end
    end)
end

function applyInstant(prompt)
    if V.InstInteract and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

function toggleInstantInteract(enabled)
    V.InstInteract = enabled
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then applyInstant(obj) end
        end
        V.Inst1 = workspace.DescendantAdded:Connect(function(obj) applyInstant(obj) end)
        V.Inst2 = ProximityPromptService.PromptShown:Connect(function(prompt) applyInstant(prompt) end)
        addConnection(V.Inst1)
        addConnection(V.Inst2)
        notify("Me","Instant Interact ON", Color3.fromRGB(80, 200, 120))
    else
        if V.Inst1 then V.Inst1:Disconnect() V.Inst1 = nil end
        if V.Inst2 then V.Inst2:Disconnect() V.Inst2 = nil end
        notify("Me","Instant Interact OFF (Rejoin to restore)", Color3.fromRGB(255, 90, 90))
    end
end

function applyInfiniteRange(prompt)
    if V.InfRange and prompt:IsA("ProximityPrompt") then
        if not Cache.Distances[prompt] then
            Cache.Distances[prompt] = {
                MaxActivationDistance = prompt.MaxActivationDistance,
                RequiresLineOfSight = prompt.RequiresLineOfSight
            }
        end
        prompt.MaxActivationDistance = 99999
        prompt.RequiresLineOfSight = false
    end
end

function toggleInfiniteRange(enabled)
    V.InfRange = enabled
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then applyInfiniteRange(obj) end
        end
        V.Inf1 = workspace.DescendantAdded:Connect(function(obj) applyInfiniteRange(obj) end)
        V.Inf2 = ProximityPromptService.PromptShown:Connect(function(prompt) applyInfiniteRange(prompt) end)
        V.InfRangeConn = RunService.RenderStepped:Connect(function()
            for prompt, _ in pairs(Cache.Distances) do
                if prompt and prompt.Parent then
                    prompt.MaxActivationDistance = 99999
                    prompt.RequiresLineOfSight = false
                else
                    Cache.Distances[prompt] = nil
                end
            end
        end)
        addConnection(V.Inf1)
        addConnection(V.Inf2)
        addConnection(V.InfRangeConn)
        notify("Me","Infinite Interact Range ON", Color3.fromRGB(80, 200, 120))
    else
        if V.Inf1 then V.Inf1:Disconnect() V.Inf1 = nil end
        if V.Inf2 then V.Inf2:Disconnect() V.Inf2 = nil end
        if V.InfRangeConn then V.InfRangeConn:Disconnect() V.InfRangeConn = nil end
        for prompt, data in pairs(Cache.Distances) do
            if prompt and prompt.Parent then
                prompt.MaxActivationDistance = data.MaxActivationDistance
                prompt.RequiresLineOfSight = data.RequiresLineOfSight
            end
        end
        Cache.Distances = {}
        notify("Me","Infinite Interact Range OFF", Color3.fromRGB(255, 90, 90))
    end
end

function applyFPSBoost(obj)
    if obj:IsA("BasePart") then
        if not Cache.FPSBoost[obj] then
            Cache.FPSBoost[obj] = {Material = obj.Material, Reflectance = obj.Reflectance}
        end
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        if not Cache.FPSBoost[obj] then
            Cache.FPSBoost[obj] = {Enabled = obj.Enabled}
        end
        obj.Enabled = false
    elseif obj:IsA("PostEffect") then
        if not Cache.FPSBoost[obj] then
            Cache.FPSBoost[obj] = {Enabled = obj.Enabled}
        end
        obj.Enabled = false
    end
end

function toggleFPSBooster(enabled)
    V.FPSBoost = enabled
    if enabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 0
        settings().Rendering.QualityLevel = 1

        for _, obj in pairs(workspace:GetDescendants()) do applyFPSBoost(obj) end
        for _, obj in pairs(Lighting:GetChildren()) do applyFPSBoost(obj) end

        V.FPSBoost1 = workspace.DescendantAdded:Connect(function(obj) applyFPSBoost(obj) end)
        V.FPSBoost2 = Lighting.ChildAdded:Connect(function(obj) applyFPSBoost(obj) end)
        notify("Server","FPS Booster ON", Color3.fromRGB(80, 200, 120))
    else
        if V.FPSBoost1 then V.FPSBoost1:Disconnect() V.FPSBoost1 = nil end
        if V.FPSBoost2 then V.FPSBoost2:Disconnect() V.FPSBoost2 = nil end

        for obj, data in pairs(Cache.FPSBoost) do
            if obj and obj.Parent then
                if obj:IsA("BasePart") then
                    obj.Material = data.Material
                    obj.Reflectance = data.Reflectance
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = data.Transparency
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("PostEffect") then
                    obj.Enabled = data.Enabled
                end
            end
        end
        Cache.FPSBoost = {}

        settings().Rendering.QualityLevel = Enum.RenderSettings.DefaultQualityLevel
        Lighting.GlobalShadows = true
        notify("Server","FPS Booster OFF", Color3.fromRGB(255, 90, 90))
    end
end

function toggleFullbright(enabled)
    V.Fullbright = enabled
    if enabled then
        Cache.Lighting = {
            GlobalShadows = Lighting.GlobalShadows,
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            ClockTime = Lighting.ClockTime,
            ExposureCompensation = Lighting.ExposureCompensation
        }
        Lighting.GlobalShadows = false
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 1e6
        Lighting.FogStart = 0
        Lighting.ClockTime = 14
        Lighting.ExposureCompensation = 0

        Cache.PostEffects = {}
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                Cache.PostEffects[v] = v.Enabled
                v.Enabled = false
            end
        end
        notify("Server","Fullbright ON", Color3.fromRGB(80, 200, 120))
    else
        if Cache.Lighting then
            Lighting.GlobalShadows = Cache.Lighting.GlobalShadows
            Lighting.Brightness = Cache.Lighting.Brightness
            Lighting.Ambient = Cache.Lighting.Ambient
            Lighting.OutdoorAmbient = Cache.Lighting.OutdoorAmbient
            Lighting.FogEnd = Cache.Lighting.FogEnd
            Lighting.FogStart = Cache.Lighting.FogStart
            Lighting.ClockTime = Cache.Lighting.ClockTime
            Lighting.ExposureCompensation = Cache.Lighting.ExposureCompensation
        end

        if Cache.PostEffects then
            for effect, state in pairs(Cache.PostEffects) do
                if effect and effect.Parent then
                    effect.Enabled = state
                end
            end
        end
        Cache.Lighting = nil
        Cache.PostEffects = nil
        notify("Server","Fullbright OFF", Color3.fromRGB(255, 90, 90))
    end
end

ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "NebulaESP"
ESPGui.ResetOnSpawn = false
ESPGui.DisplayOrder = 100
ESPGui.IgnoreGuiInset = true
ESPGui.Enabled = false
ESPGui.Parent = parentTarget

function clearESP()
    for player, obj in pairs(V.ESPObjects) do
        if obj.conn then obj.conn:Disconnect() end
        if obj.box then obj.box:Destroy() end
        if obj.nameLabel then obj.nameLabel:Destroy() end
        if obj.distLabel then obj.distLabel:Destroy() end
        if obj.highlight then obj.highlight:Destroy() end
        if obj.healthBg then obj.healthBg:Destroy() end
        if obj.weaponLabel then obj.weaponLabel:Destroy() end
        if obj.skeletonFolder then obj.skeletonFolder:Destroy() end
        if obj.tracerLine then obj.tracerLine:Destroy() end
    end
    V.ESPObjects = {}
end

function createESPForPlayer(player)
    if V.ESPObjects[player] then return end
    if player == LocalPlayer and not V.ESPSelf then return end

    local box = Instance.new("Frame")
    box.Visible = false
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = ESPGui

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Parent = box

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Visible = false
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamMedium
    nameLabel.TextSize = 13
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextColor3 = V.ESPColor
    nameLabel.Parent = ESPGui

    local distLabel = Instance.new("TextLabel")
    distLabel.Visible = false
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.GothamMedium
    distLabel.TextSize = 12
    distLabel.TextStrokeTransparency = 0
    distLabel.TextColor3 = V.ESPColor
    distLabel.Parent = ESPGui

    local highlight = Instance.new("Highlight")
    highlight.FillColor = V.ESPColor
    highlight.OutlineColor = V.ESPColor
    highlight.FillTransparency = 0.5
    highlight.Enabled = false
    highlight.Parent = nil

    local healthBg = Instance.new("Frame")
    healthBg.Visible = false
    healthBg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = ESPGui

    local healthBar = Instance.new("Frame")
    healthBar.BorderSizePixel = 0
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    healthBar.Parent = healthBg

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Visible = false
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Font = Enum.Font.GothamMedium
    weaponLabel.TextSize = 11
    weaponLabel.TextStrokeTransparency = 0
    weaponLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    weaponLabel.Parent = ESPGui

    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name ="SkeletonLines_".. player.Name
    skeletonFolder.Parent = ESPGui

    local tracerLine = Instance.new("Frame")
    tracerLine.Visible = false
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = V.ESPColor
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.Parent = ESPGui

    V.ESPObjects[player] = {
        box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight,
        healthBg = healthBg, healthBar = healthBar, weaponLabel = weaponLabel, skeletonFolder = skeletonFolder, tracerLine = tracerLine
    }

    local conn = RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not char or not V.ESP then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            tracerLine.Visible = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local localChar = LocalPlayer.Character
        if not hrp or not head or not hum or not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            tracerLine.Visible = false
            return
        end

        local localHrp = localChar.HumanoidRootPart
        local dist = (localHrp.Position - hrp.Position).Magnitude

        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            tracerLine.Visible = false
            return
        end

        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        local rawHeight = math.abs(headPos.Y - legPos.Y)
        
        local height = math.clamp(rawHeight, 20, 600)
        local width = height / 2.5

        local boxVisible = V.ESPBox or V.ESPFilled
        if boxVisible then
            box.Visible = true
            box.Size = UDim2.new(0, width, 0, height)
            box.Position = UDim2.new(0, screenPos.X - width/2, 0, screenPos.Y - height/2)
            boxStroke.Color = V.ESPColor
            boxStroke.Thickness = V.ESPBox and 1.5 or 0
            if V.ESPFilled then
                box.BackgroundColor3 = V.ESPColor
                box.BackgroundTransparency = 0.75
            else
                box.BackgroundTransparency = 1
            end
        else
            box.Visible = false
        end

        if V.ESPGlow then
            highlight.Parent = char
            highlight.FillColor = V.ESPColor
            highlight.OutlineColor = V.ESPColor
            highlight.Enabled = true
        else
            highlight.Parent = nil
        end

        if V.ESPName then
            nameLabel.Visible = true
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = V.ESPColor
            nameLabel.Size = UDim2.new(0, 200, 0, 20)
            nameLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - height/2 - 18)
        else
            nameLabel.Visible = false
        end

        if V.ESPDist then
            distLabel.Visible = true
            distLabel.Text = math.floor(dist) .."m"
            distLabel.TextColor3 = V.ESPColor
            distLabel.Size = UDim2.new(0, 200, 0, 20)
            distLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y + height/2 + 2)
        else
            distLabel.Visible = false
        end

        if V.ESPHealth then
            healthBg.Visible = true
            local barWidth = 4
            healthBg.Size = UDim2.new(0, barWidth, 0, height)
            healthBg.Position = UDim2.new(0, screenPos.X - width/2 - 7, 0, screenPos.Y - height/2)
            
            local healthPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            healthBar.Size = UDim2.new(1, 0, healthPct, 0)
            healthBar.Position = UDim2.new(0, 0, 1 - healthPct, 0)
            healthBar.BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - healthPct)), math.floor(255 * healthPct), 50)
        else
            healthBg.Visible = false
        end

        if V.ESPWeapon then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                weaponLabel.Visible = true
                weaponLabel.Text ="[".. tool.Name .."]"
                weaponLabel.Size = UDim2.new(0, 200, 0, 16)
                weaponLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y + height/2 + (V.ESPDist and 22 or 2))
            else
                weaponLabel.Visible = false
            end
        else
            weaponLabel.Visible = false
        end

        if V.ESPSkeleton then
            local isR15 = (hum.RigType == Enum.HumanoidRigType.R15)
            local joints = isR15 and {
                {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"},
                {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
                {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"}
            } or {
                {"Head","Torso"},
                {"Torso","Left Arm"}, {"Torso","Right Arm"},
                {"Torso","Left Leg"}, {"Torso","Right Leg"}
            }

            local existingLines = skeletonFolder:GetChildren()
            local lineIdx = 0
            
            for _, pair in ipairs(joints) do
                local p1Part = char:FindFirstChild(pair[1])
                local p2Part = char:FindFirstChild(pair[2])
                if p1Part and p2Part then
                    local p1Pos = Camera:WorldToViewportPoint(p1Part.Position)
                    local p2Pos = Camera:WorldToViewportPoint(p2Part.Position)
                    if p1Pos.Z > 0 and p2Pos.Z > 0 then
                        lineIdx = lineIdx + 1
                        local line = existingLines[lineIdx]
                        if not line then
                            line = Instance.new("Frame")
                            line.BorderSizePixel = 0
                            line.AnchorPoint = Vector2.new(0.5, 0.5)
                            line.Parent = skeletonFolder
                        end
                        local distance = (Vector2.new(p2Pos.X, p2Pos.Y) - Vector2.new(p1Pos.X, p1Pos.Y)).Magnitude
                        local angle = math.atan2(p2Pos.Y - p1Pos.Y, p2Pos.X - p1Pos.X)
                        line.BackgroundColor3 = V.ESPColor
                        line.Size = UDim2.new(0, distance, 0, 1.5)
                        line.Position = UDim2.new(0, (p1Pos.X + p2Pos.X) / 2, 0, (p1Pos.Y + p2Pos.Y) / 2)
                        line.Rotation = math.deg(angle)
                        line.Visible = true
                    end
                end
            end
            
            for i = lineIdx + 1, #existingLines do
                existingLines[i].Visible = false
            end
        else
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
        end

        if V.ESPTracer then
            local vp = Camera.ViewportSize
            local originPos = Vector2.new(vp.X / 2, vp.Y)
            if V.ESPTracerOrigin =="Center"then
                originPos = Vector2.new(vp.X / 2, vp.Y / 2)
            elseif V.ESPTracerOrigin =="Mouse"then
                originPos = UserInputService:GetMouseLocation()
            end
            local targetPos = Vector2.new(screenPos.X, screenPos.Y)
            local distance = (targetPos - originPos).Magnitude
            local angle = math.atan2(targetPos.Y - originPos.Y, targetPos.X - originPos.X)
            tracerLine.Visible = true
            tracerLine.Size = UDim2.new(0, distance, 0, 1.5)
            tracerLine.Position = UDim2.new(0, (originPos.X + targetPos.X) / 2, 0, (originPos.Y + targetPos.Y) / 2)
            tracerLine.Rotation = math.deg(angle)
            tracerLine.BackgroundColor3 = V.ESPColor
        else
            tracerLine.Visible = false
        end
    end)
    V.ESPObjects[player].conn = conn
end

function refreshESP()
    clearESP()
    if not V.ESP then return end
    for _, player in pairs(Players:GetPlayers()) do createESPForPlayer(player) end
end

task.spawn(function()
    while true do
        task.wait(1)
        if V.ESP then
            for _, player in pairs(Players:GetPlayers()) do
                if not V.ESPObjects[player] then createESPForPlayer(player) end
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    if _G.refreshPlayerList then _G.refreshPlayerList() end
    if V.ESP then
        task.wait(0.5)
        createESPForPlayer(p)
    end
end)
Players.PlayerRemoving:Connect(function(p)
    if _G.refreshPlayerList then _G.refreshPlayerList() end
    if V.SelPlayer == p then
        stopSpectate()
    end
    if V.ESPObjects[p] then
        if V.ESPObjects[p].conn then V.ESPObjects[p].conn:Disconnect() end
        if V.ESPObjects[p].box then V.ESPObjects[p].box:Destroy() end
        if V.ESPObjects[p].nameLabel then V.ESPObjects[p].nameLabel:Destroy() end
        if V.ESPObjects[p].distLabel then V.ESPObjects[p].distLabel:Destroy() end
        if V.ESPObjects[p].highlight then V.ESPObjects[p].highlight:Destroy() end
        if V.ESPObjects[p].healthBg then V.ESPObjects[p].healthBg:Destroy() end
        if V.ESPObjects[p].weaponLabel then V.ESPObjects[p].weaponLabel:Destroy() end
        if V.ESPObjects[p].skeletonFolder then V.ESPObjects[p].skeletonFolder:Destroy() end
        if V.ESPObjects[p].tracerLine then V.ESPObjects[p].tracerLine:Destroy() end
        V.ESPObjects[p] = nil
    end
end)

function toggleClickTP(enabled)
    V.ClickTP = enabled
    if enabled then
        if V.ClickTPTool then V.ClickTPTool:Destroy() end
        V.ClickTPTool = Instance.new("Tool")
        V.ClickTPTool.Name ="Click TP Épée"
        V.ClickTPTool.RequiresHandle = true
        local handle = Instance.new("Part")
        handle.Name ="Handle"
        handle.Size = Vector3.new(1, 1, 3)
        handle.CanCollide = false
        handle.Transparency = 1
        handle.Parent = V.ClickTPTool
        
        V.ClickTPTool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local char = getCharacter()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and mouse.Hit then
                hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        V.ClickTPTool.Parent = LocalPlayer.Backpack
        notify("Fun","Épée Click TP ajoutée !", Color3.fromRGB(80, 200, 120))
    else
        if V.ClickTPTool then
            if V.ClickTPTool.Parent == LocalPlayer.Character then
                V.ClickTPTool:Destroy()
            elseif V.ClickTPTool.Parent == LocalPlayer.Backpack then
                V.ClickTPTool:Destroy()
            end
            V.ClickTPTool = nil
        end
        notify("Fun","Épée Click TP retirée.", Color3.fromRGB(255, 90, 90))
    end
end
initStep = "cablage Movement"
createLabel("SPEED & JUMP", MovementContent)
_, _, ToggleSpeed = createToggle("Enable Walk Speed", false, function(enabled)
    V.SpeedEnabled = enabled
    notify("Movement","Walk Speed".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"SpeedEnabled")
createSlider("Walk Speed", 16, 300, 16, function(val) V.Speed = val end, MovementContent,"Speed")

local function createValueButton(parent, title, valueText, onChange)
    local card = createCard(parent, 0, 42)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.55, -10, 0, 16)
    titleLabel.Position = UDim2.new(0, 12, 0, 13)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.text
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -10, 0, 16)
    valueLabel.Position = UDim2.new(0.55, 2, 0, 13)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = valueText
    valueLabel.TextColor3 = theme.accent2
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 10
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = card

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 64, 0, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = theme.cardHover
    btn.BorderSizePixel = 0
    btn.Text = "Changer"
    btn.TextColor3 = theme.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = card
    makeCorner(btn, 7)
    makeStroke(btn, theme.border, 1)
    btn.MouseButton1Click:Connect(function()
        playClick()
        if onChange then
            local newValue = onChange()
            if newValue then
                valueLabel.Text = newValue
            end
        end
    end)

    return card, btn, valueLabel
end

speedMethodsList = {"Humanoid","CFrame (Bypass)","Velocity","VectorForce"}
currentSpeedMethodIdx = 1
speedMethodFrame, speedMethodBtnObj, speedMethodValue = createValueButton(MovementContent, "Speed Method", V.SpeedMethod, function()
    currentSpeedMethodIdx = (currentSpeedMethodIdx % #speedMethodsList) + 1
    V.SpeedMethod = speedMethodsList[currentSpeedMethodIdx]
    notify("Movement","Méthode de vitesse : ".. V.SpeedMethod, Color3.fromRGB(80, 200, 120))
    return V.SpeedMethod
end)

createToggle("Enable Jump Power", false, function(enabled)
    V.JumpEnabled = enabled
    notify("Movement","Jump Power".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"JumpEnabled")
createSlider("Jump Power", 50, 300, 50, function(val) V.Jump = val end, MovementContent,"Jump")

createToggle("Wall Climb (Spider)", false, function(enabled)
    V.WallClimb = enabled
    notify("Movement","Wall Climb".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"WallClimb")
createToggle("Auto-Bhop (Bunny Hop)", false, function(enabled)
    V.AutoBhop = enabled
    if V.BhopConn then V.BhopConn:Disconnect() V.BhopConn = nil end
    if enabled then
        V.BhopConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local state = hum:GetState()
                    local moving = hum.MoveDirection.Magnitude > 0
                    if moving and (state == Enum.HumanoidStateType.Running or (hum.FloorMaterial ~= Enum.Material.Air and state == Enum.HumanoidStateType.Landed)) then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end)
        addConnection(V.BhopConn)
    end
    notify("Movement","Auto-Bhop".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"AutoBhop")

local function cleanAndResetAllBodies()
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, desc in pairs(player.Character:GetDescendants()) do
                    if desc:IsA("BasePart") then
                        if desc.Name == "HumanoidRootPart" then
                            if not V.HitboxExtender then
                                desc.Size = Vector3.new(2, 2, 1)
                                desc.Transparency = 1
                                desc.Material = Enum.Material.Plastic
                            end
                        elseif desc.Name == "Head" then
                            desc.Size = Vector3.new(2, 1, 1)
                            desc.Transparency = 0
                            desc.Material = Enum.Material.Plastic
                            local mesh = desc:FindFirstChildOfClass("SpecialMesh")
                            if mesh then
                                mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
                            end
                        else
                            desc.Transparency = 0
                            desc.Material = Enum.Material.Plastic
                        end
                    elseif desc:IsA("Highlight") and desc.Name ~= "Nebula_Highlight" then
                        desc:Destroy()
                    end
                end
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    local hs = hum:FindFirstChild("HeadScale")
                    if hs then hs.Value = 1 end
                    local bws = hum:FindFirstChild("BodyWidthScale")
                    if bws then bws.Value = 1 end
                    local bhs = hum:FindFirstChild("BodyHeightScale")
                    if bhs then bhs.Value = 1 end
                    local bds = hum:FindFirstChild("BodyDepthScale")
                    if bds then bds.Value = 1 end
                end
            end
        end
    end)
end

cleanAndResetAllBodies()

if V.HitboxConn then V.HitboxConn:Disconnect() end
V.HitboxConn = RunService.RenderStepped:Connect(function()
    if V.HitboxExtender then
        pcall(function()
            local size = V.HitboxSize or 15
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(size, size, size)
                        hrp.Transparency = 0.65
                        hrp.Color = Color3.fromRGB(0, 145, 255) -- Carré bleu pur uniquement sur la racine
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
                    end
                    local head = player.Character:FindFirstChild("Head")
                    if head and head.Size ~= Vector3.new(2, 1, 1) then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.Material = Enum.Material.Plastic
                    end
                end
            end
        end)
    else
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and (hrp.Size ~= Vector3.new(2, 2, 1) or hrp.Transparency ~= 1) then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.Material = Enum.Material.Plastic
                        hrp.CanCollide = false
                    end
                    local head = player.Character:FindFirstChild("Head")
                    if head and head.Size ~= Vector3.new(2, 1, 1) then
                        head.Size = Vector3.new(2, 1, 1)
                        head.Transparency = 0
                        head.Material = Enum.Material.Plastic
                    end
                end
            end
        end)
    end
end)

createLabel("GRAVITY", MovementContent)
createSlider("Gravity", 0, 200, 196, function(val) workspace.Gravity = val end, MovementContent)

createLabel("FLIGHT", MovementContent)
_, SetFlyToggle, ToggleFly = createToggle("Fly (Normal)", false, function(enabled)
    if enabled then startFly() else stopFly() end
    notify("Movement","Fly".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"Fly")
createSlider("Fly Speed (Vitesse 50-2000)", 50, 2000, 300, function(val) V.FlySpeed = val end, MovementContent,"FlySpeed")
_, SetDesyncToggle, ToggleDesync = createToggle("Fly (Desynch)", false, function(enabled)
    if enabled then startDesyncFly() else stopDesyncFly() end
    notify("Movement","Desync Fly".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"DesyncFly")
createSlider("Fly Speed (Desync 50-2000)", 50, 2000, 300, function(val) V.DesyncFlySpeed = val end, MovementContent,"DesyncFlySpeed")

initStep = "cablage Me"
createLabel("BODY SCALE & HITBOX", MeContent)
createToggle("Hitbox Extender", false, function(enabled)
    V.HitboxExtender = enabled
    notify("Combat","Hitbox Extender".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"HitboxExtender")
createSlider("Hitbox Size (Taille)", 1, 50, 25, function(val) V.HitboxSize = val end, MeContent,"HitboxSize")

function updateBodyScale()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local scaleVal = V.BodyScale and (V.BodyScale / 10) or 1

        if char.ScaleTo then
            pcall(function() char:ScaleTo(scaleVal) end)
        end

        local hs = hum:FindFirstChild("BodyHeightScale") or Instance.new("NumberValue", hum)
        hs.Name ="BodyHeightScale"
        hs.Value = scaleVal

        local ws = hum:FindFirstChild("BodyWidthScale") or Instance.new("NumberValue", hum)
        ws.Name ="BodyWidthScale"
        ws.Value = scaleVal

        local ds = hum:FindFirstChild("BodyDepthScale") or Instance.new("NumberValue", hum)
        ds.Name ="BodyDepthScale"
        ds.Value = scaleVal

        local headScale = hum:FindFirstChild("HeadScale") or Instance.new("NumberValue", hum)
        headScale.Name ="HeadScale"
        headScale.Value = scaleVal

        hum.HipHeight = 2 * scaleVal

        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~="HumanoidRootPart"then
                if not part:FindFirstChild("OriginalSize") then
                    local origSize = Instance.new("Vector3Value", part)
                    origSize.Name ="OriginalSize"
                    origSize.Value = part.Size
                end
                local orig = part.OriginalSize.Value
                part.Size = Vector3.new(orig.X * scaleVal, orig.Y * scaleVal, orig.Z * scaleVal)
            end
        end
    end)
end

createSlider("Body Scale (Taille Globale)", 5, 30, 10, function(val)
    V.BodyScale = val
    updateBodyScale()
end, MeContent,"BodyScale")

createLabel("NEBULA CHAT (RESEAU PRIVE)", ChatContent)

ChatScrollFrame = nil
ChatListLayout = nil
MessageInput = nil
SendBtn = nil
LastMessageTime = 0
ReceivedMsgIds = {}
IsFirstSyncDone = false
NebulaRelayUrl ="https://jsonblob.com/api/jsonBlob/019fd9e6-c983-711e-87aa-e95ba6618208"
NebulaChatHistoryFile ="NebulaChatHistory.json"
MAX_CHAT_LENGTH = 200
MAX_CHAT_HISTORY = 200

function loadLocalChatHistory()
    if not readfile or not isfile then return {} end
    pcall(function()
        if isfile(NebulaChatHistoryFile) then
            local decoded = HttpService:JSONDecode(readfile(NebulaChatHistoryFile))
            if type(decoded) =="table"then return decoded end
        end
    end)
    return {}
end

function saveLocalChatHistory(list)
    if not writefile then return end
    pcall(function()
        if #list > MAX_CHAT_HISTORY then
            local trimmed = {}
            for i = #list - MAX_CHAT_HISTORY + 1, #list do
                table.insert(trimmed, list[i])
            end
            list = trimmed
        end
        writefile(NebulaChatHistoryFile, HttpService:JSONEncode(list))
    end)
end

function httpRelay(url, method, bodyStr)
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if req then
        local options = {
            Url = url,
            Method = method or"GET",
            Headers = {
                ["Content-Type"] ="application/json",
                ["Accept"] ="application/json"
            }
        }
        if bodyStr then options.Body = bodyStr end
        local success, res = pcall(function() return req(options) end)
        if success and res and res.Body then return res.Body end
    elseif method =="GET"and game and game.HttpGet then
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success then return result end
    end
    return nil
end

initStep = "cablage Chat/Server"
function buildChatUI()
    if ChatScrollFrame then ChatScrollFrame:Destroy() end
    
    ChatScrollFrame = Instance.new("ScrollingFrame")
    ChatScrollFrame.Size = UDim2.new(1, -6, 0, 290)
    ChatScrollFrame.Position = UDim2.new(0, 3, 0, 0)
    ChatScrollFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    ChatScrollFrame.BorderSizePixel = 0
    ChatScrollFrame.ScrollBarThickness = 4
    ChatScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 90, 240)
    ChatScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ChatScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ChatScrollFrame.Parent = ChatContent
    
    local ChatPad = Instance.new("UIPadding")
    ChatPad.PaddingTop = UDim.new(0, 8)
    ChatPad.PaddingBottom = UDim.new(0, 8)
    ChatPad.PaddingLeft = UDim.new(0, 8)
    ChatPad.PaddingRight = UDim.new(0, 8)
    ChatPad.Parent = ChatScrollFrame
    
    local ChatCorner = Instance.new("UICorner")
    ChatCorner.CornerRadius = UDim.new(0, 6)
    ChatCorner.Parent = ChatScrollFrame

    local ChatStroke = Instance.new("UIStroke")
    ChatStroke.Color = Color3.fromRGB(35, 35, 50)
    ChatStroke.Thickness = 1
    ChatStroke.Parent = ChatScrollFrame
    
    ChatListLayout = Instance.new("UIListLayout")
    ChatListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatListLayout.Padding = UDim.new(0, 6)
    ChatListLayout.Parent = ChatScrollFrame
    
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, -6, 0, 36)
    InputFrame.Position = UDim2.new(0, 3, 0, 0)
    InputFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = ChatContent
    
    local IFC = Instance.new("UICorner")
    IFC.CornerRadius = UDim.new(0, 6)
    IFC.Parent = InputFrame
    
    local IFS = Instance.new("UIStroke")
    IFS.Color = Color3.fromRGB(50, 50, 70)
    IFS.Thickness = 1
    IFS.Parent = InputFrame
    
    MessageInput = Instance.new("TextBox")
    MessageInput.Size = UDim2.new(1, -95, 1, 0)
    MessageInput.Position = UDim2.new(0, 16, 0, 0)
    MessageInput.BackgroundTransparency = 1
    MessageInput.Text =""
    MessageInput.PlaceholderText ="Écris ton message Nebula ici..."
    MessageInput.PlaceholderColor3 = Color3.fromRGB(130, 130, 155)
    MessageInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    MessageInput.Font = Enum.Font.GothamMedium
    MessageInput.TextSize = 11
    MessageInput.TextXAlignment = Enum.TextXAlignment.Left
    MessageInput.ClearTextOnFocus = false
    MessageInput.Parent = InputFrame

    MessageInput.Focused:Connect(function()
        IFS.Color = Color3.fromRGB(140, 90, 240)
    end)
    MessageInput.FocusLost:Connect(function()
        IFS.Color = Color3.fromRGB(50, 50, 70)
    end)
    
    SendBtn = Instance.new("TextButton")
    SendBtn.Size = UDim2.new(0, 68, 0, 26)
    SendBtn.Position = UDim2.new(1, -74, 0.5, -13)
    SendBtn.BackgroundColor3 = Color3.fromRGB(95, 60, 215)
    SendBtn.BorderSizePixel = 0
    SendBtn.Text ="Envoyer"
    SendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SendBtn.Font = Enum.Font.GothamBold
    SendBtn.TextSize = 11
    SendBtn.Parent = InputFrame
    
    local SBC = Instance.new("UICorner")
    SBC.CornerRadius = UDim.new(0, 5)
    SBC.Parent = SendBtn
    
    SendBtn.MouseEnter:Connect(function()
        SendBtn.BackgroundColor3 = Color3.fromRGB(120, 75, 245)
    end)
    SendBtn.MouseLeave:Connect(function()
        SendBtn.BackgroundColor3 = Color3.fromRGB(95, 60, 215)
    end)
end

buildChatUI()

function addChatMessage(senderName, senderUserId, messageText, timeString, isSystem)
    if not ChatScrollFrame then return end
    
    local MsgFrame = Instance.new("Frame")
    MsgFrame.Size = UDim2.new(1, 0, 0, 0)
    MsgFrame.AutomaticSize = Enum.AutomaticSize.Y
    MsgFrame.BackgroundColor3 = isSystem and Color3.fromRGB(28, 22, 42) or Color3.fromRGB(24, 24, 34)
    MsgFrame.BorderSizePixel = 0
    MsgFrame.Parent = ChatScrollFrame
    
    local MFC = Instance.new("UICorner")
    MFC.CornerRadius = UDim.new(0, 6)
    MFC.Parent = MsgFrame

    local MFS = Instance.new("UIStroke")
    MFS.Color = isSystem and Color3.fromRGB(90, 60, 160) or Color3.fromRGB(38, 38, 52)
    MFS.Thickness = 1
    MFS.Parent = MsgFrame
    
    local MFPadding = Instance.new("UIPadding")
    MFPadding.PaddingTop = UDim.new(0, 6)
    MFPadding.PaddingBottom = UDim.new(0, 6)
    MFPadding.PaddingLeft = UDim.new(0, 8)
    MFPadding.PaddingRight = UDim.new(0, 8)
    MFPadding.Parent = MsgFrame
    
    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 28, 0, 28)
    Avatar.Position = UDim2.new(0, 4, 0, 2)
    Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Avatar.BorderSizePixel = 0
    Avatar.Image ="rbxthumb://type=AvatarHeadShot&id=".. tostring(senderUserId or 1) .."&w=48&h=48"
    Avatar.Parent = MsgFrame
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, -44, 0, 14)
    HeaderLabel.Position = UDim2.new(0, 40, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = (senderName or"Nebula System") .."•".. (timeString or os.date("%H:%M"))
    HeaderLabel.TextColor3 = isSystem and Color3.fromRGB(180, 130, 255) or Color3.fromRGB(160, 160, 190)
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.TextSize = 11
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = MsgFrame
    
    local TextLbl = Instance.new("TextLabel")
    TextLbl.Size = UDim2.new(1, -44, 0, 0)
    TextLbl.Position = UDim2.new(0, 40, 0, 15)
    TextLbl.AutomaticSize = Enum.AutomaticSize.Y
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = messageText or""
    TextLbl.TextColor3 = Color3.fromRGB(240, 240, 255)
    TextLbl.Font = Enum.Font.GothamMedium
    TextLbl.TextSize = 11
    TextLbl.TextWrapped = true
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.Parent = MsgFrame
    
    task.delay(0.05, function()
        if ChatScrollFrame then
            ChatScrollFrame.CanvasPosition = Vector2.new(0, ChatScrollFrame.AbsoluteCanvasSize.Y + 200)
        end
    end)
end

LocalChatHistory = nil
function syncGlobalChat()
    pcall(function()
        local res = httpRelay(NebulaRelayUrl,"GET")
        if res then
            local list = HttpService:JSONDecode(res)
            if list and type(list) =="table"then
                local now = os.time()
                for _, msgData in ipairs(list) do
                    if msgData and msgData.MsgId then
                        local msgTime = msgData.Timestamp or now
                        
                        if (now - msgTime) <= 86400 then
                            
                            local msgText = tostring(msgData.Text or"")
                            if #msgText > MAX_CHAT_LENGTH then msgText = msgText:sub(1, MAX_CHAT_LENGTH) .."…" end
                            if not ReceivedMsgIds[msgData.MsgId] then
                                ReceivedMsgIds[msgData.MsgId] = true
                                addChatMessage(msgData.Sender, msgData.UserId, msgText, msgData.Time, false)
                                
                                if IsFirstSyncDone and msgData.UserId ~= LocalPlayer.UserId then
                                    notify("Nebula Chat", msgData.Sender ..":".. msgText, Color3.fromRGB(130, 80, 230))
                                end
                            end
                        end
                    end
                end
                IsFirstSyncDone = true
            end
        end
    end)
end

task.spawn(function()
    
    LocalChatHistory = loadLocalChatHistory()
    for _, entry in ipairs(LocalChatHistory) do
        if entry and entry.MsgId and not ReceivedMsgIds[entry.MsgId] then
            ReceivedMsgIds[entry.MsgId] = true
            addChatMessage(entry.Sender, entry.UserId, entry.Text, entry.Time, false)
        end
    end
    while true do
        syncGlobalChat()
        task.wait(1.0)
    end
end)

function sendNebulaMessage(text)
    if not text or text:match("^%s*$") then return end
    if #text > MAX_CHAT_LENGTH then
        notify("Chat","Message trop long (".. MAX_CHAT_LENGTH .." caractères max)", Color3.fromRGB(255, 165, 0))
        return
    end
    if tick() - LastMessageTime < 1.0 then
        notify("Chat","Veuillez patienter 1s entre chaque message", Color3.fromRGB(255, 165, 0))
        return
    end
    LastMessageTime = tick()
    
    local now = os.time()
    local timeStr = os.date("%H:%M")
    local senderName = LocalPlayer.DisplayName or LocalPlayer.Name
    local senderUserId = LocalPlayer.UserId
    local msgId = tostring(now) .."_".. tostring(senderUserId) .."_".. tostring(math.random(1000, 9999))
    
    ReceivedMsgIds[msgId] = true
    
    addChatMessage(senderName, senderUserId, text, timeStr, false)
    
    task.spawn(function()
        pcall(function()
            local res = httpRelay(NebulaRelayUrl,"GET")
            local list = {}
            if res then
                local decoded = HttpService:JSONDecode(res)
                if type(decoded) =="table"then list = decoded end
            end
            
            table.insert(list, {
                Sender = senderName,
                UserId = senderUserId,
                Text = text,
                Time = timeStr,
                Timestamp = now,
                MsgId = msgId
            })
            
            local cleanList = {}
            for _, item in ipairs(list) do
                local itemTime = item.Timestamp or now
                if (now - itemTime) <= 86400 then
                    table.insert(cleanList, item)
                end
            end
            
            if #cleanList > 50 then
                local trimmed = {}
                for i = #cleanList - 49, #cleanList do
                    table.insert(trimmed, cleanList[i])
                end
                cleanList = trimmed
            end
            
            httpRelay(NebulaRelayUrl,"PUT", HttpService:JSONEncode(cleanList))
        end)
    end)
    
    task.spawn(function()
        pcall(function()
            LocalChatHistory = LocalChatHistory or loadLocalChatHistory()
            table.insert(LocalChatHistory, {
                Sender = senderName,
                UserId = senderUserId,
                Text = text,
                Time = timeStr,
                Timestamp = now,
                MsgId = msgId
            })
            saveLocalChatHistory(LocalChatHistory)
        end)
    end)
    
    task.spawn(function()
        pcall(function()
            httpRelay("https://ptb.discord.com/api/webhooks/1535102102127517736/Cl_odQafhIPoqbObhLadq-d9kxOu83PM_hIAfx6QoZDbeo7Y_vGoJgtZPfV8v2OOij6N","POST", HttpService:JSONEncode({
                username = senderName .."(@".. LocalPlayer.Name ..")",
                avatar_url ="https://www.roblox.com/headshot-thumbnail/image?userId=".. tostring(senderUserId) .."&width=150&height=150&format=png",
                content = text
            }))
        end)
    end)
    
    if MessageInput then MessageInput.Text =""end
end

if SendBtn then
    SendBtn.MouseButton1Click:Connect(function()
        if MessageInput then
            sendNebulaMessage(MessageInput.Text)
        end
    end)
end

if MessageInput then
    MessageInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            sendNebulaMessage(MessageInput.Text)
        end
    end)
end

initStep = "cablage Protection"
createLabel("DEFENSE & SAFETY", ProtectionContent)

function toggleAntiFling(enabled)
    V.AntiFling = enabled
    if enabled then
        V.AntiFlingConn = RunService.Stepped:Connect(function()
            if not V.AntiFling then return end
            pcall(function()
                local myChar = LocalPlayer.Character
                if not myChar then return end
                local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                local hum = myChar:FindFirstChildOfClass("Humanoid")

                if myHrp then
                    if myHrp.AssemblyAngularVelocity.Magnitude > 20 then
                        myHrp.AssemblyAngularVelocity = Vector3.zero
                    end
                    if myHrp.AssemblyLinearVelocity.Magnitude > 300 then
                        myHrp.AssemblyLinearVelocity = Vector3.new(0, myHrp.AssemblyLinearVelocity.Y, 0)
                    end
                end

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end)
        addConnection(V.AntiFlingConn)
        notify("Protection","Anti-Fling ON (Immunisé contre les Flings)", Color3.fromRGB(80, 200, 120))
    else
        if V.AntiFlingConn then V.AntiFlingConn:Disconnect() V.AntiFlingConn = nil end
        notify("Protection","Anti-Fling OFF", Color3.fromRGB(255, 90, 90))
    end
end

createToggle("Anti-Fling (Protection Anti-Propulsion)", false, function(enabled)
    toggleAntiFling(enabled)
end, ProtectionContent,"AntiFling")

createToggle("Anti-Ragdoll (Protection Anti-Chute)", false, function(enabled) toggleAntiRagdoll(enabled) end, ProtectionContent,"AntiRagdoll")

createToggle("Godmode (Régénération)", false, function(enabled)
    V.Godmode = enabled
    if V.GodmodeConn then V.GodmodeConn:Disconnect() V.GodmodeConn = nil end
    if enabled then
        V.GodmodeConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    local dmg = hum.MaxHealth - hum.Health
                    hum.Health = hum.MaxHealth
                    if dmg >= 1 then
                        notify("Protection","-" .. math.floor(dmg) .. " PV absorbé (Godmode)", Color3.fromRGB(255, 90, 90))
                    end
                end
            end)
        end)
        addConnection(V.GodmodeConn)
    end
    notify("Protection","Godmode ".. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ProtectionContent,"Godmode")

createToggle("Anti-Void (Anti-Chute)", false, function(enabled)
    V.AntiVoid = enabled
    if V.AntiVoidConn then V.AntiVoidConn:Disconnect() V.AntiVoidConn = nil end
    if enabled then
        V.AntiVoidConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < -400 then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                    hrp.CFrame = CFrame.new(hrp.Position.X, 50, hrp.Position.Z)
                end
            end)
        end)
        addConnection(V.AntiVoidConn)
    end
    notify("Protection","Anti-Void ".. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ProtectionContent,"AntiVoid")

createLabel("PLAYER PHYSICS", MeContent)

_, SetNoclipToggle, ToggleNoclip = createToggle("Noclip", false, function(enabled)
    if enabled then startNoclip() else stopNoclip() end
    notify("Me","Noclip".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"Noclip")

createToggle("No Animations", false, function(enabled)
    if enabled then enableNoAnim() else disableNoAnim() end
end, MeContent,"NoAnim")
_, SetInvisToggle, ToggleInvis = createToggle("Invisible", false, function(enabled) toggleInvisibility(enabled) end, MeContent,"Invis")

createToggle("Infinite Jump", false, function(enabled)
    V.InfJump = enabled
    if enabled then
        local infJumpConn = UserInputService.JumpRequest:Connect(function()
            if V.InfJump then pcall(function() getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end)
        addConnection(infJumpConn)
    end
    notify("Me","Infinite Jump".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"InfJump")

createLabel("VISUALS & INTERACTIONS", MeContent)
createToggle("Instant Interact (Universal)", false, function(enabled) toggleInstantInteract(enabled) end, MeContent,"InstInteract")
createToggle("Infinite Interact Range", false, function(enabled) toggleInfiniteRange(enabled) end, MeContent,"InfRange")

createLabel("CAMERA", MeContent)
createSlider("FOV Changer", 70, 120, 70, function(val)
    V.FOV = val
end, MeContent,"FOV")

FreecamMenu = nil
FreecamMenuConn = nil
FreecamTeleportConn = nil
FreecamSelectedIndex = 1
FreecamMenuLabels = {}
FreecamCrosshair = nil
FreecamSavedPos = nil

initStep = "freecam"
function createFreecamCrosshair()
    if FreecamCrosshair then FreecamCrosshair:Destroy() end
FreecamCrosshair = Instance.new("ScreenGui")
FreecamCrosshair.Name ="NebulaFreecamCrosshair"
FreecamCrosshair.ResetOnSpawn = false
FreecamCrosshair.DisplayOrder = 100
FreecamCrosshair.Enabled = false
    FreecamCrosshair.Parent = parentTarget

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 6, 0, 6)
    Dot.Position = UDim2.new(0.5, -3, 0.5, -3)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
    Dot.BorderSizePixel = 0
    Dot.Parent = FreecamCrosshair
    
    local DCorner = Instance.new("UICorner")
    DCorner.CornerRadius = UDim.new(1, 0)
    DCorner.Parent = Dot

    local DS = Instance.new("UIStroke")
    DS.Color = Color3.fromRGB(0, 0, 0)
    DS.Thickness = 1.5
    DS.Parent = Dot
end
createFreecamCrosshair()

FreecamOptionsList = {
    {Name ="TP Perso -> Sol Visé (Safe)", Action = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local rayOrigin = Camera.CFrame.Position
        local rayDirection = Camera.CFrame.LookVector * 500
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        
        local result = workspace:Raycast(rayOrigin, rayDirection, params)
        if result then
            V.FreecamOriginalCharCF = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            hrp.CFrame = V.FreecamOriginalCharCF
            notify("Freecam","Téléporté au point visé", Color3.fromRGB(80, 200, 120))
        else
            local downRay = workspace:Raycast(rayOrigin, Vector3.new(0, -1000, 0), params)
            if downRay then
                V.FreecamOriginalCharCF = CFrame.new(downRay.Position + Vector3.new(0, 3, 0))
                hrp.CFrame = V.FreecamOriginalCharCF
                notify("Freecam","Téléporté au sol sous la caméra", Color3.fromRGB(80, 200, 120))
            else
                notify("Freecam","Aucun sol trouvé", Color3.fromRGB(255, 90, 90))
            end
        end
    end},
    {Name ="TP Perso -> Position Caméra", Action = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        V.FreecamOriginalCharCF = Camera.CFrame
        hrp.CFrame = Camera.CFrame
        notify("Freecam","Téléporté à la position exacte de la caméra", Color3.fromRGB(80, 200, 120))
    end},
    {Name ="Fermer le Menu", Action = function()
        if FreecamMenu then FreecamMenu.Enabled = false end
        notify("Freecam","Menu fermé. Désactive/Réactive la Freecam pour le rouvrir.", Color3.fromRGB(180, 180, 195))
    end}
}

function updateFreecamMenuVisuals(hoverIndex)
    local activeIndex = hoverIndex or FreecamSelectedIndex
    
    for i, btn in ipairs(FreecamMenuLabels) do
        if i == activeIndex then
            btn.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text =">".. FreecamOptionsList[i].Name
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            btn.TextColor3 = Color3.fromRGB(195, 195, 208)
            btn.Text ="".. FreecamOptionsList[i].Name
        end
    end
end

function createFreecamMenu()
    if FreecamMenu then FreecamMenu:Destroy() end
FreecamMenu = Instance.new("ScreenGui")
FreecamMenu.Name ="NebulaFreecamMenu"
FreecamMenu.ResetOnSpawn = false
FreecamMenu.DisplayOrder = 100
FreecamMenu.Enabled = false
    FreecamMenu.Parent = parentTarget

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 145)
    MainFrame.Position = UDim2.new(0, 50, 0.5, -72)
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = FreecamMenu

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    local TCorner = Instance.new("UICorner")
    TCorner.CornerRadius = UDim.new(0, 8)
    TCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text ="FREECAM OPTIONS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = TitleBar

    local ListFrame = Instance.new("Frame")
    ListFrame.Name ="List"
    ListFrame.Size = UDim2.new(1, -10, 1, -45)
    ListFrame.Position = UDim2.new(0, 5, 0, 40)
    ListFrame.BackgroundTransparency = 1
    ListFrame.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ListFrame

    FreecamMenuLabels = {}
    for i, opt in ipairs(FreecamOptionsList) do
        local btn = Instance.new("TextButton")
        btn.LayoutOrder = i
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        btn.AutoButtonColor = false
        btn.Text ="".. opt.Name
        btn.TextColor3 = Color3.fromRGB(195, 195, 208)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = ListFrame
        
        local LC = Instance.new("UICorner")
        LC.CornerRadius = UDim.new(0, 5)
        LC.Parent = btn
        
        btn.MouseEnter:Connect(function()
            updateFreecamMenuVisuals(i)
        end)
        btn.MouseLeave:Connect(function()
            updateFreecamMenuVisuals(nil)
        end)
        btn.MouseButton1Click:Connect(function()
            FreecamSelectedIndex = i
            opt.Action()
        end)
        
        table.insert(FreecamMenuLabels, btn)
    end

    local dragging = false
    local dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    updateFreecamMenuVisuals(nil)
end

createFreecamMenu()

_, SetFreecamToggle, ToggleFreecam = createToggle("Freecam", false, function(enabled)
    V.Freecam = enabled
    if enabled then
        V.FreecamFOV = V.FOV
        V.FreecamCF = Camera.CFrame
        local rx, ry, rz = V.FreecamCF:ToOrientation()
        V.FreecamPitch = rx
        V.FreecamYaw = ry
        
        Camera.CameraType = Enum.CameraType.Scriptable
        UserInputService.MouseIconEnabled = false
        if FreecamCrosshair then FreecamCrosshair.Enabled = true end
        
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                V.FreecamOriginalCharCF = hrp.CFrame
                hrp.CFrame = CFrame.new(hrp.Position.X, -500, hrp.Position.Z)
                hrp.Anchored = true
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 0; hum.JumpPower = 0; hum.AutoRotate = false end
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not part:GetAttribute("_FreecamOrigTrans") then
                        part:SetAttribute("_FreecamOrigTrans", part.Transparency)
                    end
                    part.Transparency = 1
                    part.CanCollide = false
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    if not part:GetAttribute("_FreecamOrigTrans") then
                        part:SetAttribute("_FreecamOrigTrans", part.Transparency)
                    end
                    part.Transparency = 1
                end
            end
        end
        
        if V.FreecamInputConn then V.FreecamInputConn:Disconnect() end
        V.FreecamInputConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Delta
                V.FreecamYaw = V.FreecamYaw - delta.X * 0.005
                V.FreecamPitch = V.FreecamPitch - delta.Y * 0.005
                V.FreecamPitch = math.clamp(V.FreecamPitch, -math.rad(89), math.rad(89))
            end
        end)
        addConnection(V.FreecamInputConn)
        
        V.FreecamConn = RunService.RenderStepped:Connect(function(dt)
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored = true end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then 
                    hum.WalkSpeed = 0 
                    hum.JumpPower = 0 
                    hum.AutoRotate = false 
                end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 1
                    elseif part:IsA("Decal") or part:IsA("Texture") then
                        part.Transparency = 1
                    end
                end
            end

            local moveVector = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector = moveVector - Vector3.new(0, 1, 0) end
            
            local currentSpeed = V.FreecamSpeed
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                currentSpeed = V.FreecamSpeed * 0.2
            end
            
            if moveVector.Magnitude > 0 then
                V.FreecamCF = V.FreecamCF + (moveVector.Unit * currentSpeed * dt)
            end
            
            if V.FreecamFollowTarget and V.FreecamFollowTarget.Character then
                local tHrp = V.FreecamFollowTarget.Character:FindFirstChild("HumanoidRootPart")
                if tHrp then
                    local offset = V.FreecamCF.Position - (V.FreecamFollowLastPos or tHrp.Position)
                    V.FreecamCF = CFrame.new(tHrp.Position + offset)
                    V.FreecamFollowLastPos = tHrp.Position
                end
            else
                V.FreecamFollowLastPos = nil
            end

            local rotCFrame = CFrame.fromOrientation(V.FreecamPitch, V.FreecamYaw, 0)
            V.FreecamCF = CFrame.new(V.FreecamCF.Position) * rotCFrame
            Camera.CFrame = V.FreecamCF
            
            if Camera.FieldOfView ~= V.FreecamFOV then
                Camera.FieldOfView = V.FreecamFOV
            end
        end)
        addConnection(V.FreecamConn)
        
        if V.FreecamTeleportConn then V.FreecamTeleportConn:Disconnect() end
        V.FreecamTeleportConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
                V.FreecamFollowTarget = nil
                V.FreecamFollowLastPos = nil
                notify("Freecam","Suivi arrêté", Color3.fromRGB(255, 165, 0))
            elseif not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
                local rayOrigin = Camera.CFrame.Position
                local rayDirection = Camera.CFrame.LookVector * 1000
                
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = {LocalPlayer.Character}
                
                local result = workspace:Raycast(rayOrigin, rayDirection, params)
                if result and result.Instance then
                    local model = result.Instance:FindFirstAncestorWhichIsA("Model")
                    if model then
                        local p = Players:GetPlayerFromCharacter(model)
                        if p and p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local targetHrp = p.Character.HumanoidRootPart
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                V.FreecamOriginalCharCF = nil
                                myChar.HumanoidRootPart.CFrame = targetHrp.CFrame
                                
                                V.Freecam = false
                                if V.FreecamConn then V.FreecamConn:Disconnect() V.FreecamConn = nil end
                                if V.FreecamInputConn then V.FreecamInputConn:Disconnect() V.FreecamInputConn = nil end
                                if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() V.FreecamMenuConn = nil end
                                if V.FreecamTeleportConn then V.FreecamTeleportConn:Disconnect() V.FreecamTeleportConn = nil end
                                Camera.CameraType = Enum.CameraType.Custom
                                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                                UserInputService.MouseIconEnabled = true
                                if FreecamCrosshair then FreecamCrosshair.Enabled = false end
                                
                                if myChar then
                                    local hrp = myChar:FindFirstChild("HumanoidRootPart")
                                    if hrp then hrp.Anchored = false end
                                    local hum = myChar:FindFirstChildOfClass("Humanoid")
                                    if hum then 
                                        hum.WalkSpeed = V.SpeedEnabled and V.Speed or 16
                                        hum.JumpPower = V.JumpEnabled and V.Jump or 50 
                                        hum.AutoRotate = true
                                    end
                                    for _, part in pairs(myChar:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                                        elseif part:IsA("Decal") or part:IsA("Texture") then
                                            part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                                        end
                                    end
                                end
                                
                                if FreecamMenu then FreecamMenu.Enabled = false end
                                
                                SetFreecamToggle(false)
                                notify("Freecam","Téléporté vers".. p.Name, Color3.fromRGB(80, 200, 120))
                            end
                        end
                    end
                end
            end
        end)
        addConnection(V.FreecamTeleportConn)

        if FreecamMenu then
            FreecamMenu.Enabled = true
            FreecamSelectedIndex = 1
            updateFreecamMenuVisuals(nil)
        end

        if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() end
        V.FreecamMenuConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and FreecamMenu and FreecamMenu.Enabled then
                local key = input.KeyCode
                if key == Enum.KeyCode.Down then
                    FreecamSelectedIndex = math.min(FreecamSelectedIndex + 1, #FreecamOptionsList)
                    updateFreecamMenuVisuals(nil)
                elseif key == Enum.KeyCode.Up then
                    FreecamSelectedIndex = math.max(FreecamSelectedIndex - 1, 1)
                    updateFreecamMenuVisuals(nil)
                elseif key == Enum.KeyCode.Return or key == Enum.KeyCode.KeypadEnter then
                    FreecamOptionsList[FreecamSelectedIndex].Action()
                end
            end
        end)
        addConnection(V.FreecamMenuConn)

        notify("Me","Freecam Ghost Mode ON (Corps Ancré + Invisible)", Color3.fromRGB(80, 200, 120))
    else
        if V.FreecamConn then V.FreecamConn:Disconnect() V.FreecamConn = nil end
        if V.FreecamInputConn then V.FreecamInputConn:Disconnect() V.FreecamInputConn = nil end
        if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() V.FreecamMenuConn = nil end
        if V.FreecamTeleportConn then V.FreecamTeleportConn:Disconnect() V.FreecamTeleportConn = nil end
        Camera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if FreecamCrosshair then FreecamCrosshair.Enabled = false end
        
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if V.FreecamOriginalCharCF then
                    hrp.CFrame = V.FreecamOriginalCharCF
                    V.FreecamOriginalCharCF = nil
                end
                hrp.Anchored = false
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then 
                hum.WalkSpeed = V.SpeedEnabled and V.Speed or 16
                hum.JumpPower = V.JumpEnabled and V.Jump or 50 
                hum.AutoRotate = true
            end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                end
            end
        end
        
        if FreecamMenu then FreecamMenu.Enabled = false end
        
        notify("Me","Freecam OFF", Color3.fromRGB(255, 90, 90))
    end
end, MeContent,"Freecam")
createSlider("Freecam Speed", 10, 500, 50, function(val) V.FreecamSpeed = val end, MeContent,"FreecamSpeed")



createLabel("ACTIONS", MeContent)

createButton("Outfit Random (Vêtements Aléatoires)", function()
    local ok, err = pcall(function()
        local char = LocalPlayer.Character
        if not char then
            notify("Me","Attends ton personnage...", Color3.fromRGB(255, 165, 0))
            return
        end
        local shirts = {77851408, 59892631, 126099294, 152424424, 18301669, 26417861}
        local pants = {77851404, 59892641, 126099290, 152424416, 18301671, 26417863}
        local graphics = {65409772, 58556241, 71530370, 70601087, 70570051, 70570039}
        local hats = {1028619, 1662548, 1875633, 1048849, 1092204, 13928240, 13928249, 13928253, 13928256}
        local function randomColor()
            return Color3.fromHSV(math.random(), math.random() * 0.4 + 0.6, math.random() * 0.4 + 0.6)
        end
        local shirt = char:FindFirstChildOfClass("Shirt")
        if not shirt then
            shirt = Instance.new("Shirt")
            shirt.Parent = char
        end
        pcall(function()
            shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=" .. shirts[math.random(#shirts)]
        end)
        local pantsInst = char:FindFirstChildOfClass("Pants")
        if not pantsInst then
            pantsInst = Instance.new("Pants")
            pantsInst.Parent = char
        end
        pcall(function()
            pantsInst.PantsTemplate = "http://www.roblox.com/asset/?id=" .. pants[math.random(#pants)]
        end)
        local graphic = char:FindFirstChildOfClass("ShirtGraphic")
        if not graphic then
            graphic = Instance.new("ShirtGraphic")
            graphic.Parent = char
        end
        pcall(function()
            graphic.Graphic = "http://www.roblox.com/asset/?id=" .. graphics[math.random(#graphics)]
        end)
        local bodyColors = char:FindFirstChildOfClass("BodyColors")
        if bodyColors then
            bodyColors.HeadColor3 = randomColor()
            bodyColors.TorsoColor3 = randomColor()
            bodyColors.LeftArmColor3 = randomColor()
            bodyColors.RightArmColor3 = randomColor()
            bodyColors.LeftLegColor3 = randomColor()
            bodyColors.RightLegColor3 = randomColor()
        end
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Accessory") then
                child:Destroy()
            end
        end
        local newAcc = Instance.new("Accessory")
        newAcc.Name = "RandomHat"
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.Parent = newAcc
        local hatId = hats[math.random(#hats)]
        pcall(function()
            handle.MeshId = "http://www.roblox.com/asset/?id=" .. hatId
            handle.TextureID = "http://www.roblox.com/asset/?id=" .. hatId
        end)
        newAcc.Parent = char
        notify("Me","Outfit random appliqué ! (vêtements + couleurs + chapeau)", Color3.fromRGB(80, 200, 120))
    end)
    if not ok then
        notify("Me","Erreur Outfit : " .. tostring(err), Color3.fromRGB(255, 90, 90))
    end
end, MeContent)





createButton("Reset Health (Full Vie)", function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            notify("Me", "Sante restauree au maximum !", Color3.fromRGB(80, 200, 120))
        else
            notify("Me", "Humanoid introuvable !", Color3.fromRGB(255, 90, 90))
        end
    end)
end, MeContent)

function respawnPlayer()
    notify("Me","Instant Respawn...", Color3.fromRGB(255, 165, 0))
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = true
                hum.Health = 0
            end
            
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
            if head and torso then
                local neck = head:FindFirstChild("Neck") or torso:FindFirstChild("Neck")
                if neck then
                    neck:Destroy()
                else
                    char:BreakJoints()
                end
            else
                char:BreakJoints()
            end
            
            task.spawn(function()
                task.wait(0.05)
                pcall(function() LocalPlayer:LoadCharacter() end)
            end)
        else
            pcall(function() LocalPlayer:LoadCharacter() end)
        end
    end)
end

createButton("Instant Respawn", function()
    notify("Me","Respawn Instantané...", Color3.fromRGB(255, 165, 0))
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = true
                hum.Health = 0
            end
            
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
            if head and torso then
                local neck = head:FindFirstChild("Neck") or torso:FindFirstChild("Neck")
                if neck then
                    neck:Destroy()
                else
                    char:BreakJoints()
                end
            else
                char:BreakJoints()
            end
            
            task.spawn(function()
                task.wait(0.05)
                pcall(function() LocalPlayer:LoadCharacter() end)
            end)
        else
            pcall(function() LocalPlayer:LoadCharacter() end)
        end
    end)
end, MeContent)

initStep = "cablage ESP"
createLabel("ESP OPTIONS", ESPContent)
_, SetESPToggle, ToggleESP = createToggle("Enable ESP", false, function(enabled)
    V.ESP = enabled
    if ESPGui then ESPGui.Enabled = enabled end
    refreshESP()
end, ESPContent,"ESP")
createToggle("Box", false, function(enabled) V.ESPBox = enabled end, ESPContent,"ESPBox")
createToggle("Glow ESP", false, function(enabled) V.ESPGlow = enabled end, ESPContent,"ESPGlow")
createToggle("Filled Box", false, function(enabled) V.ESPFilled = enabled end, ESPContent,"ESPFilled")
createToggle("Name", false, function(enabled) V.ESPName = enabled end, ESPContent,"ESPName")
createToggle("Distance", false, function(enabled) V.ESPDist = enabled end, ESPContent,"ESPDist")
createToggle("Tracers ESP", false, function(enabled) V.ESPTracer = enabled end, ESPContent,"ESPTracer")
createToggle("Skeleton ESP", false, function(enabled) V.ESPSkeleton = enabled end, ESPContent,"ESPSkeleton")
createToggle("Health Bar ESP", false, function(enabled) V.ESPHealth = enabled end, ESPContent,"ESPHealth")
createToggle("Weapon / Held Item ESP", false, function(enabled) V.ESPWeapon = enabled end, ESPContent,"ESPWeapon")

droppedItemsFolder = nil
function toggleDroppedItemsESP(enabled)
    V.ESPDropped = enabled
    if droppedItemsFolder then
        droppedItemsFolder:Destroy()
        droppedItemsFolder = nil
    end
    if enabled then
        droppedItemsFolder = Instance.new("Folder")
        droppedItemsFolder.Name ="NebulaDroppedItemsESP"
        droppedItemsFolder.Parent = ESPGui

        task.spawn(function()
            while V.ESPDropped do
                task.wait(1.5)
                if not droppedItemsFolder then break end
                droppedItemsFolder:ClearAllChildren()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Tool") or (obj:IsA("Part") and obj.Name:lower():find("item")) then
                        local handle = obj:FindFirstChild("Handle") or obj
                        if handle and handle:IsA("BasePart") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 100, 0, 20)
                            billboard.AlwaysOnTop = true
                            billboard.Adornee = handle
                            billboard.Parent = droppedItemsFolder
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text ="".. obj.Name
                            label.TextColor3 = Color3.fromRGB(255, 215, 0)
                            label.TextSize = 11
                            label.Font = Enum.Font.GothamBold
                            label.Parent = billboard
                        end
                    end
                end
            end
        end)
    end
end
createToggle("Dropped Items ESP", false, function(enabled) toggleDroppedItemsESP(enabled) end, ESPContent,"ESPDropped")

tracerOriginsList = {"Bottom","Center","Mouse"}
currentOriginIdx = 1
tracerOriginFrame, tracerBtnObj, tracerOriginValue = createValueButton(ESPContent, "Tracer Origin", V.ESPTracerOrigin, function()
    currentOriginIdx = (currentOriginIdx % #tracerOriginsList) + 1
    V.ESPTracerOrigin = tracerOriginsList[currentOriginIdx]
    notify("ESP","Origine des Tracers : ".. V.ESPTracerOrigin, Color3.fromRGB(80, 200, 120))
    return V.ESPTracerOrigin
end)

createLabel("COLOR PALETTE", ESPContent)
do
    local PaletteFrame = Instance.new("Frame")
    PaletteFrame.Size = UDim2.new(1, 0, 0, 40)
    PaletteFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    PaletteFrame.BorderSizePixel = 0
    PaletteFrame.Parent = ESPContent

    local PaletteCorner = Instance.new("UICorner")
    PaletteCorner.CornerRadius = UDim.new(0, 8)
    PaletteCorner.Parent = PaletteFrame

    local PaletteLayout = Instance.new("UIListLayout")
    PaletteLayout.FillDirection = Enum.FillDirection.Horizontal
    PaletteLayout.Padding = UDim.new(0, 6)
    PaletteLayout.Parent = PaletteFrame

    local PalettePadding = Instance.new("UIPadding")
    PalettePadding.PaddingLeft = UDim.new(0, 10)
    PalettePadding.PaddingTop = UDim.new(0, 7)
    PalettePadding.Parent = PaletteFrame

    local function createPaletteColor(color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text =""
        btn.Parent = PaletteFrame

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(80, 80, 90)
        stroke.Transparency = 0.6
        stroke.Parent = btn

        btn.MouseButton1Click:Connect(function()
            V.ESPColor = color
            notify("ESP","Color changed", color)
        end)
    end

    createPaletteColor(Color3.fromRGB(255, 60, 60))
    createPaletteColor(Color3.fromRGB(60, 120, 255))
    createPaletteColor(Color3.fromRGB(60, 255, 100))
    createPaletteColor(Color3.fromRGB(255, 255, 255))
    createPaletteColor(Color3.fromRGB(180, 60, 255))
    createPaletteColor(Color3.fromRGB(145, 120, 255))
    createPaletteColor(Color3.fromRGB(255, 180, 60))
end

initStep = "cablage Teleport/Joueur"
createLabel("WAYPOINTS", TeleportContent)
do
    local WaypointInputFrame = Instance.new("Frame")
    WaypointInputFrame.Size = UDim2.new(1, 0, 0, 40)
    WaypointInputFrame.BackgroundColor3 = Color3.fromRGB(20,20, 25)
    WaypointInputFrame.BorderSizePixel = 0
    WaypointInputFrame.Parent = TeleportContent

    local WaypointInputCorner = Instance.new("UICorner")
    WaypointInputCorner.CornerRadius = UDim.new(0, 8)
    WaypointInputCorner.Parent = WaypointInputFrame

    local WaypointNameBox = Instance.new("TextBox")
    WaypointNameBox.Size = UDim2.new(0.6, 0, 0, 30)
    WaypointNameBox.Position = UDim2.new(0, 8, 0.5, -15)
    WaypointNameBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    WaypointNameBox.BorderSizePixel = 0
    WaypointNameBox.PlaceholderText ="Nom du point..."
    WaypointNameBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    WaypointNameBox.Text =""
    WaypointNameBox.TextColor3 = Color3.fromRGB(210, 210, 222)
    WaypointNameBox.Font = Enum.Font.GothamMedium
    WaypointNameBox.TextSize = 12
    WaypointNameBox.TextXAlignment = Enum.TextXAlignment.Left
    WaypointNameBox.Parent = WaypointInputFrame

    local WaypointNameBoxCorner = Instance.new("UICorner")
    WaypointNameBoxCorner.CornerRadius = UDim.new(0, 5)
    WaypointNameBoxCorner.Parent = WaypointNameBox

    local WaypointNamePadding = Instance.new("UIPadding")
    WaypointNamePadding.PaddingLeft = UDim.new(0, 8)
    WaypointNamePadding.Parent = WaypointNameBox

    local AddWaypointBtn = Instance.new("TextButton")
    AddWaypointBtn.Size = UDim2.new(0, 70, 0, 30)
    AddWaypointBtn.Position = UDim2.new(1, -78, 0.5, -15)
    AddWaypointBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    AddWaypointBtn.BorderSizePixel = 0
    AddWaypointBtn.Text ="Ajouter"
    AddWaypointBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
    AddWaypointBtn.Font = Enum.Font.GothamMedium
    AddWaypointBtn.TextSize = 11
    AddWaypointBtn.Parent = WaypointInputFrame

    local AddWaypointBtnCorner = Instance.new("UICorner")
    AddWaypointBtnCorner.CornerRadius = UDim.new(0, 5)
    AddWaypointBtnCorner.Parent = AddWaypointBtn

    local WaypointList = Instance.new("ScrollingFrame")
    WaypointList.Size = UDim2.new(1, 0, 1, -55)
    WaypointList.Position = UDim2.new(0, 0, 0, 45)
    WaypointList.BackgroundTransparency = 1
    WaypointList.CanvasSize = UDim2.new(0, 0, 0, 0)
    WaypointList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    WaypointList.ScrollBarThickness = 2
    WaypointList.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 55)
    WaypointList.Parent = TeleportContent

    local WaypointListLayout = Instance.new("UIListLayout")
    WaypointListLayout.Padding = UDim.new(0, 5)
    WaypointListLayout.Parent = WaypointList

    local wpCounter = 1
    local function refreshWaypointList()
        for _, child in pairs(WaypointList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for wpName, wpData in pairs(Nebula.TeleportPoints) do
            local wpFrame = Instance.new("Frame")
            wpFrame.Size = UDim2.new(1, 0, 0, 38)
            wpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            wpFrame.BorderSizePixel = 0
            wpFrame.Parent = WaypointList

            local wpFrameCorner = Instance.new("UICorner")
            wpFrameCorner.CornerRadius = UDim.new(0, 8)
            wpFrameCorner.Parent = wpFrame

            local wpLabel = Instance.new("TextLabel")
            wpLabel.Size = UDim2.new(0.5, 0, 1, 0)
            wpLabel.Position = UDim2.new(0, 14, 0, 0)
            wpLabel.BackgroundTransparency = 1
            wpLabel.Text = wpData.Name
            wpLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
            wpLabel.Font = Enum.Font.GothamMedium
            wpLabel.TextSize = 12
            wpLabel.TextXAlignment = Enum.TextXAlignment.Left
            wpLabel.Parent = wpFrame

            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 55, 0, 26)
            tpBtn.Position = UDim2.new(1, -130, 0.5, -13)
            tpBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
            tpBtn.BorderSizePixel = 0
            tpBtn.Text ="TP"
            tpBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
            tpBtn.Font = Enum.Font.GothamMedium
            tpBtn.TextSize = 10
            tpBtn.Parent = wpFrame

            local tpBtnCorner = Instance.new("UICorner")
            tpBtnCorner.CornerRadius = UDim.new(0, 5)
            tpBtnCorner.Parent = tpBtn

            tpBtn.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(wpData.Position)
                    notify("Teleport","Teleported to".. wpData.Name, Color3.fromRGB(80, 200, 120))
                end
            end)

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 60, 0, 26)
            delBtn.Position = UDim2.new(1, -65, 0.5, -13)
            delBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
            delBtn.BorderSizePixel = 0
            delBtn.Text ="Delete"
            delBtn.TextColor3 = Color3.fromRGB(170, 110, 110)
            delBtn.Font = Enum.Font.GothamMedium
            delBtn.TextSize = 10
            delBtn.Parent = wpFrame

            local delBtnCorner = Instance.new("UICorner")
            delBtnCorner.CornerRadius = UDim.new(0, 5)
            delBtnCorner.Parent = delBtn

            delBtn.MouseButton1Click:Connect(function()
                Nebula.TeleportPoints[wpName] = nil
                refreshWaypointList()
                notify("Teleport","Deleted".. wpData.Name, Color3.fromRGB(255, 90, 90))
            end)
        end
    end

    AddWaypointBtn.MouseButton1Click:Connect(function()
        local name = WaypointNameBox.Text
        if name ==""then
            name ="Point_".. wpCounter
            wpCounter = wpCounter + 1
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            Nebula.TeleportPoints[name .."_".. tostring(os.clock())] = {Position = char.HumanoidRootPart.Position, Name = name}
            WaypointNameBox.Text =""
            refreshWaypointList()
            notify("Teleport","Waypoint'".. name .."'added!", Color3.fromRGB(80, 200, 120))
        end
    end)
end

createLabel("JOUEURS & INSPECTOR", JoueurContent)
createToggle("Player Inspector (Right-Click)", false, function(enabled)
    V.RightClickInspect = enabled
    notify("Joueur","Player Inspector (Clic Droit)".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, JoueurContent,"RightClickInspect")
do
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, 0, 0, 34)
    SearchBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    SearchBox.BorderSizePixel = 0
    SearchBox.PlaceholderText ="Rechercher un joueur..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    SearchBox.Text =""
    SearchBox.TextColor3 = Color3.fromRGB(210, 210, 222)
    SearchBox.Font = Enum.Font.GothamMedium
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = JoueurContent

    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingLeft = UDim.new(0, 10)
    SearchPadding.Parent = SearchBox

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, 0, 1, -45)
    PlayerList.BackgroundTransparency = 1
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PlayerList.ScrollBarThickness = 2
    PlayerList.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 55)
    PlayerList.Parent = JoueurContent

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Padding = UDim.new(0, 5)
    PlayerListLayout.Parent = PlayerList

    _G.teleportToPlayer = function(targetPlayer)
        pcall(function()
            local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local tChar = targetPlayer.Character
            if not myChar or not tChar then return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart
            local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar.PrimaryPart
            if myRoot and tRoot then
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 2, 2)
                notify("Teleport","Téléporté à".. targetPlayer.Name, Color3.fromRGB(80, 200, 120))
            end
        end)
    end
    local teleportToPlayer = _G.teleportToPlayer

    _G.stopAttach = function()
        V.Attached = nil
        if V.AttachConn then
            pcall(function() V.AttachConn:Disconnect() end)
            V.AttachConn = nil
        end
        notify("Player", "Détaché du joueur", Color3.fromRGB(255, 90, 90))
    end
    local stopAttach = _G.stopAttach

    _G.startAttach = function(player)
        if not player then return end
        if V.Attached then
            stopAttach()
        end
        V.Attached = player
        V.AttachConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                if not V.Attached or not V.Attached.Parent then
                    stopAttach()
                    return
                end
                local myChar = LocalPlayer.Character
                local tChar = V.Attached.Character
                if myChar and tChar then
                    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    if myRoot and tRoot then
                        myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.2)
                    end
                end
            end)
        end)
        addConnection(V.AttachConn)
        notify("Player", "Attaché à " .. player.Name, Color3.fromRGB(80, 200, 120))
    end
    local startAttach = _G.startAttach

    _G.toggleAttach = function(player)
        if V.Attached and (V.Attached == player or player == nil) then
            stopAttach()
        else
            startAttach(player)
        end
    end
    _G.sitInSeat = function(hum, hrp, seat)
        if not hum or not hrp or not seat then return false end
        pcall(function()
            hum.Sit = false
            hum.PlatformStand = false
            local myChar = hum.Parent
            if myChar then
                for _, v in ipairs(myChar:GetDescendants()) do
                    if v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("Snap") then
                        if v.Name == "SeatWeld" or (v.Part0 and (v.Part0:IsA("Seat") or v.Part0:IsA("VehicleSeat"))) or (v.Part1 and (v.Part1:IsA("Seat") or v.Part1:IsA("VehicleSeat"))) then
                            pcall(function() v:Destroy() end)
                        end
                    end
                end
            end
            if seat:FindFirstChild("SeatWeld") then
                pcall(function() seat.SeatWeld:Destroy() end)
            end
        end)
        hrp.CFrame = seat.CFrame
        task.wait(0.01)
        pcall(function() seat:Sit(hum) end)
        task.wait(0.02)
        if hum.SeatPart ~= seat then
            pcall(function() seat:Sit(hum) end)
        end
        return hum.SeatPart == seat
    end
    local sitInSeat = _G.sitInSeat

    _G.isSeatFree = function(seat)
        if not seat or not seat:IsA("BasePart") then return false end
        local occ = seat.Occupant
        if occ and occ.Parent and occ.Parent ~= LocalPlayer.Character then
            return false
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.SeatPart == seat then
                    return false
                end
            end
        end
        return true
    end
    local isSeatFree = _G.isSeatFree

    _G.warpToPlayerCar = function(targetPlayer)
        local success, err = pcall(function()
            if not targetPlayer then
                notify("Player", "Joueur introuvable !", Color3.fromRGB(255, 90, 90))
                return
            end

            local tChar = targetPlayer.Character
            if not tChar then
                notify("Player", targetPlayer.DisplayName .. " n'a pas de personnage !", Color3.fromRGB(255, 165, 0))
                return
            end

            local tHum = tChar:FindFirstChildOfClass("Humanoid")
            local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar.PrimaryPart
            if not tHum or not tRoot then
                notify("Player", "Personnage de " .. targetPlayer.DisplayName .. " incomplet !", Color3.fromRGB(255, 165, 0))
                return
            end

            local tSeat = tHum.SeatPart
            if not tSeat then
                for _, child in ipairs(tChar:GetDescendants()) do
                    if child:IsA("Weld") or child:IsA("WeldConstraint") then
                        local part0 = child.Part0
                        local part1 = child.Part1
                        if part0 and (part0:IsA("VehicleSeat") or part0:IsA("Seat")) then
                            tSeat = part0
                            break
                        elseif part1 and (part1:IsA("VehicleSeat") or part1:IsA("Seat")) then
                            tSeat = part1
                            break
                        end
                    end
                end
            end

            if not tSeat then
                
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
                        if obj.Occupant == tHum then
                            tSeat = obj
                            break
                        elseif (obj.Position - tRoot.Position).Magnitude < 5 then
                            tSeat = obj
                            break
                        end
                    end
                end
            end

            if not tSeat then
                notify("Player", targetPlayer.DisplayName .. " n'est pas dans un véhicule !", Color3.fromRGB(255, 165, 0))
                return
            end

            local veh = tSeat:FindFirstAncestorWhichIsA("Model") or tSeat.Parent
            if not veh then
                notify("Player", "Modèle de véhicule introuvable !", Color3.fromRGB(255, 90, 90))
                return
            end

            local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHum or not myHrp then return end

            local freeSeat = nil
            for _, obj in ipairs(veh:GetDescendants()) do
                if (obj:IsA("VehicleSeat") or obj:IsA("Seat")) and obj ~= tSeat then
                    if isSeatFree(obj) then
                        freeSeat = obj
                        break
                    end
                end
            end

            if freeSeat then
                if _G.sitInSeat then
                    _G.sitInSeat(myHum, myHrp, freeSeat)
                else
                    myHrp.CFrame = freeSeat.CFrame
                    task.wait(0.03)
                    pcall(function() freeSeat:Sit(myHum) end)
                end
                notify("Player", "TP dans la voiture de " .. targetPlayer.DisplayName .. " !", Color3.fromRGB(80, 200, 120))
            else
                local seatCF = tSeat.CFrame
                myHrp.CFrame = seatCF * CFrame.new(0, 4, 0)
                notify("Player", "Voiture de " .. targetPlayer.DisplayName .. " (1 place/Pleine) ! TP sur le véhicule.", Color3.fromRGB(255, 165, 0))
            end
        end)

        if not success then
            warn("[Nebula] Erreur WarpCar: " .. tostring(err))
            notify("Player", "Erreur lors du TP Voiture !", Color3.fromRGB(255, 90, 90))
        end
    end
    local warpToPlayerCar = _G.warpToPlayerCar

    local function refreshPlayerList()
        for _, child in pairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local searchTerm = SearchBox.Text:lower()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (searchTerm ==""or player.Name:lower():find(searchTerm) or player.DisplayName:lower():find(searchTerm)) then
                local PlayerFrame = Instance.new("Frame")
                PlayerFrame.Size = UDim2.new(1, 0, 0, 38)
                PlayerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                PlayerFrame.BorderSizePixel = 0
                PlayerFrame.Parent = PlayerList

                local PlayerFrameCorner = Instance.new("UICorner")
                PlayerFrameCorner.CornerRadius = UDim.new(0, 8)
                PlayerFrameCorner.Parent = PlayerFrame

                local PlayerName = Instance.new("TextLabel")
                PlayerName.Size = UDim2.new(0.3, 0, 1, 0)
                PlayerName.Position = UDim2.new(0, 10, 0, 0)
                PlayerName.BackgroundTransparency = 1
                PlayerName.Text = player.Name
                PlayerName.TextColor3 = Color3.fromRGB(195, 195, 208)
                PlayerName.Font = Enum.Font.GothamMedium
                PlayerName.TextSize = 12
                PlayerName.TextXAlignment = Enum.TextXAlignment.Left
                PlayerName.Parent = PlayerFrame

                local TeleportBtn = Instance.new("TextButton")
                TeleportBtn.Size = UDim2.new(0, 44, 0, 26)
                TeleportBtn.Position = UDim2.new(1, -248, 0.5, -13)
                TeleportBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                TeleportBtn.BorderSizePixel = 0
                TeleportBtn.Text ="TP"
                TeleportBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                TeleportBtn.Font = Enum.Font.GothamMedium
                TeleportBtn.TextSize = 10
                TeleportBtn.Parent = PlayerFrame

                local TeleportBtnCorner = Instance.new("UICorner")
                TeleportBtnCorner.CornerRadius = UDim.new(0, 5)
                TeleportBtnCorner.Parent = TeleportBtn
                TeleportBtn.MouseButton1Click:Connect(function() teleportToPlayer(player) end)

                local SpectateBtn = Instance.new("TextButton")
                SpectateBtn.Size = UDim2.new(0, 44, 0, 26)
                SpectateBtn.Position = UDim2.new(1, -201, 0.5, -13)
                SpectateBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                SpectateBtn.BorderSizePixel = 0
                SpectateBtn.Text ="Spec"
                SpectateBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                SpectateBtn.Font = Enum.Font.GothamMedium
                SpectateBtn.TextSize = 10
                SpectateBtn.Parent = PlayerFrame

                local SpectateBtnCorner = Instance.new("UICorner")
                SpectateBtnCorner.CornerRadius = UDim.new(0, 5)
                SpectateBtnCorner.Parent = SpectateBtn

                if V.Spectate and V.SelPlayer == player then
                    SpectateBtn.Text ="Stop"
                    SpectateBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    SpectateBtn.Text ="Spec"
                    SpectateBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                end

                SpectateBtn.MouseButton1Click:Connect(function()
                    if V.Spectate and V.SelPlayer == player then
                        stopSpectate()
                    else
                        if V.Spectate then stopSpectate() end
                        startSpectate(player)
                    end
                    refreshPlayerList()
                end)

                local FlingBtn = Instance.new("TextButton")
                FlingBtn.Size = UDim2.new(0, 44, 0, 26)
                FlingBtn.Position = UDim2.new(1, -154, 0.5, -13)
                FlingBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                FlingBtn.BorderSizePixel = 0
                FlingBtn.Text ="Fling"
                FlingBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                FlingBtn.Font = Enum.Font.GothamMedium
                FlingBtn.TextSize = 10
                FlingBtn.Parent = PlayerFrame

                local FlingBtnCorner = Instance.new("UICorner")
                FlingBtnCorner.CornerRadius = UDim.new(0, 5)
                FlingBtnCorner.Parent = FlingBtn

                if V.Flinging and V.FlingTarget == player then
                    FlingBtn.Text ="Stop"
                    FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    FlingBtn.Text ="Fling"
                    FlingBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                end

                FlingBtn.MouseButton1Click:Connect(function()
                    if V.Flinging and V.FlingTarget == player then
                        stopFling()
                    else
                        if V.Flinging then stopFling() end
                        startFling(player)
                    end
                    refreshPlayerList()
                end)

                local AttachBtn = Instance.new("TextButton")
                AttachBtn.Size = UDim2.new(0, 44, 0, 26)
                AttachBtn.Position = UDim2.new(1, -107, 0.5, -13)
                AttachBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                AttachBtn.BorderSizePixel = 0
                AttachBtn.Text ="Attach"
                AttachBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                AttachBtn.Font = Enum.Font.GothamMedium
                AttachBtn.TextSize = 10
                AttachBtn.Parent = PlayerFrame

                local AttachBtnCorner = Instance.new("UICorner")
                AttachBtnCorner.CornerRadius = UDim.new(0, 5)
                AttachBtnCorner.Parent = AttachBtn

                if V.Attached == player then
                    AttachBtn.Text ="Detach"
                    AttachBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    AttachBtn.Text ="Attach"
                    AttachBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                end

                AttachBtn.MouseButton1Click:Connect(function()
                    if _G.toggleAttach then
                        _G.toggleAttach(player)
                    else
                        if V.Attached == player then stopAttach() else startAttach(player) end
                    end
                    refreshPlayerList()
                end)

                local WarpCarBtn = Instance.new("TextButton")
                WarpCarBtn.Size = UDim2.new(0, 48, 0, 26)
                WarpCarBtn.Position = UDim2.new(1, -58, 0.5, -13)
                WarpCarBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                WarpCarBtn.BorderSizePixel = 0
                WarpCarBtn.Text ="Warp Car"
                WarpCarBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                WarpCarBtn.Font = Enum.Font.GothamMedium
                WarpCarBtn.TextSize = 10
                WarpCarBtn.Parent = PlayerFrame

                local WarpCarBtnCorner = Instance.new("UICorner")
                WarpCarBtnCorner.CornerRadius = UDim.new(0, 5)
                WarpCarBtnCorner.Parent = WarpCarBtn

                WarpCarBtn.MouseButton1Click:Connect(function()
                    if _G.warpToPlayerCar then
                        _G.warpToPlayerCar(player)
                    end
                end)

            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)

    task.spawn(function()
        while task.wait(5) do
            if PlayerList and PlayerList.Parent then
                refreshPlayerList()
            end
        end
    end)

    _G.refreshPlayerList = refreshPlayerList
    refreshPlayerList()
end

createLabel("SERVER ACTIONS & VISUALS", ServerContent)

skyPresets = {
    ["Purple Galaxy"] = {
        Bk ="rbxassetid://159454299", Dn ="rbxassetid://159454296", Ft ="rbxassetid://159454293",
        Lf ="rbxassetid://159454299", Rt ="rbxassetid://159454300", Up ="rbxassetid://159454288"
    },
    ["Vaporwave"] = {
        Bk ="rbxassetid://1417494402", Dn ="rbxassetid://1417494146", Ft ="rbxassetid://1417494253",
        Lf ="rbxassetid://1417494402", Rt ="rbxassetid://1417494499", Up ="rbxassetid://1417494643"
    }
}
skyList = {"Default","Purple Galaxy","Vaporwave"}
currentSkyIdx = 1
originalSkyObj = nil

function applyCustomSkybox(skyName)
    local Lighting = game:GetService("Lighting")
    local currentSky = Lighting:FindFirstChildOfClass("Sky")
    if not originalSkyObj and currentSky then originalSkyObj = currentSky:Clone() end
    
    if skyName =="Default"then
        if currentSky then currentSky:Destroy() end
        if originalSkyObj then originalSkyObj:Clone().Parent = Lighting end
        notify("Server","Skybox par défaut restaurée", Color3.fromRGB(80, 200, 120))
        return
    end

    if currentSky then currentSky:Destroy() end
    local newSky = Instance.new("Sky")
    newSky.Name ="NebulaCustomSky"
    local preset = skyPresets[skyName]
    if preset then
        newSky.SkyboxBk = preset.Bk
        newSky.SkyboxDn = preset.Dn
        newSky.SkyboxFt = preset.Ft
        newSky.SkyboxLf = preset.Lf
        newSky.SkyboxRt = preset.Rt
        newSky.SkyboxUp = preset.Up
        newSky.Parent = Lighting
        notify("Server","Skybox appliquée:".. skyName, Color3.fromRGB(80, 200, 120))
    end
end

skyBtnFrame, skyBtnObj, skyValue = createValueButton(ServerContent, "Custom Skybox", "Default", function()
    currentSkyIdx = (currentSkyIdx % #skyList) + 1
    local chosenSky = skyList[currentSkyIdx]
    applyCustomSkybox(chosenSky)
    return chosenSky
end)

createButton("Remove Map Particles & Smokes (FPS Boost)", function()
    local count = 0
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                obj:Destroy()
                count = count + 1
            end
        end
    end)
    notify("Server", count .."particules et fumées supprimées !", Color3.fromRGB(80, 200, 120))
end, ServerContent)

createToggle("Player Join/Leave Toast Notifs", false, function(enabled)
    V.PlayerJoinLeaveNotifs = enabled
    notify("Server","Notifs Join/Leave".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent,"PlayerJoinLeaveNotifs")
createButton("Rejoin Server", function()
    notify("Server","Rejoining server...", Color3.fromRGB(180, 180, 195))
    task.spawn(function()
        pcall(function()
            local target = { JobId = game.JobId }
            local ok, res = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId .."/servers/Public?limit=100")
            end)
            if ok and res then
                local servers = HttpService:JSONDecode(res)
                if servers and servers.data then
                    for _, v in ipairs(servers.data) do
                        if v.playing < v.maxPlayers and v.id ~= game.JobId then
                            target = { JobId = v.id }
                            break
                        end
                    end
                end
            end
            task.wait(0.3)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, target.JobId)
        end)
    end)
end, ServerContent)

function rejoinStorm()
    task.spawn(function()
        pcall(function()
            local target = { JobId = game.JobId }
            local ok, res = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId .."/servers/Public?limit=100")
            end)
            if ok and res then
                local stormServers = HttpService:JSONDecode(res)
                if stormServers and stormServers.data then
                    for _, v in ipairs(stormServers.data) do
                        if v.playing < v.maxPlayers and v.id ~= game.JobId then
                            target = { JobId = v.id }
                            break
                        end
                    end
                end
            end
            task.wait(0.3)
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, target.JobId)
            end)
        end)
    end)
end

createToggle("Auto Rejoin (On Kick/Crash)", false, function(enabled)
    V.AutoRejoin = enabled
    if enabled then
        notify("Server","Auto Rejoin ON", Color3.fromRGB(80, 200, 120))
        if not V.AutoRejoinConn then
            local coreGui = game:GetService("CoreGui")
            local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
            if promptGui then
                local promptOverlay = promptGui:FindFirstChild("promptOverlay")
                if promptOverlay then
                    V.AutoRejoinConn = promptOverlay.ChildAdded:Connect(function(child)
                        if child and child.Name =="ErrorPrompt"and V.AutoRejoin then
                            notify("Auto Rejoin","Kick/Crash détecté ! Reconnexion...", Color3.fromRGB(255, 165, 0))
                            rejoinStorm()
                        end
                    end)
                    addConnection(V.AutoRejoinConn)
                end
            end
        end
    else
        if V.AutoRejoinConn then V.AutoRejoinConn:Disconnect() V.AutoRejoinConn = nil end
        notify("Server","Auto Rejoin OFF", Color3.fromRGB(255, 90, 90))
    end
end, ServerContent,"AutoRejoin")

createToggle("Anti-Kick (Rejoin Storm)", false, function(enabled)
    V.AntiKick = enabled
    if enabled then
        notify("Server","Anti-Kick ON (soufflerie de rejoins)", Color3.fromRGB(80, 200, 120))
        if not V.AntiKickConn then
            local coreGui = game:GetService("CoreGui")
            local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
            if promptGui then
                local promptOverlay = promptGui:FindFirstChild("promptOverlay")
                if promptOverlay then
                    V.AntiKickConn = promptOverlay.ChildAdded:Connect(function(child)
                        if child and child.Name =="ErrorPrompt"and V.AntiKick then
                            notify("Anti-Kick","Kick détecté ! Rejoin Storm...", Color3.fromRGB(255, 165, 0))
                            rejoinStorm()
                        end
                    end)
                    addConnection(V.AntiKickConn)
                end
            end
        end
    else
        if V.AntiKickConn then V.AntiKickConn:Disconnect() V.AntiKickConn = nil end
        notify("Server","Anti-Kick OFF", Color3.fromRGB(255, 90, 90))
    end
end, ServerContent,"AntiKick")

createButton("Solo Server (Least Populated)", function()
    notify("Server","Recherche du serveur le plus vide...", Color3.fromRGB(180, 180, 195))
    task.spawn(function()
        pcall(function()
            local cursor =""
            local bestServer = nil
            local lowestPlayers = math.huge
            
            for page = 1, 3 do
                local url ="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                if cursor ~=""then
                    url = url .."&cursor=".. cursor
                end
                
                local success, response = pcall(function()
                    return HttpService:JSONDecode(game:HttpGet(url))
                end)
                
                if success and response and response.data then
                    for _, v in ipairs(response.data) do
                        if v.id ~= game.JobId and v.playing < v.maxPlayers then
                            if v.playing < lowestPlayers then
                                lowestPlayers = v.playing
                                bestServer = v
                            end
                            if lowestPlayers == 0 then
                                break
                            end
                        end
                    end
                    
                    if lowestPlayers == 0 and bestServer then
                        break
                    end
                    
                    if response.nextPageCursor then
                        cursor = response.nextPageCursor
                    else
                        break
                    end
                else
                    break
                end
            end
            
            if bestServer then
                notify("Server","Serveur trouvé avec".. lowestPlayers .."joueur(s). Téléportation...", Color3.fromRGB(80, 200, 120))
                TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, LocalPlayer)
            else
                notify("Server","Aucun serveur disponible trouvé.", Color3.fromRGB(255, 90, 90))
            end
        end)
    end)
end, ServerContent)

createButton("Server Hop (Random)", function()
    notify("Server","Hopping server...", Color3.fromRGB(180, 180, 195))
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in ipairs(servers.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            end
        end
        notify("Server","No other server found.", Color3.fromRGB(255, 165, 0))
    end)
end, ServerContent)



createLabel("TIME & VISUALS", ServerContent)
createSlider("Time (0-24h)", 0, 24, 14, function(val)
    Lighting.ClockTime = val
end, ServerContent)

createToggle("Fullbright", false, function(enabled) toggleFullbright(enabled) end, ServerContent,"Fullbright")
createToggle("FPS Booster (Max Boost)", false, function(enabled) toggleFPSBooster(enabled) end, ServerContent,"FPSBoost")

createLabel("CAMERA", ServerContent)
createToggle("Force First Person", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    else
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
    notify("Server","First Person".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent,"Force1st")

createToggle("Force Third Person", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
    notify("Server","Third Person".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent,"Force3rd")

createToggle("Unlock Camera Zoom", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMaxZoomDistance = 1000
        LocalPlayer.CameraMinZoomDistance = 0.5
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
    notify("Server","Zoom Unlock".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent,"UnlockZoom")

function tpToAimVehicleSeat(forced)
    if not forced and not V.VehicleSeatTP then return end
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        local targetVeh = nil
        local targetSeat = nil

        local mouse = LocalPlayer:GetMouse()
        local hit = mouse and mouse.Target
        if hit then
            if hit:IsA("VehicleSeat") or hit:IsA("Seat") then
                targetSeat = hit
                targetVeh = hit:FindFirstAncestorWhichIsA("Model") or hit.Parent
            else
                local curr = hit
                while curr and curr ~= workspace do
                    if curr:IsA("Model") then
                        for _, child in pairs(curr:GetDescendants()) do
                            if child:IsA("VehicleSeat") or child:IsA("Seat") then
                                targetSeat = child
                                targetVeh = curr
                                break
                            end
                        end
                    end
                    if targetSeat then break end
                    curr = curr.Parent
                end
            end
        end

        if not targetSeat then
            local closestDist = 70
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        targetSeat = obj
                        targetVeh = obj:FindFirstAncestorWhichIsA("Model") or obj.Parent
                    end
                end
            end
        end

        if not targetSeat then
            notify("Vehicle", "Vise un véhicule ou approche-toi d'un siège !", Color3.fromRGB(255, 165, 0))
            return
        end

        if _G.sitInSeat then
            _G.sitInSeat(hum, hrp, targetSeat)
        else
            hum.Sit = false
            hum.PlatformStand = false
            task.wait(0.02)
            hrp.CFrame = targetSeat.CFrame
            task.wait(0.04)
            pcall(function() targetSeat:Sit(hum) end)
        end
        notify("Vehicle", "TP Réussi dans le siège !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.tpToAimVehicleSeat = tpToAimVehicleSeat

initStep = "cablage Vehicle/Fun"
createLabel("VEHICLE MODIFICATIONS", VehicleContent)

createButton("TP Véhicule Auto Seat (Touche J)", function()
    if _G.tpToAimVehicleSeat then
        _G.tpToAimVehicleSeat(true)
    end
end, VehicleContent)

createSlider("Vehicle Speed Multiplier", 1, 10, 1, function(val)
    V.VehicleSpeed = val
end, VehicleContent,"VehicleSpeed")

createToggle("Vehicle Fly", false, function(enabled)
    V.VehicleFly = enabled
    notify("Vehicle","Vehicle Fly".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent,"VehicleFly")
createSlider("Vehicle Fly Speed", 50, 500, 150, function(val) V.VehicleFlySpeed = val end, VehicleContent,"VehicleFlySpeed")

createSlider("Vehicle Boost Speed", 50, 1000, 250, function(val) V.VehicleBoostSpeed = val end, VehicleContent,"VehicleBoostSpeed")

createToggle("Vehicle Noclip", false, function(enabled)
    V.VehicleNoclip = enabled
    notify("Vehicle","Vehicle Noclip".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent,"VehicleNoclip")

function flipVehicle()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then
            notify("Vehicle","Tu dois être dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = seat.Parent:IsA("Model") and seat.Parent or seat
        local primary = (veh:IsA("Model") and veh.PrimaryPart) or seat

        local pos = primary.Position
        local rx, ry, rz = primary.CFrame:ToOrientation()
        local uprightCF = CFrame.new(pos + Vector3.new(0, 3, 0)) * CFrame.Angles(0, ry, 0)

        if veh:IsA("Model") and veh.PrimaryPart then
            veh:SetPrimaryPartCFrame(uprightCF)
        else
            primary.CFrame = uprightCF
        end

        for _, part in pairs(veh:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end

        notify("Vehicle","Véhicule remis droit sur ses roues !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.flipVehicle = flipVehicle

createButton("Remettre le Véhicule Droit (Auto-Flip)", function()
    flipVehicle()
end, VehicleContent)

createButton("Explode / Propulser Véhicule (Touche L)", function()
    explodeVehicle()
end, VehicleContent)

function explodeVehicle()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local seat = hum and hum.SeatPart

        if not seat then return end

        local veh = seat:FindFirstAncestorWhichIsA("Model") or seat.Parent
        if not veh then return end

        if not seat:IsA("VehicleSeat") then
            local driverSeat = nil
            for _, obj in ipairs(veh:GetDescendants()) do
                if obj:IsA("VehicleSeat") then
                    if _G.isSeatFree and _G.isSeatFree(obj) then
                        driverSeat = obj
                        break
                    end
                end
            end

            if driverSeat then
                if _G.sitInSeat then
                    _G.sitInSeat(hum, hrp, driverSeat)
                else
                    pcall(function() driverSeat:Sit(hum) end)
                end
                task.wait(0.03)
                seat = hum and hum.SeatPart
            end
        end

        if not seat or not seat:IsA("VehicleSeat") then return end

        notify("Vehicle", "Explode Véhicule !", Color3.fromRGB(255, 90, 90))

        local randX = math.random(-30000, 30000)
        local randY = math.random(20000, 45000)
        local randZ = math.random(-30000, 30000)
        local launchVel = Vector3.new(randX, randY, randZ)
        local launchRot = Vector3.new(math.random(-8000, 8000), math.random(-8000, 8000), math.random(-8000, 8000))

        pcall(function() hum.PlatformStand = true end)

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e12, 1e12, 1e12)
        bv.Velocity = launchVel
        bv.Parent = hrp

        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(1e12, 1e12, 1e12)
        bav.AngularVelocity = launchRot
        bav.Parent = hrp

        local bvSeat = Instance.new("BodyVelocity")
        bvSeat.MaxForce = Vector3.new(1e12, 1e12, 1e12)
        bvSeat.Velocity = launchVel
        bvSeat.Parent = seat

        Debris:AddItem(bv, 0.6)
        Debris:AddItem(bav, 0.6)
        Debris:AddItem(bvSeat, 0.6)

        task.spawn(function()
            local startTime = os.clock()
            while os.clock() - startTime < 0.6 do
                pcall(function()
                    if hrp and hrp.Parent then
                        hrp.AssemblyLinearVelocity = launchVel
                        hrp.AssemblyAngularVelocity = launchRot
                    end
                    if seat and seat.Parent then
                        seat.AssemblyLinearVelocity = launchVel
                        seat.AssemblyAngularVelocity = launchRot
                    end
                    for _, p in ipairs(veh:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.AssemblyLinearVelocity = launchVel
                            p.AssemblyAngularVelocity = launchRot
                        end
                    end
                end)
                task.wait(0.01)
            end
            task.wait(0.2)
            pcall(function() hum.PlatformStand = false end)
        end)
    end)
end
_G.explodeVehicle = explodeVehicle

task.spawn(function()
    local lastSeat = nil
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            if seat then
                if seat ~= lastSeat then
                    lastSeat = seat
                    if V.VehicleExplodeEnabled == true then
                        explodeVehicle()
                    end
                end
            else
                lastSeat = nil
            end
        end)
    end
end)

function spawnInstantRamp()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local refCF = seat and seat.CFrame or hrp.CFrame
        local rampPos = refCF * CFrame.new(0, -1, -12) * CFrame.Angles(math.rad(28), 0, 0)

        local ramp = Instance.new("Part")
        ramp.Name = "Nebula_InstantRamp"
        ramp.Size = Vector3.new(14, 1, 24)
        ramp.CFrame = rampPos
        ramp.Anchored = true
        ramp.CanCollide = true
        ramp.Material = Enum.Material.Neon
        ramp.Color = Color3.fromRGB(140, 80, 255)
        ramp.Parent = workspace

        local stroke = Instance.new("SelectionBox")
        stroke.Color3 = Color3.fromRGB(0, 230, 255)
        stroke.Adornee = ramp
        stroke.Parent = ramp

        Debris:AddItem(ramp, 8)
        notify("Vehicle", "Tremplin Instantané déployé devant vous ! (U)", Color3.fromRGB(80, 200, 120))
    end)
end
_G.spawnInstantRamp = spawnInstantRamp

createButton("Instant Ramp Spawner (Touche U)", function()
    spawnInstantRamp()
end, VehicleContent)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.U then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            spawnInstantRamp()
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Nebula_InstantRamp" then
                obj:Destroy()
            end
        end
    end)
end)

function toggleCarCarry()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local targetVeh = nil
        local targetPos = V.Freecam and Camera.CFrame.Position or hrp.Position
        
        local rayOrigin = Camera.CFrame.Position
        local rayDirection = Camera.CFrame.LookVector * (V.Freecam and 2500 or 200)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        params.IgnoreWater = true
        
        local result = workspace:Raycast(rayOrigin, rayDirection, params)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorWhichIsA("Model")
            if model then
                local seat = model:FindFirstChildOfClass("VehicleSeat") or model:FindFirstChildOfClass("Seat")
                if seat or model:FindFirstChild("Drive") or model:FindFirstChild("Engine") then
                    targetVeh = model
                end
            end
        end

        if not targetVeh then
            local closestDist = V.Freecam and 300 or 60
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj ~= char then
                    local seat = obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChildOfClass("Seat")
                    if seat then
                        local primary = obj.PrimaryPart or seat
                        local dist = (primary.Position - targetPos).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            targetVeh = obj
                        end
                    end
                end
            end
        end

        if not targetVeh then
            notify("Vehicle", V.Freecam and "Vise un véhicule avec la Freecam !" or "Approche-toi d'un véhicule (moins de 60 studs) !", Color3.fromRGB(255, 165, 0))
            return
        end

        local lookVec = Camera.CFrame.LookVector
        local launchVel = (lookVec * 450) + Vector3.new(0, 65, 0)
        local launchRot = Vector3.new(math.random(-35, 35), math.random(-25, 25), math.random(-35, 35))

        pcall(function()
            for _, part in pairs(targetVeh:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                    part.CanCollide = true
                    part.LocalTransparencyModifier = 0
                    part.AssemblyLinearVelocity = launchVel
                    part.AssemblyAngularVelocity = launchRot
                end
            end
        end)

        notify("Vehicle", "🚀 VÉHICULE PROJETÉ À SUPER VITESSE !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.toggleCarCarry = toggleCarCarry

createButton("Propulser Véhicule Visé (Touche P)", function()
    toggleCarCarry()
end, VehicleContent)

function vehicleBoost()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then
            notify("Vehicle","Tu dois être dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        if V.VehicleBoostVel then
            pcall(function() V.VehicleBoostVel:Destroy() end)
            V.VehicleBoostVel = nil
        end
        local veh = seat.Parent:IsA("Model") and seat.Parent or seat
        local root = (veh:IsA("Model") and veh.PrimaryPart) or seat
        local boostDir = Camera.CFrame.LookVector
        if boostDir.Magnitude < 0.001 then boostDir = seat.CFrame.LookVector end
        boostDir = boostDir.Unit
        local bv = Instance.new("BodyVelocity")
        bv.Name ="NebulaBoostVel"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = boostDir * (V.VehicleBoostSpeed or 250)
        bv.Parent = root
        V.VehicleBoostVel = bv
        Debris:AddItem(bv, 1.2)
        V.VehicleBoostEnd = os.clock() + 1.2
        notify("Vehicle","BOOST !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.vehicleBoost = vehicleBoost

function instantBrake()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then
            notify("Vehicle","Tu dois être dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = seat.Parent:IsA("Model") and seat.Parent or seat
        for _, part in pairs(veh:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
        if V.VehicleBoostVel then
            pcall(function() V.VehicleBoostVel:Destroy() end)
            V.VehicleBoostVel = nil
        end
        notify("Vehicle","Freinage instantané !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.instantBrake = instantBrake

createButton("Vehicle Boost (Touche T)", function()
    vehicleBoost()
end, VehicleContent)
createButton("Freinage Instantané (Touche N)", function()
    instantBrake()
end, VehicleContent)

if V.VehicleBoostHoldConn then V.VehicleBoostHoldConn:Disconnect() end
V.VehicleBoostHoldConn = UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Keybinds.VehicleBoost then
        vehicleBoost()
        if V.VehicleBoostHoldTask then return end
        V.VehicleBoostHoldTask = task.spawn(function()
            while UserInputService:IsKeyDown(Keybinds.VehicleBoost) do
                task.wait(0.15)
                vehicleBoost()
            end
            V.VehicleBoostHoldTask = nil
        end)
    end
end)
if V.VehicleBoostEndConn then V.VehicleBoostEndConn:Disconnect() end
V.VehicleBoostEndConn = UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Keybinds.VehicleBoost then
        if V.VehicleBoostHoldTask then
            task.cancel(V.VehicleBoostHoldTask)
            V.VehicleBoostHoldTask = nil
        end
    end
end)



task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                if not seat:GetAttribute("_NebulaOrigMaxSpeed") then
                    seat:SetAttribute("_NebulaOrigMaxSpeed", seat.MaxSpeed)
                    seat:SetAttribute("_NebulaOrigTorque", seat.Torque)
                end
                local origSpeed = seat:GetAttribute("_NebulaOrigMaxSpeed") or seat.MaxSpeed
                local origTorque = seat:GetAttribute("_NebulaOrigTorque") or seat.Torque

                if V.VehicleSpeed and V.VehicleSpeed > 1 then
                    seat.MaxSpeed = origSpeed * V.VehicleSpeed
                    seat.Torque = origTorque * V.VehicleSpeed

                    local isForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Z) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
                    local isBackward = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)

                    if isForward and not isBackward then
                        local lookVec = seat.CFrame.LookVector
                        local fwdDir = Vector3.new(lookVec.X, 0, lookVec.Z).Unit
                        local currentVel = seat.AssemblyLinearVelocity
                        local hSpeed = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
                        if hSpeed < (40 * V.VehicleSpeed) then
                            seat.AssemblyLinearVelocity = currentVel + fwdDir * ((V.VehicleSpeed - 1) * 2)
                        end
                    elseif isBackward and not isForward then
                        local lookVec = seat.CFrame.LookVector
                        local bwdDir = -Vector3.new(lookVec.X, 0, lookVec.Z).Unit
                        local currentVel = seat.AssemblyLinearVelocity
                        local hSpeed = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
                        if hSpeed < (40 * V.VehicleSpeed) then
                            seat.AssemblyLinearVelocity = currentVel + bwdDir * ((V.VehicleSpeed - 1) * 2)
                        end
                    end
                else
                    seat.MaxSpeed = origSpeed
                    seat.Torque = origTorque
                end
            end
        end)
        if V.VehicleFly then
            V._VehFlyCleanedUp = false
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if seat then
                    local root = seat.Parent:IsA("Model") and (seat.Parent.PrimaryPart or seat) or seat
                    local vehModel = seat.Parent:IsA("Model") and seat.Parent or nil
                    
                    local bg = root:FindFirstChild("VehFlyGyro") or Instance.new("BodyGyro")
                    bg.Name ="VehFlyGyro"
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.P = 9e4
                    bg.D = 500
                    bg.CFrame = Camera.CFrame
                    bg.Parent = root
                    
                    local bv = root:FindFirstChild("VehFlyVel") or Instance.new("BodyVelocity")
                    bv.Name ="VehFlyVel"
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Parent = root
                    
                    local rootVel = root.AssemblyLinearVelocity
                    if vehModel then
                        for _, part in pairs(vehModel:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                part.AssemblyLinearVelocity = rootVel
                            end
                        end
                    end
                    
                    local camCF = Camera.CFrame
                    local moveDir = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.Z) or UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end
                    
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = moveDir.Unit * (V.VehicleFlySpeed or 150)
                    else
                        bv.Velocity = Vector3.new(0, 0, 0)
                    end
                    bg.CFrame = camCF
                end
            end)
        elseif not V._VehFlyCleanedUp then
            V._VehFlyCleanedUp = true
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if seat then
                    local root = seat.Parent:IsA("Model") and (seat.Parent.PrimaryPart or seat) or seat
                    if root:FindFirstChild("VehFlyGyro") then root.VehFlyGyro:Destroy() end
                    if root:FindFirstChild("VehFlyVel") then root.VehFlyVel:Destroy() end
                end
            end)
        end
        
        if V.VehicleNoclip then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if seat then
                    local veh = seat.Parent
                    if veh then
                        for _, part in pairs(veh:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    seat.CanCollide = false
                    if char then
                        for _, p in pairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end
end)

createLabel("Fun", FunContent)
createToggle("Click TP (Épée)", false, function(enabled) toggleClickTP(enabled) end, FunContent,"ClickTP")

createToggle("Ragdoll Mode (Ragdoll Volontaire)", false, function(enabled)
    pcall(function()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = enabled
            if enabled then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                notify("Fun","Ragdoll Mode ACTIVÉ", Color3.fromRGB(80, 200, 120))
            else
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                notify("Fun","Ragdoll Mode DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
            end
        end
    end)
end, FunContent,"RagdollMode")

createSlider("Spin Bot Speed", 10, 1000, 100, function(val) V.SpinSpeed = val end, FunContent,"SpinSpeed")
createToggle("Spin Bot (Toupie)", false, function(enabled)
    V.Spin = enabled
    if enabled then
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.AutoRotate = false end

        V.SpinConn = RunService.Heartbeat:Connect(function(dt)
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local spinAngle = math.rad(V.SpinSpeed * dt * 10)
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, spinAngle, 0)
                end
            end)
        end)
        addConnection(V.SpinConn)
        notify("Fun","Spin Bot ON", Color3.fromRGB(80, 200, 120))
    else
        if V.SpinConn then V.SpinConn:Disconnect() V.SpinConn = nil end
        pcall(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = true end
        end)
        notify("Fun","Spin Bot OFF", Color3.fromRGB(255, 90, 90))
    end
end, FunContent,"Spin")

createLabel("PRE-MADE SCRIPTS", ScriptsContent)
do
    local ScriptScroll = Instance.new("ScrollingFrame")
    ScriptScroll.Size = UDim2.new(1, 0, 1, -30)
    ScriptScroll.Position = UDim2.new(0, 0, 0, 30)
    ScriptScroll.BackgroundTransparency = 1
    ScriptScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScriptScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScriptScroll.ScrollBarThickness = 2
    ScriptScroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 55)
    ScriptScroll.Parent = ScriptsContent

    local ScriptListLayout = Instance.new("UIListLayout")
    ScriptListLayout.Padding = UDim.new(0, 5)
    ScriptListLayout.Parent = ScriptScroll

    local function destroyGuiByName(guiName)
        for _, child in pairs(parentTarget:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == guiName then
                child:Destroy()
            end
        end
    end

    local ScriptsList = {
        { 
            Name ="Flick", 
            Code = flick_script, 
            Destroy = function() 
                destroyGuiByName("EternalFlick_GUI")
                if V.HitboxConn then V.HitboxConn:Disconnect() V.HitboxConn = nil end
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("Head") then
                        local h = p.Character.Head
                        h.Size = Vector3.new(2,1,1)
                        h.Transparency = 0
                        h.CanCollide = false
                    end
                end
            end 
        },
        { 
            Name ="Murder Mystery",
            Code = murder_mystery, 
            Destroy = function() 
                destroyGuiByName("UpdateGui")
            end 
        },
        { 
            Name ="Grow Garden 2", 
            Code = grow_garden, 
            Destroy = function() 
                destroyGuiByName("UpdateGui")
                if _G.Nebula_OrigFogEnd then
                    Lighting.FogEnd = _G.Nebula_OrigFogEnd
                    Lighting.FogStart = _G.Nebula_OrigFogStart
                else
                    Lighting.FogEnd = 100000
                    Lighting.FogStart = 0
                end
            end 
        },
        { 
            Name ="Tsunami Brainrot", 
            Code = tsunami_brainrot, 
            Destroy = function() 
                destroyGuiByName("UpdateGui")
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                end
            end 
        }
    }

    for _, scriptData in ipairs(ScriptsList) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 38)
        row.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        row.BorderSizePixel = 0
        row.Parent = ScriptScroll

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 8)
        rowCorner.Parent = row

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = scriptData.Name
        lbl.TextColor3 = Color3.fromRGB(195, 195, 208)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 60, 0, 26)
        loadBtn.Position = UDim2.new(1, -130, 0.5, -13)
        loadBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        loadBtn.BorderSizePixel = 0
        loadBtn.Text ="Load"
        loadBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
        loadBtn.Font = Enum.Font.GothamMedium
        loadBtn.TextSize = 11
        loadBtn.Parent = row

        local loadCorner = Instance.new("UICorner")
        loadCorner.CornerRadius = UDim.new(0, 5)
        loadCorner.Parent = loadBtn

        local destBtn = Instance.new("TextButton")
        destBtn.Size = UDim2.new(0, 60, 0, 26)
        destBtn.Position = UDim2.new(1, -65, 0.5, -13)
        destBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
        destBtn.BorderSizePixel = 0
        destBtn.Text ="Destroy"
        destBtn.TextColor3 = Color3.fromRGB(170, 110, 110)
        destBtn.Font = Enum.Font.GothamMedium
        destBtn.TextSize = 10
        destBtn.Parent = row

        local destCorner = Instance.new("UICorner")
        destCorner.CornerRadius = UDim.new(0, 5)
        destCorner.Parent = destBtn

        loadBtn.MouseButton1Click:Connect(function()
            pcall(function()
                loadstring(scriptData.Code)()
            end)
            notify("Scripts", scriptData.Name .."loaded!", Color3.fromRGB(80, 200, 120))
        end)

        destBtn.MouseButton1Click:Connect(function()
            pcall(scriptData.Destroy)
            notify("Scripts", scriptData.Name .."destroyed!", Color3.fromRGB(255, 90, 90))
        end)
    end
end

initStep = "cablage Scripts/Settings"
createLabel("THEME & INTERFACE", SettingsContent)

themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(1, 0, 0, 44)
themeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
themeFrame.BorderSizePixel = 0
themeFrame.Parent = SettingsContent
tfc = Instance.new("UICorner", themeFrame)
tfc.CornerRadius = UDim.new(0, 8)

themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(0.4, 0, 1, 0)
themeLabel.Position = UDim2.new(0, 14, 0, 0)
themeLabel.BackgroundTransparency = 1
themeLabel.Text ="GUI Accent Color"
themeLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
themeLabel.Font = Enum.Font.GothamMedium
themeLabel.TextSize = 13
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = themeFrame

function updateThemeAccent(col)
    V.AccentColor = col
    if setAccentColor then
        pcall(function() setAccentColor(col) end)
    end
    notify("Theme","Couleur d'accentuation mise à jour !", col)
end

themeColors = {
    {Name ="Bleu", Color = Color3.fromRGB(60, 160, 255)},
    {Name ="Violet", Color = Color3.fromRGB(160, 90, 255)},
    {Name ="Rouge", Color = Color3.fromRGB(255, 60, 80)},
    {Name ="Vert", Color = Color3.fromRGB(0, 230, 120)}
}

for i, tCol in ipairs(themeColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.Position = UDim2.new(1, -125 + (i-1)*30, 0.5, -13)
    btn.BackgroundColor3 = tCol.Color
    btn.BorderSizePixel = 0
    btn.Text =""
    btn.Parent = themeFrame
    local bc = Instance.new("UICorner", btn)
    bc.CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(function() updateThemeAccent(tCol.Color) end)
end

do
    local KeybindHUDFrame = Instance.new("Frame")
    KeybindHUDFrame.Name ="NebulaKeybindHUD"
    KeybindHUDFrame.Size = UDim2.new(0, 190, 0, 220)
    KeybindHUDFrame.Position = UDim2.new(1, -200, 0.25, 0)
    KeybindHUDFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    KeybindHUDFrame.BackgroundTransparency = 0.1
    KeybindHUDFrame.BorderSizePixel = 0
    KeybindHUDFrame.Visible = false
    KeybindHUDFrame.Active = true
    KeybindHUDFrame.Draggable = true
    KeybindHUDFrame.Parent = ScreenGui

    local khc = Instance.new("UICorner", KeybindHUDFrame)
    khc.CornerRadius = UDim.new(0, 10)

    local khStroke = Instance.new("UIStroke", KeybindHUDFrame)
    khStroke.Color = Color3.fromRGB(60, 60, 75)
    khStroke.Thickness = 1.2

    local khHeader = Instance.new("Frame")
    khHeader.Size = UDim2.new(1, 0, 0, 32)
    khHeader.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    khHeader.BorderSizePixel = 0
    khHeader.Parent = KeybindHUDFrame
    local khcHeader = Instance.new("UICorner", khHeader)
    khcHeader.CornerRadius = UDim.new(0, 10)

    local khTitle = Instance.new("TextLabel")
    khTitle.Size = UDim2.new(1, -20, 1, 0)
    khTitle.Position = UDim2.new(0, 12, 0, 0)
    khTitle.BackgroundTransparency = 1
    khTitle.Text ="⌨ KEYBINDS HUD"
    khTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    khTitle.Font = Enum.Font.GothamBold
    khTitle.TextSize = 11
    khTitle.TextXAlignment = Enum.TextXAlignment.Left
    khTitle.Parent = khHeader

    local khContent = Instance.new("ScrollingFrame")
    khContent.Size = UDim2.new(1, -16, 1, -40)
    khContent.Position = UDim2.new(0, 8, 0, 36)
    khContent.BackgroundTransparency = 1
    khContent.BorderSizePixel = 0
    khContent.ScrollBarThickness = 2
    khContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    khContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    khContent.Parent = KeybindHUDFrame

    local khLayout = Instance.new("UIListLayout", khContent)
    khLayout.Padding = UDim.new(0, 4)

    createToggle("Keybind List Overlay", false, function(enabled)
        V.KeybindHUD = enabled
        KeybindHUDFrame.Visible = enabled
        if enabled then notify("Settings","Keybind HUD ON", Color3.fromRGB(80, 200, 120)) end
    end, SettingsContent,"KeybindHUD")

    task.spawn(function()
        while task.wait(0.2) do
            if V.KeybindHUD then
                for _, child in pairs(khContent:GetChildren()) do
                    if child:IsA("Frame") then child:Destroy() end
                end
                for name, key in pairs(Keybinds) do
                    local active = false
                    if name =="Fly"and V.Fly then active = true
                    elseif name =="Noclip"and V.Noclip then active = true
                    elseif name =="Invisible"and V.Invis then active = true
                    elseif name =="DesyncFly"and V.DesyncFly then active = true
                    elseif name =="ESP"and V.ESP then active = true
                    elseif name =="Speed"and V.SpeedEnabled then active = true
                    elseif name =="Freecam"and FreecamMenu and FreecamMenu.Enabled then active = true
                    end

                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 24)
                    row.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
                    row.BorderSizePixel = 0
                    row.Parent = khContent
                    local rc = Instance.new("UICorner", row)
                    rc.CornerRadius = UDim.new(0, 5)

                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(0.65, 0, 1, 0)
                    lbl.Position = UDim2.new(0, 8, 0, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = name .."[".. key.Name .."]"
                    lbl.TextColor3 = Color3.fromRGB(190, 190, 205)
                    lbl.Font = Enum.Font.GothamMedium
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.Parent = row

                    local statusBadge = Instance.new("TextLabel")
                    statusBadge.Size = UDim2.new(0, 42, 0, 16)
                    statusBadge.Position = UDim2.new(1, -48, 0.5, -8)
                    statusBadge.BackgroundColor3 = active and Color3.fromRGB(20, 80, 40) or Color3.fromRGB(35, 35, 45)
                    statusBadge.Text = active and"ON"or"OFF"
                    statusBadge.TextColor3 = active and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(140, 140, 155)
                    statusBadge.Font = Enum.Font.GothamBold
                    statusBadge.TextSize = 9
                    statusBadge.BorderSizePixel = 0
                    statusBadge.Parent = row
                    local sbc = Instance.new("UICorner", statusBadge)
                    sbc.CornerRadius = UDim.new(0, 4)
                end
            end
        end
    end)
end

createSlider("UI Opacity / Transparency", 0, 80, 0, function(val)
    V.UITransparency = val
    if BloxFruitsPanel then
        BloxFruitsPanel.BackgroundTransparency = val / 100
    end
end, SettingsContent,"UITransparency")

createSlider("Opacité Fond Sombre (Dimmer)", 0, 100, 80, function(val)
    if BackgroundDimmer then
        BackgroundDimmer.BackgroundTransparency = 1 - (val / 100)
    end
end, SettingsContent,"DimmerOpacity")

createToggle("Bulles Animées (Background)", true, function(enabled)
    if BubblesContainer then
        BubblesContainer.Visible = enabled
    end
end, SettingsContent,"BubblesEnabled")

createToggle("Anti-Cheat Notification Alert", false, function(enabled)
    V.AntiCheatAlert = enabled
    notify("Settings","Anti-Cheat Alert".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, SettingsContent,"AntiCheatAlert")

createLabel("SYSTEM", SettingsContent)
do
    local antiAfkConn = nil
    createToggle("Real Anti-AFK System", false, function(enabled)
        V.AntiAFK = enabled
        if enabled then
            local VirtualUser = game:GetService("VirtualUser")
            
            if antiAfkConn then antiAfkConn:Disconnect() end
            antiAfkConn = LocalPlayer.Idled:Connect(function()
                if V.AntiAFK then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new(0, 0))
                    end)
                end
            end)
            addConnection(antiAfkConn)

            task.spawn(function()
                while V.AntiAFK do
                    task.wait(45)
                    if V.AntiAFK then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                            task.wait(0.1)
                            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                        end)
                    end
                end
            end)

            notify("Settings","Real Anti-AFK System ON", Color3.fromRGB(80, 200, 120))
        else
            if antiAfkConn then antiAfkConn:Disconnect() antiAfkConn = nil end
            notify("Settings","Anti-AFK System OFF", Color3.fromRGB(255, 90, 90))
        end
    end, SettingsContent,"AntiAFK")
end

createToggle("Notifications", true, function(enabled)
    V.Notif = enabled
    if enabled then
        notify("Settings","Notifications ON", Color3.fromRGB(80, 200, 120))
    end
end, SettingsContent,"Notif")

do
    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Size = UDim2.new(0, 400, 0, 30)
    WatermarkFrame.Position = UDim2.new(1, 460, 0, 10)
    WatermarkFrame.AnchorPoint = Vector2.new(1, 0)
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 21)
    WatermarkFrame.BackgroundTransparency = 0.15
    WatermarkFrame.BorderSizePixel = 0
    WatermarkFrame.Visible = false
    WatermarkFrame.Parent = ScreenGui
    makeCorner(WatermarkFrame, 10)
    makeStroke(WatermarkFrame, Color3.fromRGB(60, 60, 78), 1)

    local WatermarkAccent = Instance.new("Frame")
    WatermarkAccent.Size = UDim2.new(0, 3, 1, -8)
    WatermarkAccent.Position = UDim2.new(0, 6, 0.5, 0)
    WatermarkAccent.AnchorPoint = Vector2.new(0, 0.5)
    WatermarkAccent.BackgroundColor3 = theme.accent
    WatermarkAccent.BorderSizePixel = 0
    WatermarkAccent.Parent = WatermarkFrame
    makeCorner(WatermarkAccent, 2)

    local WatermarkLabel = Instance.new("TextLabel")
    WatermarkLabel.Size = UDim2.new(1, -24, 1, 0)
    WatermarkLabel.Position = UDim2.new(0, 16, 0, 0)
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.Text = "Nebula V2.0"
    WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WatermarkLabel.TextStrokeTransparency = 0.4
    WatermarkLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    WatermarkLabel.Font = Enum.Font.GothamBold
    WatermarkLabel.TextSize = 13
    WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
    WatermarkLabel.TextYAlignment = Enum.TextYAlignment.Center
    WatermarkLabel.Parent = WatermarkFrame

    local function showWatermark(visible)
        if visible then
            WatermarkFrame.Visible = true
            TweenService:Create(WatermarkFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -12, 0, 10)}):Play()
        else
            TweenService:Create(WatermarkFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 460, 0, 10)}):Play()
            task.delay(0.3, function()
                WatermarkFrame.Visible = false
            end)
        end
    end

    createToggle("Watermark (HUD)", false, function(enabled)
        V.Watermark = enabled
        showWatermark(enabled)
        if enabled then
            notify("Settings","Watermark ON", Color3.fromRGB(80, 200, 120))
        end
    end, SettingsContent,"Watermark")

    task.spawn(function()
        while task.wait(0.5) do
            if V.Watermark then
                local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                local playerCount = #Players:GetPlayers()
                WatermarkLabel.Text = string.format("Nebula V2.0  |  FPS: %d  |  Ping: %d ms  |  Joueurs: %d", currentFPS, ping, playerCount)
            end
        end
    end)
end

do
    local MenuKeybindFrame = Instance.new("Frame")
    MenuKeybindFrame.Size = UDim2.new(1, 0, 0, 40)
    MenuKeybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MenuKeybindFrame.BorderSizePixel = 0
    MenuKeybindFrame.Parent = SettingsContent

    local MenuKeybindCorner = Instance.new("UICorner")
    MenuKeybindCorner.CornerRadius = UDim.new(0, 8)
    MenuKeybindCorner.Parent = MenuKeybindFrame

    local MenuKeyLabel = Instance.new("TextLabel")
    MenuKeyLabel.Size = UDim2.new(0.6, 0, 1, 0)
    MenuKeyLabel.Position = UDim2.new(0, 14, 0, 0)
    MenuKeyLabel.BackgroundTransparency = 1
    MenuKeyLabel.Text ="Menu Toggle Key"
    MenuKeyLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
    MenuKeyLabel.Font = Enum.Font.GothamMedium
    MenuKeyLabel.TextSize = 13
    MenuKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    MenuKeyLabel.Parent = MenuKeybindFrame

    local MenuKeyBtn = Instance.new("TextButton")
    MenuKeyBtn.Size = UDim2.new(0, 80, 0, 26)
    MenuKeyBtn.Position = UDim2.new(1, -94, 0.5, -13)
    MenuKeyBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    MenuKeyBtn.BorderSizePixel = 0
    MenuKeyBtn.Text = Keybinds.Menu.Name
    MenuKeyBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
    MenuKeyBtn.Font = Enum.Font.GothamMedium
    MenuKeyBtn.TextSize = 11
    MenuKeyBtn.Parent = MenuKeybindFrame

    local MenuKeyCorner = Instance.new("UICorner")
    MenuKeyCorner.CornerRadius = UDim.new(0, 5)
    MenuKeyCorner.Parent = MenuKeyBtn

    KeybindButtons["Menu"] = MenuKeyBtn
    MenuKeyBtn.MouseButton1Click:Connect(function()
        KeybindSystem.Binding = true
        KeybindSystem.BindingName ="Menu"
        KeybindSystem.BindingBtn = MenuKeyBtn
        MenuKeyBtn.Text ="Press..."
    end)

    createLabel("KEYBINDS", SettingsContent)
    local function createKeybindButton(name, defaultKey, callback)
        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.Size = UDim2.new(1, 0, 0, 40)
        KeybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        KeybindFrame.BorderSizePixel = 0
        KeybindFrame.Parent = SettingsContent

        local KeybindCorner = Instance.new("UICorner")
        KeybindCorner.CornerRadius = UDim.new(0, 8)
        KeybindCorner.Parent = KeybindFrame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = Color3.fromRGB(195, 195, 208)
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 13
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = KeybindFrame

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Size = UDim2.new(0, 80, 0, 26)
        KeyBtn.Position = UDim2.new(1, -94, 0.5, -13)
        KeyBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        KeyBtn.BorderSizePixel = 0
        KeyBtn.Text = Keybinds[name] and Keybinds[name].Name or defaultKey.Name
        KeyBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
        KeyBtn.Font = Enum.Font.GothamMedium
        KeyBtn.TextSize = 11
        KeyBtn.Parent = KeybindFrame

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 5)
        KeyCorner.Parent = KeyBtn

        KeybindCallbacks[name] = callback
        KeybindButtons[name] = KeyBtn

        KeyBtn.MouseButton1Click:Connect(function()
            KeybindSystem.Binding = true
            KeybindSystem.BindingName = name
            KeybindSystem.BindingBtn = KeyBtn
            KeyBtn.Text ="Press..."
        end)
    end

    createKeybindButton("Fly", Keybinds.Fly, ToggleFly)
    createKeybindButton("Noclip", Keybinds.Noclip, ToggleNoclip)
    createKeybindButton("Invisible", Keybinds.Invisible, ToggleInvis)
    createKeybindButton("DesyncFly", Keybinds.DesyncFly, ToggleDesync)
    createKeybindButton("ESP", Keybinds.ESP, ToggleESP)
    createKeybindButton("Speed", Keybinds.Speed, ToggleSpeed)
    createKeybindButton("Respawn", Keybinds.Respawn, respawnPlayer)
    createKeybindButton("Freecam", Keybinds.Freecam, ToggleFreecam)
    createKeybindButton("VehicleFly", Keybinds.VehicleFly, function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            V.VehicleFly = not V.VehicleFly
            notify("Vehicle","Vehicle Fly".. (V.VehicleFly and"ON"or"OFF"), V.VehicleFly and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
        end
    end)
    createKeybindButton("VehicleBoost", Keybinds.VehicleBoost, function()
        vehicleBoost()
    end)
    createKeybindButton("InstantBrake", Keybinds.InstantBrake, function()
        instantBrake()
    end)
    createKeybindButton("VehicleSeatTP", Keybinds.VehicleSeatTP, function()
        if _G.tpToAimVehicleSeat then _G.tpToAimVehicleSeat(true) end
    end)
    createKeybindButton("VehicleAutoFlip", Keybinds.VehicleAutoFlip, function()
        if _G.flipVehicle then _G.flipVehicle() end
    end)
    createKeybindButton("VehicleExplode", Keybinds.VehicleExplode, function()
        if _G.explodeVehicle then _G.explodeVehicle() end
    end)
    createKeybindButton("VehiclePropulse", Keybinds.VehiclePropulse, function()
        if _G.toggleCarCarry then _G.toggleCarCarry() end
    end)
end

createLabel("UNLOAD", SettingsContent)
createButton("Unload Nebula Hub", function()
    performFullUnload()
end, SettingsContent)

initStep = "cablage Config/Code"
createLabel("CONFIGURATION", ConfigContent)
do
    local ConfigNameBox = Instance.new("TextBox")
    ConfigNameBox.Size = UDim2.new(1, 0, 0, 34)
    ConfigNameBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    ConfigNameBox.BorderSizePixel = 0
    ConfigNameBox.PlaceholderText ="Nom de la config (ex: Main)"
    ConfigNameBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    ConfigNameBox.Text ="Default"
    ConfigNameBox.TextColor3 = Color3.fromRGB(210, 210, 222)
    ConfigNameBox.Font = Enum.Font.GothamMedium
    ConfigNameBox.TextSize = 12
    ConfigNameBox.TextXAlignment = Enum.TextXAlignment.Left
    ConfigNameBox.Parent = ConfigContent

    local ConfigNamePadding = Instance.new("UIPadding")
    ConfigNamePadding.PaddingLeft = UDim.new(0, 10)
    ConfigNamePadding.Parent = ConfigNameBox

    local ConfigNameCorner = Instance.new("UICorner")
    ConfigNameCorner.CornerRadius = UDim.new(0, 6)
    ConfigNameCorner.Parent = ConfigNameBox

    local ConfigListFrame = Instance.new("Frame")
    ConfigListFrame.Size = UDim2.new(1, 0, 0, 220)
    ConfigListFrame.Position = UDim2.new(0, 0, 0, 40)
    ConfigListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ConfigListFrame.BorderSizePixel = 0
    ConfigListFrame.Parent = ConfigContent

    local ConfigListFrameCorner = Instance.new("UICorner")
    ConfigListFrameCorner.CornerRadius = UDim.new(0, 8)
    ConfigListFrameCorner.Parent = ConfigListFrame

    local ConfigList = Instance.new("ScrollingFrame")
    ConfigList.Size = UDim2.new(1, 0, 1, 0)
    ConfigList.BackgroundTransparency = 1
    ConfigList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ConfigList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ConfigList.ScrollBarThickness = 2
    ConfigList.Parent = ConfigListFrame

    local ConfigListLayout = Instance.new("UIListLayout")
    ConfigListLayout.Padding = UDim.new(0, 5)
    ConfigListLayout.Parent = ConfigList

    local ConfigListPadding = Instance.new("UIPadding")
    ConfigListPadding.PaddingTop = UDim.new(0, 5)
    ConfigListPadding.PaddingLeft = UDim.new(0, 5)
    ConfigListPadding.PaddingRight = UDim.new(0, 5)
    ConfigListPadding.Parent = ConfigList

    local function refreshConfigList()
        for _, child in pairs(ConfigList:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end

        if not listfiles then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text ="listfiles not supported"
            lbl.TextColor3 = Color3.fromRGB(255, 90, 90)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.Parent = ConfigList
            return
        end

        local files = listfiles()
        if not files then return end

        local hasConfigs = false

        for _, filePath in ipairs(files) do
            local fileName = string.match(filePath,"([^/\\]+)$") or filePath
            local cfgName = string.match(fileName,"NebulaConfig_(.-)%.json")
            if cfgName then
                hasConfigs = true
                local CfgFrame = Instance.new("Frame")
                CfgFrame.Size = UDim2.new(1, 0, 0, 38)
                CfgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                CfgFrame.BorderSizePixel = 0
                CfgFrame.Parent = ConfigList

                local CfgCorner = Instance.new("UICorner")
                CfgCorner.CornerRadius = UDim.new(0, 8)
                CfgCorner.Parent = CfgFrame

                local CfgLabel = Instance.new("TextLabel")
                CfgLabel.Size = UDim2.new(0.4, 0, 1, 0)
                CfgLabel.Position = UDim2.new(0, 10, 0, 0)
                CfgLabel.BackgroundTransparency = 1
                CfgLabel.Text = cfgName
                CfgLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
                CfgLabel.Font = Enum.Font.GothamMedium
                CfgLabel.TextSize = 12
                CfgLabel.TextXAlignment = Enum.TextXAlignment.Left
                CfgLabel.Parent = CfgFrame

                local LoadBtn = Instance.new("TextButton")
                LoadBtn.Size = UDim2.new(0, 50, 0, 26)
                LoadBtn.Position = UDim2.new(1, -235, 0.5, -13)
                LoadBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                LoadBtn.BorderSizePixel = 0
                LoadBtn.Text ="Load"
                LoadBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
                LoadBtn.Font = Enum.Font.GothamMedium
                LoadBtn.TextSize = 11
                LoadBtn.Parent = CfgFrame

                local LoadCorner = Instance.new("UICorner")
                LoadCorner.CornerRadius = UDim.new(0, 5)
                LoadCorner.Parent = LoadBtn

                LoadBtn.MouseEnter:Connect(function()
                    TweenService:Create(LoadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
                end)
                LoadBtn.MouseLeave:Connect(function()
                    TweenService:Create(LoadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
                end)

                LoadBtn.MouseButton1Click:Connect(function()
                    if readfile then
                        local content = readfile(filePath)
                        if content then
                            pcall(function()
                                local cfg = HttpService:JSONDecode(content)
                                
                                for key, val in pairs(DefaultConfig) do
                                    if ConfigRegistry[key] then
                                        ConfigRegistry[key](val)
                                    end
                                end
                                
                                for key, setter in pairs(ConfigRegistry) do
                                    if cfg[key] ~= nil then
                                        setter(cfg[key])
                                    end
                                end
                                
                                if cfg.Keybinds then
                                    Keybinds.Fly = Enum.KeyCode[cfg.Keybinds.Fly] or Keybinds.Fly
                                    Keybinds.Noclip = Enum.KeyCode[cfg.Keybinds.Noclip] or Keybinds.Noclip
                                    Keybinds.Invisible = Enum.KeyCode[cfg.Keybinds.Invisible] or Keybinds.Invisible
                                    Keybinds.DesyncFly = Enum.KeyCode[cfg.Keybinds.DesyncFly] or Keybinds.DesyncFly
                                    if cfg.Keybinds.ESP then Keybinds.ESP = Enum.KeyCode[cfg.Keybinds.ESP] end
                                    if cfg.Keybinds.Speed then Keybinds.Speed = Enum.KeyCode[cfg.Keybinds.Speed] end
                                    if cfg.Keybinds.Respawn then Keybinds.Respawn = Enum.KeyCode[cfg.Keybinds.Respawn] end
                                    if cfg.Keybinds.Menu then Keybinds.Menu = Enum.KeyCode[cfg.Keybinds.Menu] end
                                    if cfg.Keybinds.Freecam then Keybinds.Freecam = Enum.KeyCode[cfg.Keybinds.Freecam] end
                                    if cfg.Keybinds.VehicleFly then Keybinds.VehicleFly = Enum.KeyCode[cfg.Keybinds.VehicleFly] end
                                    if cfg.Keybinds.VehicleBoost then Keybinds.VehicleBoost = Enum.KeyCode[cfg.Keybinds.VehicleBoost] end
                                    if cfg.Keybinds.InstantBrake then Keybinds.InstantBrake = Enum.KeyCode[cfg.Keybinds.InstantBrake] end
                                    
                                    for name, btn in pairs(KeybindButtons) do
                                        if Keybinds[name] then btn.Text = Keybinds[name].Name end
                                    end
                                    
                                    notify("Config", cfgName .."chargée avec succès !", Color3.fromRGB(80, 200, 120))
                                end
                            end)
                        end
                    end
                end)

                local ExportBtn = Instance.new("TextButton")
                ExportBtn.Size = UDim2.new(0, 50, 0, 26)
                ExportBtn.Position = UDim2.new(1, -175, 0.5, -13)
                ExportBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                ExportBtn.BorderSizePixel = 0
                ExportBtn.Text ="Export"
                ExportBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
                ExportBtn.Font = Enum.Font.GothamMedium
                ExportBtn.TextSize = 11
                ExportBtn.Parent = CfgFrame

                local ExpCorner = Instance.new("UICorner")
                ExpCorner.CornerRadius = UDim.new(0, 5)
                ExpCorner.Parent = ExportBtn

                ExportBtn.MouseButton1Click:Connect(function()
                    if readfile and setclipboard then
                        local content = readfile(filePath)
                        if content then
                            setclipboard(content)
                            notify("Config","Config copiée dans le presse-papier !", Color3.fromRGB(80, 200, 120))
                        end
                    else
                        notify("Config","Presse-papier non supporté.", Color3.fromRGB(255, 90, 90))
                    end
                end)

                local UnloadBtn = Instance.new("TextButton")
                UnloadBtn.Size = UDim2.new(0, 50, 0, 26)
                UnloadBtn.Position = UDim2.new(1, -115, 0.5, -13)
                UnloadBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 22)
                UnloadBtn.BorderSizePixel = 0
                UnloadBtn.Text ="Unload"
                UnloadBtn.TextColor3 = Color3.fromRGB(255, 165, 0)
                UnloadBtn.Font = Enum.Font.GothamMedium
                UnloadBtn.TextSize = 11
                UnloadBtn.Parent = CfgFrame

                local UnloadCorner = Instance.new("UICorner")
                UnloadCorner.CornerRadius = UDim.new(0, 5)
                UnloadCorner.Parent = UnloadBtn

                UnloadBtn.MouseEnter:Connect(function()
                    TweenService:Create(UnloadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 45, 30)}):Play()
                end)
                UnloadBtn.MouseLeave:Connect(function()
                    TweenService:Create(UnloadBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 30, 22)}):Play()
                end)

                UnloadBtn.MouseButton1Click:Connect(function()
                    for key, val in pairs(DefaultConfig) do
                        if ConfigRegistry[key] then
                            ConfigRegistry[key](val)
                        end
                    end
                    Keybinds.Fly = Enum.KeyCode.F
                    Keybinds.Noclip = Enum.KeyCode.V
                    Keybinds.Invisible = Enum.KeyCode.C
                    Keybinds.DesyncFly = Enum.KeyCode.G
                    Keybinds.ESP = Enum.KeyCode.E
                    Keybinds.Speed = Enum.KeyCode.R
                    Keybinds.Respawn = Enum.KeyCode.B
                    Keybinds.Menu = Enum.KeyCode.Insert
                    Keybinds.Freecam = Enum.KeyCode.X
                    Keybinds.VehicleFly = Enum.KeyCode.H
                    Keybinds.VehicleBoost = Enum.KeyCode.T
                    Keybinds.InstantBrake = Enum.KeyCode.N
                    
                    for name, btn in pairs(KeybindButtons) do
                        if Keybinds[name] then btn.Text = Keybinds[name].Name end
                    end
                    
                    notify("Config","Config unloaded (Reset to default)!", Color3.fromRGB(255, 165, 0))
                end)

                local DelBtn = Instance.new("TextButton")
                DelBtn.Size = UDim2.new(0, 50, 0, 26)
                DelBtn.Position = UDim2.new(1, -55, 0.5, -13)
                DelBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                DelBtn.BorderSizePixel = 0
                DelBtn.Text ="Delete"
                DelBtn.TextColor3 = Color3.fromRGB(170, 110, 110)
                DelBtn.Font = Enum.Font.GothamMedium
                DelBtn.TextSize = 11
                DelBtn.Parent = CfgFrame

                local DelCorner = Instance.new("UICorner")
                DelCorner.CornerRadius = UDim.new(0, 5)
                DelCorner.Parent = DelBtn

                DelBtn.MouseEnter:Connect(function()
                    TweenService:Create(DelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 30, 30)}):Play()
                end)
                DelBtn.MouseLeave:Connect(function()
                    TweenService:Create(DelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 22, 22)}):Play()
                end)

                DelBtn.MouseButton1Click:Connect(function()
                    if delfile then
                        delfile(filePath)
                        notify("Config", cfgName .."deleted!", Color3.fromRGB(255, 90, 90))
                        refreshConfigList()
                    end
                end)
            end
        end

        if not hasConfigs then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text ="No configs found"
            lbl.TextColor3 = Color3.fromRGB(120, 120, 132)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.Parent = ConfigList
        end
    end

    local function saveConfig()
        local cfgName = ConfigNameBox.Text
        if cfgName ==""then cfgName ="Default"end
        local fileName ="NebulaConfig_".. cfgName ..".json"
        pcall(function()
            local cfg = {}
            for key, _ in pairs(ConfigRegistry) do
                cfg[key] = V[key]
            end
            cfg.Keybinds = {
                Fly = Keybinds.Fly.Name,
                Noclip = Keybinds.Noclip.Name,
                Invisible = Keybinds.Invisible.Name,
                DesyncFly = Keybinds.DesyncFly.Name,
                ESP = Keybinds.ESP.Name,
                Speed = Keybinds.Speed.Name,
                Respawn = Keybinds.Respawn.Name,
                Menu = Keybinds.Menu.Name,
                Freecam = Keybinds.Freecam.Name,
                VehicleFly = Keybinds.VehicleFly and Keybinds.VehicleFly.Name or"H",
                VehicleBoost = Keybinds.VehicleBoost and Keybinds.VehicleBoost.Name or"T",
                InstantBrake = Keybinds.InstantBrake and Keybinds.InstantBrake.Name or"N"
            }
            if writefile then
                writefile(fileName, HttpService:JSONEncode(cfg))
                notify("Config","Saved ALL settings as".. cfgName .."!", Color3.fromRGB(80, 200, 120))
                refreshConfigList()
            else
                notify("Config","Writefile not supported.", Color3.fromRGB(255, 90, 90))
            end
        end)
    end

    createButton("Save Config", saveConfig, ConfigContent)

    createButton("Importer Config", function()
        local ImportGui = Instance.new("ScreenGui")
        ImportGui.Name ="NebulaImportGui"
        ImportGui.Parent = parentTarget
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 300, 0, 300)
        MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ImportGui
        local IC = Instance.new("UICorner", MainFrame)
        IC.CornerRadius = UDim.new(0, 8)

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundTransparency = 1
        Title.Text ="IMPORTER UNE CONFIG"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = MainFrame

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Position = UDim2.new(0, 10, 0, 35)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text ="Nom de la config:"
        NameLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
        NameLabel.Font = Enum.Font.GothamMedium
        NameLabel.TextSize = 12
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = MainFrame

        local NameBox = Instance.new("TextBox")
        NameBox.Size = UDim2.new(1, -20, 0, 30)
        NameBox.Position = UDim2.new(0, 10, 0, 55)
        NameBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        NameBox.TextColor3 = Color3.fromRGB(210, 210, 222)
        NameBox.Font = Enum.Font.GothamMedium
        NameBox.TextSize = 12
        NameBox.Text ="Imported"
        NameBox.TextXAlignment = Enum.TextXAlignment.Left
        NameBox.Parent = MainFrame
        local NCPad = Instance.new("UIPadding", NameBox)
        NCPad.PaddingLeft = UDim.new(0, 10)
        local NCCorner = Instance.new("UICorner", NameBox)
        NCCorner.CornerRadius = UDim.new(0, 6)

        local BoxLabel = Instance.new("TextLabel")
        BoxLabel.Size = UDim2.new(1, -20, 0, 20)
        BoxLabel.Position = UDim2.new(0, 10, 0, 95)
        BoxLabel.BackgroundTransparency = 1
        BoxLabel.Text ="Code JSON:"
        BoxLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
        BoxLabel.Font = Enum.Font.GothamMedium
        BoxLabel.TextSize = 12
        BoxLabel.TextXAlignment = Enum.TextXAlignment.Left
        BoxLabel.Parent = MainFrame

        local Box = Instance.new("TextBox")
        Box.Size = UDim2.new(1, -20, 1, -190)
        Box.Position = UDim2.new(0, 10, 0, 115)
        Box.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.Font = Enum.Font.Code
        Box.TextSize = 12
        Box.TextWrapped = true
        Box.MultiLine = true
        Box.TextXAlignment = Enum.TextXAlignment.Left
        Box.TextYAlignment = Enum.TextYAlignment.Top
        Box.PlaceholderText ="Colle le code JSON ici..."
        Box.Parent = MainFrame
        local BC = Instance.new("UICorner", Box)
        BC.CornerRadius = UDim.new(0, 6)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0.5, -10, 0, 30)
        CloseBtn.Position = UDim2.new(0, 10, 1, -40)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
        CloseBtn.Text ="Annuler"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 12
        CloseBtn.Parent = MainFrame
        local CC = Instance.new("UICorner", CloseBtn)
        CC.CornerRadius = UDim.new(0, 6)
        CloseBtn.MouseButton1Click:Connect(function() ImportGui:Destroy() end)

        local SaveBtn = Instance.new("TextButton")
        SaveBtn.Size = UDim2.new(0.5, -10, 0, 30)
        SaveBtn.Position = UDim2.new(0.5, 0, 1, -40)
        SaveBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
        SaveBtn.Text ="Sauvegarder"
        SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SaveBtn.Font = Enum.Font.GothamBold
        SaveBtn.TextSize = 12
        SaveBtn.Parent = MainFrame
        local SC = Instance.new("UICorner", SaveBtn)
        SC.CornerRadius = UDim.new(0, 6)

        SaveBtn.MouseButton1Click:Connect(function()
            if writefile and Box.Text ~=""then
                local cfgName = NameBox.Text
                if cfgName ==""then cfgName ="Imported"end
                local fileName ="NebulaConfig_".. cfgName ..".json"
                
                pcall(function()
                    writefile(fileName, Box.Text)
                    notify("Config","Config importée sous le nom:".. cfgName, Color3.fromRGB(80, 200, 120))
                    refreshConfigList()
                    ImportGui:Destroy()
                end)
            else
                notify("Config","Erreur: Ecriture non supportée ou vide.", Color3.fromRGB(255, 90, 90))
            end
        end)
    end, ConfigContent)

    refreshConfigList()
end

initStep = "fin"
createLabel("EXECUTE CODE", CodeContent)
do
    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, 0, 0, 220)
    CodeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    CodeBox.BorderSizePixel = 0
    CodeBox.Text =""
    CodeBox.PlaceholderText ="Colle ton code Lua ici"
    CodeBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    CodeBox.TextColor3 = Color3.fromRGB(210, 210, 222)
    CodeBox.Font = Enum.Font.Code
    CodeBox.TextSize = 14
    CodeBox.TextWrapped = true
    CodeBox.MultiLine = true
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.Parent = CodeContent

    local CodeBoxCorner = Instance.new("UICorner")
    CodeBoxCorner.CornerRadius = UDim.new(0, 8)
    CodeBoxCorner.Parent = CodeBox

    local CodeBoxPadding = Instance.new("UIPadding")
    CodeBoxPadding.PaddingLeft = UDim.new(0, 8)
    CodeBoxPadding.PaddingRight = UDim.new(0, 8)
    CodeBoxPadding.PaddingTop = UDim.new(0, 8)
    CodeBoxPadding.PaddingBottom = UDim.new(0, 8)
    CodeBoxPadding.Parent = CodeBox

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 38)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 230)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = CodeContent

    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.Padding = UDim.new(0, 5)
    ButtonLayout.Parent = ButtonContainer

    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Size = UDim2.new(0.5, -3, 1, 0)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    ExecBtn.BorderSizePixel = 0
    ExecBtn.Text ="Execute"
    ExecBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
    ExecBtn.Font = Enum.Font.GothamMedium
    ExecBtn.TextSize = 13
    ExecBtn.Parent = ButtonContainer

    local ExecCorner = Instance.new("UICorner")
    ExecCorner.CornerRadius = UDim.new(0, 8)
    ExecCorner.Parent = ExecBtn

    local ExecStroke = Instance.new("UIStroke")
    ExecStroke.Thickness = 0.8
    ExecStroke.Color = Color3.fromRGB(40, 40, 48)
    ExecStroke.Transparency = 0.5
    ExecStroke.Parent = ExecBtn

    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0.5, -3, 1, 0)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
    ClearBtn.BorderSizePixel = 0
    ClearBtn.Text ="Clear"
    ClearBtn.TextColor3 = Color3.fromRGB(170, 110, 110)
    ClearBtn.Font = Enum.Font.GothamMedium
    ClearBtn.TextSize = 13
    ClearBtn.Parent = ButtonContainer

    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 8)
    ClearCorner.Parent = ClearBtn

    local ClearStroke = Instance.new("UIStroke")
    ClearStroke.Thickness = 0.8
    ClearStroke.Color = Color3.fromRGB(80, 40, 40)
    ClearStroke.Transparency = 0.5
    ClearStroke.Parent = ClearBtn

    ExecBtn.MouseEnter:Connect(function()
        TweenService:Create(ExecBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
    end)
    ExecBtn.MouseLeave:Connect(function()
        TweenService:Create(ExecBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
    end)

    ClearBtn.MouseEnter:Connect(function()
        TweenService:Create(ClearBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 30, 30)}):Play()
    end)
    ClearBtn.MouseLeave:Connect(function()
        TweenService:Create(ClearBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 22, 22)}):Play()
    end)

    ExecBtn.MouseButton1Click:Connect(function()
        local codeToRun = CodeBox.Text
        if codeToRun ==""or codeToRun:match("^%s*$") then
            notify("Code","No code to execute!", Color3.fromRGB(255, 165, 0))
            return
        end
        
        local func, err = loadstring(codeToRun)
        if func then
            local success, runtimeErr = pcall(func)
            if success then
                notify("Code","Code executed successfully!", Color3.fromRGB(80, 200, 120))
            else
                notify("Code","Runtime Error:".. tostring(runtimeErr), Color3.fromRGB(255, 90, 90))
            end
        else
            notify("Code","Syntax Error:".. tostring(err), Color3.fromRGB(255, 90, 90))
        end
    end)

    ClearBtn.MouseButton1Click:Connect(function()
        CodeBox.Text =""
        notify("Code","Cleared text box.", Color3.fromRGB(180, 180, 195))
    end)
end

if V.UnifiedInputConn then V.UnifiedInputConn:Disconnect() end
V.UnifiedInputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if KeybindSystem.Binding then
            local newKey = input.KeyCode
            local alreadyUsed = false
            for kName, kVal in pairs(Keybinds) do
                if kName ~= KeybindSystem.BindingName and kVal == newKey then
                    alreadyUsed = true
                    break
                end
            end

            if alreadyUsed then
                notify("Settings","Key already used by another bind!", Color3.fromRGB(255, 90, 90))
            else
                Keybinds[KeybindSystem.BindingName] = newKey
                if KeybindSystem.BindingBtn then
                    KeybindSystem.BindingBtn.Text = newKey.Name
                end
                notify("Settings", KeybindSystem.BindingName .."set to".. newKey.Name, Color3.fromRGB(80, 200, 120))
            end
            KeybindSystem.Binding = false
            KeybindSystem.BindingName = nil
            KeybindSystem.BindingBtn = nil
            return
        end

        if not gameProcessed then
            if input.KeyCode == Keybinds.Menu or input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.M then
                if toggleMenu then
                    toggleMenu()
                elseif BloxFruitsPanel then
                    BloxFruitsPanel.Visible = not BloxFruitsPanel.Visible
                end
                return
            end

            for name, key in pairs(Keybinds) do
                if name ~="Menu"and input.KeyCode == key and KeybindCallbacks[name] then
                    local success, err = pcall(KeybindCallbacks[name])
                    if not success then
                        warn("Erreur Keybind".. name ..":".. tostring(err))
                    end
                    return
                end
            end
        end
    end
end)
addConnection(V.UnifiedInputConn)

if BloxFruitsPanel then BloxFruitsPanel.Visible = true end
notify("Nebula V2.0","Script loaded successfully!", Color3.fromRGB(80, 200, 120))

local InspectorGui = nil
local function openPlayerInspector(targetPlayer)
    if not targetPlayer then return end
    if InspectorGui then InspectorGui:Destroy() end

InspectorGui = Instance.new("ScreenGui")
InspectorGui.Name ="NebulaPlayerInspector"
InspectorGui.ResetOnSpawn = false
InspectorGui.DisplayOrder = 100
InspectorGui.Parent = parentTarget

    local CardFrame = Instance.new("Frame")
    CardFrame.Size = UDim2.new(0, 310, 0, 450)
    CardFrame.Position = UDim2.new(0.5, -155, 0.52, -225)
    CardFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    CardFrame.BackgroundTransparency = 1
    CardFrame.BorderSizePixel = 0
    CardFrame.Active = true
    CardFrame.Draggable = true
    CardFrame.Parent = InspectorGui

    local CardCorner = Instance.new("UICorner", CardFrame)
    CardCorner.CornerRadius = UDim.new(0, 14)

    local CardStroke = Instance.new("UIStroke", CardFrame)
    CardStroke.Color = V.AccentColor or Color3.fromRGB(60, 160, 255)
    CardStroke.Thickness = 1.5
    CardStroke.Transparency = 0.25

    TweenService:Create(CardFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 340, 0, 480),
        Position = UDim2.new(0.5, -170, 0.5, -240),
        BackgroundTransparency = 0.05
    }):Play()

    local TopBanner = Instance.new("Frame")
    TopBanner.Size = UDim2.new(1, 0, 0, 75)
    TopBanner.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    TopBanner.BorderSizePixel = 0
    TopBanner.Parent = CardFrame
    local tbc = Instance.new("UICorner", TopBanner)
    tbc.CornerRadius = UDim.new(0, 14)

    local BannerGradient = Instance.new("UIGradient", TopBanner)
    BannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 24))
    })

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -34, 0, 10)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 30)
    CloseBtn.Text =""
    CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Parent = CardFrame
    local cbc = Instance.new("UICorner", CloseBtn)
    cbc.CornerRadius = UDim.new(0, 8)

    local function closeInspector()
        local tweenOut = TweenService:Create(CardFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 300, 0, 430),
            Position = UDim2.new(0.5, -150, 0.52, -215),
            BackgroundTransparency = 1
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            InspectorGui:Destroy()
        end)
    end
    CloseBtn.MouseButton1Click:Connect(closeInspector)

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(0, 56, 0, 56)
    AvatarImg.Position = UDim2.new(0, 16, 0, 10)
    AvatarImg.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    AvatarImg.BorderSizePixel = 0
    AvatarImg.Image ="rbxthumb://type=AvatarHeadShot&id=".. targetPlayer.UserId .."&w=150&h=150"
    AvatarImg.Parent = CardFrame
    local aic = Instance.new("UICorner", AvatarImg)
    aic.CornerRadius = UDim.new(1, 0)
    local ais = Instance.new("UIStroke", AvatarImg)
    ais.Color = V.AccentColor or Color3.fromRGB(60, 160, 255)
    ais.Thickness = 2

    local DisplayLabel = Instance.new("TextLabel")
    DisplayLabel.Size = UDim2.new(1, -125, 0, 20)
    DisplayLabel.Position = UDim2.new(0, 82, 0, 14)
    DisplayLabel.BackgroundTransparency = 1
    DisplayLabel.Text = targetPlayer.DisplayName
    DisplayLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DisplayLabel.Font = Enum.Font.GothamBold
    DisplayLabel.TextSize = 14
    DisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayLabel.Parent = CardFrame

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Size = UDim2.new(1, -125, 0, 16)
    UserLabel.Position = UDim2.new(0, 82, 0, 34)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Text ="@".. targetPlayer.Name
    UserLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
    UserLabel.Font = Enum.Font.GothamMedium
    UserLabel.TextSize = 11
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.Parent = CardFrame

    local function detectPlatform()
        if targetPlayer == LocalPlayer then
            if UserInputService.VREnabled then return"VR Headset"end
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then return"Mobile (iOS/Android)"end
            if UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then return"Console (Xbox/PS)"end
            return"PC / Mac (Keyboard & Mouse)"
        end

        local pg = targetPlayer:FindFirstChild("PlayerGui")
        if pg then
            if pg:FindFirstChild("TouchGui") or pg:FindFirstChild("TouchCameraControlFrame") or pg:FindFirstChild("MobileGui") or pg:FindFirstChild("TouchControls") then
                return"Mobile (iOS/Android)"
            end
            if pg:FindFirstChild("ConsoleGui") or pg:FindFirstChild("GamepadGui") or pg:FindFirstChild("XboxGui") or pg:FindFirstChild("PSGui") then
                return"Console (PlayStation/Xbox)"
            end
        end

        local char = targetPlayer.Character
        if char then
            if char:FindFirstChild("VRCharacter") or char:FindFirstChild("Left Hand") or char:FindFirstChild("LeftHandVR") then
                return"VR Headset"
            end
            for _, obj in pairs(char:GetChildren()) do
                local n = obj.Name:lower()
                if n:find("touch") or n:find("mobile") then return"Mobile (iOS/Android)"
                elseif n:find("console") or n:find("gamepad") or n:find("controller") then return"Console (Xbox/PS)"
                end
            end
        end

        local devAttr = targetPlayer:GetAttribute("Device") or targetPlayer:GetAttribute("Platform")
        if devAttr then return tostring(devAttr) end

        return"PC / Mac (Keyboard & Mouse)"
    end

    local PlatformBadge = Instance.new("TextLabel")
    PlatformBadge.Size = UDim2.new(0, 185, 0, 18)
    PlatformBadge.Position = UDim2.new(0, 82, 0, 52)
    PlatformBadge.BackgroundColor3 = Color3.fromRGB(28, 42, 65)
    PlatformBadge.Text = detectPlatform()
    PlatformBadge.TextColor3 = Color3.fromRGB(100, 200, 255)
    PlatformBadge.Font = Enum.Font.GothamBold
    PlatformBadge.TextSize = 9
    PlatformBadge.BorderSizePixel = 0
    PlatformBadge.Parent = CardFrame
    local pbc = Instance.new("UICorner", PlatformBadge)
    pbc.CornerRadius = UDim.new(0, 4)

    local InfoContainer = Instance.new("Frame")
    InfoContainer.Size = UDim2.new(1, -32, 0, 245)
    InfoContainer.Position = UDim2.new(0, 16, 0, 90)
    InfoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    InfoContainer.BorderSizePixel = 0
    InfoContainer.Parent = CardFrame
    local icc = Instance.new("UICorner", InfoContainer)
    icc.CornerRadius = UDim.new(0, 10)

    local InfoList = Instance.new("UIListLayout", InfoContainer)
    InfoList.Padding = UDim.new(0, 5)

    local InfoPadding = Instance.new("UIPadding", InfoContainer)
    InfoPadding.PaddingTop = UDim.new(0, 8)
    InfoPadding.PaddingLeft = UDim.new(0, 10)
    InfoPadding.PaddingRight = UDim.new(0, 10)

    local valueLabels = {}
    local function addInfoRow(key, title, defaultValue)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundTransparency = 1
        row.Parent = InfoContainer

        local tLbl = Instance.new("TextLabel")
        tLbl.Size = UDim2.new(0.45, 0, 1, 0)
        tLbl.BackgroundTransparency = 1
        tLbl.Text = title
        tLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
        tLbl.Font = Enum.Font.GothamMedium
        tLbl.TextSize = 11
        tLbl.TextXAlignment = Enum.TextXAlignment.Left
        tLbl.Parent = row

        local vLbl = Instance.new("TextLabel")
        vLbl.Size = UDim2.new(0.55, 0, 1, 0)
        vLbl.Position = UDim2.new(0.45, 0, 0, 0)
        vLbl.BackgroundTransparency = 1
        vLbl.Text = tostring(defaultValue)
        vLbl.TextColor3 = Color3.fromRGB(230, 230, 245)
        vLbl.Font = Enum.Font.GothamBold
        vLbl.TextSize = 11
        vLbl.TextXAlignment = Enum.TextXAlignment.Right
        vLbl.Parent = row

        valueLabels[key] = vLbl
    end

    local rankInGroup = pcall(function() return targetPlayer:GetRankInGroup(game.CreatorId) end) and targetPlayer:GetRankInGroup(game.CreatorId) or"N/A"

    addInfoRow("UserId","ID Utilisateur:", targetPlayer.UserId)
    addInfoRow("AccountAge","Âge du Compte:", targetPlayer.AccountAge .."jours")
    addInfoRow("Health","Santé (Health):","Chargement...")
    addInfoRow("Speed","Vitesse (WalkSpeed):","Chargement...")
    addInfoRow("Distance","Distance:","Chargement...")
    addInfoRow("Tool","Objet en main:","Chargement...")
    addInfoRow("Team","Équipe (Team):", targetPlayer.Team and targetPlayer.Team.Name or"Aucune")
    addInfoRow("Rank","Rang Créateur:", rankInGroup)

    local HealthBarBg = Instance.new("Frame")
    HealthBarBg.Size = UDim2.new(1, 0, 0, 6)
    HealthBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    HealthBarBg.BorderSizePixel = 0
    HealthBarBg.Parent = InfoContainer
    local hbgc = Instance.new("UICorner", HealthBarBg)
    hbgc.CornerRadius = UDim.new(1, 0)

    local HealthBarFill = Instance.new("Frame")
    HealthBarFill.Size = UDim2.new(1, 0, 1, 0)
    HealthBarFill.BackgroundColor3 = Color3.fromRGB(0, 230, 120)
    HealthBarFill.BorderSizePixel = 0
    HealthBarFill.Parent = HealthBarBg
    local hfc = Instance.new("UICorner", HealthBarFill)
    hfc.CornerRadius = UDim.new(1, 0)

    task.spawn(function()
        while CardFrame.Parent and targetPlayer and targetPlayer.Parent do
            pcall(function()
                local char = targetPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local localHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local dist = (hrp and localHrp) and math.floor((localHrp.Position - hrp.Position).Magnitude) or"?"
                local tool = char and char:FindFirstChildOfClass("Tool")

                if hum then
                    local hp = math.floor(hum.Health)
                    local maxHp = math.floor(hum.MaxHealth)
                    valueLabels["Health"].Text = hp .."/".. maxHp
                    local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    TweenService:Create(HealthBarFill, TweenInfo.new(0.2), {
                        Size = UDim2.new(pct, 0, 1, 0),
                        BackgroundColor3 = Color3.fromRGB(math.floor(255 * (1 - pct)), math.floor(255 * pct), 80)
                    }):Play()
                    valueLabels["Speed"].Text = math.floor(hum.WalkSpeed) .."studs/s"
                else
                    valueLabels["Health"].Text ="Mort / Inc"
                    valueLabels["Speed"].Text ="N/A"
                    HealthBarFill.Size = UDim2.new(0, 0, 1, 0)
                end

                valueLabels["Distance"].Text = dist .."m"
                valueLabels["Tool"].Text = tool and ("[".. tool.Name .."]") or"Aucun"
                valueLabels["Team"].Text = targetPlayer.Team and targetPlayer.Team.Name or"Aucune"
            end)
            task.wait(0.1)
        end
    end)

    local ActionsContainer = Instance.new("Frame")
    ActionsContainer.Size = UDim2.new(1, -32, 0, 120)
    ActionsContainer.Position = UDim2.new(0, 16, 0, 345)
    ActionsContainer.BackgroundTransparency = 1
    ActionsContainer.Parent = CardFrame

    local ActionGrid = Instance.new("UIGridLayout", ActionsContainer)
    ActionGrid.CellSize = UDim2.new(0, 95, 0, 32)
    ActionGrid.CellPadding = UDim2.new(0, 8, 0, 8)

    local function createActionButton(initialText, defaultCol, activeCol, isActiveFunc, onClick)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = defaultCol
        btn.Text = initialText
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.Parent = ActionsContainer

        local bc = Instance.new("UICorner", btn)
        bc.CornerRadius = UDim.new(0, 8)

        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(255, 255, 255)
        bs.Transparency = 0.85
        bs.Thickness = 1

        local function updateButtonVisual()
            local isActive = isActiveFunc and isActiveFunc()
            local targetColor = isActive and activeCol or defaultCol
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        end

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 97, 0, 34)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 95, 0, 32)}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            onClick(btn, updateButtonVisual)
            updateButtonVisual()
        end)

        updateButtonVisual()
        return btn
    end

    createActionButton("Teleport", Color3.fromRGB(30, 80, 150), Color3.fromRGB(50, 140, 250), nil, function(btn)
        if _G.teleportToPlayer then
            _G.teleportToPlayer(targetPlayer)
        elseif teleportToPlayer then
            teleportToPlayer(targetPlayer)
        end
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 200, 120)}):Play()
        task.delay(0.3, function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 80, 150)}):Play() end)
    end)

    createActionButton("Spectate", Color3.fromRGB(30, 100, 75), Color3.fromRGB(220, 60, 60), function()
        return V.Spectate and V.SelPlayer == targetPlayer
    end, function(btn, refresh)
        if V.Spectate and V.SelPlayer == targetPlayer then
            stopSpectate()
            btn.Text ="Spectate"
        else
            if V.Spectate then stopSpectate() end
            startSpectate(targetPlayer)
            btn.Text ="Stop Spec"
        end
    end)

    createActionButton("Fling", Color3.fromRGB(150, 40, 40), Color3.fromRGB(240, 70, 70), function()
        return V.Flinging and V.FlingTarget == targetPlayer
    end, function(btn, refresh)
        if V.Flinging and V.FlingTarget == targetPlayer then
            stopFling()
            btn.Text ="Fling"
        else
            if V.Flinging then stopFling() end
            startFling(targetPlayer)
            btn.Text ="Stop Fling"
        end
    end)

    createActionButton("Attach", Color3.fromRGB(110, 50, 150), Color3.fromRGB(220, 60, 60), function()
        return V.Attached == targetPlayer
    end, function(btn, refresh)
        if _G.toggleAttach then
            _G.toggleAttach(targetPlayer)
        elseif V.Attached == targetPlayer then
            if _G.stopAttach then _G.stopAttach() elseif stopAttach then stopAttach() end
        else
            if _G.startAttach then _G.startAttach(targetPlayer) elseif startAttach then startAttach(targetPlayer) end
        end
        local isAtt = (V.Attached == targetPlayer)
        btn.Text = isAtt and "Detach" or "Attach"
        if refresh then refresh() end
    end)

    createActionButton("Copier ID", Color3.fromRGB(45, 45, 60), Color3.fromRGB(45, 45, 60), nil, function(btn)
        if setclipboard then
            setclipboard(tostring(targetPlayer.UserId))
            notify("Inspector","ID Utilisateur copié !", Color3.fromRGB(80, 200, 120))
        else
            notify("Inspector","Presse-papier non supporté", Color3.fromRGB(255, 90, 90))
        end
    end)

    createActionButton("Copier Outfit", Color3.fromRGB(130, 50, 160), Color3.fromRGB(130, 50, 160), nil, function(btn)
        pcall(function()
            local myChar = LocalPlayer.Character
            local tChar = targetPlayer.Character
            if not myChar or not tChar then return end

            for _, item in pairs(myChar:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
                    item:Destroy()
                end
            end

            for _, item in pairs(tChar:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
                    item:Clone().Parent = myChar
                end
            end

            local tHead = tChar:FindFirstChild("Head")
            local myHead = myChar:FindFirstChild("Head")
            if tHead and myHead then
                local tFace = tHead:FindFirstChildOfClass("Decal")
                local myFace = myHead:FindFirstChildOfClass("Decal")
                if tFace then
                    if myFace then myFace.Texture = tFace.Texture
                    else
                        local newFace = tFace:Clone()
                        newFace.Parent = myHead
                    end
                end
            end

            notify("Cosmetics","Tenue de".. targetPlayer.Name .."copiée !", Color3.fromRGB(80, 200, 120))
        end)
    end)

    createActionButton("Warp to Car", Color3.fromRGB(40, 110, 140), Color3.fromRGB(60, 160, 200), nil, function(btn)
        if _G.warpToPlayerCar then
            _G.warpToPlayerCar(targetPlayer)
        end
    end)
end

if V.InspectorClickConn then V.InspectorClickConn:Disconnect() end
V.InspectorClickConn = UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
    if input.UserInputState ~= Enum.UserInputState.Begin then return end
    if not V.RightClickInspect then return end
    pcall(function()
        local mouseLoc = UserInputService:GetMouseLocation()
        local unitRay = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        if LocalPlayer.Character then
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        end
        local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
        if result and result.Instance then
            local model = result.Instance:FindFirstAncestorOfClass("Model")
            if model then
                local targetPlayer = Players:GetPlayerFromCharacter(model)
                if targetPlayer and targetPlayer ~= LocalPlayer then
                    openPlayerInspector(targetPlayer)
                end
            end
        end
    end)
end)

Players.PlayerAdded:Connect(function(p)
    if V.PlayerJoinLeaveNotifs then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title ="Joueur Rejoint",
            Text = p.DisplayName .."(@".. p.Name ..") a rejoint la partie.",
            Duration = 6,
            Icon ="rbxthumb://type=AvatarHeadShot&id=".. p.UserId .."&w=150&h=150"
        })
    end
end)

Players.PlayerRemoving:Connect(function(p)
    if V.PlayerJoinLeaveNotifs then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title ="Joueur Quitté",
            Text = p.DisplayName .."(@".. p.Name ..") a quitté la partie.",
            Duration = 6,
            Icon ="rbxthumb://type=AvatarHeadShot&id=".. p.UserId .."&w=150&h=150"
        })
    end
end)

task.spawn(function()
    while task.wait(10) do
        if V.AntiCheatAlert then
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") then
                        local n = obj.Name:lower()
                        if n:find("anticheat") or n:find("speedcheck") or n:find("ban") or n:find("detector") then
                            notify("Security Alert","Anti-Cheat détecté dans la carte:".. obj.Name, Color3.fromRGB(255, 165, 0))
                            break
                        end
                    end
                end
            end)
        end
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if V.SpeedEnabled and V.Speed then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hum.SeatPart then return end 
            if hum and hrp then
                local method = V.SpeedMethod or"Humanoid"
                if method =="Humanoid"then
                    hum.WalkSpeed = V.Speed
                elseif method =="CFrame (Bypass)"or method =="CFrame"then
                    
                    if hum.MoveDirection.Magnitude > 0 then
                        local dt = math.clamp(deltaTime or 1 / 60, 1 / 240, 1 / 20)
                        local vel = hum.MoveDirection * V.Speed
                        hrp.CFrame = hrp.CFrame + vel * dt
                        hrp.AssemblyLinearVelocity = vel + Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    else
                        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                    end
                elseif method =="Velocity"then
                    if hum.MoveDirection.Magnitude > 0 then
                        local yVel = hrp.AssemblyLinearVelocity.Y
                        hrp.AssemblyLinearVelocity = hum.MoveDirection * V.Speed + Vector3.new(0, yVel, 0)
                    end
                elseif method =="VectorForce"then
                    if hum.MoveDirection.Magnitude > 0 then
                        hrp.AssemblyLinearVelocity = hum.MoveDirection * (V.Speed * 1.4)
                    end
                end
            end
        end)
    end
end)

end
local initOk, initErr = pcall(initFeatures)
if not initOk then
    warn("Nebula init error: ".. tostring(initErr))
    pcall(function()
        local errBanner = Instance.new("TextLabel")
        errBanner.Size = UDim2.new(1, -40, 0, 60)
        errBanner.Position = UDim2.new(0.5, 0, 0, 8)
        errBanner.AnchorPoint = Vector2.new(0.5, 0)
        errBanner.BackgroundColor3 = Color3.fromRGB(70, 15, 15)
        errBanner.BorderSizePixel = 0
        errBanner.ZIndex = 999
        errBanner.Text = "ERREUR INIT [".. tostring(initStep or "?") .."]: ".. tostring(initErr)
        errBanner.TextColor3 = Color3.fromRGB(255, 130, 130)
        errBanner.Font = Enum.Font.GothamBold
        errBanner.TextSize = 13
        errBanner.TextWrapped = true
        errBanner.Parent = ScreenGui
    end)
end
