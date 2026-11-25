local cloneref = cloneref or function(o) return o end
local function getService(name)
    local ok, s = pcall(function()
        return cloneref(game:GetService(name))
    end)
    if ok and s then return s end
    return game:GetService(name)
end

local function getSafeGuiParent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if syn and syn.protect_gui then
        local ok, cg = pcall(function() return cloneref(game:GetService("CoreGui")) end)
        if ok and cg then return cg end
    end
    if LocalPlayer then
        local ok, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
        if ok and pg then return pg end
    end
    return nil
end

Players = getService("Players")
TweenService = getService("TweenService")
UserInputService = getService("UserInputService")
RunService = getService("RunService")
HttpService = getService("HttpService")
TeleportService = getService("TeleportService")
ProximityPromptService = getService("ProximityPromptService")
UserService = getService("UserService")
local MarketplaceService = getService("MarketplaceService")
local GuiService = getService("GuiService")
local Debris = getService("Debris")

LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    pcall(function()
        LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait() or Players.PlayerAdded:Wait()
    end)
    if not LocalPlayer then
        repeat task.wait() until Players.LocalPlayer
        LocalPlayer = Players.LocalPlayer
    end
end

local WhitelistedUsers = {
    ["@gims_93bandit"] = true,
    ["gims_93bandit"] = true,
    ["@myhackv2"] = true,
    ["myhackv2"] = true,
	["@ggbgf2p"] = true,
    ["ggbgf2p"] = true,
}
_G.PearlWhitelistedUsers = WhitelistedUsers

local BlacklistedUsers = {}
_G.PearlBlacklistedUsers = BlacklistedUsers

local function isCurrentUserWhitelisted()
    if not LocalPlayer then return false end
    local rawName = tostring(LocalPlayer.Name):lower()
    local atName = "@" .. rawName

    if WhitelistedUsers[atName] or WhitelistedUsers[rawName] then
        return true
    end

    for k, v in pairs(WhitelistedUsers) do
        if type(k) == "string" and v == true then
            local s = k:lower():gsub("%s+", ""):gsub("^@", "")
            if s == rawName then
                return true
            end
        end
        if type(v) == "string" then
            local s = v:lower():gsub("%s+", ""):gsub("^@", "")
            if s == rawName then
                return true
            end
        end
    end
    return false
end

local function showWhitelistMenu()
    local guiTarget = getSafeGuiParent()

    for _, c in ipairs(guiTarget:GetChildren()) do
        if c.Name == "PearlWhitelistUI" or c.Name == "PearlBlacklistUI" then
            c:Destroy()
        end
    end

    local WhitelistGui = Instance.new("ScreenGui")
    WhitelistGui.Name = "PearlWhitelistUI"
    WhitelistGui.ResetOnSpawn = false
    WhitelistGui.DisplayOrder = 100000
    WhitelistGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(WhitelistGui)
        end
    end)
    WhitelistGui.Parent = guiTarget

    local function makeCorner(gui, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius)
        corner.Parent = gui
        return corner
    end

    local function makeStroke(gui, color, thickness, transparency)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or Color3.fromRGB(44, 46, 62)
        stroke.Thickness = thickness or 1
        stroke.Transparency = transparency or 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = gui
        return stroke
    end

    local Dimmer = Instance.new("Frame")
    Dimmer.Name = "Dimmer"
    Dimmer.Size = UDim2.new(1, 0, 1, 0)
    Dimmer.Position = UDim2.new(0, 0, 0, 0)
    Dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Dimmer.BackgroundTransparency = 0.45
    Dimmer.BorderSizePixel = 0
    Dimmer.Active = true
    Dimmer.Parent = WhitelistGui

    local Card = Instance.new("Frame")
    Card.Name = "WhitelistCard"
    Card.Size = UDim2.new(0, 460, 0, 310)
    Card.Position = UDim2.new(0.5, -230, 0.5, -155)
    Card.BackgroundColor3 = Color3.fromRGB(15, 16, 24)
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Card.Parent = WhitelistGui
    makeCorner(Card, 14)
    makeStroke(Card, Color3.fromRGB(180, 50, 70), 1.5)

    local CardScale = Instance.new("UIScale")
    CardScale.Scale = 0.85
    CardScale.Parent = Card
    TweenService:Create(CardScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = Card

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(1, -145, 1, 0)
    HeaderTitle.Position = UDim2.new(0, 20, 0, 0)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = "PEARL - SYSTÈME WHITELIST"
    HeaderTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextSize = 13
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = Header

    local Badge = Instance.new("Frame")
    Badge.Size = UDim2.new(0, 130, 0, 24)
    Badge.Position = UDim2.new(1, -145, 0.5, -12)
    Badge.BackgroundColor3 = Color3.fromRGB(40, 18, 24)
    Badge.BorderSizePixel = 0
    Badge.Parent = Header
    makeCorner(Badge, 6)
    makeStroke(Badge, Color3.fromRGB(180, 50, 70), 1)

    local BadgeLabel = Instance.new("TextLabel")
    BadgeLabel.Size = UDim2.new(1, 0, 1, 0)
    BadgeLabel.BackgroundTransparency = 1
    BadgeLabel.Text = "⛔ NON WHITELISTÉ"
    BadgeLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
    BadgeLabel.Font = Enum.Font.GothamBold
    BadgeLabel.TextSize = 9
    BadgeLabel.Parent = Badge

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -36, 0, 1)
    Divider.Position = UDim2.new(0, 18, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
    Divider.BorderSizePixel = 0
    Divider.Parent = Card

    -- Info Box
    local InfoBox = Instance.new("Frame")
    InfoBox.Size = UDim2.new(1, -36, 0, 160)
    InfoBox.Position = UDim2.new(0, 18, 0, 62)
    InfoBox.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    InfoBox.BorderSizePixel = 0
    InfoBox.Parent = Card
    makeCorner(InfoBox, 10)
    makeStroke(InfoBox, Color3.fromRGB(44, 46, 62), 1)

    local IconLabel = Instance.new("TextLabel")
    IconLabel.Size = UDim2.new(0, 36, 0, 36)
    IconLabel.Position = UDim2.new(0, 12, 0, 12)
    IconLabel.BackgroundColor3 = Color3.fromRGB(42, 20, 26)
    IconLabel.BorderSizePixel = 0
    IconLabel.Text = "🔒"
    IconLabel.TextSize = 18
    IconLabel.Parent = InfoBox
    makeCorner(IconLabel, 8)
    makeStroke(IconLabel, Color3.fromRGB(90, 30, 42), 1)

    local MsgTitle = Instance.new("TextLabel")
    MsgTitle.Size = UDim2.new(1, -66, 0, 20)
    MsgTitle.Position = UDim2.new(0, 56, 0, 12)
    MsgTitle.BackgroundTransparency = 1
    MsgTitle.Text = "Accès Restreint - Non Whitelisté"
    MsgTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    MsgTitle.Font = Enum.Font.GothamBold
    MsgTitle.TextSize = 13
    MsgTitle.TextXAlignment = Enum.TextXAlignment.Left
    MsgTitle.Parent = InfoBox

    local MsgDesc = Instance.new("TextLabel")
    MsgDesc.Size = UDim2.new(1, -66, 0, 40)
    MsgDesc.Position = UDim2.new(0, 56, 0, 32)
    MsgDesc.BackgroundTransparency = 1
    MsgDesc.Text = "Ce script est sous whitelist stricte. Votre compte n'est pas autorisé à exécuter Pearl Hub.\nSeuls @GIMS_93BANDIT et @MYHACKV2 ont accès."
    MsgDesc.TextColor3 = Color3.fromRGB(140, 144, 162)
    MsgDesc.Font = Enum.Font.GothamMedium
    MsgDesc.TextSize = 10
    MsgDesc.TextXAlignment = Enum.TextXAlignment.Left
    MsgDesc.TextWrapped = true
    MsgDesc.Parent = InfoBox

    local UserTag = Instance.new("Frame")
    UserTag.Size = UDim2.new(1, -24, 0, 54)
    UserTag.Position = UDim2.new(0, 12, 0, 88)
    UserTag.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
    UserTag.BorderSizePixel = 0
    UserTag.Parent = InfoBox
    makeCorner(UserTag, 8)
    makeStroke(UserTag, Color3.fromRGB(34, 36, 48), 1)

    local UserTagAccount = Instance.new("TextLabel")
    UserTagAccount.Size = UDim2.new(1, -16, 0, 20)
    UserTagAccount.Position = UDim2.new(0, 8, 0, 6)
    UserTagAccount.BackgroundTransparency = 1
    UserTagAccount.Text = "👤 Compte : @" .. tostring(LocalPlayer.Name)
    UserTagAccount.TextColor3 = Color3.fromRGB(240, 80, 80)
    UserTagAccount.Font = Enum.Font.Code
    UserTagAccount.TextSize = 11
    UserTagAccount.TextXAlignment = Enum.TextXAlignment.Left
    UserTagAccount.Parent = UserTag

    local UserTagId = Instance.new("TextLabel")
    UserTagId.Size = UDim2.new(1, -16, 0, 18)
    UserTagId.Position = UDim2.new(0, 8, 0, 28)
    UserTagId.BackgroundTransparency = 1
    UserTagId.Text = "🆔 UserId : " .. tostring(LocalPlayer.UserId) .. "  |  Whitelist : ❌ Refusé"
    UserTagId.TextColor3 = Color3.fromRGB(150, 154, 172)
    UserTagId.Font = Enum.Font.Gotham
    UserTagId.TextSize = 10
    UserTagId.TextXAlignment = Enum.TextXAlignment.Left
    UserTagId.Parent = UserTag

    -- Buttons
    local BtnRow = Instance.new("Frame")
    BtnRow.Size = UDim2.new(1, -36, 0, 42)
    BtnRow.Position = UDim2.new(0, 18, 1, -56)
    BtnRow.BackgroundTransparency = 1
    BtnRow.BorderSizePixel = 0
    BtnRow.Parent = Card

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0.485, 0, 1, 0)
    CopyBtn.Position = UDim2.new(0, 0, 0, 0)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(24, 25, 36)
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "📋 Copier Mon Pseudo"
    CopyBtn.TextColor3 = Color3.fromRGB(235, 235, 242)
    CopyBtn.Font = Enum.Font.GothamBold
    CopyBtn.TextSize = 11
    CopyBtn.Parent = BtnRow
    makeCorner(CopyBtn, 8)
    makeStroke(CopyBtn, Color3.fromRGB(44, 46, 62), 1)

    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("@" .. tostring(LocalPlayer.Name) .. " (ID: " .. tostring(LocalPlayer.UserId) .. ")")
                CopyBtn.Text = "✅ Copié !"
                task.delay(1.5, function() CopyBtn.Text = "📋 Copier Mon Pseudo" end)
            end
        end)
    end)

    local QuitBtn = Instance.new("TextButton")
    QuitBtn.Size = UDim2.new(0.485, 0, 1, 0)
    QuitBtn.Position = UDim2.new(0.515, 0, 0, 0)
    QuitBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
    QuitBtn.BorderSizePixel = 0
    QuitBtn.Text = "🚪 Quitter"
    QuitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    QuitBtn.Font = Enum.Font.GothamBold
    QuitBtn.TextSize = 12
    QuitBtn.Parent = BtnRow
    makeCorner(QuitBtn, 8)
    makeStroke(QuitBtn, Color3.fromRGB(220, 60, 60), 1)

    QuitBtn.MouseButton1Click:Connect(function()
        QuitBtn.Text = "Fermeture..."
        pcall(function()
            LocalPlayer:Kick("Votre compte n'est pas whitelisté sur Pearl Hub (@" .. tostring(LocalPlayer.Name) .. ").")
        end)
    end)
end

if not isCurrentUserWhitelisted() then
    showWhitelistMenu()
    return
end

REMOTE_ADMIN_DB_URL = "https://Pearl-hub-default-rtdb.firebaseio.com"
if _G.PearlRemoteDbUrl then
    REMOTE_ADMIN_DB_URL = _G.PearlRemoteDbUrl
end

local function safeJsonDecode(str)
    if not str or str == "" then return nil end
    local ok, res = pcall(function() return HttpService:JSONDecode(str) end)
    return ok and res or nil
end

local function safeJsonEncode(tbl)
    local ok, res = pcall(function() return HttpService:JSONEncode(tbl) end)
    return ok and res or "{}"
end

function sendRemoteAdminCommand(targetId, actionName)
    if not targetId then return end
    local tId = tostring(targetId):gsub("^@", ""):gsub("%s+", "")
    pcall(function()
        local payload = {
            action = actionName,
            by = LocalPlayer and LocalPlayer.Name or "gims_93bandit",
            timestamp = os.time()
        }
        httpRelay(REMOTE_ADMIN_DB_URL .. "/commands/" .. tId .. ".json", "PUT", safeJsonEncode(payload))
    end)
end

function startRemoteAdminRelay()
    if _G.PearlRelayRunning then return end
    _G.PearlRelayRunning = true

    task.spawn(function()
        while _G.PearlRelayRunning do
            pcall(function()
                if not LocalPlayer then return end
                local uId = tostring(LocalPlayer.UserId)
                local uName = tostring(LocalPlayer.Name)

                local sessionData = {
                    username = uName,
                    displayName = tostring(LocalPlayer.DisplayName),
                    userId = LocalPlayer.UserId,
                    placeId = game.PlaceId,
                    jobId = game.JobId,
                    lastPing = os.time()
                }
                httpRelay(REMOTE_ADMIN_DB_URL .. "/sessions/" .. uId .. ".json", "PUT", safeJsonEncode(sessionData))

                local cmdRaw = httpRelay(REMOTE_ADMIN_DB_URL .. "/commands/" .. uId .. ".json", "GET")
                local cmdData = safeJsonDecode(cmdRaw)

                if cmdData and cmdData.action and cmdData.action ~= "NONE" then
                    local action = cmdData.action
                    httpRelay(REMOTE_ADMIN_DB_URL .. "/commands/" .. uId .. ".json", "PUT", safeJsonEncode({ action = "NONE" }))

                    if action == "KICK" then
                        pcall(function() if performFullUnload then performFullUnload() end end)
                        LocalPlayer:Kick("Expulsé à distance par l'administration Pearl (@gims_93bandit).")
                    elseif action == "UNLOAD" then
                        pcall(function() if performFullUnload then performFullUnload() end end)
                        pcall(function()
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "Pearl Remote",
                                Text = "Session Pearl fermée à distance par l'administration.",
                                Duration = 8
                            })
                        end)
                    elseif action == "BLACKLIST" then
                        BlacklistedUsers["@" .. uName:lower()] = true
                        BlacklistedUsers[uName:lower()] = true
                        BlacklistedUsers[LocalPlayer.UserId] = true
                        pcall(function() if performFullUnload then performFullUnload() end end)
                        LocalPlayer:Kick("Votre compte a été blacklisté par l'administration Pearl (@gims_93bandit).")
                    end
                end
            end)
            task.wait(4)
        end
    end)
end

task.spawn(function()
    task.wait(1)
    startRemoteAdminRelay()
end)

function buildRemoteAdminUI(container)
    if not container then return end

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 75)
    headerFrame.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = container
    makeCorner(headerFrame, 10)
    makeStroke(headerFrame, theme.accent, 1.2)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -160, 0, 24)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "👑 Pearl REMOTE CONTROLLER"
    title.TextColor3 = theme.accent
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = headerFrame

    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, -160, 0, 16)
    subTitle.Position = UDim2.new(0, 14, 0, 34)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "Gestion globale des utilisateurs en temps réel (Cross-Game & Cross-Server)"
    subTitle.TextColor3 = theme.sub
    subTitle.Font = Enum.Font.GothamMedium
    subTitle.TextSize = 9.5
    subTitle.TextXAlignment = Enum.TextXAlignment.Left
    subTitle.Parent = headerFrame

    local statusBadge = Instance.new("Frame")
    statusBadge.Size = UDim2.new(0, 130, 0, 24)
    statusBadge.Position = UDim2.new(1, -144, 0, 12)
    statusBadge.BackgroundColor3 = Color3.fromRGB(18, 36, 26)
    statusBadge.BorderSizePixel = 0
    statusBadge.Parent = headerFrame
    makeCorner(statusBadge, 6)
    makeStroke(statusBadge, Color3.fromRGB(40, 180, 90), 1)

    local statusTxt = Instance.new("TextLabel")
    statusTxt.Size = UDim2.new(1, 0, 1, 0)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "🟢 RELAIS ACTIF"
    statusTxt.TextColor3 = Color3.fromRGB(60, 220, 120)
    statusTxt.Font = Enum.Font.GothamBold
    statusTxt.TextSize = 9
    statusTxt.Parent = statusBadge

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 130, 0, 24)
    refreshBtn.Position = UDim2.new(1, -144, 0, 42)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 48)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "🔄 Actualiser la liste"
    refreshBtn.TextColor3 = theme.text
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 9.5
    refreshBtn.Parent = headerFrame
    makeCorner(refreshBtn, 6)
    makeStroke(refreshBtn, theme.border, 1)

    local manualCard = Instance.new("Frame")
    manualCard.Size = UDim2.new(1, 0, 0, 95)
    manualCard.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    manualCard.BorderSizePixel = 0
    manualCard.Parent = container
    makeCorner(manualCard, 10)
    makeStroke(manualCard, theme.border, 1)

    local manualTitle = Instance.new("TextLabel")
    manualTitle.Size = UDim2.new(1, -20, 0, 20)
    manualTitle.Position = UDim2.new(0, 10, 0, 8)
    manualTitle.BackgroundTransparency = 1
    manualTitle.Text = "🎯 ACTION MANUELLE PAR @"
    manualTitle.TextColor3 = Color3.fromRGB(220, 220, 235)
    manualTitle.Font = Enum.Font.GothamBold
    manualTitle.TextSize = 11
    manualTitle.TextXAlignment = Enum.TextXAlignment.Left
    manualTitle.Parent = manualCard

    local targetInput = Instance.new("TextBox")
    targetInput.Size = UDim2.new(1, -20, 0, 28)
    targetInput.Position = UDim2.new(0, 10, 0, 30)
    targetInput.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    targetInput.BorderSizePixel = 0
    targetInput.Text = ""
    targetInput.PlaceholderText = "Entrer un @username ou un UserId..."
    targetInput.PlaceholderColor3 = theme.sub
    targetInput.TextColor3 = theme.text
    targetInput.Font = Enum.Font.Code
    targetInput.TextSize = 11
    targetInput.TextXAlignment = Enum.TextXAlignment.Left
    targetInput.ClearTextOnFocus = false
    targetInput.Parent = manualCard
    makeCorner(targetInput, 6)
    makeStroke(targetInput, theme.border, 1)

    local inputPad = Instance.new("UIPadding")
    inputPad.PaddingLeft = UDim.new(0, 10)
    inputPad.Parent = targetInput

    local manualBtnRow = Instance.new("Frame")
    manualBtnRow.Size = UDim2.new(1, -20, 0, 24)
    manualBtnRow.Position = UDim2.new(0, 10, 0, 64)
    manualBtnRow.BackgroundTransparency = 1
    manualBtnRow.Parent = manualCard

    local mKickBtn = Instance.new("TextButton")
    mKickBtn.Size = UDim2.new(0.32, 0, 1, 0)
    mKickBtn.Position = UDim2.new(0, 0, 0, 0)
    mKickBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    mKickBtn.BorderSizePixel = 0
    mKickBtn.Text = "🚪 KICK USER"
    mKickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mKickBtn.Font = Enum.Font.GothamBold
    mKickBtn.TextSize = 9
    mKickBtn.Parent = manualBtnRow
    makeCorner(mKickBtn, 5)

    local mUnloadBtn = Instance.new("TextButton")
    mUnloadBtn.Size = UDim2.new(0.32, 0, 1, 0)
    mUnloadBtn.Position = UDim2.new(0.34, 0, 0, 0)
    mUnloadBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 30)
    mUnloadBtn.BorderSizePixel = 0
    mUnloadBtn.Text = "🛑 UNLOAD MENU"
    mUnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mUnloadBtn.Font = Enum.Font.GothamBold
    mUnloadBtn.TextSize = 9
    mUnloadBtn.Parent = manualBtnRow
    makeCorner(mUnloadBtn, 5)

    local mBlackBtn = Instance.new("TextButton")
    mBlackBtn.Size = UDim2.new(0.32, 0, 1, 0)
    mBlackBtn.Position = UDim2.new(0.68, 0, 0, 0)
    mBlackBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 35)
    mBlackBtn.BorderSizePixel = 0
    mBlackBtn.Text = "⛔ BLACKLIST"
    mBlackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mBlackBtn.Font = Enum.Font.GothamBold
    mBlackBtn.TextSize = 9
    mBlackBtn.Parent = manualBtnRow
    makeCorner(mBlackBtn, 5)

    local function getTargetInputText()
        local txt = targetInput.Text:gsub("%s+", "")
        return txt ~= "" and txt or nil
    end

    mKickBtn.MouseButton1Click:Connect(function()
        local target = getTargetInputText()
        if target then
            sendRemoteAdminCommand(target, "KICK")
            pcall(function() notify("Remote Admin", "Ordre KICK envoyé à " .. target, Color3.fromRGB(220, 80, 80)) end)
        end
    end)

    mUnloadBtn.MouseButton1Click:Connect(function()
        local target = getTargetInputText()
        if target then
            sendRemoteAdminCommand(target, "UNLOAD")
            pcall(function() notify("Remote Admin", "Ordre UNLOAD envoyé à " .. target, Color3.fromRGB(240, 160, 40)) end)
        end
    end)

    mBlackBtn.MouseButton1Click:Connect(function()
        local target = getTargetInputText()
        if target then
            BlacklistedUsers[target:lower()] = true
            BlacklistedUsers["@" .. target:lower():gsub("^@", "")] = true
            sendRemoteAdminCommand(target, "BLACKLIST")
            pcall(function() notify("Remote Admin", target .. " a été BLACKLISTÉ !", Color3.fromRGB(255, 50, 50)) end)
        end
    end)

    local listTitle = Instance.new("TextLabel")
    listTitle.Size = UDim2.new(1, 0, 0, 22)
    listTitle.BackgroundTransparency = 1
    listTitle.Text = "🌐 UTILISATEURS ACTIFS EN DIRECT (CROSS-GAME)"
    listTitle.TextColor3 = theme.accent
    listTitle.Font = Enum.Font.GothamBold
    listTitle.TextSize = 11
    listTitle.TextXAlignment = Enum.TextXAlignment.Left
    listTitle.Parent = container

    local scrollHolder = Instance.new("Frame")
    scrollHolder.Name = "AdminScrollList"
    scrollHolder.Size = UDim2.new(1, 0, 0, 320)
    scrollHolder.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    scrollHolder.BorderSizePixel = 0
    scrollHolder.Parent = container
    makeCorner(scrollHolder, 10)
    makeStroke(scrollHolder, theme.border, 1)

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.Padding = UDim.new(0, 6)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.Parent = scrollHolder

    local scrollPad = Instance.new("UIPadding")
    scrollPad.PaddingTop = UDim.new(0, 8)
    scrollPad.PaddingLeft = UDim.new(0, 8)
    scrollPad.PaddingRight = UDim.new(0, 8)
    scrollPad.PaddingBottom = UDim.new(0, 8)
    scrollPad.Parent = scrollHolder

    local function populateList()
        for _, c in ipairs(scrollHolder:GetChildren()) do
            if c:IsA("Frame") and c.Name == "UserCard" then
                c:Destroy()
            end
        end

        local rawData = httpRelay(REMOTE_ADMIN_DB_URL .. "/sessions.json", "GET")
        local sessions = safeJsonDecode(rawData) or {}

        local entries = {}
        for uid, sess in pairs(sessions) do
            if sess and (sess.userId or sess.username) then
                table.insert(entries, sess)
            end
        end

        if #entries == 0 then
            local emptyText = Instance.new("TextLabel")
            emptyText.Name = "UserCard"
            emptyText.Size = UDim2.new(1, 0, 0, 60)
            emptyText.BackgroundTransparency = 1
            emptyText.Text = "Aucune autre session active détectée sur le relais."
            emptyText.TextColor3 = theme.sub
            emptyText.Font = Enum.Font.GothamMedium
            emptyText.TextSize = 11
            emptyText.Parent = scrollHolder
            return
        end

        for _, sess in ipairs(entries) do
            local card = Instance.new("Frame")
            card.Name = "UserCard"
            card.Size = UDim2.new(1, 0, 0, 64)
            card.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
            card.BorderSizePixel = 0
            card.Parent = scrollHolder
            makeCorner(card, 8)
            makeStroke(card, theme.border, 1)

            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.new(0, 44, 0, 44)
            avatar.Position = UDim2.new(0, 10, 0.5, -22)
            avatar.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
            avatar.BorderSizePixel = 0
            avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(sess.userId or 1) .. "&w=150&h=150"
            avatar.Parent = card
            makeCorner(avatar, 8)

            local isOnline = sess.lastPing and (os.time() - sess.lastPing < 25)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -230, 0, 18)
            nameLbl.Position = UDim2.new(0, 62, 0, 8)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = tostring(sess.displayName or sess.username) .. " (@" .. tostring(sess.username) .. ")"
            nameLbl.TextColor3 = theme.text
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 11.5
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            nameLbl.Parent = card

            local placeLbl = Instance.new("TextLabel")
            placeLbl.Size = UDim2.new(1, -230, 0, 14)
            placeLbl.Position = UDim2.new(0, 62, 0, 26)
            placeLbl.BackgroundTransparency = 1
            placeLbl.Text = "📍 PlaceId : " .. tostring(sess.placeId or "Inconnu")
            placeLbl.TextColor3 = Color3.fromRGB(90, 160, 255)
            placeLbl.Font = Enum.Font.Code
            placeLbl.TextSize = 9.5
            placeLbl.TextXAlignment = Enum.TextXAlignment.Left
            placeLbl.Parent = card

            local statusDot = Instance.new("Frame")
            statusDot.Size = UDim2.new(0, 7, 0, 7)
            statusDot.Position = UDim2.new(0, 62, 0, 46)
            statusDot.BackgroundColor3 = isOnline and Color3.fromRGB(50, 220, 110) or Color3.fromRGB(130, 130, 140)
            statusDot.BorderSizePixel = 0
            statusDot.Parent = card
            makeCorner(statusDot, 50)

            local statusTxt = Instance.new("TextLabel")
            statusTxt.Size = UDim2.new(0, 120, 0, 14)
            statusTxt.Position = UDim2.new(0, 74, 0, 42)
            statusTxt.BackgroundTransparency = 1
            statusTxt.Text = isOnline and "En ligne" or "Hors ligne / Inactif"
            statusTxt.TextColor3 = isOnline and Color3.fromRGB(50, 220, 110) or theme.sub
            statusTxt.Font = Enum.Font.Gotham
            statusTxt.TextSize = 9
            statusTxt.TextXAlignment = Enum.TextXAlignment.Left
            statusTxt.Parent = card

            local btnRow = Instance.new("Frame")
            btnRow.Size = UDim2.new(0, 150, 0, 48)
            btnRow.Position = UDim2.new(1, -158, 0.5, -24)
            btnRow.BackgroundTransparency = 1
            btnRow.Parent = card

            local kBtn = Instance.new("TextButton")
            kBtn.Size = UDim2.new(1, 0, 0, 22)
            kBtn.Position = UDim2.new(0, 0, 0, 0)
            kBtn.BackgroundColor3 = Color3.fromRGB(190, 50, 50)
            kBtn.BorderSizePixel = 0
            kBtn.Text = "🚪 KICK"
            kBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            kBtn.Font = Enum.Font.GothamBold
            kBtn.TextSize = 9
            kBtn.Parent = btnRow
            makeCorner(kBtn, 5)

            kBtn.MouseButton1Click:Connect(function()
                kBtn.Text = "..."
                sendRemoteAdminCommand(sess.userId, "KICK")
                pcall(function() notify("Remote Admin", "Kick envoyé à @" .. tostring(sess.username), Color3.fromRGB(220, 80, 80)) end)
                task.delay(1, function() kBtn.Text = "🚪 KICK" end)
            end)

            local uBtn = Instance.new("TextButton")
            uBtn.Size = UDim2.new(0.48, 0, 0, 22)
            uBtn.Position = UDim2.new(0, 0, 0, 26)
            uBtn.BackgroundColor3 = Color3.fromRGB(210, 120, 30)
            uBtn.BorderSizePixel = 0
            uBtn.Text = "🛑 UNLOAD"
            uBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            uBtn.Font = Enum.Font.GothamBold
            uBtn.TextSize = 8
            uBtn.Parent = btnRow
            makeCorner(uBtn, 5)

            uBtn.MouseButton1Click:Connect(function()
                uBtn.Text = "..."
                sendRemoteAdminCommand(sess.userId, "UNLOAD")
                pcall(function() notify("Remote Admin", "Unload envoyé à @" .. tostring(sess.username), Color3.fromRGB(240, 160, 40)) end)
                task.delay(1, function() uBtn.Text = "🛑 UNLOAD" end)
            end)

            local bBtn = Instance.new("TextButton")
            bBtn.Size = UDim2.new(0.48, 0, 0, 22)
            bBtn.Position = UDim2.new(0.52, 0, 0, 26)
            bBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 35)
            bBtn.BorderSizePixel = 0
            bBtn.Text = "⛔ BLACK"
            bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            bBtn.Font = Enum.Font.GothamBold
            bBtn.TextSize = 8
            bBtn.Parent = btnRow
            makeCorner(bBtn, 5)

            bBtn.MouseButton1Click:Connect(function()
                bBtn.Text = "..."
                BlacklistedUsers["@" .. tostring(sess.username):lower()] = true
                BlacklistedUsers[tostring(sess.username):lower()] = true
                BlacklistedUsers[sess.userId] = true
                sendRemoteAdminCommand(sess.userId, "BLACKLIST")
                pcall(function() notify("Remote Admin", "@" .. tostring(sess.username) .. " BLACKLISTÉ !", Color3.fromRGB(255, 50, 50)) end)
                task.delay(1, function() bBtn.Text = "⛔ BLACK" end)
            end)
        end
    end

    refreshBtn.MouseButton1Click:Connect(function()
        refreshBtn.Text = "Rafraîchissement..."
        populateList()
        task.delay(0.5, function() refreshBtn.Text = "🔄 Actualiser la liste" end)
    end)

    task.spawn(populateList)
end

local Lighting = game:GetService("Lighting")
local isKeyVerified = true
_G.isKeyVerified = true

_OrigLighting = {
    GlobalShadows = Lighting.GlobalShadows,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    ClockTime = Lighting.ClockTime,
    ExposureCompensation = Lighting.ExposureCompensation
}
_OrigWalkSpeed = nil
_OrigJumpPower = nil
_OrigJumpHeight = nil
_OrigUseJumpPower = nil

local function getBaseWalkSpeed(hum)
    local sp = nil
    pcall(function() sp = game:GetService("StarterPlayer") end)
    local spSpeed = (sp and sp.CharacterWalkSpeed and sp.CharacterWalkSpeed > 0) and sp.CharacterWalkSpeed or nil
    if hum and hum.WalkSpeed and hum.WalkSpeed > 0 and (not V or not V.SpeedEnabled) then
        return hum.WalkSpeed
    end
    return spSpeed or 16
end
_G.getBaseWalkSpeed = getBaseWalkSpeed

local function trackHumanoidSpeed(hum)
    if not hum then return end
    pcall(function()
        if not (V and V.SpeedEnabled) and hum.WalkSpeed and hum.WalkSpeed > 0 then
            _OrigWalkSpeed = hum.WalkSpeed
        end
    end)
    pcall(function()
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if not (V and V.SpeedEnabled) and not (V and V.Freecam) and not (V and V.Fly) then
                local ws = hum.WalkSpeed
                if ws and ws > 0 then
                    _OrigWalkSpeed = ws
                end
            end
        end)
    end)
end

pcall(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        _OrigWalkSpeed = getBaseWalkSpeed(hum)
        _OrigJumpPower = hum.JumpPower
        _OrigJumpHeight = hum.JumpHeight
        _OrigUseJumpPower = hum.UseJumpPower
        trackHumanoidSpeed(hum)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(c)
    task.wait(0.2)
    pcall(function()
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then
            if not V or not V.SpeedEnabled then
                _OrigWalkSpeed = getBaseWalkSpeed(h)
                _OrigJumpPower = h.JumpPower
                _OrigJumpHeight = h.JumpHeight
                _OrigUseJumpPower = h.UseJumpPower
            end
            trackHumanoidSpeed(h)
        end
    end)
end)
Camera = workspace.CurrentCamera
Lighting = game:GetService("Lighting")


_G.Aimlock_Enabled = false
_G.Aimlock_Key = nil
_G.Aimlock_KeyName = "Aucun"
_G.Aimlock_HoldMode = false
_G.Aimlock_IsHeld = false
_G.Aimlock_FOV = 150
_G.Aimlock_TargetPart = "Head"
_G.Aimlock_Wallcheck = true
_G.Aimlock_ShowFOV = true
_G.Aimlock_Smoothness = 1
_G.Aimlock_Prediction = true
_G.Aimlock_PredictionBoost = 1.0
_G.Aimlock_PingCompensation = true
_G.Aimlock_StickyTarget = nil
_G.Aimlock_TargetNPCs = false

Aimlock_Enabled = false
Aimlock_Key = nil
Aimlock_KeyName = "Aucun"
Aimlock_HoldMode = false
Aimlock_IsHeld = false
Aimlock_FOV = 150
Aimlock_TargetPart = "Head"
Aimlock_Wallcheck = true
Aimlock_ShowFOV = true
Aimlock_Smoothness = 1
Aimlock_Prediction = true
Aimlock_PredictionBoost = 1.0
Aimlock_PingCompensation = true
Aimlock_TargetNPCs = false
currentLockedTarget = nil
currentLockedChar = nil
currentLockedPart = nil

SilentAimCircle = nil
if Drawing and Drawing.new then
    pcall(function()
        SilentAimCircle = Drawing.new("Circle")
        SilentAimCircle.Visible = false
        SilentAimCircle.Thickness = 1.5
        SilentAimCircle.Color = Color3.fromRGB(60, 160, 255)
        SilentAimCircle.Radius = SilentAim_FOV
        SilentAimCircle.Filled = false
        SilentAimCircle.Transparency = 1
        SilentAimCircle.NumSides = 64
    end)
end

local cachedAimNPCs = {}
local lastAimNPCScan = 0
local function getAimNPCList()
    local now = tick()
    if now - lastAimNPCScan < 0.4 then
        return cachedAimNPCs
    end
    lastAimNPCScan = now
    local list = {}
    local function scan(inst, depth)
        if not inst or depth > 3 then return end
        for _, obj in ipairs(inst:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("Head")
                if hum and hum.Health > 0 and root then
                    table.insert(list, obj)
                else
                    scan(obj, depth + 1)
                end
            elseif obj:IsA("Folder") then
                scan(obj, depth + 1)
            end
        end
    end
    scan(workspace, 1)
    cachedAimNPCs = list
    return list
end

--------------------------------------------------------------------------------
-- NOVAK AIMLOCK ENGINE (DIRECT REPLACEMENT)
--------------------------------------------------------------------------------
currentAimbotTarget = nil

local function isTargetAlive(model)
    if not model then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then return true end
    local attrHp = model:GetAttribute("Health") or model:GetAttribute("hp") or model:GetAttribute("HP")
    if attrHp and tonumber(attrHp) and tonumber(attrHp) > 0 then return true end
    return false
end
_G.isTargetAlive = isTargetAlive

local function isTeammate(player)
    if not player or not LocalPlayer then return false end
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return true end
    if player.TeamColor and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then return true end
    return false
end
_G.isTeammate = isTeammate

local function isPartVisible(part, origin)
    if not part then return false end
    local cam = workspace.CurrentCamera
    if not cam then return false end
    local originPos = origin or cam.CFrame.Position
    local ignoreList = { LocalPlayer.Character, cam }
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = ignoreList
    rayParams.IgnoreWater = true

    local dir = part.Position - originPos
    local result = workspace:Raycast(originPos, dir, rayParams)
    if not result then return true end
    if result.Instance and result.Instance:IsDescendantOf(part.Parent) then return true end
    if result.Instance and (result.Instance.CanCollide == false or result.Instance.Transparency >= 0.75) then
        return true
    end
    return false
end
_G.isPartVisible = isPartVisible
isPlayerVisibleAim = isPartVisible

local function getTargetPart(character, partPref)
    if not character then return nil end
    local pref = partPref or _G.Aimlock_TargetPart or Aimlock_TargetPart or "Head"
    if pref == "Head" then
        return character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    elseif pref == "Torso" or pref == "UpperTorso" or pref == "HumanoidRootPart" then
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
    elseif pref == "Random" then
        local parts = { "Head", "UpperTorso", "Torso", "HumanoidRootPart" }
        for _, pName in ipairs(parts) do
            local found = character:FindFirstChild(pName)
            if found then return found end
        end
    end
    return character:FindFirstChild(pref) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end
_G.getTargetPart = getTargetPart

local function getPredictedPosition(character, part, originPos)
    if not part then return nil end
    local basePos = part.Position
    if not (_G.Aimlock_Prediction or Aimlock_Prediction) then
        return basePos
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart") or part
    local vel = rootPart.AssemblyLinearVelocity or rootPart.Velocity or Vector3.zero
    if V and V.ResolverEnabled and vel.Magnitude > 75 then
        vel = Vector3.new(math.clamp(vel.X, -30, 30), math.clamp(vel.Y, -20, 20), math.clamp(vel.Z, -30, 30))
    end
    local boost = (_G.Aimlock_PredictionBoost or Aimlock_PredictionBoost or 1.0)
    local dt = 0.135 * boost
    local dist = (originPos - basePos).Magnitude
    local dynamicLead = dt + (dist / 1400) * 0.04
    return basePos + (vel * dynamicLead)
end
_G.getPredictedPosition = getPredictedPosition

function getAimbotTarget()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local mousePos = UserInputService:GetMouseLocation()
    local bestTarget = nil
    local bestScore = math.huge
    local fov = _G.Aimlock_FOV or Aimlock_FOV or 150
    local maxDist = 2000
    local teamCheck = (_G.Aimlock_TeamCheck ~= nil and _G.Aimlock_TeamCheck) or (Aimlock_TeamCheck ~= nil and Aimlock_TeamCheck) or (V and V.ESPTeamCheck)
    local wallCheck = (_G.Aimlock_Wallcheck ~= nil and _G.Aimlock_Wallcheck) or Aimlock_Wallcheck
    local targetPartPref = _G.Aimlock_TargetPart or Aimlock_TargetPart or "Head"

    local function evaluateModel(model, isPlayerTarget, playerObj)
        if not model or not isTargetAlive(model) then return end
        if isPlayerTarget and teamCheck and isTeammate(playerObj) then return end
        if isPlayerTarget and IsWhitelisted and IsWhitelisted(playerObj) then return end

        local targetPart = getTargetPart(model, targetPartPref)
        if not targetPart then return end

        local screenPos, onScreen = cam:WorldToViewportPoint(targetPart.Position)
        if not onScreen or screenPos.Z <= 0 then return end

        local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if mouseDist > fov then return end

        local camDist = (cam.CFrame.Position - targetPart.Position).Magnitude
        if camDist > maxDist then return end

        if wallCheck and not isPartVisible(targetPart, cam.CFrame.Position) then
            return
        end

        local score = mouseDist
        if score < bestScore then
            bestScore = score
            bestTarget = {
                Character = model,
                Part = targetPart,
                IsPlayer = isPlayerTarget,
                Player = playerObj,
            }
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            evaluateModel(p.Character, true, p)
        end
    end

    if _G.Aimlock_TargetNPCs or Aimlock_TargetNPCs then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(obj) then
                if obj:FindFirstChildOfClass("Humanoid") then
                    evaluateModel(obj, false, nil)
                end
            end
        end
    end

    return bestTarget
end
_G.getAimbotTarget = getAimbotTarget
getAimlockTarget = getAimbotTarget

local function updateAimbotCamera()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local isEnabled = (_G.Aimlock_Enabled or Aimlock_Enabled)
    local isShowFOV = (_G.Aimlock_ShowFOV ~= nil and _G.Aimlock_ShowFOV) or Aimlock_ShowFOV
    local fovRad = _G.Aimlock_FOV or Aimlock_FOV or 150
    local isHeld = (_G.Aimlock_IsHeld or Aimlock_IsHeld)
    local isHoldMode = (_G.Aimlock_HoldMode or Aimlock_HoldMode)
    local autoLock = (V and V.AimlockAutoLock) or false

    if SilentAimCircle then
        SilentAimCircle.Visible = (isEnabled or isHeld or autoLock) and isShowFOV
        SilentAimCircle.Position = UserInputService:GetMouseLocation()
        SilentAimCircle.Radius = fovRad
    end

    local shouldAim = false
    if isHoldMode then
        shouldAim = isHeld or autoLock
    else
        shouldAim = isEnabled or isHeld or autoLock
    end

    if not shouldAim then
        currentAimbotTarget = nil
        return
    end

    if not currentAimbotTarget or not isTargetAlive(currentAimbotTarget.Character) then
        currentAimbotTarget = getAimbotTarget()
    end

    if currentAimbotTarget and currentAimbotTarget.Character then
        local targetPart = getTargetPart(currentAimbotTarget.Character, _G.Aimlock_TargetPart or Aimlock_TargetPart)
        if not targetPart then
            currentAimbotTarget = nil
            return
        end

        local aimPos = getPredictedPosition(currentAimbotTarget.Character, targetPart, cam.CFrame.Position)
        if aimPos then
            local targetCFrame = CFrame.lookAt(cam.CFrame.Position, aimPos)
            local smooth = _G.Aimlock_Smoothness or Aimlock_Smoothness or 1
            if smooth <= 1 then
                cam.CFrame = targetCFrame
            else
                local s = math.clamp(smooth, 1, 30)
                local alpha = math.clamp(1 / s, 0.04, 0.95)
                cam.CFrame = cam.CFrame:Lerp(targetCFrame, alpha)
            end
        end
    else
        currentAimbotTarget = nil
    end
end

pcall(function() RunService:UnbindFromRenderStep("PearlAimlockUpdate") end)
RunService:BindToRenderStep("PearlAimlockUpdate", Enum.RenderPriority.Camera.Value + 1, updateAimbotCamera)
_G.PearlAimlockUpdate = updateAimbotCamera

if _G.PearlAimlockInputBeganConn then pcall(function() _G.PearlAimlockInputBeganConn:Disconnect() end) _G.PearlAimlockInputBeganConn = nil end
if _G.PearlAimlockInputEndedConn then pcall(function() _G.PearlAimlockInputEndedConn:Disconnect() end) _G.PearlAimlockInputEndedConn = nil end

_G.PearlAimlockInputBeganConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if UserInputService:GetFocusedTextBox() then return end
    local lockKey = _G.Aimlock_Key or Aimlock_Key
    local isTargetKey = false

    if typeof(lockKey) == "EnumItem" then
        if input.KeyCode == lockKey or input.UserInputType == lockKey then
            isTargetKey = true
        end
    end

    if isTargetKey then
        if _G.Aimlock_HoldMode or Aimlock_HoldMode then
            _G.Aimlock_IsHeld = true
            Aimlock_IsHeld = true
        else
            _G.Aimlock_Enabled = not (_G.Aimlock_Enabled or Aimlock_Enabled)
            Aimlock_Enabled = _G.Aimlock_Enabled
            if not Aimlock_Enabled then
                currentAimbotTarget = nil
            end
            notify("Aimlock", "Aimlock " .. (Aimlock_Enabled and "ACTIVÉ" or "DÉSACTIVÉ"), Aimlock_Enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
        end
    end
end)

_G.PearlAimlockInputEndedConn = UserInputService.InputEnded:Connect(function(input, gpe)
    local lockKey = _G.Aimlock_Key or Aimlock_Key
    local isTargetKey = false
    if typeof(lockKey) == "EnumItem" then
        if input.KeyCode == lockKey or input.UserInputType == lockKey then
            isTargetKey = true
        end
    end
    if isTargetKey and (_G.Aimlock_HoldMode or Aimlock_HoldMode) then
        _G.Aimlock_IsHeld = false
        Aimlock_IsHeld = false
        currentAimbotTarget = nil
    end
end)

function serverHop()
    task.spawn(function()
        pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            local res = game:HttpGet(url)
            local data = HttpService:JSONDecode(res)
            for _, srv in ipairs(data.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    return
                end
            end
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
end

function rejoinServer()
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

Pearl = {
    Version ="1.0",
    Open = true,
    TeleportPoints = {}
}

V = {}
C = { All = {} }
Cache = { Distances = {}, FPSBoost = {}, Lighting = nil, PostEffects = {} }
ConfigRegistry = {}

Keybinds = {
    Fly = Enum.KeyCode.Unknown,
    Noclip = Enum.KeyCode.Unknown,
    Invisible = Enum.KeyCode.Unknown,
    DesyncFly = Enum.KeyCode.Unknown,
    ESP = Enum.KeyCode.Unknown,
    Speed = Enum.KeyCode.Unknown,
    Respawn = Enum.KeyCode.Unknown,
    Menu = Enum.KeyCode.Insert,
    Freecam = Enum.KeyCode.Unknown,
    VehicleFly = Enum.KeyCode.Unknown,
    VehicleBoost = Enum.KeyCode.Unknown,
    InstantBrake = Enum.KeyCode.Unknown,
    VehicleSeatTP = Enum.KeyCode.Unknown,
    VehicleAutoFlip = Enum.KeyCode.Unknown,
    VehicleExplode = Enum.KeyCode.Unknown,
    VehiclePropulse = Enum.KeyCode.Unknown,
    RecordMovement = Enum.KeyCode.Unknown,
    ReplayMovement = Enum.KeyCode.Unknown,
    VehicleFreeze = Enum.KeyCode.Unknown,
    VehicleDelete = Enum.KeyCode.Unknown,
    VehicleInvisible = Enum.KeyCode.Unknown
}

KeybindCallbacks = {}
KeybindButtons = {}
KeybindSystem = { Binding = false, BindingName = nil, BindingBtn = nil }

V.INVISIBILITY_POSITION = Vector3.new(0, 100000, 0)
V.FOV = 70
V.CustomFOV = false

DefaultConfig = {
    KeyboardLayout = "AZERTY",
    CurrentTheme = "Violet Void",
    RecordMovement = "Y", ReplayMovement = "O", MovementReplayNoclip = true, MovementReplaySpeed = 100,
    Speed = 16, SpeedEnabled = false, SpeedMethod = "Humanoid", Jump = 50, JumpEnabled = false, 
    WallClimb = false, AutoBhop = false, SuperJumpCharge = false, InfiniteStamina = false,
    Fly = false, FlySpeed = 150, DesyncFly = false, DesyncFlySpeed = 150,
    AntiRagdoll = false, Noclip = false, NoAnim = false, Invis = false, InfJump = false, AntiVoid = false, Godmode = false,
    InstInteract = false, InfRange = false,
    ESP = false, ESPSelf = false, ESPTeamCheck = false, ESPBox = false, ESPFilled = false, ESPName = false, ESPDist = false,
    ESPSkeleton = false, ESPHealth = false, ESPPV = false, ESPWeapon = false, ESPDropped = false, ESPTracerOrigin ="Bottom",
    BulletTracers = false, OffScreenArrows = false, GrappleHook = false, SitAir = false,
    FreecamTPTargetMode = "Ground", FreecamTPOnDisable = false, FreecamCharVisible = false,
    VehicleSpeed = 1, VehicleFly = false, VehicleFlySpeed = 150, VehicleNoclip = false, VehicleBoost = false, VehicleBoostMode = "Camera", VehicleJumpPower = 80, VehicleAutoJump = true, VehicleExplodeEnabled = false,
    Ghost = false,
    KeybindHUD = false, UITransparency = 3, AccentColor ="Blue", Streamproof = false,
    PearlChatNotifs = true, RobloxChatNotifs = false,
    ChatTranslator = false, UncensoredChat = false, PlayerJoinLeaveNotifs = false, AdminJoinNotif = false, TPMiniWindow = false,
    Fullbright = false, FPSBoost = false,
    Force1st = false, Force3rd = false, UnlockZoom = false,
    FOV = 70,
    AntiAFK = false, Notif = true, Watermark = true,
    BubblesEnabled = true, DimmerEnabled = true, DimmerOpacity = 80,
    XRay = false, XRayTransparency = 65, XRayKeepFloor = true, XRayHideDecals = true, XRayStyle = "Murs Propres"
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
Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")

LocalPlayer = Players.LocalPlayer

local parent = getSafeGuiParent()

if getgenv().BloxFruitsUILoaded then
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "BloxFruitsUI" or child.Name == "PearlUpdateUI" or child.Name == "PearlFreecamMenu" or child.Name == "PearlFreecamCrosshair" or child.Name == "PearlTacticalRadar" or child.Name == "PearlDangerWarning" or child.Name == "PearlConfigInspector" then
            child:Destroy()
        end
    end
    if _G.cleanupCloneInvis then pcall(_G.cleanupCloneInvis) end
    if _G.cleanupGhostDesync then pcall(_G.cleanupGhostDesync) end
    if _G.cleanupPearlSkyDome then pcall(_G.cleanupPearlSkyDome) end
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
        if xrayConn then xrayConn:Disconnect() xrayConn = nil end
        if restoreXRay then
            pcall(restoreXRay)
        else
            if origXRayTransparencies then
                for part, orig in pairs(origXRayTransparencies) do
                    if part and part.Parent then pcall(function() part.Transparency = orig end) end
                end
                origXRayTransparencies = {}
            end
            if origMaterials then
                for part, mat in pairs(origMaterials) do
                    if part and part.Parent then pcall(function() part.Material = mat end) end
                end
                origMaterials = {}
            end
            if origDecalTransparencies then
                for dec, orig in pairs(origDecalTransparencies) do
                    if dec and dec.Parent then pcall(function() dec.Transparency = orig end) end
                end
                origDecalTransparencies = {}
            end
        end
        V.Freecam = false
    end
end
getgenv().BloxFruitsUILoaded = true

theme = setmetatable({
    text = Color3.fromRGB(235, 235, 242),
    sub = Color3.fromRGB(130, 134, 152),
    textDim = Color3.fromRGB(130, 134, 152),
    panel = Color3.fromRGB(14, 15, 22),
    panel2 = Color3.fromRGB(18, 19, 28),
    card = Color3.fromRGB(23, 24, 35),
    cardHover = Color3.fromRGB(31, 33, 47),
    border = Color3.fromRGB(44, 46, 62),
    accent = Color3.fromRGB(145, 120, 255),
    accent2 = Color3.fromRGB(90, 160, 255),
    danger = Color3.fromRGB(220, 60, 60),
}, {
    __index = function(tbl, key)
        if key == "textDim" then return Color3.fromRGB(130, 134, 152) end
        return Color3.fromRGB(200, 200, 200)
    end
})

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PearlUpdateUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = parent

function makeCorner(gui, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = gui
    return corner
end

function makeStroke(gui, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or theme.border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = gui
    return stroke
end

function makeGradient(gui, from, to, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, from),
        ColorSequenceKeypoint.new(1, to),
    })
    gradient.Rotation = rotation or 90
    gradient.Parent = gui
    return gradient
end


BackgroundDimmer = Instance.new("Frame")
BackgroundDimmer.Name = "BackgroundDimmer"
BackgroundDimmer.Size = UDim2.new(1, 0, 1, 0)
BackgroundDimmer.Position = UDim2.new(0, 0, 0, 0)
BackgroundDimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundDimmer.BackgroundTransparency = 1
BackgroundDimmer.BorderSizePixel = 0
BackgroundDimmer.ZIndex = 1
BackgroundDimmer.Active = false
BackgroundDimmer.Visible = false
BackgroundDimmer.Parent = ScreenGui

BubblesContainer = Instance.new("Frame")
BubblesContainer.Name = "BubblesContainer"
BubblesContainer.Size = UDim2.new(1, 0, 1, 0)
BubblesContainer.Position = UDim2.new(0, 0, 0, 0)
BubblesContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BubblesContainer.BackgroundTransparency = 1
BubblesContainer.ClipsDescendants = true
BubblesContainer.ZIndex = 2
BubblesContainer.Active = false
BubblesContainer.Parent = ScreenGui

bubbles = {}
numBubbles = 60

for i = 1, numBubbles do
    local b = Instance.new("Frame")
    local size = math.random(7, 30)
    b.Size = UDim2.new(0, size, 0, size)
    local randCol = math.random()
    if randCol > 0.65 then
        b.BackgroundColor3 = theme.accent
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

menuSound = nil

function playClick()
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


local Colors = {
	Background = Color3.fromRGB(15, 15, 18),
	Card = Color3.fromRGB(20, 20, 24),
	CardSub = Color3.fromRGB(26, 26, 32),
	Border = Color3.fromRGB(34, 34, 40),
	BorderActive = Color3.fromRGB(65, 65, 78),
	Accent = Color3.fromRGB(146, 112, 255),
	AccentDark = Color3.fromRGB(44, 34, 76),
	AccentLight = Color3.fromRGB(175, 145, 255),
	Text = Color3.fromRGB(242, 242, 246),
	TextDim = Color3.fromRGB(142, 142, 155),
	TextMuted = Color3.fromRGB(86, 86, 98),
	Success = Color3.fromRGB(115, 235, 145),
	Warning = Color3.fromRGB(245, 185, 85),
	Error = Color3.fromRGB(245, 95, 95),
	Info = Color3.fromRGB(110, 185, 255)
}

local CategoryIcons = {
	Information = "rbxassetid://7733964719",
	Movement = "rbxassetid://7733955740",
	Me = "rbxassetid://7743875962",
	Protection = "rbxassetid://7734056608",
	ESP = "rbxassetid://7733774602",
	Aim = "rbxassetid://7733765307",
	Teleport = "rbxassetid://7733919198",
	Joueur = "rbxassetid://7743876054",
	Server = "rbxassetid://7734053426",
	Vehicle = "rbxassetid://7733708835",
	Fun = "rbxassetid://7733955511",
	Settings = "rbxassetid://7734053495",
	Config = "rbxassetid://7743868936",
	Code = "rbxassetid://7733749837",
	Spy = "rbxassetid://7733774602"
}

local function CreateTween(instance, properties, duration, style, direction)
	local info = TweenInfo.new(
		duration or 0.25,
		style or Enum.EasingStyle.Quart,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(instance, info, properties)
	tween:Play()
	return tween
end

Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 0, 0, 26)
Watermark.Position = UDim2.new(0, 18, 0, 18)
Watermark.BackgroundColor3 = Colors.Background
Watermark.BorderSizePixel = 0
Watermark.AutomaticSize = Enum.AutomaticSize.X
Watermark.Active = true
Watermark.ZIndex = 100
Watermark.Parent = ScreenGui

local WmCorner = Instance.new("UICorner")
WmCorner.CornerRadius = UDim.new(0, 6)
WmCorner.Parent = Watermark

local WmStroke = Instance.new("UIStroke")
WmStroke.Color = Colors.Border
WmStroke.Thickness = 1
WmStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
WmStroke.Parent = Watermark

local wmBar = Instance.new("Frame")
wmBar.Name = "AccentBar"
wmBar.Size = UDim2.new(0, 3, 0, 16)
wmBar.Position = UDim2.new(0, 4, 0.5, -8)
wmBar.BackgroundColor3 = Colors.Accent
wmBar.BorderSizePixel = 0
wmBar.ZIndex = 101
wmBar.Parent = Watermark

local WmBarCorner = Instance.new("UICorner")
WmBarCorner.CornerRadius = UDim.new(0, 2)
WmBarCorner.Parent = wmBar

local WatermarkText = Instance.new("TextLabel")
WatermarkText.Name = "WatermarkText"
WatermarkText.Size = UDim2.new(0, 0, 1, 0)
WatermarkText.Position = UDim2.new(0, 13, 0, 0)
WatermarkText.BackgroundTransparency = 1
WatermarkText.AutomaticSize = Enum.AutomaticSize.X
WatermarkText.Text = "Pearl HUB | " .. (LocalPlayer and LocalPlayer.Name or "user") .. " | 60 FPS"
WatermarkText.TextColor3 = Colors.Text
WatermarkText.TextSize = 12
WatermarkText.Font = Enum.Font.GothamMedium
WatermarkText.TextXAlignment = Enum.TextXAlignment.Left
WatermarkText.ZIndex = 101
WatermarkText.Parent = Watermark

local WmPadding = Instance.new("UIPadding")
WmPadding.PaddingTop = UDim.new(0, 0)
WmPadding.PaddingBottom = UDim.new(0, 0)
WmPadding.PaddingLeft = UDim.new(0, 6)
WmPadding.PaddingRight = UDim.new(0, 12)
WmPadding.Parent = Watermark

-- Petit menu d'affichage des joueurs connectes dans le serveur
local WatermarkPlayerCard = Instance.new("Frame")
WatermarkPlayerCard.Name = "WatermarkPlayerCard"
WatermarkPlayerCard.Size = UDim2.new(0, 0, 0, 24)
WatermarkPlayerCard.Position = UDim2.new(0, 0, 1, 6)
WatermarkPlayerCard.BackgroundColor3 = Colors.Background
WatermarkPlayerCard.BorderSizePixel = 0
WatermarkPlayerCard.AutomaticSize = Enum.AutomaticSize.X
WatermarkPlayerCard.ZIndex = 100
WatermarkPlayerCard.Parent = Watermark

local WmPlayerCorner = Instance.new("UICorner")
WmPlayerCorner.CornerRadius = UDim.new(0, 6)
WmPlayerCorner.Parent = WatermarkPlayerCard

local WmPlayerStroke = Instance.new("UIStroke")
WmPlayerStroke.Color = Colors.Border
WmPlayerStroke.Thickness = 1
WmPlayerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
WmPlayerStroke.Parent = WatermarkPlayerCard

local WmPlayerBar = Instance.new("Frame")
WmPlayerBar.Name = "AccentBar"
WmPlayerBar.Size = UDim2.new(0, 3, 0, 14)
WmPlayerBar.Position = UDim2.new(0, 4, 0.5, -7)
WmPlayerBar.BackgroundColor3 = Colors.Accent
WmPlayerBar.BorderSizePixel = 0
WmPlayerBar.ZIndex = 101
WmPlayerBar.Parent = WatermarkPlayerCard

local WmPlayerBarCorner = Instance.new("UICorner")
WmPlayerBarCorner.CornerRadius = UDim.new(0, 2)
WmPlayerBarCorner.Parent = WmPlayerBar

local PlayerIcon = Instance.new("ImageLabel")
PlayerIcon.Name = "PlayerIcon"
PlayerIcon.Size = UDim2.new(0, 13, 0, 13)
PlayerIcon.Position = UDim2.new(0, 12, 0.5, -6.5)
PlayerIcon.BackgroundTransparency = 1
PlayerIcon.Image = "rbxassetid://7743876054"
PlayerIcon.ImageColor3 = Colors.Accent
PlayerIcon.ZIndex = 101
PlayerIcon.Parent = WatermarkPlayerCard

local PlayerCountText = Instance.new("TextLabel")
PlayerCountText.Name = "PlayerCountText"
PlayerCountText.Size = UDim2.new(0, 0, 1, 0)
PlayerCountText.Position = UDim2.new(0, 29, 0, 0)
PlayerCountText.BackgroundTransparency = 1
PlayerCountText.AutomaticSize = Enum.AutomaticSize.X
PlayerCountText.Text = "0 / 0 joueurs"
PlayerCountText.TextColor3 = Colors.Text
PlayerCountText.TextSize = 11.5
PlayerCountText.Font = Enum.Font.GothamMedium
PlayerCountText.TextXAlignment = Enum.TextXAlignment.Left
PlayerCountText.ZIndex = 101
PlayerCountText.Parent = WatermarkPlayerCard

local WmPlayerPadding = Instance.new("UIPadding")
WmPlayerPadding.PaddingTop = UDim.new(0, 0)
WmPlayerPadding.PaddingBottom = UDim.new(0, 0)
WmPlayerPadding.PaddingLeft = UDim.new(0, 6)
WmPlayerPadding.PaddingRight = UDim.new(0, 12)
WmPlayerPadding.Parent = WatermarkPlayerCard

local function updateWatermarkPlayerCount()
	pcall(function()
		local count = #Players:GetPlayers()
		local maxP = Players.MaxPlayers
		if maxP and maxP > 0 then
			PlayerCountText.Text = tostring(count) .. " / " .. tostring(maxP) .. " joueurs"
		else
			PlayerCountText.Text = tostring(count) .. " joueurs"
		end
	end)
end
updateWatermarkPlayerCount()
Players.PlayerAdded:Connect(function()
	task.wait(0.2)
	updateWatermarkPlayerCount()
end)
Players.PlayerRemoving:Connect(function()
	task.defer(updateWatermarkPlayerCount)
end)

local wmDragging = false
local wmDragStart, wmStartPos

local function startWmDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		wmDragging = true
		wmDragStart = input.Position
		wmStartPos = Watermark.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				wmDragging = false
			end
		end)
	end
end

Watermark.InputBegan:Connect(startWmDrag)
if WatermarkPlayerCard then
	WatermarkPlayerCard.Active = true
	WatermarkPlayerCard.InputBegan:Connect(startWmDrag)
end

UserInputService.InputChanged:Connect(function(input)
	if wmDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - wmDragStart
		Watermark.Position = UDim2.new(
			wmStartPos.X.Scale,
			wmStartPos.X.Offset + delta.X,
			wmStartPos.Y.Scale,
			wmStartPos.Y.Offset + delta.Y
		)
	end
end)

local lastFpsTime = tick()
local fpsFrames = 0
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - lastFpsTime >= 0.25 then
		local curFps = math.floor(fpsFrames / (now - lastFpsTime))
		WatermarkText.Text = "Pearl HUB | " .. (LocalPlayer and LocalPlayer.Name or "user") .. " | " .. curFps .. " FPS"
		if updateWatermarkPlayerCount then updateWatermarkPlayerCount() end
		fpsFrames = 0
		lastFpsTime = now
	end
end)

NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "PearlNotificationContainer"
NotificationContainer.Size = UDim2.new(0, 320, 1, -40)
NotificationContainer.Position = UDim2.new(1, -336, 0, 20)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.BorderSizePixel = 0
NotificationContainer.ZIndex = 500
NotificationContainer.ClipsDescendants = false
NotificationContainer.Parent = ScreenGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.Parent = NotificationContainer

local lastNotifyKey = nil
local lastNotifyTime = 0
local activeNotifCards = {}

function notify(title, text, color)
	if V and V.Notif == false then return end
	title = tostring(title or "Pearl Hub"):gsub("<[^>]->", "")
	text = tostring(text or ""):gsub("<[^>]->", "")

	local key = title .. "|" .. text
	local now = os.clock()
	if key == lastNotifyKey and (now - lastNotifyTime) < 1.0 then
		return
	end
	lastNotifyKey = key
	lastNotifyTime = now

	local notifColor = color or (theme and theme.accent) or Color3.fromRGB(145, 120, 255)

	-- Cap maximum active notifications on screen to 5
	if #activeNotifCards >= 5 then
		local oldest = table.remove(activeNotifCards, 1)
		if oldest and oldest.dismiss then
			pcall(oldest.dismiss)
		end
	end

	local textLen = string.len(text)
	local cardHeight = textLen > 48 and 72 or 62

	local Card = Instance.new("Frame")
	Card.Name = "PearlNotifCard"
	Card.Size = UDim2.new(1, 0, 0, cardHeight)
	Card.Position = UDim2.new(0, 120, 0, 0)
	Card.BackgroundColor3 = Color3.fromRGB(17, 18, 26)
	Card.BorderSizePixel = 0
	Card.ClipsDescendants = true
	Card.BackgroundTransparency = 1
	Card.ZIndex = 501

	local CardScale = Instance.new("UIScale")
	CardScale.Scale = 0.8
	CardScale.Parent = Card

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Card

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = notifColor
	UIStroke.Thickness = 1.2
	UIStroke.Transparency = 1
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Card

	local CardGrad = Instance.new("UIGradient")
	CardGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 27, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 15, 22))
	})
	CardGrad.Rotation = 45
	CardGrad.Parent = Card

	-- Left Glowing Accent Pill
	local LeftPill = Instance.new("Frame")
	LeftPill.Name = "LeftPill"
	LeftPill.Size = UDim2.new(0, 3.5, 0.65, 0)
	LeftPill.Position = UDim2.new(0, 5, 0.5, 0)
	LeftPill.AnchorPoint = Vector2.new(0, 0.5)
	LeftPill.BackgroundColor3 = notifColor
	LeftPill.BorderSizePixel = 0
	LeftPill.BackgroundTransparency = 1
	LeftPill.ZIndex = 502
	LeftPill.Parent = Card
	local pillCorner = Instance.new("UICorner")
	pillCorner.CornerRadius = UDim.new(1, 0)
	pillCorner.Parent = LeftPill

	-- Icon Container
	local IconBox = Instance.new("Frame")
	IconBox.Name = "IconBox"
	IconBox.Size = UDim2.new(0, 34, 0, 34)
	IconBox.Position = UDim2.new(0, 15, 0.5, 0)
	IconBox.AnchorPoint = Vector2.new(0, 0.5)
	IconBox.BackgroundColor3 = Color3.fromRGB(24, 25, 36)
	IconBox.BorderSizePixel = 0
	IconBox.BackgroundTransparency = 1
	IconBox.ZIndex = 502
	IconBox.Parent = Card
	local ibCorner = Instance.new("UICorner")
	ibCorner.CornerRadius = UDim.new(0, 8)
	ibCorner.Parent = IconBox
	local ibStroke = Instance.new("UIStroke")
	ibStroke.Color = Color3.fromRGB(48, 50, 70)
	ibStroke.Thickness = 1
	ibStroke.Transparency = 1
	ibStroke.Parent = IconBox

	-- Category icon selector matching left navigation rail
	local iconId = nil
	if CategoryIcons and CategoryIcons[title] then
		iconId = CategoryIcons[title]
	else
		local lContext = string.lower(title .. " " .. text)
		if CategoryIcons then
			for catName, catIcon in pairs(CategoryIcons) do
				if string.find(lContext, string.lower(catName)) then
					iconId = catIcon
					break
				end
			end
		end
	end
	if not iconId then
		local lC = string.lower(title .. " " .. text)
		if string.find(lC, "aim") or string.find(lC, "lock") or string.find(lC, "fov") or string.find(lC, "trigger") then
			iconId = CategoryIcons and CategoryIcons.Aim or "rbxassetid://7733765307"
		elseif string.find(lC, "teleport") or string.find(lC, "tp") or string.find(lC, "waypoint") then
			iconId = CategoryIcons and CategoryIcons.Teleport or "rbxassetid://7733919198"
		elseif string.find(lC, "esp") or string.find(lC, "visual") or string.find(lC, "chams") then
			iconId = CategoryIcons and CategoryIcons.ESP or "rbxassetid://7733774602"
		elseif string.find(lC, "fly") or string.find(lC, "speed") or string.find(lC, "noclip") or string.find(lC, "desync") then
			iconId = CategoryIcons and CategoryIcons.Movement or "rbxassetid://7733955740"
		elseif string.find(lC, "veh") or string.find(lC, "car") or string.find(lC, "boat") then
			iconId = CategoryIcons and CategoryIcons.Vehicle or "rbxassetid://7733708835"
		elseif string.find(lC, "player") or string.find(lC, "joueur") then
			iconId = CategoryIcons and CategoryIcons.Joueur or "rbxassetid://7743876054"
		elseif string.find(lC, "server") or string.find(lC, "troll") or string.find(lC, "kick") then
			iconId = CategoryIcons and CategoryIcons.Server or "rbxassetid://7734053426"
		elseif string.find(lC, "keybind") or string.find(lC, "setting") then
			iconId = CategoryIcons and CategoryIcons.Settings or "rbxassetid://7734053495"
		else
			iconId = (CategoryIcons and CategoryIcons.Me) or "rbxassetid://7733964719"
		end
	end

	local Icon = Instance.new("ImageLabel")
	Icon.Name = "Icon"
	Icon.Size = UDim2.new(0, 18, 0, 18)
	Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.BackgroundTransparency = 1
	Icon.Image = iconId
	Icon.ImageColor3 = notifColor
	Icon.ImageTransparency = 1
	Icon.ZIndex = 503
	Icon.Parent = IconBox

	-- Title Label
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, -95, 0, 18)
	TitleLabel.Position = UDim2.new(0, 58, 0, 10)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = string.upper(title)
	TitleLabel.TextColor3 = notifColor
	TitleLabel.TextSize = 12
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	TitleLabel.TextTransparency = 1
	TitleLabel.ZIndex = 502
	TitleLabel.Parent = Card

	-- Message Label
	local MessageLabel = Instance.new("TextLabel")
	MessageLabel.Name = "MessageLabel"
	MessageLabel.Size = UDim2.new(1, -90, 0, cardHeight > 64 and 34 or 22)
	MessageLabel.Position = UDim2.new(0, 58, 0, 28)
	MessageLabel.BackgroundTransparency = 1
	MessageLabel.Font = Enum.Font.GothamMedium
	MessageLabel.Text = text
	MessageLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
	MessageLabel.TextSize = 11
	MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
	MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
	MessageLabel.TextWrapped = true
	MessageLabel.TextTransparency = 1
	MessageLabel.ZIndex = 502
	MessageLabel.Parent = Card

	-- Close Button
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Size = UDim2.new(0, 20, 0, 20)
	CloseBtn.Position = UDim2.new(1, -26, 0, 7)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(130, 134, 152)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 11
	CloseBtn.TextTransparency = 1
	CloseBtn.ZIndex = 504
	CloseBtn.Parent = Card

	-- Progress Bar
	local ProgressBarBg = Instance.new("Frame")
	ProgressBarBg.Name = "ProgressBarBg"
	ProgressBarBg.Size = UDim2.new(1, -24, 0, 2)
	ProgressBarBg.Position = UDim2.new(0, 12, 1, -4)
	ProgressBarBg.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
	ProgressBarBg.BorderSizePixel = 0
	ProgressBarBg.BackgroundTransparency = 1
	ProgressBarBg.ZIndex = 502
	ProgressBarBg.Parent = Card
	local pbCorner = Instance.new("UICorner")
	pbCorner.CornerRadius = UDim.new(1, 0)
	pbCorner.Parent = ProgressBarBg

	local ProgressBar = Instance.new("Frame")
	ProgressBar.Name = "ProgressBar"
	ProgressBar.Size = UDim2.new(1, 0, 1, 0)
	ProgressBar.BackgroundColor3 = notifColor
	ProgressBar.BorderSizePixel = 0
	ProgressBar.ZIndex = 503
	ProgressBar.Parent = ProgressBarBg
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = ProgressBar

	local BarGrad = Instance.new("UIGradient")
	BarGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, notifColor),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 160, 255))
	})
	BarGrad.Parent = ProgressBar

	Card.Parent = NotificationContainer

	local notifEntry = {card = Card, dismissed = false}
	table.insert(activeNotifCards, notifEntry)

	-- Audio Feedback
	pcall(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://6895079853"
		sound.Volume = 0.35
		sound.Parent = game:GetService("SoundService")
		sound:Play()
		game:GetService("Debris"):AddItem(sound, 1.5)
	end)

	-- Entrance Animation (Fluid Slide & Bouncy Pop)
	local enterDuration = 0.38
	CreateTween(Card, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.04}, enterDuration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	CreateTween(CardScale, {Scale = 1}, enterDuration, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	CreateTween(UIStroke, {Transparency = 0.45}, enterDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	CreateTween(LeftPill, {BackgroundTransparency = 0}, 0.25)
	CreateTween(IconBox, {BackgroundTransparency = 0}, 0.25)
	CreateTween(ibStroke, {Transparency = 0.4}, 0.25)
	CreateTween(Icon, {ImageTransparency = 0}, 0.25)
	CreateTween(TitleLabel, {TextTransparency = 0}, 0.25)
	CreateTween(MessageLabel, {TextTransparency = 0}, 0.25)
	CreateTween(CloseBtn, {TextTransparency = 0.4}, 0.25)
	CreateTween(ProgressBarBg, {BackgroundTransparency = 0.5}, 0.25)

	-- Progress bar timer shrink
	CreateTween(ProgressBar, {Size = UDim2.new(0, 0, 1, 0)}, 3.2, Enum.EasingStyle.Linear)

	local isHovered = false
	local function dismissNotif()
		if notifEntry.dismissed then return end
		notifEntry.dismissed = true

		-- Remove from active list
		for idx, entry in ipairs(activeNotifCards) do
			if entry == notifEntry then
				table.remove(activeNotifCards, idx)
				break
			end
		end

		local exitDuration = 0.28
		local exitTween = CreateTween(Card, {
			Position = UDim2.new(0, 120, 0, 0),
			BackgroundTransparency = 1
		}, exitDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

		CreateTween(CardScale, {Scale = 0.8}, exitDuration, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		CreateTween(UIStroke, {Transparency = 1}, 0.2)
		CreateTween(LeftPill, {BackgroundTransparency = 1}, 0.2)
		CreateTween(IconBox, {BackgroundTransparency = 1}, 0.2)
		CreateTween(ibStroke, {Transparency = 1}, 0.2)
		CreateTween(Icon, {ImageTransparency = 1}, 0.2)
		CreateTween(TitleLabel, {TextTransparency = 1}, 0.2)
		CreateTween(MessageLabel, {TextTransparency = 1}, 0.2)
		CreateTween(CloseBtn, {TextTransparency = 1}, 0.2)
		CreateTween(ProgressBarBg, {BackgroundTransparency = 1}, 0.2)

		exitTween.Completed:Connect(function()
			-- Smooth vertical collapse so cards below glide up
			local collapseTween = CreateTween(Card, {Size = UDim2.new(1, 0, 0, 0)}, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			collapseTween.Completed:Connect(function()
				Card:Destroy()
			end)
		end)
	end
	notifEntry.dismiss = dismissNotif

	-- Interactivity (Hover Effect)
	Card.MouseEnter:Connect(function()
		isHovered = true
		CreateTween(UIStroke, {Transparency = 0.1, Color = Color3.fromRGB(175, 145, 255)}, 0.15)
		CreateTween(Card, {BackgroundColor3 = Color3.fromRGB(25, 26, 38)}, 0.15)
		CreateTween(CloseBtn, {TextTransparency = 0}, 0.15)
	end)
	Card.MouseLeave:Connect(function()
		isHovered = false
		CreateTween(UIStroke, {Transparency = 0.45, Color = notifColor}, 0.2)
		CreateTween(Card, {BackgroundColor3 = Color3.fromRGB(17, 18, 26)}, 0.2)
		CreateTween(CloseBtn, {TextTransparency = 0.4}, 0.2)
	end)

	CloseBtn.MouseEnter:Connect(function()
		CreateTween(CloseBtn, {TextColor3 = Color3.fromRGB(255, 80, 80)}, 0.15)
	end)
	CloseBtn.MouseLeave:Connect(function()
		CreateTween(CloseBtn, {TextColor3 = Color3.fromRGB(130, 134, 152)}, 0.15)
	end)
	CloseBtn.MouseButton1Click:Connect(dismissNotif)

	-- Auto dismiss after 3.2s (pauses if mouse is hovering)
	task.delay(3.2, function()
		while isHovered and not notifEntry.dismissed do
			task.wait(0.25)
		end
		if not notifEntry.dismissed then
			dismissNotif()
		end
	end)
end
_G.notify = notify
_G.PearlNotify = notify

defaultWindowSize = UDim2.new(0, 800, 0, 540)
defaultWindowPos = UDim2.new(0.5, -400, 0.5, -270)
savedWindowPos = defaultWindowPos
savedWindowSize = defaultWindowSize

Panel = Instance.new("Frame")
Panel.Name = "PearlMasterPanel"
Panel.Size = defaultWindowSize
Panel.Position = defaultWindowPos
Panel.BackgroundTransparency = 1
Panel.BorderSizePixel = 0
Panel.Visible = true
Panel.Active = true
Panel.ZIndex = 5
Panel.Parent = ScreenGui

PanelScale = Instance.new("UIScale")
PanelScale.Scale = 1
PanelScale.Parent = Panel

BloxFruitsPanel = Panel

Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 68, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Colors.Background
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 6
Sidebar.Parent = Panel

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 14)
SidebarCorner.Parent = Sidebar

local SidebarStroke = Instance.new("UIStroke")
SidebarStroke.Color = Colors.Border
SidebarStroke.Thickness = 1
SidebarStroke.Parent = Sidebar

local LogoContainer = Instance.new("Frame")
LogoContainer.Name = "LogoContainer"
LogoContainer.Size = UDim2.new(0, 44, 0, 44)
LogoContainer.Position = UDim2.new(0.5, -22, 0, 14)
LogoContainer.BackgroundColor3 = Colors.Card
LogoContainer.BorderSizePixel = 0
LogoContainer.ZIndex = 7
LogoContainer.Parent = Sidebar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = LogoContainer

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Color = Colors.Border
LogoStroke.Thickness = 1
LogoStroke.Parent = LogoContainer

local LogoImg = Instance.new("ImageLabel")
LogoImg.Name = "LogoImage"
LogoImg.Size = UDim2.new(1, -6, 1, -6)
LogoImg.Position = UDim2.new(0.5, 0, 0.5, 0)
LogoImg.AnchorPoint = Vector2.new(0.5, 0.5)
LogoImg.BackgroundTransparency = 1
LogoImg.ScaleType = Enum.ScaleType.Fit
LogoImg.ZIndex = 8
LogoImg.Parent = LogoContainer

local LogoUrl = "https://i.ibb.co/9HT9Yt3X/logo.png"

task.spawn(function()
	local loaded = false
	pcall(function()
		local req = (syn and syn.request) or (http and http.request) or http_request or request
		if req and writefile and getcustomasset then
			local fileName = "pearl_logo.png"
			if not (isfile and isfile(fileName)) then
				local res = req({Url = LogoUrl, Method = "GET"})
				if res and res.Body then
					writefile(fileName, res.Body)
				end
			end
			if isfile and isfile(fileName) then
				LogoImg.Image = getcustomasset(fileName)
				loaded = true
			end
		end
	end)
	if not loaded then
		LogoImg.Image = LogoUrl
	end
end)

local NavScroll = Instance.new("ScrollingFrame")
NavScroll.Name = "NavScroll"
NavScroll.Size = UDim2.new(1, 0, 1, -78)
NavScroll.Position = UDim2.new(0, 0, 0, 68)
NavScroll.BackgroundTransparency = 1
NavScroll.BorderSizePixel = 0
NavScroll.ScrollBarThickness = 2
NavScroll.ScrollBarImageColor3 = Colors.BorderActive
NavScroll.ScrollBarImageTransparency = 0.8
NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
NavScroll.ZIndex = 7
NavScroll.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 6)
NavLayout.Parent = NavScroll

ContentPanel = Instance.new("Frame")
ContentPanel.Name = "ContentPanel"
ContentPanel.Size = UDim2.new(1, -82, 1, 0)
ContentPanel.Position = UDim2.new(0, 82, 0, 0)
ContentPanel.BackgroundTransparency = 1
ContentPanel.ZIndex = 6
ContentPanel.Parent = Panel

TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Colors.Background
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 7
TopBar.Parent = ContentPanel

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 14)
TopBarCorner.Parent = TopBar

local TopBarStroke = Instance.new("UIStroke")
TopBarStroke.Color = Colors.Border
TopBarStroke.Thickness = 1
TopBarStroke.Parent = TopBar

PanelHeader = TopBar

PanelTitle = Instance.new("TextLabel")
PanelTitle.Name = "PanelTitle"
PanelTitle.Size = UDim2.new(0, 220, 1, 0)
PanelTitle.Position = UDim2.new(0, 22, 0, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Font = Enum.Font.GothamBold
PanelTitle.Text = "Information"
PanelTitle.TextColor3 = Colors.Text
PanelTitle.TextSize = 17
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 8
PanelTitle.Parent = TopBar

_G.NebulaHealth = _G.NebulaHealth or {
    failedOptions = {}
}

function _G.reportOptionResult(name, success, err)
    if not name then return end
    local cleanName = tostring(name):gsub("<[^>]->", "")
    if not success then
        _G.NebulaHealth.failedOptions[cleanName] = tostring(err or "Erreur")
    else
        _G.NebulaHealth.failedOptions[cleanName] = nil
    end
    if _G.updateNebulaStatusUI then
        pcall(_G.updateNebulaStatusUI)
    end
end

local TopBarStatusPill = Instance.new("Frame")
TopBarStatusPill.Name = "TopBarStatusPill"
TopBarStatusPill.Size = UDim2.new(0, 115, 0, 26)
TopBarStatusPill.Position = UDim2.new(1, -172, 0.5, -13)
TopBarStatusPill.BackgroundColor3 = Color3.fromRGB(18, 22, 28)
TopBarStatusPill.BorderSizePixel = 0
TopBarStatusPill.ZIndex = 8
TopBarStatusPill.Parent = TopBar

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 7)
tbCorner.Parent = TopBarStatusPill

local tbStroke = Instance.new("UIStroke")
tbStroke.Color = Color3.fromRGB(46, 204, 113)
tbStroke.Thickness = 1
tbStroke.Transparency = 0.5
tbStroke.Parent = TopBarStatusPill

local tbDot = Instance.new("Frame")
tbDot.Name = "Dot"
tbDot.Size = UDim2.new(0, 8, 0, 8)
tbDot.Position = UDim2.new(0, 8, 0.5, -4)
tbDot.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
tbDot.BorderSizePixel = 0
tbDot.ZIndex = 9
tbDot.Parent = TopBarStatusPill
local tbDotCorner = Instance.new("UICorner") tbDotCorner.CornerRadius = UDim.new(1, 0) tbDotCorner.Parent = tbDot

local tbLabel = Instance.new("TextLabel")
tbLabel.Name = "Label"
tbLabel.Size = UDim2.new(1, -22, 1, 0)
tbLabel.Position = UDim2.new(0, 20, 0, 0)
tbLabel.BackgroundTransparency = 1
tbLabel.Text = "100% Fonctionnel"
tbLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
tbLabel.Font = Enum.Font.GothamBold
tbLabel.TextSize = 10
tbLabel.TextXAlignment = Enum.TextXAlignment.Left
tbLabel.ZIndex = 9
tbLabel.Parent = TopBarStatusPill

_G.TopBarStatusElements = {
    pill = TopBarStatusPill,
    stroke = tbStroke,
    dot = tbDot,
    label = tbLabel,
}

local AvatarHolder = Instance.new("Frame")
AvatarHolder.Name = "AvatarHolder"
AvatarHolder.Size = UDim2.new(0, 36, 0, 36)
AvatarHolder.Position = UDim2.new(1, -46, 0.5, -18)
AvatarHolder.BackgroundColor3 = Colors.Card
AvatarHolder.BorderSizePixel = 0
AvatarHolder.ZIndex = 8
AvatarHolder.Parent = TopBar

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarHolder

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Colors.Border
AvatarStroke.Thickness = 1
AvatarStroke.Parent = AvatarHolder

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "Avatar"
AvatarImage.Size = UDim2.new(1, 0, 1, 0)
AvatarImage.BackgroundTransparency = 1
AvatarImage.ZIndex = 9
AvatarImage.Parent = AvatarHolder

local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

task.spawn(function()
	local thumbType = Enum.ThumbnailType.HeadShot
	local thumbSize = Enum.ThumbnailSize.Size100x100
	local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
	if isReady then
		AvatarImage.Image = content
	end
end)

-- BARRE DE RECHERCHE D'OPTIONS (Placee directement a gauche de l'avatar)
SearchContainer = Instance.new("Frame")
SearchContainer.Name = "SearchContainer"
SearchContainer.Size = UDim2.new(0, 210, 0, 32)
SearchContainer.Position = UDim2.new(1, -266, 0.5, -16)
SearchContainer.BackgroundColor3 = Colors.Card
SearchContainer.BorderSizePixel = 0
SearchContainer.ZIndex = 10
SearchContainer.Parent = TopBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchContainer

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Name = "SearchStroke"
SearchStroke.Color = Colors.Border
SearchStroke.Thickness = 1
SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
SearchStroke.Parent = SearchContainer

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Name = "SearchIcon"
SearchIcon.Size = UDim2.new(0, 14, 0, 14)
SearchIcon.Position = UDim2.new(0, 10, 0.5, -7)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://7733956411"
SearchIcon.ImageColor3 = Colors.TextDim
SearchIcon.ZIndex = 11
SearchIcon.Parent = SearchContainer

SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -56, 1, 0)
SearchBox.Position = UDim2.new(0, 30, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.PlaceholderText = "Rechercher une option..."
SearchBox.PlaceholderColor3 = Colors.TextMuted
SearchBox.Text = ""
SearchBox.TextColor3 = Colors.Text
SearchBox.TextSize = 11
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 11
SearchBox.Parent = SearchContainer

ClearSearchBtn = Instance.new("TextButton")
ClearSearchBtn.Name = "ClearSearchBtn"
ClearSearchBtn.Size = UDim2.new(0, 18, 0, 18)
ClearSearchBtn.Position = UDim2.new(1, -24, 0.5, -9)
ClearSearchBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
ClearSearchBtn.BorderSizePixel = 0
ClearSearchBtn.Text = "x"
ClearSearchBtn.TextColor3 = Colors.TextDim
ClearSearchBtn.Font = Enum.Font.GothamBold
ClearSearchBtn.TextSize = 13
ClearSearchBtn.AutoButtonColor = false
ClearSearchBtn.Visible = false
ClearSearchBtn.ZIndex = 12
ClearSearchBtn.Parent = SearchContainer

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(1, 0)
ClearCorner.Parent = ClearSearchBtn

local ClearStroke = Instance.new("UIStroke")
ClearStroke.Color = Colors.Border
ClearStroke.Thickness = 1
ClearStroke.Parent = ClearSearchBtn

SearchContainer.MouseEnter:Connect(function()
	if not SearchBox:IsFocused() then
		CreateTween(SearchStroke, {Color = Colors.BorderActive}, 0.15)
	end
end)

SearchContainer.MouseLeave:Connect(function()
	if not SearchBox:IsFocused() then
		CreateTween(SearchStroke, {Color = Colors.Border}, 0.15)
	end
end)

SearchBox.Focused:Connect(function()
	CreateTween(SearchStroke, {Color = Colors.Accent}, 0.2)
	CreateTween(SearchIcon, {ImageColor3 = Colors.Accent}, 0.2)
	CreateTween(SearchContainer, {Size = UDim2.new(0, 230, 0, 32), Position = UDim2.new(1, -286, 0.5, -16)}, 0.2)
end)

SearchBox.FocusLost:Connect(function()
	CreateTween(SearchStroke, {Color = Colors.Border}, 0.2)
	CreateTween(SearchIcon, {ImageColor3 = Colors.TextDim}, 0.2)
	CreateTween(SearchContainer, {Size = UDim2.new(0, 210, 0, 32), Position = UDim2.new(1, -266, 0.5, -16)}, 0.2)
end)

ClearSearchBtn.MouseEnter:Connect(function()
	CreateTween(ClearSearchBtn, {BackgroundColor3 = Color3.fromRGB(220, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
end)

ClearSearchBtn.MouseLeave:Connect(function()
	CreateTween(ClearSearchBtn, {BackgroundColor3 = Color3.fromRGB(28, 28, 36), TextColor3 = Colors.TextDim}, 0.15)
end)

ClearSearchBtn.MouseButton1Click:Connect(function()
	SearchBox.Text = ""
	if filterCards then
		filterCards("")
	end
	ClearSearchBtn.Visible = false
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local currentText = SearchBox.Text
	if currentText and currentText ~= "" then
		ClearSearchBtn.Visible = true
	else
		ClearSearchBtn.Visible = false
	end
	if filterCards then
		filterCards(currentText)
	end
end)

-- UserTooltip positionne proprement sous l'avatar pour ne pas gener la recherche
local UserTooltip = Instance.new("Frame")
UserTooltip.Name = "UserTooltip"
UserTooltip.Size = UDim2.new(0, 140, 0, 28)
UserTooltip.Position = UDim2.new(1, -150, 0, 56)
UserTooltip.BackgroundColor3 = Colors.Card
UserTooltip.BorderSizePixel = 0
UserTooltip.BackgroundTransparency = 1
UserTooltip.Visible = false
UserTooltip.ZIndex = 50
UserTooltip.Parent = TopBar

local TooltipCorner = Instance.new("UICorner")
TooltipCorner.CornerRadius = UDim.new(0, 8)
TooltipCorner.Parent = UserTooltip

local TooltipStroke = Instance.new("UIStroke")
TooltipStroke.Color = Colors.Border
TooltipStroke.Thickness = 1
TooltipStroke.Transparency = 1
TooltipStroke.Parent = UserTooltip

local TooltipLabel = Instance.new("TextLabel")
TooltipLabel.Size = UDim2.new(1, 0, 1, 0)
TooltipLabel.BackgroundTransparency = 1
TooltipLabel.Font = Enum.Font.GothamMedium
TooltipLabel.Text = "@" .. LocalPlayer.Name
TooltipLabel.TextColor3 = Colors.Text
TooltipLabel.TextSize = 11
TooltipLabel.TextTransparency = 1
TooltipLabel.ZIndex = 51
TooltipLabel.Parent = UserTooltip

AvatarHolder.MouseEnter:Connect(function()
	UserTooltip.Visible = true
	CreateTween(AvatarStroke, {Color = Colors.Accent}, 0.2)
	CreateTween(AvatarHolder, {Size = UDim2.new(0, 38, 0, 38), Position = UDim2.new(1, -47, 0.5, -19)}, 0.2)
	CreateTween(UserTooltip, {BackgroundTransparency = 0}, 0.2)
	CreateTween(TooltipStroke, {Transparency = 0}, 0.2)
	CreateTween(TooltipLabel, {TextTransparency = 0}, 0.2)
end)

AvatarHolder.MouseLeave:Connect(function()
	CreateTween(AvatarStroke, {Color = Colors.Border}, 0.2)
	CreateTween(AvatarHolder, {Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(1, -46, 0.5, -18)}, 0.2)
	local fade = CreateTween(UserTooltip, {BackgroundTransparency = 1}, 0.2)
	CreateTween(TooltipStroke, {Transparency = 1}, 0.2)
	CreateTween(TooltipLabel, {TextTransparency = 1}, 0.2)
	fade.Completed:Connect(function()
		if UserTooltip.BackgroundTransparency == 1 then
			UserTooltip.Visible = false
		end
	end)
end)

ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -64)
ContentArea.Position = UDim2.new(0, 0, 0, 64)
ContentArea.BackgroundColor3 = Colors.Background
ContentArea.BorderSizePixel = 0
ContentArea.ClipsDescendants = true
ContentArea.ZIndex = 6
ContentArea.Parent = ContentPanel

local ContentAreaCorner = Instance.new("UICorner")
ContentAreaCorner.CornerRadius = UDim.new(0, 14)
ContentAreaCorner.Parent = ContentArea

local ContentAreaStroke = Instance.new("UIStroke")
ContentAreaStroke.Color = Colors.Border
ContentAreaStroke.Thickness = 1
ContentAreaStroke.Parent = ContentArea

panels = {}
local panelItemCounters = {}
local function getNextLayoutOrder(parent)
	if not parent then return 1 end
	panelItemCounters[parent] = (panelItemCounters[parent] or 0) + 1
	return panelItemCounters[parent]
end

AllRegisteredCards = {}
local registeredCardsSet = {}

function registerSearchCard(card, name, parent)
	if card and parent and name then
		if registeredCardsSet[card] then return end
		registeredCardsSet[card] = true
		local cleanSearchName = string.lower(tostring(name or "")):gsub("<[^>]->", "")
		local assignedOrder = card.LayoutOrder
		if not assignedOrder or assignedOrder <= 0 then
			assignedOrder = getNextLayoutOrder(parent)
			card.LayoutOrder = assignedOrder
		end
		pcall(function() card:SetAttribute("NebulaOrigOrder", assignedOrder) end)
		table.insert(AllRegisteredCards, {
			card = card,
			name = cleanSearchName,
			origParent = parent,
			origOrder = assignedOrder
		})
	end
end

function createPanel(name)
	local panel = Instance.new("ScrollingFrame")
	panel.Name = name
	panel.Size = UDim2.new(1, -24, 1, -24)
	panel.Position = UDim2.new(0, 12, 0, 12)
	panel.BackgroundTransparency = 1
	panel.BorderSizePixel = 0
	panel.ScrollBarThickness = 3
	panel.ScrollBarImageColor3 = Colors.Accent
	panel.ScrollBarImageTransparency = 0.6
	panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
	panel.CanvasSize = UDim2.new(0, 0, 0, 0)
	panel.Visible = false
	panel.ZIndex = 7
	panel.Parent = ContentArea

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = panel

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 8)
	pad.PaddingBottom = UDim.new(0, 24)
	pad.Parent = panel

	panels[name] = panel
	return panel
end

SearchPanel = createPanel("Search")

local NoResultContainer = Instance.new("Frame")
NoResultContainer.Name = "NoResultContainer"
NoResultContainer.Size = UDim2.new(1, 0, 0, 130)
NoResultContainer.BackgroundTransparency = 1
NoResultContainer.Visible = false
NoResultContainer.LayoutOrder = 999999
NoResultContainer.Parent = SearchPanel

local NoResultIcon = Instance.new("ImageLabel")
NoResultIcon.Size = UDim2.new(0, 36, 0, 36)
NoResultIcon.Position = UDim2.new(0.5, -18, 0, 20)
NoResultIcon.BackgroundTransparency = 1
NoResultIcon.Image = "rbxassetid://7733956411"
NoResultIcon.ImageColor3 = Colors.TextMuted
NoResultIcon.Parent = NoResultContainer

local NoResultLabel = Instance.new("TextLabel")
NoResultLabel.Size = UDim2.new(1, 0, 0, 24)
NoResultLabel.Position = UDim2.new(0, 0, 0, 64)
NoResultLabel.BackgroundTransparency = 1
NoResultLabel.Font = Enum.Font.GothamMedium
NoResultLabel.Text = "Aucune option trouvee"
NoResultLabel.TextColor3 = Colors.TextDim
NoResultLabel.TextSize = 13
NoResultLabel.Parent = NoResultContainer

local NoResultSub = Instance.new("TextLabel")
NoResultSub.Size = UDim2.new(1, 0, 0, 18)
NoResultSub.Position = UDim2.new(0, 0, 0, 90)
NoResultSub.BackgroundTransparency = 1
NoResultSub.Font = Enum.Font.Gotham
NoResultSub.Text = "Essayez un autre mot-cle (ex: Speed, Aim, ESP, Fly...)"
NoResultSub.TextColor3 = Colors.TextMuted
NoResultSub.TextSize = 11
NoResultSub.Parent = NoResultContainer

function filterCards(query)
	local rawQuery = tostring(query or "")
	local cleanQuery = string.lower(rawQuery):match("^%s*(.-)%s*$")
	if not cleanQuery or cleanQuery == "" then
		if ClearSearchBtn then ClearSearchBtn.Visible = false end
		for _, item in ipairs(AllRegisteredCards) do
			if item.card and item.origParent then
				if item.card.Parent ~= item.origParent then
					item.card.Parent = item.origParent
				end
				local restoredOrder = item.origOrder
				if not restoredOrder or restoredOrder <= 0 then
					pcall(function() restoredOrder = item.card:GetAttribute("NebulaOrigOrder") end)
				end
				item.card.LayoutOrder = restoredOrder or 1
				item.card.Visible = true
			end
		end
		if SearchPanel then SearchPanel.Visible = false end
		if NoResultContainer then NoResultContainer.Visible = false end
		if switchCategory then
			switchCategory(currentCategory)
		end
	else
		if ClearSearchBtn then ClearSearchBtn.Visible = true end
		for name, panel in pairs(panels) do
			if name ~= "Search" then
				panel.Visible = false
			end
		end
		if SearchPanel then
			SearchPanel.Visible = true
			SearchPanel.Position = UDim2.new(0, 12, 0, 12)
		end

		local normalizedQuery = cleanQuery:gsub("[éèêë]", "e"):gsub("[àâä]", "a"):gsub("[ùûü]", "u"):gsub("[îï]", "i"):gsub("[ôö]", "o"):gsub("[ç]", "c")
		local matchCount = 0
		for _, item in ipairs(AllRegisteredCards) do
			if item.card and item.origParent then
				local normItemName = tostring(item.name or ""):gsub("[éèêë]", "e"):gsub("[àâä]", "a"):gsub("[ùûü]", "u"):gsub("[îï]", "i"):gsub("[ôö]", "o"):gsub("[ç]", "c")
				if string.find(normItemName, normalizedQuery, 1, true) or string.find(item.name, cleanQuery, 1, true) then
					matchCount = matchCount + 1
					item.card.Parent = SearchPanel
					item.card.LayoutOrder = matchCount
					item.card.Visible = true
				else
					if item.card.Parent == SearchPanel then
						item.card.Parent = item.origParent
						local restoredOrder = item.origOrder
						if not restoredOrder or restoredOrder <= 0 then
							pcall(function() restoredOrder = item.card:GetAttribute("NebulaOrigOrder") end)
						end
						item.card.LayoutOrder = restoredOrder or 1
					end
				end
			end
		end

		if matchCount == 0 then
			PanelTitle.Text = "AUCUN RESULTAT"
			if NoResultContainer then
				NoResultContainer.Visible = true
				if NoResultLabel then
					NoResultLabel.Text = 'Aucune option pour "' .. rawQuery .. '"'
				end
			end
		else
			PanelTitle.Text = "RESULTATS (" .. matchCount .. ")"
			if NoResultContainer then
				NoResultContainer.Visible = false
			end
		end
	end
end

function createCard(parent, order, height)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, height or 46)
	card.BackgroundColor3 = Colors.Card
	card.BorderSizePixel = 0
	local assignedOrder = (order and order > 0) and order or getNextLayoutOrder(parent)
	card.LayoutOrder = assignedOrder
	pcall(function() card:SetAttribute("NebulaOrigOrder", assignedOrder) end)
	card.ZIndex = 8
	card.Parent = parent

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 10)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Colors.Border
	cardStroke.Thickness = 1
	cardStroke.Parent = card

	card.MouseEnter:Connect(function()
		CreateTween(card, {BackgroundColor3 = Colors.CardSub}, 0.15)
		CreateTween(cardStroke, {Color = Colors.BorderActive}, 0.15)
	end)
	card.MouseLeave:Connect(function()
		CreateTween(card, {BackgroundColor3 = Colors.Card}, 0.15)
		CreateTween(cardStroke, {Color = Colors.Border}, 0.15)
	end)

	return card
end

function createSectionHeader(parent, title, order)
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 26)
	header.BackgroundTransparency = 1
	local assignedOrder = (order and order > 0) and order or getNextLayoutOrder(parent)
	header.LayoutOrder = assignedOrder
	pcall(function() header:SetAttribute("NebulaOrigOrder", assignedOrder) end)
	header.ZIndex = 8
	header.Parent = parent

	local TitleContainer = Instance.new("Frame")
	TitleContainer.Size = UDim2.new(0, 0, 1, 0)
	TitleContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	TitleContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	TitleContainer.BackgroundTransparency = 1
	TitleContainer.AutomaticSize = Enum.AutomaticSize.X
	TitleContainer.Parent = header

	local TitleLayout = Instance.new("UIListLayout")
	TitleLayout.FillDirection = Enum.FillDirection.Horizontal
	TitleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TitleLayout.Padding = UDim.new(0, 6)
	TitleLayout.Parent = TitleContainer

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 0, 1, 0)
	lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.BackgroundTransparency = 1
	lbl.Text = tostring(title):upper()
	lbl.TextColor3 = Colors.Accent
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.Parent = TitleContainer

	local HelpIcon = Instance.new("ImageLabel")
	HelpIcon.Size = UDim2.new(0, 13, 0, 13)
	HelpIcon.BackgroundTransparency = 1
	HelpIcon.Image = "rbxassetid://7733956210"
	HelpIcon.ImageColor3 = Colors.Accent
	HelpIcon.Parent = TitleContainer

	return header
end

function setToggleBtn(btn, value)
	if not btn then return end
	local isEnabled = (value == true)
	local stroke = btn:FindFirstChildOfClass("UIStroke")
	if isEnabled then
		btn.Text = "ON"
		CreateTween(btn, {BackgroundColor3 = Colors.Accent, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
		if stroke then CreateTween(stroke, {Color = Colors.AccentLight}, 0.15) end
	else
		btn.Text = "OFF"
		CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(24, 24, 28), TextColor3 = Colors.TextDim}, 0.15)
		if stroke then CreateTween(stroke, {Color = Colors.Border}, 0.15) end
	end
end

function createToggleCard(parent, text, subtext, order, getter, setter)
	local card = createCard(parent, order, subtext and 54 or 46)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 0, 16)
	title.Position = UDim2.new(0, 14, 0, subtext and 8 or 15)
	title.BackgroundTransparency = 1
	title.Text = text
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 9
	title.Parent = card

	if subtext then
		local sub = Instance.new("TextLabel")
		sub.Size = UDim2.new(1, -80, 0, 14)
		sub.Position = UDim2.new(0, 14, 0, 26)
		sub.BackgroundTransparency = 1
		sub.Text = subtext
		sub.TextColor3 = Colors.TextDim
		sub.Font = Enum.Font.Gotham
		sub.TextSize = 10
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.ZIndex = 9
		sub.Parent = card
	end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 52, 0, 24)
	btn.Position = UDim2.new(1, -64, 0.5, -12)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	btn.BorderSizePixel = 0
	btn.Text = "OFF"
	btn.TextColor3 = Colors.TextDim
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.AutoButtonColor = false
	btn.ZIndex = 10
	btn.Parent = card

	local btnScale = Instance.new("UIScale")
	btnScale.Scale = 1
	btnScale.Parent = btn

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 6)
	bCorner.Parent = btn

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = Colors.Border
	bStroke.Thickness = 1
	bStroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		pcall(function() GuiService.SelectedObject = nil end)
		playClick()
		CreateTween(btnScale, {Scale = 0.8}, 0.08)
		task.delay(0.08, function()
			CreateTween(btnScale, {Scale = 1.1}, 0.12, Enum.EasingStyle.Back)
			task.delay(0.12, function()
				CreateTween(btnScale, {Scale = 1.0}, 0.1)
			end)
		end)
		local newVal = not getter()
		setter(newVal)
		setToggleBtn(btn, newVal)
		notify(text, newVal and "Active" or "Desactive", newVal and Colors.Success or Colors.Info)
	end)

	setToggleBtn(btn, getter())
	registerSearchCard(card, text, parent)
	return card, btn
end

categories = {
	{ key = "Information", title = "Information" },
	{ key = "Movement", title = "Movement" },
	{ key = "Me", title = "Me" },
	{ key = "Protection", title = "Protection" },
	{ key = "ESP", title = "ESP" },
	{ key = "Aim", title = "Aim" },
	{ key = "Teleport", title = "Teleport" },
	{ key = "Joueur", title = "Joueur" },
	{ key = "Server", title = "Server" },
	{ key = "Vehicle", title = "Vehicle" },
	{ key = "Fun", title = "Fun" },
	{ key = "Settings", title = "Settings" },
	{ key = "Config", title = "Config" },
	{ key = "Code", title = "Code" },
}

local setVisualPreviewVisible
do
local function initVisualPreview()
	local VP = {}
	local PreviewGuiService = GuiService

	local VisualPreview = Instance.new("Frame")
	VisualPreview.Name = "VisualPreviewWindow"
	VisualPreview.Size = UDim2.new(0, 330, 1, 0)
	VisualPreview.Position = UDim2.new(1, 14, 0, 0)
	VisualPreview.BackgroundColor3 = Color3.fromRGB(11, 11, 15)
	VisualPreview.BorderSizePixel = 0
	VisualPreview.ClipsDescendants = true
	VisualPreview.Visible = false
	VisualPreview.ZIndex = 6
	VisualPreview.Parent = Panel
	VP.Window = VisualPreview

	do
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 12)
		c.Parent = VisualPreview
		local s = Instance.new("UIStroke")
		s.Color = Color3.fromRGB(35, 35, 45)
		s.Thickness = 1
		s.Parent = VisualPreview
		local sc = Instance.new("UIScale")
		sc.Scale = 0.92
		sc.Parent = VisualPreview
		VP.Scale = sc
	end

	do
		local top = Instance.new("Frame")
		top.Name = "PreviewTop"
		top.Size = UDim2.new(1, 0, 0, 38)
		top.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		top.BorderSizePixel = 0
		top.ZIndex = 7
		top.Parent = VisualPreview

		local tc = Instance.new("UICorner")
		tc.CornerRadius = UDim.new(0, 12)
		tc.Parent = top

		local cover = Instance.new("Frame")
		cover.Size = UDim2.new(1, 0, 0, 12)
		cover.Position = UDim2.new(0, 0, 1, -12)
		cover.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		cover.BorderSizePixel = 0
		cover.ZIndex = 7
		cover.Parent = top

		local div = Instance.new("Frame")
		div.Size = UDim2.new(1, 0, 0, 1)
		div.Position = UDim2.new(0, 0, 1, -1)
		div.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		div.BorderSizePixel = 0
		div.ZIndex = 8
		div.Parent = top

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -100, 1, 0)
		title.Position = UDim2.new(0, 14, 0, 0)
		title.BackgroundTransparency = 1
		title.Text = "ESP Preview"
		title.TextColor3 = Color3.fromRGB(220, 220, 235)
		title.TextSize = 12
		title.Font = Enum.Font.GothamBold
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.ZIndex = 9
		title.Parent = top

		local status = Instance.new("TextLabel")
		status.Size = UDim2.new(0, 74, 1, 0)
		status.Position = UDim2.new(1, -86, 0, 0)
		status.BackgroundTransparency = 1
		status.Text = "ESP OFF"
		status.TextColor3 = Color3.fromRGB(110, 110, 130)
		status.TextSize = 10
		status.Font = Enum.Font.GothamBold
		status.TextXAlignment = Enum.TextXAlignment.Right
		status.ZIndex = 9
		status.Parent = top
		VP.StatusLabel = status
	end

	do
		local grid = Instance.new("Frame")
		grid.Name = "TacticalGrid"
		grid.Size = UDim2.new(1, 0, 1, -38)
		grid.Position = UDim2.new(0, 0, 0, 38)
		grid.BackgroundTransparency = 1
		grid.BorderSizePixel = 0
		grid.ZIndex = 6
		grid.Parent = VisualPreview

		for i = 1, 7 do
			local vLine = Instance.new("Frame")
			vLine.Size = UDim2.new(0, 1, 1, 0)
			vLine.Position = UDim2.new(i / 8, 0, 0, 0)
			vLine.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
			vLine.BorderSizePixel = 0
			vLine.ZIndex = 6
			vLine.Parent = grid
		end

		for j = 1, 11 do
			local hLine = Instance.new("Frame")
			hLine.Size = UDim2.new(1, 0, 0, 1)
			hLine.Position = UDim2.new(0, 0, j / 12, 0)
			hLine.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
			hLine.BorderSizePixel = 0
			hLine.ZIndex = 6
			hLine.Parent = grid
		end

		local aura = Instance.new("ImageLabel")
		aura.Name = "GlowAura"
		aura.BackgroundTransparency = 1
		aura.Image = "rbxassetid://5028857472"
		aura.ImageColor3 = Color3.fromRGB(255, 60, 60)
		aura.ImageTransparency = 0.42
		aura.Visible = false
		aura.ZIndex = 6
		aura.Parent = grid
		VP.GlowAura = aura

		local function makeTacticalCorner(pos, isLeft)
			local hB = Instance.new("Frame")
			hB.Size = UDim2.new(0, 12, 0, 1.5)
			hB.Position = pos
			hB.BackgroundColor3 = Color3.fromRGB(90, 95, 115)
			hB.BorderSizePixel = 0
			hB.ZIndex = 9
			hB.Parent = grid

			local vB = Instance.new("Frame")
			vB.Size = UDim2.new(0, 1.5, 0, 12)
			vB.Position = isLeft and pos or UDim2.new(pos.X.Scale, pos.X.Offset + 10.5, pos.Y.Scale, pos.Y.Offset)
			vB.BackgroundColor3 = Color3.fromRGB(90, 95, 115)
			vB.BorderSizePixel = 0
			vB.ZIndex = 9
			vB.Parent = grid
		end

		makeTacticalCorner(UDim2.new(0, 10, 0, 10), true)
		makeTacticalCorner(UDim2.new(1, -22, 0, 10), false)
	end

	do
		local vpf = Instance.new("ViewportFrame")
		vpf.Name = "PreviewViewport"
		vpf.Size = UDim2.new(1, 0, 1, -38)
		vpf.Position = UDim2.new(0, 0, 0, 38)
		vpf.BackgroundTransparency = 1
		vpf.BorderSizePixel = 0
		vpf.LightColor = Color3.fromRGB(245, 245, 255)
		vpf.Ambient = Color3.fromRGB(170, 170, 195)
		vpf.LightDirection = Vector3.new(-1, -1.2, -2)
		vpf.ZIndex = 7
		vpf.Parent = VisualPreview
		VP.VPF = vpf

		local world = Instance.new("WorldModel")
		world.Parent = vpf
		VP.World = world

		local cam = Instance.new("Camera")
		cam.FieldOfView = 36
		cam.CFrame = CFrame.new(Vector3.new(0, 0, 11.5), Vector3.new(0, 0, 0))
		cam.Parent = vpf
		vpf.CurrentCamera = cam
		VP.Camera = cam
	end

	do
		local overlay = Instance.new("Frame")
		overlay.Name = "ESPOverlay"
		overlay.Size = UDim2.new(1, 0, 1, -38)
		overlay.Position = UDim2.new(0, 0, 0, 38)
		overlay.BackgroundTransparency = 1
		overlay.BorderSizePixel = 0
		overlay.ZIndex = 25
		overlay.Parent = VisualPreview
		VP.Overlay = overlay

		local gLine = Instance.new("Frame")
		gLine.Name = "GroundLine"
		gLine.Size = UDim2.new(1, 0, 0, 1.5)
		gLine.Position = UDim2.new(0, 0, 0.84, 0)
		gLine.BackgroundColor3 = Color3.fromRGB(65, 70, 85)
		gLine.BorderSizePixel = 0
		gLine.ZIndex = 25
		gLine.Parent = overlay
		VP.GroundLine = gLine

		local sRing = Instance.new("Frame")
		sRing.Name = "SonarRing"
		sRing.AnchorPoint = Vector2.new(0.5, 0.5)
		sRing.BackgroundTransparency = 1
		sRing.Visible = false
		sRing.ZIndex = 25
		sRing.Parent = overlay
		local sCorner = Instance.new("UICorner")
		sCorner.CornerRadius = UDim.new(1, 0)
		sCorner.Parent = sRing
		local sStroke = Instance.new("UIStroke")
		sStroke.Thickness = 2
		sStroke.Color = Color3.fromRGB(145, 120, 255)
		sStroke.Parent = sRing
		VP.SonarRing = sRing
		VP.SonarRingStroke = sStroke

		local box = Instance.new("Frame")
		box.Name = "BoxESP"
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Visible = false
		box.ZIndex = 26
		box.Parent = overlay
		VP.BoxFrame = box

		local bStroke = Instance.new("UIStroke")
		bStroke.Thickness = 1.5
		bStroke.Color = Color3.fromRGB(255, 60, 60)
		bStroke.Enabled = false
		bStroke.Parent = box
		VP.BoxStroke = bStroke

		local function makeCornerPair(anchor, pos, s1, s2)
			local c1 = Instance.new("Frame")
			c1.Size = s1
			c1.Position = pos
			c1.AnchorPoint = anchor
			c1.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
			c1.BorderSizePixel = 0
			c1.Visible = false
			c1.ZIndex = 27
			c1.Parent = box

			local c2 = Instance.new("Frame")
			c2.Size = s2
			c2.Position = pos
			c2.AnchorPoint = anchor
			c2.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
			c2.BorderSizePixel = 0
			c2.Visible = false
			c2.ZIndex = 27
			c2.Parent = box

			return c1, c2
		end

		local tl1, tl2 = makeCornerPair(Vector2.new(0, 0), UDim2.new(0, 0, 0, 0), UDim2.new(0, 16, 0, 2), UDim2.new(0, 2, 0, 16))
		local tr1, tr2 = makeCornerPair(Vector2.new(1, 0), UDim2.new(1, 0, 0, 0), UDim2.new(0, 16, 0, 2), UDim2.new(0, 2, 0, 16))
		local bl1, bl2 = makeCornerPair(Vector2.new(0, 1), UDim2.new(0, 0, 1, 0), UDim2.new(0, 16, 0, 2), UDim2.new(0, 2, 0, 16))
		local br1, br2 = makeCornerPair(Vector2.new(1, 1), UDim2.new(1, 0, 1, 0), UDim2.new(0, 16, 0, 2), UDim2.new(0, 2, 0, 16))
		VP.CornerH = {tl1, tr1, bl1, br1}
		VP.CornerV = {tl2, tr2, bl2, br2}
		VP.AllCorners = {tl1, tl2, tr1, tr2, bl1, bl2, br1, br2}

		local hpBg = Instance.new("Frame")
		hpBg.Name = "HealthBar"
		hpBg.Size = UDim2.new(0, 4, 1, 0)
		hpBg.Position = UDim2.new(0, -8, 0, 0)
		hpBg.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
		hpBg.BorderSizePixel = 0
		hpBg.Visible = false
		hpBg.ZIndex = 26
		hpBg.Parent = box
		local hpStroke = Instance.new("UIStroke")
		hpStroke.Thickness = 1
		hpStroke.Color = Color3.fromRGB(0, 0, 0)
		hpStroke.Transparency = 0.25
		hpStroke.Parent = hpBg
		local hpFill = Instance.new("Frame")
		hpFill.Size = UDim2.new(1, 0, 1, 0)
		hpFill.BackgroundColor3 = Color3.fromRGB(65, 235, 115)
		hpFill.BorderSizePixel = 0
		hpFill.ZIndex = 27
		hpFill.Parent = hpBg
		VP.HealthBarBg = hpBg
		VP.HealthBarFill = hpFill

		local pvLbl = Instance.new("TextLabel")
		pvLbl.Name = "HealthPvLabel"
		pvLbl.Size = UDim2.new(0, 46, 0, 14)
		pvLbl.Position = UDim2.new(0, -56, 0, -1)
		pvLbl.BackgroundTransparency = 1
		pvLbl.Text = "100 PV"
		pvLbl.TextColor3 = Color3.fromRGB(65, 235, 115)
		pvLbl.TextStrokeTransparency = 0.2
		pvLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		pvLbl.Font = Enum.Font.GothamBold
		pvLbl.TextSize = 10
		pvLbl.TextXAlignment = Enum.TextXAlignment.Right
		pvLbl.Visible = false
		pvLbl.ZIndex = 28
		pvLbl.Parent = box
		VP.HealthPvLabel = pvLbl

		local nLbl = Instance.new("TextLabel")
		nLbl.Name = "NameLabel"
		nLbl.Size = UDim2.new(0, 200, 0, 16)
		nLbl.AnchorPoint = Vector2.new(0.5, 0)
		nLbl.Position = UDim2.new(0.5, 0, 0, -19)
		nLbl.BackgroundTransparency = 1
		nLbl.Text = tostring(LocalPlayer.Name)
		nLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
		nLbl.TextStrokeTransparency = 0.2
		nLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		nLbl.Font = Enum.Font.GothamBold
		nLbl.TextSize = 12
		nLbl.Visible = false
		nLbl.ZIndex = 28
		nLbl.Parent = box
		VP.NameLabel = nLbl

		local lvLbl = Instance.new("TextLabel")
		lvLbl.Name = "BFLevelLabel"
		lvLbl.Size = UDim2.new(0, 160, 0, 14)
		lvLbl.AnchorPoint = Vector2.new(0.5, 0)
		lvLbl.Position = UDim2.new(0.5, 0, 0, -34)
		lvLbl.BackgroundTransparency = 1
		lvLbl.Text = "[Lv. 2550]"
		lvLbl.TextColor3 = Color3.fromRGB(175, 110, 255)
		lvLbl.TextStrokeTransparency = 0.2
		lvLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		lvLbl.Font = Enum.Font.GothamBold
		lvLbl.TextSize = 11
		lvLbl.Visible = false
		lvLbl.ZIndex = 28
		lvLbl.Parent = box
		VP.BFLevelLabel = lvLbl

		local frLbl = Instance.new("TextLabel")
		frLbl.Name = "BFFruitLabel"
		frLbl.Size = UDim2.new(0, 190, 0, 14)
		frLbl.AnchorPoint = Vector2.new(0.5, 0)
		frLbl.Position = UDim2.new(0.5, 0, 0, -49)
		frLbl.BackgroundTransparency = 1
		frLbl.RichText = true
		frLbl.Text = '[Kitsune] <font color="rgb(255,50,50)">perm</font>'
		frLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		frLbl.TextStrokeTransparency = 0.2
		frLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		frLbl.Font = Enum.Font.GothamBold
		frLbl.TextSize = 11
		frLbl.Visible = false
		frLbl.ZIndex = 28
		frLbl.Parent = box
		VP.BFFruitLabel = frLbl

		local dLbl = Instance.new("TextLabel")
		dLbl.Name = "DistLabel"
		dLbl.Size = UDim2.new(0, 56, 0, 15)
		dLbl.Position = UDim2.new(1, 6, 0, -1)
		dLbl.BackgroundTransparency = 1
		dLbl.Text = "14m"
		dLbl.TextColor3 = Color3.fromRGB(210, 210, 225)
		dLbl.TextStrokeTransparency = 0.2
		dLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		dLbl.Font = Enum.Font.GothamBold
		dLbl.TextSize = 11
		dLbl.TextXAlignment = Enum.TextXAlignment.Left
		dLbl.Visible = false
		dLbl.ZIndex = 28
		dLbl.Parent = box
		VP.DistLabel = dLbl

		local wLbl = Instance.new("TextLabel")
		wLbl.Name = "WeaponLabel"
		wLbl.Size = UDim2.new(0, 200, 0, 15)
		wLbl.AnchorPoint = Vector2.new(0.5, 0)
		wLbl.Position = UDim2.new(0.5, 0, 1, 5)
		wLbl.BackgroundTransparency = 1
		wLbl.Text = "[Knife]"
		wLbl.TextColor3 = Color3.fromRGB(180, 170, 255)
		wLbl.TextStrokeTransparency = 0.2
		wLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		wLbl.Font = Enum.Font.GothamBold
		wLbl.TextSize = 10
		wLbl.Visible = false
		wLbl.ZIndex = 28
		wLbl.Parent = box
		VP.WeaponLabel = wLbl

		local drLbl = Instance.new("TextLabel")
		drLbl.Name = "DroppedLabel"
		drLbl.Size = UDim2.new(0, 90, 0, 15)
		drLbl.AnchorPoint = Vector2.new(0.5, 1)
		drLbl.Position = UDim2.new(0.82, 0, 0.83, -2)
		drLbl.BackgroundTransparency = 1
		drLbl.Text = "[Item]"
		drLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
		drLbl.TextStrokeTransparency = 0.2
		drLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		drLbl.Font = Enum.Font.GothamBold
		drLbl.TextSize = 10
		drLbl.Visible = false
		drLbl.ZIndex = 28
		drLbl.Parent = overlay
		VP.DroppedLabel = drLbl

		local arr = Instance.new("ImageLabel")
		arr.Name = "ArrowIndicator"
		arr.Size = UDim2.new(0, 24, 0, 24)
		arr.AnchorPoint = Vector2.new(0.5, 0.5)
		arr.Position = UDim2.new(0.88, 0, 0.16, 0)
		arr.Rotation = -135
		arr.BackgroundTransparency = 1
		arr.BorderSizePixel = 0
		arr.Image = "rbxassetid://7734020942"
		arr.ImageColor3 = Color3.fromRGB(255, 60, 60)
		arr.Visible = false
		arr.ZIndex = 28
		arr.Parent = overlay
		VP.ArrowIndicator = arr

		local hDot = Instance.new("Frame")
		hDot.Size = UDim2.new(0, 18, 0, 18)
		hDot.AnchorPoint = Vector2.new(0.5, 0.5)
		hDot.BackgroundTransparency = 1
		hDot.Visible = false
		hDot.ZIndex = 28
		hDot.Parent = overlay
		local hStroke = Instance.new("UIStroke")
		hStroke.Thickness = 1.5
		hStroke.Color = Color3.fromRGB(255, 60, 60)
		hStroke.Parent = hDot
		local hCorner = Instance.new("UICorner")
		hCorner.CornerRadius = UDim.new(1, 0)
		hCorner.Parent = hDot
		VP.HeadDot = hDot
		VP.HeadDotStroke = hStroke

		local tLine = Instance.new("Frame")
		tLine.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		tLine.BorderSizePixel = 0
		tLine.Visible = false
		tLine.ZIndex = 25
		tLine.AnchorPoint = Vector2.new(0.5, 0.5)
		tLine.Parent = overlay
		VP.TracerLine = tLine

		VP.SkeletonLines = {}
		for i = 1, 18 do
			local line = Instance.new("Frame")
			line.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
			line.BorderSizePixel = 0
			line.Visible = false
			line.ZIndex = 26
			line.AnchorPoint = Vector2.new(0.5, 0.5)
			line.Parent = overlay
			table.insert(VP.SkeletonLines, line)
		end

		VP.JointDots = {}
		for i = 1, 16 do
			local dot = Instance.new("Frame")
			dot.Size = UDim2.new(0, 4, 0, 4)
			dot.AnchorPoint = Vector2.new(0.5, 0.5)
			dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
			dot.BorderSizePixel = 0
			dot.Visible = false
			dot.ZIndex = 27
			local dotCorner = Instance.new("UICorner")
			dotCorner.CornerRadius = UDim.new(1, 0)
			dotCorner.Parent = dot
			dot.Parent = overlay
			table.insert(VP.JointDots, dot)
		end
	end

	VP.model = nil
	VP.root = nil
	VP.head = nil
	VP.bodyParts = {}
	VP.joints = {}
	VP.glowParts = {}
	VP.lastGlow = nil
	VP.lastGlowCol = nil
	VP.rot = 0
	VP.baseY = 0
	VP.dragging = false
	VP.dragStart = 0
	VP.initRot = 0
	VP.active = false

	local function projectToPreview(worldPos)
		local vpSize = VP.VPF.AbsoluteSize
		if vpSize.X <= 1 or vpSize.Y <= 1 then
			return nil, false
		end
		local rel = VP.Camera.CFrame:PointToObjectSpace(worldPos)
		local depth = -rel.Z
		if depth <= 0.05 then
			return nil, false
		end
		local halfH = depth * math.tan(math.rad(VP.Camera.FieldOfView) * 0.5)
		local halfW = halfH * (vpSize.X / vpSize.Y)
		local u = (rel.X / halfW) * 0.5 + 0.5
		local v = 0.5 - (rel.Y / halfH) * 0.5
		if u ~= u or v ~= v then
			return nil, false
		end
		return Vector2.new(u, v), true
	end

	local function update2DLineUV(lineFrame, uv1, uv2, thickness, color, ovW, ovH)
		local p1 = Vector2.new(uv1.X * ovW, uv1.Y * ovH)
		local p2 = Vector2.new(uv2.X * ovW, uv2.Y * ovH)
		local diff = p2 - p1
		local dist = diff.Magnitude
		if dist < 1 then
			lineFrame.Visible = false
			return
		end
		lineFrame.Size = UDim2.new(0, dist, 0, thickness or 1.5)
		lineFrame.Position = UDim2.fromScale((uv1.X + uv2.X) * 0.5, (uv1.Y + uv2.Y) * 0.5)
		lineFrame.Rotation = math.deg(math.atan2(diff.Y, diff.X))
		lineFrame.BackgroundColor3 = color
		lineFrame.Visible = true
	end

	local function getJointWorldPos(jointName, fallbackPartName)
		local j = VP.joints[jointName]
		if j and j.p0 and j.p0.Parent and j.motor then
			return (j.p0.CFrame * j.motor.C0).Position
		end
		local fp = VP.model and VP.model:FindFirstChild(fallbackPartName)
		return fp and fp.Position or nil
	end

	local function setupPreviewCharacter()
		if VP.model then
			pcall(function() VP.model:Destroy() end)
			VP.model = nil
			VP.root = nil
			VP.head = nil
			VP.bodyParts = {}
			VP.joints = {}
			VP.glowParts = {}
			VP.lastGlow = nil
			VP.lastGlowCol = nil
		end

		local char = LocalPlayer.Character
		if not char then return end

		pcall(function()
			char.Archivable = true
			for _, desc in ipairs(char:GetDescendants()) do
				pcall(function() desc.Archivable = true end)
			end
		end)

		local clone = nil
		pcall(function() clone = char:Clone() end)
		pcall(function() char.Archivable = false end)
		if not clone then return end

		for _, item in ipairs(clone:GetChildren()) do
			if item:IsA("Tool") or item:IsA("HopperBin") then
				pcall(function() item:Destroy() end)
			end
		end

		local validLimbs = {
			["HumanoidRootPart"] = true, ["Head"] = true, ["Torso"] = true,
			["UpperTorso"] = true, ["LowerTorso"] = true,
			["LeftUpperArm"] = true, ["LeftLowerArm"] = true, ["LeftHand"] = true,
			["RightUpperArm"] = true, ["RightLowerArm"] = true, ["RightHand"] = true,
			["LeftUpperLeg"] = true, ["LeftLowerLeg"] = true, ["LeftFoot"] = true,
			["RightUpperLeg"] = true, ["RightLowerLeg"] = true, ["RightFoot"] = true,
			["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true
		}

		for _, item in ipairs(clone:GetChildren()) do
			if item:IsA("BasePart") and not validLimbs[item.Name] and item.Name ~= "Handle" then
				pcall(function() item:Destroy() end)
			elseif item:IsA("Model") then
				pcall(function() item:Destroy() end)
			end
		end

		for _, item in ipairs(clone:GetDescendants()) do
			if item:IsA("Accessory") then
				local nm = item.Name:lower()
				if string.find(nm, "sword") or string.find(nm, "blade") or string.find(nm, "weapon") or string.find(nm, "gun") or string.find(nm, "cutlass") or string.find(nm, "saber") or string.find(nm, "knife") or string.find(nm, "katana") or string.find(nm, "axe") or string.find(nm, "bow") or string.find(nm, "item") then
					pcall(function() item:Destroy() end)
				end
			end
		end

		for _, desc in ipairs(clone:GetDescendants()) do
			if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("Sound") or desc:IsA("BillboardGui") or desc:IsA("Animator") or desc:IsA("AnimationController") then
				pcall(function() desc:Destroy() end)
			end
		end

		local hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone.PrimaryPart
		if not hrp then return end
		clone.PrimaryPart = hrp

		local hum = clone:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = true
			hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end

		pcall(function() clone:PivotTo(CFrame.new(0, 0, 0)) end)

		local isR15Rig = clone:FindFirstChild("UpperTorso") ~= nil
		local orderedJoints = isR15Rig and {
			{"Root", "LowerTorso", CFrame.new()},
			{"Waist", "UpperTorso", CFrame.new()},
			{"Neck", "Head", CFrame.new()},
			{"LeftShoulder", "LeftUpperArm", CFrame.Angles(0, 0, math.rad(-18))},
			{"LeftElbow", "LeftLowerArm", CFrame.new()},
			{"LeftWrist", "LeftHand", CFrame.new()},
			{"RightShoulder", "RightUpperArm", CFrame.Angles(0, 0, math.rad(18))},
			{"RightElbow", "RightLowerArm", CFrame.new()},
			{"RightWrist", "RightHand", CFrame.new()},
			{"LeftHip", "LeftUpperLeg", CFrame.new()},
			{"LeftKnee", "LeftLowerLeg", CFrame.new()},
			{"LeftAnkle", "LeftFoot", CFrame.new()},
			{"RightHip", "RightUpperLeg", CFrame.new()},
			{"RightKnee", "RightLowerLeg", CFrame.new()},
			{"RightAnkle", "RightFoot", CFrame.new()}
		} or {
			{"RootJoint", "Torso", CFrame.new()},
			{"Neck", "Head", CFrame.new()},
			{"Left Shoulder", "Left Arm", CFrame.Angles(0, 0, math.rad(-14))},
			{"Right Shoulder", "Right Arm", CFrame.Angles(0, 0, math.rad(14))},
			{"Left Hip", "Left Leg", CFrame.new()},
			{"Right Hip", "Right Leg", CFrame.new()}
		}

		VP.joints = {}
		for _, step in ipairs(orderedJoints) do
			local motorName = step[1]
			local partName = step[2]
			local tf = step[3]
			local p1 = clone:FindFirstChild(partName)
			local motor = p1 and p1:FindFirstChildOfClass("Motor6D")
			if not motor then
				for _, m in ipairs(clone:GetDescendants()) do
					if m:IsA("Motor6D") and (m.Name == motorName or (m.Part1 and m.Part1.Name == partName)) then
						motor = m
						break
					end
				end
			end
			if motor and motor.Part0 and motor.Part1 then
				local rp0 = motor.Part0:IsDescendantOf(clone) and motor.Part0 or clone:FindFirstChild(motor.Part0.Name)
				local rp1 = motor.Part1:IsDescendantOf(clone) and motor.Part1 or clone:FindFirstChild(motor.Part1.Name)
				if rp0 and rp1 then
					pcall(function()
						rp1.CFrame = rp0.CFrame * motor.C0 * tf * motor.C1:Inverse()
					end)
					VP.joints[motorName] = { motor = motor, p0 = rp0, p1 = rp1 }
				end
			end
		end

		for _, acc in ipairs(clone:GetDescendants()) do
			if acc:IsA("Accessory") then
				local handle = acc:FindFirstChild("Handle")
				if handle then
					local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("WeldConstraint")
					if weld and weld.Part0 and weld.Part1 and weld:IsA("Weld") then
						local wp0 = weld.Part0:IsDescendantOf(clone) and weld.Part0 or clone:FindFirstChild(weld.Part0.Name)
						if wp0 then
							pcall(function()
								handle.CFrame = wp0.CFrame * weld.C0 * weld.C1:Inverse()
							end)
						end
					end
				end
			end
		end

		local minY = 100000
		for _, p in ipairs(clone:GetDescendants()) do
			if p:IsA("BasePart") then
				local bY = p.Position.Y - (p.Size.Y / 2)
				if bY < minY then
					minY = bY
				end
			end
		end

		local deltaY = -2.5 - minY
		for _, p in ipairs(clone:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CFrame = CFrame.new(0, deltaY, 0) * p.CFrame
				p.CanCollide = false
				p.Anchored = true
			end
		end

		VP.bodyParts = {}
		for _, part in ipairs(clone:GetChildren()) do
			if part:IsA("BasePart") and validLimbs[part.Name] and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.98 then
				table.insert(VP.bodyParts, part)
			end
		end
		if #VP.bodyParts == 0 then
			for _, part in ipairs(clone:GetDescendants()) do
				if part:IsA("BasePart") and part ~= hrp and part.Transparency < 0.98 then
					table.insert(VP.bodyParts, part)
				end
			end
		end

		local glowFolder = Instance.new("Folder")
		glowFolder.Name = "PreviewGlowShell"
		glowFolder.Parent = clone
		VP.glowParts = {}
		for _, part in ipairs(VP.bodyParts) do
			pcall(function()
				local sp = part:Clone()
				for _, ch in ipairs(sp:GetChildren()) do
					if ch:IsA("SpecialMesh") then
						pcall(function() ch.TextureId = "" end)
					else
						pcall(function() ch:Destroy() end)
					end
				end
				sp.Name = "Glow_" .. part.Name
				sp.Size = part.Size * 1.05
				sp.CFrame = part.CFrame
				sp.Material = Enum.Material.ForceField
				sp.Color = Color3.fromRGB(255, 60, 60)
				sp.Transparency = 1
				sp.CanCollide = false
				sp.Anchored = true
				sp.CastShadow = false
				pcall(function()
					if sp:IsA("MeshPart") then
						sp.TextureID = ""
					end
				end)
				sp.Parent = glowFolder
				table.insert(VP.glowParts, sp)
			end)
		end

		VP.model = clone
		VP.root = hrp
		VP.head = clone:FindFirstChild("Head")
		VP.baseY = deltaY
		VP.lastGlow = nil
		VP.lastGlowCol = nil

		clone.Parent = VP.World
		VP.Camera.CFrame = CFrame.new(Vector3.new(0, 0, 11.5), Vector3.new(0, 0, 0))
	end

	VP.VPF.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			VP.dragging = true
			VP.dragStart = input.Position.X
			VP.initRot = VP.rot
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if VP.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			VP.rot = VP.initRot + ((input.Position.X - VP.dragStart) * 0.015)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			VP.dragging = false
		end
	end)

	setVisualPreviewVisible = function(visible)
		if VP.active == visible then return end
		VP.active = visible
		if visible then
			setupPreviewCharacter()
			VP.Window.Visible = true
			VP.Window.Position = UDim2.new(1, -10, 0, 0)
			VP.Scale.Scale = 0.88
			CreateTween(VP.Window, {Position = UDim2.new(1, 14, 0, 0)}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			CreateTween(VP.Scale, {Scale = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		else
			local closeTween = CreateTween(VP.Window, {Position = UDim2.new(1, -10, 0, 0)}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			CreateTween(VP.Scale, {Scale = 0.88}, 0.22)
			closeTween.Completed:Connect(function()
				if not VP.active then
					VP.Window.Visible = false
				end
			end)
		end
	end

	LocalPlayer.CharacterAdded:Connect(function()
		if VP.active and VP.Window.Visible then
			task.delay(0.5, function()
				setupPreviewCharacter()
			end)
		end
	end)

	local function updatePreviewSkeleton(curColor, ovW, ovH)
		local head = VP.head or VP.model:FindFirstChild("Head")
		if head then
			local uvHead, hOk = projectToPreview(head.Position)
			local uvHTop, tOk = projectToPreview(head.Position + Vector3.new(0, head.Size.Y * 0.5, 0))
			local uvHBot, bOk = projectToPreview(head.Position - Vector3.new(0, head.Size.Y * 0.5, 0))
			if hOk then
				local diam = (tOk and bOk) and math.clamp(math.abs(uvHBot.Y - uvHTop.Y) * ovH * 0.92, 12, 44) or 18
				VP.HeadDot.Size = UDim2.new(0, diam, 0, diam)
				VP.HeadDot.Position = UDim2.fromScale(uvHead.X, uvHead.Y)
				VP.HeadDotStroke.Color = curColor
				VP.HeadDotStroke.Thickness = V.ESPSkeletonThickness or 1.5
				VP.HeadDot.Visible = true
			else
				VP.HeadDot.Visible = false
			end
		else
			VP.HeadDot.Visible = false
		end

		local bonePts = {}
		local dotPts = {}
		if VP.model:FindFirstChild("UpperTorso") ~= nil then
			local pts = {}
			pts.head = head and head.Position
			pts.neck = getJointWorldPos("Neck", "UpperTorso")
			pts.waist = getJointWorldPos("Waist", "LowerTorso")
			local lt = VP.model:FindFirstChild("LowerTorso")
			pts.pelvis = (lt and lt.Position) or pts.waist
			pts.lSh = getJointWorldPos("LeftShoulder", "LeftUpperArm")
			pts.lEl = getJointWorldPos("LeftElbow", "LeftLowerArm")
			local lh = VP.model:FindFirstChild("LeftHand")
			pts.lHa = (lh and lh.Position) or getJointWorldPos("LeftWrist", "LeftHand")
			pts.rSh = getJointWorldPos("RightShoulder", "RightUpperArm")
			pts.rEl = getJointWorldPos("RightElbow", "RightLowerArm")
			local rh = VP.model:FindFirstChild("RightHand")
			pts.rHa = (rh and rh.Position) or getJointWorldPos("RightWrist", "RightHand")
			pts.lHip = getJointWorldPos("LeftHip", "LeftUpperLeg")
			pts.lKnee = getJointWorldPos("LeftKnee", "LeftLowerLeg")
			local lf = VP.model:FindFirstChild("LeftFoot")
			pts.lFoot = (lf and lf.Position) or getJointWorldPos("LeftAnkle", "LeftFoot")
			pts.rHip = getJointWorldPos("RightHip", "RightUpperLeg")
			pts.rKnee = getJointWorldPos("RightKnee", "RightLowerLeg")
			local rf = VP.model:FindFirstChild("RightFoot")
			pts.rFoot = (rf and rf.Position) or getJointWorldPos("RightAnkle", "RightFoot")

			bonePts = {
				{pts.head, pts.neck}, {pts.neck, pts.waist}, {pts.waist, pts.pelvis},
				{pts.neck, pts.lSh}, {pts.lSh, pts.lEl}, {pts.lEl, pts.lHa},
				{pts.neck, pts.rSh}, {pts.rSh, pts.rEl}, {pts.rEl, pts.rHa},
				{pts.pelvis, pts.lHip}, {pts.lHip, pts.lKnee}, {pts.lKnee, pts.lFoot},
				{pts.pelvis, pts.rHip}, {pts.rHip, pts.rKnee}, {pts.rKnee, pts.rFoot},
			}
			dotPts = {
				pts.neck, pts.waist, pts.pelvis,
				pts.lSh, pts.lEl, pts.lHa,
				pts.rSh, pts.rEl, pts.rHa,
				pts.lHip, pts.lKnee, pts.lFoot,
				pts.rHip, pts.rKnee, pts.rFoot,
			}
		else
			local torso = VP.model:FindFirstChild("Torso")
			if torso then
				local la = VP.model:FindFirstChild("Left Arm")
				local ra = VP.model:FindFirstChild("Right Arm")
				local ll = VP.model:FindFirstChild("Left Leg")
				local rl = VP.model:FindFirstChild("Right Leg")
				local pts = {
					head = head and head.Position,
					neck = (torso.CFrame * CFrame.new(0, torso.Size.Y * 0.45, 0)).Position,
					pelvis = (torso.CFrame * CFrame.new(0, -torso.Size.Y * 0.45, 0)).Position,
					lSh = la and (la.CFrame * CFrame.new(0, la.Size.Y * 0.35, 0)).Position,
					lHa = la and (la.CFrame * CFrame.new(0, -la.Size.Y * 0.45, 0)).Position,
					rSh = ra and (ra.CFrame * CFrame.new(0, ra.Size.Y * 0.35, 0)).Position,
					rHa = ra and (ra.CFrame * CFrame.new(0, -ra.Size.Y * 0.45, 0)).Position,
					lHip = ll and (ll.CFrame * CFrame.new(0, ll.Size.Y * 0.4, 0)).Position,
					lFoot = ll and (ll.CFrame * CFrame.new(0, -ll.Size.Y * 0.45, 0)).Position,
					rHip = rl and (rl.CFrame * CFrame.new(0, rl.Size.Y * 0.4, 0)).Position,
					rFoot = rl and (rl.CFrame * CFrame.new(0, -rl.Size.Y * 0.45, 0)).Position,
				}
				bonePts = {
					{pts.head, pts.neck}, {pts.neck, pts.pelvis},
					{pts.neck, pts.lSh}, {pts.lSh, pts.lHa},
					{pts.neck, pts.rSh}, {pts.rSh, pts.rHa},
					{pts.pelvis, pts.lHip}, {pts.lHip, pts.lFoot},
					{pts.pelvis, pts.rHip}, {pts.rHip, pts.rFoot},
				}
				dotPts = {pts.neck, pts.pelvis, pts.lSh, pts.lHa, pts.rSh, pts.rHa, pts.lHip, pts.lFoot, pts.rHip, pts.rFoot}
			end
		end

		local lineIdx = 1
		for _, pair in ipairs(bonePts) do
			if pair[1] and pair[2] and lineIdx <= #VP.SkeletonLines then
				local uv1, ok1 = projectToPreview(pair[1])
				local uv2, ok2 = projectToPreview(pair[2])
				if ok1 and ok2 then
					update2DLineUV(VP.SkeletonLines[lineIdx], uv1, uv2, V.ESPSkeletonThickness or 1.5, curColor, ovW, ovH)
					lineIdx = lineIdx + 1
				end
			end
		end
		for i = lineIdx, #VP.SkeletonLines do
			VP.SkeletonLines[i].Visible = false
		end

		local dotIdx = 1
		for _, dPos in ipairs(dotPts) do
			if dPos and dotIdx <= #VP.JointDots then
				local uvD, okD = projectToPreview(dPos)
				if okD then
					VP.JointDots[dotIdx].Position = UDim2.fromScale(uvD.X, uvD.Y)
					VP.JointDots[dotIdx].BackgroundColor3 = curColor
					VP.JointDots[dotIdx].Visible = true
					dotIdx = dotIdx + 1
				end
			end
		end
		for i = dotIdx, #VP.JointDots do
			VP.JointDots[i].Visible = false
		end
	end

	RunService.RenderStepped:Connect(function()
		if not VP.Window or not VP.Window.Parent then return end
		if not VP.active or not VP.Window.Visible then return end
		if not VP.model or not VP.root or not VP.model.Parent then
			setupPreviewCharacter()
			if not VP.model or not VP.root then return end
		end

		VP.model:PivotTo(CFrame.new(0, VP.baseY, 0) * CFrame.Angles(0, VP.rot, 0))

		local totalScale = (PanelScale and PanelScale.Scale or 1) * (VP.Scale and VP.Scale.Scale or 1)
		if totalScale < 0.01 then totalScale = 1 end
		local ovW = VP.Overlay.AbsoluteSize.X / totalScale
		local ovH = VP.Overlay.AbsoluteSize.Y / totalScale
		if ovW <= 2 or ovH <= 2 then return end

		local minU, maxU, minV, maxV = 1, 0, 1, 0
		local hasBounds = false
		for _, part in ipairs(VP.bodyParts) do
			if part and part.Parent then
				local cf = part.CFrame
				local pos = cf.Position
				local rx = cf.RightVector * (part.Size.X * 0.5)
				local ry = cf.UpVector * (part.Size.Y * 0.5)
				local rz = cf.LookVector * (part.Size.Z * 0.5)
				for sx = -1, 1, 2 do
					for sy = -1, 1, 2 do
						for sz = -1, 1, 2 do
							local uv, ok = projectToPreview(pos + rx * sx + ry * sy + rz * sz)
							if ok then
								if uv.X < minU then minU = uv.X end
								if uv.X > maxU then maxU = uv.X end
								if uv.Y < minV then minV = uv.Y end
								if uv.Y > maxV then maxV = uv.Y end
								hasBounds = true
							end
						end
					end
				end
			end
		end

		if not hasBounds or maxU <= minU or maxV <= minV then
			VP.BoxFrame.Visible = false
			VP.GlowAura.Visible = false
			VP.TracerLine.Visible = false
			VP.HeadDot.Visible = false
			VP.SonarRing.Visible = false
			VP.DroppedLabel.Visible = false
			VP.ArrowIndicator.Visible = false
			for _, l in ipairs(VP.SkeletonLines) do l.Visible = false end
			for _, d in ipairs(VP.JointDots) do d.Visible = false end
			return
		end

		local floorV = math.clamp(maxV, 0.2, 0.95)
		VP.GroundLine.Position = UDim2.new(0, 0, floorV, 0)

		local bMinU = math.clamp(minU - 0.025, 0.04, 0.90)
		local bMaxU = math.clamp(maxU + 0.025, bMinU + 0.08, 0.96)
		local bMinV = math.clamp(minV - 0.014, 0.06, 0.90)
		local bMaxV = math.clamp(maxV + 0.008, bMinV + 0.10, 0.96)
		local bW = bMaxU - bMinU
		local bH = bMaxV - bMinV
		local centerU = (bMinU + bMaxU) * 0.5

		local curColor = (V and V.ESPColor) or Colors.Accent or Color3.fromRGB(255, 60, 60)
		local f = {
			esp = (V and V.ESP) == true,
			box = (V and V.ESPBox) == true,
			corner = (V and V.ESPCornerBox) == true,
			filled = (V and V.ESPFilled) == true,
			glow = (V and V.ESPGlow) == true,
			health = (V and V.ESPHealth) == true,
			pv = (V and V.ESPPV == true) or (HealthPV_Enabled == true),
			name = (V and V.ESPName) == true,
			dist = (V and V.ESPDist) == true,
			weapon = (V and V.ESPWeapon) == true,
			tracer = (V and V.ESPTracer) == true,
			skeleton = (V and V.ESPSkeleton) == true,
			bfLevel = (V and V.ESPBloxFruitsLevel) == true,
			bfFruit = (V and V.ESPBloxFruitsFruit) == true,
			dropped = (V and V.ESPDropped) == true,
			arrow = (V and V.ArrowESP) == true,
			sonar = (V and V.SoundSonar) == true,
		}

		VP.StatusLabel.Text = f.esp and "ESP ON" or "ESP OFF"
		VP.StatusLabel.TextColor3 = f.esp and Color3.fromRGB(80, 225, 125) or Color3.fromRGB(110, 110, 130)

		local hasBoxEl = f.box or f.corner or f.filled or f.health or f.pv or f.name or f.dist or f.weapon or f.bfLevel or f.bfFruit
		VP.BoxFrame.Visible = hasBoxEl
		if hasBoxEl then
			VP.BoxFrame.Position = UDim2.fromScale(bMinU, bMinV)
			VP.BoxFrame.Size = UDim2.fromScale(bW, bH)

			VP.BoxStroke.Enabled = f.box
			VP.BoxStroke.Color = curColor

			local cLen = math.clamp(math.floor(math.min(bW * ovW, bH * ovH) * 0.24), 8, 22)
			for _, ch in ipairs(VP.CornerH) do ch.Size = UDim2.new(0, cLen, 0, 2) end
			for _, cv in ipairs(VP.CornerV) do cv.Size = UDim2.new(0, 2, 0, cLen) end
			for _, corner in ipairs(VP.AllCorners) do
				corner.Visible = f.corner
				corner.BackgroundColor3 = curColor
			end

			VP.BoxFrame.BackgroundColor3 = curColor
			VP.BoxFrame.BackgroundTransparency = f.filled and 0.74 or 1

			local realHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			local curHp = realHum and math.floor(realHum.Health + 0.5) or 100
			local maxHp = realHum and math.max(realHum.MaxHealth, 1) or 100
			local hpPct = math.clamp(curHp / maxHp, 0, 1)
			local hpColor = Color3.fromRGB(math.floor(255 * (1 - hpPct)), math.floor(255 * hpPct), 65)

			VP.HealthBarBg.Visible = f.health
			if f.health then
				VP.HealthBarFill.Size = UDim2.new(1, 0, hpPct, 0)
				VP.HealthBarFill.Position = UDim2.new(0, 0, 1 - hpPct, 0)
				VP.HealthBarFill.BackgroundColor3 = hpColor
			end

			VP.HealthPvLabel.Visible = f.pv
			if f.pv then
				VP.HealthPvLabel.Text = tostring(curHp) .. " PV"
				VP.HealthPvLabel.TextColor3 = hpColor
				if (bMinU * ovW) >= 56 then
					VP.HealthPvLabel.Position = UDim2.new(0, f.health and -58 or -50, 0, -1)
					VP.HealthPvLabel.TextXAlignment = Enum.TextXAlignment.Right
				else
					VP.HealthPvLabel.Position = UDim2.new(0, f.health and -8 or 0, 1, 4)
					VP.HealthPvLabel.TextXAlignment = Enum.TextXAlignment.Left
				end
			end

			VP.NameLabel.Visible = f.name
			if f.name then
				VP.NameLabel.Text = tostring(LocalPlayer.Name)
				VP.NameLabel.TextColor3 = curColor
				VP.NameLabel.Position = UDim2.new(0.5, 0, 0, -19)
			end

			local topStack = f.name and -34 or -19
			VP.BFLevelLabel.Visible = f.bfLevel
			if f.bfLevel then
				VP.BFLevelLabel.Position = UDim2.new(0.5, 0, 0, topStack)
				topStack = topStack - 15
			end

			VP.BFFruitLabel.Visible = f.bfFruit
			if f.bfFruit then
				VP.BFFruitLabel.Position = UDim2.new(0.5, 0, 0, topStack)
			end

			local distBelow = false
			VP.DistLabel.Visible = f.dist
			if f.dist then
				VP.DistLabel.TextColor3 = curColor
				if ((1 - bMaxU) * ovW) >= 44 then
					VP.DistLabel.AnchorPoint = Vector2.new(0, 0)
					VP.DistLabel.Position = UDim2.new(1, 6, 0, -1)
					VP.DistLabel.TextXAlignment = Enum.TextXAlignment.Left
				else
					distBelow = true
					VP.DistLabel.AnchorPoint = Vector2.new(0.5, 0)
					VP.DistLabel.Position = UDim2.new(0.5, 0, 1, 4)
					VP.DistLabel.TextXAlignment = Enum.TextXAlignment.Center
				end
			end

			VP.WeaponLabel.Visible = f.weapon
			if f.weapon then
				local heldTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				VP.WeaponLabel.Text = heldTool and ("[" .. heldTool.Name .. "]") or "[Knife]"
				VP.WeaponLabel.TextColor3 = curColor
				VP.WeaponLabel.Position = UDim2.new(0.5, 0, 1, distBelow and 20 or 5)
			end
		end

		VP.GlowAura.Visible = f.glow
		if f.glow then
			VP.GlowAura.Position = UDim2.fromScale(bMinU - 0.06, bMinV - 0.05)
			VP.GlowAura.Size = UDim2.fromScale(bW + 0.12, bH + 0.10)
			VP.GlowAura.ImageColor3 = curColor
		end

		if VP.lastGlow ~= f.glow or VP.lastGlowCol ~= curColor then
			VP.lastGlow = f.glow
			VP.lastGlowCol = curColor
			for _, sp in ipairs(VP.glowParts) do
				if sp and sp.Parent then
					sp.Transparency = f.glow and 0 or 1
					sp.Color = curColor
					local sm = sp:FindFirstChildOfClass("SpecialMesh")
					if sm then
						sm.VertexColor = Vector3.new(curColor.R, curColor.G, curColor.B)
					end
				end
			end
		end

		VP.DroppedLabel.Visible = f.dropped
		if f.dropped then
			VP.DroppedLabel.Position = UDim2.new(math.clamp(bMaxU + 0.07, 0.72, 0.88), 0, floorV, -3)
		end

		VP.ArrowIndicator.Visible = f.arrow
		if f.arrow then
			VP.ArrowIndicator.ImageColor3 = curColor
		end

		VP.SonarRing.Visible = f.sonar
		if f.sonar then
			local phase = (tick() % 1.1) / 1.1
			VP.SonarRing.Position = UDim2.fromScale(centerU, floorV)
			VP.SonarRing.Size = UDim2.fromScale(0.12 + phase * 0.62, 0.028 + phase * 0.11)
			VP.SonarRingStroke.Color = curColor
			VP.SonarRingStroke.Transparency = 0.15 + phase * 0.85
		end

		if f.tracer then
			local originMode = (V and V.ESPTracerOrigin) or "Bottom"
			local startUV = Vector2.new(0.5, 1.0)
			if originMode == "Center" then
				startUV = Vector2.new(0.5, 0.5)
			elseif originMode == "Mouse" or originMode == "Top" then
				local mouseOk = false
				pcall(function()
					local guiInset = PreviewGuiService:GetGuiInset()
					local mPos = UserInputService:GetMouseLocation() - guiInset
					local oPos = VP.Overlay.AbsolutePosition
					local oSize = VP.Overlay.AbsoluteSize
					if oSize.X > 1 and oSize.Y > 1 then
						local mu = (mPos.X - oPos.X) / oSize.X
						local mv = (mPos.Y - oPos.Y) / oSize.Y
						if mu >= 0 and mu <= 1 and mv >= 0 and mv <= 1 then
							startUV = Vector2.new(mu, mv)
							mouseOk = true
						end
					end
				end)
				if not mouseOk then
					startUV = Vector2.new(0.5, 0.02)
				end
			end
			update2DLineUV(VP.TracerLine, startUV, Vector2.new(centerU, bMaxV), 1.8, curColor, ovW, ovH)
		else
			VP.TracerLine.Visible = false
		end

		if f.skeleton and VP.model then
			updatePreviewSkeleton(curColor, ovW, ovH)
		else
			VP.HeadDot.Visible = false
			for _, l in ipairs(VP.SkeletonLines) do l.Visible = false end
			for _, d in ipairs(VP.JointDots) do d.Visible = false end
		end
	end)
end
initVisualPreview()
end


minimized = false
panelPos = defaultWindowPos
currentCategory = "Information"
railButtons = {}

function switchCategory(key)
	currentCategory = key
	if SearchBox and SearchBox.Text ~= "" then
		SearchBox.Text = ""
		if ClearSearchBtn then ClearSearchBtn.Visible = false end
		for _, item in ipairs(AllRegisteredCards) do
			if item.card and item.origParent then
				if item.card.Parent ~= item.origParent then
					item.card.Parent = item.origParent
				end
				local restoredOrder = item.origOrder
				if not restoredOrder or restoredOrder <= 0 then
					pcall(function() restoredOrder = item.card:GetAttribute("NebulaOrigOrder") end)
				end
				item.card.LayoutOrder = restoredOrder or 1
				item.card.Visible = true
			end
		end
		if SearchPanel then SearchPanel.Visible = false end
	end
	for name, p in pairs(panels) do
		if name == key then
			p.Visible = true
			p.Position = UDim2.new(0, 24, 0, 12)
			CreateTween(p, {Position = UDim2.new(0, 12, 0, 12)}, 0.25, Enum.EasingStyle.Quart)
			if key == "Joueur" and _G.refreshPlayerList then
				pcall(_G.refreshPlayerList)
			end
		else
			p.Visible = false
		end
	end
	for _, cat in ipairs(categories) do
		local data = railButtons[cat.key]
		if data then
			local isActive = (cat.key == key)
			local btn = data.btn
			local icon = btn:FindFirstChildOfClass("ImageLabel")
			if isActive then
				CreateTween(btn, {BackgroundColor3 = Colors.AccentDark, BackgroundTransparency = 0}, 0.2)
				if icon then CreateTween(icon, {ImageColor3 = Colors.Accent, ImageTransparency = 0}, 0.2) end
			else
				CreateTween(btn, {BackgroundTransparency = 1}, 0.2)
				if icon then CreateTween(icon, {ImageColor3 = Colors.Text, ImageTransparency = 0.15}, 0.2) end
			end
		end
	end
	PanelTitle.Text = key
	if key == "ESP" then
		setVisualPreviewVisible(true)
	else
		setVisualPreviewVisible(false)
	end
end

function createCategoryButton(cat, index, parentContainer)
	local btn = Instance.new("ImageButton")
	btn.Name = cat.key
	btn.Size = UDim2.new(0, 44, 0, 44)
	btn.BackgroundColor3 = (cat.key == currentCategory) and Colors.AccentDark or Colors.Background
	btn.BackgroundTransparency = (cat.key == currentCategory) and 0 or 1
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.LayoutOrder = index
	btn.ZIndex = 8
	btn.Parent = parentContainer

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btn

	local btnScale = Instance.new("UIScale")
	btnScale.Scale = 1
	btnScale.Parent = btn

	local iconId = CategoryIcons[cat.key] or "rbxassetid://7733964719"
	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 22, 0, 22)
	icon.Position = UDim2.new(0.5, -11, 0.5, -11)
	icon.BackgroundTransparency = 1
	icon.Image = iconId
	icon.ImageColor3 = (cat.key == currentCategory) and Colors.Accent or Colors.Text
	icon.ImageTransparency = (cat.key == currentCategory) and 0 or 0.15
	icon.ZIndex = 9
	icon.Parent = btn

	btn.MouseEnter:Connect(function()
		if cat.key ~= currentCategory then
			CreateTween(btnScale, {Scale = 1.06}, 0.15)
			CreateTween(btn, {BackgroundTransparency = 0.7, BackgroundColor3 = Colors.Card}, 0.15)
			CreateTween(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), ImageTransparency = 0}, 0.15)
		end
	end)
	btn.MouseLeave:Connect(function()
		if cat.key ~= currentCategory then
			CreateTween(btnScale, {Scale = 1}, 0.15)
			CreateTween(btn, {BackgroundTransparency = 1}, 0.15)
			CreateTween(icon, {ImageColor3 = Colors.Text, ImageTransparency = 0.15}, 0.15)
		end
	end)
	btn.MouseButton1Click:Connect(function()
		playClick()
		CreateTween(btnScale, {Scale = 0.88}, 0.1)
		task.delay(0.1, function() CreateTween(btnScale, {Scale = 1}, 0.2, Enum.EasingStyle.Back) end)
		switchCategory(cat.key)
	end)

	railButtons[cat.key] = { btn = btn, index = index }
	return btn
end

for index, cat in ipairs(categories) do
	createCategoryButton(cat, index, NavScroll)
	createPanel(cat.key)
end

ContentFrames = {}
for _, cat in ipairs(categories) do
	ContentFrames[cat.key] = panels[cat.key]
end

activeNSlider = nil

function createToggle(name, default, callback, parent, configKey)
	local card = createCard(parent, 0, 46)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -75, 1, 0)
	title.Position = UDim2.new(0, 14, 0, 0)
	title.BackgroundTransparency = 1
	title.RichText = true
	title.Text = name
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 9
	title.Parent = card

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 22, 0, 22)
	btn.Position = UDim2.new(1, -36, 0.5, -11)
	btn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.ZIndex = 10
	btn.Parent = card

	local btnScale = Instance.new("UIScale")
	btnScale.Scale = 1
	btnScale.Parent = btn

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 6)
	bCorner.Parent = btn

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = Colors.Border
	bStroke.Thickness = 1
	bStroke.Parent = btn

	local enabled = default or false
	if configKey then
		if V[configKey] ~= nil then
			enabled = (V[configKey] == true)
		else
			V[configKey] = enabled
		end
	end

	local function updateBoxVisual(val)
		if val then
			CreateTween(btn, {BackgroundColor3 = Colors.Accent}, 0.2)
			CreateTween(bStroke, {Color = Colors.AccentLight}, 0.2)
			CreateTween(title, {TextColor3 = Colors.Text}, 0.2)
		else
			CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}, 0.2)
			CreateTween(bStroke, {Color = Colors.Border}, 0.2)
			CreateTween(title, {TextColor3 = Colors.TextDim}, 0.2)
		end
	end

	updateBoxVisual(enabled)

	local function setToggleState(value)
		enabled = (value == true)
		if configKey then V[configKey] = enabled end
		updateBoxVisual(enabled)
		local ok, err = pcall(callback, enabled)
		if _G.reportOptionResult then
			_G.reportOptionResult(name, ok, err)
		end
	end

	local function toggleState()
		CreateTween(btnScale, {Scale = 0.78}, 0.08)
		task.delay(0.08, function()
			CreateTween(btnScale, {Scale = 1.12}, 0.12, Enum.EasingStyle.Back)
			task.delay(0.12, function() CreateTween(btnScale, {Scale = 1.0}, 0.1) end)
		end)
		setToggleState(not enabled)
	end

	btn.MouseButton1Click:Connect(function()
		pcall(function() GuiService.SelectedObject = nil end)
		playClick()
		toggleState()
	end)

	if configKey then
		ConfigRegistry[configKey] = setToggleState
	end

	registerSearchCard(card, name, parent)
	return card, setToggleState, toggleState
end

function createSlider(name, min, max, default, callback, parent, configKey)
	local card = createCard(parent, 0, 52)

	if configKey then
		if V[configKey] ~= nil and type(V[configKey]) == "number" then
			default = math.clamp(V[configKey], min, max)
		else
			V[configKey] = default
		end
	end
	default = math.clamp(default, min, max)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.6, -10, 0, 18)
	title.Position = UDim2.new(0, 14, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 8
	title.Parent = card

	local valBox = Instance.new("Frame")
	valBox.Size = UDim2.new(0, 48, 0, 20)
	valBox.Position = UDim2.new(1, -62, 0, 6)
	valBox.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	valBox.BorderSizePixel = 0
	valBox.ZIndex = 8
	valBox.Parent = card

	local valCorner = Instance.new("UICorner")
	valCorner.CornerRadius = UDim.new(0, 5)
	valCorner.Parent = valBox

	local valStroke = Instance.new("UIStroke")
	valStroke.Color = Colors.Border
	valStroke.Thickness = 1
	valStroke.Parent = valBox

	local valLbl = Instance.new("TextLabel")
	valLbl.Size = UDim2.new(1, 0, 1, 0)
	valLbl.BackgroundTransparency = 1
	valLbl.Text = tostring(default)
	valLbl.TextColor3 = Colors.Text
	valLbl.Font = Enum.Font.GothamBold
	valLbl.TextSize = 10
	valLbl.ZIndex = 9
	valLbl.Parent = valBox

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -28, 0, 4)
	track.Position = UDim2.new(0, 14, 0, 36)
	track.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
	track.BorderSizePixel = 0
	track.ZIndex = 8
	track.Parent = card

	local trkCorner = Instance.new("UICorner")
	trkCorner.CornerRadius = UDim.new(1, 0)
	trkCorner.Parent = track

	local initPct = math.clamp((default - min) / (max - min), 0, 1)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(initPct, 0, 1, 0)
	fill.BackgroundColor3 = Colors.Accent
	fill.BorderSizePixel = 0
	fill.ZIndex = 9
	fill.Parent = track

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local thumb = Instance.new("Frame")
	thumb.Size = UDim2.new(0, 12, 0, 12)
	thumb.Position = UDim2.new(1, -6, 0.5, -6)
	thumb.BackgroundColor3 = Colors.Accent
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 10
	thumb.Parent = fill

	local thumbScale = Instance.new("UIScale")
	thumbScale.Scale = 1
	thumbScale.Parent = thumb

	local thumbCorner = Instance.new("UICorner")
	thumbCorner.CornerRadius = UDim.new(1, 0)
	thumbCorner.Parent = thumb

	local thumbGlow = Instance.new("UIStroke")
	thumbGlow.Color = Colors.AccentDark
	thumbGlow.Thickness = 2
	thumbGlow.Parent = thumb

	local function updateFromX(x)
		local trackPos = track.AbsolutePosition.X
		local trackWidth = track.AbsoluteSize.X
		if trackWidth <= 0 then return end
		local pct = math.clamp((x - trackPos) / trackWidth, 0, 1)
		local value = math.floor(min + pct * (max - min))
		valLbl.Text = tostring(value)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		if configKey then V[configKey] = value end
		pcall(callback, value)
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			activeNSlider = updateFromX
			CreateTween(thumbScale, {Scale = 1.3}, 0.15, Enum.EasingStyle.Back)
			CreateTween(valStroke, {Color = Colors.Accent}, 0.2)
			updateFromX(input.Position.X)
		end
	end)

	registerSearchCard(card, name, parent)

	local function setSliderValue(val)
		local clamped = math.clamp(val, min, max)
		local pct = math.clamp((clamped - min) / (max - min), 0, 1)
		valLbl.Text = tostring(clamped)
		fill.Size = UDim2.new(pct, 0, 1, 0)
		if configKey then V[configKey] = clamped end
		pcall(callback, clamped)
	end

	if configKey then
		ConfigRegistry[configKey] = setSliderValue
	end

	return card, updateFromX, setSliderValue
end

function createButton(name, callback, parent, customBtnText, isDanger)
	local card = createCard(parent, 0, 44)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -90, 1, 0)
	title.Position = UDim2.new(0, 14, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = Colors.Text
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 12
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 8
	title.Parent = card

	local isUnload = isDanger or (string.find(string.lower(name), "unload") ~= nil) or (customBtnText and string.lower(customBtnText) == "unload")
	local btnLabel = customBtnText or (isUnload and "Unload" or "Lancer")

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 72, 0, 26)
	btn.Position = UDim2.new(1, -84, 0.5, -13)
	btn.BackgroundColor3 = isUnload and Color3.fromRGB(42, 18, 22) or Color3.fromRGB(24, 24, 28)
	btn.BorderSizePixel = 0
	btn.Text = btnLabel
	btn.TextColor3 = isUnload and Color3.fromRGB(255, 75, 75) or Colors.Text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.AutoButtonColor = false
	btn.ZIndex = 9
	btn.Parent = card

	local btnScale = Instance.new("UIScale")
	btnScale.Scale = 1
	btnScale.Parent = btn

	local bCorner = Instance.new("UICorner")
	bCorner.CornerRadius = UDim.new(0, 7)
	bCorner.Parent = btn

	local bStroke = Instance.new("UIStroke")
	bStroke.Color = isUnload and Color3.fromRGB(150, 35, 45) or Colors.Border
	bStroke.Thickness = 1
	bStroke.Parent = btn

	btn.MouseEnter:Connect(function()
		CreateTween(btnScale, {Scale = 1.04}, 0.15)
		if isUnload then
			CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(215, 45, 55), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
		else
			CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}, 0.15)
			CreateTween(bStroke, {Color = Colors.BorderActive}, 0.15)
		end
	end)
	btn.MouseLeave:Connect(function()
		CreateTween(btnScale, {Scale = 1}, 0.15)
		if isUnload then
			CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(42, 18, 22), TextColor3 = Color3.fromRGB(255, 75, 75)}, 0.15)
		else
			CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(24, 24, 28)}, 0.15)
			CreateTween(bStroke, {Color = Colors.Border}, 0.15)
		end
	end)
	btn.MouseButton1Down:Connect(function()
		CreateTween(btnScale, {Scale = 0.94}, 0.1)
		CreateTween(btn, {BackgroundColor3 = Colors.AccentDark}, 0.1)
	end)
	btn.MouseButton1Up:Connect(function()
		CreateTween(btnScale, {Scale = 1.04}, 0.15, Enum.EasingStyle.Back)
		CreateTween(btn, {BackgroundColor3 = Color3.fromRGB(32, 32, 40)}, 0.15)
		pcall(function() GuiService.SelectedObject = nil end)
		playClick()
		if callback then
			local ok, err = pcall(callback)
			if _G.reportOptionResult then
				_G.reportOptionResult(name, ok, err)
			end
		end
	end)

	registerSearchCard(card, name, parent)
	return card, btn
end

function createLabel(text, parent)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, 0, 0, 22)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Colors.TextMuted
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 10
	Label.TextXAlignment = Enum.TextXAlignment.Left
	local assignedOrder = getNextLayoutOrder(parent)
	Label.LayoutOrder = assignedOrder
	pcall(function() Label:SetAttribute("NebulaOrigOrder", assignedOrder) end)
	Label.ZIndex = 8
	Label.Parent = parent
	return Label
end

nSliderMoveConn = UserInputService.InputChanged:Connect(function(input)
	if activeNSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		activeNSlider(input.Position.X)
	end
end)
nSliderEndConn = UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		activeNSlider = nil
	end
end)

menuOpen = true
isTogglingMenu = false

function toggleMenu(forceState)
	if isTogglingMenu then return end
	isTogglingMenu = true
	task.delay(0.25, function() isTogglingMenu = false end)

	if forceState ~= nil then
		menuOpen = forceState
	else
		menuOpen = not menuOpen
	end

	if menuOpen then
		Panel.Visible = true
		if currentCategory == "ESP" then
			setVisualPreviewVisible(true)
		end
		if BubblesContainer and V and V.BubblesEnabled then
			BubblesContainer.Visible = true
		end
		if BackgroundDimmer then
			if V and (V.DimmerEnabled ~= false) then
				BackgroundDimmer.Visible = true
				local targetTrans = 1 - ((V and V.DimmerOpacity or 80) / 100)
				CreateTween(BackgroundDimmer, {BackgroundTransparency = targetTrans}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			else
				BackgroundDimmer.Visible = false
				BackgroundDimmer.BackgroundTransparency = 1
			end
		end
		PanelScale.Scale = 0.72
		Panel.Position = UDim2.new(
			savedWindowPos.X.Scale,
			savedWindowPos.X.Offset,
			savedWindowPos.Y.Scale,
			savedWindowPos.Y.Offset + 45
		)
		CreateTween(PanelScale, {Scale = 1}, 0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		CreateTween(Panel, {Position = savedWindowPos}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	else
		setVisualPreviewVisible(false)
		if BackgroundDimmer then
			local tweenDim = CreateTween(BackgroundDimmer, {BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			tweenDim.Completed:Connect(function()
				if not menuOpen and BackgroundDimmer then
					BackgroundDimmer.Visible = false
					BackgroundDimmer.BackgroundTransparency = 1
				end
			end)
		end
		CreateTween(PanelScale, {Scale = 0.75}, 0.24, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		local tweenPos = CreateTween(Panel, {
			Position = UDim2.new(
				savedWindowPos.X.Scale,
				savedWindowPos.X.Offset,
				savedWindowPos.Y.Scale,
				savedWindowPos.Y.Offset + 40
			)
		}, 0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		tweenPos.Completed:Connect(function()
			if not menuOpen then
				Panel.Visible = false
				if BubblesContainer then
					BubblesContainer.Visible = false
				end
				if BackgroundDimmer then
					BackgroundDimmer.Visible = false
					BackgroundDimmer.BackgroundTransparency = 1
				end
			end
		end)
	end
end
_G.togglePearlMenu = toggleMenu

dragging = false
dragInput, dragStart, startPos = nil, nil, nil

function updateDrag(input)
	local delta = input.Position - dragStart
	savedWindowPos = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
	Panel.Position = savedWindowPos
end

function enableDrag(frame)
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

enableDrag(TopBar)
enableDrag(Sidebar)

dragConn = UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

bubbleRenderConn = RunService.RenderStepped:Connect(function(dt)
	if BubblesContainer and BubblesContainer.Visible then
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

function performFullUnload()
    pcall(function() RunService:UnbindFromRenderStep("PearlAimlock") end)
    pcall(function() RunService:UnbindFromRenderStep("PearlAimlockUpdate") end)
    pcall(function() RunService:UnbindFromRenderStep("PearlFreecam") end)
    local pg = getSafeGuiParent()
    if pg then
        local ci = pg:FindFirstChild("PearlConfigInspector")
        if ci then pcall(function() ci:Destroy() end) end
    end

    if espPreviewConn then espPreviewConn:Disconnect(); espPreviewConn = nil end
    _G.Aimlock_Enabled = false
    _G.Aimlock_IsHeld = false
    _G.Aimlock_ShowFOV = false
    if _G.PearlAimlockConn then pcall(function() _G.PearlAimlockConn:Disconnect() _G.PearlAimlockConn = nil end) end
    if _G.PearlAimlockInputBeganConn then pcall(function() _G.PearlAimlockInputBeganConn:Disconnect() _G.PearlAimlockInputBeganConn = nil end) end
    if _G.PearlAimlockInputEndedConn then pcall(function() _G.PearlAimlockInputEndedConn:Disconnect() _G.PearlAimlockInputEndedConn = nil end) end
    if SilentAimCircle then
        pcall(function()
            SilentAimCircle.Visible = false
            if SilentAimCircle.Remove then SilentAimCircle:Remove()
            elseif SilentAimCircle.Destroy then SilentAimCircle:Destroy() end
            SilentAimCircle = nil
        end)
    end

    pcall(function()
        if V then
            if V.Fly and stopFly then pcall(stopFly) end
            if V.DesyncFly and stopDesyncFly then pcall(stopDesyncFly) end
            if V.Noclip and stopNoclip then pcall(stopNoclip) end
            if V.Invis and toggleInvisibility then pcall(function() toggleInvisibility(false) end) end
            if V.NoAnim and disableNoAnim then pcall(disableNoAnim) end
            if V.Flinging and stopFling then pcall(stopFling) end
            if stopSpectate then pcall(stopSpectate) end
            if _G.stopSpectate then pcall(_G.stopSpectate) end
            if _G.destroySpectatorWindow then pcall(_G.destroySpectatorWindow) end
            if V then V.SpectatorList = false end
            if V.InfRange and toggleInfiniteRange then pcall(function() toggleInfiniteRange(false) end) end
            if V.FPSBoost and toggleFPSBooster then pcall(function() toggleFPSBooster(false) end) end
            if V.Fullbright and toggleFullbright then pcall(function() toggleFullbright(false) end) end
            if V.ClickTP and toggleClickTP then pcall(function() toggleClickTP(false) end) end
            if V.Godmode and toggleGodmode then pcall(function() toggleGodmode(false) end) end
            if V.Ghost and toggleGhost then pcall(function() toggleGhost(false) end) end
            if V.Freecam and SetFreecamToggle then pcall(function() SetFreecamToggle(false) end) end
            V.Fly = false
            V.DesyncFly = false
            V.Noclip = false
            V.Invis = false
            V.NoAnim = false
            V.Flinging = false
            V.Spectate = false
            V.InfRange = false
            V.FPSBoost = false
            V.Fullbright = false
            V.ClickTP = false
            V.Godmode = false
            V.Ghost = false
            V.Freecam = false
            V.Force3rd = false
            V.HitboxExtender = false
            V.AutoBhop = false
            V.InfiniteStamina = false
            V.AntiVoid = false
            V.AntiRagdoll = false
V.AirWalk = false
V.KillAll = false
            V.AntiFling = false
            V.SpeedEnabled = false
            V.JumpEnabled = false
            V.CFrameSpeed = false
            V.VehicleFly = false
            V.VehicleNoclip = false
            if toggleMovementRecording and isMovementRecording then pcall(toggleMovementRecording) end
            if toggleMovementReplaying and isMovementReplaying then pcall(function() toggleMovementReplaying(false) end) end
        end
    end)

    pcall(function()
        if godmodeCharConn then godmodeCharConn:Disconnect(); godmodeCharConn = nil end
        if godmodeHealthConn then godmodeHealthConn:Disconnect(); godmodeHealthConn = nil end
        if godmodeStateConn then godmodeStateConn:Disconnect(); godmodeStateConn = nil end
        if V and V.GodmodeConn then V.GodmodeConn:Disconnect(); V.GodmodeConn = nil end
        if V and V.GhostConn then V.GhostConn:Disconnect(); V.GhostConn = nil end
        if V and V.SuperJumpConn then V.SuperJumpConn:Disconnect(); V.SuperJumpConn = nil end
        if V and V.OffScreenConn then V.OffScreenConn:Disconnect(); V.OffScreenConn = nil end
        if V and V.SitAirConn then V.SitAirConn:Disconnect(); V.SitAirConn = nil end
        if V and V.GrappleTool then
            if V.GrappleTool.Parent == LocalPlayer.Character or V.GrappleTool.Parent == LocalPlayer.Backpack then
                V.GrappleTool:Destroy()
            end
            V.GrappleTool = nil
        end
        if cleanupOffScreenArrows then cleanupOffScreenArrows() end
        if V and V.Force3rdConn then V.Force3rdConn:Disconnect(); V.Force3rdConn = nil end
        if V and V.FlyNoclipConn then V.FlyNoclipConn:Disconnect(); V.FlyNoclipConn = nil end
        if V and V.DesyncFlyNoclipConn then V.DesyncFlyNoclipConn:Disconnect(); V.DesyncFlyNoclipConn = nil end
        if V and V.FreecamConn then V.FreecamConn:Disconnect(); V.FreecamConn = nil end
        if V and V.FreecamInputConn then V.FreecamInputConn:Disconnect(); V.FreecamInputConn = nil end
        if V and V.FreecamMenuConn then V.FreecamMenuConn:Disconnect(); V.FreecamMenuConn = nil end
        if V and V.FreecamTeleportConn then V.FreecamTeleportConn:Disconnect(); V.FreecamTeleportConn = nil end
        if V and V.FreecamTeleportConnEnd then V.FreecamTeleportConnEnd:Disconnect(); V.FreecamTeleportConnEnd = nil end
        if V and V.InvisConn then V.InvisConn:Disconnect(); V.InvisConn = nil end
        if _G.cleanupCloneInvis then pcall(_G.cleanupCloneInvis) end
        if _G.cleanupGhostDesync then pcall(_G.cleanupGhostDesync) end
        if _G.cleanupPearlSkyDome then pcall(_G.cleanupPearlSkyDome) end
        if V then V.GhostDesync = false end
        if V and V.NoAnimConn then V.NoAnimConn:Disconnect(); V.NoAnimConn = nil end
        if V and V.SpecConn then V.SpecConn:Disconnect(); V.SpecConn = nil end
        if V and V.FlingConn then V.FlingConn:Disconnect(); V.FlingConn = nil end
        if V and V.AntiRagdollConn then V.AntiRagdollConn:Disconnect(); V.AntiRagdollConn = nil end
        if V and V.AntiFlingConn then V.AntiFlingConn:Disconnect(); V.AntiFlingConn = nil end
        if V and V.AntiVoidConn then V.AntiVoidConn:Disconnect(); V.AntiVoidConn = nil end
        if setupInfiniteStamina then pcall(function() setupInfiniteStamina(false) end) end
        if V and V.InfiniteStaminaConn then V.InfiniteStaminaConn:Disconnect(); V.InfiniteStaminaConn = nil end
        if disconnectRobloxChat then pcall(disconnectRobloxChat) end
        if V and V.HitboxConn then V.HitboxConn:Disconnect(); V.HitboxConn = nil end
        if V and V.BhopConn then V.BhopConn:Disconnect(); V.BhopConn = nil end
        if V and V.AttachConn then V.AttachConn:Disconnect(); V.AttachConn = nil end
        if V and V.SpinConn then V.SpinConn:Disconnect(); V.SpinConn = nil end
        if V and V.InfRangeConn then V.InfRangeConn:Disconnect(); V.InfRangeConn = nil end
        if V and V.FPSConn then V.FPSConn:Disconnect(); V.FPSConn = nil end
        if V and V.AutoRejoinConn then V.AutoRejoinConn:Disconnect(); V.AutoRejoinConn = nil end
                if V and V.UnifiedInputConn then V.UnifiedInputConn:Disconnect(); V.UnifiedInputConn = nil end
        if V and V.InspectorClickConn then V.InspectorClickConn:Disconnect(); V.InspectorClickConn = nil end
        if V and V.VehicleBoostHoldConn then V.VehicleBoostHoldConn:Disconnect(); V.VehicleBoostHoldConn = nil end
        if V and V.VehicleBoostEndConn then V.VehicleBoostEndConn:Disconnect(); V.VehicleBoostEndConn = nil end
        if movementConn then movementConn:Disconnect(); movementConn = nil end
        if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
        if bubbleRenderConn then bubbleRenderConn:Disconnect(); bubbleRenderConn = nil end
        if dragConn then dragConn:Disconnect(); dragConn = nil end
        if resizeChangedConn then resizeChangedConn:Disconnect(); resizeChangedConn = nil end
        if resizeEndedConn then resizeEndedConn:Disconnect(); resizeEndedConn = nil end
        if nSliderMoveConn then nSliderMoveConn:Disconnect(); nSliderMoveConn = nil end
        if nSliderEndConn then nSliderEndConn:Disconnect(); nSliderEndConn = nil end

        pcall(function() RunService:UnbindFromRenderStep("PearlAimlockUpdate") end)
        if _G.PearlAimlockConn then _G.PearlAimlockConn:Disconnect(); _G.PearlAimlockConn = nil end
        if _G.PearlAimlockInputBeganConn then _G.PearlAimlockInputBeganConn:Disconnect(); _G.PearlAimlockInputBeganConn = nil end
        if _G.PearlAimlockInputEndedConn then _G.PearlAimlockInputEndedConn:Disconnect(); _G.PearlAimlockInputEndedConn = nil end
        _G.Aimlock_Enabled = false
        _G.Aimlock_IsHeld = false
        if SilentAimCircle then
            pcall(function()
                SilentAimCircle.Visible = false
                SilentAimCircle:Remove()
            end)
            SilentAimCircle = nil
        end
        if V then
            V.Radar2D = false
            V.ArrowESP = false
            V.DangerWarning = false
        end
        if ArrowGui then pcall(function() ArrowGui:Destroy() end) end
        if cleanupArrowESP then pcall(cleanupArrowESP) end
        if _G.cleanupArrowESP then pcall(_G.cleanupArrowESP) end
        if cleanupRadar2D then pcall(cleanupRadar2D) end
        if _G.cleanupRadar2D then pcall(_G.cleanupRadar2D) end
        if toggleDangerWarning then pcall(function() toggleDangerWarning(false) end) end
        if cleanupSoundSonar then pcall(cleanupSoundSonar) end
        if _G.cleanupSoundSonar then pcall(_G.cleanupSoundSonar) end

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
        if V then V.ESP = false end
        if clearESP then clearESP() end
        if ClearESP then ClearESP() end
        if ESPGui then ESPGui:Destroy() end
        if VehicleESPGui then pcall(function() VehicleESPGui:Destroy() end) end
    end)

    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = false
                end
                for _, desc in pairs(p.Character:GetDescendants()) do
                    if desc:IsA("Highlight") or desc:IsA("SelectionBox") or desc:IsA("BoxHandleAdornment") then
                        desc:Destroy()
                    end
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
                local normalSpeed = _OrigWalkSpeed or (getBaseWalkSpeed and getBaseWalkSpeed(hum)) or 16
                hum.WalkSpeed = normalSpeed
                local normalJump = (_OrigJumpPower and _OrigJumpPower >= 50) and _OrigJumpPower or 50
                hum.JumpPower = normalJump
                if _OrigJumpHeight and _OrigJumpHeight > 0 then hum.JumpHeight = _OrigJumpHeight end
                if _OrigUseJumpPower ~= nil then hum.UseJumpPower = _OrigUseJumpPower end
                hum.RequiresNeck = true
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
                for _, obj in pairs(hrp:GetChildren()) do
                    if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("LinearVelocity") or obj:IsA("VectorForce") or obj:IsA("BodyAngularVelocity") then
                        obj:Destroy()
                    end
                end
            end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                    if part.Name == "HumanoidRootPart" then
                        part.Transparency = 1
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    pcall(function()
        workspace.Gravity = 196.2
        local cam = workspace.CurrentCamera or Camera
        if cam then
            cam.FieldOfView = 70
            cam.CameraType = Enum.CameraType.Custom
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = 128
        LocalPlayer.CameraMinZoomDistance = 0.5
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        pcall(function() GuiService.SelectedObject = nil end)
    end)

    pcall(function()
        if _OrigLighting then
            Lighting.GlobalShadows = _OrigLighting.GlobalShadows
            Lighting.Brightness = _OrigLighting.Brightness
            Lighting.Ambient = _OrigLighting.Ambient
            Lighting.OutdoorAmbient = _OrigLighting.OutdoorAmbient
            Lighting.FogEnd = _OrigLighting.FogEnd
            Lighting.FogStart = _OrigLighting.FogStart
            Lighting.ClockTime = _OrigLighting.ClockTime
            Lighting.ExposureCompensation = _OrigLighting.ExposureCompensation
        end
    end)

    pcall(function()
        if ScreenGui then ScreenGui:Destroy() end
    end)
    pcall(function()
        local searchRoots = {
            parentTarget,
            CoreGui,
            LocalPlayer and (LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChild("PlayerGui"))
        }
        for _, root in ipairs(searchRoots) do
            if root then
                pcall(function()
                    for _, child in ipairs(root:GetChildren()) do
                        if child:IsA("ScreenGui") and (
                            child.Name == "PearlTacticalRadar" or
                            child.Name == "PearlDangerWarning" or
                            child.Name == "PearlArrowGui" or
                            child.Name == "PearlSpectatorListGui" or
                            child.Name:find("Spectator") or
                            child.Name:find("Radar") or
                            child.Name == "PearlUpdateUI" or
                            child.Name == "PearlKeySystemUI" or
                            child.Name == "EternalFlick_GUI" or
                            child.Name == "PearlFreecamMenu" or
                            child.Name == "PearlFreecamCrosshair" or
                            child.Name == "PearlPlayerInspector" or
                            child.Name == "PearlESP" or
                            child.Name == "PearlTPMiniGui"
                        ) then
                            child:Destroy()
                        end
                    end
                end)
            end
        end
    end)

    getgenv().BloxFruitsUILoaded = false
    _G.PearlLoaded = false
    _G.togglePearlMenu = nil
end
unloadMenu = performFullUnload
unloadPearl = performFullUnload

KEY_WEBHOOK_URL = "https://ptb.discord.com/api/webhooks/1553768728989278282/3dRonVtLZEYhkBmKGHzwlo7NAuEIo6jj2IkTf17Y3sy9y0UhoS99g0amkyxJJf8CRdiR"
LOAD_WEBHOOK_URL = "https://ptb.discord.com/api/webhooks/1535102102127517736/Cl_odQafhIPoqbObhLadq-d9kxOu83PM_hIAfx6QoZDbeo7Y_vGoJgtZPfV8v2OOij6N"
KEY_FILE = "Pearl_v2_" .. tostring(LocalPlayer.UserId) .. ".key"
VERIFIED_KEY_FILE = "Pearl_v2_verified_" .. tostring(LocalPlayer.UserId) .. ".key"
isKeyVerified = false
savedKeyOnDisk = nil
currentSessionToken = nil
activeValidationKey = nil
lastSentKey = nil
isSendingWebhook = false
lastKeyGenTimestamp = 0
KEY_COOLDOWN_SECONDS = 300

WHITELISTED_USERS = {
    ["gims_93bandit"] = true,
    ["myhackv2"] = true,
    ["nuza1010"] = true
}

function isPlayerWhitelisted()
    local uid = tostring(LocalPlayer.UserId)
    local uName = string.lower(tostring(LocalPlayer.Name))
    for entry, _ in pairs(WHITELISTED_USERS) do
        local clean = string.lower(tostring(entry)):gsub("^@", ""):gsub("%s+", "")
        if clean == uid or clean == uName then
            return true
        end
    end
    return false
end

function httpRelay(url, method, bodyStr)
    method = method or "GET"
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        local ok, res = pcall(function()
            return req({
                Url = url,
                Method = method,
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Accept"] = "application/json"
                },
                Body = bodyStr
            })
        end)
        if ok and res then
            if type(res) == "table" then
                return res.Body or res.body or ""
            elseif type(res) == "string" then
                return res
            end
        end
    end
    if method == "GET" and game and game.HttpGet then
        local ok, body = pcall(function() return game:HttpGet(url) end)
        if ok and body then return body end
    end
    return nil
end

local function GenerateRandomAESKey()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local function randChunk(len)
        local res = ""
        for _ = 1, len do
            local idx = math.random(1, #charset)
            res = res .. string.sub(charset, idx, idx)
        end
        return res
    end

    if crypt and crypt.generatekey then
        local rawKey = ""
        pcall(function()
            rawKey = crypt.generatekey()
        end)
        if rawKey and rawKey ~= "" then
            local hex = ""
            for i = 1, math.min(#rawKey, 16) do
                hex = hex .. string.format("%02X", string.byte(rawKey, i))
            end
            return "Pearl-AES256-" .. string.sub(hex, 1, 8) .. "-" .. string.sub(hex, 9, 16) .. "-" .. string.sub(hex, 17, 24)
        end
    end

    math.randomseed(os.time() + LocalPlayer.UserId + math.random(100000, 999999))
    return "Pearl-AES256-" .. randChunk(8) .. "-" .. randChunk(8) .. "-" .. randChunk(8)
end

function sendKeyWebhook(keyToSend)
    if isSendingWebhook then return end
    if lastSentKey == keyToSend then return end
    isSendingWebhook = true
    lastSentKey = keyToSend

    task.spawn(function()
        pcall(function()
            local headUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=150&height=150&format=png"
            pcall(function()
                local headApi = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(LocalPlayer.UserId) .. "&size=150x150&format=Png&isCircular=false"
                local res = httpRelay(headApi, "GET")
                if res and #res > 0 then
                    local data = HttpService:JSONDecode(res)
                    if data and data.data and data.data[1] and data.data[1].imageUrl then
                        headUrl = data.data[1].imageUrl
                    end
                end
            end)

            local embed = {
                ["title"] = "🪐 Pearl Hub • Nouvelle Clé AES-256 Reçue",
                ["description"] = "Une clé aléatoire unique a été générée pour ce compte.",
                ["color"] = 0x8A2BE2,
                ["thumbnail"] = { ["url"] = headUrl },
                ["fields"] = {
                    {
                        ["name"] = "👤 Pseudo Roblox",
                        ["value"] = "```" .. LocalPlayer.Name .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🆔 UserId",
                        ["value"] = "```" .. tostring(LocalPlayer.UserId) .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🔑 Clé AES-256 (Privée)",
                        ["value"] = "```" .. tostring(keyToSend) .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🎮 Jeu ID",
                        ["value"] = "```" .. tostring(game.PlaceId) .. "```",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🔒 Statut",
                        ["value"] = "```Clé verrouillée au compte```",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "Pearl Security System | AES256 Linked",
                    ["icon_url"] = headUrl
                },
                ["timestamp"] = DateTime.now():ToIsoDate()
            }

            local payload = {
                ["username"] = "Pearl License Manager",
                ["avatar_url"] = headUrl,
                ["embeds"] = { embed }
            }
            httpRelay(KEY_WEBHOOK_URL, "POST", HttpService:JSONEncode(payload))
        end)
        task.delay(3, function() isSendingWebhook = false end)
    end)
end

local hasSentLoadWebhook = false
function sendCheatLoadedWebhook()
    if hasSentLoadWebhook then return end
    hasSentLoadWebhook = true

    task.spawn(function()
        pcall(function()
            local headUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=150&height=150&format=png"
            local gameThumbUrl = nil
            local gameName = "Roblox Game"

            pcall(function()
                local mps = game:GetService("MarketplaceService")
                local pInfo = mps:GetProductInfo(game.PlaceId)
                if pInfo and pInfo.Name then
                    gameName = pInfo.Name
                end
            end)

            pcall(function()
                local headApi = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(LocalPlayer.UserId) .. "&size=150x150&format=Png&isCircular=false"
                local res = httpRelay(headApi, "GET")
                if res and #res > 0 then
                    local data = HttpService:JSONDecode(res)
                    if data and data.data and data.data[1] and data.data[1].imageUrl then
                        headUrl = data.data[1].imageUrl
                    end
                end
            end)

            pcall(function()
                if game.PlaceId and game.PlaceId > 0 then
                    local univApi = "https://apis.roblox.com/universes/v1/places/" .. tostring(game.PlaceId) .. "/universe"
                    local uRes = httpRelay(univApi, "GET")
                    if uRes and #uRes > 0 then
                        local uData = HttpService:JSONDecode(uRes)
                        if uData and uData.universeId then
                            local thumbApi = "https://thumbnails.roblox.com/v1/games/multiget/thumbnails?universeIds=" .. tostring(uData.universeId) .. "&size=768x432&format=Png&isCircular=false"
                            local tRes = httpRelay(thumbApi, "GET")
                            if tRes and #tRes > 0 then
                                local tData = HttpService:JSONDecode(tRes)
                                if tData and tData.data and tData.data[1] and tData.data[1].thumbnails and tData.data[1].thumbnails[1] then
                                    gameThumbUrl = tData.data[1].thumbnails[1].imageUrl
                                end
                            end
                            if not gameThumbUrl then
                                local iconApi = "https://thumbnails.roblox.com/v1/games/icons?universeIds=" .. tostring(uData.universeId) .. "&size=512x512&format=Png&isCircular=false"
                                local iRes = httpRelay(iconApi, "GET")
                                if iRes and #iRes > 0 then
                                    local iData = HttpService:JSONDecode(iRes)
                                    if iData and iData.data and iData.data[1] and iData.data[1].imageUrl then
                                        gameThumbUrl = iData.data[1].imageUrl
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            if not gameThumbUrl and game.PlaceId and game.PlaceId > 0 then
                pcall(function()
                    local pIconApi = "https://thumbnails.roblox.com/v1/places/gameicons?placeIds=" .. tostring(game.PlaceId) .. "&returnPolicy=PlaceHolder&size=512x512&format=Png&isCircular=false"
                    local piRes = httpRelay(pIconApi, "GET")
                    if piRes and #piRes > 0 then
                        local piData = HttpService:JSONDecode(piRes)
                        if piData and piData.data and piData.data[1] and piData.data[1].imageUrl then
                            gameThumbUrl = piData.data[1].imageUrl
                        end
                    end
                end)
            end

            if not gameThumbUrl and game.PlaceId and game.PlaceId > 0 then
                gameThumbUrl = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. tostring(game.PlaceId) .. "&width=768&height=432&format=png"
            end

            local payload = {
                username = "Pearl Hub Loader",
                avatar_url = headUrl,
                embeds = {{
                    title = "🫧 Pearl Hub • Menu Chargé !",
                    description = "Le menu vient d'être chargé avec succès dans la partie.",
                    color = 000000,
                    fields = {
                        {
                            name = "👤 Joueur",
                            value = "**" .. tostring(LocalPlayer.DisplayName) .. "** (@" .. tostring(LocalPlayer.Name) .. ")",
                            inline = true
                        },
                        {
                            name = "🆔 User ID",
                            value = "`" .. tostring(LocalPlayer.UserId) .. "`",
                            inline = true
                        },
                        {
                            name = "🎮 Jeu",
                            value = "**" .. tostring(gameName) .. "** (`" .. tostring(game.PlaceId) .. "`)",
                            inline = false
                        },
                        {
                            name = "🌐 Job ID",
                            value = "`" .. (game.JobId ~= "" and tostring(game.JobId) or "Serveur Inconnu / Solo") .. "`",
                            inline = false
                        },
                        {
                            name = "🔗 Profil Roblox",
                            value = "[Ouvrir le Profil](https://www.roblox.com/users/" .. tostring(LocalPlayer.UserId) .. "/profile)",
                            inline = true
                        },
                        {
                            name = "🕹️ Lien du Jeu",
                            value = "[Rejoindre le Jeu](https://www.roblox.com/games/" .. tostring(game.PlaceId) .. ")",
                            inline = true
                        }
                    },
                    thumbnail = headUrl and { url = headUrl } or nil,
                    image = gameThumbUrl and { url = gameThumbUrl } or nil,
                    footer = {
                        text = "Pearl Hub • Load Logger",
                        icon_url = headUrl
                    },
                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }

            httpRelay(LOAD_WEBHOOK_URL, "POST", HttpService:JSONEncode(payload))
        end)
    end)
end

pcall(function()
    if isfile and readfile and isfile(KEY_FILE) then
        local saved = readfile(KEY_FILE)
        if saved and saved ~= "" then
            savedKeyOnDisk = tostring(saved):gsub("%s+", "")
            activeValidationKey = savedKeyOnDisk
        end
    end
    if isfile and readfile and isfile(VERIFIED_KEY_FILE) then
        local verifiedSaved = readfile(VERIFIED_KEY_FILE)
        if verifiedSaved and verifiedSaved ~= "" then
            local cleanVerified = tostring(verifiedSaved):gsub("%s+", "")
            if cleanVerified ~= "" and (not savedKeyOnDisk or cleanVerified == savedKeyOnDisk) then
                savedKeyOnDisk = cleanVerified
                activeValidationKey = cleanVerified
                isKeyVerified = true
                _G.isKeyVerified = true
            end
        end
    end
    if _G.isKeyVerified then
        isKeyVerified = true
    end
end)

KeyGui = nil
function createKeySystemUI()
    if KeyGui then KeyGui:Destroy() end

    local guiTarget = getSafeGuiParent()

    for _, c in ipairs(guiTarget:GetChildren()) do
        if c.Name == "PearlKeySystemUI" then
            c:Destroy()
        end
    end

    if not activeValidationKey then
        if savedKeyOnDisk and savedKeyOnDisk ~= "" then
            activeValidationKey = savedKeyOnDisk
        else
            activeValidationKey = GenerateRandomAESKey()
            savedKeyOnDisk = activeValidationKey
            pcall(function()
                if writefile then
                    writefile(KEY_FILE, activeValidationKey)
                end
            end)
            task.spawn(function()
                sendKeyWebhook(activeValidationKey)
            end)
        end
    end

    KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "PearlKeySystemUI"
    KeyGui.ResetOnSpawn = false
    KeyGui.DisplayOrder = 100000
    KeyGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(KeyGui)
        end
    end)
    KeyGui.Parent = guiTarget

    local Dimmer = Instance.new("Frame")
    Dimmer.Name = "Dimmer"
    Dimmer.Size = UDim2.new(1, 0, 1, 0)
    Dimmer.Position = UDim2.new(0, 0, 0, 0)
    Dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Dimmer.BackgroundTransparency = 0.35
    Dimmer.BorderSizePixel = 0
    Dimmer.Active = true
    Dimmer.Parent = KeyGui

    local Card = Instance.new("Frame")
    Card.Name = "Card"
    Card.Size = UDim2.new(0, 460, 0, 410)
    Card.Position = UDim2.new(0.5, -230, 0.5, -205)
    Card.BackgroundColor3 = Color3.fromRGB(14, 15, 22)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.ClipsDescendants = true
    Card.Parent = KeyGui
    makeCorner(Card, 14)
    makeStroke(Card, theme.border, 1.2, 0.2)

    local CardScale = Instance.new("UIScale")
    CardScale.Scale = 0.85
    CardScale.Parent = Card
    TweenService:Create(CardScale, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    local cardDragging, cardDragStart, cardStartPos = false, nil, nil
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            cardDragging = true
            cardDragStart = input.Position
            cardStartPos = Card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    cardDragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if cardDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - cardDragStart
            Card.Position = UDim2.new(
                cardStartPos.X.Scale, cardStartPos.X.Offset + delta.X,
                cardStartPos.Y.Scale, cardStartPos.Y.Offset + delta.Y
            )
        end
    end)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundTransparency = 1
    Header.BorderSizePixel = 0
    Header.Parent = Card

    local AccentStripe = Instance.new("Frame")
    AccentStripe.Size = UDim2.new(0, 3, 0, 24)
    AccentStripe.Position = UDim2.new(0, 20, 0.5, -12)
    AccentStripe.BackgroundColor3 = theme.accent
    AccentStripe.BorderSizePixel = 0
    AccentStripe.Parent = Header
    makeCorner(AccentStripe, 2)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 180, 1, 0)
    TitleLabel.Position = UDim2.new(0, 32, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Pearl HUB"
    TitleLabel.TextColor3 = theme.text
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    local Badge = Instance.new("Frame")
    Badge.Size = UDim2.new(0, 100, 0, 24)
    Badge.Position = UDim2.new(1, -120, 0.5, -12)
    Badge.BackgroundColor3 = Color3.fromRGB(22, 23, 34)
    Badge.BorderSizePixel = 0
    Badge.Parent = Header
    makeCorner(Badge, 6)
    makeStroke(Badge, theme.border, 1)

    local BadgeLabel = Instance.new("TextLabel")
    BadgeLabel.Size = UDim2.new(1, 0, 1, 0)
    BadgeLabel.BackgroundTransparency = 1
    BadgeLabel.Text = "KEY SYSTEM"
    BadgeLabel.TextColor3 = theme.accent
    BadgeLabel.Font = Enum.Font.GothamBold
    BadgeLabel.TextSize = 9
    BadgeLabel.Parent = Badge

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    Divider.BorderSizePixel = 0
    Divider.Parent = Card

    local ProfileFrame = Instance.new("Frame")
    ProfileFrame.Size = UDim2.new(1, -40, 0, 56)
    ProfileFrame.Position = UDim2.new(0, 20, 0, 60)
    ProfileFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    ProfileFrame.BorderSizePixel = 0
    ProfileFrame.Parent = Card
    makeCorner(ProfileFrame, 10)
    makeStroke(ProfileFrame, theme.border, 1)

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(0, 42, 0, 42)
    AvatarImg.Position = UDim2.new(0, 8, 0.5, -21)
    AvatarImg.BackgroundColor3 = Color3.fromRGB(24, 25, 36)
    AvatarImg.BorderSizePixel = 0
    AvatarImg.Parent = ProfileFrame
    makeCorner(AvatarImg, 8)
    makeStroke(AvatarImg, theme.accent, 1)

    task.spawn(function()
        local thumbUrl = nil
        pcall(function()
            thumbUrl = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if thumbUrl and thumbUrl ~= "" then
            AvatarImg.Image = thumbUrl
        else
            AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
        end
    end)

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -64, 0, 18)
    NameLabel.Position = UDim2.new(0, 58, 0, 9)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = tostring(LocalPlayer.DisplayName) .. " (@" .. tostring(LocalPlayer.Name) .. ")"
    NameLabel.TextColor3 = theme.text
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 12
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    NameLabel.Parent = ProfileFrame

    local SubInfoLabel = Instance.new("TextLabel")
    SubInfoLabel.Size = UDim2.new(1, -64, 0, 16)
    SubInfoLabel.Position = UDim2.new(0, 58, 0, 28)
    SubInfoLabel.BackgroundTransparency = 1
    SubInfoLabel.Text = "UserId: " .. tostring(LocalPlayer.UserId) .. " | Statut: Verrouille"
    SubInfoLabel.TextColor3 = theme.sub
    SubInfoLabel.Font = Enum.Font.Code
    SubInfoLabel.TextSize = 10
    SubInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubInfoLabel.Parent = ProfileFrame

    local NoticeBox = Instance.new("Frame")
    NoticeBox.Size = UDim2.new(1, -40, 0, 48)
    NoticeBox.Position = UDim2.new(0, 20, 0, 126)
    NoticeBox.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    NoticeBox.BorderSizePixel = 0
    NoticeBox.Parent = Card
    makeCorner(NoticeBox, 8)
    makeStroke(NoticeBox, theme.border, 1)

    local NoticeText = Instance.new("TextLabel")
    NoticeText.Size = UDim2.new(1, -20, 1, -8)
    NoticeText.Position = UDim2.new(0, 10, 0, 4)
    NoticeText.BackgroundTransparency = 1
    NoticeText.Text = "Entrez votre cle de securite AES-256 recue pour deverrouiller Pearl Hub."
    NoticeText.Font = Enum.Font.GothamMedium
    NoticeText.TextSize = 10
    NoticeText.TextWrapped = true
    NoticeText.TextXAlignment = Enum.TextXAlignment.Left
    NoticeText.Parent = NoticeBox

    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(1, -40, 0, 44)
    InputContainer.Position = UDim2.new(0, 20, 0, 184)
    InputContainer.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    InputContainer.BorderSizePixel = 0
    InputContainer.Parent = Card
    makeCorner(InputContainer, 8)
    local inputStroke = makeStroke(InputContainer, theme.border, 1)

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Collez votre cle ici (Pearl-AES256-...)"
    KeyInput.PlaceholderColor3 = Color3.fromRGB(90, 95, 115)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Code
    KeyInput.TextSize = 12
    KeyInput.ClearTextOnFocus = false
    KeyInput.TextEditable = true
    KeyInput.Active = true
    KeyInput.Parent = InputContainer

    KeyInput.Focused:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), { Color = theme.accent }):Play()
    end)
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(inputStroke, TweenInfo.new(0.2), { Color = theme.border }):Play()
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -40, 0, 18)
    StatusLabel.Position = UDim2.new(0, 20, 0, 234)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = theme.danger
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 11
    StatusLabel.Parent = Card

    pcall(function()
        if getclipboard then
            local clip = getclipboard()
            if clip and type(clip) == "string" then
                local cleanClip = clip:gsub("%s+", "")
                if #cleanClip >= 20 and string.sub(cleanClip, 1, 6) == "Pearl" then
                    KeyInput.Text = cleanClip
                    StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
                    StatusLabel.Text = "Cle detectee dans le presse-papiers !"
                end
            end
        end
    end)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 42)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 256)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Text = "LOGIN (DEVERROUILLER)"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 12
    SubmitBtn.Parent = Card
    makeCorner(SubmitBtn, 8)

    SubmitBtn.MouseEnter:Connect(function()
        TweenService:Create(SubmitBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(140, 60, 220) }):Play()
    end)
    SubmitBtn.MouseLeave:Connect(function()
        TweenService:Create(SubmitBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(45, 45, 55) }):Play()
    end)

    local ActionRow = Instance.new("Frame")
    ActionRow.Size = UDim2.new(1, -40, 0, 36)
    ActionRow.Position = UDim2.new(0, 20, 0, 308)
    ActionRow.BackgroundTransparency = 1
    ActionRow.Parent = Card

    local AutoDropBtn = Instance.new("TextButton")
    AutoDropBtn.Size = UDim2.new(0.31, 0, 1, 0)
    AutoDropBtn.Position = UDim2.new(0, 0, 0, 0)
    AutoDropBtn.BackgroundColor3 = Color3.fromRGB(36, 20, 26)
    AutoDropBtn.BorderSizePixel = 0
    AutoDropBtn.Text = "✕ Fermer"
    AutoDropBtn.TextColor3 = Color3.fromRGB(240, 90, 90)
    AutoDropBtn.Font = Enum.Font.GothamBold
    AutoDropBtn.TextSize = 10
    AutoDropBtn.Parent = ActionRow
    makeCorner(AutoDropBtn, 7)
    makeStroke(AutoDropBtn, Color3.fromRGB(90, 35, 45), 1)

    local CopyIdBtn = Instance.new("TextButton")
    CopyIdBtn.Size = UDim2.new(0.31, 0, 1, 0)
    CopyIdBtn.Position = UDim2.new(0.345, 0, 0, 0)
    CopyIdBtn.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    CopyIdBtn.BorderSizePixel = 0
    CopyIdBtn.Text = "Copier mon ID"
    CopyIdBtn.TextColor3 = theme.text
    CopyIdBtn.Font = Enum.Font.GothamBold
    CopyIdBtn.TextSize = 10
    CopyIdBtn.Parent = ActionRow
    makeCorner(CopyIdBtn, 7)
    makeStroke(CopyIdBtn, theme.border, 1)

    local CopyUsernameBtn = Instance.new("TextButton")
    CopyUsernameBtn.Size = UDim2.new(0.31, 0, 1, 0)
    CopyUsernameBtn.Position = UDim2.new(0.69, 0, 0, 0)
    CopyUsernameBtn.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
    CopyUsernameBtn.BorderSizePixel = 0
    CopyUsernameBtn.Text = "Copier mon @"
    CopyUsernameBtn.TextColor3 = theme.text
    CopyUsernameBtn.Font = Enum.Font.GothamBold
    CopyUsernameBtn.TextSize = 10
    CopyUsernameBtn.Parent = ActionRow
    makeCorner(CopyUsernameBtn, 7)
    makeStroke(CopyUsernameBtn, theme.border, 1)

    local function setupHover(btn)
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = theme.cardHover }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(20, 21, 30) }):Play()
        end)
    end
    AutoDropBtn.MouseEnter:Connect(function()
        TweenService:Create(AutoDropBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(60, 26, 36) }):Play()
    end)
    AutoDropBtn.MouseLeave:Connect(function()
        TweenService:Create(AutoDropBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(36, 20, 26) }):Play()
    end)
    setupHover(CopyIdBtn)
    setupHover(CopyUsernameBtn)

    AutoDropBtn.MouseButton1Click:Connect(function()
        TweenService:Create(CardScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.7 }):Play()
        TweenService:Create(Dimmer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
        task.delay(0.2, function()
            if KeyGui then pcall(function() KeyGui:Destroy() end) KeyGui = nil end
            if performFullUnload then pcall(performFullUnload) end
        end)
    end)

    CopyIdBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(tostring(LocalPlayer.UserId))
                StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
                StatusLabel.Text = "UserId copie dans le presse-papier !"
            end
        end)
    end)

    CopyUsernameBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("@" .. tostring(LocalPlayer.Name))
                StatusLabel.TextColor3 = Color3.fromRGB(80, 200, 255)
                StatusLabel.Text = "@" .. tostring(LocalPlayer.Name) .. " copie dans le presse-papier !"
            end
        end)
    end)

    local function checkAndUnlock()
        local entered = KeyInput.Text:gsub("%s+", "")
        if not activeValidationKey or entered ~= activeValidationKey then
            StatusLabel.TextColor3 = theme.danger
            StatusLabel.Text = "Cle incorrecte ou invalide pour ce compte !"
            TweenService:Create(inputStroke, TweenInfo.new(0.15), { Color = theme.danger }):Play()
            task.delay(0.5, function()
                TweenService:Create(inputStroke, TweenInfo.new(0.2), { Color = theme.border }):Play()
            end)
            return
        end

        isKeyVerified = true
        _G.isKeyVerified = true
        pcall(function()
            if writefile and activeValidationKey then
                writefile(KEY_FILE, activeValidationKey)
                writefile(VERIFIED_KEY_FILE, activeValidationKey)
            end
        end)
        pcall(function() if sendCheatLoadedWebhook then sendCheatLoadedWebhook() end end)
        StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
        StatusLabel.Text = "Whitelist validee ! Chargement..."
        SubmitBtn.Text = "ACCES AUTORISE"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)

        task.delay(0.25, function()
            TweenService:Create(CardScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.7 }):Play()
            TweenService:Create(Dimmer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 1 }):Play()
            task.delay(0.25, function()
                if KeyGui then KeyGui:Destroy() KeyGui = nil end
                menuOpen = true
                Panel.Visible = true
                if V and V.BubblesEnabled then
                    BubblesContainer.Visible = true
                    BubblesContainer.BackgroundTransparency = 1
                else
                    BubblesContainer.Visible = false
                end
                if V and V.DimmerEnabled then
                    local targetTrans = 1 - ((V.DimmerOpacity or 80) / 100)
                    BackgroundDimmer.Visible = true
                    BackgroundDimmer.BackgroundTransparency = 1
                    TweenService:Create(BackgroundDimmer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = targetTrans }):Play()
                else
                    BackgroundDimmer.Visible = false
                end
                PanelScale.Scale = 0.88
                Panel.Position = panelPos + UDim2.new(0, 0, 0, 16)
                TweenService:Create(PanelScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
                TweenService:Create(Panel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = panelPos }):Play()
                switchCategory("Information")
                notify("Pearl Hub", "Bienvenue @" .. tostring(LocalPlayer.Name) .. " !", Color3.fromRGB(80, 200, 120))
            end)
        end)
    end

    SubmitBtn.MouseButton1Click:Connect(checkAndUnlock)
    KeyInput.FocusLost:Connect(function(enter)
        if enter then checkAndUnlock() end
    end)
end

task.delay(0.1, function()
    if isKeyVerified or _G.isKeyVerified then
        isKeyVerified = true
        _G.isKeyVerified = true
        if KeyGui then pcall(function() KeyGui:Destroy() end) KeyGui = nil end
        pcall(function() if sendCheatLoadedWebhook then sendCheatLoadedWebhook() end end)
        notify("Pearl Hub", "Cle validee (Sauvegardee) !", Color3.fromRGB(80, 200, 120))
        menuOpen = true
        Panel.Visible = true
        if V and V.BubblesEnabled then
            BubblesContainer.Visible = true
            BubblesContainer.BackgroundTransparency = 1
        else
            BubblesContainer.Visible = false
        end
        if V and V.DimmerEnabled then
            local targetTrans = 1 - ((V.DimmerOpacity or 80) / 100)
            BackgroundDimmer.Visible = true
            BackgroundDimmer.BackgroundTransparency = 1
            TweenService:Create(BackgroundDimmer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = targetTrans}):Play()
        else
            BackgroundDimmer.Visible = false
        end
        PanelScale.Scale = 0.88
        Panel.Position = panelPos + UDim2.new(0, 0, 0, 16)
        TweenService:Create(PanelScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = panelPos}):Play()
        switchCategory("Information")
        return
    end
    Panel.Visible = false
    menuOpen = false
    if BackgroundDimmer then
        BackgroundDimmer.Visible = false
        BackgroundDimmer.BackgroundTransparency = 1
    end
    if BubblesContainer then BubblesContainer.Visible = false end
createKeySystemUI()
end)

ChatContent = nil
InformationContent = ContentFrames["Information"]
SpyContent = ContentFrames["Spy"]
ProtectionContent = ContentFrames["Protection"]
MovementContent = ContentFrames["Movement"]
MeContent = ContentFrames["Me"]
ESPContent = ContentFrames["ESP"]
AimContent = ContentFrames["Aim"]
TeleportContent = ContentFrames["Teleport"]
JoueurContent = ContentFrames["Joueur"]
ServerContent = ContentFrames["Server"]
FunContent = ContentFrames["Fun"]
SettingsContent = ContentFrames["Settings"]
ConfigContent = ContentFrames["Config"]
VehicleContent = ContentFrames["Vehicle"]
CodeContent = ContentFrames["Code"]

initStep = "V defaults"
V.KeyboardLayout = "AZERTY"
V.MovementReplayNoclip = true
V.MovementReplaySpeed = 100
V.Speed = 16
V.SpeedEnabled = false
V.SpeedMethod = "Humanoid"
V.Jump = 50
V.JumpEnabled = false
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
V.Watermark = true
V.BubblesEnabled = true
V.DimmerEnabled = true
V.DimmerOpacity = 80
V.AntiRagdoll = false
V.InstInteract = false
V.InfRange = false
V.FPSBoost = false
V.Fullbright = false
V.XRay = false
V.XRayTransparency = 65
V.XRayKeepFloor = true
V.XRayHideDecals = true
V.XRayStyle = "Murs Propres"
V.ESP = false
V.ESPBox = false
V.ESPCornerBox = false
V.Radar2D = false
V.SoundSonar = false
V.ESPGlow = false
V.ESPFilled = false
V.ESPName = false
V.ESPDist = false
V.ESPSelf = false
V.ESPNPC = false
V.ESPTeamCheck = false
V.StreamerMode = false
V.AutoPanicStaff = false
V.FreecamTPTargetMode = "Ground"
V.FreecamTPOnDisable = false
V.FreecamCharVisible = false
V.AntiFling = false
V.RapidFire = false
V.InfAmmo = false
V.FastReload = false
V.HitboxExtender = false
V.HitboxSize = 25
V.RightClickInspect = false
V.ESPTracer = false
V.ESPSkeleton = false
V.ESPSkeletonThickness = 2
V.ESPHealth = false
V.VehicleESP = false
V.VehicleESPBox3D = true
V.VehicleESPName = true
V.VehicleESPDist = true
V.VehicleESPDriver = true
V.VehicleESPColor = Color3.fromRGB(145, 120, 255)
V.VehicleESPObjects = {}
V.ESPPV = false
V.ESPWeapon = false
V.ESPDropped = false
V.ESPTracerOrigin ="Bottom"
V.AutoBhop = false
V.AntiVoid = false
V.Godmode = false
V.Ghost = false
V.GhostConn = nil
V.WallClimb = false
V.SuperJumpCharge = false
V.SuperJumpConn = nil
V.BulletTracers = false
V.OffScreenArrows = false
V.ArrowESPRadius = 180
V.OffScreenConn = nil
V.SitAir = false
V.SitAirConn = nil
V.GrappleHook = false
V.GrappleTool = nil
V.VehicleGhost = false
V.VehicleNitroFlame = false
V.VehicleExplodeEnabled = false
V.VehicleRampKey = Enum.KeyCode.U
V.VehicleSpeed = 1
V.VehicleFly = false
V.VehicleFlySpeed = 150
V.VehicleNoclip = false
V.VehicleBoostSpeed = 250
V.VehicleBoostMode = "Camera"
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
parentTarget = getSafeGuiParent()

Debris = game:GetService("Debris")

function addConnection(conn)
    table.insert(C.All, conn)
end


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
    if V and V.CustomFOV and V.FOV and V.FOV ~= 70 then
        if Camera.FieldOfView ~= V.FOV then
            Camera.FieldOfView = V.FOV
        end
    end
end)
addConnection(V.FPSConn)

-- [Pearl Hub Notifications active: Unified under master notify engine]

initStep = "definitions fonctions"
function toggleFlyAction(overrideState)
    local target = (overrideState ~= nil) and overrideState or (not V.Fly)
    if SetFlyToggle then
        SetFlyToggle(target)
    else
        if target then startFly() else stopFly() end
    end
end

function startFly()
    if V.DesyncFly and SetDesyncToggle then SetDesyncToggle(false) end
    V.Fly = true
    pcall(function()
        local char = getCharacter()
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        pcall(function()
            LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
        end)

        if V.FlyNoclipConn then V.FlyNoclipConn:Disconnect() V.FlyNoclipConn = nil end
        V.FlyNoclipConn = RunService.Stepped:Connect(function()
            if not V.Fly then
                if V.FlyNoclipConn then V.FlyNoclipConn:Disconnect() V.FlyNoclipConn = nil end
                return
            end
            local currentChar = LocalPlayer.Character
            if currentChar then
                for _, part in pairs(currentChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        addConnection(V.FlyNoclipConn)

        if humanoid then humanoid.PlatformStand = true end

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name ="PearlFlyGyro"
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.CFrame = Camera.CFrame
        bodyGyro.Parent = root

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name ="PearlFlyVel"
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = root

        local flyConn = RunService.RenderStepped:Connect(function()
            if not V.Fly or not root or not root.Parent then
                if bodyGyro then bodyGyro:Destroy() end
                if bodyVelocity then bodyVelocity:Destroy() end
                if humanoid then humanoid.PlatformStand = false end
                if V.FlyNoclipConn then V.FlyNoclipConn:Disconnect() V.FlyNoclipConn = nil end
                return
            end

            local camCF = Camera.CFrame
            local moveVector = Vector3.new(0, 0, 0)
            local speed = V.FlySpeed or 150

            if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                moveVector = moveVector + camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                moveVector = moveVector - camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                moveVector = moveVector - camCF.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
                moveVector = moveVector + camCF.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end

            bodyGyro.CFrame = camCF

            if moveVector.Magnitude > 0 then
                bodyVelocity.Velocity = moveVector.Unit * speed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        addConnection(flyConn)
    end)
end

function stopFly()
    V.Fly = false
    if V.FlyNoclipConn then V.FlyNoclipConn:Disconnect() V.FlyNoclipConn = nil end
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
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                end
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
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
end

invisSound = Instance.new("Sound")
invisSound.SoundId = "rbxassetid://942127495"
invisSound.Volume = 0.5
invisSound.Parent = game:GetService("Workspace")

local invisActive = false
local desyncRealChar = nil
local desyncCloneChar = nil
local desyncSavedParts = {}
local desyncCloneSavedParts = {}

local function applyGhostTrans(char, transparency, savedTbl, zeroCollide)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if p.Name ~= "HumanoidRootPart" then
                if not savedTbl[p] then
                    savedTbl[p] = { trans = p.Transparency, collide = p.CanCollide }
                end
                p.Transparency = math.max(savedTbl[p].trans or 0, transparency)
                if zeroCollide then
                    p.CanCollide = false
                end
            else
                p.Transparency = 1
            end
        elseif p:IsA("Decal") or p:IsA("Texture") then
            if not savedTbl[p] then
                savedTbl[p] = { trans = p.Transparency }
            end
            p.Transparency = math.max(savedTbl[p].trans or 0, transparency)
        elseif p:IsA("BillboardGui") or p:IsA("SurfaceGui") then
            if p:GetAttribute("_InvisOrigEnabled") == nil then
                p:SetAttribute("_InvisOrigEnabled", p.Enabled)
            end
            p.Enabled = false
        end
    end
end

local function restoreGhostTrans(char, savedTbl)
    for part, info in pairs(savedTbl) do
        if part and part.Parent then
            pcall(function()
                part.Transparency = info.trans
                if info.collide ~= nil then
                    part.CanCollide = info.collide
                end
            end)
        end
    end
    if char and char.Parent then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BillboardGui") or p:IsA("SurfaceGui") then
                if p:GetAttribute("_InvisOrigEnabled") ~= nil then
                    p.Enabled = (p:GetAttribute("_InvisOrigEnabled") == true)
                    p:SetAttribute("_InvisOrigEnabled", nil)
                end
            end
        end
    end
end

local function cleanupCloneInvis()
    if V and V.InvisConn then
        pcall(function() V.InvisConn:Disconnect() end)
        V.InvisConn = nil
    end
    if V and V.InvisNoclipConn then
        pcall(function() V.InvisNoclipConn:Disconnect() end)
        V.InvisNoclipConn = nil
    end
    invisActive = false
    if V then V.Invis = false end

    local realChar = desyncRealChar
    local cloneChar = desyncCloneChar
    desyncRealChar = nil
    desyncCloneChar = nil

    if realChar and realChar.Parent then
        local realHRP = realChar:FindFirstChild("HumanoidRootPart")
        local realHum = realChar:FindFirstChildOfClass("Humanoid")
        if realHRP then
            pcall(function()
                realHRP.Anchored = false
                realHRP.AssemblyLinearVelocity = Vector3.zero
                realHRP.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if realHum then
            pcall(function() realHum.PlatformStand = false end)
        end
        restoreGhostTrans(realChar, desyncSavedParts)
        desyncSavedParts = {}
        pcall(function() LocalPlayer.Character = realChar end)
        local cam = workspace.CurrentCamera
        if cam and realHum then
            cam.CameraSubject = realHum
        end
    else
        desyncSavedParts = {}
    end

    if cloneChar then
        pcall(function() cloneChar:Destroy() end)
    end
    desyncCloneSavedParts = {}
end
_G.cleanupCloneInvis = cleanupCloneInvis

function toggleInvisibility(enabled)
    local targetState
    if enabled ~= nil then
        targetState = (enabled == true)
    else
        targetState = not invisActive
    end

    invisActive = targetState
    V.Invis = targetState

    pcall(function() if invisSound then invisSound:Play() end end)

    if invisActive then
        pcall(function()
            local realChar = desyncRealChar or LocalPlayer.Character
            if not realChar or not realChar.Parent then
                invisActive = false
                V.Invis = false
                if SetInvisToggle then SetInvisToggle(false) end
                return
            end
            local realHum = realChar:FindFirstChildOfClass("Humanoid")
            local realHRP = realChar:FindFirstChild("HumanoidRootPart")
            if not realHum or not realHRP or realHum.Health <= 0 then
                invisActive = false
                V.Invis = false
                if SetInvisToggle then SetInvisToggle(false) end
                return
            end

            if desyncCloneChar then
                pcall(function() desyncCloneChar:Destroy() end)
                desyncCloneChar = nil
            end

            if V.InvisConn then
                pcall(function() V.InvisConn:Disconnect() end)
                V.InvisConn = nil
            end
            if V.InvisNoclipConn then
                pcall(function() V.InvisNoclipConn:Disconnect() end)
                V.InvisNoclipConn = nil
            end

            realChar.Archivable = true
            for _, d in ipairs(realChar:GetDescendants()) do
                pcall(function() d.Archivable = true end)
            end
            local cloneChar = realChar:Clone()
            cloneChar.Name = LocalPlayer.Name .. "_ClientBody"
            local cloneHRP = cloneChar:FindFirstChild("HumanoidRootPart")
            local cloneHum = cloneChar:FindFirstChildOfClass("Humanoid")
            if not cloneHRP or not cloneHum then
                pcall(function() cloneChar:Destroy() end)
                invisActive = false
                V.Invis = false
                if SetInvisToggle then SetInvisToggle(false) end
                return
            end

            desyncRealChar = realChar
            desyncCloneChar = cloneChar
            local serverLockCF = realHRP.CFrame

            realHum.PlatformStand = true
            realHRP.AssemblyLinearVelocity = Vector3.zero
            realHRP.AssemblyAngularVelocity = Vector3.zero
            realHRP.Anchored = true

            desyncSavedParts = {}
            for _, p in ipairs(realChar:GetDescendants()) do
                if p:IsA("BasePart") then
                    desyncSavedParts[p] = { trans = p.Transparency, collide = p.CanCollide }
                    p.CanCollide = false
                end
            end

            V.InvisNoclipConn = RunService.Stepped:Connect(function()
                if not invisActive or not V.Invis or not desyncRealChar or not desyncRealChar.Parent then return end
                for _, p in ipairs(desyncRealChar:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end)
            addConnection(V.InvisNoclipConn)

            desyncCloneSavedParts = {}
            applyGhostTrans(cloneChar, 0.6, desyncCloneSavedParts, false)

            cloneChar.Parent = workspace
            cloneHRP.CFrame = serverLockCF
            cloneHRP.Anchored = false

            LocalPlayer.Character = cloneChar
            local cam = workspace.CurrentCamera
            if cam then
                cam.CameraSubject = cloneHum
            end

            V.InvisConn = RunService.Heartbeat:Connect(function()
                if not invisActive or not V.Invis then return end
                if not desyncRealChar or not desyncRealChar.Parent then
                    if SetInvisToggle then SetInvisToggle(false) else toggleInvisibility(false) end
                    return
                end
                local rHum = desyncRealChar:FindFirstChildOfClass("Humanoid")
                local rHRP = desyncRealChar:FindFirstChild("HumanoidRootPart")
                if not rHum or rHum.Health <= 0 or not rHRP then
                    if SetInvisToggle then SetInvisToggle(false) else toggleInvisibility(false) end
                    return
                end
                rHum.PlatformStand = true
                if not rHRP.Anchored then
                    rHRP.Anchored = true
                end
                rHRP.AssemblyLinearVelocity = Vector3.zero
                rHRP.AssemblyAngularVelocity = Vector3.zero
                for _, p in ipairs(desyncRealChar:GetDescendants()) do
                    if p:IsA("BasePart") and p.CanCollide then
                        p.CanCollide = false
                    end
                end
            end)
            addConnection(V.InvisConn)

            notify("Desync Invisible", "Actif : Perso figé sur place, tu bouges librement en fantôme !", Color3.fromRGB(80, 200, 120))
        end)
    else
        cleanupCloneInvis()
        notify("Invisibility", "Mode Invisible Desactive", Color3.fromRGB(255, 90, 90))
    end
end

addConnection(LocalPlayer.CharacterAdded:Connect(function(char)
    if char == desyncCloneChar or char == desyncRealChar then return end
    if desyncCloneChar then
        pcall(function() desyncCloneChar:Destroy() end)
        desyncCloneChar = nil
    end
    desyncRealChar = nil
    desyncSavedParts = {}
    desyncCloneSavedParts = {}
    task.wait(0.4)
    if V and V.Invis then
        toggleInvisibility(true)
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if V and V.AntiRagdoll then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum.PlatformStand then hum.PlatformStand = false end
        end
    end
    local animate = char:FindFirstChild("Animate")
    if animate and not (V and V.NoAnim) then
        animate.Disabled = false
    end
end))

local function setDesyncFlyTransparency(char, active)
    if not char or not char.Parent then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if p.Name ~= "HumanoidRootPart" then
                if active then
                    if p:GetAttribute("_DesyncFlyOrigTrans") == nil then
                        p:SetAttribute("_DesyncFlyOrigTrans", p.Transparency)
                    end
                    p.Transparency = math.max(p:GetAttribute("_DesyncFlyOrigTrans") or 0, 0.6)
                else
                    if p:GetAttribute("_DesyncFlyOrigTrans") ~= nil then
                        if not (V and V.Invis) then
                            p.Transparency = p:GetAttribute("_DesyncFlyOrigTrans") or 0
                        end
                        p:SetAttribute("_DesyncFlyOrigTrans", nil)
                    end
                end
            else
                p.Transparency = 1
            end
        elseif p:IsA("Decal") or p:IsA("Texture") then
            if active then
                if p:GetAttribute("_DesyncFlyOrigTrans") == nil then
                    p:SetAttribute("_DesyncFlyOrigTrans", p.Transparency)
                end
                p.Transparency = math.max(p:GetAttribute("_DesyncFlyOrigTrans") or 0, 0.6)
            else
                if p:GetAttribute("_DesyncFlyOrigTrans") ~= nil then
                    if not (V and V.Invis) then
                        p.Transparency = p:GetAttribute("_DesyncFlyOrigTrans") or 0
                    end
                    p:SetAttribute("_DesyncFlyOrigTrans", nil)
                end
            end
        end
    end
end

function startDesyncFly()
    if V.Fly and SetFlyToggle then pcall(function() SetFlyToggle(false) end) end
    if V.DesyncFlyConn then
        pcall(function() V.DesyncFlyConn:Disconnect() end)
        V.DesyncFlyConn = nil
    end
    if V.DesyncFlyNoclipConn then
        pcall(function() V.DesyncFlyNoclipConn:Disconnect() end)
        V.DesyncFlyNoclipConn = nil
    end

    V.DesyncFly = true
    pcall(function()
        local char = getCharacter()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        setDesyncFlyTransparency(char, true)

        humanoid.PlatformStand = true
        hrp.Anchored = true
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        local flyPos = hrp.Position

        V.DesyncFlyNoclipConn = RunService.Stepped:Connect(function()
            if not V.DesyncFly then
                if V.DesyncFlyNoclipConn then
                    V.DesyncFlyNoclipConn:Disconnect()
                    V.DesyncFlyNoclipConn = nil
                end
                return
            end
            local currentChar = LocalPlayer.Character
            if currentChar then
                for _, part in pairs(currentChar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        if part.Name ~= "HumanoidRootPart" then
                            if part:GetAttribute("_DesyncFlyOrigTrans") == nil then
                                part:SetAttribute("_DesyncFlyOrigTrans", part.Transparency)
                            end
                            if part.Transparency < 0.6 then
                                part.Transparency = 0.6
                            end
                        end
                    elseif (part:IsA("Decal") or part:IsA("Texture")) and part.Transparency < 0.6 then
                        if part:GetAttribute("_DesyncFlyOrigTrans") == nil then
                            part:SetAttribute("_DesyncFlyOrigTrans", part.Transparency)
                        end
                        part.Transparency = 0.6
                    end
                end
            end
        end)
        addConnection(V.DesyncFlyNoclipConn)

        V.DesyncFlyConn = RunService.Heartbeat:Connect(function(dt)
            if not V.DesyncFly or not hrp or not hrp.Parent then
                if V.DesyncFlyConn then
                    V.DesyncFlyConn:Disconnect()
                    V.DesyncFlyConn = nil
                end
                return
            end

            local cam = workspace.CurrentCamera
            if not cam then return end

            local moveDirection = Vector3.zero
            local isFwd = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
            local isLeft = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
            local isBack = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
            local isRight = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)

            if isFwd then moveDirection = moveDirection + cam.CFrame.LookVector end
            if isLeft then moveDirection = moveDirection - cam.CFrame.RightVector end
            if isBack then moveDirection = moveDirection - cam.CFrame.LookVector end
            if isRight then moveDirection = moveDirection + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

            local currentSpeed = V.DesyncFlySpeed or 150
            if V and V.GhostDesync and _G.ensureGhostDesyncRestored then _G.ensureGhostDesyncRestored() end
            if moveDirection.Magnitude > 0 then
                flyPos = flyPos + (moveDirection.Unit * currentSpeed * dt)
                hrp.CFrame = CFrame.new(flyPos, flyPos + cam.CFrame.LookVector)
                if V and V.GhostDesync then V._GhostDesyncRealCF = hrp.CFrame end
            else
                flyPos = hrp.Position
            end
        end)
        addConnection(V.DesyncFlyConn)
    end)
end

function stopDesyncFly()
    V.DesyncFly = false
    if V.DesyncFlyConn then
        pcall(function() V.DesyncFlyConn:Disconnect() end)
        V.DesyncFlyConn = nil
    end
    if V.DesyncFlyNoclipConn then
        pcall(function() V.DesyncFlyNoclipConn:Disconnect() end)
        V.DesyncFlyNoclipConn = nil
    end
    pcall(function()
        local char = getCharacter()
        setDesyncFlyTransparency(char, false)
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if hrp then
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        if char and not V.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end

function enableNoAnim()
    V.NoAnim = true
    local char = getCharacter()
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        if not V.OrigAnim then
            V.OrigAnim = animate:Clone()
        end
        animate:Destroy()
    end

    if V.NoAnimConn then V.NoAnimConn:Disconnect() V.NoAnimConn = nil end
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

    local char = LocalPlayer.Character or getCharacter()
    if char then
        local animate = char:FindFirstChild("Animate")
        if not animate and V.OrigAnim then
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
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera or Camera
        if cam then
            cam.CameraType = Enum.CameraType.Custom
            if hum then
                cam.CameraSubject = hum
            end
        end
    end)
    notify("Spectate","Spectate OFF", Color3.fromRGB(255, 90, 90))
end
_G.stopSpectate = stopSpectate

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


movementConn = RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if V and V.GhostDesync and _G.ensureGhostDesyncRestored then _G.ensureGhostDesyncRestored() end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp or humanoid.Health <= 0 then return end
        if humanoid.SeatPart or humanoid.Sit then return end

        if V.Freecam then
            humanoid.WalkSpeed = 0
            if humanoid.UseJumpPower then
                humanoid.JumpPower = 0
            else
                humanoid.JumpHeight = 0
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
            return
        end

        if not UserInputService:GetFocusedTextBox() and not V.Fly and not V.DesyncFly then
            local isZ = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
            local isS = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
            local isQ = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
            local isD = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)

            if isZ or isS or isQ or isD then
                local fwd = (isZ and -1 or 0) + (isS and 1 or 0)
                local side = (isD and 1 or 0) + (isQ and -1 or 0)
                local moveVec = Vector3.new(side, 0, fwd)
                if moveVec.Magnitude > 0 then
                    humanoid:Move(moveVec.Unit, true)
                end
            end
        end

        if V.JumpEnabled and V.Jump and V.Jump > 0 then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = V.Jump
        end

        if V.SpeedEnabled and V.Speed and V.Speed > 16 then
            local currentSpeed = V.Speed
            local method = V.SpeedMethod or "Anti-TP CFrame (Recommandé)"

            if humanoid.MoveDirection.Magnitude > 0.05 then
                local moveVec = humanoid.MoveDirection.Unit
                local yVel = hrp.AssemblyLinearVelocity.Y

                if method == "Anti-TP CFrame (Recommandé)" or method == "Velocity" or method == "CFrame (Bypass)" or method == "CFrame" then
                    hrp.AssemblyLinearVelocity = Vector3.new(moveVec.X * currentSpeed, yVel, moveVec.Z * currentSpeed)
                    
                    local baseWS = _OrigWalkSpeed or (getBaseWalkSpeed and getBaseWalkSpeed(humanoid)) or 16
                    if humanoid.WalkSpeed ~= baseWS and not V.VelocitySpoof then
                        humanoid.WalkSpeed = baseWS
                    end
                elseif method == "Humanoid" then
                    humanoid.WalkSpeed = currentSpeed
                elseif method == "VectorForce" then
                    hrp.AssemblyLinearVelocity = moveVec * (currentSpeed * 1.5)
                end
            else
                local yVel = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = Vector3.new(0, yVel, 0)
                local baseWS = _OrigWalkSpeed or (getBaseWalkSpeed and getBaseWalkSpeed(humanoid)) or 16
                if method == "Humanoid" and not V.VelocitySpoof and humanoid.WalkSpeed ~= baseWS then
                    humanoid.WalkSpeed = baseWS
                end
            end
        end

        local isClimbForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
        local isClimbBackward = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
        local isClimbLeft = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
        local isClimbRight = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)

        if V.WallClimb then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude

            local fwdLook = hrp.CFrame.LookVector
            local checkOffsets = {Vector3.new(0, 0, 0), Vector3.new(0, 1.2, 0), Vector3.new(0, -1.2, 0)}
            local hitWallNormal = nil

            for _, offset in ipairs(checkOffsets) do
                local res = workspace:Raycast(hrp.Position + offset, fwdLook * 2.8, rayParams)
                if res and res.Instance and res.Instance.CanCollide and math.abs(res.Normal.Y) < 0.4 then
                    hitWallNormal = res.Normal
                    break
                end
            end

            if hitWallNormal then
                local _, currentYaw, _ = hrp.CFrame:ToOrientation()
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, currentYaw, 0)

                humanoid.PlatformStand = false
                humanoid.Sit = false

                local climbSpeed = (V.Speed and V.Speed > 16) and V.Speed or 32
                local wallRight = Vector3.new(0, 1, 0):Cross(hitWallNormal).Unit

                local climbVelY = 0
                if isClimbForward then
                    climbVelY = climbSpeed
                elseif isClimbBackward then
                    climbVelY = -climbSpeed
                end

                local climbVelX = 0
                local climbVelZ = 0
                if isClimbLeft then
                    local sideMove = -wallRight * (climbSpeed * 0.8)
                    climbVelX = climbVelX + sideMove.X
                    climbVelZ = climbVelZ + sideMove.Z
                elseif isClimbRight then
                    local sideMove = wallRight * (climbSpeed * 0.8)
                    climbVelX = climbVelX + sideMove.X
                    climbVelZ = climbVelZ + sideMove.Z
                end

                local stickForce = -Vector3.new(hitWallNormal.X, 0, hitWallNormal.Z).Unit * 3.5

                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    hrp.AssemblyLinearVelocity = Vector3.new(hitWallNormal.X * 28, 55, hitWallNormal.Z * 28)
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                else
                    if climbVelY ~= 0 or climbVelX ~= 0 or climbVelZ ~= 0 then
                        hrp.AssemblyLinearVelocity = Vector3.new(stickForce.X + climbVelX, climbVelY, stickForce.Z + climbVelZ)
                        humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                    else
                        hrp.AssemblyLinearVelocity = Vector3.new(stickForce.X, 0.15, stickForce.Z)
                        humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
                    end
                end
            else
                if humanoid:GetState() == Enum.HumanoidStateType.Climbing then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
                local _, cy, _ = hrp.CFrame:ToOrientation()
                if math.abs(hrp.CFrame.LookVector.Y) > 0.15 or math.abs(hrp.CFrame.UpVector.Y - 1) > 0.05 then
                    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, cy, 0)
                end
            end
        end
    end)
end)
addConnection(movementConn)

antiRagdollCharConn = nil
antiRagdollStateConn = nil

local function enforceAntiRagdollOnChar(char)
    if not char then return end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            if hum.PlatformStand and not (V.Fly or V.DesyncFly) then
                hum.PlatformStand = false
            end
        end

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then
                obj.Enabled = true
            elseif obj:IsA("BallSocketConstraint") and (obj.Name:lower():find("ragdoll") or obj.Name:lower():find("joint") or obj.Name:lower():find("fall")) then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("BoolValue") then
                local n = obj.Name:lower()
                if n:find("ragdoll") or n:find("stun") or n:find("knocked") or n:find("fall") or n:find("down") or n:find("rag") then
                    if obj.Value == true then obj.Value = false end
                end
            end
        end
    end)
end

function toggleAntiRagdoll(enabled)
    V.AntiRagdoll = enabled
    pcall(function()
        if V.AntiRagdollConn then V.AntiRagdollConn:Disconnect() V.AntiRagdollConn = nil end
        if antiRagdollCharConn then antiRagdollCharConn:Disconnect() antiRagdollCharConn = nil end
        if antiRagdollStateConn then antiRagdollStateConn:Disconnect() antiRagdollStateConn = nil end

        if enabled then
            local char = LocalPlayer.Character
            enforceAntiRagdollOnChar(char)

            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                antiRagdollStateConn = hum.StateChanged:Connect(function(oldState, newState)
                    if not V.AntiRagdoll then return end
                    if newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then
                        pcall(function()
                            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end)
                    end
                end)
                addConnection(antiRagdollStateConn)
            end

            -- Verification legere sans bloquer le moteur physique
            local timer = 0
            V.AntiRagdollConn = RunService.Heartbeat:Connect(function(dt)
                if not V.AntiRagdoll then return end
                timer = timer + dt
                if timer < 0.2 then return end
                timer = 0

                pcall(function()
                    local c = LocalPlayer.Character
                    if not c then return end
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then
                        if h.PlatformStand and not (V.Fly or V.DesyncFly or V.SuperJumpCharge) then
                            h.PlatformStand = false
                            h:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                        local st = h:GetState()
                        if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                            h:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end

                    for _, child in ipairs(c:GetDescendants()) do
                        if child:IsA("Motor6D") and not child.Enabled then
                            child.Enabled = true
                        elseif child:IsA("BallSocketConstraint") and (child.Name:lower():find("ragdoll") or child.Name:lower():find("joint") or child.Name:lower():find("fall")) then
                            pcall(function() child:Destroy() end)
                        elseif child:IsA("BoolValue") then
                            local n = child.Name:lower()
                            if n:find("ragdoll") or n:find("stun") or n:find("knocked") or n:find("down") or n:find("rag") then
                                if child.Value == true then child.Value = false end
                            end
                        end
                    end
                end)
            end)
            addConnection(V.AntiRagdollConn)

            antiRagdollCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
                if V.AntiRagdoll then
                    task.wait(0.3)
                    enforceAntiRagdollOnChar(newChar)
                    local newHum = newChar:WaitForChild("Humanoid", 3) or newChar:FindFirstChildOfClass("Humanoid")
                    if newHum then
                        if antiRagdollStateConn then antiRagdollStateConn:Disconnect() end
                        antiRagdollStateConn = newHum.StateChanged:Connect(function(oldState, newState)
                            if not V.AntiRagdoll then return end
                            if newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then
                                pcall(function()
                                    newHum:ChangeState(Enum.HumanoidStateType.GettingUp)
                                end)
                            end
                        end)
                        addConnection(antiRagdollStateConn)
                    end
                end
            end)
            addConnection(antiRagdollCharConn)

            notify("Protection", "Anti-Ragdoll ON", Color3.fromRGB(80, 200, 120))
        else
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                end)
            end
            notify("Protection", "Anti-Ragdoll OFF", Color3.fromRGB(255, 90, 90))
        end
    end)
end
_G.toggleAntiRagdoll = toggleAntiRagdoll

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

local _FPSBoostCache = {
    Parts = {},
    Decals = {},
    Effects = {},
    Lighting = {},
    Terrain = {}
}

function applyFPSBoost(obj)
    if not V.FPSBoost then return end
    pcall(function()
        if obj:IsA("BasePart") then
            if not _FPSBoostCache.Parts[obj] then
                _FPSBoostCache.Parts[obj] = {
                    Material = obj.Material,
                    Reflectance = obj.Reflectance,
                    CastShadow = obj.CastShadow
                }
            end
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if not _FPSBoostCache.Decals[obj] then
                _FPSBoostCache.Decals[obj] = obj.Transparency
            end
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") or obj:IsA("Highlight") or obj:IsA("PostEffect") then
            if not _FPSBoostCache.Effects[obj] then
                _FPSBoostCache.Effects[obj] = obj.Enabled
            end
            obj.Enabled = false
        end
    end)
end

function toggleFPSBooster(enabled)
    V.FPSBoost = enabled
    if enabled then
        -- 1. Sauvegarde du Lighting sans toucher a la distance de rendu (Render Distance preservee a 100%)
        _FPSBoostCache.Lighting.GlobalShadows = Lighting.GlobalShadows
        Lighting.GlobalShadows = false

        -- 2. Sauvegarde et optimisation du Terrain (Eau & Herbe volumetrique)
        local terr = workspace:FindFirstChildOfClass("Terrain")
        if terr then
            _FPSBoostCache.Terrain = {
                WaterWaveSize = terr.WaterWaveSize,
                WaterWaveSpeed = terr.WaterWaveSpeed,
                WaterReflectance = terr.WaterReflectance,
                WaterTransparency = terr.WaterTransparency,
                Decoration = terr.Decoration
            }
            pcall(function()
                terr.WaterWaveSize = 0
                terr.WaterWaveSpeed = 0
                terr.WaterReflectance = 0
                terr.WaterTransparency = 0
                terr.Decoration = false
            end)
        end

        -- 3. Application massive sur toute la map et le Lighting
        for _, obj in ipairs(workspace:GetDescendants()) do
            applyFPSBoost(obj)
        end
        for _, obj in ipairs(Lighting:GetChildren()) do
            applyFPSBoost(obj)
        end

        -- 4. Ecouteurs d'ajouts dynamiques
        if V.FPSBoost1 then V.FPSBoost1:Disconnect() end
        if V.FPSBoost2 then V.FPSBoost2:Disconnect() end
        V.FPSBoost1 = workspace.DescendantAdded:Connect(function(obj)
            applyFPSBoost(obj)
        end)
        V.FPSBoost2 = Lighting.ChildAdded:Connect(function(obj)
            applyFPSBoost(obj)
        end)

        notify("Server", "FPS Booster Ultra ON (Distance intacte)", Color3.fromRGB(80, 200, 120))
    else
        -- Deconnexion des ecouteurs
        if V.FPSBoost1 then V.FPSBoost1:Disconnect() V.FPSBoost1 = nil end
        if V.FPSBoost2 then V.FPSBoost2:Disconnect() V.FPSBoost2 = nil end

        -- Restauration exacte de toutes les parties
        for obj, data in pairs(_FPSBoostCache.Parts) do
            if obj and obj.Parent then
                pcall(function()
                    obj.Material = data.Material
                    obj.Reflectance = data.Reflectance
                    obj.CastShadow = data.CastShadow
                end)
            end
        end

        -- Restauration des Decals et Textures
        for obj, origTrans in pairs(_FPSBoostCache.Decals) do
            if obj and obj.Parent then
                pcall(function()
                    obj.Transparency = origTrans
                end)
            end
        end

        -- Restauration des particules et effets
        for obj, origEnabled in pairs(_FPSBoostCache.Effects) do
            if obj and obj.Parent then
                pcall(function()
                    obj.Enabled = origEnabled
                end)
            end
        end

        -- Restauration du Terrain
        local terr = workspace:FindFirstChildOfClass("Terrain")
        if terr and _FPSBoostCache.Terrain.Decoration ~= nil then
            pcall(function()
                terr.WaterWaveSize = _FPSBoostCache.Terrain.WaterWaveSize
                terr.WaterWaveSpeed = _FPSBoostCache.Terrain.WaterWaveSpeed
                terr.WaterReflectance = _FPSBoostCache.Terrain.WaterReflectance
                terr.WaterTransparency = _FPSBoostCache.Terrain.WaterTransparency
                terr.Decoration = _FPSBoostCache.Terrain.Decoration
            end)
        end

        -- Restauration du Lighting
        if _FPSBoostCache.Lighting.GlobalShadows ~= nil then
            Lighting.GlobalShadows = _FPSBoostCache.Lighting.GlobalShadows
        else
            Lighting.GlobalShadows = true
        end

        _FPSBoostCache.Parts = {}
        _FPSBoostCache.Decals = {}
        _FPSBoostCache.Effects = {}
        _FPSBoostCache.Lighting = {}
        _FPSBoostCache.Terrain = {}

        notify("Server", "FPS Booster OFF (Monde restaure)", Color3.fromRGB(255, 90, 90))
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
ESPGui.Name = "PearlESP"
ESPGui.ResetOnSpawn = false
ESPGui.DisplayOrder = 100
ESPGui.IgnoreGuiInset = true
ESPGui.Enabled = false
ESPGui.Parent = parentTarget

if VehicleESPGui then pcall(function() VehicleESPGui:Destroy() end) end
VehicleESPGui = Instance.new("ScreenGui")
VehicleESPGui.Name = "PearlVehicleESP"
VehicleESPGui.ResetOnSpawn = false
VehicleESPGui.DisplayOrder = 99
VehicleESPGui.IgnoreGuiInset = true
VehicleESPGui.Enabled = false
VehicleESPGui.Parent = parentTarget

function clearESP()
    for player, obj in pairs(V.ESPObjects) do
        if obj.conn then obj.conn:Disconnect() end
        if obj.box then obj.box:Destroy() end
        if obj.nameLabel then obj.nameLabel:Destroy() end
        if obj.distLabel then obj.distLabel:Destroy() end
        if obj.highlight then obj.highlight:Destroy() end
        if obj.healthBg then obj.healthBg:Destroy() end
        if obj.healthPvText then obj.healthPvText:Destroy() end
        if obj.weaponLabel then obj.weaponLabel:Destroy() end
        if obj.skeletonFolder then obj.skeletonFolder:Destroy() end
        if obj.skeletonHead then obj.skeletonHead:Destroy() end
        if obj.tracerLine then obj.tracerLine:Destroy() end
    end
    V.ESPObjects = {}
end

function createESPForCharacter(charInstance, customName)
    if not charInstance or V.ESPObjects[charInstance] then return end
    if charInstance == LocalPlayer.Character and not V.ESPSelf then return end

    local box = Instance.new("Frame")
    box.Visible = false
    box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = ESPGui

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Thickness = 1.5
    boxStroke.Parent = box

    local corners = {}
    for i = 1, 8 do
        local cLine = Instance.new("Frame")
        cLine.BorderSizePixel = 0
        cLine.Visible = false
        cLine.ZIndex = 5
        cLine.Parent = box
        table.insert(corners, cLine)
    end

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

    local healthPvText = Instance.new("TextLabel")
    healthPvText.Visible = false
    healthPvText.BackgroundTransparency = 1
    healthPvText.Font = Enum.Font.GothamBold
    healthPvText.TextSize = 10
    healthPvText.TextStrokeTransparency = 0
    healthPvText.TextColor3 = Color3.fromRGB(0, 230, 120)
    healthPvText.Parent = ESPGui

    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Visible = false
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Font = Enum.Font.GothamMedium
    weaponLabel.TextSize = 11
    weaponLabel.TextStrokeTransparency = 0
    weaponLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
    weaponLabel.Parent = ESPGui

    local skeletonFolder = Instance.new("Folder")
    skeletonFolder.Name = "SkeletonLines_" .. (customName or charInstance.Name)
    skeletonFolder.Parent = ESPGui

    local skeletonHead = Instance.new("Frame")
    skeletonHead.Name = "SkeletonHead"
    skeletonHead.AnchorPoint = Vector2.new(0.5, 0.5)
    skeletonHead.BackgroundTransparency = 1
    skeletonHead.BorderSizePixel = 0
    skeletonHead.Visible = false
    skeletonHead.Parent = ESPGui
    local skeletonHeadStroke = Instance.new("UIStroke")
    skeletonHeadStroke.Color = V.ESPColor
    skeletonHeadStroke.Thickness = V.ESPSkeletonThickness or 1.5
    skeletonHeadStroke.Parent = skeletonHead
    local skeletonHeadCorner = Instance.new("UICorner")
    skeletonHeadCorner.CornerRadius = UDim.new(1, 0)
    skeletonHeadCorner.Parent = skeletonHead

    local tracerLine = Instance.new("Frame")
    tracerLine.Visible = false
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = V.ESPColor
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.Parent = ESPGui

    V.ESPObjects[charInstance] = {
        box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight,
        healthBg = healthBg, healthBar = healthBar, healthPvText = healthPvText, weaponLabel = weaponLabel,
        skeletonFolder = skeletonFolder, skeletonHead = skeletonHead, skeletonHeadStroke = skeletonHeadStroke, tracerLine = tracerLine
    }

    local conn = RunService.RenderStepped:Connect(function()
        local char = charInstance
        if not char or not char.Parent or not V.ESP then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            healthPvText.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            skeletonHead.Visible = false
            tracerLine.Visible = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
        local head = char:FindFirstChild("Head") or hrp
        local hum = char:FindFirstChildOfClass("Humanoid")
        local localChar = LocalPlayer.Character
        local localRoot = localChar and (localChar:FindFirstChild("HumanoidRootPart") or localChar:FindFirstChildWhichIsA("BasePart"))
        local targetRoot = hrp or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
        if not targetRoot or not localRoot then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            healthPvText.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            skeletonHead.Visible = false
            tracerLine.Visible = false
            return
        end

        local rootPart = hrp or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
        local resolvedPos = (hrp and hrp.Position) or (rootPart and rootPart.Position) or Vector3.zero
        local resolvedHeadPos = (head and head.Position) or (resolvedPos + Vector3.new(0, 1.5, 0))



        local localHrp = localChar.HumanoidRootPart
        local dist = (localHrp.Position - resolvedPos).Magnitude

        local screenPos, onScreen = Camera:WorldToViewportPoint(resolvedPos)
        if not onScreen or screenPos.Z <= 0.5 then
            box.Visible = false
            for _, c in ipairs(corners) do c.Visible = false end
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            healthPvText.Visible = false
            weaponLabel.Visible = false
            if skeletonFolder then
                for _, child in ipairs(skeletonFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            if skeletonHead then skeletonHead.Visible = false end
            tracerLine.Visible = false
            return
        end

        local vp = Camera.ViewportSize
        local depth = math.max(screenPos.Z, 1)
        local fovRad = math.rad(math.clamp(Camera.FieldOfView, 10, 120))
        local projectedHeight = (5.8 / (2 * depth * math.tan(fovRad / 2))) * vp.Y

        local headPos = Camera:WorldToViewportPoint(resolvedHeadPos + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(resolvedPos - Vector3.new(0, 3, 0))
        
        local rawHeight
        if headPos.Z > 0.5 and legPos.Z > 0.5 then
            rawHeight = math.abs(headPos.Y - legPos.Y)
            if rawHeight > projectedHeight * 2.2 or rawHeight < projectedHeight * 0.4 then
                rawHeight = projectedHeight
            end
        else
            rawHeight = projectedHeight
        end

        local maxHeight = math.floor(vp.Y * 0.75)
        local height = math.clamp(rawHeight, 14, maxHeight)
        local width = math.clamp(height / 2.2, 8, math.floor(vp.X * 0.55))

        local boxVisible = V.ESPBox or V.ESPFilled or V.ESPCornerBox
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

            if V.ESPCornerBox then
                local cLen = math.clamp(math.floor(width * 0.28), 4, 18)
                corners[1].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[1].Position = UDim2.new(0, 0, 0, 0)
                corners[2].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[2].Position = UDim2.new(0, 0, 0, 0)

                corners[3].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[3].Position = UDim2.new(1, -cLen, 0, 0)
                corners[4].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[4].Position = UDim2.new(1, -1.5, 0, 0)

                corners[5].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[5].Position = UDim2.new(0, 0, 1, -1.5)
                corners[6].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[6].Position = UDim2.new(0, 0, 1, -cLen)

                corners[7].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[7].Position = UDim2.new(1, -cLen, 1, -1.5)
                corners[8].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[8].Position = UDim2.new(1, -1.5, 1, -cLen)

                for _, c in ipairs(corners) do
                    c.BackgroundColor3 = V.ESPColor
                    c.Visible = true
                end
            else
                for _, c in ipairs(corners) do c.Visible = false end
            end
        else
            box.Visible = false
            for _, c in ipairs(corners) do c.Visible = false end
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
            nameLabel.Text = customName or char.Name
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

        if V.ESPHealth and hum then
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

        if V.ESPPV and hum then
            healthPvText.Visible = true
            local curHp = math.floor(hum.Health + 0.5)
            local maxHp = math.max(hum.MaxHealth, 1)
            local hpRatio = math.clamp(curHp / maxHp, 0, 1)
            healthPvText.Text = tostring(curHp) .. " PV"
            healthPvText.Size = UDim2.new(0, 48, 0, 14)
            healthPvText.Position = UDim2.new(0, screenPos.X - width/2 - 28, 0, screenPos.Y + height/2 + 2)
            healthPvText.TextColor3 = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 60)
        else
            healthPvText.Visible = false
        end

        if (V.ESPPV or HealthPV_Enabled) and hum and (V.ESPHealth or V.ESP) then
            healthPvText.Visible = true
            local curHp = math.max(0, math.floor(hum.Health))
            healthPvText.Text = curHp .. " PV"
            healthPvText.Size = UDim2.new(0, 48, 0, 14)
            healthPvText.Position = UDim2.new(0, screenPos.X - width/2 - 28, 0, screenPos.Y + height/2 + 2)
            local hpRatio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            healthPvText.TextColor3 = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 60)
        else
            healthPvText.Visible = false
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

        if V.ESPSkeleton and hum and onScreen and screenPos.Z > 0 then
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
            local vp = Camera.ViewportSize
            
            for _, pair in ipairs(joints) do
                local p1Part = char:FindFirstChild(pair[1])
                local p2Part = char:FindFirstChild(pair[2])
                if p1Part and p2Part then
                    local p1Pos, onScreen1 = Camera:WorldToViewportPoint(p1Part.Position)
                    local p2Pos, onScreen2 = Camera:WorldToViewportPoint(p2Part.Position)
                    if onScreen1 and onScreen2 and p1Pos.Z > 0 and p2Pos.Z > 0 then
                        if p1Pos.X >= 0 and p1Pos.X <= vp.X and p1Pos.Y >= 0 and p1Pos.Y <= vp.Y and
                           p2Pos.X >= 0 and p2Pos.X <= vp.X and p2Pos.Y >= 0 and p2Pos.Y <= vp.Y then
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
                            line.Size = UDim2.new(0, distance, 0, V.ESPSkeletonThickness or 1.5)
                            line.Position = UDim2.new(0, (p1Pos.X + p2Pos.X) / 2, 0, (p1Pos.Y + p2Pos.Y) / 2)
                            line.Rotation = math.deg(angle)
                            line.Visible = true
                        end
                    end
                end
            end
            
            for i = lineIdx + 1, #existingLines do
                existingLines[i].Visible = false
            end
            local headPart = char:FindFirstChild("Head")
            if headPart then
                local headPos, hOnScreen = Camera:WorldToViewportPoint(headPart.Position)
                if hOnScreen and headPos.Z > 0 and headPos.X >= 0 and headPos.X <= vp.X and headPos.Y >= 0 and headPos.Y <= vp.Y then
                    local topPos = Camera:WorldToViewportPoint(headPart.Position + Vector3.new(0, headPart.Size.Y * 0.5, 0))
                    local botPos = Camera:WorldToViewportPoint(headPart.Position - Vector3.new(0, headPart.Size.Y * 0.5, 0))
                    local diam = math.clamp(math.abs(botPos.Y - topPos.Y) * 1.15, 6, 60)
                    skeletonHead.Size = UDim2.new(0, diam, 0, diam)
                    skeletonHead.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
                    skeletonHeadStroke.Color = V.ESPColor
                    skeletonHeadStroke.Thickness = V.ESPSkeletonThickness or 1.5
                    skeletonHead.Visible = true
                else
                    skeletonHead.Visible = false
                end
            else
                skeletonHead.Visible = false
            end
        else
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
            skeletonHead.Visible = false
        end

        if V.ESPTracer and onScreen and screenPos.Z > 0 then
            local vp = Camera.ViewportSize
            local originPos = Vector2.new(vp.X / 2, vp.Y)
            if V.ESPTracerOrigin =="Center"then
                originPos = Vector2.new(vp.X / 2, vp.Y / 2)
            elseif V.ESPTracerOrigin =="Mouse"then
                originPos = UserInputService:GetMouseLocation()
            end
            local targetPos = Vector2.new(screenPos.X, screenPos.Y)
            if targetPos.X >= 0 and targetPos.X <= vp.X and targetPos.Y >= 0 and targetPos.Y <= vp.Y then
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
        else
            tracerLine.Visible = false
        end
    end)
    V.ESPObjects[charInstance].conn = conn
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

    local corners = {}
    for i = 1, 8 do
        local cLine = Instance.new("Frame")
        cLine.BorderSizePixel = 0
        cLine.Visible = false
        cLine.ZIndex = 5
        cLine.Parent = box
        table.insert(corners, cLine)
    end

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

    local healthPvText = Instance.new("TextLabel")
    healthPvText.Visible = false
    healthPvText.BackgroundTransparency = 1
    healthPvText.Font = Enum.Font.GothamBold
    healthPvText.TextSize = 10
    healthPvText.TextStrokeTransparency = 0
    healthPvText.TextColor3 = Color3.fromRGB(0, 230, 120)
    healthPvText.Parent = ESPGui

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

    local skeletonHead = Instance.new("Frame")
    skeletonHead.Name = "SkeletonHead"
    skeletonHead.AnchorPoint = Vector2.new(0.5, 0.5)
    skeletonHead.BackgroundTransparency = 1
    skeletonHead.BorderSizePixel = 0
    skeletonHead.Visible = false
    skeletonHead.Parent = ESPGui
    local skeletonHeadStroke = Instance.new("UIStroke")
    skeletonHeadStroke.Color = V.ESPColor
    skeletonHeadStroke.Thickness = V.ESPSkeletonThickness or 1.5
    skeletonHeadStroke.Parent = skeletonHead
    local skeletonHeadCorner = Instance.new("UICorner")
    skeletonHeadCorner.CornerRadius = UDim.new(1, 0)
    skeletonHeadCorner.Parent = skeletonHead

    local tracerLine = Instance.new("Frame")
    tracerLine.Visible = false
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = V.ESPColor
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.Parent = ESPGui

    V.ESPObjects[player] = {
        box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight,
        healthBg = healthBg, healthBar = healthBar, healthPvText = healthPvText, weaponLabel = weaponLabel,
        skeletonFolder = skeletonFolder, skeletonHead = skeletonHead, skeletonHeadStroke = skeletonHeadStroke, tracerLine = tracerLine
    }

    local conn = RunService.RenderStepped:Connect(function()
        local char = player.Character
        local isTeam = false
        if V.ESPTeamCheck and player ~= LocalPlayer then
            if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                isTeam = true
            elseif player.TeamColor and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then
                isTeam = true
            end
        end
        if not char or not V.ESP or isTeam then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            if healthPvText then healthPvText.Visible = false end
            weaponLabel.Visible = false
            if skeletonFolder then
                for _, child in ipairs(skeletonFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            if skeletonHead then skeletonHead.Visible = false end
            if tracerLine then tracerLine.Visible = false end
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local localChar = LocalPlayer.Character
        local localRoot = localChar and (localChar:FindFirstChild("HumanoidRootPart") or localChar:FindFirstChildWhichIsA("BasePart"))
        local targetRoot = hrp or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
        if not targetRoot or not localRoot then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            if healthPvText then healthPvText.Visible = false end
            weaponLabel.Visible = false
            if skeletonFolder then
                for _, child in ipairs(skeletonFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            if skeletonHead then skeletonHead.Visible = false end
            if tracerLine then tracerLine.Visible = false end
            return
        end

        local rootPart = hrp or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
        local resolvedPos = (hrp and hrp.Position) or (rootPart and rootPart.Position) or Vector3.zero
        local resolvedHeadPos = (head and head.Position) or (resolvedPos + Vector3.new(0, 1.5, 0))



        local localHrp = localChar.HumanoidRootPart
        local dist = (localHrp.Position - resolvedPos).Magnitude

        local screenPos, onScreen = Camera:WorldToViewportPoint(resolvedPos)
        if not onScreen or screenPos.Z <= 0.5 then
            box.Visible = false
            for _, c in ipairs(corners) do c.Visible = false end
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            if healthPvText then healthPvText.Visible = false end
            weaponLabel.Visible = false
            if skeletonFolder then
                for _, child in ipairs(skeletonFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            if skeletonHead then skeletonHead.Visible = false end
            tracerLine.Visible = false
            return
        end

        local vp = Camera.ViewportSize
        local depth = math.max(screenPos.Z, 1)
        local fovRad = math.rad(math.clamp(Camera.FieldOfView, 10, 120))
        local projectedHeight = (5.8 / (2 * depth * math.tan(fovRad / 2))) * vp.Y

        local headPos = Camera:WorldToViewportPoint(resolvedHeadPos + Vector3.new(0, 0.5, 0))
        local legPos = Camera:WorldToViewportPoint(resolvedPos - Vector3.new(0, 3, 0))
        
        local rawHeight
        if headPos.Z > 0.5 and legPos.Z > 0.5 then
            rawHeight = math.abs(headPos.Y - legPos.Y)
            if rawHeight > projectedHeight * 2.2 or rawHeight < projectedHeight * 0.4 then
                rawHeight = projectedHeight
            end
        else
            rawHeight = projectedHeight
        end

        local maxHeight = math.floor(vp.Y * 0.75)
        local height = math.clamp(rawHeight, 14, maxHeight)
        local width = math.clamp(height / 2.2, 8, math.floor(vp.X * 0.55))

        local boxVisible = V.ESPBox or V.ESPFilled or V.ESPCornerBox
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

            if V.ESPCornerBox then
                local cLen = math.clamp(math.floor(width * 0.28), 4, 18)
                corners[1].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[1].Position = UDim2.new(0, 0, 0, 0)
                corners[2].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[2].Position = UDim2.new(0, 0, 0, 0)

                corners[3].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[3].Position = UDim2.new(1, -cLen, 0, 0)
                corners[4].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[4].Position = UDim2.new(1, -1.5, 0, 0)

                corners[5].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[5].Position = UDim2.new(0, 0, 1, -1.5)
                corners[6].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[6].Position = UDim2.new(0, 0, 1, -cLen)

                corners[7].Size = UDim2.new(0, cLen, 0, 1.5)
                corners[7].Position = UDim2.new(1, -cLen, 1, -1.5)
                corners[8].Size = UDim2.new(0, 1.5, 0, cLen)
                corners[8].Position = UDim2.new(1, -1.5, 1, -cLen)

                for _, c in ipairs(corners) do
                    c.BackgroundColor3 = V.ESPColor
                    c.Visible = true
                end
            else
                for _, c in ipairs(corners) do c.Visible = false end
            end
        else
            box.Visible = false
            for _, c in ipairs(corners) do c.Visible = false end
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

        if (V.ESPPV or HealthPV_Enabled) and hum then
            healthPvText.Visible = true
            local curHp = math.floor(hum.Health + 0.5)
            local maxHp = math.max(hum.MaxHealth, 1)
            local hpRatio = math.clamp(curHp / maxHp, 0, 1)
            healthPvText.Text = tostring(curHp) .. " PV"
            healthPvText.Size = UDim2.new(0, 48, 0, 14)
            healthPvText.Position = UDim2.new(0, screenPos.X - width/2 - 28, 0, screenPos.Y + height/2 + 2)
            healthPvText.TextColor3 = Color3.fromRGB(math.floor(255 * (1 - hpRatio)), math.floor(255 * hpRatio), 60)
        else
            healthPvText.Visible = false
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

        if V.ESPSkeleton and hum and onScreen and screenPos.Z > 0 then
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
            local vp = Camera.ViewportSize
            
            for _, pair in ipairs(joints) do
                local p1Part = char:FindFirstChild(pair[1])
                local p2Part = char:FindFirstChild(pair[2])
                if p1Part and p2Part then
                    local p1Pos, onScreen1 = Camera:WorldToViewportPoint(p1Part.Position)
                    local p2Pos, onScreen2 = Camera:WorldToViewportPoint(p2Part.Position)
                    if onScreen1 and onScreen2 and p1Pos.Z > 0 and p2Pos.Z > 0 then
                        if p1Pos.X >= 0 and p1Pos.X <= vp.X and p1Pos.Y >= 0 and p1Pos.Y <= vp.Y and
                           p2Pos.X >= 0 and p2Pos.X <= vp.X and p2Pos.Y >= 0 and p2Pos.Y <= vp.Y then
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
                            line.Size = UDim2.new(0, distance, 0, V.ESPSkeletonThickness or 1.5)
                            line.Position = UDim2.new(0, (p1Pos.X + p2Pos.X) / 2, 0, (p1Pos.Y + p2Pos.Y) / 2)
                            line.Rotation = math.deg(angle)
                            line.Visible = true
                        end
                    end
                end
            end
            
            for i = lineIdx + 1, #existingLines do
                existingLines[i].Visible = false
            end
            local headPart = char:FindFirstChild("Head")
            if headPart then
                local headPos, hOnScreen = Camera:WorldToViewportPoint(headPart.Position)
                if hOnScreen and headPos.Z > 0 and headPos.X >= 0 and headPos.X <= vp.X and headPos.Y >= 0 and headPos.Y <= vp.Y then
                    local topPos = Camera:WorldToViewportPoint(headPart.Position + Vector3.new(0, headPart.Size.Y * 0.5, 0))
                    local botPos = Camera:WorldToViewportPoint(headPart.Position - Vector3.new(0, headPart.Size.Y * 0.5, 0))
                    local diam = math.clamp(math.abs(botPos.Y - topPos.Y) * 1.15, 6, 60)
                    skeletonHead.Size = UDim2.new(0, diam, 0, diam)
                    skeletonHead.Position = UDim2.new(0, headPos.X, 0, headPos.Y)
                    skeletonHeadStroke.Color = V.ESPColor
                    skeletonHeadStroke.Thickness = V.ESPSkeletonThickness or 1.5
                    skeletonHead.Visible = true
                else
                    skeletonHead.Visible = false
                end
            else
                skeletonHead.Visible = false
            end
        else
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
            skeletonHead.Visible = false
        end

        if V.ESPTracer and onScreen and screenPos.Z > 0 then
            local vp = Camera.ViewportSize
            local originPos = Vector2.new(vp.X / 2, vp.Y)
            if V.ESPTracerOrigin =="Center"then
                originPos = Vector2.new(vp.X / 2, vp.Y / 2)
            elseif V.ESPTracerOrigin =="Mouse"then
                originPos = UserInputService:GetMouseLocation()
            end
            local targetPos = Vector2.new(screenPos.X, screenPos.Y)
            if targetPos.X >= 0 and targetPos.X <= vp.X and targetPos.Y >= 0 and targetPos.Y <= vp.Y then
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
        else
            tracerLine.Visible = false
        end
    end)
    V.ESPObjects[player].conn = conn
end

function isNPCModel(model)
    if not model or not model:IsA("Model") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChild("Head")
    return (hum ~= nil and root ~= nil and hum.Health > 0)
end

function refreshESP()
    clearESP()
    if not V.ESP then return end
    for _, player in pairs(Players:GetPlayers()) do createESPForPlayer(player) end
    if V.ESPNPC then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if isNPCModel(obj) then
                createESPForCharacter(obj, "[NPC] " .. obj.Name)
            end
        end
    end
end

-- ==============================================================
-- [VEHICLE ESP : 3D BOX, NAME, DISTANCE, DRIVER & COLORS]
-- ==============================================================
V.VehicleESPObjects = V.VehicleESPObjects or {}

local VEHICLE_EDGE_PAIRS = {
    {1, 2}, {2, 3}, {3, 4}, {4, 1},
    {5, 6}, {6, 7}, {7, 8}, {8, 5},
    {1, 5}, {2, 6}, {3, 7}, {4, 8}
}

local function clearVehicleESP()
    if V.VehicleESPObjects then
        for veh, obj in pairs(V.VehicleESPObjects) do
            if obj.conn then pcall(function() obj.conn:Disconnect() end) end
            if obj.linesFolder then pcall(function() obj.linesFolder:Destroy() end) end
            if obj.topContainer then pcall(function() obj.topContainer:Destroy() end) end
        end
    end
    V.VehicleESPObjects = {}
    if VehicleESPGui then
        VehicleESPGui:ClearAllChildren()
    end
end
_G.clearVehicleESP = clearVehicleESP

local function createESPForVehicle(veh, seat)
    if not veh or not seat or (V.VehicleESPObjects and V.VehicleESPObjects[veh]) then return end
    V.VehicleESPObjects = V.VehicleESPObjects or {}

    local targetParent = VehicleESPGui or parentTarget
    local linesFolder = Instance.new("Folder")
    linesFolder.Name = "Veh3DBox_" .. tostring(veh.Name)
    linesFolder.Parent = targetParent

    local lines = {}
    for i = 1, 12 do
        local line = Instance.new("Frame")
        line.Name = "Edge_" .. i
        line.BorderSizePixel = 0
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = V.VehicleESPColor or Color3.fromRGB(145, 120, 255)
        line.Visible = false
        line.ZIndex = 8
        line.Parent = linesFolder
        table.insert(lines, line)
    end

    local topContainer = Instance.new("Frame")
    topContainer.Name = "VehTopInfo_" .. tostring(veh.Name)
    topContainer.AnchorPoint = Vector2.new(0.5, 1)
    topContainer.Size = UDim2.new(0, 160, 0, 48)
    topContainer.BackgroundTransparency = 1
    topContainer.BorderSizePixel = 0
    topContainer.Visible = false
    topContainer.ZIndex = 9
    topContainer.Parent = targetParent

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Vertical
    topLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    topLayout.SortOrder = Enum.SortOrder.LayoutOrder
    topLayout.Padding = UDim.new(0, 1)
    topLayout.Parent = topContainer

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = tostring(veh.Name)
    nameLabel.TextColor3 = V.VehicleESPColor or Color3.fromRGB(145, 120, 255)
    nameLabel.TextStrokeTransparency = 0.4
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextSize = 11.5
    nameLabel.LayoutOrder = 1
    nameLabel.Parent = topContainer

    local driverLabel = Instance.new("TextLabel")
    driverLabel.Name = "DriverLabel"
    driverLabel.Size = UDim2.new(1, 0, 0, 13)
    driverLabel.BackgroundTransparency = 1
    driverLabel.Font = Enum.Font.GothamMedium
    driverLabel.Text = "[Vide]"
    driverLabel.TextColor3 = Color3.fromRGB(160, 165, 180)
    driverLabel.TextStrokeTransparency = 0.4
    driverLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    driverLabel.TextSize = 10.5
    driverLabel.LayoutOrder = 2
    driverLabel.Parent = topContainer

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 12)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.Gotham
    distLabel.Text = "[0m]"
    distLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    distLabel.TextStrokeTransparency = 0.4
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.TextSize = 10
    distLabel.LayoutOrder = 3
    distLabel.Parent = topContainer

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not V.VehicleESP or not veh or not veh.Parent or not seat or not seat.Parent then
            if conn then conn:Disconnect() end
            if linesFolder then linesFolder:Destroy() end
            if topContainer then topContainer:Destroy() end
            if V.VehicleESPObjects then V.VehicleESPObjects[veh] = nil end
            return
        end

        local cf, size
        pcall(function()
            if veh:IsA("Model") then
                cf, size = veh:GetBoundingBox()
            else
                cf, size = seat.CFrame, seat.Size
            end
        end)
        if not cf or not size then return end

        local sx = math.max(size.X / 2, 2.5)
        local sy = math.max(size.Y / 2, 1.5)
        local sz = math.max(size.Z / 2, 3.5)

        local c1 = cf:PointToWorldSpace(Vector3.new( sx,  sy,  sz))
        local c2 = cf:PointToWorldSpace(Vector3.new(-sx,  sy,  sz))
        local c3 = cf:PointToWorldSpace(Vector3.new(-sx, -sy,  sz))
        local c4 = cf:PointToWorldSpace(Vector3.new( sx, -sy,  sz))
        local c5 = cf:PointToWorldSpace(Vector3.new( sx,  sy, -sz))
        local c6 = cf:PointToWorldSpace(Vector3.new(-sx,  sy, -sz))
        local c7 = cf:PointToWorldSpace(Vector3.new(-sx, -sy, -sz))
        local c8 = cf:PointToWorldSpace(Vector3.new( sx, -sy, -sz))
        local cornerPts = {c1, c2, c3, c4, c5, c6, c7, c8}

        local screenCorners = {}
        local anyOnScreen = false
        for idxCorner = 1, 8 do
            local sp, onScreen = Camera:WorldToViewportPoint(cornerPts[idxCorner])
            screenCorners[idxCorner] = { x = sp.X, y = sp.Y, z = sp.Z, on = onScreen }
            if onScreen and sp.Z > 0 then anyOnScreen = true end
        end

        local boxColor = V.VehicleESPColor or Color3.fromRGB(145, 120, 255)

        if anyOnScreen and V.VehicleESPBox3D then
            for idxEdge, pair in ipairs(VEHICLE_EDGE_PAIRS) do
                local p1 = screenCorners[pair[1]]
                local p2 = screenCorners[pair[2]]
                local lineFrame = lines[idxEdge]
                if p1 and p2 and p1.z > 0 and p2.z > 0 and (p1.on or p2.on) then
                    local dx = p2.x - p1.x
                    local dy = p2.y - p1.y
                    local len = math.sqrt(dx * dx + dy * dy)
                    local angle = math.atan2(dy, dx)
                    lineFrame.Size = UDim2.new(0, len, 0, 1.5)
                    lineFrame.Position = UDim2.new(0, (p1.x + p2.x) / 2, 0, (p1.y + p2.y) / 2)
                    lineFrame.Rotation = math.deg(angle)
                    lineFrame.BackgroundColor3 = boxColor
                    lineFrame.Visible = true
                else
                    if lineFrame then lineFrame.Visible = false end
                end
            end
        else
            for _, lineFrame in ipairs(lines) do
                lineFrame.Visible = false
            end
        end

        local topPos = cf.Position + Vector3.new(0, sy + 0.8, 0)
        local topScreen, topOn = Camera:WorldToViewportPoint(topPos)
        if topOn and topScreen.Z > 0 then
            local dist = math.floor((cf.Position - Camera.CFrame.Position).Magnitude)

            if V.VehicleESPName then
                nameLabel.Text = tostring(veh.Name)
                nameLabel.TextColor3 = boxColor
                nameLabel.Visible = true
            else
                nameLabel.Visible = false
            end

            if V.VehicleESPDist then
                distLabel.Text = "[" .. tostring(dist) .. "m]"
                distLabel.Visible = true
            else
                distLabel.Visible = false
            end

            if V.VehicleESPDriver then
                local occ = seat.Occupant
                if occ and occ.Parent then
                    local p = Players:GetPlayerFromCharacter(occ.Parent)
                    local driverName = p and ("@" .. p.Name) or occ.Parent.Name
                    driverLabel.Text = "Conducteur: " .. driverName
                    driverLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
                else
                    driverLabel.Text = "[Vide]"
                    driverLabel.TextColor3 = Color3.fromRGB(160, 165, 180)
                end
                driverLabel.Visible = true
            else
                driverLabel.Visible = false
            end

            topContainer.Position = UDim2.new(0, topScreen.X, 0, topScreen.Y)
            topContainer.Visible = (V.VehicleESPName or V.VehicleESPDist or V.VehicleESPDriver)
        else
            topContainer.Visible = false
        end
    end)

    V.VehicleESPObjects[veh] = {
        conn = conn,
        linesFolder = linesFolder,
        topContainer = topContainer
    }
end

local function scanAndCreateVehicleESP()
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                local veh = obj:FindFirstAncestorWhichIsA("Model") or obj
                if veh and not (V.VehicleESPObjects and V.VehicleESPObjects[veh]) then
                    createESPForVehicle(veh, obj)
                end
            end
        end
    end)
end
_G.scanAndCreateVehicleESP = scanAndCreateVehicleESP

task.spawn(function()
    while true do
        task.wait(1.5)
        if V.VehicleESP then
            scanAndCreateVehicleESP()
        end
        if V.ESP then
            for _, player in pairs(Players:GetPlayers()) do
                if not V.ESPObjects[player] then createESPForPlayer(player) end
            end
            if V.ESPNPC then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if isNPCModel(obj) and not V.ESPObjects[obj] then
                        createESPForCharacter(obj, "[NPC] " .. obj.Name)
                    end
                end
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
        if V.ESPObjects[p].healthPvText then V.ESPObjects[p].healthPvText:Destroy() end
        if V.ESPObjects[p].weaponLabel then V.ESPObjects[p].weaponLabel:Destroy() end
        if V.ESPObjects[p].skeletonFolder then V.ESPObjects[p].skeletonFolder:Destroy() end
        if V.ESPObjects[p].skeletonHead then V.ESPObjects[p].skeletonHead:Destroy() end
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
initStep = "cablage Information"
-- ==============================================================
-- [INFORMATIONS & STATUT DU SCRIPT]
-- ==============================================================
-- Change facilement le statut ici :
-- "FONCTIONNEL" = Point Vert (100% Operationnel)
-- "PROBLEMES"   = Point Jaune (Quelques problemes / instable)
-- "OFFLINE"     = Point Rouge (Ne marche pas / patche)
local SCRIPT_STATUS = "FONCTIONNEL"

do
    InformationContent.ScrollBarThickness = 3
    InformationContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    InformationContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    -- Fonction de copie multi-executors dediee au Discord
    local function safeSetClipboard(str)
        str = tostring(str)
        local fn = setclipboard 
            or toclipboard 
            or set_clipboard 
            or writeclipboard
            or (syn and syn.write_clipboard) 
            or (Clipboard and Clipboard.set)
        if not fn and getgenv then
            local g = getgenv()
            fn = g.setclipboard or g.toclipboard or g.set_clipboard or g.writeclipboard
        end
        if not fn and getfenv then
            local env = getfenv(0)
            fn = env.setclipboard or env.toclipboard or env.set_clipboard
        end
        if not fn and _G then
            fn = _G.setclipboard or _G.toclipboard
        end
        
        local success = false
        if fn then
            local ok = pcall(function() fn(str) end)
            if ok then success = true end
        end
        return success
    end

    createLabel("STATUT DU SCRIPT", InformationContent)

    -- Status Hero Card parfaitement centree
    local statusCard = createCard(InformationContent, 0, 64)

    -- 1. Onde radar dynamique (Expansion & Fade)
    local ping = Instance.new("Frame")
    ping.AnchorPoint = Vector2.new(0.5, 0.5)
    ping.Size = UDim2.new(0, 10, 0, 10)
    ping.Position = UDim2.new(0, 26, 0.5, 0)
    ping.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    ping.BackgroundTransparency = 0.35
    ping.BorderSizePixel = 0
    ping.ZIndex = 8
    ping.Parent = statusCard
    local pingCorner = Instance.new("UICorner") pingCorner.CornerRadius = UDim.new(1, 0) pingCorner.Parent = ping

    -- 2. Halo doux en arriere-plan
    local halo = Instance.new("Frame")
    halo.AnchorPoint = Vector2.new(0.5, 0.5)
    halo.Size = UDim2.new(0, 18, 0, 18)
    halo.Position = UDim2.new(0, 26, 0.5, 0)
    halo.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    halo.BackgroundTransparency = 0.75
    halo.BorderSizePixel = 0
    halo.ZIndex = 9
    halo.Parent = statusCard
    local haloCorner = Instance.new("UICorner") haloCorner.CornerRadius = UDim.new(1, 0) haloCorner.Parent = halo

    -- 3. Point central net et respirant
    local dot = Instance.new("Frame")
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 26, 0.5, 0)
    dot.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    dot.BorderSizePixel = 0
    dot.ZIndex = 10
    dot.Parent = statusCard
    local dotCorner = Instance.new("UICorner") dotCorner.CornerRadius = UDim.new(1, 0) dotCorner.Parent = dot

    local dotScale = Instance.new("UIScale")
    dotScale.Scale = 1
    dotScale.Parent = dot

    local pingAnim = TweenService:Create(ping, TweenInfo.new(1.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, -1, false), {
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundTransparency = 1
    })
    pingAnim:Play()

    local dotPulse = TweenService:Create(dotScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Scale = 1.2
    })
    dotPulse:Play()

    -- Container des textes pour un centrage vertical parfait
    local sTextContainer = Instance.new("Frame")
    sTextContainer.Size = UDim2.new(1, -165, 0, 36)
    sTextContainer.Position = UDim2.new(0, 48, 0.5, -18)
    sTextContainer.BackgroundTransparency = 1
    sTextContainer.BorderSizePixel = 0
    sTextContainer.ZIndex = 9
    sTextContainer.Parent = statusCard

    local sTitleLbl = Instance.new("TextLabel")
    sTitleLbl.Size = UDim2.new(1, 0, 0, 18)
    sTitleLbl.Position = UDim2.new(0, 0, 0, 0)
    sTitleLbl.BackgroundTransparency = 1
    sTitleLbl.Text = "Statut : 100% Fonctionnel"
    sTitleLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    sTitleLbl.Font = Enum.Font.GothamBold
    sTitleLbl.TextSize = 13
    sTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    sTitleLbl.ZIndex = 9
    sTitleLbl.Parent = sTextContainer

    local sDescLbl = Instance.new("TextLabel")
    sDescLbl.Size = UDim2.new(1, 0, 0, 16)
    sDescLbl.Position = UDim2.new(0, 0, 0, 19)
    sDescLbl.BackgroundTransparency = 1
    sDescLbl.Text = "Toutes les options sont a jour et fonctionnent parfaitement."
    sDescLbl.TextColor3 = Colors.TextDim or Color3.fromRGB(150, 150, 170)
    sDescLbl.Font = Enum.Font.Gotham
    sDescLbl.TextSize = 10
    sDescLbl.TextXAlignment = Enum.TextXAlignment.Left
    sDescLbl.ZIndex = 9
    sDescLbl.Parent = sTextContainer

    -- Status Badge Pill centre a droite
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 72, 0, 24)
    badge.Position = UDim2.new(1, -84, 0.5, -12)
    badge.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    badge.BackgroundTransparency = 0.85
    badge.BorderSizePixel = 0
    badge.ZIndex = 9
    badge.Parent = statusCard
    local badgeCorner = Instance.new("UICorner") badgeCorner.CornerRadius = UDim.new(0, 6) badgeCorner.Parent = badge
    local badgeStroke = Instance.new("UIStroke") badgeStroke.Color = Color3.fromRGB(46, 204, 113) badgeStroke.Thickness = 1 badgeStroke.Transparency = 0.4 badgeStroke.Parent = badge

    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size = UDim2.new(1, 0, 1, 0)
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Text = "ACTIF"
    badgeLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize = 10
    badgeLbl.TextXAlignment = Enum.TextXAlignment.Center
    badgeLbl.TextYAlignment = Enum.TextYAlignment.Center
    badgeLbl.ZIndex = 10
    badgeLbl.Parent = badge

    local function updateNebulaStatusUI()
        local failedCount = 0
        local failedNames = {}
        if _G.NebulaHealth and _G.NebulaHealth.failedOptions then
            for optName, _ in pairs(_G.NebulaHealth.failedOptions) do
                failedCount = failedCount + 1
                table.insert(failedNames, optName)
            end
        end

        local statusColor = Color3.fromRGB(46, 204, 113) -- Vert (OK)
        local statusTitle = "Statut : 100% Fonctionnel"
        local statusDesc = "Toutes les options sont a jour et fonctionnent parfaitement."
        local statusBadge = "ACTIF"
        local topBarStatusText = "100% Fonctionnel"

        if failedCount >= 1 and failedCount <= 2 then
            statusColor = Color3.fromRGB(241, 196, 15) -- Jaune (Warning)
            statusTitle = "Statut : " .. tostring(failedCount) .. " probleme(s) detecte(s)"
            statusDesc = "Option(s) instable(s) : " .. table.concat(failedNames, ", ")
            statusBadge = "ATTENTION"
            topBarStatusText = "Instable (" .. tostring(failedCount) .. ")"
        elseif failedCount >= 3 then
            statusColor = Color3.fromRGB(231, 76, 60) -- Rouge (Trop d'erreurs)
            statusTitle = "Statut : Problemes multiples (" .. tostring(failedCount) .. ")"
            statusDesc = "Trop d'options en erreur. Certaines fonctionnalites sont indisponibles."
            statusBadge = "CRITIQUE"
            topBarStatusText = "Critique (" .. tostring(failedCount) .. ")"
        end

        pcall(function()
            sTitleLbl.Text = statusTitle
            sTitleLbl.TextColor3 = statusColor
            sDescLbl.Text = statusDesc
            badge.BackgroundColor3 = statusColor
            badgeStroke.Color = statusColor
            badgeLbl.Text = statusBadge
            badgeLbl.TextColor3 = statusColor
            ping.BackgroundColor3 = statusColor
            halo.BackgroundColor3 = statusColor
            dot.BackgroundColor3 = statusColor
        end)

        pcall(function()
            if _G.TopBarStatusElements then
                local tb = _G.TopBarStatusElements
                if tb.dot then tb.dot.BackgroundColor3 = statusColor end
                if tb.stroke then tb.stroke.Color = statusColor end
                if tb.label then
                    tb.label.Text = topBarStatusText
                    tb.label.TextColor3 = statusColor
                end
            end
        end)
    end
    _G.updateNebulaStatusUI = updateNebulaStatusUI
    updateNebulaStatusUI()

    createLabel("INFORMATIONS & MISES A JOUR", InformationContent)

    -- French Month Formatter
    local moisFR = {
        ["01"] = "Janvier", ["02"] = "Fevrier", ["03"] = "Mars", ["04"] = "Avril",
        ["05"] = "Mai", ["06"] = "Juin", ["07"] = "Juillet", ["08"] = "Aout",
        ["09"] = "Septembre", ["10"] = "Octobre", ["11"] = "Novembre", ["12"] = "Decembre"
    }

    local function formatFrenchDate(isoString)
        if not isoString then return "20 Novembre 2026 a 20:56 (Heure FR)" end
        local y, m, d, hh, mm = string.match(isoString, "(%d+)-(%d+)-(%d+)T(%d+):(%d+)")
        if not (y and m and d and hh and mm) then
            return "20 Novembre 2026 a 20:56 (Heure FR)"
        end

        local hourNum = tonumber(hh) or 0
        local dayNum = tonumber(d) or 1
        local yearNum = tonumber(y) or 2026

        -- Heure francaise (CET = UTC+1 en hiver)
        hourNum = hourNum + 1
        if hourNum >= 24 then
            hourNum = hourNum - 24
            dayNum = dayNum + 1
        end

        local moisNom = moisFR[m] or m
        local hourStr = string.format("%02d", hourNum)
        return string.format("%d %s %d a %s:%s (Heure FR)", dayNum, moisNom, yearNum, hourStr, mm)
    end

    -- Card 1: Last Update Date (GitHub commits fetch) - Purement visuel, NON CLIQUABLE
    local updateCard = createCard(InformationContent, 0, 52)

    local uTitle = Instance.new("TextLabel")
    uTitle.Size = UDim2.new(1, -110, 0, 16)
    uTitle.Position = UDim2.new(0, 14, 0, 9)
    uTitle.BackgroundTransparency = 1
    uTitle.Text = "Derniere Mise a Jour (GitHub)"
    uTitle.TextColor3 = Colors.Text or Color3.fromRGB(235, 235, 245)
    uTitle.Font = Enum.Font.GothamMedium
    uTitle.TextSize = 12
    uTitle.TextXAlignment = Enum.TextXAlignment.Left
    uTitle.ZIndex = 9
    uTitle.Parent = updateCard

    local uDateLbl = Instance.new("TextLabel")
    uDateLbl.Size = UDim2.new(1, -110, 0, 15)
    uDateLbl.Position = UDim2.new(0, 14, 0, 27)
    uDateLbl.BackgroundTransparency = 1
    uDateLbl.Text = "20 Novembre 2026 a 20:56 (Heure FR)"
    uDateLbl.TextColor3 = Colors.Accent or Color3.fromRGB(145, 120, 255)
    uDateLbl.Font = Enum.Font.GothamBold
    uDateLbl.TextSize = 11
    uDateLbl.TextXAlignment = Enum.TextXAlignment.Left
    uDateLbl.ZIndex = 9
    uDateLbl.Parent = updateCard

    -- Tag / Badge "GitHub" en gris PUREMENT VISUEL (Non cliquable)
    local gitTag = Instance.new("Frame")
    gitTag.Size = UDim2.new(0, 74, 0, 24)
    gitTag.Position = UDim2.new(1, -86, 0.5, -12)
    gitTag.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    gitTag.BorderSizePixel = 0
    gitTag.ZIndex = 9
    gitTag.Parent = updateCard
    local gtCorner = Instance.new("UICorner")
    gtCorner.CornerRadius = UDim.new(0, 6)
    gtCorner.Parent = gitTag
    local gtStroke = Instance.new("UIStroke")
    gtStroke.Color = Colors.Border or Color3.fromRGB(44, 46, 62)
    gtStroke.Thickness = 1
    gtStroke.Parent = gitTag

    local gtLbl = Instance.new("TextLabel")
    gtLbl.Size = UDim2.new(1, 0, 1, 0)
    gtLbl.BackgroundTransparency = 1
    gtLbl.Text = "GitHub"
    gtLbl.TextColor3 = Color3.fromRGB(150, 150, 165)
    gtLbl.Font = Enum.Font.GothamBold
    gtLbl.TextSize = 11
    gtLbl.TextXAlignment = Enum.TextXAlignment.Center
    gtLbl.TextYAlignment = Enum.TextYAlignment.Center
    gtLbl.ZIndex = 10
    gtLbl.Parent = gitTag

    -- Fetch GitHub Commit Timestamp with French Conversion
    task.spawn(function()
        local success, res = pcall(function()
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if req then
                local resp = req({
                    Url = "https://api.github.com/repos/ntopng/lua-utils-code/commits?path=main2.lua&page=1&per_page=1",
                    Method = "GET",
                    Headers = { ["User-Agent"] = "PearlScript" }
                })
                if resp and resp.Body then return resp.Body end
            end
            return game:HttpGet("https://api.github.com/repos/ntopng/lua-utils-code/commits?path=main2.lua&page=1&per_page=1")
        end)
        if success and res and type(res) == "string" then
            local iso = string.match(res, '"date"%s*:%s*"([^"]+)"')
            if iso then
                uDateLbl.Text = formatFrenchDate(iso)
            end
        end
    end)

    -- Card 2: Creator (COLE)
    local creatorCard = createCard(InformationContent, 0, 48)
    local cTitle = Instance.new("TextLabel")
    cTitle.Size = UDim2.new(1, -120, 0, 16)
    cTitle.Position = UDim2.new(0, 14, 0, 8)
    cTitle.BackgroundTransparency = 1
    cTitle.Text = "Createur du Script"
    cTitle.TextColor3 = Colors.Text or Color3.fromRGB(235, 235, 245)
    cTitle.Font = Enum.Font.GothamMedium
    cTitle.TextSize = 12
    cTitle.TextXAlignment = Enum.TextXAlignment.Left
    cTitle.ZIndex = 9
    cTitle.Parent = creatorCard

    local cName = Instance.new("TextLabel")
    cName.Size = UDim2.new(1, -120, 0, 16)
    cName.Position = UDim2.new(0, 14, 0, 24)
    cName.BackgroundTransparency = 1
    cName.Text = "COLE"
    cName.TextColor3 = Colors.Accent or Color3.fromRGB(145, 120, 255)
    cName.Font = Enum.Font.GothamBold
    cName.TextSize = 12
    cName.TextXAlignment = Enum.TextXAlignment.Left
    cName.ZIndex = 9
    cName.Parent = creatorCard

    local cBadge = Instance.new("Frame")
    cBadge.Size = UDim2.new(0, 96, 0, 24)
    cBadge.Position = UDim2.new(1, -108, 0.5, -12)
    cBadge.BackgroundColor3 = Color3.fromRGB(35, 28, 55)
    cBadge.BorderSizePixel = 0
    cBadge.ZIndex = 9
    cBadge.Parent = creatorCard
    local cbCorner2 = Instance.new("UICorner") cbCorner2.CornerRadius = UDim.new(0, 6) cbCorner2.Parent = cBadge
    local cbStroke2 = Instance.new("UIStroke") cbStroke2.Color = Colors.Accent or Color3.fromRGB(145, 120, 255) cbStroke2.Thickness = 1 cbStroke2.Transparency = 0.5 cbStroke2.Parent = cBadge

    local cbLbl = Instance.new("TextLabel")
    cbLbl.Size = UDim2.new(1, 0, 1, 0)
    cbLbl.BackgroundTransparency = 1
    cbLbl.Text = "Developpeur"
    cbLbl.TextColor3 = Colors.Accent or Color3.fromRGB(145, 120, 255)
    cbLbl.Font = Enum.Font.GothamBold
    cbLbl.TextSize = 10
    cbLbl.TextXAlignment = Enum.TextXAlignment.Center
    cbLbl.TextYAlignment = Enum.TextYAlignment.Center
    cbLbl.ZIndex = 10
    cbLbl.Parent = cBadge

    -- Card 3: Discord (.gg/6pTxDuk3RG)
    local discordCard = createCard(InformationContent, 0, 52)
    local dTitle = Instance.new("TextLabel")
    dTitle.Size = UDim2.new(1, -120, 0, 16)
    dTitle.Position = UDim2.new(0, 14, 0, 9)
    dTitle.BackgroundTransparency = 1
    dTitle.Text = "Communaute Discord"
    dTitle.TextColor3 = Colors.Text or Color3.fromRGB(235, 235, 245)
    dTitle.Font = Enum.Font.GothamMedium
    dTitle.TextSize = 12
    dTitle.TextXAlignment = Enum.TextXAlignment.Left
    dTitle.ZIndex = 9
    dTitle.Parent = discordCard

    local dLinkLbl = Instance.new("TextLabel")
    dLinkLbl.Size = UDim2.new(1, -120, 0, 14)
    dLinkLbl.Position = UDim2.new(0, 14, 0, 27)
    dLinkLbl.BackgroundTransparency = 1
    dLinkLbl.Text = ".gg/6pTxDuk3RG"
    dLinkLbl.TextColor3 = Color3.fromRGB(114, 137, 218)
    dLinkLbl.Font = Enum.Font.GothamBold
    dLinkLbl.TextSize = 11
    dLinkLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLinkLbl.ZIndex = 9
    dLinkLbl.Parent = discordCard

    local copyDiscBtn = Instance.new("TextButton")
    copyDiscBtn.Size = UDim2.new(0, 78, 0, 26)
    copyDiscBtn.Position = UDim2.new(1, -90, 0.5, -13)
    copyDiscBtn.BackgroundColor3 = Color3.fromRGB(40, 48, 85)
    copyDiscBtn.BorderSizePixel = 0
    copyDiscBtn.Text = "Copier"
    copyDiscBtn.TextColor3 = Color3.fromRGB(210, 225, 255)
    copyDiscBtn.Font = Enum.Font.GothamBold
    copyDiscBtn.TextSize = 11
    copyDiscBtn.Active = true
    copyDiscBtn.AutoButtonColor = false
    copyDiscBtn.ZIndex = 14
    copyDiscBtn.Parent = discordCard
    local dcbCorner = Instance.new("UICorner") dcbCorner.CornerRadius = UDim.new(0, 6) dcbCorner.Parent = copyDiscBtn
    local dcbStroke = Instance.new("UIStroke") dcbStroke.Color = Color3.fromRGB(88, 101, 242) dcbStroke.Thickness = 1 dcbStroke.Parent = copyDiscBtn

    local lastDiscCopy = 0
    local function copyDiscordLink()
        local now = os.clock()
        if now - lastDiscCopy < 0.4 then return end
        lastDiscCopy = now
        playClick()
        local discordLink = ".gg/6pTxDuk3RG"
        safeSetClipboard(discordLink)
        copyDiscBtn.Text = "Copie !"
        copyDiscBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
        notify("Discord", "Lien .gg/6pTxDuk3RG copie !", Color3.fromRGB(114, 137, 218))
        task.delay(1.3, function()
            if copyDiscBtn and copyDiscBtn.Parent then
                copyDiscBtn.Text = "Copier"
                copyDiscBtn.TextColor3 = Color3.fromRGB(210, 225, 255)
            end
        end)
    end

    copyDiscBtn.MouseButton1Click:Connect(copyDiscordLink)
    copyDiscBtn.Activated:Connect(copyDiscordLink)

    copyDiscBtn.MouseEnter:Connect(function()
        TweenService:Create(copyDiscBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(88, 101, 242), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    copyDiscBtn.MouseLeave:Connect(function()
        TweenService:Create(copyDiscBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 48, 85), TextColor3 = (copyDiscBtn.Text == "Copie !" and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(210, 225, 255))}):Play()
    end)

    -- Card 4: Version & Build
    local verCard = createCard(InformationContent, 0, 48)
    local vTitle = Instance.new("TextLabel")
    vTitle.Size = UDim2.new(1, -120, 0, 16)
    vTitle.Position = UDim2.new(0, 14, 0, 8)
    vTitle.BackgroundTransparency = 1
    vTitle.Text = "Version du Script"
    vTitle.TextColor3 = Colors.Text or Color3.fromRGB(235, 235, 245)
    vTitle.Font = Enum.Font.GothamMedium
    vTitle.TextSize = 12
    vTitle.TextXAlignment = Enum.TextXAlignment.Left
    vTitle.ZIndex = 9
    vTitle.Parent = verCard

    local vSub = Instance.new("TextLabel")
    vSub.Size = UDim2.new(1, -120, 0, 14)
    vSub.Position = UDim2.new(0, 14, 0, 24)
    vSub.BackgroundTransparency = 1
    vSub.Text = "Pearl Edition • Build 2.0.4"
    vSub.TextColor3 = Colors.TextDim or Color3.fromRGB(150, 150, 170)
    vSub.Font = Enum.Font.Gotham
    vSub.TextSize = 10
    vSub.TextXAlignment = Enum.TextXAlignment.Left
    vSub.ZIndex = 9
    vSub.Parent = verCard

    local vBadge = Instance.new("Frame")
    vBadge.Size = UDim2.new(0, 56, 0, 22)
    vBadge.Position = UDim2.new(1, -68, 0.5, -11)
    vBadge.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    vBadge.BorderSizePixel = 0
    vBadge.ZIndex = 9
    vBadge.Parent = verCard
    local vbCorner = Instance.new("UICorner") vbCorner.CornerRadius = UDim.new(0, 5) vbCorner.Parent = vBadge
    local vbStroke = Instance.new("UIStroke") vbStroke.Color = Colors.Border or Color3.fromRGB(44, 46, 62) vbStroke.Thickness = 1 vbStroke.Parent = vBadge

    local vbLbl = Instance.new("TextLabel")
    vbLbl.Size = UDim2.new(1, 0, 1, 0)
    vbLbl.BackgroundTransparency = 1
    vbLbl.Text = "V2.0"
    vbLbl.TextColor3 = Colors.Accent or Color3.fromRGB(145, 120, 255)
    vbLbl.Font = Enum.Font.GothamBold
    vbLbl.TextSize = 10
    vbLbl.TextXAlignment = Enum.TextXAlignment.Center
    vbLbl.TextYAlignment = Enum.TextYAlignment.Center
    vbLbl.ZIndex = 10
    vbLbl.Parent = vBadge

    -- Card 5: Derniere Mise a Jour (Changelog Recents)
    createLabel("DERNIERE MISE A JOUR (CHANGELOG)", InformationContent)

    local changelogCard = createCard(InformationContent, 0, 310)

    -- Titre bien espacé et aéré
    local clTitle = Instance.new("TextLabel")
    clTitle.Size = UDim2.new(1, -110, 0, 18)
    clTitle.Position = UDim2.new(0, 16, 0, 12)
    clTitle.BackgroundTransparency = 1
    clTitle.Text = "Changements Récents"
    clTitle.TextColor3 = Colors.Text or Color3.fromRGB(235, 235, 245)
    clTitle.Font = Enum.Font.GothamMedium
    clTitle.TextSize = 12
    clTitle.TextXAlignment = Enum.TextXAlignment.Left
    clTitle.ZIndex = 9
    clTitle.Parent = changelogCard

    local clBadge = Instance.new("Frame")
    clBadge.Size = UDim2.new(0, 68, 0, 20)
    clBadge.Position = UDim2.new(1, -80, 0, 11)
    clBadge.BackgroundColor3 = Color3.fromRGB(24, 30, 40)
    clBadge.BorderSizePixel = 0
    clBadge.ZIndex = 9
    clBadge.Parent = changelogCard
    local clbCorner = Instance.new("UICorner") clbCorner.CornerRadius = UDim.new(0, 5) clbCorner.Parent = clBadge
    local clbStroke = Instance.new("UIStroke") clbStroke.Color = Color3.fromRGB(46, 204, 113) clbStroke.Thickness = 1 clbStroke.Parent = clBadge

    local clbLbl = Instance.new("TextLabel")
    clbLbl.Size = UDim2.new(1, 0, 1, 0)
    clbLbl.BackgroundTransparency = 1
    clbLbl.Text = "AUTO"
    clbLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    clbLbl.Font = Enum.Font.GothamBold
    clbLbl.TextSize = 10
    clbLbl.TextXAlignment = Enum.TextXAlignment.Center
    clbLbl.TextYAlignment = Enum.TextYAlignment.Center
    clbLbl.ZIndex = 10
    clbLbl.Parent = clBadge

    -- Liste dynamique automatique des changements
    _G.NebulaChangelog = _G.NebulaChangelog or {
        { text = "- Fix Menu & ESP : Anti-Desync Resolver Freecam, FOV Clic-Droit & Marges Layout", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Player Size & Weapon Size : Echelles locales, armes geantes et calage parfait au sol", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Vehicle ESP 3D : Box 3D, Nom, Distance, Statut Conducteur & Palette Couleurs", color = Color3.fromRGB(241, 196, 15) },
        { text = "- Vehicle ESP 100% Indépendant : Toggle dédié, couleur violette par défaut & palette", color = Color3.fromRGB(145, 120, 255) },
        { text = "- Véhicules Allégés : Ancrage / Freeze unifié avec Keybind custom, Anti-Flip & Tout-Terrain", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Anti-Desordre Recherche : Stabilisation automatique permanente du LayoutOrder", color = Color3.fromRGB(140, 100, 255) },
        { text = "- Air Walk / Jesus Walk : Escalier Celeste & plateforme dynamique dans le vide", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Kill All (weapons games) : TP 1.1s dos, camera lock automatique & traque a mort", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Statut Auto-Dynamique : Detection erreurs temps reel (Vert / Jaune / Rouge)", color = Color3.fromRGB(140, 100, 255) },
        { text = "- TopBar Health Badge : Statut de sante du script affiche en direct tout en haut", color = Color3.fromRGB(140, 100, 255) },
        { text = "- Onglet Joueur : Layout 2 colonnes elargi (53%/47%) sans aucune coupure de pseudo", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Stealth Bypass : Disallowed Services elimines (Anti-Cheat code 267)", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Freecam AZERTY : Remplacement camera fluide sans TP du personnage", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Invisibilite FE : Glitch Seat Desync 100% invisible (Invischair clean)", color = Color3.fromRGB(46, 204, 113) },
        { text = "- FPS Booster Ultra : Boost massif sans impacter la distance d'affichage", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Clavier 100% ZQSD strict en AZERTY (WASD desactive)", color = Color3.fromRGB(46, 204, 113) },
        { text = "- Menu : Categorie Information chargee par defaut a l'ouverture", color = Color3.fromRGB(46, 204, 113) },
    }

    local renderedChangelogRows = {}
    local function renderChangelog()
        for _, obj in ipairs(renderedChangelogRows) do
            pcall(function() obj:Destroy() end)
        end
        renderedChangelogRows = {}

        local changes = _G.NebulaChangelog or {}
        local startY = 44 -- Espace genereux de 14px sous le titre pour respirer
        local rowHeight = 23
        local totalCardHeight = startY + (#changes * rowHeight) + 14
        changelogCard.Size = UDim2.new(1, 0, 0, totalCardHeight)

        for idxRow, item in ipairs(changes) do
            local rowY = startY + (idxRow - 1) * rowHeight

            local rowDot = Instance.new("Frame")
            rowDot.Size = UDim2.new(0, 6, 0, 6)
            rowDot.Position = UDim2.new(0, 16, 0, rowY + 6)
            rowDot.BackgroundColor3 = item.color or Color3.fromRGB(46, 204, 113)
            rowDot.BorderSizePixel = 0
            rowDot.ZIndex = 9
            rowDot.Parent = changelogCard
            local dotCorner = Instance.new("UICorner") dotCorner.CornerRadius = UDim.new(1, 0) dotCorner.Parent = rowDot
            table.insert(renderedChangelogRows, rowDot)

            local rowLbl = Instance.new("TextLabel")
            rowLbl.Size = UDim2.new(1, -36, 0, 18)
            rowLbl.Position = UDim2.new(0, 28, 0, rowY)
            rowLbl.BackgroundTransparency = 1
            rowLbl.Text = item.text
            rowLbl.TextColor3 = item.color or Color3.fromRGB(235, 235, 245)
            rowLbl.Font = Enum.Font.GothamMedium
            rowLbl.TextSize = 11
            rowLbl.TextXAlignment = Enum.TextXAlignment.Left
            rowLbl.ZIndex = 9
            rowLbl.Parent = changelogCard
            table.insert(renderedChangelogRows, rowLbl)
        end
    end

    _G.addNebulaChangelog = function(text, color)
        if not text then return end
        table.insert(_G.NebulaChangelog, 1, {
            text = text,
            color = color or Color3.fromRGB(46, 204, 113)
        })
        pcall(renderChangelog)
    end

    renderChangelog()

end


initStep = "cablage Movement"
-- Clavier configure en AZERTY par defaut
V.KeyboardLayout = "AZERTY" 
createLabel("SPEED & JUMP", MovementContent)
_, _, ToggleSpeed = createToggle("Enable Walk Speed", false, function(enabled)
    V.SpeedEnabled = enabled
    if not enabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and not V.VelocitySpoof then local restoreSpeed = _OrigWalkSpeed or (getBaseWalkSpeed and getBaseWalkSpeed(hum)) or 16; hum.WalkSpeed = restoreSpeed end
            if hrp then
                local yVel = hrp.AssemblyLinearVelocity.Y
                hrp.AssemblyLinearVelocity = Vector3.new(0, yVel, 0)
            end
        end)
    end
    notify("Movement","Walk Speed ".. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"SpeedEnabled")
createSlider("Walk Speed", 16, 1000, 16, function(val) V.Speed = val end, MovementContent,"Speed")

function createValueButton(parent, title, valueText, onChange, configKey)
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
                valueLabel.Text = tostring(newValue)
            end
        end
    end)

    if configKey then
        ConfigRegistry[configKey] = function(val)
            if val ~= nil then
                V[configKey] = val
                valueLabel.Text = tostring(val)
            end
        end
    end

    registerSearchCard(card, title, parent)

    return card, btn, valueLabel
end

speedMethodsList = {"Anti-TP CFrame (Recommandé)", "Humanoid", "Velocity", "VectorForce"}
currentSpeedMethodIdx = 1
speedMethodFrame, speedMethodBtnObj, speedMethodValue = createValueButton(MovementContent, "Speed Method", V.SpeedMethod, function()
    local foundIdx = table.find(speedMethodsList, V.SpeedMethod)
    if foundIdx then currentSpeedMethodIdx = foundIdx end
    currentSpeedMethodIdx = (currentSpeedMethodIdx % #speedMethodsList) + 1
    V.SpeedMethod = speedMethodsList[currentSpeedMethodIdx]
    notify("Movement","Méthode de vitesse : ".. V.SpeedMethod, Color3.fromRGB(80, 200, 120))
    return V.SpeedMethod
end, "SpeedMethod")

createToggle("Enable Jump Power", false, function(enabled)
    V.JumpEnabled = enabled
    if not enabled then
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                if _OrigUseJumpPower ~= nil then
                    hum.UseJumpPower = _OrigUseJumpPower
                end
                if _OrigJumpPower then
                    hum.JumpPower = _OrigJumpPower
                else
                    hum.JumpPower = 50
                end
                if _OrigJumpHeight then
                    hum.JumpHeight = _OrigJumpHeight
                end
            end
        end)
    end
    notify("Movement","Jump Power ".. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"JumpEnabled")
createSlider("Jump Power", 50, 300, 50, function(val) V.Jump = val end, MovementContent,"Jump")

createToggle("Wall Climb (Spider)", false, function(enabled)
    V.WallClimb = enabled
    if not enabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hum.PlatformStand = false
                hum.Sit = false
                local _, ry, _ = hrp.CFrame:ToOrientation()
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, ry, 0)
                if hum:GetState() == Enum.HumanoidStateType.Climbing then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end)
    end
    notify("Movement","Wall Climb ".. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MovementContent,"WallClimb")

function setupInfiniteStamina(enabled)
    V.InfiniteStamina = enabled
    if V.InfiniteStaminaConn then
        V.InfiniteStaminaConn:Disconnect()
        V.InfiniteStaminaConn = nil
    end
    if V.InfiniteStaminaTask then
        task.cancel(V.InfiniteStaminaTask)
        V.InfiniteStaminaTask = nil
    end
    if V.InfiniteStaminaSubConns then
        for _, conn in ipairs(V.InfiniteStaminaSubConns) do
            pcall(function() conn:Disconnect() end)
        end
        V.InfiniteStaminaSubConns = nil
    end

    if enabled then
        V.InfiniteStaminaSubConns = {}
        local staminaKeywords = {
            "stamina", "energy", "sprint", "sprintenergy", "staminabar",
            "sprintvalue", "dashstamina", "runenergy", "endurance", "fatigue",
            "sprintstamina", "playerstamina"
        }

        local function isStaminaName(str)
            local s = string.lower(tostring(str))
            for _, kw in ipairs(staminaKeywords) do
                if string.find(s, kw, 1, true) then return true end
            end
            return false
        end

        local function lockObject(obj)
            if not obj then return end
            if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                if isStaminaName(obj.Name) then
                    local maxVal = obj:FindFirstChild("MaxValue") or obj:FindFirstChild("Max")
                    local target = (maxVal and maxVal.Value) or 100
                    pcall(function() obj.Value = target end)
                    local c = obj.Changed:Connect(function(newVal)
                        if not V.InfiniteStamina then return end
                        if newVal < target then
                            task.defer(function()
                                if V.InfiniteStamina and obj and obj.Parent then
                                    pcall(function() obj.Value = target end)
                                end
                            end)
                        end
                    end)
                    table.insert(V.InfiniteStaminaSubConns, c)
                end
            elseif obj:IsA("BoolValue") then
                local lowerName = string.lower(obj.Name)
                if lowerName == "exhausted" or lowerName == "tired" or lowerName == "outofbreath" then
                    pcall(function() obj.Value = false end)
                    local c = obj.Changed:Connect(function(newVal)
                        if not V.InfiniteStamina then return end
                        if newVal == true then
                            task.defer(function()
                                if V.InfiniteStamina and obj and obj.Parent then
                                    pcall(function() obj.Value = false end)
                                end
                            end)
                        end
                    end)
                    table.insert(V.InfiniteStaminaSubConns, c)
                end
            end
        end

        local function bindCharacter(char)
            if not char then return end
            pcall(function()
                local attrs = char:GetAttributes()
                for attrName, val in pairs(attrs) do
                    if isStaminaName(attrName) then
                        if type(val) == "number" then
                            char:SetAttribute(attrName, 100)
                        elseif type(val) == "boolean" and (string.find(string.lower(attrName), "tired") or string.find(string.lower(attrName), "exhaust")) then
                            char:SetAttribute(attrName, false)
                        end
                    end
                end
            end)

            local attrConn = char.AttributeChanged:Connect(function(attrName)
                if not V.InfiniteStamina then return end
                if isStaminaName(attrName) then
                    local cur = char:GetAttribute(attrName)
                    if type(cur) == "number" and cur < 100 then
                        char:SetAttribute(attrName, 100)
                    elseif type(cur) == "boolean" and cur == true and (string.find(string.lower(attrName), "tired") or string.find(string.lower(attrName), "exhaust")) then
                        char:SetAttribute(attrName, false)
                    end
                end
            end)
            table.insert(V.InfiniteStaminaSubConns, attrConn)

            for _, child in ipairs(char:GetChildren()) do
                lockObject(child)
                if child:IsA("Folder") or child:IsA("Configuration") or child.Name == "Stats" or child.Name == "Values" then
                    for _, sub in ipairs(child:GetChildren()) do
                        lockObject(sub)
                    end
                end
            end

            local childConn = char.ChildAdded:Connect(function(child)
                if not V.InfiniteStamina then return end
                lockObject(child)
                if child:IsA("Folder") or child:IsA("Configuration") then
                    for _, sub in ipairs(child:GetChildren()) do
                        lockObject(sub)
                    end
                end
            end)
            table.insert(V.InfiniteStaminaSubConns, childConn)
        end

        local char = LocalPlayer.Character
        if char then bindCharacter(char) end

        local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(0.3)
            if V.InfiniteStamina then
                bindCharacter(newChar)
            end
        end)
        table.insert(V.InfiniteStaminaSubConns, charAddedConn)

        V.InfiniteStaminaTask = task.spawn(function()
            while V.InfiniteStamina do
                pcall(function()
                    local c = LocalPlayer.Character
                    if c then
                        for attr, val in pairs(c:GetAttributes()) do
                            if isStaminaName(attr) and type(val) == "number" and val < 100 then
                                c:SetAttribute(attr, 100)
                            end
                        end
                        for _, desc in ipairs(c:GetDescendants()) do
                            if (desc:IsA("NumberValue") or desc:IsA("IntValue")) and isStaminaName(desc.Name) then
                                local maxVal = desc:FindFirstChild("MaxValue") or desc:FindFirstChild("Max")
                                local target = (maxVal and maxVal.Value) or 100
                                if desc.Value < target then desc.Value = target end
                            elseif desc:IsA("BoolValue") and (desc.Name == "Exhausted" or desc.Name == "Tired") then
                                desc.Value = false
                            end
                        end
                    end
                    for attr, val in pairs(LocalPlayer:GetAttributes()) do
                        if isStaminaName(attr) and type(val) == "number" and val < 100 then
                            LocalPlayer:SetAttribute(attr, 100)
                        end
                    end
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    if pg then
                        for _, desc in ipairs(pg:GetDescendants()) do
                            if (desc:IsA("NumberValue") or desc:IsA("IntValue")) and isStaminaName(desc.Name) then
                                local maxVal = desc:FindFirstChild("MaxValue") or desc:FindFirstChild("Max")
                                local target = (maxVal and maxVal.Value) or 100
                                if desc.Value < target then desc.Value = target end
                            end
                        end
                    end
                end)
                task.wait(0.15)
            end
        end)

        notify("Movement", "Infinite Stamina ACTIVÉ (0 Lag)", Color3.fromRGB(80, 200, 120))
    else
        notify("Movement", "Infinite Stamina DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end
_G.setupInfiniteStamina = setupInfiniteStamina

createToggle("Infinite Stamina (Sprint Infini)", false, function(enabled)
    setupInfiniteStamina(enabled)
end, MovementContent, "InfiniteStamina")

superJumpPressTime = nil
superJumpChargeTask = nil
superJumpChargeRing = nil

function createChargeEffect(char)
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        local a = Instance.new("Attachment")
        a.Name = "PearlChargeAtt"
        a.Parent = hrp
        local p = Instance.new("ParticleEmitter")
        p.Name = "PearlChargeParticles"
        p.Texture = "rbxassetid://29712167"
        p.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 50)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
        })
        p.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.4),
            NumberSequenceKeypoint.new(1, 2)
        })
        p.Transparency = NumberSequence.new(0.2, 0.8)
        p.Lifetime = NumberRange.new(0.3, 0.6)
        p.Rate = 50
        p.Speed = NumberRange.new(5, 15)
        p.SpreadAngle = Vector2.new(180, 180)
        p.Parent = a
    end)
end

function removeChargeEffect(char)
    if not char then return end
    pcall(function()
        for _, desc in pairs(char:GetDescendants()) do
            if desc.Name == "PearlChargeAtt" or desc.Name == "PearlChargeParticles" then
                desc:Destroy()
            end
        end
    end)
end

superJumpAnimTrack = nil
superJumpAnimObject = nil

function playChargeAnimation(hum)
    if not hum then return end
    pcall(function()
        if superJumpAnimTrack then
            superJumpAnimTrack:Stop()
            superJumpAnimTrack:Destroy()
            superJumpAnimTrack = nil
        end
        local anim = Instance.new("Animation")
        anim.AnimationId = (hum.RigType == Enum.RigType.R15) and "rbxassetid://282574440" or "rbxassetid://182436935"
        superJumpAnimObject = anim
        superJumpAnimTrack = hum:LoadAnimation(anim)
        if superJumpAnimTrack then
            superJumpAnimTrack.Priority = Enum.AnimationPriority.Action4
            superJumpAnimTrack.Looped = true
            superJumpAnimTrack:Play(0.15)
            superJumpAnimTrack:AdjustSpeed(0.5)
        end
    end)
end

function stopChargeAnimation()
    pcall(function()
        if superJumpAnimTrack then
            superJumpAnimTrack:Stop(0.1)
            superJumpAnimTrack:Destroy()
            superJumpAnimTrack = nil
        end
        if superJumpAnimObject then
            superJumpAnimObject:Destroy()
            superJumpAnimObject = nil
        end
    end)
end

function toggleSuperJumpCharge(enabled)
    V.SuperJumpCharge = enabled
    if V.SuperJumpConn then V.SuperJumpConn:Disconnect() V.SuperJumpConn = nil end
    if V.SuperJumpEndConn then V.SuperJumpEndConn:Disconnect() V.SuperJumpEndConn = nil end
    if superJumpChargeTask then task.cancel(superJumpChargeTask) superJumpChargeTask = nil end
    local char = LocalPlayer.Character
    removeChargeEffect(char)
    stopChargeAnimation()

    if enabled then
        V.SuperJumpConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.Space then
                local c = LocalPlayer.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                
                superJumpPressTime = tick()
                createChargeEffect(c)
                playChargeAnimation(hum)
                
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                
                if superJumpChargeTask then task.cancel(superJumpChargeTask) end
                superJumpChargeTask = task.spawn(function()
                    local origWalk = hum.WalkSpeed
                    while UserInputService:IsKeyDown(Enum.KeyCode.Space) and V.SuperJumpCharge do
                        hum.WalkSpeed = math.max(4, origWalk * 0.35)
                        task.wait(0.05)
                    end
                    hum.WalkSpeed = origWalk
                end)
            end
        end)
        addConnection(V.SuperJumpConn)

        V.SuperJumpEndConn = UserInputService.InputEnded:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.Space and superJumpPressTime then
                local c = LocalPlayer.Character
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                local chargeTime = math.min(tick() - superJumpPressTime, 3)
                superJumpPressTime = nil
                removeChargeEffect(c)
                stopChargeAnimation()

                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                end

                if chargeTime >= 0.15 and hrp and hum then
                    local chargeRatio = math.clamp(chargeTime / 2.5, 0.1, 1)
                    local launchVelocity = 160 + (chargeRatio * 420)
                    
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "SuperJumpLaunch"
                    bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                    bv.Velocity = Vector3.new(hrp.AssemblyLinearVelocity.X, launchVelocity, hrp.AssemblyLinearVelocity.Z)
                    bv.Parent = hrp
                    Debris:AddItem(bv, 0.45)
                    
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    notify("Movement", string.format("🚀 SAUT CATAPULTE ! (%d%% Puissance)", math.floor(chargeRatio * 100)), Color3.fromRGB(80, 200, 120))
                end
            end
        end)
        addConnection(V.SuperJumpEndConn)
        notify("Movement", "Super Jump Charge ACTIVÉ (Maintiens ESPACE)", Color3.fromRGB(80, 200, 120))
    else
        local c = LocalPlayer.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end
        stopChargeAnimation()
        notify("Movement", "Super Jump Charge DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleSuperJumpCharge = toggleSuperJumpCharge

createToggle("Super Jump Charge (Saut Catapulte)", false, function(enabled)
    toggleSuperJumpCharge(enabled)
end, MovementContent, "SuperJumpCharge")

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



function cleanAndResetAllBodies()
    pcall(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and not V.HitboxExtender then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = Enum.Material.Plastic
                    hrp.CanCollide = false
                end
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local orig = head:FindFirstChild("OriginalSize")
                    if orig and orig:IsA("Vector3Value") then
                        head.Size = orig.Value
                    elseif head:IsA("MeshPart") and head.MeshSize and head.MeshSize.Magnitude > 0 then
                        head.Size = head.MeshSize
                    else
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.RigType == Enum.HumanoidRigType.R15 then
                            head.Size = Vector3.new(1.2, 1.2, 1.2)
                        end
                    end
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
                        hrp.Color = Color3.fromRGB(0, 145, 255)
                        hrp.Material = Enum.Material.Neon
                        hrp.CanCollide = false
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
createLabel("HITBOX", MeContent)
createToggle("Hitbox Extender", false, function(enabled)
    V.HitboxExtender = enabled
    if not enabled then
        cleanAndResetAllBodies()
    end
    notify("Combat","Hitbox Extender".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"HitboxExtender")
createSlider("Hitbox Size (Taille)", 1, 50, 25, function(val) V.HitboxSize = val end, MeContent,"HitboxSize")

-- [FAKE DEAD : EFFONDREMENT, SON & RELEVEMENT SUR ESPACE / AVANCER]
do
    local fakeDeadActive = false
    local fakeDeadConn = nil

    local function toggleFakeDead(forceState)
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        local newState = (forceState ~= nil) and forceState or not fakeDeadActive
        fakeDeadActive = newState

        if newState then
            -- Son authentique Roblox Death ("OOF")
            pcall(function()
                local sound = Instance.new("Sound")
                sound.Name = "FakeDeadOofSound"
                sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
                sound.Volume = 2.0
                sound.Parent = hrp
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 3)
            end)

            -- Effondrement propre au sol SANS s'enfoncer sous la map
            pcall(function()
                hum.PlatformStand = true
                hum:ChangeState(Enum.HumanoidStateType.FallingDown)

                -- Raycast précis vers le sol pour caler le corps au-dessus du sol
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = { char }
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local groundRay = workspace:Raycast(hrp.Position, Vector3.new(0, -15, 0), rayParams)
                local groundY = groundRay and groundRay.Position.Y or (hrp.Position.Y - 2.5)

                -- Bascule le corps à l'horizontale posé net au sol
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                hrp.CFrame = CFrame.new(hrp.Position.X, groundY + 1.2, hrp.Position.Z) * CFrame.Angles(math.rad(-90), hrp.CFrame.Rotation.Y, 0)
            end)
            notify("Me", "Fausse Mort ACTIVE (Espace ou Avancer pour te relever)", Color3.fromRGB(255, 165, 0))

            if fakeDeadConn then fakeDeadConn:Disconnect() end
            fakeDeadConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if not fakeDeadActive then return end
                local kc = input.KeyCode
                if kc == Enum.KeyCode.Space or kc == Enum.KeyCode.W or kc == Enum.KeyCode.A or kc == Enum.KeyCode.S or kc == Enum.KeyCode.D or kc == Enum.KeyCode.Z or kc == Enum.KeyCode.Q then
                    toggleFakeDead(false)
                end
            end)
        else
            pcall(function()
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
            if fakeDeadConn then
                fakeDeadConn:Disconnect()
                fakeDeadConn = nil
            end
            notify("Me", "Tu t'es relevé !", Color3.fromRGB(80, 200, 120))
        end
    end
    _G.toggleFakeDead = toggleFakeDead

    createToggle("Fausse Mort (Fake Dead)", false, function(enabled)
        toggleFakeDead(enabled)
    end, MeContent, "FakeDead")
end

initStep = "cablage Protection"

function isRobloxAdminOrStaff(player)
    if not player or not player:IsA("Player") then return false, "" end
    local isStaff = false
    local reason = ""

    pcall(function()
        if game.CreatorType == Enum.CreatorType.User and player.UserId == game.CreatorId then
            isStaff = true
            reason = "Créateur du Jeu"
        end
    end)
    if isStaff then return true, reason end

    pcall(function()
        if game.CreatorType == Enum.CreatorType.Group and game.CreatorId > 0 then
            local rank = player:GetRankInGroup(game.CreatorId)
            if rank > 0 then
                local role = string.lower(player:GetRoleInGroup(game.CreatorId) or "")
                
                -- Exclusion stricte des faux-positifs fréquents (voice chat, membres, VIP, donateurs)
                local isNonStaff = role:find("verified") 
                    or role:find("member") 
                    or role:find("player") 
                    or role:find("guest") 
                    or role:find("vip") 
                    or role:find("donat") 
                    or role:find("fan") 
                    or role:find("voice")
                    or role:find("mic")
                    or role:find("user")
                    or role:find("regular")
                    or role:find("citizen")

                if not isNonStaff then
                    if rank >= 254 then
                        isStaff = true
                        reason = "Créateur / Owner Groupe (" .. tostring(rank) .. ")"
                    elseif role:find("admin") or role:find("moderat") or role:find("owner") or role:find("fondat") or role:find("develop") or role:find("developp") or role:find("staff") or role:find("creator") or role:find("manage") then
                        isStaff = true
                        reason = "Staff Groupe (" .. player:GetRoleInGroup(game.CreatorId) .. ")"
                    end
                end
            end
        end
    end)
    if isStaff then return true, reason end

    pcall(function()
        if player:IsInGroup(1200769) and player:GetRankInGroup(1200769) >= 100 then
            isStaff = true
            reason = "Roblox Staff Officiel"
        end
    end)
    if isStaff then return true, reason end

    pcall(function()
        if player:IsInGroup(2868472) and player:GetRankInGroup(2868472) >= 100 then
            isStaff = true
            reason = "Roblox QA Tester"
        end
    end)
    if isStaff then return true, reason end

    pcall(function()
        if player:IsInGroup(4199740) and player:GetRankInGroup(4199740) >= 100 then
            isStaff = true
            reason = "Roblox Intern"
        end
    end)
    if isStaff then return true, reason end

    return false, ""
end
_G.isRobloxAdminOrStaff = isRobloxAdminOrStaff

function triggerStaffPanic(staffPlayer, reason)
    pcall(function()
        notify("URGENCE ANTI-BAN", "Staff detecte (" .. tostring(reason) .. ") ! Evacuation...", Color3.fromRGB(255, 40, 40))
        task.wait(0.15)
        local ts = game:GetService("TeleportService")
        local success = pcall(function()
            ts:Teleport(game.PlaceId, LocalPlayer)
        end)
        if not success then
            LocalPlayer:Kick("\n\n[PEARL PROTECTION ANTI-BAN]\nUn membre du Staff / Moderateur a ete detecte (" .. tostring(reason) .. ").\nVotre compte a ete deconnecte instantanement pour eviter tout ban !\n")
        end
    end)
end
_G.triggerStaffPanic = triggerStaffPanic

createLabel("STAFF & ANTI-BAN", ProtectionContent)

createToggle("Admin / Staff Join Toast Notifs", false, function(enabled)
    V.AdminJoinNotif = enabled
    notify("Protection", "Notifs Admin Join " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
    if enabled then
        task.spawn(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local isStaff, reason = isRobloxAdminOrStaff(p)
                    if isStaff then
                        notify("ADMIN DÉTECTÉ", p.DisplayName .. " (" .. reason .. ")", Color3.fromRGB(255, 60, 60))
                        if V.AutoPanicStaff then
                            triggerStaffPanic(p, reason)
                        end
                    end
                end
            end
        end)
    end
end, ProtectionContent, "AdminJoinNotif")

createToggle("Auto-Panic / Staff Auto-Leave", false, function(enabled)
    V.AutoPanicStaff = enabled
    notify("Protection", "Auto-Panic Staff " .. (enabled and "ACTIF" or "DÉSACTIVÉ"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
    if enabled then
        task.spawn(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local isStaff, reason = isRobloxAdminOrStaff(p)
                    if isStaff then
                        triggerStaffPanic(p, reason)
                        break
                    end
                end
            end
        end)
    end
end, ProtectionContent, "AutoPanicStaff")

createLabel("DEFENSE & SAFETY", ProtectionContent)

function toggleAntiFling(enabled)
    V.AntiFling = enabled
    if enabled then
        V.AntiFlingConn = RunService.Stepped:Connect(function()
            if not V.AntiFling then return end
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") and part.CanCollide then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end)
        addConnection(V.AntiFlingConn)
        notify("Protection","Anti-Fling ON (Sans collision)", Color3.fromRGB(80, 200, 120))
    else
        if V.AntiFlingConn then V.AntiFlingConn:Disconnect() V.AntiFlingConn = nil end
        notify("Protection","Anti-Fling OFF", Color3.fromRGB(255, 90, 90))
    end
end

createToggle("Anti-Fling (Protection Anti-Propulsion)", false, function(enabled)
    toggleAntiFling(enabled)
end, ProtectionContent,"AntiFling")

createToggle("Anti-Ragdoll (Protection Anti-Chute)", false, function(enabled) toggleAntiRagdoll(enabled) end, ProtectionContent,"AntiRagdoll")

godmodeCharConn = nil
godmodeHealthConn = nil
godmodeStateConn = nil

function setupGodmodeForChar(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 3) or char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    pcall(function()
        hum.RequiresNeck = false
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    end)

    if godmodeHealthConn then godmodeHealthConn:Disconnect() godmodeHealthConn = nil end
    godmodeHealthConn = hum.HealthChanged:Connect(function(newHealth)
        if V.Godmode and newHealth < hum.MaxHealth then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
            end)
        end
    end)

    if godmodeStateConn then godmodeStateConn:Disconnect() godmodeStateConn = nil end
    godmodeStateConn = hum.StateChanged:Connect(function(old, new)
        if V.Godmode and new == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum.Health = hum.MaxHealth
            end)
        end
    end)
end

function disableHazardParts()
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") then
                local p = obj.Parent
                if p and p:IsA("BasePart") then
                    local n = p.Name:lower()
                    if n:find("kill") or n:find("lava") or n:find("acid") or n:find("dead") or n:find("death") or n:find("hazard") or n:find("spikes") or n:find("dmg") or n:find("damage") then
                        p.CanTouch = false
                    end
                end
            end
        end
    end)
end

function toggleGodmode(enabled)
    V.Godmode = enabled
    if V.GodmodeConn then V.GodmodeConn:Disconnect() V.GodmodeConn = nil end
    if godmodeHealthConn then godmodeHealthConn:Disconnect() godmodeHealthConn = nil end
    if godmodeStateConn then godmodeStateConn:Disconnect() godmodeStateConn = nil end
    if godmodeCharConn then godmodeCharConn:Disconnect() godmodeCharConn = nil end

    if enabled then
        setupGodmodeForChar(LocalPlayer.Character)
        disableHazardParts()

        V.GodmodeConn = RunService.RenderStepped:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.RequiresNeck = false
                    hum.BreakJointsOnDeath = false
                    if hum.Health > 0 and hum.Health < hum.MaxHealth then
                        hum.Health = hum.MaxHealth
                    end
                    if hum:GetState() == Enum.HumanoidStateType.Dead then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        hum.Health = hum.MaxHealth
                    end
                end
            end)
        end)
        addConnection(V.GodmodeConn)

        godmodeCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
            if V.Godmode then
                task.wait(0.3)
                setupGodmodeForChar(newChar)
                disableHazardParts()
            end
        end)
        addConnection(godmodeCharConn)
    else
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.RequiresNeck = true
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end)
    end
    notify("Protection","Godmode ".. (enabled and "ON (Invincible + Anti-Killparts)" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end

createToggle("Godmode (Invincible + Régèn)", false, function(enabled)
    toggleGodmode(enabled)
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

createLabel("STREAMER & ANONYMAT", ProtectionContent)
do
    local streamerModeActive = false
    local streamerConns = {}
    local propertyConns = {}
    local originalTextMap = {}
    local originalDisplayNames = {}
    local originalImages = {}

    local fakeName = "Guest_1337"
    local fakeUserId = "1337"
    local fakeAvatar = "rbxassetid://1085959147" -- Headshot classique Bacon Hair / Guest

    local function safeReplace(text, target, repl)
        if not text or text == "" or not target or target == "" then return text end
        local s, e = text:find(target, 1, true)
        if not s then return text end
        local parts = {}
        local lastPos = 1
        while s do
            table.insert(parts, text:sub(lastPos, s - 1))
            table.insert(parts, repl)
            lastPos = e + 1
            s, e = text:find(target, lastPos, true)
        end
        table.insert(parts, text:sub(lastPos))
        return table.concat(parts)
    end

    local function sanitizeText(t, rName, rDisplay, rUserId)
        if not t or t == "" then return t, false end
        local modified = false
        if rName ~= "" and t:find(rName, 1, true) then
            t = safeReplace(t, rName, fakeName)
            modified = true
        end
        if rDisplay ~= "" and t:find(rDisplay, 1, true) then
            t = safeReplace(t, rDisplay, fakeName)
            modified = true
        end
        if rUserId ~= "" and t:find(rUserId, 1, true) then
            t = safeReplace(t, rUserId, fakeUserId)
            modified = true
        end
        return t, modified
    end

    local function processTextElement(desc, rName, rDisplay, rUserId)
        if not desc or not desc.Parent then return end
        if not (desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox")) then return end
        local t = desc.Text
        if not t or t == "" then return end
        local newT, modified = sanitizeText(t, rName, rDisplay, rUserId)
        if modified then
            if originalTextMap[desc] == nil then
                originalTextMap[desc] = t
            end
            if desc.Text ~= newT then
                desc.Text = newT
            end
        end

        if not propertyConns[desc] then
            propertyConns[desc] = desc:GetPropertyChangedSignal("Text"):Connect(function()
                if not streamerModeActive then return end
                local cur = desc.Text
                if not cur or cur == "" then return end
                local cleaned, wasMod = sanitizeText(cur, rName, rDisplay, rUserId)
                if wasMod and desc.Text ~= cleaned then
                    desc.Text = cleaned
                end
            end)
        end
    end

    local function processImageElement(desc, rUserId)
        if not desc or not desc.Parent then return end
        if not (desc:IsA("ImageLabel") or desc:IsA("ImageButton")) then return end
        local img = desc.Image or ""
        local isPfp = false
        if rUserId ~= "" and img:find(rUserId, 1, true) then
            isPfp = true
        else
            local nameLower = desc.Name:lower()
            if nameLower:find("avatar", 1, true) or nameLower:find("profile", 1, true) or nameLower:find("pfp", 1, true) or nameLower:find("headshot", 1, true) then
                isPfp = true
            end
        end
        if isPfp then
            if originalImages[desc] == nil then
                originalImages[desc] = img
            end
            if desc.Image ~= fakeAvatar then
                desc.Image = fakeAvatar
            end
        end
    end

    local function hookCharacter(char, rName, rDisplay, rUserId)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if originalDisplayNames[hum] == nil then
                originalDisplayNames[hum] = hum.DisplayName
            end
            pcall(function() hum.DisplayName = fakeName end)
        end

        for _, desc in ipairs(char:GetDescendants()) do
            processTextElement(desc, rName, rDisplay, rUserId)
        end

        local cConn = char.DescendantAdded:Connect(function(desc)
            if not streamerModeActive then return end
            processTextElement(desc, rName, rDisplay, rUserId)
        end)
        table.insert(streamerConns, cConn)
    end

    local function applyStreamerSpoof()
        local rName = LocalPlayer.Name or ""
        local rDisplay = LocalPlayer.DisplayName or ""
        local rUserId = tostring(LocalPlayer.UserId or "")

        -- 1. Perso local
        hookCharacter(LocalPlayer.Character, rName, rDisplay, rUserId)

        -- Listener pour le respawn
        local charAddedConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
            if not streamerModeActive then return end
            task.wait(0.1)
            hookCharacter(newChar, rName, rDisplay, rUserId)
        end)
        table.insert(streamerConns, charAddedConn)

        -- 2. PlayerGui initial scan + event listener
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pGui then
            for _, desc in ipairs(pGui:GetDescendants()) do
                processTextElement(desc, rName, rDisplay, rUserId)
                processImageElement(desc, rUserId)
            end

            local pGuiConn = pGui.DescendantAdded:Connect(function(desc)
                if not streamerModeActive then return end
                processTextElement(desc, rName, rDisplay, rUserId)
                processImageElement(desc, rUserId)
            end)
            table.insert(streamerConns, pGuiConn)
        end

        -- 3. Safe HUI scan (CoreGui scan removed to prevent Adonis detection)
        pcall(function()
            if gethui then
                local hui = gethui()
                if hui then
                    for _, desc in ipairs(hui:GetDescendants()) do
                        processTextElement(desc, rName, rDisplay, rUserId)
                        processImageElement(desc, rUserId)
                    end
                end
            end
        end)
    end

    local function restoreStreamerOriginals()
        for _, conn in ipairs(streamerConns) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(streamerConns)

        for desc, conn in pairs(propertyConns) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(propertyConns)

        for obj, origText in pairs(originalTextMap) do
            if obj and obj.Parent then
                pcall(function() obj.Text = origText end)
            end
        end
        table.clear(originalTextMap)

        for obj, origImg in pairs(originalImages) do
            if obj and obj.Parent then
                pcall(function() obj.Image = origImg end)
            end
        end
        table.clear(originalImages)

        for hum, origDisp in pairs(originalDisplayNames) do
            if hum and hum.Parent then
                pcall(function() hum.DisplayName = origDisp end)
            end
        end
        table.clear(originalDisplayNames)
    end

    local function toggleStreamerMode(enabled)
        streamerModeActive = enabled
        V.StreamerMode = enabled

        restoreStreamerOriginals()

        if enabled then
            applyStreamerSpoof()
            notify("Protection", "Mode Streamer ACTIF (Identite Spoofee : " .. fakeName .. ")", Color3.fromRGB(80, 200, 120))
        else
            notify("Protection", "Mode Streamer DESACTIVE (Identite Restauree)", Color3.fromRGB(255, 90, 90))
        end
    end

    createToggle("Mode Streamer (Spoof Identite)", false, function(enabled)
        toggleStreamerMode(enabled)
    end, ProtectionContent, "StreamerMode")

    local fakeNamesList = {"Guest_1337", "Noob_Player", "BaconHair", "Anonymous", "Player1"}
    createButton("Changer Pseudo Fake", function()
        local cur = fakeName
        local idx = 1
        for i, n in ipairs(fakeNamesList) do
            if n == cur then idx = i break end
        end
        idx = (idx % #fakeNamesList) + 1
        fakeName = fakeNamesList[idx]
        if streamerModeActive then
            restoreStreamerOriginals()
            applyStreamerSpoof()
        end
        notify("Protection", "Nouveau Pseudo Fake : " .. fakeName, Color3.fromRGB(145, 120, 255))
    end, ProtectionContent, "Changer")
end


createLabel("PLAYER PHYSICS", MeContent)

_, SetNoclipToggle, ToggleNoclip = createToggle("Noclip", false, function(enabled)
    if enabled then startNoclip() else stopNoclip() end
    notify("Me","Noclip".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"Noclip")

createToggle("No Animations", false, function(enabled)
    if enabled then enableNoAnim() else disableNoAnim() end
end, MeContent,"NoAnim")
_, SetInvisToggle, ToggleInvis = createToggle("Invisible", false, function(enabled)
    toggleInvisibility(enabled)
end, MeContent, "Invis")

-- Enregistrer le callback de la touche Invisible (Bind C) immediatement
KeybindCallbacks["Invisible"] = function()
    if ToggleInvis then
        ToggleInvis()
    else
        toggleInvisibility()
    end
end

createToggle("Infinite Jump", false, function(enabled)
    V.InfJump = enabled
    if V.InfJumpConn then
        V.InfJumpConn:Disconnect()
        V.InfJumpConn = nil
    end
    if enabled then
        V.InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if V.InfJump then
                pcall(function()
                    local hum = getHumanoid()
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
        end)
        addConnection(V.InfJumpConn)
    end
    notify("Me","Infinite Jump".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent,"InfJump")

createLabel("VISUALS & INTERACTIONS", MeContent)
createToggle("Instant Interact (Universal)", false, function(enabled) toggleInstantInteract(enabled) end, MeContent,"InstInteract")
createToggle("Infinite Interact Range", false, function(enabled) toggleInfiniteRange(enabled) end, MeContent,"InfRange")

createLabel("CAMERA", MeContent)
createSlider("FOV Changer", 70, 120, 70, function(val)
    V.FOV = val
    V.CustomFOV = (val ~= 70)
    if val == 70 then
        Camera.FieldOfView = 70
    else
        Camera.FieldOfView = val
    end
end, MeContent,"FOV")

if not _G.NebulaFOVLockSignal then
    _G.NebulaFOVLockSignal = Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        if V and V.CustomFOV and V.FOV and V.FOV ~= 70 then
            if Camera.FieldOfView ~= V.FOV then
                Camera.FieldOfView = V.FOV
            end
        end
    end)
    addConnection(_G.NebulaFOVLockSignal)
end

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
FreecamCrosshair.Name ="PearlFreecamCrosshair"
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

function teleportPlayerFromFreecam(mode, exitFreecam)
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local ghostPart = V.FreecamGhostPart or workspace:FindFirstChild("SeGhost")
        local targetCF = nil
        local refPos = ghostPart and ghostPart.Position or Camera.CFrame.Position
        local refCF = ghostPart and ghostPart.CFrame or Camera.CFrame

        if mode == "Ground" then
            local rayOrigin = refPos
            local rayDirection = Camera.CFrame.LookVector * 1500
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {char, ghostPart}
            local result = workspace:Raycast(rayOrigin, rayDirection, params)
            if result then
                targetCF = CFrame.new(result.Position + Vector3.new(0, 3.5, 0), result.Position + Vector3.new(0, 3.5, 0) + Camera.CFrame.LookVector * Vector3.new(1, 0, 1))
            else
                local downRay = workspace:Raycast(rayOrigin, Vector3.new(0, -2000, 0), params)
                if downRay then
                    targetCF = CFrame.new(downRay.Position + Vector3.new(0, 3.5, 0))
                else
                    targetCF = refCF
                end
            end
        else
            targetCF = refCF
        end

        V.FreecamOriginalCharCF = nil
        hrp.CFrame = targetCF + Vector3.new(0, 1.5, 0)
        hrp.Anchored = false
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = hum

        if hum then
            if V.SpeedEnabled and V.Speed then
                hum.WalkSpeed = V.Speed
            else
                local restoredSpeed = V._FreecamPreWalkSpeed or (_OrigWalkSpeed and _OrigWalkSpeed >= 16 and _OrigWalkSpeed) or 16
                hum.WalkSpeed = restoredSpeed
            end

            if V.JumpEnabled and V.Jump then
                hum.UseJumpPower = true
                hum.JumpPower = V.Jump
            else
                if V._FreecamPreUseJumpPower ~= nil then
                    hum.UseJumpPower = V._FreecamPreUseJumpPower
                end
                local restoredJump = V._FreecamPreJumpPower or (_OrigJumpPower and _OrigJumpPower > 0 and _OrigJumpPower) or 50
                hum.JumpPower = restoredJump

                local restoredJumpHeight = V._FreecamPreJumpHeight or (_OrigJumpHeight and _OrigJumpHeight > 0 and _OrigJumpHeight) or 7.2
                hum.JumpHeight = restoredJumpHeight
            end

            hum.AutoRotate = true
            hum.PlatformStand = false
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)

            task.delay(0.08, function()
                pcall(function()
                    if hum and hum.Parent then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end)
        end

        V.FreecamCharVisible = true
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "HumanoidRootPart" then
                    part.CanCollide = false
                else
                    part.CanCollide = true
                end
                part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                part.LocalTransparencyModifier = 0
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
            end
        end

        if exitFreecam then
            V._FreecamExplicitTP = true
            V.FreecamOriginalCharCF = nil
            if ghostPart then pcall(function() ghostPart:Destroy() end) V.FreecamGhostPart = nil end
            if SetFreecamToggle then SetFreecamToggle(false) else V.Freecam = false end
            notify("Freecam", "Teleporte (" .. (mode == "Ground" and "Sol" or "Ghost") .. ") - Freecam Fermee", Color3.fromRGB(80, 200, 120))
        else
            V.FreecamOriginalCharCF = hrp.CFrame
            notify("Freecam", "Teleporte (" .. (mode == "Ground" and "Sol" or "Ghost") .. ") - Perso Visible", Color3.fromRGB(80, 200, 120))
        end
    end)
end

FreecamOptionsList = {
    {Name = "TP Perso -> Sol Vise (Safe)", Action = function()
        teleportPlayerFromFreecam("Ground", false)
    end},
    {Name = "TP Perso -> Position Camera", Action = function()
        teleportPlayerFromFreecam("Cam", false)
    end},
    {Name = "TP & Quitter Freecam", Action = function()
        teleportPlayerFromFreecam(V.FreecamTPTargetMode or "Ground", true)
    end},
    {Name = "Fermer Menu (Garder Freecam)", Action = function()
        if FreecamMenu then FreecamMenu.Enabled = false end
        notify("Freecam", "Menu masque. Appuie sur X pour quitter la Freecam.", Color3.fromRGB(180, 180, 195))
    end}
}

function updateFreecamMenuVisuals(hoverIndex)
    local activeIndex = hoverIndex or FreecamSelectedIndex
    for i, btn in ipairs(FreecamMenuLabels) do
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if i == activeIndex then
            btn.BackgroundColor3 = theme.accent
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = "  > " .. FreecamOptionsList[i].Name
            if stroke then stroke.Color = theme.accent end
        else
            btn.BackgroundColor3 = theme.card
            btn.TextColor3 = theme.text
            btn.Text = "    " .. FreecamOptionsList[i].Name
            if stroke then stroke.Color = theme.border end
        end
    end
end

function createFreecamMenu()
    if FreecamMenu then FreecamMenu:Destroy() end
    FreecamMenu = Instance.new("ScreenGui")
    FreecamMenu.Name = "PearlFreecamMenu"
    FreecamMenu.ResetOnSpawn = false
    FreecamMenu.DisplayOrder = 999
    FreecamMenu.Enabled = false
    FreecamMenu.Parent = parentTarget

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 310, 0, 215)
    MainFrame.Position = UDim2.new(0, 30, 0.5, -107)
    MainFrame.BackgroundColor3 = theme.panel
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = FreecamMenu

    makeCorner(MainFrame, 12)
    makeStroke(MainFrame, theme.border, 1.2)

    local TopAccent = Instance.new("Frame")
    TopAccent.Size = UDim2.new(1, -24, 0, 2)
    TopAccent.Position = UDim2.new(0, 12, 0, 0)
    TopAccent.BackgroundColor3 = theme.accent
    TopAccent.BorderSizePixel = 0
    TopAccent.Parent = MainFrame
    makeCorner(TopAccent, 2)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, -16, 0, 42)
    TitleBar.Position = UDim2.new(0, 8, 0, 8)
    TitleBar.BackgroundColor3 = theme.panel2
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    makeCorner(TitleBar, 8)
    makeStroke(TitleBar, theme.border, 1)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -16, 0, 18)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "FREECAM"
    Title.TextColor3 = theme.accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Size = UDim2.new(1, -16, 0, 14)
    SubTitle.Position = UDim2.new(0, 10, 0, 23)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "ZQSD: Voler  •  Entree / T: TP"
    SubTitle.TextColor3 = theme.sub
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.TextSize = 10
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.Parent = TitleBar

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "List"
    ListFrame.Size = UDim2.new(1, -16, 1, -60)
    ListFrame.Position = UDim2.new(0, 8, 0, 56)
    ListFrame.BackgroundTransparency = 1
    ListFrame.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = ListFrame

    FreecamMenuLabels = {}
    for i, opt in ipairs(FreecamOptionsList) do
        local btn = Instance.new("TextButton")
        btn.LayoutOrder = i
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = theme.card
        btn.AutoButtonColor = false
        btn.Text = "    " .. opt.Name
        btn.TextColor3 = theme.text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.Parent = ListFrame

        makeCorner(btn, 8)
        makeStroke(btn, theme.border, 1)

        btn.MouseEnter:Connect(function()
            updateFreecamMenuVisuals(i)
        end)
        btn.MouseLeave:Connect(function()
            updateFreecamMenuVisuals(nil)
        end)
        btn.MouseButton1Click:Connect(function()
            pcall(function() GuiService.SelectedObject = nil end)
            FreecamSelectedIndex = i
            opt.Action()
        end)

        table.insert(FreecamMenuLabels, btn)
    end

    updateFreecamMenuVisuals(nil)
end

createFreecamMenu()


_, SetFreecamToggle, ToggleFreecam = createToggle("Freecam", false, function(enabled)
    V.Freecam = enabled
    pcall(function() GuiService.SelectedObject = nil end)
    if enabled then
        if V and V.GhostDesync and _G.ensureGhostDesyncRestored then _G.ensureGhostDesyncRestored() end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        V.FreecamOriginalCharCF = hrp.CFrame

        -- Sauvegarde des vitesses et puissances de saut reelles du joueur
        if hum.WalkSpeed and hum.WalkSpeed > 0 then
            V._FreecamPreWalkSpeed = hum.WalkSpeed
        end
        if hum.JumpPower and hum.JumpPower > 0 then
            V._FreecamPreJumpPower = hum.JumpPower
        end
        if hum.JumpHeight and hum.JumpHeight > 0 then
            V._FreecamPreJumpHeight = hum.JumpHeight
        end
        V._FreecamPreUseJumpPower = hum.UseJumpPower

        -- Nettoyage de tout ancien SeGhost
        local oldGhost = workspace:FindFirstChild("SeGhost") or V.FreecamGhostPart
        if oldGhost then pcall(function() oldGhost:Destroy() end) V.FreecamGhostPart = nil end

        -- Creation de la Ghost Part (carre bleu / cyan neon avec Highlight)
        local invisPart = Instance.new("Part")
        invisPart.Name = "SeGhost"
        invisPart.Size = Vector3.new(4, 5, 4)
        invisPart.Color = Color3.fromRGB(0, 255, 255)
        invisPart.Material = Enum.Material.Neon
        invisPart.Transparency = 0.6
        invisPart.Anchored = true
        invisPart.CanCollide = false
        invisPart.CFrame = hrp.CFrame
        invisPart.Parent = workspace

        local hl = Instance.new("Highlight")
        hl.Name = "SeGhostHighlight"
        hl.FillColor = Color3.fromRGB(0, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(0, 255, 255)
        hl.OutlineTransparency = 0
        hl.Adornee = invisPart
        hl.Parent = invisPart

        V.FreecamGhostPart = invisPart

        -- Immobiliser le vrai perso sur place de facon invisible sans l'envoyer dans le vide
        hrp.Anchored = true
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.JumpHeight = 0
        hum.AutoRotate = false

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

        -- La camera suit la Ghost Part directement en 3eme personne
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = invisPart
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        if FreecamCrosshair then FreecamCrosshair.Enabled = false end

        -- Boucle de deplacement du SeGhost (ZQSD ou WASD + Espace/Ctrl)
        if V.FreecamConn then V.FreecamConn:Disconnect() end
        V.FreecamConn = RunService.RenderStepped:Connect(function(dt)
            if not V.Freecam or not V.FreecamGhostPart or not V.FreecamGhostPart.Parent then return end
            workspace.CurrentCamera.CameraSubject = V.FreecamGhostPart

            local cam = workspace.CurrentCamera
            local move = Vector3.zero
            local isFwd = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
            local isLeft = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
            local isBack = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
            local isRight = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)

            if isFwd then move = move + cam.CFrame.LookVector end
            if isBack then move = move - cam.CFrame.LookVector end
            if isLeft then move = move - cam.CFrame.RightVector end
            if isRight then move = move + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

            local ghostSpeed = V.FreecamSpeed or 60
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                ghostSpeed = ghostSpeed * 2.2
            end

            if move.Magnitude > 0 then
                local direction = move.Unit
                V.FreecamGhostPart.CFrame = V.FreecamGhostPart.CFrame + (direction * ghostSpeed * dt)
            end
        end)
        addConnection(V.FreecamConn)

        if FreecamMenu then
            FreecamMenu.Enabled = true
            FreecamSelectedIndex = 1
            updateFreecamMenuVisuals(nil)
        end

        if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() end
        V.FreecamMenuConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if FreecamMenu and FreecamMenu.Enabled then
                local key = input.KeyCode
                if key == Enum.KeyCode.Down then
                    if FreecamSelectedIndex < #FreecamOptionsList then
                        FreecamSelectedIndex = FreecamSelectedIndex + 1
                    else
                        FreecamSelectedIndex = 1
                    end
                    updateFreecamMenuVisuals(nil)
                elseif key == Enum.KeyCode.Up then
                    if FreecamSelectedIndex > 1 then
                        FreecamSelectedIndex = FreecamSelectedIndex - 1
                    else
                        FreecamSelectedIndex = #FreecamOptionsList
                    end
                    updateFreecamMenuVisuals(nil)
                elseif key == Enum.KeyCode.Return or key == Enum.KeyCode.KeypadEnter or key == Enum.KeyCode.Right or key == Enum.KeyCode.T then
                    pcall(function() GuiService.SelectedObject = nil end)
                    if FreecamOptionsList[FreecamSelectedIndex] and FreecamOptionsList[FreecamSelectedIndex].Action then
                        FreecamOptionsList[FreecamSelectedIndex].Action()
                    end
                end
            end
        end)
        addConnection(V.FreecamMenuConn)

        notify("Me", "Freecam Ghost ON (ZQSD pour voler, Espace/Ctrl = Haut/Bas, Entree/T = TP)", Color3.fromRGB(0, 255, 255))
    else
        if V.FreecamConn then V.FreecamConn:Disconnect() V.FreecamConn = nil end
        if V.FreecamMenuConn then V.FreecamMenuConn:Disconnect() V.FreecamMenuConn = nil end

        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local ghostPart = V.FreecamGhostPart or workspace:FindFirstChild("SeGhost")

            if hrp then
                if V._FreecamExplicitTP then
                    V._FreecamExplicitTP = nil
                elseif V.FreecamTPOnDisable then
                    local camCF = Camera.CFrame
                    local destPos = (ghostPart and ghostPart.Position) or camCF.Position
                    local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
                    local destCF
                    if flatLook.Magnitude > 0.01 then
                        destCF = CFrame.lookAt(destPos, destPos + flatLook.Unit)
                    else
                        destCF = CFrame.new(destPos)
                    end
                    pcall(function() LocalPlayer:RequestStreamAroundAsync(destPos) end)
                    hrp.CFrame = destCF
                else
                    -- Fermeture normale (touche/bind ou toggle) : PAS DE TP, retour exact au perso !
                    if V.FreecamOriginalCharCF then
                        hrp.CFrame = V.FreecamOriginalCharCF
                    end
                end
                V.FreecamOriginalCharCF = nil
                hrp.Anchored = false
                pcall(function()
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end

            if hum then
                Camera.CameraSubject = hum
                Camera.CameraType = Enum.CameraType.Custom

                -- Restauration exacte de la vitesse
                if V.SpeedEnabled and V.Speed then
                    hum.WalkSpeed = V.Speed
                else
                    local restoredSpeed = V._FreecamPreWalkSpeed or (_OrigWalkSpeed and _OrigWalkSpeed >= 16 and _OrigWalkSpeed) or 16
                    hum.WalkSpeed = restoredSpeed
                end

                -- Restauration exacte du saut (JumpPower & JumpHeight)
                if V.JumpEnabled and V.Jump then
                    hum.UseJumpPower = true
                    hum.JumpPower = V.Jump
                else
                    if V._FreecamPreUseJumpPower ~= nil then
                        hum.UseJumpPower = V._FreecamPreUseJumpPower
                    end
                    local restoredJump = V._FreecamPreJumpPower or (_OrigJumpPower and _OrigJumpPower > 0 and _OrigJumpPower) or 50
                    hum.JumpPower = restoredJump

                    local restoredJumpHeight = V._FreecamPreJumpHeight or (_OrigJumpHeight and _OrigJumpHeight > 0 and _OrigJumpHeight) or 7.2
                    hum.JumpHeight = restoredJumpHeight
                end

                hum.AutoRotate = true
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)

                task.delay(0.08, function()
                    pcall(function()
                        if hum and hum.Parent then
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                end)
            end

            -- Restauration propre des collisions : HumanoidRootPart ne DOIT JAMAIS avoir CanCollide = true
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name == "HumanoidRootPart" then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                    part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                    part:SetAttribute("_FreecamOrigTrans", nil)
                    part.LocalTransparencyModifier = 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
                    part:SetAttribute("_FreecamOrigTrans", nil)
                end
            end
        end

        local gPart = V.FreecamGhostPart or workspace:FindFirstChild("SeGhost")
        if gPart then
            pcall(function() gPart:Destroy() end)
            V.FreecamGhostPart = nil
        end

        Camera.CameraType = Enum.CameraType.Custom
        if FreecamMenu then FreecamMenu.Enabled = false end
        if FreecamCrosshair then FreecamCrosshair.Enabled = false end

        if V.FreecamTPOnDisable then
            notify("Freecam", "Freecam OFF - Perso TP sur Caméra", Color3.fromRGB(80, 200, 120))
        else
            notify("Freecam", "Freecam OFF (Camera Replacee)", Color3.fromRGB(255, 90, 90))
        end
    end
end, MeContent, "Freecam")
createSlider("Freecam Speed", 10, 500, 50, function(val) V.FreecamSpeed = val end, MeContent,"FreecamSpeed")
createToggle("Freecam Cible TP : Sol (ON) / Caméra (OFF)", true, function(enabled)
    V.FreecamTPTargetMode = enabled and "Ground" or "Cam"
    notify("Freecam", "Cible TP Freecam : " .. (enabled and "Sol visé" or "Position Caméra"), Color3.fromRGB(80, 200, 120))
end, MeContent, "FreecamTPMode")
createToggle("Freecam TP sur Caméra (Off Freecam)", false, function(enabled)
    V.FreecamTPOnDisable = enabled
    notify("Freecam", "TP à la caméra au Off : " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, MeContent, "FreecamTPOnDisable")

createLabel("GHOST DESYNC / FAKE-LAG", MeContent)
local function ensureGhostDesyncRestored()
    if not V or not V._GhostDesyncSpoofed then return end
    local c = LocalPlayer.Character
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if r and r.Parent then
        if V._GhostDesyncLastSpoofCF and (r.CFrame.Position - V._GhostDesyncLastSpoofCF.Position).Magnitude > 12 then
            V._GhostDesyncRealCF = r.CFrame
        elseif V._GhostDesyncRealCF then
            r.CFrame = V._GhostDesyncRealCF
            if V._GhostDesyncRealVel then r.AssemblyLinearVelocity = V._GhostDesyncRealVel end
            if V._GhostDesyncRealAngVel then r.AssemblyAngularVelocity = V._GhostDesyncRealAngVel end
        end
    end
    V._GhostDesyncSpoofed = false
end
_G.ensureGhostDesyncRestored = ensureGhostDesyncRestored

local function cleanupGhostDesync()
    pcall(ensureGhostDesyncRestored)
    pcall(function() RunService:UnbindFromRenderStep("PearlGhostDesyncRender") end)
    if V and V._GhostDesyncConn then
        pcall(function() V._GhostDesyncConn:Disconnect() end)
        V._GhostDesyncConn = nil
    end
    if V and V._GhostDesyncSteppedConn then
        pcall(function() V._GhostDesyncSteppedConn:Disconnect() end)
        V._GhostDesyncSteppedConn = nil
    end
    if V and V._GhostDesyncBox then
        pcall(function() V._GhostDesyncBox:Destroy() end)
        V._GhostDesyncBox = nil
    end
    local leftover = workspace:FindFirstChild("PearlGhostDesyncBox")
    if leftover then pcall(function() leftover:Destroy() end) end
    if V then
        V._GhostDesyncSpoofed = false
        V._GhostDesyncRealCF = nil
        V._GhostDesyncServerCF = nil
        V._GhostDesyncLastSpoofCF = nil
    end
end
_G.cleanupGhostDesync = cleanupGhostDesync

createToggle("Ghost Desync (Fake-Lag Positionnel)", false, function(enabled)
    V.GhostDesync = enabled
    if enabled then
        cleanupGhostDesync()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notify("Me", "Personnage introuvable !", Color3.fromRGB(255, 90, 90))
            V.GhostDesync = false
            return
        end

        V._GhostDesyncRealCF = hrp.CFrame
        V._GhostDesyncRealVel = hrp.AssemblyLinearVelocity
        V._GhostDesyncRealAngVel = hrp.AssemblyAngularVelocity
        V._GhostDesyncServerCF = hrp.CFrame
        V._GhostDesyncLastSpoofCF = hrp.CFrame
        V._GhostDesyncSpoofed = false
        V._GhostDesyncTick = 0

        local boxPart = Instance.new("Part")
        boxPart.Name = "PearlGhostDesyncBox"
        boxPart.Size = Vector3.new(3.8, 5.2, 2.2)
        boxPart.Anchored = true
        boxPart.CanCollide = false
        boxPart.CanQuery = false
        boxPart.CanTouch = false
        boxPart.CastShadow = false
        boxPart.Transparency = 1
        boxPart.CFrame = V._GhostDesyncServerCF * CFrame.new(0, -0.4, 0)
        boxPart.Parent = workspace

        local col = (theme and theme.accent) or Colors.Accent or Color3.fromRGB(145, 120, 255)
        local selBox = Instance.new("SelectionBox")
        selBox.Name = "GhostServerBox"
        selBox.Adornee = boxPart
        selBox.Color3 = col
        selBox.LineThickness = 0.045
        selBox.SurfaceColor3 = col
        selBox.SurfaceTransparency = 0.84
        selBox.Parent = boxPart
        V._GhostDesyncBox = boxPart

        RunService:BindToRenderStep("PearlGhostDesyncRender", Enum.RenderPriority.First.Value, function()
            if not V.GhostDesync or V.Freecam then return end
            ensureGhostDesyncRestored()
        end)

        V._GhostDesyncSteppedConn = RunService.Stepped:Connect(function()
            if not V.GhostDesync or V.Freecam then return end
            ensureGhostDesyncRestored()
        end)
        addConnection(V._GhostDesyncSteppedConn)

        V._GhostDesyncConn = RunService.Heartbeat:Connect(function(dt)
            if not V.GhostDesync or V.Freecam then return end
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if not h or not r or h.Health <= 0 then return end
            if h.SeatPart or h.Sit then
                V._GhostDesyncSpoofed = false
                V._GhostDesyncServerCF = r.CFrame
                if V._GhostDesyncBox and V._GhostDesyncBox.Parent then
                    V._GhostDesyncBox.CFrame = V._GhostDesyncServerCF * CFrame.new(0, -0.4, 0)
                end
                return
            end

            if not V._GhostDesyncSpoofed then
                V._GhostDesyncRealCF = r.CFrame
                V._GhostDesyncRealVel = r.AssemblyLinearVelocity
                V._GhostDesyncRealAngVel = r.AssemblyAngularVelocity
                V._GhostDesyncTick = (V._GhostDesyncTick or 0) + dt

                if V._GhostDesyncTick >= 0.40 then
                    V._GhostDesyncTick = 0
                    V._GhostDesyncServerCF = V._GhostDesyncRealCF
                else
                    V._GhostDesyncSpoofed = true
                    V._GhostDesyncLastSpoofCF = V._GhostDesyncServerCF
                    r.CFrame = V._GhostDesyncServerCF
                    r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    r.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end

            if V._GhostDesyncBox and V._GhostDesyncBox.Parent and V._GhostDesyncServerCF then
                V._GhostDesyncBox.CFrame = V._GhostDesyncServerCF * CFrame.new(0, -0.4, 0)
                local sb = V._GhostDesyncBox:FindFirstChildOfClass("SelectionBox")
                if sb then
                    local curCol = (theme and theme.accent) or Colors.Accent or Color3.fromRGB(145, 120, 255)
                    sb.Color3 = curCol
                    sb.SurfaceColor3 = curCol
                end
            end
        end)
        addConnection(V._GhostDesyncConn)
        notify("Me", "Ghost Desync ACTIVÉ — 0 lag client + Box 3D serveur", Color3.fromRGB(80, 200, 120))
    else
        cleanupGhostDesync()
        notify("Me", "Ghost Desync DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end, MeContent, "GhostDesync")


createLabel("ACTIONS", MeContent)

V.KillAll = false
createToggle('kill all <font color="rgb(175,110,255)">(weapons games)</font>', false, function(enabled)
    V.KillAll = enabled
    if enabled then
        notify("Me", "Kill All (weapons games) ACTIVÉ", Color3.fromRGB(80, 200, 120))
        task.spawn(function()
            while V.KillAll do
                local myChar = LocalPlayer.Character
                local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                
                if not myChar or not myHum or not myHrp or myHum.Health <= 0 then
                    task.wait(0.25)
                    continue
                end
                
                local foundEnemy = false
                local playersList = Players:GetPlayers()
                
                for _, p in ipairs(playersList) do
                    if not V.KillAll then break end
                    if p == LocalPlayer then continue end
                    
                    -- Ignorer les alliés (même équipe)
                    local isAlly = false
                    if LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then
                        isAlly = true
                    elseif LocalPlayer.TeamColor and p.TeamColor and LocalPlayer.TeamColor == p.TeamColor then
                        isAlly = true
                    end
                    if isAlly then continue end
                    
                    local targetChar = p.Character
                    if not targetChar then continue end
                    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
                    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso")
                    
                    if not targetHum or not targetHrp or targetHum.Health <= 0 then continue end
                    if targetChar:FindFirstChildOfClass("ForceField") then continue end
                    
                    foundEnemy = true
                    
                    -- Équiper une arme si pas déjà équipée
                    local tool = myChar:FindFirstChildOfClass("Tool")
                    if not tool then
                        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                        if backpack then
                            local bpTool = backpack:FindFirstChildOfClass("Tool")
                            if bpTool then
                                pcall(function() myHum:EquipTool(bpTool) end)
                                task.wait(0.04)
                                tool = myChar:FindFirstChildOfClass("Tool") or bpTool
                            end
                        end
                    end
                    
                    -- Reste sur CET ennemi tant qu'il n'est pas mort
                    while V.KillAll and targetHum and targetHum.Health > 0 and targetChar.Parent and p.Parent do
                        if targetChar:FindFirstChildOfClass("ForceField") then break end
                        
                        myChar = LocalPlayer.Character
                        myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
                        myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                        if not myChar or not myHum or not myHrp or myHum.Health <= 0 then break end
                        
                        -- Collé directement sur la personne (1.1 studs dans le dos) et orienté vers lui
                        local lookVec = targetHrp.CFrame.LookVector
                        local behindPos = targetHrp.Position - (lookVec * 1.1) + Vector3.new(0, 0.1, 0)
                        
                        pcall(function()
                            myHrp.AssemblyLinearVelocity = Vector3.zero
                            myHrp.AssemblyAngularVelocity = Vector3.zero
                            myHrp.CFrame = CFrame.lookAt(behindPos, targetHrp.Position)
                            
                            -- Caméra bien tournée vers la tête / torse de la cible
                            local cam = workspace.CurrentCamera or Camera
                            if cam then
                                local targetAim = targetChar:FindFirstChild("Head") or targetHrp
                                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, targetAim.Position)
                            end
                        end)
                        
                        -- Attaque avec l'arme
                        if tool and tool.Parent == myChar then
                            pcall(function() tool:Activate() end)
                        else
                            local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
                            if backpack then
                                local bpTool = backpack:FindFirstChildOfClass("Tool")
                                if bpTool then
                                    pcall(function() myHum:EquipTool(bpTool) end)
                                    tool = myChar:FindFirstChildOfClass("Tool") or bpTool
                                end
                            end
                            if tool then
                                pcall(function() tool:Activate() end)
                            end
                        end
                        
                        task.wait(0.09)
                    end
                    
                    task.wait(0.05)
                end
                
                if not foundEnemy then
                    task.wait(0.25)
                end
            end
        end)
    else
        notify("Me", "Kill All (weapons games) DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end, MeContent, "KillAll")

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

--------------------------------------------------------------------------------
-- MOVEMENT RECORDER & REPLAY (MACRO) - CATEGORIE ME
--------------------------------------------------------------------------------
MeKeybindButtons = MeKeybindButtons or {}

local isMovementRecording = false
local isMovementReplaying = false
local movementRecordData = {}
local movementRecordConn = nil
local movementReplayConn = nil
local movementNoclipConn = nil
local movementRecordStartTime = 0
local movementDuration = 0
local movementReplayLastIdx = 1

local recActionBtn, repActionBtn, recKeyBtn, repKeyBtn, statusLbl
local recActionStroke, repActionStroke, recKeyStroke, repKeyStroke

local function updateMovementUI()
    local count = #movementRecordData
    local dur = (count > 0 and movementRecordData[count].t) or movementDuration or 0

    if recActionBtn then
        if isMovementRecording then
            recActionBtn.Text = "ARRÊTER"
            recActionBtn.BackgroundColor3 = Color3.fromRGB(215, 45, 55)
            recActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            if recActionStroke then recActionStroke.Color = Color3.fromRGB(255, 80, 80) end
        else
            recActionBtn.Text = "Démarrer"
            recActionBtn.BackgroundColor3 = theme.cardHover
            recActionBtn.TextColor3 = theme.text
            if recActionStroke then recActionStroke.Color = theme.border end
        end
    end

    if repActionBtn then
        if isMovementReplaying then
            repActionBtn.Text = "ARRÊTER"
            repActionBtn.BackgroundColor3 = Color3.fromRGB(45, 175, 95)
            repActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            if repActionStroke then repActionStroke.Color = Color3.fromRGB(80, 220, 130) end
        else
            repActionBtn.Text = "Rejouer"
            repActionBtn.BackgroundColor3 = theme.cardHover
            repActionBtn.TextColor3 = theme.text
            if repActionStroke then repActionStroke.Color = theme.border end
        end
    end

    if statusLbl then
        if isMovementRecording then
            local liveElapsed = tick() - movementRecordStartTime
            statusLbl.Text = string.format("Points : %d  |  Enregistrement... (%.1fs)", count, liveElapsed)
            statusLbl.TextColor3 = Color3.fromRGB(255, 110, 110)
        elseif isMovementReplaying then
            statusLbl.Text = string.format("Points : %d  |  Rejeu en boucle (%.1fs)", count, dur)
            statusLbl.TextColor3 = Color3.fromRGB(110, 235, 150)
        else
            if count > 0 then
                statusLbl.Text = string.format("Points : %d  |  Durée : %.1fs  |  Prêt", count, dur)
                statusLbl.TextColor3 = theme.text
            else
                statusLbl.Text = "Points : 0  |  Durée : 0.0s  |  Statut : Inactif"
                statusLbl.TextColor3 = theme.sub
            end
        end
    end

    if recKeyBtn and not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "RecordMovement") then
        recKeyBtn.Text = (Keybinds and Keybinds.RecordMovement and Keybinds.RecordMovement.Name) or "Y"
    end
    if repKeyBtn and not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "ReplayMovement") then
        repKeyBtn.Text = (Keybinds and Keybinds.ReplayMovement and Keybinds.ReplayMovement.Name) or "O"
    end
end

function toggleMovementRecording()
    if isMovementRecording then
        isMovementRecording = false
        if movementRecordConn then
            pcall(function() movementRecordConn:Disconnect() end)
            movementRecordConn = nil
        end
        local count = #movementRecordData
        local dur = (count > 0 and movementRecordData[count].t) or 0
        movementDuration = dur
        notify("Me", "Enregistrement arrêté (" .. count .. " points, " .. string.format("%.1f", dur) .. "s)", Color3.fromRGB(255, 165, 0))
        updateMovementUI()
    else
        if isMovementReplaying then
            toggleMovementReplaying(false)
        end

        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
        if not char or not root then
            notify("Me", "Personnage introuvable pour enregistrer !", Color3.fromRGB(255, 90, 90))
            return
        end

        movementRecordData = {}
        movementRecordStartTime = tick()
        isMovementRecording = true

        local hum = char:FindFirstChildOfClass("Humanoid")
        table.insert(movementRecordData, {
            t = 0,
            cf = root.CFrame,
            vel = root.AssemblyLinearVelocity or root.Velocity or Vector3.zero,
            jumping = (hum and hum:GetState() == Enum.HumanoidStateType.Jumping)
        })

        if movementRecordConn then
            pcall(function() movementRecordConn:Disconnect() end)
            movementRecordConn = nil
        end

        local lastUiTick = tick()
        movementRecordConn = RunService.Heartbeat:Connect(function()
            if not isMovementRecording then return end
            local c = LocalPlayer.Character
            local r = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c.PrimaryPart)
            if not r then return end

            local curT = tick() - movementRecordStartTime
            local count = #movementRecordData
            if count == 0 or (curT - movementRecordData[count].t) >= 0.015 then
                local h = c:FindFirstChildOfClass("Humanoid")
                table.insert(movementRecordData, {
                    t = curT,
                    cf = r.CFrame,
                    vel = r.AssemblyLinearVelocity or r.Velocity or Vector3.zero,
                    jumping = (h and h:GetState() == Enum.HumanoidStateType.Jumping)
                })
            end

            if tick() - lastUiTick >= 0.25 then
                lastUiTick = tick()
                if statusLbl and isMovementRecording then
                    statusLbl.Text = string.format("Points : %d  |  Enregistrement... (%.1fs)", #movementRecordData, curT)
                end
            end
        end)
        addConnection(movementRecordConn)

        notify("Me", "Enregistrement du mouvement DÉMARRÉ", Color3.fromRGB(80, 200, 120))
        updateMovementUI()
    end
end

function toggleMovementReplaying(forceState)
    local targetState = forceState
    if targetState == nil then
        targetState = not isMovementReplaying
    end

    if not targetState then
        if isMovementReplaying then
            isMovementReplaying = false
            if movementReplayConn then
                pcall(function() movementReplayConn:Disconnect() end)
                movementReplayConn = nil
            end
            if movementNoclipConn then
                pcall(function() movementNoclipConn:Disconnect() end)
                movementNoclipConn = nil
            end
            local char = LocalPlayer.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
            if root then
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            notify("Me", "Rejeu en boucle ARRÊTÉ", Color3.fromRGB(255, 90, 90))
            updateMovementUI()
        end
    else
        if isMovementRecording then
            toggleMovementRecording()
        end

        local count = #movementRecordData
        if count < 2 then
            notify("Me", "Aucun mouvement enregistré ! Enregistrez d'abord un parcours.", Color3.fromRGB(255, 90, 90))
            return
        end

        local totalDuration = movementRecordData[count].t
        if totalDuration <= 0.05 then
            notify("Me", "Parcours enregistré trop court !", Color3.fromRGB(255, 90, 90))
            return
        end

        local char = LocalPlayer.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char.PrimaryPart)
        if not char or not root then
            notify("Me", "Personnage introuvable pour rejouer !", Color3.fromRGB(255, 90, 90))
            return
        end

        isMovementReplaying = true
        movementReplayLastIdx = 1
        local replayStartTime = tick()

        if movementReplayConn then
            pcall(function() movementReplayConn:Disconnect() end)
            movementReplayConn = nil
        end
        if movementNoclipConn then
            pcall(function() movementNoclipConn:Disconnect() end)
            movementNoclipConn = nil
        end

        movementNoclipConn = RunService.Stepped:Connect(function()
            if not isMovementReplaying then return end
            if V.MovementReplayNoclip ~= false then
                local c = LocalPlayer.Character
                if c then
                    for _, part in ipairs(c:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
        addConnection(movementNoclipConn)

        local lastUiTick = tick()
        movementReplayConn = RunService.Heartbeat:Connect(function()
            if not isMovementReplaying then return end
            local c = LocalPlayer.Character
            if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.Health <= 0 then return end
            local r = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c.PrimaryPart
            if not r then return end

            local ptsCount = #movementRecordData
            if ptsCount < 2 then return end
            local totTime = movementRecordData[ptsCount].t
            if totTime <= 0.01 then return end

            local rawSpeed = V.MovementReplaySpeed or 100
            local speed = (rawSpeed > 10) and (rawSpeed / 100) or rawSpeed
            if speed <= 0 then speed = 1 end

            local elapsed = ((tick() - replayStartTime) * speed) % totTime

            if movementReplayLastIdx > ptsCount or movementRecordData[movementReplayLastIdx].t > elapsed then
                movementReplayLastIdx = 1
            end

            while movementReplayLastIdx < ptsCount and movementRecordData[movementReplayLastIdx + 1].t <= elapsed do
                movementReplayLastIdx = movementReplayLastIdx + 1
            end

            local p1 = movementRecordData[movementReplayLastIdx]
            local p2 = movementRecordData[movementReplayLastIdx + 1]

            if p1 and p2 then
                local span = p2.t - p1.t
                local alpha = (span > 0.0001) and math.clamp((elapsed - p1.t) / span, 0, 1) or 0
                r.CFrame = p1.cf:Lerp(p2.cf, alpha)
                pcall(function()
                    r.AssemblyLinearVelocity = p1.vel or Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end)
            elseif p1 then
                r.CFrame = p1.cf
                pcall(function()
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end)
            end

            if tick() - lastUiTick >= 0.25 then
                lastUiTick = tick()
                if statusLbl and isMovementReplaying then
                    statusLbl.Text = string.format("Points : %d  |  Rejeu en boucle (%.1f / %.1fs)", ptsCount, elapsed, totTime)
                end
            end
        end)
        addConnection(movementReplayConn)

        notify("Me", "Rejeu en boucle DÉMARRÉ (" .. string.format("%.1f", totalDuration) .. "s)", Color3.fromRGB(80, 200, 120))
        updateMovementUI()
    end
end

KeybindCallbacks["RecordMovement"] = function() toggleMovementRecording() end
KeybindCallbacks["ReplayMovement"] = function() toggleMovementReplaying() end

createLabel("ENREGISTREUR DE MOUVEMENTS (MACRO)", MeContent)

do
    local recCard = createCard(MeContent, 0, 50)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -155, 0, 16)
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Enregistrer Mouvement"
    titleLbl.TextColor3 = theme.text
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 8
    titleLbl.Parent = recCard

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -155, 0, 14)
    subLbl.Position = UDim2.new(0, 12, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Enregistre tous tes déplacements (Toggle)"
    subLbl.TextColor3 = theme.sub
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 9
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 8
    subLbl.Parent = recCard

    recKeyBtn = Instance.new("TextButton")
    recKeyBtn.Size = UDim2.new(0, 56, 0, 26)
    recKeyBtn.Position = UDim2.new(1, -150, 0.5, -13)
    recKeyBtn.BackgroundColor3 = theme.cardHover
    recKeyBtn.BorderSizePixel = 0
    recKeyBtn.Text = (Keybinds and Keybinds.RecordMovement and Keybinds.RecordMovement.Name) or "Y"
    recKeyBtn.TextColor3 = theme.accent
    recKeyBtn.Font = Enum.Font.GothamBold
    recKeyBtn.TextSize = 10
    recKeyBtn.ZIndex = 9
    recKeyBtn.Parent = recCard
    makeCorner(recKeyBtn, 6)
    recKeyStroke = makeStroke(recKeyBtn, theme.border, 1)

    MeKeybindButtons["RecordMovement"] = recKeyBtn

    recKeyBtn.MouseEnter:Connect(function()
        if not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "RecordMovement") then
            recKeyStroke.Color = theme.accent
        end
    end)
    recKeyBtn.MouseLeave:Connect(function()
        if not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "RecordMovement") then
            recKeyStroke.Color = theme.border
        end
    end)
    recKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        playClick()
        KeybindSystem.Binding = true
        KeybindSystem.BindingName = "RecordMovement"
        KeybindSystem.BindingBtn = recKeyBtn
        recKeyBtn.Text = "Press..."
        recKeyBtn.BackgroundColor3 = theme.accent
        recKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        recKeyStroke.Color = theme.accent
    end)

    recActionBtn = Instance.new("TextButton")
    recActionBtn.Size = UDim2.new(0, 80, 0, 26)
    recActionBtn.Position = UDim2.new(1, -88, 0.5, -13)
    recActionBtn.BackgroundColor3 = theme.cardHover
    recActionBtn.BorderSizePixel = 0
    recActionBtn.Text = "Démarrer"
    recActionBtn.TextColor3 = theme.text
    recActionBtn.Font = Enum.Font.GothamBold
    recActionBtn.TextSize = 10
    recActionBtn.ZIndex = 9
    recActionBtn.Parent = recCard
    makeCorner(recActionBtn, 6)
    recActionStroke = makeStroke(recActionBtn, theme.border, 1)

    recActionBtn.MouseEnter:Connect(function()
        if not isMovementRecording then
            TweenService:Create(recActionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
    end)
    recActionBtn.MouseLeave:Connect(function()
        if not isMovementRecording then
            TweenService:Create(recActionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover, TextColor3 = theme.text}):Play()
        end
    end)
    recActionBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        playClick()
        toggleMovementRecording()
    end)

    registerSearchCard(recCard, "Enregistrer Mouvement Record Macro", MeContent)
end

do
    local repCard = createCard(MeContent, 0, 50)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -155, 0, 16)
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "Rejouer en Boucle"
    titleLbl.TextColor3 = theme.text
    titleLbl.Font = Enum.Font.GothamMedium
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 8
    titleLbl.Parent = repCard

    local subLbl = Instance.new("TextLabel")
    subLbl.Size = UDim2.new(1, -155, 0, 14)
    subLbl.Position = UDim2.new(0, 12, 0, 26)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "Répète le parcours enregistré en boucle"
    subLbl.TextColor3 = theme.sub
    subLbl.Font = Enum.Font.Gotham
    subLbl.TextSize = 9
    subLbl.TextXAlignment = Enum.TextXAlignment.Left
    subLbl.ZIndex = 8
    subLbl.Parent = repCard

    repKeyBtn = Instance.new("TextButton")
    repKeyBtn.Size = UDim2.new(0, 56, 0, 26)
    repKeyBtn.Position = UDim2.new(1, -150, 0.5, -13)
    repKeyBtn.BackgroundColor3 = theme.cardHover
    repKeyBtn.BorderSizePixel = 0
    repKeyBtn.Text = (Keybinds and Keybinds.ReplayMovement and Keybinds.ReplayMovement.Name) or "O"
    repKeyBtn.TextColor3 = theme.accent
    repKeyBtn.Font = Enum.Font.GothamBold
    repKeyBtn.TextSize = 10
    repKeyBtn.ZIndex = 9
    repKeyBtn.Parent = repCard
    makeCorner(repKeyBtn, 6)
    repKeyStroke = makeStroke(repKeyBtn, theme.border, 1)

    MeKeybindButtons["ReplayMovement"] = repKeyBtn

    repKeyBtn.MouseEnter:Connect(function()
        if not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "ReplayMovement") then
            repKeyStroke.Color = theme.accent
        end
    end)
    repKeyBtn.MouseLeave:Connect(function()
        if not (KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "ReplayMovement") then
            repKeyStroke.Color = theme.border
        end
    end)
    repKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        playClick()
        KeybindSystem.Binding = true
        KeybindSystem.BindingName = "ReplayMovement"
        KeybindSystem.BindingBtn = repKeyBtn
        repKeyBtn.Text = "Press..."
        repKeyBtn.BackgroundColor3 = theme.accent
        repKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        repKeyStroke.Color = theme.accent
    end)

    repActionBtn = Instance.new("TextButton")
    repActionBtn.Size = UDim2.new(0, 80, 0, 26)
    repActionBtn.Position = UDim2.new(1, -88, 0.5, -13)
    repActionBtn.BackgroundColor3 = theme.cardHover
    repActionBtn.BorderSizePixel = 0
    repActionBtn.Text = "Rejouer"
    repActionBtn.TextColor3 = theme.text
    repActionBtn.Font = Enum.Font.GothamBold
    repActionBtn.TextSize = 10
    repActionBtn.ZIndex = 9
    repActionBtn.Parent = repCard
    makeCorner(repActionBtn, 6)
    repActionStroke = makeStroke(repActionBtn, theme.border, 1)

    repActionBtn.MouseEnter:Connect(function()
        if not isMovementReplaying then
            TweenService:Create(repActionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end
    end)
    repActionBtn.MouseLeave:Connect(function()
        if not isMovementReplaying then
            TweenService:Create(repActionBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover, TextColor3 = theme.text}):Play()
        end
    end)
    repActionBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        playClick()
        toggleMovementReplaying()
    end)

    registerSearchCard(repCard, "Rejouer en Boucle Replay Macro", MeContent)
end

do
    local statusCard = createCard(MeContent, 0, 44)

    statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -95, 1, 0)
    statusLbl.Position = UDim2.new(0, 12, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "Points : 0  |  Durée : 0.0s  |  Statut : Inactif"
    statusLbl.TextColor3 = theme.sub
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextSize = 10
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.ZIndex = 8
    statusLbl.Parent = statusCard

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 75, 0, 26)
    clearBtn.Position = UDim2.new(1, -85, 0.5, -13)
    clearBtn.BackgroundColor3 = theme.cardHover
    clearBtn.BorderSizePixel = 0
    clearBtn.Text = "Effacer"
    clearBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 10
    clearBtn.ZIndex = 9
    clearBtn.Parent = statusCard
    makeCorner(clearBtn, 6)
    makeStroke(clearBtn, theme.border, 1)

    clearBtn.MouseEnter:Connect(function()
        TweenService:Create(clearBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(215, 45, 55), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    clearBtn.MouseLeave:Connect(function()
        TweenService:Create(clearBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover, TextColor3 = Color3.fromRGB(255, 90, 90)}):Play()
    end)
    clearBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        playClick()
        if isMovementRecording then toggleMovementRecording() end
        if isMovementReplaying then toggleMovementReplaying(false) end
        movementRecordData = {}
        movementDuration = 0
        updateMovementUI()
        notify("Me", "Enregistrement de mouvement effacé !", Color3.fromRGB(255, 165, 0))
    end)

    registerSearchCard(statusCard, "Statut Mouvement Macro", MeContent)
end

createToggle("Noclip pendant le Rejeu", true, function(enabled)
    V.MovementReplayNoclip = enabled
end, MeContent, "MovementReplayNoclip")

createSlider("Vitesse du Rejeu (%)", 25, 300, 100, function(val)
    V.MovementReplaySpeed = val
end, MeContent, "MovementReplaySpeed")

initStep = "cablage ESP"

origXRayTransparencies = origXRayTransparencies or {}
origMaterials = origMaterials or {}
origDecalTransparencies = origDecalTransparencies or {}
xrayConn = nil

local function isPlayerOrCharPart(part)
    if not part then return false end
    for _, p in ipairs(Players:GetPlayers()) do
        local c = p.Character
        if c and part:IsDescendantOf(c) then
            return true
        end
    end
    local m = part:FindFirstAncestorOfClass("Model")
    if m and m:FindFirstChildOfClass("Humanoid") then
        return true
    end
    return false
end

local function isFloorOrGround(part)
    if not part or not part:IsA("BasePart") then return false end
    if part:IsA("Terrain") then return true end
    local name = string.lower(part.Name)
    if string.find(name, "floor") or string.find(name, "ground") or string.find(name, "sol") or string.find(name, "baseplate")
        or string.find(name, "road") or string.find(name, "street") or string.find(name, "route") or string.find(name, "pavement")
        or string.find(name, "grass") or string.find(name, "terrain") or string.find(name, "stairs") or string.find(name, "escalier")
        or string.find(name, "sidewalk") or string.find(name, "path") or string.find(name, "trottoir") then
        return true
    end
    local sz = part.Size
    if sz.Y <= 4 and (sz.X >= 18 or sz.Z >= 18) then
        return true
    end
    return false
end

function restoreXRay()
    if xrayConn then
        xrayConn:Disconnect()
        xrayConn = nil
    end
    if origXRayTransparencies then
        for part, orig in pairs(origXRayTransparencies) do
            if part and part.Parent then
                pcall(function() part.Transparency = orig end)
            end
        end
        origXRayTransparencies = {}
    end
    if origMaterials then
        for part, mat in pairs(origMaterials) do
            if part and part.Parent then
                pcall(function() part.Material = mat end)
            end
        end
        origMaterials = {}
    end
    if origDecalTransparencies then
        for dec, orig in pairs(origDecalTransparencies) do
            if dec and dec.Parent then
                pcall(function() dec.Transparency = orig end)
            end
        end
        origDecalTransparencies = {}
    end
end

local function applyPartXRay(obj, targetTrans, style, effKeepFloor, hideDecals)
    if not obj or not obj.Parent then return end
    if obj:IsA("BasePart") then
        if isPlayerOrCharPart(obj) then return end
        if effKeepFloor and isFloorOrGround(obj) then return end

        if origXRayTransparencies[obj] == nil then
            origXRayTransparencies[obj] = obj.Transparency
        end
        if origMaterials[obj] == nil then
            origMaterials[obj] = obj.Material
        end

        pcall(function()
            if origXRayTransparencies[obj] < targetTrans then
                obj.Transparency = targetTrans
            end
            if style == "Verre Lisse" then
                obj.Material = Enum.Material.SmoothPlastic
            elseif style == "ForceField" then
                obj.Material = Enum.Material.ForceField
            end
        end)
    elseif hideDecals and (obj:IsA("Decal") or obj:IsA("Texture")) then
        local p = obj.Parent
        if p and p:IsA("BasePart") and not isPlayerOrCharPart(p) then
            if not effKeepFloor or not isFloorOrGround(p) then
                if origDecalTransparencies[obj] == nil then
                    origDecalTransparencies[obj] = obj.Transparency
                end
                pcall(function() obj.Transparency = 1 end)
            end
        end
    end
end

function updateXRay()
    if not V.XRay then return end
    local targetTrans = (V.XRayTransparency or 65) / 100
    local style = V.XRayStyle or "Murs Propres"
    local keepFloor = (V.XRayKeepFloor ~= false)
    local effKeepFloor = keepFloor and (style ~= "Total X-Ray")
    local hideDecals = (V.XRayHideDecals ~= false)

    for part, orig in pairs(origXRayTransparencies) do
        if part and part.Parent and not isPlayerOrCharPart(part) then
            if effKeepFloor and isFloorOrGround(part) then
                pcall(function()
                    part.Transparency = orig
                    if origMaterials[part] then part.Material = origMaterials[part] end
                end)
            else
                pcall(function()
                    if orig < targetTrans then
                        part.Transparency = targetTrans
                    else
                        part.Transparency = orig
                    end
                    if style == "Verre Lisse" then
                        part.Material = Enum.Material.SmoothPlastic
                    elseif style == "ForceField" then
                        part.Material = Enum.Material.ForceField
                    elseif origMaterials[part] then
                        part.Material = origMaterials[part]
                    end
                end)
            end
        end
    end

    if hideDecals then
        for dec, orig in pairs(origDecalTransparencies) do
            if dec and dec.Parent then
                local p = dec.Parent
                if p and p:IsA("BasePart") and effKeepFloor and isFloorOrGround(p) then
                    pcall(function() dec.Transparency = orig end)
                else
                    pcall(function() dec.Transparency = 1 end)
                end
            end
        end
    else
        for dec, orig in pairs(origDecalTransparencies) do
            if dec and dec.Parent then
                pcall(function() dec.Transparency = orig end)
            end
        end
    end
end

function toggleXRay(enabled)
    V.XRay = enabled
    local targetTrans = (V.XRayTransparency or 65) / 100
    local style = V.XRayStyle or "Murs Propres"
    local keepFloor = (V.XRayKeepFloor ~= false)
    local effKeepFloor = keepFloor and (style ~= "Total X-Ray")
    local hideDecals = (V.XRayHideDecals ~= false)

    if enabled then
        task.spawn(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not V.XRay then break end
                applyPartXRay(obj, targetTrans, style, effKeepFloor, hideDecals)
            end
        end)

        if xrayConn then xrayConn:Disconnect() end
        xrayConn = workspace.DescendantAdded:Connect(function(obj)
            if not V.XRay then return end
            task.wait()
            if not V.XRay then return end
            local curStyle = V.XRayStyle or "Murs Propres"
            local curKeep = (V.XRayKeepFloor ~= false)
            local curEff = curKeep and (curStyle ~= "Total X-Ray")
            applyPartXRay(obj, (V.XRayTransparency or 65) / 100, curStyle, curEff, V.XRayHideDecals ~= false)
        end)
        notify("ESP", "X-Ray PRO ACTIVÉ (" .. tostring(V.XRayTransparency or 65) .. "% - " .. tostring(style) .. ")", Color3.fromRGB(80, 200, 120))
    else
        restoreXRay()
        notify("ESP", "X-Ray DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end

createLabel("ESP OPTIONS", ESPContent)
_, SetESPToggle, ToggleESP = createToggle("Enable ESP", false, function(enabled)
    V.ESP = enabled
    if ESPGui then ESPGui.Enabled = enabled end
    refreshESP()
end, ESPContent,"ESP")
createToggle("Team Check (Masquer Alliés)", false, function(enabled)
    V.ESPTeamCheck = enabled
    refreshESP()
end, ESPContent, "ESPTeamCheck")
createToggle("Box", false, function(enabled) V.ESPBox = enabled end, ESPContent,"ESPBox")
createToggle("Corner Box", false, function(enabled) V.ESPCornerBox = enabled end, ESPContent, "ESPCornerBox")
createToggle("Glow ESP", false, function(enabled) V.ESPGlow = enabled end, ESPContent,"ESPGlow")
createToggle("Filled Box", false, function(enabled) V.ESPFilled = enabled end, ESPContent,"ESPFilled")
createToggle("Name", false, function(enabled) V.ESPName = enabled end, ESPContent,"ESPName")
-- [SPECTATOR LIST : MINI-FENETRE FLOTTANTE QUI AFFICHE QUI ME SPECTATE]
do
    local specGui = nil
    local specListFrame = nil
    local specContainer = nil
    local specCountLbl = nil
    local specItems = {}
    local specConn = nil

    local function createSpectatorWindow()
        if specGui and specGui.Parent then return end
        specGui = Instance.new("ScreenGui")
        specGui.Name = "PearlSpectatorListGui"
        specGui.ResetOnSpawn = false
        specGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(specGui) end
        end)
        specGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")

        local win = Instance.new("Frame")
        win.Name = "SpecWindow"
        win.Size = UDim2.new(0, 210, 0, 140)
        win.Position = UDim2.new(0.02, 0, 0.42, 0)
        win.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
        win.BorderSizePixel = 0
        win.Active = true
        win.Draggable = true
        win.Parent = specGui
        makeCorner(win, 8)
        makeStroke(win, Color3.fromRGB(48, 42, 70), 1.2)

        local header = Instance.new("Frame")
        header.Name = "Header"
        header.Size = UDim2.new(1, 0, 0, 28)
        header.BackgroundColor3 = Color3.fromRGB(22, 20, 32)
        header.BorderSizePixel = 0
        header.Parent = win
        makeCorner(header, 8)

        local hTitle = Instance.new("TextLabel")
        hTitle.Size = UDim2.new(0.65, 0, 1, 0)
        hTitle.Position = UDim2.new(0, 10, 0, 0)
        hTitle.BackgroundTransparency = 1
        hTitle.Text = "SPECTATEURS"
        hTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        hTitle.Font = Enum.Font.GothamBold
        hTitle.TextSize = 11
        hTitle.TextXAlignment = Enum.TextXAlignment.Left
        hTitle.Parent = header

        specCountLbl = Instance.new("TextLabel")
        specCountLbl.Size = UDim2.new(0, 32, 0, 18)
        specCountLbl.Position = UDim2.new(1, -40, 0.5, -9)
        specCountLbl.BackgroundColor3 = Color3.fromRGB(34, 26, 52)
        specCountLbl.Text = "0"
        specCountLbl.TextColor3 = Color3.fromRGB(180, 145, 255)
        specCountLbl.Font = Enum.Font.GothamBold
        specCountLbl.TextSize = 10
        specCountLbl.Parent = header
        makeCorner(specCountLbl, 9)
        makeStroke(specCountLbl, Color3.fromRGB(80, 60, 130), 1)

        specContainer = Instance.new("ScrollingFrame")
        specContainer.Name = "Container"
        specContainer.Size = UDim2.new(1, -12, 1, -36)
        specContainer.Position = UDim2.new(0, 6, 0, 32)
        specContainer.BackgroundTransparency = 1
        specContainer.BorderSizePixel = 0
        specContainer.ScrollBarThickness = 2
        specContainer.ScrollBarImageColor3 = Color3.fromRGB(140, 75, 255)
        specContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        specContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
        specContainer.Parent = win

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 2)
        pad.PaddingRight = UDim.new(0, 4)
        pad.PaddingTop = UDim.new(0, 2)
        pad.PaddingBottom = UDim.new(0, 4)
        pad.Parent = specContainer

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = specContainer

        specListFrame = win
    end

    local function destroySpectatorWindow()
        if specConn then specConn:Disconnect(); specConn = nil end
        if specGui then specGui:Destroy(); specGui = nil end
        specListFrame = nil
        specContainer = nil
        specCountLbl = nil
        specItems = {}
    end
    _G.destroySpectatorWindow = destroySpectatorWindow

    local lastSpecCheck = 0
    local function updateSpectators()
        if not V.SpectatorList or not specContainer then return end
        local now = tick()
        if now - lastSpecCheck < 0.25 then return end
        lastSpecCheck = now

        local myChar = LocalPlayer.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end

        local currentSpectators = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local isSpectatingMe = false

                -- 1. Attributs specifiques Roblox ou jeux (MM2, Arsenal, Axion, Da Hood, etc.)
                pcall(function()
                    local spectatingAttr = p:GetAttribute("Spectating") or p:GetAttribute("SpectateTarget") or p:GetAttribute("Target") or p:GetAttribute("Watching")
                    if spectatingAttr and (tostring(spectatingAttr) == LocalPlayer.Name or tostring(spectatingAttr) == tostring(LocalPlayer.UserId)) then
                        isSpectatingMe = true
                    end
                end)

                -- 2. ValueObjects (ObjectValue, StringValue) dans le Player ou PlayerGui
                if not isSpectatingMe then
                    pcall(function()
                        local specVal = p:FindFirstChild("Spectating") or p:FindFirstChild("Spectate") or p:FindFirstChild("SpectateTarget") or p:FindFirstChild("CameraSubject")
                        if specVal then
                            if specVal:IsA("ObjectValue") and (specVal.Value == LocalPlayer or specVal.Value == myChar) then
                                isSpectatingMe = true
                            elseif specVal:IsA("StringValue") and (specVal.Value == LocalPlayer.Name) then
                                isSpectatingMe = true
                            end
                        end
                    end)
                end

                -- 3. Joueur mort ou sans corps dont la camera cible le joueur local
                if not isSpectatingMe then
                    pcall(function()
                        local tChar = p.Character
                        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                        local isDead = (not tChar) or (not tHum) or (tHum.Health <= 0)
                        if isDead then
                            local cam = workspace.CurrentCamera
                            if cam and cam.CameraSubject and (cam.CameraSubject == myChar or cam.CameraSubject == myHrp) then
                                isSpectatingMe = true
                            end
                        end
                    end)
                end

                -- 4. Spectate mutuel enregistre dans V.Spectators
                if not isSpectatingMe and V._ActiveSpectators and V._ActiveSpectators[p] then
                    isSpectatingMe = true
                end

                if isSpectatingMe then
                    table.insert(currentSpectators, p)
                end
            end
        end

        specCountLbl.Text = tostring(#currentSpectators)

        -- Nettoyage des anciennes lignes
        for _, item in pairs(specContainer:GetChildren()) do
            if item:IsA("Frame") or item:IsA("TextLabel") then
                item:Destroy()
            end
        end

        if #currentSpectators == 0 then
            local noneLbl = Instance.new("TextLabel")
            noneLbl.Size = UDim2.new(1, 0, 0, 30)
            noneLbl.BackgroundTransparency = 1
            noneLbl.Text = "Aucun spectateur"
            noneLbl.TextColor3 = Color3.fromRGB(130, 130, 150)
            noneLbl.Font = Enum.Font.GothamMedium
            noneLbl.TextSize = 10
            noneLbl.Parent = specContainer
        else
            for _, p in ipairs(currentSpectators) do
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 30)
                row.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
                row.BorderSizePixel = 0
                row.Parent = specContainer
                makeCorner(row, 6)
                makeStroke(row, Color3.fromRGB(44, 44, 60), 1)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0, 22, 0, 22)
                av.Position = UDim2.new(0, 4, 0.5, -11)
                av.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p.UserId) .. "&w=100&h=100"
                av.BorderSizePixel = 0
                av.Parent = row
                makeCorner(av, 11)

                local nLbl = Instance.new("TextLabel")
                nLbl.Size = UDim2.new(1, -34, 1, 0)
                nLbl.Position = UDim2.new(0, 30, 0, 0)
                nLbl.BackgroundTransparency = 1
                nLbl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                nLbl.TextColor3 = Color3.fromRGB(240, 240, 250)
                nLbl.Font = Enum.Font.GothamBold
                nLbl.TextSize = 10
                nLbl.TextXAlignment = Enum.TextXAlignment.Left
                nLbl.TextTruncate = Enum.TextTruncate.AtEnd
                nLbl.Parent = row
            end
        end
    end

    createToggle("Spectator List (Qui me regarde)", false, function(enabled)
        V.SpectatorList = enabled
        if enabled then
            createSpectatorWindow()
            if not specConn then
                specConn = RunService.RenderStepped:Connect(updateSpectators)
            end
            notify("ESP", "Spectator List AFFICHÉE", Color3.fromRGB(80, 200, 120))
        else
            destroySpectatorWindow()
            notify("ESP", "Spectator List MASQUÉE", Color3.fromRGB(255, 90, 90))
        end
    end, ESPContent, "SpectatorList")
end

createToggle("Distance", false, function(enabled) V.ESPDist = enabled end, ESPContent,"ESPDist")
createToggle("Tracers ESP", false, function(enabled) V.ESPTracer = enabled end, ESPContent,"ESPTracer")
createToggle("Skeleton ESP", false, function(enabled) V.ESPSkeleton = enabled end, ESPContent,"ESPSkeleton")
createSlider("Épaisseur Skeleton (Thickness)", 1, 10, 2, function(val)
    V.ESPSkeletonThickness = val
    if VP and VP.HeadDotStroke then
        VP.HeadDotStroke.Thickness = val
    end
end, ESPContent, "ESPSkeletonThickness")
createToggle("Health Bar ESP", false, function(enabled) V.ESPHealth = enabled end, ESPContent,"ESPHealth")
createToggle("Afficher PV", false, function(enabled)
    V.ESPPV = enabled
    HealthPV_Enabled = enabled
    if HealthPVTrack and HealthPVThumb then
        AnimateToggle(HealthPVTrack, HealthPVThumb, enabled)
    end
end, ESPContent, "ESPPV")
createToggle("Weapon / Held Item ESP", false, function(enabled) V.ESPWeapon = enabled end, ESPContent,"ESPWeapon")
createToggle("NPCs ESP (Entités / PNJ)", false, function(enabled)
    V.ESPNPC = enabled
    refreshESP()
end, ESPContent, "ESPNPC")

createToggle("X-Ray (Vision murs optimisée)", false, function(enabled)
    toggleXRay(enabled)
end, ESPContent, "XRay")
createToggle("Garder le Sol Solide (Anti-Vertige)", true, function(enabled)
    V.XRayKeepFloor = enabled
    if V.XRay and updateXRay then updateXRay() end
end, ESPContent, "XRayKeepFloor")
createToggle("Masquer Textures Flottantes (Clean)", true, function(enabled)
    V.XRayHideDecals = enabled
    if V.XRay and updateXRay then updateXRay() end
end, ESPContent, "XRayHideDecals")

local xrayStyles = {"Murs Propres", "Verre Lisse", "ForceField", "Total X-Ray"}
local styleCard, styleBtn
styleCard, styleBtn = createButton("Style Visuel X-Ray", function()
    local cur = V.XRayStyle or "Murs Propres"
    local idx = 1
    for i, s in ipairs(xrayStyles) do
        if s == cur then idx = i break end
    end
    idx = (idx % #xrayStyles) + 1
    local nextStyle = xrayStyles[idx]
    V.XRayStyle = nextStyle
    if styleBtn then styleBtn.Text = nextStyle end
    if V.XRay and updateXRay then updateXRay() end
    notify("X-Ray", "Style : " .. nextStyle, Color3.fromRGB(130, 100, 255))
end, ESPContent, V.XRayStyle or "Murs Propres")
if styleBtn then
    styleBtn.Size = UDim2.new(0, 95, 0, 24)
    styleBtn.Position = UDim2.new(1, -105, 0.5, -12)
end

ConfigRegistry["XRayStyle"] = function(val)
    if val and table.find(xrayStyles, val) then
        V.XRayStyle = val
        if styleBtn then styleBtn.Text = val end
        if V.XRay and updateXRay then updateXRay() end
    end
end

createSlider("X-Ray Transparence", 10, 95, 65, function(val)
    V.XRayTransparency = val
    if V.XRay and updateXRay then updateXRay() end
end, ESPContent, "XRayTransparency")

droppedItemsFolder = nil
function toggleDroppedItemsESP(enabled)
    V.ESPDropped = enabled
    if droppedItemsFolder then
        droppedItemsFolder:Destroy()
        droppedItemsFolder = nil
    end
    if enabled then
        droppedItemsFolder = Instance.new("Folder")
        droppedItemsFolder.Name ="PearlDroppedItemsESP"
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

do
    local RadarGui = nil
    local RadarFrame = nil
    local radarBlipPool = {}
    local radarConn = nil
    local radarEnemyBadge = nil
    local radarRangeLbl = nil
    local radarCompassLabels = {}

    local function getOrCreateBlip(idx)
        if radarBlipPool[idx] then return radarBlipPool[idx] end

        local blipContainer = Instance.new("Frame")
        blipContainer.Name = "Blip_" .. idx
        blipContainer.Size = UDim2.new(0, 16, 0, 16)
        blipContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        blipContainer.BackgroundTransparency = 1
        blipContainer.BorderSizePixel = 0
        blipContainer.ZIndex = 15
        blipContainer.Visible = false
        blipContainer.Parent = RadarFrame

        -- Halo externe doux
        local glow = Instance.new("Frame")
        glow.Name = "Glow"
        glow.Size = UDim2.new(0, 12, 0, 12)
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Position = UDim2.new(0.5, 0, 0.5, 0)
        glow.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
        glow.BackgroundTransparency = 0.72
        glow.BorderSizePixel = 0
        glow.ZIndex = 15
        glow.Parent = blipContainer
        makeCorner(glow, 6)

        -- Point central (Core)
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.BorderSizePixel = 0
        dot.BackgroundColor3 = Color3.fromRGB(255, 55, 75)
        dot.ZIndex = 17
        dot.Parent = blipContainer
        makeCorner(dot, 3)
        local dotStroke = makeStroke(dot, Color3.fromRGB(255, 255, 255), 1)

        -- Aiguille de direction (orbitant autour du point par trigonométrie)
        local dirLine = Instance.new("Frame")
        dirLine.Name = "DirLine"
        dirLine.Size = UDim2.new(0, 2, 0, 5)
        dirLine.AnchorPoint = Vector2.new(0.5, 0.5)
        dirLine.Position = UDim2.new(0.5, 0, 0.5, -5)
        dirLine.BorderSizePixel = 0
        dirLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dirLine.ZIndex = 16
        dirLine.Parent = blipContainer
        makeCorner(dirLine, 1)

        -- Indicateur d'élévation (▲ = Haut, ▼ = Bas)
        local elevLbl = Instance.new("TextLabel")
        elevLbl.Name = "ElevLbl"
        elevLbl.Size = UDim2.new(0, 12, 0, 8)
        elevLbl.AnchorPoint = Vector2.new(0.5, 0.5)
        elevLbl.Position = UDim2.new(0.5, 0, 0.5, -10)
        elevLbl.BackgroundTransparency = 1
        elevLbl.Font = Enum.Font.GothamBold
        elevLbl.TextSize = 7
        elevLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        elevLbl.Text = ""
        elevLbl.ZIndex = 18
        elevLbl.Parent = blipContainer

        radarBlipPool[idx] = {
            container = blipContainer,
            glow = glow,
            dot = dot,
            dotStroke = dotStroke,
            dirLine = dirLine,
            elevLbl = elevLbl
        }
        return radarBlipPool[idx]
    end

    local function createRadar2D()
        if RadarGui then RadarGui:Destroy() end
        RadarGui = Instance.new("ScreenGui")
        RadarGui.Name = "PearlTacticalRadar"
        RadarGui.ResetOnSpawn = false
        RadarGui.DisplayOrder = 998
        RadarGui.Parent = getSafeGuiParent()

        local radarDiameter = V.RadarSize or 180
        local radius = radarDiameter / 2

        -- Header Pill Tactique (Compteur ennemis & Portée)
        local HeaderPill = Instance.new("Frame")
        HeaderPill.Name = "RadarHeader"
        HeaderPill.Size = UDim2.new(0, radarDiameter, 0, 24)
        HeaderPill.Position = UDim2.new(1, -(radarDiameter + 25), 0, 46)
        HeaderPill.BackgroundColor3 = Color3.fromRGB(13, 12, 20)
        HeaderPill.BackgroundTransparency = 0.12
        HeaderPill.BorderSizePixel = 0
        HeaderPill.Parent = RadarGui
        makeCorner(HeaderPill, 7)
        makeStroke(HeaderPill, Color3.fromRGB(58, 48, 88), 1)

        local pulseDot = Instance.new("Frame")
        pulseDot.Size = UDim2.new(0, 6, 0, 6)
        pulseDot.AnchorPoint = Vector2.new(0, 0.5)
        pulseDot.Position = UDim2.new(0, 8, 0.5, 0)
        pulseDot.BackgroundColor3 = Color3.fromRGB(155, 90, 255)
        pulseDot.BorderSizePixel = 0
        pulseDot.Parent = HeaderPill
        makeCorner(pulseDot, 3)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0, 58, 1, 0)
        titleLbl.Position = UDim2.new(0, 18, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "RADAR 2D"
        titleLbl.TextColor3 = Color3.fromRGB(245, 245, 255)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 9
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = HeaderPill

        radarRangeLbl = Instance.new("TextLabel")
        radarRangeLbl.Size = UDim2.new(0, 34, 1, 0)
        radarRangeLbl.AnchorPoint = Vector2.new(0.5, 0)
        radarRangeLbl.Position = UDim2.new(0.46, 0, 0, 0)
        radarRangeLbl.BackgroundTransparency = 1
        radarRangeLbl.Text = tostring(V.RadarRange or 200) .. "m"
        radarRangeLbl.TextColor3 = Color3.fromRGB(165, 155, 195)
        radarRangeLbl.Font = Enum.Font.GothamMedium
        radarRangeLbl.TextSize = 9
        radarRangeLbl.Parent = HeaderPill

        radarEnemyBadge = Instance.new("TextLabel")
        radarEnemyBadge.Size = UDim2.new(0, 68, 0, 16)
        radarEnemyBadge.AnchorPoint = Vector2.new(1, 0.5)
        radarEnemyBadge.Position = UDim2.new(1, -5, 0.5, 0)
        radarEnemyBadge.BackgroundColor3 = Color3.fromRGB(22, 28, 24)
        radarEnemyBadge.Text = "0 ENNEMI"
        radarEnemyBadge.TextColor3 = Color3.fromRGB(80, 225, 125)
        radarEnemyBadge.Font = Enum.Font.GothamBold
        radarEnemyBadge.TextSize = 8
        radarEnemyBadge.Parent = HeaderPill
        makeCorner(radarEnemyBadge, 4)
        makeStroke(radarEnemyBadge, Color3.fromRGB(52, 44, 76), 1)

        -- Radar Circle Frame (Draggable & Super Clean)
        local Container = Instance.new("Frame")
        Container.Name = "RadarContainer"
        Container.Size = UDim2.new(0, radarDiameter, 0, radarDiameter)
        Container.Position = UDim2.new(1, -(radarDiameter + 25), 0, 75)
        Container.BackgroundColor3 = Color3.fromRGB(11, 10, 18)
        Container.BackgroundTransparency = 0.14
        Container.BorderSizePixel = 0
        Container.Active = true
        Container.Draggable = true
        Container.ClipsDescendants = true
        Container.Parent = RadarGui
        makeCorner(Container, radius)
        makeStroke(Container, Color3.fromRGB(140, 82, 255), 1.6)

        -- Anneau de bordure interne subtil
        local innerRim = Instance.new("Frame")
        innerRim.Size = UDim2.new(1, -6, 1, -6)
        innerRim.AnchorPoint = Vector2.new(0.5, 0.5)
        innerRim.Position = UDim2.new(0.5, 0, 0.5, 0)
        innerRim.BackgroundTransparency = 1
        innerRim.Parent = Container
        makeCorner(innerRim, radius - 3)
        makeStroke(innerRim, Color3.fromRGB(36, 32, 54), 1)

        -- Synchronisation du déplacement du header avec le radar
        Container:GetPropertyChangedSignal("Position"):Connect(function()
            HeaderPill.Position = UDim2.new(Container.Position.X.Scale, Container.Position.X.Offset, Container.Position.Y.Scale, Container.Position.Y.Offset - 29)
        end)

        -- Cercles concentriques de distance (33% et 66%)
        local ring1 = Instance.new("Frame")
        ring1.Size = UDim2.new(0.33, 0, 0.33, 0)
        ring1.AnchorPoint = Vector2.new(0.5, 0.5)
        ring1.Position = UDim2.new(0.5, 0, 0.5, 0)
        ring1.BackgroundTransparency = 1
        ring1.Parent = Container
        makeCorner(ring1, math.floor(radius * 0.33))
        makeStroke(ring1, Color3.fromRGB(44, 38, 64), 1)

        local ring2 = Instance.new("Frame")
        ring2.Size = UDim2.new(0.66, 0, 0.66, 0)
        ring2.AnchorPoint = Vector2.new(0.5, 0.5)
        ring2.Position = UDim2.new(0.5, 0, 0.5, 0)
        ring2.BackgroundTransparency = 1
        ring2.Parent = Container
        makeCorner(ring2, math.floor(radius * 0.66))
        makeStroke(ring2, Color3.fromRGB(44, 38, 64), 1)

        -- Lignes de réticule ultra-fines
        local hLine = Instance.new("Frame")
        hLine.Size = UDim2.new(1, -12, 0, 1)
        hLine.AnchorPoint = Vector2.new(0.5, 0.5)
        hLine.Position = UDim2.new(0.5, 0, 0.5, 0)
        hLine.BackgroundColor3 = Color3.fromRGB(38, 34, 56)
        hLine.BorderSizePixel = 0
        hLine.Parent = Container

        local vLine = Instance.new("Frame")
        vLine.Size = UDim2.new(0, 1, 1, -12)
        vLine.AnchorPoint = Vector2.new(0.5, 0.5)
        vLine.Position = UDim2.new(0.5, 0, 0.5, 0)
        vLine.BackgroundColor3 = Color3.fromRGB(38, 34, 56)
        vLine.BorderSizePixel = 0
        vLine.Parent = Container


        -- Points cardinaux rotatifs (N, E, S, W) sur le pourtour
        radarCompassLabels = {}
        local cardinals = {
            { txt = "N", dir = Vector3.new(0, 0, -1), col = Color3.fromRGB(255, 80, 95) },
            { txt = "E", dir = Vector3.new(1, 0, 0),  col = Color3.fromRGB(150, 145, 180) },
            { txt = "S", dir = Vector3.new(0, 0, 1),  col = Color3.fromRGB(150, 145, 180) },
            { txt = "W", dir = Vector3.new(-1, 0, 0), col = Color3.fromRGB(150, 145, 180) }
        }
        for _, cInfo in ipairs(cardinals) do
            local cLbl = Instance.new("TextLabel")
            cLbl.Size = UDim2.new(0, 14, 0, 14)
            cLbl.AnchorPoint = Vector2.new(0.5, 0.5)
            cLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
            cLbl.BackgroundTransparency = 1
            cLbl.Text = cInfo.txt
            cLbl.TextColor3 = cInfo.col
            cLbl.Font = Enum.Font.GothamBold
            cLbl.TextSize = 8
            cLbl.ZIndex = 12
            cLbl.Parent = Container
            table.insert(radarCompassLabels, { lbl = cLbl, dir = cInfo.dir })
        end

        -- Icône centrale (Position joueur local)
        local centerHalo = Instance.new("Frame")
        centerHalo.Size = UDim2.new(0, 14, 0, 14)
        centerHalo.AnchorPoint = Vector2.new(0.5, 0.5)
        centerHalo.Position = UDim2.new(0.5, 0, 0.5, 0)
        centerHalo.BackgroundColor3 = Color3.fromRGB(0, 225, 255)
        centerHalo.BackgroundTransparency = 0.78
        centerHalo.BorderSizePixel = 0
        centerHalo.ZIndex = 19
        centerHalo.Parent = Container
        makeCorner(centerHalo, 7)

        local centerOuter = Instance.new("Frame")
        centerOuter.Size = UDim2.new(0, 7, 0, 7)
        centerOuter.AnchorPoint = Vector2.new(0.5, 0.5)
        centerOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
        centerOuter.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
        centerOuter.BorderSizePixel = 0
        centerOuter.Rotation = 45
        centerOuter.ZIndex = 20
        centerOuter.Parent = Container
        makeCorner(centerOuter, 2)
        makeStroke(centerOuter, Color3.fromRGB(255, 255, 255), 1)

        RadarFrame = Container
    end

    local function cleanupRadar2D()
        if radarConn then pcall(function() radarConn:Disconnect() end) radarConn = nil end
        if RadarGui and RadarGui.Parent then pcall(function() RadarGui:Destroy() end) end
        RadarGui = nil
        RadarFrame = nil
        radarEnemyBadge = nil
        radarRangeLbl = nil
        radarCompassLabels = {}
        table.clear(radarBlipPool)
    end
    _G.cleanupRadar2D = cleanupRadar2D
    _G.toggleRadar2D = toggleRadar2D

    function toggleRadar2D(enabled)
        V.Radar2D = enabled
        cleanupRadar2D()
        if enabled then
            createRadar2D()
            radarConn = RunService.RenderStepped:Connect(function()
                if not V.Radar2D or not RadarFrame or not RadarFrame.Parent then return end
                local char = LocalPlayer.Character
                local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                local cam = workspace.CurrentCamera or Camera
                if not myRoot or not cam then
                    for _, b in pairs(radarBlipPool) do b.container.Visible = false end
                    return
                end

                local maxRange = V.RadarRange or 200
                if radarRangeLbl then
                    radarRangeLbl.Text = tostring(maxRange) .. "m"
                end

                local radarDiameter = V.RadarSize or 180
                local halfRadius = (radarDiameter * 0.5) - 12
                local compassRadius = (radarDiameter * 0.5) - 10
                local blipIndex = 0
                local enemyCount = 0
                local camCFrame = cam.CFrame

                -- Rotation des 4 points cardinaux (N, E, S, W) sur le bord du cercle
                for _, cItem in ipairs(radarCompassLabels) do
                    local relDir = camCFrame:VectorToObjectSpace(cItem.dir)
                    local cAngle = math.atan2(relDir.X, -relDir.Z)
                    local cX = math.sin(cAngle) * compassRadius
                    local cY = -math.cos(cAngle) * compassRadius
                    cItem.lbl.Position = UDim2.new(0.5, cX, 0.5, cY)
                end

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local eChar = p.Character
                        local eRoot = eChar:FindFirstChild("HumanoidRootPart")
                        local eHum = eChar:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            -- Position relative centrée sur le joueur local, orientée selon l'angle caméra
                            local worldDiff = eRoot.Position - myRoot.Position
                            local camRel = camCFrame:VectorToObjectSpace(worldDiff)
                            local hDist = math.sqrt(camRel.X * camRel.X + camRel.Z * camRel.Z)
                            local relY = worldDiff.Y

                            local isTeam = isPlayerTeamMate and isPlayerTeamMate(p)
                            if not isTeam then
                                enemyCount = enemyCount + 1
                            end

                            if hDist <= maxRange * 1.4 then
                                blipIndex = blipIndex + 1
                                local item = getOrCreateBlip(blipIndex)

                                -- Coordonnées polaires centrées exactement sur (0.5, 0.5)
                                local angle = math.atan2(camRel.X, -camRel.Z)
                                local clampedDist = math.clamp(hDist / maxRange, 0, 1)
                                local rDist = clampedDist * halfRadius
                                local dx = math.sin(angle) * rDist
                                local dy = -math.cos(angle) * rDist

                                item.container.Position = UDim2.new(0.5, dx, 0.5, dy)

                                -- Aiguille de direction orbitant parfaitement autour du point (trigonométrie pure)
                                local eLookRel = camCFrame:VectorToObjectSpace(eRoot.CFrame.LookVector)
                                local lookRad = math.atan2(eLookRel.X, -eLookRel.Z)
                                local tipX = math.sin(lookRad) * 5
                                local tipY = -math.cos(lookRad) * 5
                                item.dirLine.Position = UDim2.new(0.5, tipX, 0.5, tipY)
                                item.dirLine.Rotation = math.deg(lookRad)

                                -- Indicateur d'élévation relative (▲ Plus haut / ▼ Plus bas)
                                if relY > 7 then
                                    item.elevLbl.Text = "▲"
                                    item.elevLbl.Position = UDim2.new(0.5, 0, 0.5, -10)
                                    item.elevLbl.TextColor3 = Color3.fromRGB(120, 210, 255)
                                    item.elevLbl.Visible = true
                                elseif relY < -7 then
                                    item.elevLbl.Text = "▼"
                                    item.elevLbl.Position = UDim2.new(0.5, 0, 0.5, 10)
                                    item.elevLbl.TextColor3 = Color3.fromRGB(255, 130, 130)
                                    item.elevLbl.Visible = true
                                else
                                    item.elevLbl.Visible = false
                                end

                                -- Couleurs tactiques
                                local isSel = (V.SelectedJoueurPlayer and V.SelectedJoueurPlayer == p)
                                local isVis = isPlayerVisible and isPlayerVisible(p)
                                local mainCol, strokeCol

                                if isSel then
                                    mainCol = Color3.fromRGB(255, 215, 0)
                                    strokeCol = Color3.fromRGB(255, 255, 255)
                                elseif isTeam then
                                    mainCol = Color3.fromRGB(50, 230, 120)
                                    strokeCol = Color3.fromRGB(165, 255, 195)
                                elseif isVis then
                                    mainCol = Color3.fromRGB(255, 45, 65)
                                    strokeCol = Color3.fromRGB(255, 175, 180)
                                else
                                    mainCol = Color3.fromRGB(175, 95, 255)
                                    strokeCol = Color3.fromRGB(225, 190, 255)
                                end

                                item.dot.BackgroundColor3 = mainCol
                                item.glow.BackgroundColor3 = mainCol
                                item.dotStroke.Color = strokeCol
                                item.dirLine.BackgroundColor3 = strokeCol

                                if hDist > maxRange then
                                    item.dot.BackgroundTransparency = 0.35
                                    item.glow.BackgroundTransparency = 0.88
                                    item.dirLine.BackgroundTransparency = 0.45
                                else
                                    item.dot.BackgroundTransparency = 0
                                    item.glow.BackgroundTransparency = 0.72
                                    item.dirLine.BackgroundTransparency = 0
                                end

                                item.container.Visible = true
                            end
                        end
                    end
                end

                for idx = blipIndex + 1, #radarBlipPool do
                    radarBlipPool[idx].container.Visible = false
                end

                if radarEnemyBadge then
                    if enemyCount > 0 then
                        radarEnemyBadge.Text = tostring(enemyCount) .. " ENNEMI" .. (enemyCount > 1 and "S" or "")
                        radarEnemyBadge.TextColor3 = Color3.fromRGB(255, 80, 95)
                        radarEnemyBadge.BackgroundColor3 = Color3.fromRGB(40, 16, 24)
                    else
                        radarEnemyBadge.Text = "0 ENNEMI"
                        radarEnemyBadge.TextColor3 = Color3.fromRGB(80, 225, 125)
                        radarEnemyBadge.BackgroundColor3 = Color3.fromRGB(18, 30, 24)
                    end
                end
            end)
            addConnection(radarConn)
            notify("ESP", "Radar 2D Tactique ACTIF", Color3.fromRGB(80, 200, 120))
        else
            cleanupRadar2D()
            notify("ESP", "Radar 2D DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
        end
    end
    local DangerGui = nil
    local DangerBanner = nil
    local DangerLabel = nil
    local dangerConn = nil

    local function createDangerHUD()
        if DangerGui then DangerGui:Destroy() end
        DangerGui = Instance.new("ScreenGui")
        DangerGui.Name = "PearlDangerWarning"
        DangerGui.ResetOnSpawn = false
        DangerGui.DisplayOrder = 999
        DangerGui.Parent = getSafeGuiParent()

        local Banner = Instance.new("Frame")
        Banner.Name = "DangerBanner"
        Banner.Size = UDim2.new(0, 310, 0, 34)
        Banner.Position = UDim2.new(0.5, -155, 0.16, 0)
        Banner.BackgroundColor3 = Color3.fromRGB(26, 12, 14)
        Banner.BackgroundTransparency = 0.2
        Banner.BorderSizePixel = 0
        Banner.Visible = false
        Banner.Parent = DangerGui
        makeCorner(Banner, 8)
        makeStroke(Banner, Color3.fromRGB(255, 60, 75), 1.5)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = "ATTENTION : VISE PAR UN ENNEMI"
        Label.TextColor3 = Color3.fromRGB(255, 80, 90)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 11.5
        Label.Parent = Banner

        DangerBanner = Banner
        DangerLabel = Label
    end

    function toggleDangerWarning(enabled)
        V.DangerWarning = enabled
        if dangerConn then dangerConn:Disconnect() dangerConn = nil end
        if enabled then
            createDangerHUD()
            dangerConn = RunService.RenderStepped:Connect(function()
                if not V.DangerWarning or not DangerBanner or not DangerBanner.Parent then return end
                local char = LocalPlayer.Character
                local myHead = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
                if not myHead then
                    DangerBanner.Visible = false
                    return
                end

                local closestThreat = nil
                local closestDist = 250

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local isTeam = isPlayerTeamMate and isPlayerTeamMate(p)
                        if not isTeam then
                            local eChar = p.Character
                            local eHead = eChar:FindFirstChild("Head") or eChar:FindFirstChild("HumanoidRootPart")
                            local eHum = eChar:FindFirstChildOfClass("Humanoid")
                            if eHead and eHum and eHum.Health > 0 then
                                local toMe = (myHead.Position - eHead.Position)
                                local dist = toMe.Magnitude
                                if dist < closestDist and dist > 2 then
                                    local dirToMe = toMe.Unit
                                    local look = eHead.CFrame.LookVector
                                    local dot = look:Dot(dirToMe)
                                    if dot > 0.93 then
                                        closestThreat = p
                                        closestDist = dist
                                    end
                                end
                            end
                        end
                    end
                end

                if closestThreat then
                    DangerBanner.Visible = true
                    DangerLabel.Text = "VISE PAR " .. closestThreat.DisplayName:upper() .. " (" .. math.floor(closestDist) .. " STUDS)"
                else
                    DangerBanner.Visible = false
                end
            end)
            addConnection(dangerConn)
            notify("ESP", "Alerte de Danger ACTIF", Color3.fromRGB(80, 200, 120))
        else
            if DangerGui then DangerGui:Destroy() DangerGui = nil end
            notify("ESP", "Alerte de Danger DESACTIVE", Color3.fromRGB(255, 90, 90))
        end
    end
end

createLabel("RADAR 2D & ALERTES TACTIQUES", ESPContent)
createToggle("Radar 2D Tactique", false, function(enabled)
    toggleRadar2D(enabled)
end, ESPContent, "Radar2D")
createSlider("Portée Radar (50m - 400m)", 50, 400, 200, function(val)
    V.RadarRange = val
    if radarRangeLbl then radarRangeLbl.Text = val .. "m" end
end, ESPContent, "RadarRange")
createSlider("Taille Radar (140 - 240)", 140, 240, 180, function(val)
    V.RadarSize = val
    if V.Radar2D then
        toggleRadar2D(true)
    end
end, ESPContent, "RadarSize")

createToggle("Alerte Danger (Vise par un Ennemi)", false, function(enabled)
    toggleDangerWarning(enabled)
end, ESPContent, "DangerWarning")

bloxFruitsLevelFolder = nil
function toggleBloxFruitsLevelESP(enabled)
    V.ESPBloxFruitsLevel = enabled
    if bloxFruitsLevelFolder then
        bloxFruitsLevelFolder:Destroy()
        bloxFruitsLevelFolder = nil
    end
    if enabled then
        bloxFruitsLevelFolder = Instance.new("Folder")
        bloxFruitsLevelFolder.Name = "PearlBloxFruitsLevelESP"
        bloxFruitsLevelFolder.Parent = ESPGui or parentTarget

        task.spawn(function()
            while V.ESPBloxFruitsLevel do
                if not bloxFruitsLevelFolder then break end
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                        if head then
                            local bb = bloxFruitsLevelFolder:FindFirstChild("BFLevel_" .. player.Name)
                            local levelText = "?"
                            local data = player:FindFirstChild("Data")
                            if data and data:FindFirstChild("Level") then
                                levelText = tostring(data.Level.Value)
                            else
                                local ls = player:FindFirstChild("leaderstats")
                                if ls and ls:FindFirstChild("Level") then
                                    levelText = tostring(ls.Level.Value)
                                else
                                    for _, desc in pairs(char:GetDescendants()) do
                                        if desc:IsA("TextLabel") and string.find(desc.Text, "Lv%s*%.?%s*%d+") then
                                            local lv = string.match(desc.Text, "Lv%s*%.?%s*(%d+)")
                                            if lv then levelText = lv break end
                                        end
                                    end
                                end
                            end

                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = "BFLevel_" .. player.Name
                                bb.Size = UDim2.new(0, 120, 0, 22)
                                bb.StudsOffset = Vector3.new(0, 3.2, 0)
                                bb.AlwaysOnTop = true
                                bb.Adornee = head
                                bb.Parent = bloxFruitsLevelFolder

                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "LevelLabel"
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Text = "[Lv. " .. levelText .. "]"
                                lbl.TextColor3 = Color3.fromRGB(175, 110, 255)
                                lbl.TextSize = 12
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextStrokeTransparency = 0.2
                                lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                lbl.Parent = bb
                            else
                                bb.Adornee = head
                                local lbl = bb:FindFirstChild("LevelLabel")
                                if lbl then
                                    lbl.Text = "[Lv. " .. levelText .. "]"
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end
createToggle('Esp level (<font color="rgb(175,110,255)">Bloxfruit</font>)', false, function(enabled)
    toggleBloxFruitsLevelESP(enabled)
end, ESPContent, "ESPBloxFruitsLevel")

_G.getPlayerBloxFruit = function(player)
    local fruitName = nil
    local isPerm = false
    local invFruitList = {}
    if not player then return "Aucun", false, invFruitList end
    local data = player:FindFirstChild("Data")
    if data then
        local df = data:FindFirstChild("DevilFruit") or data:FindFirstChild("Fruit") or data:FindFirstChild("DevilFruitName")
        if df and df.Value and df.Value ~= "" and df.Value ~= "None" then
            fruitName = tostring(df.Value)
        end
        local permFolder = data:FindFirstChild("PermFruits") or data:FindFirstChild("PermanentFruits") or data:FindFirstChild("Perm") or data:FindFirstChild("Permanent") or data:FindFirstChild("OwnedFruits") or data:FindFirstChild("Perms")
        if permFolder and fruitName then
            local clean = string.gsub(string.gsub(fruitName, "%-.*$", ""), "%s*[Ff]ruit$", "")
            for _, ch in ipairs(permFolder:GetChildren()) do
                if string.find(string.lower(ch.Name), string.lower(clean)) or ch.Name == fruitName then
                    isPerm = true
                    break
                end
            end
        end
        if fruitName and data:GetAttribute("Perm" .. fruitName) == true then
            isPerm = true
        end
    end
    if player:GetAttribute("DevilFruit") then
        local dfAttr = tostring(player:GetAttribute("DevilFruit"))
        if dfAttr ~= "" and dfAttr ~= "None" then
            fruitName = fruitName or dfAttr
        end
    end
    if fruitName and (player:GetAttribute("IsPerm") == true or player:GetAttribute("Perm") == true or player:GetAttribute("Permanent") == true) then
        isPerm = true
    end
    local scanList = {}
    if player.Character then table.insert(scanList, player.Character) end
    local bp = player:FindFirstChild("Backpack")
    if bp then table.insert(scanList, bp) end
    for _, container in ipairs(scanList) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local rawItemName = item.Name
                local lowerItemName = string.lower(rawItemName)
                local isToolFruit = false
                local itemIsPerm = false
                if string.find(lowerItemName, "perm") or string.find(lowerItemName, "permanent") then
                    itemIsPerm = true
                    isToolFruit = true
                end
                if string.find(lowerItemName, "fruit") or string.find(lowerItemName, "devil") then
                    isToolFruit = true
                end
                if item:GetAttribute("Permanent") == true or item:GetAttribute("IsPermanent") == true or item:GetAttribute("Perm") == true or item:GetAttribute("IsPerm") == true then
                    itemIsPerm = true
                    isToolFruit = true
                end
                if item:FindFirstChild("Permanent") or item:FindFirstChild("Perm") or item:FindFirstChild("IsPermanent") then
                    itemIsPerm = true
                    isToolFruit = true
                end
                local tip = item.ToolTip
                if tip and (string.find(string.lower(tip), "fruit") or string.find(string.lower(tip), "perm")) then
                    isToolFruit = true
                    if string.find(string.lower(tip), "perm") then
                        itemIsPerm = true
                    end
                end
                if isToolFruit then
                    table.insert(invFruitList, {
                        name = rawItemName,
                        isPerm = itemIsPerm
                    })
                    if not fruitName then
                        fruitName = rawItemName
                        if itemIsPerm then isPerm = true end
                    elseif itemIsPerm and not isPerm then
                        local cleanEq = string.gsub(fruitName, "%-.*$", "")
                        if string.find(lowerItemName, string.lower(cleanEq)) then
                            isPerm = true
                        end
                    end
                end
            end
        end
    end
    if player == LocalPlayer and (not fruitName or not isPerm) then
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            local rem = rs:FindFirstChild("Remotes")
            local comm = rem and rem:FindFirstChild("CommF_")
            if comm then
                local inv = comm:InvokeServer("getInventory")
                if type(inv) == "table" then
                    for _, it in pairs(inv) do
                        if type(it) == "table" then
                            local iname = tostring(it.Name or it.id or "")
                            local itype = tostring(it.Type or "")
                            local iperm = (itype == "Perm" or itype == "Permanent" or it.Permanent == true or string.find(string.lower(iname), "perm"))
                            if iperm and fruitName and string.find(string.lower(fruitName), string.lower(string.gsub(iname, "%-.*$", ""))) then
                                isPerm = true
                            end
                        end
                    end
                end
            end
        end)
    end
    local cleanName = "Aucun"
    if fruitName and fruitName ~= "" and fruitName ~= "None" then
        cleanName = fruitName
        local p1, p2 = string.match(fruitName, "^([%w]+)%-([%w]+)$")
        if p1 and string.lower(p1) == string.lower(p2) then
            cleanName = p1
        else
            cleanName = string.gsub(cleanName, "%s*[Ff]ruit$", "")
            cleanName = string.gsub(cleanName, "^[Ff]ruit%s*%-?%s*", "")
        end
    end
    return cleanName, isPerm, invFruitList
end
local getPlayerBloxFruit = _G.getPlayerBloxFruit

bloxFruitsFruitFolder = nil
function toggleBloxFruitsFruitESP(enabled)
    V.ESPBloxFruitsFruit = enabled
    if bloxFruitsFruitFolder then
        bloxFruitsFruitFolder:Destroy()
        bloxFruitsFruitFolder = nil
    end
    if enabled then
        bloxFruitsFruitFolder = Instance.new("Folder")
        bloxFruitsFruitFolder.Name = "PearlBloxFruitsFruitESP"
        bloxFruitsFruitFolder.Parent = ESPGui or parentTarget

        task.spawn(function()
            local notifiedFruits = {}
            while V.ESPBloxFruitsFruit do
                if not bloxFruitsFruitFolder then break end
                local activeKeys = {}

                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local char = player.Character
                        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                        if head then
                            local playerKey = "BFPlFruit_" .. player.Name
                            activeKeys[playerKey] = true
                            local fruitName, isPerm, invList = getPlayerBloxFruit(player)
                            local dist = 0
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude)
                            end

                            local displayText = ""
                            if fruitName ~= "Aucun" then
                                if isPerm then
                                    displayText = '[' .. fruitName .. '] <font color="rgb(255,50,50)">perm</font>'
                                else
                                    displayText = '[' .. fruitName .. '] <font color="rgb(160,160,175)">[Physique]</font>'
                                end
                            elseif #invList > 0 then
                                local firstFruit = invList[1]
                                if firstFruit.isPerm then
                                    displayText = '[' .. firstFruit.name .. '] <font color="rgb(255,50,50)">perm</font>'
                                else
                                    displayText = '[' .. firstFruit.name .. '] <font color="rgb(160,160,175)">[Physique]</font>'
                                end
                            else
                                displayText = '<font color="rgb(150,150,165)">[Sans Fruit]</font>'
                            end

                            local extraInvText = ""
                            if #invList > 0 and fruitName ~= "Aucun" then
                                local listNames = {}
                                for _, itm in ipairs(invList) do
                                    if itm.isPerm then
                                        table.insert(listNames, itm.name .. ' <font color="rgb(255,50,50)">perm</font>')
                                    else
                                        table.insert(listNames, itm.name)
                                    end
                                end
                                extraInvText = "Sac: " .. table.concat(listNames, ", ")
                            end

                            local bb = bloxFruitsFruitFolder:FindFirstChild(playerKey)
                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = playerKey
                                bb.Size = UDim2.new(0, 190, 0, 42)
                                bb.StudsOffset = Vector3.new(0, 4.4, 0)
                                bb.AlwaysOnTop = true
                                bb.Adornee = head
                                bb.Parent = bloxFruitsFruitFolder

                                local titleLbl = Instance.new("TextLabel")
                                titleLbl.Name = "FruitTitle"
                                titleLbl.Size = UDim2.new(1, 0, 0, 18)
                                titleLbl.Position = UDim2.new(0, 0, 0, 0)
                                titleLbl.BackgroundTransparency = 1
                                titleLbl.RichText = true
                                titleLbl.Text = displayText
                                titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                                titleLbl.TextSize = 12
                                titleLbl.Font = Enum.Font.GothamBold
                                titleLbl.TextStrokeTransparency = 0.2
                                titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                titleLbl.Parent = bb

                                local distLbl = Instance.new("TextLabel")
                                distLbl.Name = "FruitDist"
                                distLbl.Size = UDim2.new(1, 0, 0, 14)
                                distLbl.Position = UDim2.new(0, 0, 0, 18)
                                distLbl.BackgroundTransparency = 1
                                distLbl.RichText = true
                                distLbl.Text = "[" .. tostring(dist) .. " studs]" .. (extraInvText ~= "" and (" | " .. extraInvText) or "")
                                distLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
                                distLbl.TextSize = 10
                                distLbl.Font = Enum.Font.GothamMedium
                                distLbl.TextStrokeTransparency = 0.2
                                distLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                distLbl.Parent = bb
                            else
                                bb.Adornee = head
                                local titleLbl = bb:FindFirstChild("FruitTitle")
                                if titleLbl then
                                    titleLbl.Text = displayText
                                end
                                local distLbl = bb:FindFirstChild("FruitDist")
                                if distLbl then
                                    distLbl.Text = "[" .. tostring(dist) .. " studs]" .. (extraInvText ~= "" and (" | " .. extraInvText) or "")
                                end
                            end
                        end
                    end
                end

                local function checkGroundFruit(obj)
                    if not obj then return end
                    local isFruit = false
                    local fruitName = obj.Name
                    if obj:IsA("Tool") and (string.find(string.lower(fruitName), "fruit") or string.find(string.lower(fruitName), "devil")) then
                        isFruit = true
                    elseif obj:IsA("Model") and (string.find(string.lower(fruitName), "fruit") or string.find(string.lower(fruitName), "devil")) then
                        isFruit = true
                    elseif obj:IsA("BasePart") and (string.find(string.lower(fruitName), "fruit") or string.find(string.lower(fruitName), "devil")) then
                        isFruit = true
                    end
                    if isFruit then
                        local handle = obj:IsA("BasePart") and obj or (obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart"))
                        if handle then
                            local groundKey = "BFGndFruit_" .. (obj:GetDebugId() or (fruitName .. "_" .. tostring(handle.Position.X)))
                            activeKeys[groundKey] = true
                            if not notifiedFruits[groundKey] then
                                notifiedFruits[groundKey] = true
                                notify("Blox Fruits", "Fruit detecte au sol : " .. fruitName, Color3.fromRGB(175, 110, 255))
                            end
                            local dist = 0
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - handle.Position).Magnitude)
                            end
                            local bb = bloxFruitsFruitFolder:FindFirstChild(groundKey)
                            if not bb then
                                bb = Instance.new("BillboardGui")
                                bb.Name = groundKey
                                bb.Size = UDim2.new(0, 160, 0, 36)
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.Adornee = handle
                                bb.Parent = bloxFruitsFruitFolder

                                local titleLbl = Instance.new("TextLabel")
                                titleLbl.Name = "FruitTitle"
                                titleLbl.Size = UDim2.new(1, 0, 0, 18)
                                titleLbl.Position = UDim2.new(0, 0, 0, 0)
                                titleLbl.BackgroundTransparency = 1
                                titleLbl.RichText = true
                                titleLbl.Text = '<font color="rgb(255,215,0)">[Sol] ' .. fruitName .. '</font>'
                                titleLbl.TextColor3 = Color3.fromRGB(255, 215, 0)
                                titleLbl.TextSize = 12
                                titleLbl.Font = Enum.Font.GothamBold
                                titleLbl.TextStrokeTransparency = 0.2
                                titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                titleLbl.Parent = bb

                                local distLbl = Instance.new("TextLabel")
                                distLbl.Name = "FruitDist"
                                distLbl.Size = UDim2.new(1, 0, 0, 14)
                                distLbl.Position = UDim2.new(0, 0, 0, 18)
                                distLbl.BackgroundTransparency = 1
                                distLbl.Text = "[" .. tostring(dist) .. " studs]"
                                distLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                                distLbl.TextSize = 10
                                distLbl.Font = Enum.Font.GothamMedium
                                distLbl.TextStrokeTransparency = 0.2
                                distLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                distLbl.Parent = bb

                                local hl = Instance.new("Highlight")
                                hl.Name = "FruitHighlight"
                                hl.Adornee = obj
                                hl.FillColor = Color3.fromRGB(175, 110, 255)
                                hl.FillTransparency = 0.5
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.OutlineTransparency = 0.2
                                hl.Parent = bb
                            else
                                bb.Adornee = handle
                                local distLbl = bb:FindFirstChild("FruitDist")
                                if distLbl then
                                    distLbl.Text = "[" .. tostring(dist) .. " studs]"
                                end
                            end
                        end
                    end
                end

                for _, obj in pairs(workspace:GetChildren()) do
                    checkGroundFruit(obj)
                end
                local map = workspace:FindFirstChild("Map")
                if map then
                    for _, obj in pairs(map:GetChildren()) do
                        checkGroundFruit(obj)
                    end
                end

                for _, child in pairs(bloxFruitsFruitFolder:GetChildren()) do
                    if not activeKeys[child.Name] then
                        child:Destroy()
                    end
                end

                task.wait(1.2)
            end
        end)
    end
end
createToggle('Esp Fruit (<font color="rgb(175,110,255)">Bloxfruit</font>)', false, function(enabled)
    toggleBloxFruitsFruitESP(enabled)
end, ESPContent, "ESPBloxFruitsFruit")

arrowESPList = {}
ArrowGui = Instance.new("ScreenGui")
ArrowGui.Name = "PearlArrowGui"
ArrowGui.ResetOnSpawn = false
ArrowGui.DisplayOrder = 9999
ArrowGui.IgnoreGuiInset = true
ArrowGui.Enabled = true
ArrowGui.Parent = parentTarget

function cleanupArrowESP()
    for _, arrow in pairs(arrowESPList) do
        pcall(function() arrow:Destroy() end)
    end
    arrowESPList = {}
end
_G.cleanupArrowESP = cleanupArrowESP

function toggleArrowESP(enabled)
    V.ArrowESP = enabled
    if V.ArrowESPConn then V.ArrowESPConn:Disconnect() V.ArrowESPConn = nil end
    cleanupArrowESP()

    if enabled then
        V.ArrowESPConn = RunService.RenderStepped:Connect(function()
            if not V.ArrowESP then return end
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then
                for _, a in pairs(arrowESPList) do a.Visible = false end
                return
            end

            local vp = Camera.ViewportSize
            local screenCenter = Vector2.new(vp.X / 2, vp.Y / 2)
            local radius = V.ArrowESPRadius or 180
            local curColor = V.ESPColor or Color3.fromRGB(255, 50, 75)

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local pHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                    if pHrp and pHum and pHum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(pHrp.Position)
                        local isOffScreen = (not onScreen) or (screenPos.Z < 0) or (screenPos.X < 25 or screenPos.X > vp.X - 25 or screenPos.Y < 25 or screenPos.Y > vp.Y - 25)

                        if isOffScreen then
                            local arrow = arrowESPList[player]
                            if not arrow then
                                arrow = Instance.new("ImageLabel")
                                arrow.Name = "ArrowESP_" .. player.Name
                                arrow.Size = UDim2.new(0, 26, 0, 26)
                                arrow.AnchorPoint = Vector2.new(0.5, 0.5)
                                arrow.BackgroundTransparency = 1
                                arrow.BorderSizePixel = 0
                                arrow.Image = "rbxassetid://7734020942"
                                arrow.ImageColor3 = curColor
                                arrow.ZIndex = 50
                                arrow.Parent = ArrowGui

                                arrowESPList[player] = arrow
                            end

                            arrow.ImageColor3 = curColor

                            local targetScreenPos
                            if screenPos.Z < 0 then
                                targetScreenPos = Vector2.new(vp.X - screenPos.X, vp.Y - screenPos.Y)
                            else
                                targetScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                            end

                            local diff = targetScreenPos - screenCenter
                            local dir = diff.Magnitude > 0 and diff.Unit or Vector2.new(0, -1)
                            local rot = math.deg(math.atan2(dir.Y, dir.X)) + 90

                            arrow.Position = UDim2.new(0, screenCenter.X + (dir.X * radius), 0, screenCenter.Y + (dir.Y * radius))
                            arrow.Rotation = rot
                            arrow.Visible = true
                        else
                            if arrowESPList[player] then
                                arrowESPList[player].Visible = false
                            end
                        end
                    else
                        if arrowESPList[player] then
                            arrowESPList[player].Visible = false
                        end
                    end
                end
            end
        end)
        addConnection(V.ArrowESPConn)
        notify("ESP", "Arrow ESP (Fleches Off-Screen) ACTIVE", Color3.fromRGB(80, 200, 120))
    else
        notify("ESP", "Arrow ESP DESACTIVE", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleArrowESP = toggleArrowESP

createToggle("Arrow ESP (Fleches Ennemis)", false, function(enabled)
    toggleArrowESP(enabled)
end, ESPContent, "ArrowESP")
createSlider("Distance Arrow ESP (Centre)", 50, 500, 180, function(val)
    V.ArrowESPRadius = val
end, ESPContent, "ArrowESPRadius")

--------------------------------------------------------------------------------
-- SOUND SONAR (EXPANDING FOOTSTEP RINGS / VISUAL AUDIO)--------------------------------------------------------------------------------
-- SOUND SONAR (EXPANDING FOOTSTEP RINGS / VISUAL AUDIO)
--------------------------------------------------------------------------------
soundSonarConn = nil
sonarCooldowns = {}

function cleanupSoundSonar()
    if soundSonarConn then pcall(function() soundSonarConn:Disconnect() end) soundSonarConn = nil end
    sonarCooldowns = {}
end
_G.cleanupSoundSonar = cleanupSoundSonar

local function spawnSonarPulse(position, playerColor)
    local terrain = workspace.Terrain
    if not terrain then return end

    local ring = Instance.new("CylinderHandleAdornment")
    ring.Name = "SonarRing"
    ring.Height = 0.15
    ring.Radius = 1.8
    ring.InnerRadius = 1.3
    ring.Color3 = playerColor or V.ESPColor or Color3.fromRGB(100, 210, 255)
    ring.Transparency = 0.2
    ring.AlwaysOnTop = true
    ring.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(90), 0, 0)
    ring.Adornee = terrain
    ring.Parent = terrain

    task.spawn(function()
        local duration = 0.75
        local steps = 24
        local dt = duration / steps
        for i = 1, steps do
            task.wait(dt)
            if not ring or not ring.Parent then break end
            local alpha = i / steps
            ring.Radius = 1.8 + (alpha * 12)
            ring.InnerRadius = math.max(0.5, ring.Radius - 0.7)
            ring.Transparency = 0.2 + (alpha * 0.8)
        end
        if ring and ring.Parent then
            ring:Destroy()
        end
    end)
end

function toggleSoundSonar(enabled)
    V.SoundSonar = enabled
    cleanupSoundSonar()

    if enabled then
        soundSonarConn = RunService.Heartbeat:Connect(function()
            if not V.SoundSonar then return end
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not myHrp then return end

            local now = tick()

            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local pHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                    if pHrp and pHum and pHum.Health > 0 then
                        local isTeammate = V.ESPTeamCheck and player.Team and LocalPlayer.Team and (player.Team == LocalPlayer.Team)
                        local dist = (pHrp.Position - myHrp.Position).Magnitude

                        local vel = pHrp.AssemblyLinearVelocity
                        local isMoving = (vel.Magnitude > 10) or (pHum.MoveDirection.Magnitude > 0.1)

                        if isMoving and dist <= 90 and not isTeammate then
                            local lastPulse = sonarCooldowns[player] or 0
                            if now - lastPulse >= 0.38 then
                                sonarCooldowns[player] = now
                                local footPos = pHrp.Position - Vector3.new(0, 2.5, 0)
                                spawnSonarPulse(footPos, V.ESPColor)
                            end
                        end
                    end
                end
            end
        end)
        addConnection(soundSonarConn)
        notify("ESP", "Sound Sonar (Footstep Rings) ACTIVÉ", Color3.fromRGB(80, 200, 120))
    else
        notify("ESP", "Sound Sonar DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleSoundSonar = toggleSoundSonar

createToggle("Sound Sonar (Footstep Rings)", false, function(enabled)
    toggleSoundSonar(enabled)
end, ESPContent, "SoundSonar")


tracerOriginsList = {"Bottom","Center","Mouse"}
currentOriginIdx = 1
tracerOriginFrame, tracerBtnObj, tracerOriginValue = createValueButton(ESPContent, "Tracer Origin", V.ESPTracerOrigin, function()
    currentOriginIdx = (currentOriginIdx % #tracerOriginsList) + 1
    V.ESPTracerOrigin = tracerOriginsList[currentOriginIdx]
    notify("ESP","Origine des Tracers : ".. V.ESPTracerOrigin, Color3.fromRGB(80, 200, 120))
    return V.ESPTracerOrigin
end)

-- SECTION VEHICLE ESP
createLabel("VEHICLE ESP", ESPContent)

createToggle("Enable Vehicle ESP", false, function(enabled)
    V.VehicleESP = enabled
    if VehicleESPGui then
        VehicleESPGui.Enabled = enabled
    end
    if not enabled and clearVehicleESP then
        clearVehicleESP()
    elseif enabled and scanAndCreateVehicleESP then
        scanAndCreateVehicleESP()
    end
    notify("ESP", "Vehicle ESP " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ESPContent, "VehicleESP")

createToggle("Box 3D (Véhicule)", true, function(enabled)
    V.VehicleESPBox3D = enabled
end, ESPContent, "VehicleESPBox3D")

createToggle("Nom du Véhicule (Name)", true, function(enabled)
    V.VehicleESPName = enabled
end, ESPContent, "VehicleESPName")

createToggle("Distance Véhicule", true, function(enabled)
    V.VehicleESPDist = enabled
end, ESPContent, "VehicleESPDist")

createToggle("Indicateur Conducteur (Driver)", true, function(enabled)
    V.VehicleESPDriver = enabled
end, ESPContent, "VehicleESPDriver")

createLabel("COULEUR BOX VEHICULE", ESPContent)
do
    local VehPaletteFrame = Instance.new("Frame")
    VehPaletteFrame.Size = UDim2.new(1, 0, 0, 40)
    VehPaletteFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    VehPaletteFrame.BorderSizePixel = 0
    VehPaletteFrame.Parent = ESPContent

    local vpc = Instance.new("UICorner")
    vpc.CornerRadius = UDim.new(0, 8)
    vpc.Parent = VehPaletteFrame

    local vpl = Instance.new("UIListLayout")
    vpl.FillDirection = Enum.FillDirection.Horizontal
    vpl.Padding = UDim.new(0, 6)
    vpl.Parent = VehPaletteFrame

    local vpp = Instance.new("UIPadding")
    vpp.PaddingLeft = UDim.new(0, 10)
    vpp.PaddingTop = UDim.new(0, 7)
    vpp.Parent = VehPaletteFrame

    local function createVehPaletteColor(col)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.BackgroundColor3 = col
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = VehPaletteFrame

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Thickness = 1
        s.Color = Color3.fromRGB(80, 80, 90)
        s.Transparency = 0.6
        s.Parent = btn

        btn.MouseButton1Click:Connect(function()
            V.VehicleESPColor = col
            notify("ESP", "Couleur Box Véhicule changée !", col)
        end)
    end

    createVehPaletteColor(Color3.fromRGB(145, 120, 255)) -- Violet (Defaut)
    createVehPaletteColor(Color3.fromRGB(255, 170, 0))   -- Orange / Ambre
    createVehPaletteColor(Color3.fromRGB(255, 60, 60))   -- Rouge
    createVehPaletteColor(Color3.fromRGB(60, 180, 255))  -- Bleu Ciel
    createVehPaletteColor(Color3.fromRGB(46, 204, 113))  -- Vert Emeraude
    createVehPaletteColor(Color3.fromRGB(255, 255, 255)) -- Blanc Pur
    createVehPaletteColor(Color3.fromRGB(255, 80, 180))  -- Rose Fluo
end

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

initStep = "cablage Aim"
createLabel("AIMBOT & CAMERA LOCK", AimContent)

_, SetAimlockToggle, ToggleAimlock = createToggle("Enable Aimlock (Verrouillage)", false, function(enabled)
    Aimlock_Enabled = enabled
    _G.Aimlock_Enabled = enabled
    if SilentAimCircle then SilentAimCircle.Visible = enabled and (_G.Aimlock_ShowFOV or Aimlock_ShowFOV) end
    notify("Aim", "Aimlock " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, AimContent, "Aimlock")

createToggle("Hold Mode (Maintenir la touche)", false, function(enabled)
    Aimlock_HoldMode = enabled
    _G.Aimlock_HoldMode = enabled
end, AimContent, "AimlockHold")

createToggle("Auto Lock (Dans FOV)", false, function(enabled)
    V.AimlockAutoLock = enabled
    notify("Aim", "Auto Lock dans FOV " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, AimContent, "AimAutoLock")

AimlockKeyBtn = nil
pcall(function()
    local AimKeyCard = createCard(AimContent, 0, 46)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Aimlock Keybind"
    title.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 8
    title.Parent = AimKeyCard

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 68, 0, 26)
    keyBtn.Position = UDim2.new(1, -78, 0.5, -13)
    keyBtn.BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47)
    keyBtn.BorderSizePixel = 0
    keyBtn.Text = "[" .. tostring(_G.Aimlock_KeyName or "Aucun") .. "]"
    local dimCol = theme.textDim or theme.sub or Color3.fromRGB(130, 134, 152)
    local accCol = theme.accent or Color3.fromRGB(145, 120, 255)
    keyBtn.TextColor3 = (_G.Aimlock_KeyName and _G.Aimlock_KeyName ~= "Aucun") and accCol or dimCol
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.TextSize = 10
    keyBtn.ZIndex = 9
    keyBtn.Parent = AimKeyCard
    makeCorner(keyBtn, 8)
    makeStroke(keyBtn, theme.border or Color3.fromRGB(44, 46, 62), 1)
    AimlockKeyBtn = keyBtn
    KeybindButtons["Aimlock"] = keyBtn
    registerSearchCard(AimKeyCard, "Aimlock Keybind Touche", AimContent)

    local waitingAimKey = false
    keyBtn.MouseButton1Click:Connect(function()
        waitingAimKey = true
        keyBtn.Text = "[...]"
        keyBtn.TextColor3 = Color3.fromRGB(255, 170, 0)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if waitingAimKey then
            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Escape then
                _G.Aimlock_Key = nil
                Aimlock_Key = nil
                _G.Aimlock_KeyName = "Aucun"
                Aimlock_KeyName = "Aucun"
                keyBtn.Text = "[Aucun]"
                keyBtn.TextColor3 = theme.textDim or theme.sub or Color3.fromRGB(130, 134, 152)
                waitingAimKey = false
                notify("Keybind", "Aimlock: Touche retiree (Pas attribue)", Color3.fromRGB(255, 170, 0))
                return
            end
            local chosenKey, keyName = nil, nil
            if input.UserInputType == Enum.UserInputType.Keyboard then
                chosenKey = input.KeyCode
                keyName = string.sub(tostring(input.KeyCode), 14)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                chosenKey = Enum.UserInputType.MouseButton1
                keyName = "M1"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                chosenKey = Enum.UserInputType.MouseButton2
                keyName = "M2"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                chosenKey = Enum.UserInputType.MouseButton3
                keyName = "M3"
            end
            if chosenKey then
                _G.Aimlock_Key = chosenKey
                Aimlock_Key = chosenKey
                _G.Aimlock_KeyName = keyName
                Aimlock_KeyName = keyName
                keyBtn.Text = "[" .. keyName .. "]"
                keyBtn.TextColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
                waitingAimKey = false
                notify("Keybind", "Aimlock bind: " .. keyName, Color3.fromRGB(80, 200, 120))
            end
        end
    end)
end)

aimPartFrame, aimPartBtnObj, aimPartValue = createValueButton(AimContent, "Target Part (Partie Visée)", "Head", function()
    local parts = {"Head", "HumanoidRootPart", "UpperTorso"}
    local current = _G.Aimlock_TargetPart or Aimlock_TargetPart or "Head"
    local idx = table.find(parts, current) or 1
    idx = (idx % #parts) + 1
    local newPart = parts[idx]
    _G.Aimlock_TargetPart = newPart
    Aimlock_TargetPart = newPart
    notify("Aim", "Cible: " .. newPart, Color3.fromRGB(80, 200, 120))
    return newPart
end)

createSlider("Aim Smoothness (1 = Instant)", 1, 10, 1, function(val)
    Aimlock_Smoothness = val
    _G.Aimlock_Smoothness = val
end, AimContent, "AimSmoothness")

createSlider("FOV Radius (Rayon du Cercle)", 30, 500, 150, function(val)
    Aimlock_FOV = val
    _G.Aimlock_FOV = val
    if SilentAimCircle then SilentAimCircle.Radius = val end
end, AimContent, "AimFOV")

createToggle("Wallcheck (Vérification Murs)", true, function(enabled)
    Aimlock_Wallcheck = enabled
    _G.Aimlock_Wallcheck = enabled
end, AimContent, "AimWallcheck")

createToggle("Team Check (Ignorer Allis)", true, function(enabled)
    Aimlock_TeamCheck = enabled
    _G.Aimlock_TeamCheck = enabled
    notify("Aim", "Aimlock Team Check " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, AimContent, "AimTeamCheck")

createToggle("Show FOV Circle (Afficher Cercle)", true, function(enabled)
    Aimlock_ShowFOV = enabled
    _G.Aimlock_ShowFOV = enabled
    if SilentAimCircle then SilentAimCircle.Visible = (_G.Aimlock_Enabled or Aimlock_Enabled) and enabled end
end, AimContent, "AimShowFOV")

createToggle("Movement Prediction (Prédiction)", true, function(enabled)
    Aimlock_Prediction = enabled
    _G.Aimlock_Prediction = enabled
end, AimContent, "AimPrediction")

createSlider("Prediction Strength (Force 0.5x - 2.5x)", 5, 25, 10, function(val)
    local factor = val / 10
    Aimlock_PredictionBoost = factor
    _G.Aimlock_PredictionBoost = factor
end, AimContent, "AimPredStrength")

createToggle("Target NPCs (Cibler les PNJ)", false, function(enabled)
    Aimlock_TargetNPCs = enabled
    _G.Aimlock_TargetNPCs = enabled
end, AimContent, "AimTargetNPCs")

-- ====================================================================
-- OPTIONS BALISTIQUE, BEZIER & TRIGGERBOT PREDICTIF
-- ====================================================================
createLabel("AIMLOCK BALISTIQUE & LISSAGE BEZIER", AimContent)
createToggle("Ballistic Prediction (Ping & Gravite)", true, function(enabled)
    V.AimlockBallistic = enabled
    _G.Aimlock_Ballistic = enabled
end, AimContent, "AimBallistic")

createToggle("Lissage Bezier (Courbe Humaine)", true, function(enabled)
    V.AimlockBezier = enabled
end, AimContent, "AimBezier")

createToggle("Micro-Jitter Humain (Anti-Spectate)", false, function(enabled)
    V.AimlockJitter = enabled
end, AimContent, "AimJitter")

do
    local lastTriggerTime = 0
    local triggerbotConn = nil
    local VIM = nil

    local function performInstantShot(mousePos)
        local cam = workspace.CurrentCamera
        local posX = mousePos and mousePos.X or (cam and cam.ViewportSize.X / 2 or 500)
        local posY = mousePos and mousePos.Y or (cam and cam.ViewportSize.Y / 2 or 350)

        if VIM then
            pcall(function()
                VIM:SendMouseButtonEvent(posX, posY, 0, true, game, 0)
                task.wait(0.01)
                VIM:SendMouseButtonEvent(posX, posY, 0, false, game, 0)
            end)
        elseif mouse1click then
            pcall(mouse1click)
        elseif mouse1press and mouse1release then
            pcall(mouse1press)
            task.wait(0.01)
            pcall(mouse1release)
        end

        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end)
    end

    local function checkTriggerbot()
        if not (V and (V.TriggerBot or V.TriggerBotFOV)) then return end
        local char = LocalPlayer.Character
        if not char then return end
        local cam = workspace.CurrentCamera
        if not cam then return end

        local now = tick()
        local delaySec = (V.TriggerBotDelay or 0) / 1000
        local minThrottle = math.max(delaySec, 0.03)
        if now - lastTriggerTime < minThrottle then return end

        local mousePos = UserInputService:GetMouseLocation()

        -- 1. MODE "TRIGGERBOT DANS FOV (AUTO SHOOT)" : tire instantanément dès qu'un ennemi est dans la FOV
        if V.TriggerBotFOV then
            local target = currentAimbotTarget or (getAimbotTarget and getAimbotTarget())
            if target and target.Character and isTargetAlive(target.Character) then
                lastTriggerTime = now
                if delaySec > 0 then
                    task.delay(delaySec, function() performInstantShot(mousePos) end)
                else
                    performInstantShot(mousePos)
                end
                return
            end
        end

        -- 2. MODE "TRIGGERBOT RÉTICULE (RAYCAST RAPIDE)" : tire dès que le viseur croise un ennemi
        if V.TriggerBot then
            local ray = cam:ViewportPointToRay(mousePos.X, mousePos.Y)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = { char, cam }
            params.IgnoreWater = true

            local result = workspace:Raycast(ray.Origin, ray.Direction * 1200, params)
            local hitPart = result and result.Instance or (LocalPlayer:GetMouse() and LocalPlayer:GetMouse().Target)
            if not hitPart then return end

            local hitModel = hitPart:FindFirstAncestorOfClass("Model")
            if not hitModel or hitModel == char then return end

            if isTargetAlive(hitModel) then
                local targetPlayer = Players:GetPlayerFromCharacter(hitModel)
                local isNPC = false

                if not targetPlayer and (V.TriggerBotNPC or _G.Aimlock_TargetNPCs or Aimlock_TargetNPCs) then
                    local hum = hitModel:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        isNPC = true
                    end
                end

                if not targetPlayer and not isNPC then return end

                if targetPlayer then
                    if targetPlayer == LocalPlayer then return end
                    if (V.TriggerBotTeamCheck ~= false) and isTeammate and isTeammate(targetPlayer) then return end
                    if IsWhitelisted and IsWhitelisted(targetPlayer) then return end
                    local hum = hitModel:FindFirstChildOfClass("Humanoid")
                    if not hum or hum.Health <= 0 then return end
                end

                if V.TriggerBotHeadOnly then
                    local pName = hitPart.Name:lower()
                    if not pName:find("head") then
                        return
                    end
                end

                lastTriggerTime = now
                if delaySec > 0 then
                    task.delay(delaySec, function() performInstantShot(mousePos) end)
                else
                    performInstantShot(mousePos)
                end
            end
        end
    end

    function toggleTriggerbot(enabled)
        V.TriggerBot = enabled
        if not V.TriggerBot and not V.TriggerBotFOV then
            if triggerbotConn then triggerbotConn:Disconnect() triggerbotConn = nil end
        elseif enabled and not triggerbotConn then
            triggerbotConn = RunService.RenderStepped:Connect(checkTriggerbot)
            addConnection(triggerbotConn)
        end
        if enabled then
            notify("TriggerBot", "TriggerBot Réticule ACTIF (0ms)", Color3.fromRGB(80, 200, 120))
        else
            notify("TriggerBot", "TriggerBot Réticule DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
        end
    end

    function toggleTriggerbotFOV(enabled)
        V.TriggerBotFOV = enabled
        if not V.TriggerBot and not V.TriggerBotFOV then
            if triggerbotConn then triggerbotConn:Disconnect() triggerbotConn = nil end
        elseif enabled and not triggerbotConn then
            triggerbotConn = RunService.RenderStepped:Connect(checkTriggerbot)
            addConnection(triggerbotConn)
        end
        notify("TriggerBot", "Auto Shoot dans FOV " .. (enabled and "ACTIF" or "DÉSACTIVÉ"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
    end
end

createLabel("TRIGGERBOT & AUTO-SHOOT", AimContent)
createToggle("TriggerBot Instantané (Réticule)", false, function(enabled)
    toggleTriggerbot(enabled)
end, AimContent, "TriggerBot")

createToggle("Auto Shoot dans FOV (Tir Automatique)", false, function(enabled)
    toggleTriggerbotFOV(enabled)
end, AimContent, "TriggerBotFOV")

createToggle("TriggerBot Headshot Only", false, function(enabled)
    V.TriggerBotHeadOnly = enabled
end, AimContent, "TriggerBotHeadOnly")

createSlider("TriggerBot Délai (ms)", 0, 100, 0, function(val)
    V.TriggerBotDelay = val
end, AimContent, "TriggerBotDelay")

tracerColors = { Color3.fromRGB(180, 70, 255), Color3.fromRGB(0, 240, 255) }
tracerColorIdx = 1

function spawnNeonTracer(startPos, endPos)
    pcall(function()
        local dist = (endPos - startPos).Magnitude
        if dist < 0.5 then return end
        
        local part = Instance.new("Part")
        part.Name = "PearlNeonBulletTracer"
        part.Anchored = true
        part.CanCollide = false
        part.CastShadow = false
        part.Material = Enum.Material.Neon
        tracerColorIdx = (tracerColorIdx % #tracerColors) + 1
        part.Color = tracerColors[tracerColorIdx]
        part.Size = Vector3.new(0.08, 0.08, dist)
        part.CFrame = CFrame.lookAt((startPos + endPos) / 2, endPos)
        part.Parent = workspace

        local tw = TweenService:Create(part, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = Vector3.new(0.01, 0.01, dist)
        })
        tw:Play()
        task.delay(0.7, function()
            pcall(function() part:Destroy() end)
        end)
    end)
end
_G.spawnNeonTracer = spawnNeonTracer

local lastTracerTick = 0
local function fireBulletTracer()
    if not V.BulletTracers then return end
    local now = tick()
    if now - lastTracerTick < 0.04 then return end
    lastTracerTick = now

    local char = LocalPlayer.Character
    if not char then return end
    local cam = workspace.CurrentCamera

    local startPos = nil
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local muzzle = tool:FindFirstChild("Muzzle", true)
            or tool:FindFirstChild("Barrel", true)
            or tool:FindFirstChild("MuzzlePoint", true)
            or tool:FindFirstChild("FirePoint", true)
            or tool:FindFirstChild("Tip", true)
            or tool:FindFirstChild("Handle", true)
            or tool:FindFirstChildWhichIsA("BasePart", true)
        if muzzle then startPos = muzzle.Position end
    end
    if not startPos then
        local hand = char:FindFirstChild("RightHand")
            or char:FindFirstChild("Right Arm")
            or char:FindFirstChild("Head")
            or char:FindFirstChild("HumanoidRootPart")
        if hand then startPos = hand.Position end
    end
    if not startPos and cam then
        startPos = cam.CFrame.Position + (cam.CFrame.LookVector * 1.5)
    end
    if not startPos then return end

    local endPos = nil
    local mouse = LocalPlayer:GetMouse()
    if mouse and mouse.Hit then
        endPos = mouse.Hit.Position
    end
    if not endPos and cam then
        local mPos = UserInputService:GetMouseLocation()
        local ray = cam:ViewportPointToRay(mPos.X, mPos.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char}
        local res = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if res then
            endPos = res.Position
        else
            endPos = ray.Origin + (ray.Direction * 600)
        end
    end

    if endPos then
        spawnNeonTracer(startPos, endPos)
    end
end

function hookBulletTracers()
    if V.BulletTracerClickConn then V.BulletTracerClickConn:Disconnect() V.BulletTracerClickConn = nil end
    if V.BulletTracerEquipConn then V.BulletTracerEquipConn:Disconnect() V.BulletTracerEquipConn = nil end
    if V.BulletTracerToolConn then V.BulletTracerToolConn:Disconnect() V.BulletTracerToolConn = nil end

    V.BulletTracerClickConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if not V.BulletTracers then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if UserInputService:GetFocusedTextBox() then return end
            fireBulletTracer()
        end
    end)
    addConnection(V.BulletTracerClickConn)

    local function bindTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        if V.BulletTracerToolConn then V.BulletTracerToolConn:Disconnect() V.BulletTracerToolConn = nil end
        V.BulletTracerToolConn = tool.Activated:Connect(function()
            if not V.BulletTracers then return end
            fireBulletTracer()
        end)
        addConnection(V.BulletTracerToolConn)
    end

    local char = LocalPlayer.Character
    if char then
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool then bindTool(currentTool) end
        V.BulletTracerEquipConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then bindTool(child) end
        end)
        addConnection(V.BulletTracerEquipConn)
    end
end

function toggleBulletTracers(enabled)
    V.BulletTracers = enabled
    if V.BulletTracerClickConn then V.BulletTracerClickConn:Disconnect() V.BulletTracerClickConn = nil end
    if V.BulletTracerEquipConn then V.BulletTracerEquipConn:Disconnect() V.BulletTracerEquipConn = nil end
    if V.BulletTracerToolConn then V.BulletTracerToolConn:Disconnect() V.BulletTracerToolConn = nil end
    if enabled then
        hookBulletTracers()
        notify("Aim", "Bullet Tracers Néon (Violet/Cyan) ACTIVÉS", Color3.fromRGB(80, 200, 120))
    else
        notify("Aim", "Bullet Tracers Néon DÉSACTIVÉS", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleBulletTracers = toggleBulletTracers

createToggle("Bullet Tracers Néon (Violet/Cyan)", false, function(enabled)
    toggleBulletTracers(enabled)
end, AimContent, "BulletTracers")

initStep = "cablage Teleport"
pcall(function()
    TeleportContent.ScrollBarThickness = 3
    TeleportContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TeleportContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    createLabel("WAYPOINTS", TeleportContent)

    local refreshTPMiniList = nil
    local TPMiniGui = nil

    local function toggleTPMiniWindow(enabled)
        V.TPMiniWindow = enabled
        if not enabled then
            if TPMiniGui then
                pcall(function() TPMiniGui:Destroy() end)
                TPMiniGui = nil
            end
            return
        end

        if TPMiniGui then
            pcall(function() TPMiniGui:Destroy() end)
            TPMiniGui = nil
        end

        TPMiniGui = Instance.new("ScreenGui")
        TPMiniGui.Name = "PearlTPMiniGui"
        TPMiniGui.ResetOnSpawn = false
        TPMiniGui.DisplayOrder = 10005
        TPMiniGui.Parent = parentTarget

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 270, 0, 320)
        MainFrame.Position = UDim2.new(0.82, -270, 0.35, 0)
        MainFrame.BackgroundColor3 = theme.panel or Color3.fromRGB(14, 15, 22)
        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = true
        MainFrame.Active = true
        MainFrame.Parent = TPMiniGui
        makeCorner(MainFrame, 12)
        local mainStroke = makeStroke(MainFrame, theme.border or Color3.fromRGB(44, 46, 62), 1.2)

        local MainGrad = Instance.new("UIGradient")
        MainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 25, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(13, 14, 20))
        })
        MainGrad.Rotation = 45
        MainGrad.Parent = MainFrame

        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 42)
        Header.BackgroundColor3 = theme.panel2 or Color3.fromRGB(18, 19, 28)
        Header.BorderSizePixel = 0
        Header.Active = true
        Header.Parent = MainFrame
        makeCorner(Header, 12)

        local HeaderLine = Instance.new("Frame")
        HeaderLine.Size = UDim2.new(1, 0, 0, 1)
        HeaderLine.Position = UDim2.new(0, 0, 1, -1)
        HeaderLine.BackgroundColor3 = theme.border or Color3.fromRGB(44, 46, 62)
        HeaderLine.BackgroundTransparency = 0.5
        HeaderLine.BorderSizePixel = 0
        HeaderLine.Parent = Header

        local HeaderIcon = Instance.new("ImageLabel")
        HeaderIcon.Size = UDim2.new(0, 18, 0, 18)
        HeaderIcon.Position = UDim2.new(0, 10, 0.5, -9)
        HeaderIcon.BackgroundTransparency = 1
        HeaderIcon.Image = (CategoryIcons and CategoryIcons.Teleport) or "rbxassetid://7733919198"
        HeaderIcon.ImageColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
        HeaderIcon.Parent = Header

        local TitleLogo = Instance.new("TextLabel")
        TitleLogo.Size = UDim2.new(1, -75, 0, 16)
        TitleLogo.Position = UDim2.new(0, 34, 0, 6)
        TitleLogo.BackgroundTransparency = 1
        TitleLogo.Text = "PEARL"
        TitleLogo.TextColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
        TitleLogo.Font = Enum.Font.GothamBold
        TitleLogo.TextSize = 13
        TitleLogo.TextXAlignment = Enum.TextXAlignment.Left
        TitleLogo.Parent = Header

        local TitleSub = Instance.new("TextLabel")
        TitleSub.Size = UDim2.new(1, -75, 0, 12)
        TitleSub.Position = UDim2.new(0, 34, 0, 22)
        TitleSub.BackgroundTransparency = 1
        TitleSub.Text = "WAYPOINTS TP"
        TitleSub.TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)
        TitleSub.Font = Enum.Font.GothamMedium
        TitleSub.TextSize = 9
        TitleSub.TextXAlignment = Enum.TextXAlignment.Left
        TitleSub.Parent = Header

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 24, 0, 24)
        CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
        CloseBtn.BackgroundTransparency = 1
        CloseBtn.BorderSizePixel = 0
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)
        CloseBtn.Font = Enum.Font.GothamBold
        CloseBtn.TextSize = 12
        CloseBtn.Parent = Header

        CloseBtn.MouseEnter:Connect(function()
            TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = theme.danger or Color3.fromRGB(255, 80, 80)}):Play()
        end)
        CloseBtn.MouseLeave:Connect(function()
            TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)}):Play()
        end)

        CloseBtn.MouseButton1Click:Connect(function()
            if ConfigRegistry and ConfigRegistry["TPMiniWindow"] then
                ConfigRegistry["TPMiniWindow"](false)
            else
                toggleTPMiniWindow(false)
            end
        end)

        -- Smooth Dragging
        local isDragging = false
        local dragStart = nil
        local startPos = nil

        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                mainStroke.Color = theme.accent or Color3.fromRGB(145, 120, 255)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                        mainStroke.Color = theme.border or Color3.fromRGB(44, 46, 62)
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        -- Quick Save Current Position Button
        local MiniQuickAddBtn = Instance.new("TextButton")
        MiniQuickAddBtn.Size = UDim2.new(1, -16, 0, 32)
        MiniQuickAddBtn.Position = UDim2.new(0, 8, 0, 50)
        MiniQuickAddBtn.BackgroundColor3 = theme.card or Color3.fromRGB(23, 24, 35)
        MiniQuickAddBtn.BorderSizePixel = 0
        MiniQuickAddBtn.Text = "+ Sauvegarder Position Actuelle"
        MiniQuickAddBtn.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
        MiniQuickAddBtn.Font = Enum.Font.GothamMedium
        MiniQuickAddBtn.TextSize = 11
        MiniQuickAddBtn.Parent = MainFrame
        makeCorner(MiniQuickAddBtn, 8)
        local quickAddStroke = makeStroke(MiniQuickAddBtn, theme.border or Color3.fromRGB(44, 46, 62), 1)

        MiniQuickAddBtn.MouseEnter:Connect(function()
            TweenService:Create(MiniQuickAddBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47)}):Play()
            TweenService:Create(quickAddStroke, TweenInfo.new(0.15), {Color = theme.accent or Color3.fromRGB(145, 120, 255)}):Play()
        end)
        MiniQuickAddBtn.MouseLeave:Connect(function()
            TweenService:Create(MiniQuickAddBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.card or Color3.fromRGB(23, 24, 35)}):Play()
            TweenService:Create(quickAddStroke, TweenInfo.new(0.15), {Color = theme.border or Color3.fromRGB(44, 46, 62)}):Play()
        end)

        local ScrollList = Instance.new("ScrollingFrame")
        ScrollList.Name = "ScrollList"
        ScrollList.Size = UDim2.new(1, -16, 1, -92)
        ScrollList.Position = UDim2.new(0, 8, 0, 88)
        ScrollList.BackgroundTransparency = 1
        ScrollList.BorderSizePixel = 0
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        ScrollList.ScrollBarThickness = 2
        ScrollList.ScrollBarImageColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
        ScrollList.ScrollBarImageTransparency = 0.3
        ScrollList.Parent = MainFrame

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 6)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = ScrollList

        local function renderMiniList()
            if not ScrollList or not ScrollList.Parent then return end
            for _, child in pairs(ScrollList:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextLabel") then
                    child:Destroy()
                end
            end

            local count = 0
            if Pearl and Pearl.TeleportPoints then
                for wpKey, wpData in pairs(Pearl.TeleportPoints) do
                    count = count + 1
                    local itemRow = Instance.new("Frame")
                    itemRow.Size = UDim2.new(1, 0, 0, 36)
                    itemRow.BackgroundColor3 = theme.card or Color3.fromRGB(23, 24, 35)
                    itemRow.BorderSizePixel = 0
                    itemRow.Parent = ScrollList
                    makeCorner(itemRow, 8)
                    makeStroke(itemRow, theme.border or Color3.fromRGB(44, 46, 62), 1)

                    itemRow.MouseEnter:Connect(function()
                        TweenService:Create(itemRow, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47)}):Play()
                    end)
                    itemRow.MouseLeave:Connect(function()
                        TweenService:Create(itemRow, TweenInfo.new(0.15), {BackgroundColor3 = theme.card or Color3.fromRGB(23, 24, 35)}):Play()
                    end)

                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Size = UDim2.new(1, -88, 1, 0)
                    nameLbl.Position = UDim2.new(0, 10, 0, 0)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = tostring(wpData.Name or "Point")
                    nameLbl.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
                    nameLbl.Font = Enum.Font.GothamMedium
                    nameLbl.TextSize = 11
                    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                    nameLbl.Parent = itemRow

                    local tpBtn = Instance.new("TextButton")
                    tpBtn.Size = UDim2.new(0, 42, 0, 24)
                    tpBtn.Position = UDim2.new(1, -74, 0.5, -12)
                    tpBtn.BackgroundColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
                    tpBtn.BorderSizePixel = 0
                    tpBtn.Text = "TP"
                    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tpBtn.Font = Enum.Font.GothamBold
                    tpBtn.TextSize = 10
                    tpBtn.Parent = itemRow
                    makeCorner(tpBtn, 6)

                    tpBtn.MouseButton1Click:Connect(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = CFrame.new(wpData.Position)
                            notify("Teleport", "Téléporté à " .. tostring(wpData.Name), Color3.fromRGB(80, 200, 120))
                        end
                    end)

                    local delBtn = Instance.new("TextButton")
                    delBtn.Size = UDim2.new(0, 22, 0, 22)
                    delBtn.Position = UDim2.new(1, -28, 0.5, -11)
                    delBtn.BackgroundTransparency = 1
                    delBtn.BorderSizePixel = 0
                    delBtn.Text = "X"
                    delBtn.TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)
                    delBtn.Font = Enum.Font.GothamBold
                    delBtn.TextSize = 11
                    delBtn.Parent = itemRow

                    delBtn.MouseEnter:Connect(function()
                        TweenService:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = theme.danger or Color3.fromRGB(255, 80, 80)}):Play()
                    end)
                    delBtn.MouseLeave:Connect(function()
                        TweenService:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)}):Play()
                    end)

                    delBtn.MouseButton1Click:Connect(function()
                        Pearl.TeleportPoints[wpKey] = nil
                        renderMiniList()
                        if _G.PearlRefreshWaypointList then
                            pcall(_G.PearlRefreshWaypointList)
                        end
                        notify("Teleport", "Waypoint supprimé", Color3.fromRGB(255, 90, 90))
                    end)
                end
            end

            if count == 0 then
                local emptyLbl = Instance.new("TextLabel")
                emptyLbl.Size = UDim2.new(1, 0, 0, 60)
                emptyLbl.BackgroundTransparency = 1
                emptyLbl.Text = "Aucun waypoint sauvegardé.\nClique sur '+ Sauvegarder' pour en créer !"
                emptyLbl.TextColor3 = theme.sub or Color3.fromRGB(130, 134, 152)
                emptyLbl.Font = Enum.Font.GothamMedium
                emptyLbl.TextSize = 10
                emptyLbl.TextWrapped = true
                emptyLbl.Parent = ScrollList
            end
        end

        MiniQuickAddBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local count = 0
                for _ in pairs(Pearl.TeleportPoints) do count = count + 1 end
                local newName = "Point_" .. tostring(count + 1)
                Pearl.TeleportPoints[newName .. "_" .. tostring(os.clock())] = {
                    Position = char.HumanoidRootPart.Position,
                    Name = newName
                }
                renderMiniList()
                if _G.PearlRefreshWaypointList then
                    pcall(_G.PearlRefreshWaypointList)
                end
                notify("Teleport", "Point '" .. newName .. "' enregistré !", Color3.fromRGB(80, 200, 120))
            end
        end)

        refreshTPMiniList = renderMiniList
        renderMiniList()
    end

    createToggle("Mini-Interface TP Flottante (Draggable)", false, function(enabled)
        toggleTPMiniWindow(enabled)
    end, TeleportContent, "TPMiniWindow")

    -- Waypoint Creation & List in Main Teleport Tab
    local WaypointInputCard = createCard(TeleportContent, 0, 46)

    local WaypointNameBox = Instance.new("TextBox")
    WaypointNameBox.Size = UDim2.new(1, -95, 0, 30)
    WaypointNameBox.Position = UDim2.new(0, 10, 0.5, -15)
    WaypointNameBox.BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47)
    WaypointNameBox.BorderSizePixel = 0
    WaypointNameBox.PlaceholderText = "Nom du waypoint..."
    WaypointNameBox.PlaceholderColor3 = theme.sub or Color3.fromRGB(130, 134, 152)
    WaypointNameBox.Text = ""
    WaypointNameBox.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
    WaypointNameBox.Font = Enum.Font.GothamMedium
    WaypointNameBox.TextSize = 12
    WaypointNameBox.TextXAlignment = Enum.TextXAlignment.Left
    WaypointNameBox.ClearTextOnFocus = false
    WaypointNameBox.ZIndex = 9
    WaypointNameBox.Parent = WaypointInputCard
    makeCorner(WaypointNameBox, 6)
    makeStroke(WaypointNameBox, theme.border or Color3.fromRGB(44, 46, 62), 1)

    local WaypointNamePadding = Instance.new("UIPadding")
    WaypointNamePadding.PaddingLeft = UDim.new(0, 10)
    WaypointNamePadding.Parent = WaypointNameBox

    local AddWaypointBtn = Instance.new("TextButton")
    AddWaypointBtn.Size = UDim2.new(0, 75, 0, 30)
    AddWaypointBtn.Position = UDim2.new(1, -80, 0.5, -15)
    AddWaypointBtn.BackgroundColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
    AddWaypointBtn.BorderSizePixel = 0
    AddWaypointBtn.Text = "Ajouter"
    AddWaypointBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddWaypointBtn.Font = Enum.Font.GothamBold
    AddWaypointBtn.TextSize = 11
    AddWaypointBtn.ZIndex = 9
    AddWaypointBtn.Parent = WaypointInputCard
    makeCorner(AddWaypointBtn, 6)

    registerSearchCard(WaypointInputCard, "Waypoint Sauvegarder Ajouter Position", TeleportContent)

    local WaypointListContainer = Instance.new("Frame")
    WaypointListContainer.Name = "WaypointListContainer"
    WaypointListContainer.Size = UDim2.new(1, 0, 0, 0)
    WaypointListContainer.AutomaticSize = Enum.AutomaticSize.Y
    WaypointListContainer.BackgroundTransparency = 1
    WaypointListContainer.BorderSizePixel = 0
    WaypointListContainer.Parent = TeleportContent

    local WpListLayout = Instance.new("UIListLayout")
    WpListLayout.Padding = UDim.new(0, 6)
    WpListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    WpListLayout.Parent = WaypointListContainer

    local function refreshMainWaypointList()
        if not WaypointListContainer or not WaypointListContainer.Parent then return end
        for _, child in pairs(WaypointListContainer:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        local count = 0
        if Pearl and Pearl.TeleportPoints then
            for wpKey, wpData in pairs(Pearl.TeleportPoints) do
                count = count + 1
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 42)
                card.BackgroundColor3 = theme.card or Color3.fromRGB(23, 24, 35)
                card.BorderSizePixel = 0
                card.Parent = WaypointListContainer
                makeCorner(card, 8)
                makeStroke(card, theme.border or Color3.fromRGB(44, 46, 62), 1)

                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size = UDim2.new(1, -145, 1, 0)
                nameLbl.Position = UDim2.new(0, 14, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = tostring(wpData.Name or "Point")
                nameLbl.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
                nameLbl.Font = Enum.Font.GothamMedium
                nameLbl.TextSize = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
                nameLbl.Parent = card

                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(0, 65, 0, 26)
                tpBtn.Position = UDim2.new(1, -115, 0.5, -13)
                tpBtn.BackgroundColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
                tpBtn.BorderSizePixel = 0
                tpBtn.Text = "TP"
                tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 11
                tpBtn.Parent = card
                makeCorner(tpBtn, 6)

                tpBtn.MouseButton1Click:Connect(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(wpData.Position)
                        notify("Teleport", "Téléporté à " .. tostring(wpData.Name), Color3.fromRGB(80, 200, 120))
                    end
                end)

                local delBtn = Instance.new("TextButton")
                delBtn.Size = UDim2.new(0, 36, 0, 26)
                delBtn.Position = UDim2.new(1, -44, 0.5, -13)
                delBtn.BackgroundColor3 = Color3.fromRGB(45, 24, 28)
                delBtn.BorderSizePixel = 0
                delBtn.Text = "X"
                delBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
                delBtn.Font = Enum.Font.GothamBold
                delBtn.TextSize = 12
                delBtn.Parent = card
                makeCorner(delBtn, 6)
                makeStroke(delBtn, Color3.fromRGB(80, 35, 40), 1)

                delBtn.MouseButton1Click:Connect(function()
                    Pearl.TeleportPoints[wpKey] = nil
                    refreshMainWaypointList()
                    if refreshTPMiniList then pcall(refreshTPMiniList) end
                    notify("Teleport", "Waypoint supprimé", Color3.fromRGB(255, 90, 90))
                end)
            end
        end
    end
    _G.PearlRefreshWaypointList = refreshMainWaypointList

    AddWaypointBtn.MouseButton1Click:Connect(function()
        local name = WaypointNameBox.Text
        if name and name ~= "" then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                Pearl.TeleportPoints[name .. "_" .. tostring(os.clock())] = {
                    Position = char.HumanoidRootPart.Position,
                    Name = name
                }
                WaypointNameBox.Text = ""
                refreshMainWaypointList()
                if refreshTPMiniList then pcall(refreshTPMiniList) end
                notify("Teleport", "Waypoint '" .. name .. "' créé !", Color3.fromRGB(80, 200, 120))
            end
        else
            notify("Teleport", "Veuillez entrer un nom de point !", Color3.fromRGB(255, 170, 0))
        end
    end)

    refreshMainWaypointList()
end)

_G.teleportToPlayer = function(targetPlayer)
    if not targetPlayer then return end
    pcall(function()
        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local tChar = targetPlayer.Character
        if not myChar or not tChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart
        local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar.PrimaryPart
        if myRoot and tRoot then
            myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 2, 2)
            notify("Teleport", "Téléporté à " .. targetPlayer.DisplayName, Color3.fromRGB(80, 200, 120))
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
    notify("Player", "Attaché à " .. player.DisplayName, Color3.fromRGB(80, 200, 120))
end
local startAttach = _G.startAttach

_G.toggleAttach = function(player)
    if V.Attached and (V.Attached == player or player == nil) then
        stopAttach()
    else
        startAttach(player)
    end
end

_G.stopAttachBloxFruit = function()
    V.AttachedBloxFruit = nil
    if V.AttachBloxFruitConn then
        pcall(function() V.AttachBloxFruitConn:Disconnect() end)
        V.AttachBloxFruitConn = nil
    end
    if V.AttachBloxFruitNoclip then
        pcall(function() V.AttachBloxFruitNoclip:Disconnect() end)
        V.AttachBloxFruitNoclip = nil
    end
    pcall(function()
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum.PlatformStand = false
        end
    end)
    notify("Player", "Détaché (BloxFruit)", Color3.fromRGB(255, 90, 90))
end
local stopAttachBloxFruit = _G.stopAttachBloxFruit

_G.startAttachBloxFruit = function(targetPlayer)
    if not targetPlayer then return end
    if V.AttachedBloxFruit then
        stopAttachBloxFruit()
    end
    if V.Attached then
        if _G.stopAttach then _G.stopAttach() elseif stopAttach then stopAttach() end
    end

    V.AttachedBloxFruit = targetPlayer

    V.AttachBloxFruitNoclip = RunService.Stepped:Connect(function()
        if not V.AttachedBloxFruit then
            if V.AttachBloxFruitNoclip then
                pcall(function() V.AttachBloxFruitNoclip:Disconnect() end)
                V.AttachBloxFruitNoclip = nil
            end
            return
        end
        local myChar = LocalPlayer.Character
        if myChar then
            for _, part in ipairs(myChar:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    addConnection(V.AttachBloxFruitNoclip)

    V.AttachBloxFruitConn = RunService.Heartbeat:Connect(function(dt)
        pcall(function()
            if not V.AttachedBloxFruit or not V.AttachedBloxFruit.Parent then
                stopAttachBloxFruit()
                return
            end
            local myChar = LocalPlayer.Character
            local tChar = V.AttachedBloxFruit.Character
            if not myChar or not tChar then return end

            local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart
            local myHum = myChar:FindFirstChildOfClass("Humanoid")
            local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar.PrimaryPart
            local tHum = tChar:FindFirstChildOfClass("Humanoid")

            if not myRoot or not tRoot or (tHum and tHum.Health <= 0) then
                stopAttachBloxFruit()
                return
            end

            if myHum then
                myHum.PlatformStand = true
            end

            local targetCF = tRoot.CFrame * CFrame.new(0, 3, 2)
            local targetPos = targetCF.Position
            local diff = targetPos - myRoot.Position
            local dist = diff.Magnitude
            local flySpeed = 230

            if dist > 3 then
                local step = math.min(flySpeed * dt, dist)
                local dir = diff.Unit
                local newPos = myRoot.Position + dir * step
                myRoot.CFrame = CFrame.new(newPos, targetPos)
            else
                myRoot.CFrame = targetCF
            end

            if myRoot:IsA("BasePart") then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end)
    addConnection(V.AttachBloxFruitConn)

    notify("Player", "Glisse (230) vers " .. targetPlayer.DisplayName .. "...", Color3.fromRGB(175, 110, 255))
end
local startAttachBloxFruit = _G.startAttachBloxFruit



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
        warn("[Pearl] Erreur WarpCar: " .. tostring(err))
        notify("Player", "Erreur lors du TP Voiture !", Color3.fromRGB(255, 90, 90))
    end
end
local warpToPlayerCar = _G.warpToPlayerCar

_G.carjackPlayer = function(targetPlayer)
    local success, err = pcall(function()
        if not targetPlayer then
            notify("Carjack", "Joueur introuvable !", Color3.fromRGB(255, 90, 90))
            return
        end
        if targetPlayer == LocalPlayer then
            notify("Carjack", "Tu ne peux pas voler ton propre véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end

        local tChar = targetPlayer.Character
        if not tChar then
            notify("Carjack", targetPlayer.DisplayName .. " n'a pas de personnage !", Color3.fromRGB(255, 165, 0))
            return
        end

        local tHum = tChar:FindFirstChildOfClass("Humanoid")
        local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso")
        if not tHum or not tRoot then
            notify("Carjack", "Personnage de " .. targetPlayer.DisplayName .. " incomplet !", Color3.fromRGB(255, 165, 0))
            return
        end

        -- Rechercher le siège conducteur ou siège occupé par la cible (VehicleSeat ou Seat)
        local tSeat = tHum.SeatPart
        if not tSeat then
            for _, child in ipairs(tChar:GetDescendants()) do
                if child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("Snap") then
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
                    elseif (obj.Position - tRoot.Position).Magnitude < 6 then
                        tSeat = obj
                        break
                    end
                end
            end
        end

        if not tSeat then
            notify("Carjack", targetPlayer.DisplayName .. " n'est pas dans un véhicule ou bateau !", Color3.fromRGB(255, 165, 0))
            return
        end

        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHum or not myHrp then
            notify("Carjack", "Ton personnage est incomplet !", Color3.fromRGB(255, 90, 90))
            return
        end

        notify("Carjack", "Éjection de " .. targetPlayer.DisplayName .. " et prise des commandes...", Color3.fromRGB(175, 110, 255))

        -- 1. Détruire toutes les soudures (SeatWeld) reliant la cible au siège
        for _, child in ipairs(tSeat:GetChildren()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("Snap") or child.Name == "SeatWeld" then
                pcall(function() child:Destroy() end)
            end
        end
        for _, child in ipairs(tChar:GetDescendants()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("Snap") then
                if child.Name == "SeatWeld" or child.Part0 == tSeat or child.Part1 == tSeat then
                    pcall(function() child:Destroy() end)
                end
            end
        end

        -- 2. Éjecter de force la cible du siège (désactivation Sit + impulsion pour le faire tomber)
        pcall(function()
            tHum.Sit = false
            tHum.PlatformStand = true
            tRoot.CFrame = tSeat.CFrame * CFrame.new(0, 7, -6)
            tRoot.AssemblyLinearVelocity = (tSeat.CFrame.LookVector * -35) + Vector3.new(0, 30, 0)
        end)
        task.delay(0.6, function()
            pcall(function() tHum.PlatformStand = false end)
        end)

        -- 3. Désasseoir le joueur local s'il était assis
        if myHum.Sit then
            myHum.Sit = false
            task.wait(0.04)
        end

        -- 4. TP instantané et s'asseoir directement à la place du conducteur
        myHrp.CFrame = tSeat.CFrame * CFrame.new(0, 1.2, 0)
        task.wait(0.02)
        pcall(function() tSeat:Sit(myHum) end)
        task.wait(0.05)

        if myHum.SeatPart ~= tSeat then
            if _G.sitInSeat then
                _G.sitInSeat(myHum, myHrp, tSeat)
            else
                pcall(function() tSeat:Sit(myHum) end)
            end
        end

        -- 5. Prendre le contrôle physique et démarrer le véhicule / bateau
        pcall(function()
            if tSeat:IsA("VehicleSeat") then
                tSeat.Throttle = 1
            end
            local vehModel = tSeat:FindFirstAncestorWhichIsA("Model") or tSeat.Parent
            local primary = vehModel and (vehModel.PrimaryPart or vehModel:FindFirstChild("HumanoidRootPart") or tSeat) or tSeat
            if primary and primary:IsA("BasePart") then
                primary.AssemblyLinearVelocity = tSeat.CFrame.LookVector * 55 + Vector3.new(0, 2, 0)
            end
        end)

        notify("Carjack", "Véhicule / Bateau volé à " .. targetPlayer.DisplayName .. " !", Color3.fromRGB(80, 200, 120))
    end)

    if not success then
        warn("[Pearl] Erreur Carjack: " .. tostring(err))
        notify("Carjack", "Erreur lors du carjack !", Color3.fromRGB(255, 90, 90))
    end
end
local carjackPlayer = _G.carjackPlayer


do
-- ============================================================================
-- ONGLET JOUEUR : DESIGN MODERNE, CARD-BASED, SANS EMOJIS & COULEURS BLANC/GRIS
-- ============================================================================
JoueurContent.ScrollBarThickness = 0
JoueurContent.ScrollBarImageTransparency = 1
JoueurContent.VerticalScrollBarInset = Enum.ScrollBarInset.None
JoueurContent.ScrollingEnabled = false
JoueurContent.CanvasSize = UDim2.new(0, 0, 0, 0)
JoueurContent.AutomaticCanvasSize = Enum.AutomaticSize.None
JoueurContent.ClipsDescendants = true

local existingLayout = JoueurContent:FindFirstChildOfClass("UIListLayout")
if existingLayout then existingLayout:Destroy() end
local existingPad = JoueurContent:FindFirstChildOfClass("UIPadding")
if existingPad then existingPad:Destroy() end

local PlayerTabRoot = Instance.new("Frame")
PlayerTabRoot.Name = "PlayerTabRoot"
PlayerTabRoot.Size = UDim2.new(1, 0, 1, 0)
PlayerTabRoot.BackgroundTransparency = 1
PlayerTabRoot.BorderSizePixel = 0
PlayerTabRoot.ClipsDescendants = true
PlayerTabRoot.Parent = JoueurContent

local rootPad = Instance.new("UIPadding")
rootPad.PaddingTop = UDim.new(0, 8)
rootPad.PaddingBottom = UDim.new(0, 10)
rootPad.PaddingLeft = UDim.new(0, 12)
rootPad.PaddingRight = UDim.new(0, 12)
rootPad.Parent = PlayerTabRoot

-- Colonne Gauche (Player List) : 50% - 7px
local LeftCol = Instance.new("Frame")
LeftCol.Name = "LeftCol"
LeftCol.Size = UDim2.new(0.5, -7, 1, 0)
LeftCol.Position = UDim2.new(0, 0, 0, 0)
LeftCol.BackgroundTransparency = 1
LeftCol.BorderSizePixel = 0
LeftCol.ClipsDescendants = true
LeftCol.Parent = PlayerTabRoot

-- Header Player List avec compteur
local LeftHeader = Instance.new("Frame")
LeftHeader.Name = "LeftHeader"
LeftHeader.Size = UDim2.new(1, -12, 0, 24)
LeftHeader.Position = UDim2.new(0, 4, 0, 0)
LeftHeader.BackgroundTransparency = 1
LeftHeader.Parent = LeftCol

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Name = "LeftTitle"
LeftTitle.Size = UDim2.new(0.65, 0, 1, 0)
LeftTitle.Position = UDim2.new(0, 0, 0, 0)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Text = "Player List"
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 14
LeftTitle.TextXAlignment = Enum.TextXAlignment.Left
LeftTitle.Parent = LeftHeader

local PlayerCountBadge = Instance.new("TextLabel")
PlayerCountBadge.Name = "PlayerCountBadge"
PlayerCountBadge.Size = UDim2.new(0, 75, 0, 20)
PlayerCountBadge.Position = UDim2.new(1, -75, 0.5, -10)
PlayerCountBadge.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
PlayerCountBadge.Text = "0 joueurs"
PlayerCountBadge.TextColor3 = Color3.fromRGB(215, 215, 230)
PlayerCountBadge.Font = Enum.Font.GothamBold
PlayerCountBadge.TextSize = 10
PlayerCountBadge.Parent = LeftHeader
makeCorner(PlayerCountBadge, 10)
makeStroke(PlayerCountBadge, Color3.fromRGB(50, 50, 68), 1)

-- Boîte de recherche moderne sans emoji
local FilterContainer = Instance.new("Frame")
FilterContainer.Name = "FilterContainer"
FilterContainer.Size = UDim2.new(1, -12, 0, 32)
FilterContainer.Position = UDim2.new(0, 4, 0, 28)
FilterContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FilterContainer.BorderSizePixel = 0
FilterContainer.Parent = LeftCol
makeCorner(FilterContainer, 8)
local filterStroke = makeStroke(FilterContainer, Color3.fromRGB(34, 34, 48), 1)

local FilterBox = Instance.new("TextBox")
FilterBox.Name = "FilterBox"
FilterBox.Size = UDim2.new(1, -20, 1, 0)
FilterBox.Position = UDim2.new(0, 10, 0, 0)
FilterBox.BackgroundTransparency = 1
FilterBox.PlaceholderText = "Filtrer un joueur ou ID..."
FilterBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 130)
FilterBox.Text = ""
FilterBox.TextColor3 = Color3.fromRGB(240, 240, 250)
FilterBox.Font = Enum.Font.GothamMedium
FilterBox.TextSize = 11
FilterBox.TextXAlignment = Enum.TextXAlignment.Left
FilterBox.ClearTextOnFocus = false
FilterBox.Parent = FilterContainer

FilterBox.Focused:Connect(function()
    filterStroke.Color = Color3.fromRGB(140, 75, 255)
end)
FilterBox.FocusLost:Connect(function()
    filterStroke.Color = Color3.fromRGB(34, 34, 48)
end)

-- Liste scrollable des joueurs parfaitement alignée
local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Name = "PlayerListScroll"
PlayerListScroll.Size = UDim2.new(1, 0, 1, -66)
PlayerListScroll.Position = UDim2.new(0, 0, 0, 66)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScroll.ScrollBarThickness = 3
PlayerListScroll.ScrollBarImageColor3 = Color3.fromRGB(140, 75, 255)
PlayerListScroll.ScrollBarImageTransparency = 0.2
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ClipsDescendants = true
PlayerListScroll.Parent = LeftCol

local PlayerListPad = Instance.new("UIPadding")
PlayerListPad.PaddingLeft = UDim.new(0, 4)
PlayerListPad.PaddingRight = UDim.new(0, 8)
PlayerListPad.PaddingTop = UDim.new(0, 4)
PlayerListPad.PaddingBottom = UDim.new(0, 14)
PlayerListPad.Parent = PlayerListScroll

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Parent = PlayerListScroll

PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 16)
end)

-- Ligne de séparation centrale
local CenterDivider = Instance.new("Frame")
CenterDivider.Name = "CenterDivider"
CenterDivider.Size = UDim2.new(0, 1, 1, -12)
CenterDivider.Position = UDim2.new(0.5, 0, 0, 6)
CenterDivider.BackgroundColor3 = Color3.fromRGB(32, 32, 46)
CenterDivider.BorderSizePixel = 0
CenterDivider.Parent = PlayerTabRoot

-- Colonne Droite (Actions Joueur) : 50% - 7px
local RightCol = Instance.new("Frame")
RightCol.Name = "RightCol"
RightCol.Size = UDim2.new(0.5, -7, 1, 0)
RightCol.Position = UDim2.new(0.5, 7, 0, 0)
RightCol.BackgroundTransparency = 1
RightCol.BorderSizePixel = 0
RightCol.ClipsDescendants = true
RightCol.Parent = PlayerTabRoot

local RightTitle = Instance.new("TextLabel")
RightTitle.Name = "RightTitle"
RightTitle.Size = UDim2.new(1, -12, 0, 24)
RightTitle.Position = UDim2.new(0, 4, 0, 0)
RightTitle.BackgroundTransparency = 1
RightTitle.Text = "Actions Joueur"
RightTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RightTitle.Font = Enum.Font.GothamBold
RightTitle.TextSize = 14
RightTitle.TextXAlignment = Enum.TextXAlignment.Left
RightTitle.Parent = RightCol

-- Carte Profil de la Cible (Target Card) - Palette Blanc & Gris
local TargetCard = Instance.new("Frame")
TargetCard.Name = "TargetCard"
TargetCard.Size = UDim2.new(1, -12, 0, 48)
TargetCard.Position = UDim2.new(0, 4, 0, 28)
TargetCard.BackgroundColor3 = Color3.fromRGB(16, 15, 26)
TargetCard.BorderSizePixel = 0
TargetCard.ClipsDescendants = true
TargetCard.Parent = RightCol
makeCorner(TargetCard, 8)
local targetCardStroke = makeStroke(TargetCard, Color3.fromRGB(48, 38, 74), 1)

local TargetAvatar = Instance.new("ImageLabel")
TargetAvatar.Name = "TargetAvatar"
TargetAvatar.Size = UDim2.new(0, 34, 0, 34)
TargetAvatar.Position = UDim2.new(0, 8, 0.5, -17)
TargetAvatar.BackgroundColor3 = Color3.fromRGB(24, 22, 34)
TargetAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=100&h=100"
TargetAvatar.BorderSizePixel = 0
TargetAvatar.Parent = TargetCard
makeCorner(TargetAvatar, 17)
makeStroke(TargetAvatar, Color3.fromRGB(140, 75, 255), 1)

local TargetHeaderLbl = Instance.new("TextLabel")
TargetHeaderLbl.Name = "TargetHeaderLbl"
TargetHeaderLbl.Size = UDim2.new(1, -95, 0, 14)
TargetHeaderLbl.Position = UDim2.new(0, 48, 0, 7)
TargetHeaderLbl.BackgroundTransparency = 1
TargetHeaderLbl.Text = "CIBLE ACTIVE (VOUS)"
TargetHeaderLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetHeaderLbl.Font = Enum.Font.GothamBold
TargetHeaderLbl.TextSize = 9
TargetHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetHeaderLbl.Parent = TargetCard

local TargetNameLbl = Instance.new("TextLabel")
TargetNameLbl.Name = "TargetNameLbl"
TargetNameLbl.Size = UDim2.new(1, -95, 0, 18)
TargetNameLbl.Position = UDim2.new(0, 48, 0, 22)
TargetNameLbl.BackgroundTransparency = 1
TargetNameLbl.Text = "Aucun joueur"
TargetNameLbl.TextColor3 = Color3.fromRGB(245, 245, 255)
TargetNameLbl.Font = Enum.Font.GothamBold
TargetNameLbl.TextSize = 12
TargetNameLbl.TextXAlignment = Enum.TextXAlignment.Left
TargetNameLbl.TextTruncate = Enum.TextTruncate.AtEnd
TargetNameLbl.Parent = TargetCard

local TargetStatusPill = Instance.new("TextLabel")
TargetStatusPill.Name = "TargetStatusPill"
TargetStatusPill.Size = UDim2.new(0, 46, 0, 18)
TargetStatusPill.Position = UDim2.new(1, -52, 0.5, -9)
TargetStatusPill.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TargetStatusPill.Text = "Moi"
TargetStatusPill.TextColor3 = Color3.fromRGB(240, 240, 250)
TargetStatusPill.Font = Enum.Font.GothamBold
TargetStatusPill.TextSize = 9
TargetStatusPill.Parent = TargetCard
makeCorner(TargetStatusPill, 9)
local statusStroke = makeStroke(TargetStatusPill, Color3.fromRGB(60, 60, 78), 1)

-- Conteneur d'actions avec boutons calibrés
local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Size = UDim2.new(1, 0, 1, -82)
SettingsContainer.Position = UDim2.new(0, 0, 0, 82)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.BorderSizePixel = 0
SettingsContainer.ScrollBarThickness = 3
SettingsContainer.ScrollBarImageColor3 = Color3.fromRGB(140, 75, 255)
SettingsContainer.ScrollBarImageTransparency = 0.2
SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsContainer.ClipsDescendants = true
SettingsContainer.Parent = RightCol

local SettingsPad = Instance.new("UIPadding")
SettingsPad.PaddingLeft = UDim.new(0, 4)
SettingsPad.PaddingRight = UDim.new(0, 8)
SettingsPad.PaddingTop = UDim.new(0, 4)
SettingsPad.PaddingBottom = UDim.new(0, 14)
SettingsPad.Parent = SettingsContainer

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 6)
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Parent = SettingsContainer

SettingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, SettingsLayout.AbsoluteContentSize.Y + 16)
end)

local selectedPlayer = V.SelectedJoueurPlayer or LocalPlayer
local actionRefreshers = {}
local playerRowsByPlayer = {}

local function updateTargetIndicator()
    if selectedPlayer and selectedPlayer.Parent then
        local isMe = (selectedPlayer == LocalPlayer)
        TargetAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(selectedPlayer.UserId) .. "&w=100&h=100"
        TargetNameLbl.Text = selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")"
        if isMe then
            TargetHeaderLbl.Text = "CIBLE ACTIVE (VOUS)"
            TargetHeaderLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            TargetStatusPill.Text = "Moi"
            TargetStatusPill.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            TargetStatusPill.TextColor3 = Color3.fromRGB(245, 245, 255)
            statusStroke.Color = Color3.fromRGB(65, 65, 85)
        else
            TargetHeaderLbl.Text = "CIBLE SÉLECTIONNÉE"
            TargetHeaderLbl.TextColor3 = Color3.fromRGB(185, 185, 200)
            TargetStatusPill.Text = "En jeu"
            TargetStatusPill.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
            TargetStatusPill.TextColor3 = Color3.fromRGB(210, 210, 225)
            statusStroke.Color = Color3.fromRGB(50, 50, 68)
        end
    else
        TargetAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=1&w=100&h=100"
        TargetHeaderLbl.Text = "AUCUNE CIBLE"
        TargetHeaderLbl.TextColor3 = Color3.fromRGB(140, 140, 160)
        TargetNameLbl.Text = "Sélectionnez un joueur"
        TargetStatusPill.Text = "Aucun"
        TargetStatusPill.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        TargetStatusPill.TextColor3 = Color3.fromRGB(150, 150, 165)
        statusStroke.Color = Color3.fromRGB(45, 45, 60)
    end
end

local function refreshAllActions()
    for _, ref in ipairs(actionRefreshers) do
        pcall(ref)
    end
end

local function updateSelectionHighlight()
    for p, rowData in pairs(playerRowsByPlayer) do
        if rowData.btn and rowData.btn.Parent then
            local isSel = (p == selectedPlayer)
            if isSel then
                rowData.btn.BackgroundColor3 = Color3.fromRGB(44, 22, 72)
                rowData.stroke.Color = Color3.fromRGB(150, 85, 255)
                rowData.dispLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                rowData.userLbl.TextColor3 = Color3.fromRGB(195, 175, 240)
            else
                rowData.btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                rowData.stroke.Color = Color3.fromRGB(32, 32, 46)
                rowData.dispLbl.TextColor3 = Color3.fromRGB(240, 240, 250)
                rowData.userLbl.TextColor3 = Color3.fromRGB(135, 135, 155)
            end
        end
    end
end

local function updatePlayerCount()
    local total = #Players:GetPlayers()
    PlayerCountBadge.Text = tostring(total) .. " joueur" .. (total > 1 and "s" or "")
end

local function createPlayerRow(p)
    if not p or playerRowsByPlayer[p] then return end

    local isMe = (p == LocalPlayer)
    local isSel = (p == selectedPlayer)

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -12, 0, 40) -- Bonne taille calibrée
    row.BackgroundColor3 = isSel and Color3.fromRGB(44, 22, 72) or Color3.fromRGB(18, 18, 26)
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.ClipsDescendants = true
    row.LayoutOrder = isMe and 0 or 1
    row.Parent = PlayerListScroll
    makeCorner(row, 8)
    local rowStroke = makeStroke(row, isSel and Color3.fromRGB(150, 85, 255) or Color3.fromRGB(32, 32, 46), 1)

    -- Avatar du joueur
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 28, 0, 28)
    avatar.Position = UDim2.new(0, 6, 0.5, -14)
    avatar.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p.UserId) .. "&w=100&h=100"
    avatar.BorderSizePixel = 0
    avatar.Parent = row
    makeCorner(avatar, 14)
    makeStroke(avatar, Color3.fromRGB(48, 48, 68), 1)

    -- Nom d'affichage (Blanc)
    local dispLabel = Instance.new("TextLabel")
    dispLabel.Name = "DisplayName"
    dispLabel.Size = UDim2.new(1, -96, 0, 16)
    dispLabel.Position = UDim2.new(0, 42, 0, 4)
    dispLabel.BackgroundTransparency = 1
    dispLabel.Text = p.DisplayName
    dispLabel.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(240, 240, 250)
    dispLabel.Font = Enum.Font.GothamBold
    dispLabel.TextSize = 11
    dispLabel.TextXAlignment = Enum.TextXAlignment.Left
    dispLabel.TextTruncate = Enum.TextTruncate.AtEnd
    dispLabel.Parent = row

    -- Username (@Name) (Gris)
    local userLabel = Instance.new("TextLabel")
    userLabel.Name = "Username"
    userLabel.Size = UDim2.new(1, -96, 0, 14)
    userLabel.Position = UDim2.new(0, 42, 0, 20)
    userLabel.BackgroundTransparency = 1
    userLabel.Text = "@" .. p.Name
    userLabel.TextColor3 = isSel and Color3.fromRGB(195, 175, 240) or Color3.fromRGB(140, 140, 160)
    userLabel.Font = Enum.Font.GothamMedium
    userLabel.TextSize = 10
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.TextTruncate = Enum.TextTruncate.AtEnd
    userLabel.Parent = row

    -- Badge "MOI" sobre (Blanc et Gris)
    if isMe then
        local meBadge = Instance.new("TextLabel")
        meBadge.Name = "MeBadge"
        meBadge.Size = UDim2.new(0, 36, 0, 18)
        meBadge.Position = UDim2.new(1, -44, 0.5, -9)
        meBadge.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        meBadge.Text = "MOI"
        meBadge.TextColor3 = Color3.fromRGB(240, 240, 250)
        meBadge.Font = Enum.Font.GothamBold
        meBadge.TextSize = 9
        meBadge.Parent = row
        makeCorner(meBadge, 6)
        makeStroke(meBadge, Color3.fromRGB(58, 58, 76), 1)
    end

    local searchKey = string.lower(p.Name .. " " .. p.DisplayName .. " " .. tostring(p.UserId))

    row.MouseEnter:Connect(function()
        if selectedPlayer ~= p then
            row.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
            rowStroke.Color = Color3.fromRGB(48, 48, 68)
        end
    end)

    row.MouseLeave:Connect(function()
        if selectedPlayer ~= p then
            row.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            rowStroke.Color = Color3.fromRGB(32, 32, 46)
        end
    end)

    row.MouseButton1Click:Connect(function()
        playClick()
        selectedPlayer = p
        V.SelectedJoueurPlayer = p
        _G.SelectedJoueurPlayer = p
        updateTargetIndicator()
        updateSelectionHighlight()
        refreshAllActions()
    end)

    playerRowsByPlayer[p] = {btn = row, stroke = rowStroke, dispLbl = dispLabel, userLbl = userLabel, searchKey = searchKey}
end

local function removePlayerRow(p)
    local data = playerRowsByPlayer[p]
    if data then
        if data.btn and data.btn.Parent then
            data.btn:Destroy()
        end
        playerRowsByPlayer[p] = nil
    end
    if selectedPlayer == p then
        selectedPlayer = LocalPlayer
        V.SelectedJoueurPlayer = LocalPlayer
        _G.SelectedJoueurPlayer = LocalPlayer
        updateTargetIndicator()
        updateSelectionHighlight()
        refreshAllActions()
    end
    updatePlayerCount()
end

local function applyFilter()
    local q = string.lower(FilterBox.Text or ""):match("^%s*(.-)%s*$")
    for _, data in pairs(playerRowsByPlayer) do
        if data.btn and data.btn.Parent then
            if q == "" or string.find(data.searchKey, q, 1, true) then
                data.btn.Visible = true
            else
                data.btn.Visible = false
            end
        end
    end
end

-- Remplissage initial
for _, p in ipairs(Players:GetPlayers()) do
    createPlayerRow(p)
end
if not selectedPlayer or not selectedPlayer.Parent then
    selectedPlayer = LocalPlayer
    V.SelectedJoueurPlayer = LocalPlayer
    _G.SelectedJoueurPlayer = LocalPlayer
end
updatePlayerCount()
updateTargetIndicator()
updateSelectionHighlight()

FilterBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)

Players.PlayerAdded:Connect(function(p)
    createPlayerRow(p)
    applyFilter()
    updateSelectionHighlight()
    updatePlayerCount()
end)

Players.PlayerRemoving:Connect(function(p)
    removePlayerRow(p)
end)

-- Creation des boutons d'action de bonne taille sans emojis
local function createActionButton(btnTitle, callback, checkActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 35) -- Bonne taille proportionnee et elegante
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    btn.BorderSizePixel = 0
    btn.Text = btnTitle
    btn.TextColor3 = Color3.fromRGB(235, 235, 245)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.RichText = true
    btn.AutoButtonColor = false
    btn.Parent = SettingsContainer
    makeCorner(btn, 8)
    local stroke = makeStroke(btn, Color3.fromRGB(34, 34, 48), 1)

    local function refreshState()
        local active = false
        if checkActive then
            pcall(function()
                active = checkActive(btn)
            end)
        end
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(56, 18, 30)
            btn.TextColor3 = Color3.fromRGB(255, 95, 115)
            stroke.Color = Color3.fromRGB(215, 48, 64)
        else
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            btn.TextColor3 = Color3.fromRGB(235, 235, 245)
            stroke.Color = Color3.fromRGB(34, 34, 48)
        end
    end

    table.insert(actionRefreshers, refreshState)

    btn.MouseEnter:Connect(function()
        local active = false
        if checkActive then pcall(function() active = checkActive(btn) end) end
        if not active then
            btn.BackgroundColor3 = Color3.fromRGB(26, 26, 38)
            stroke.Color = Color3.fromRGB(52, 50, 72)
        end
    end)

    btn.MouseLeave:Connect(function()
        local active = false
        if checkActive then pcall(function() active = checkActive(btn) end) end
        if not active then
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            stroke.Color = Color3.fromRGB(34, 34, 48)
        end
    end)

    btn.MouseButton1Down:Connect(function()
        local active = false
        if checkActive then pcall(function() active = checkActive(btn) end) end
        if not active then
            btn.BackgroundColor3 = Color3.fromRGB(42, 24, 68)
            stroke.Color = Color3.fromRGB(150, 85, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    btn.MouseButton1Up:Connect(function()
        task.wait(0.08)
        refreshState()
    end)

    btn.MouseButton1Click:Connect(function()
        playClick()
        if not selectedPlayer or not selectedPlayer.Parent then
            notify("Player", "Veuillez sélectionner un joueur à gauche !", Color3.fromRGB(255, 165, 0))
            return
        end
        callback(btn)
        refreshState()
    end)

    refreshState()
    return btn
end

-- 1. Teleport
createActionButton("Teleport", function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Teleport", "Vous êtes déjà sur vous-même !", Color3.fromRGB(255, 165, 0))
        return
    end
    if _G.teleportToPlayer then
        _G.teleportToPlayer(selectedPlayer)
    elseif teleportToPlayer then
        teleportToPlayer(selectedPlayer)
    end
end)

-- 1b. TP Bypass AC (Interpolation Lineaire)
createActionButton('TP (<font color="rgb(175,110,255)">Bypass AC</font>)', function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Teleport", "Vous êtes déjà sur vous-même !", Color3.fromRGB(255, 165, 0))
        return
    end
    local myChar = LocalPlayer.Character
    local tChar = selectedPlayer and selectedPlayer.Character
    if not myChar or not tChar then
        notify("Teleport", "Personnage introuvable !", Color3.fromRGB(255, 90, 90))
        return
    end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart
    local tRoot = tChar:FindFirstChild("HumanoidRootPart") or tChar.PrimaryPart
    if not myRoot or not tRoot then
        notify("Teleport", "HumanoidRootPart introuvable !", Color3.fromRGB(255, 90, 90))
        return
    end
    task.spawn(function()
        local startPos = myRoot.Position
        local endPos = tRoot.Position + Vector3.new(0, 2, 2)
        local totalDist = (endPos - startPos).Magnitude
        local stepSize = 15
        local steps = math.ceil(totalDist / stepSize)
        if steps < 1 then steps = 1 end
        notify("Teleport", "TP Bypass AC en cours... (" .. steps .. " micro-sauts)", Color3.fromRGB(80, 200, 120))
        for i = 1, steps do
            local alpha = i / steps
            local interpPos = startPos:Lerp(endPos, alpha)
            pcall(function()
                myRoot.CFrame = CFrame.new(interpPos) * (myRoot.CFrame - myRoot.CFrame.Position)
            end)
            local hb = game:GetService("RunService").Heartbeat
            hb:Wait()
            hb:Wait()
        end
        notify("Teleport", "TP Bypass AC terminé vers " .. selectedPlayer.DisplayName, Color3.fromRGB(80, 200, 120))
    end)
end)

-- 2. Spectate
createActionButton("Spectate", function(btn)
    if selectedPlayer == LocalPlayer then
        stopSpectate()
        return
    end
    if V.Spectate and V.SelPlayer == selectedPlayer then
        stopSpectate()
    else
        if V.Spectate then stopSpectate() end
        startSpectate(selectedPlayer)
    end
end, function(btn)
    local active = (V.Spectate and V.SelPlayer == selectedPlayer)
    btn.Text = active and "Stop Spectate" or "Spectate"
    return active
end)

-- 3. Attach
createActionButton("Attach", function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Attach", "Impossible de s'attacher à soi-même !", Color3.fromRGB(255, 165, 0))
        return
    end
    if V.Attached == selectedPlayer then
        if _G.stopAttach then _G.stopAttach() elseif stopAttach then stopAttach() end
    else
        if _G.startAttach then _G.startAttach(selectedPlayer) elseif startAttach then startAttach(selectedPlayer) end
    end
end, function(btn)
    local active = (V.Attached == selectedPlayer)
    btn.Text = active and "Detach" or "Attach"
    return active
end)

-- 4. Attach Player (BloxFruit)
createActionButton('attach player (<font color="rgb(175,110,255)">bloxfruit</font>)', function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Attach", "Impossible de s'attacher à soi-même !", Color3.fromRGB(255, 165, 0))
        return
    end
    if V.AttachedBloxFruit == selectedPlayer then
        if _G.stopAttachBloxFruit then _G.stopAttachBloxFruit() elseif stopAttachBloxFruit then stopAttachBloxFruit() end
    else
        if _G.startAttachBloxFruit then _G.startAttachBloxFruit(selectedPlayer) elseif startAttachBloxFruit then startAttachBloxFruit(selectedPlayer) end
    end
end, function(btn)
    local active = (V.AttachedBloxFruit == selectedPlayer)
    btn.Text = active and 'Stop attach (<font color="rgb(175,110,255)">bloxfruit</font>)' or 'attach player (<font color="rgb(175,110,255)">bloxfruit</font>)'
    return active
end)

-- 5. WarpCar
createActionButton("WarpCar", function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Player", "Vous êtes déjà dans votre session !", Color3.fromRGB(255, 165, 0))
        return
    end
    if _G.warpToPlayerCar then
        _G.warpToPlayerCar(selectedPlayer)
    elseif warpToPlayerCar then
        warpToPlayerCar(selectedPlayer)
    end
end)

-- 6. Fling
createActionButton("Fling", function(btn)
    if selectedPlayer == LocalPlayer then
        notify("Fling", "Impossible de fling son propre personnage !", Color3.fromRGB(255, 165, 0))
        return
    end
    if V.Flinging and V.FlingTarget == selectedPlayer then
        stopFling()
    else
        if V.Flinging then stopFling() end
        startFling(selectedPlayer)
    end
end, function(btn)
    local active = (V.Flinging and V.FlingTarget == selectedPlayer)
    btn.Text = active and "Stop Fling" or "Fling"
    return active
end)

_G.refreshPlayerList = function()
    for _, p in ipairs(Players:GetPlayers()) do
        createPlayerRow(p)
    end
    applyFilter()
    updateSelectionHighlight()
    updatePlayerCount()
end
end


createLabel("SERVER ACTIONS & VISUALS", ServerContent)

local PEARL_SKY_B64 = "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"
local PEARL_LOGO_SKY_B64 = "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"

local function decodePearlBase64(data)
    local fn = (crypt and crypt.base64decode) or (syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.decode) or (base64 and base64.decode) or base64decode
    if fn then
        local ok, res = pcall(fn, data)
        if ok and type(res) == "string" and #res > 100 then
            return res
        end
    end
    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #b64chars do
        lookup[b64chars:byte(i)] = i - 1
    end
    local out = {}
    local len = #data
    local i = 1
    while i <= len do
        local c1 = lookup[data:byte(i)] or 0
        local c2 = lookup[data:byte(i + 1)] or 0
        local b3 = data:byte(i + 2)
        local b4 = data:byte(i + 3)
        local c3 = lookup[b3] or 0
        local c4 = lookup[b4] or 0
        local n = bit32.bor(bit32.lshift(c1, 18), bit32.lshift(c2, 12), bit32.lshift(c3, 6), c4)
        out[#out + 1] = string.char(bit32.band(bit32.rshift(n, 16), 255))
        if b3 and b3 ~= 61 then
            out[#out + 1] = string.char(bit32.band(bit32.rshift(n, 8), 255))
        end
        if b4 and b4 ~= 61 then
            out[#out + 1] = string.char(bit32.band(n, 255))
        end
        i = i + 4
    end
    return table.concat(out)
end

local function loadCachedAssetFromB64(fname, b64Data, fallbackUri)
    local assetFn = getcustomasset or getsynasset
    if writefile and assetFn then
        local exists = isfile and isfile(fname)
        if not exists then
            local okDec, decoded = pcall(decodePearlBase64, b64Data)
            if okDec and type(decoded) == "string" and #decoded > 100 then
                pcall(writefile, fname, decoded)
            end
        end
        if not isfile or isfile(fname) then
            local okUri, uri = pcall(assetFn, fname)
            if okUri and uri then
                return uri
            end
        end
    end
    return fallbackUri
end

local function getPearlCustomSkyUri()
    if _G._PearlCustomSkyUri then return _G._PearlCustomSkyUri end
    local uri = loadCachedAssetFromB64("pearl_custom_sky_v2.png", PEARL_SKY_B64, "rbxassetid://159454299")
    _G._PearlCustomSkyUri = uri
    return uri
end

local function getPearlSingleLogoSkyUri()
    if _G._PearlSingleLogoSkyUri then return _G._PearlSingleLogoSkyUri end
    local uri = loadCachedAssetFromB64("pearl_sky_logo_alpha_v1.png", PEARL_LOGO_SKY_B64, "https://i.ibb.co/9HT9Yt3X/logo.png")
    _G._PearlSingleLogoSkyUri = uri
    return uri
end

local function cleanupPearlSkyDome()
    if V and V.PearlSkyDomeConn then
        pcall(function() V.PearlSkyDomeConn:Disconnect() end)
        V.PearlSkyDomeConn = nil
    end
    if V and V.PearlSkyDomePart then
        pcall(function() V.PearlSkyDomePart:Destroy() end)
        V.PearlSkyDomePart = nil
    end
    if V and V.PearlSkyDomeGui then
        pcall(function() V.PearlSkyDomeGui:Destroy() end)
        V.PearlSkyDomeGui = nil
    end
    local oldWsDome = workspace:FindFirstChild("PearlCustomSkyDome")
    if oldWsDome then pcall(function() oldWsDome:Destroy() end) end
    local cam = workspace.CurrentCamera
    if cam then
        local oldDome = cam:FindFirstChild("PearlCustomSkyDome")
        if oldDome then pcall(function() oldDome:Destroy() end) end
    end
    if parentTarget then
        local oldGui = parentTarget:FindFirstChild("PearlCustomSkyDomeGui")
        if oldGui then pcall(function() oldGui:Destroy() end) end
    end
end
_G.cleanupPearlSkyDome = cleanupPearlSkyDome

local function spawnPearlSkyDome()
    cleanupPearlSkyDome()
    local logoUri = getPearlSingleLogoSkyUri()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local domePart = Instance.new("Part")
    domePart.Name = "PearlCustomSkyDome"
    domePart.Size = Vector3.new(1, 1, 1)
    domePart.Anchored = true
    domePart.CanCollide = false
    domePart.CanQuery = false
    domePart.CanTouch = false
    domePart.CastShadow = false
    domePart.Transparency = 1
    domePart.CFrame = CFrame.new(cam.CFrame.Position)
    domePart.Parent = workspace
    V.PearlSkyDomePart = domePart

    local count = 42
    local radius = 900
    local goldenAngle = math.pi * (3 - math.sqrt(5))
    for i = 1, count do
        local t = (i - 0.5) / count
        local y = -0.15 + t * 1.13
        local r = math.sqrt(math.max(0, 1 - y * y))
        local theta = goldenAngle * i
        local offset = Vector3.new(math.cos(theta) * r * radius, y * radius, math.sin(theta) * r * radius)

        local att = Instance.new("Attachment")
        att.Position = offset
        att.Parent = domePart

        local sz = 72 + ((i * 23) % 52)
        local bb = Instance.new("BillboardGui")
        bb.Adornee = att
        bb.AlwaysOnTop = false
        bb.LightInfluence = 0
        bb.Active = false
        bb.MaxDistance = 5000
        bb.Size = UDim2.new(sz, 0, sz, 0)
        bb.Parent = att

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = logoUri
        img.ImageTransparency = 0.08
        img.ScaleType = Enum.ScaleType.Fit
        img.Rotation = ((i * 41) % 60) - 30
        img.Parent = bb
    end

    V.PearlSkyDomeConn = RunService.RenderStepped:Connect(function()
        local c = workspace.CurrentCamera
        if c and domePart and domePart.Parent then
            domePart.CFrame = CFrame.new(c.CFrame.Position)
        end
    end)
    addConnection(V.PearlSkyDomeConn)
end

skyPresets = {
    ["Pearl Noir (Logo)"] = {
        CustomPearl = true,
        ClockTime = 0, Stars = 2000
    },
    ["Crépuscule Violet Sombre"] = {
        Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293",
        Lf = "rbxassetid://159454299", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288",
        ClockTime = 20, Stars = 4000
    },
    ["Vaporwave 80s"] = {
        Bk = "rbxassetid://1417494402", Dn = "rbxassetid://1417494146", Ft = "rbxassetid://1417494253",
        Lf = "rbxassetid://1417494402", Rt = "rbxassetid://1417494499", Up = "rbxassetid://1417494643",
        ClockTime = 18, Stars = 0
    },
    ["Galaxie Pourpre"] = {
        Bk = "rbxassetid://271042516", Dn = "rbxassetid://271077243", Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310", Rt = "rbxassetid://271042467", Up = "rbxassetid://271077958",
        ClockTime = 22, Stars = 4500
    },
    ["Nébuleuse Violette HD"] = {
        Bk = "rbxassetid://570557514", Dn = "rbxassetid://570557775", Ft = "rbxassetid://570557559",
        Lf = "rbxassetid://570557620", Rt = "rbxassetid://570557672", Up = "rbxassetid://570557727",
        ClockTime = 21, Stars = 3500
    }
}

skyList = {
    "Default",
    "Pearl Noir (Logo)",
    "Crépuscule Violet Sombre",
    "Vaporwave 80s",
    "Galaxie Pourpre",
    "Nébuleuse Violette HD"
}

currentSkyIdx = 1
originalSkyObj = nil
originalClockTime = nil
originalFogEnd = nil
originalAtmosphereDensity = nil

function applyCustomSkybox(skyName)
    local Lighting = game:GetService("Lighting")
    local currentSky = Lighting:FindFirstChildOfClass("Sky")
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if not originalSkyObj and currentSky then
        pcall(function() originalSkyObj = currentSky:Clone() end)
    end
    if originalClockTime == nil then
        originalClockTime = Lighting.ClockTime
    end
    if originalFogEnd == nil then
        originalFogEnd = Lighting.FogEnd
    end
    if originalAtmosphereDensity == nil and atmosphere then
        originalAtmosphereDensity = atmosphere.Density
    end

    cleanupPearlSkyDome()

    if skyName == "Default" then
        if currentSky then currentSky:Destroy() end
        if originalSkyObj then
            pcall(function() originalSkyObj:Clone().Parent = Lighting end)
        end
        if originalClockTime then
            Lighting.ClockTime = originalClockTime
        end
        if originalFogEnd then
            Lighting.FogEnd = originalFogEnd
        end
        if atmosphere and originalAtmosphereDensity ~= nil then
            atmosphere.Density = originalAtmosphereDensity
        end
        notify("Server", "Skybox par défaut restaurée", Color3.fromRGB(80, 200, 120))
        return
    end

    local preset = skyPresets[skyName]
    if not preset then return end

    if currentSky then currentSky:Destroy() end

    if atmosphere then
        atmosphere.Density = 0
    end
    Lighting.FogEnd = 100000

    local newSky = Instance.new("Sky")
    newSky.Name = "PearlCustomSky"
    if preset.CustomPearl then
        local customUri = getPearlCustomSkyUri()
        newSky.SkyboxBk = customUri
        newSky.SkyboxDn = customUri
        newSky.SkyboxFt = customUri
        newSky.SkyboxLf = customUri
        newSky.SkyboxRt = customUri
        newSky.SkyboxUp = customUri
        pcall(spawnPearlSkyDome)
    else
        newSky.SkyboxBk = preset.Bk
        newSky.SkyboxDn = preset.Dn
        newSky.SkyboxFt = preset.Ft
        newSky.SkyboxLf = preset.Lf
        newSky.SkyboxRt = preset.Rt
        newSky.SkyboxUp = preset.Up
    end
    newSky.CelestialBodiesShown = false
    newSky.StarCount = preset.Stars or 3000
    newSky.Parent = Lighting

    if preset.ClockTime then
        Lighting.ClockTime = preset.ClockTime
    end

    notify("Visuals", "Skybox : " .. skyName, Color3.fromRGB(80, 200, 120))
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

-- [isRobloxAdminOrStaff deja defini plus haut]

createToggle("Player Join/Leave Toast Notifs", false, function(enabled)
    V.PlayerJoinLeaveNotifs = enabled
    notify("Server","Notifs Join/Leave".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent,"PlayerJoinLeaveNotifs")

-- AdminJoinNotif deplace dans ProtectionContent
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

isRejoining = false
function performRealAutoRejoin()
    if isRejoining then return end
    isRejoining = true

    task.spawn(function()
        notify("Auto Rejoin", "Déconnexion détectée ! Reconnexion automatique...", Color3.fromRGB(255, 165, 0))
        while true do
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
            task.wait(2.5)

            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
            task.wait(3.5)
        end
    end)
end

pcall(function()
    local GuiService = GuiService
    GuiService.ErrorMessageChanged:Connect(function()
        if V.AutoRejoin then
            performRealAutoRejoin()
        end
    end)
end)

pcall(function()
    local gs = GuiService or GuiService
    gs.ErrorMessageChanged:Connect(function()
        if V.AutoRejoin and not isRejoining then
            performRealAutoRejoin()
        end
    end)
end)

createToggle("Auto Rejoin (Vrai Reconnect Kick/Crash)", true, function(enabled)
    V.AutoRejoin = enabled
    notify("Server", "Auto Rejoin " .. (enabled and "ACTIVÉ (Infaillible)" or "DÉSACTIVÉ"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ServerContent, "AutoRejoin")

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
    V.Force3rd = enabled
    if V.Force3rdConn then V.Force3rdConn:Disconnect() V.Force3rdConn = nil end
    if enabled then
        pcall(function()
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            if LocalPlayer.CameraMaxZoomDistance < 100 then
                LocalPlayer.CameraMaxZoomDistance = 1000
            end
            LocalPlayer.CameraMinZoomDistance = 12
        end)
        V.Force3rdConn = RunService.RenderStepped:Connect(function()
            if not V.Force3rd then
                if V.Force3rdConn then V.Force3rdConn:Disconnect() V.Force3rdConn = nil end
                return
            end
            pcall(function()
                if LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then
                    LocalPlayer.CameraMode = Enum.CameraMode.Classic
                end
                if LocalPlayer.CameraMinZoomDistance < 10 then
                    LocalPlayer.CameraMinZoomDistance = 12
                end
                if LocalPlayer.CameraMaxZoomDistance < 50 then
                    LocalPlayer.CameraMaxZoomDistance = 1000
                end
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and Camera.CameraSubject ~= hum then
                        Camera.CameraSubject = hum
                    end
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                        end
                    end
                end
            end)
        end)
        addConnection(V.Force3rdConn)
    else
        pcall(function()
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 128
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        end)
    end
    notify("Server","Third Person ".. (enabled and "ON (Vue 3ème Personne Parfaite)" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
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

vehicleBoostModesList = {"Camera", "Vehicle Front"}
currentVehicleBoostModeIdx = 1
vehBoostModeFrame, vehBoostModeBtnObj, vehBoostModeValue = createValueButton(VehicleContent, "Vehicle Boost Mode", V.VehicleBoostMode or "Camera", function()
    local foundIdx = table.find(vehicleBoostModesList, V.VehicleBoostMode)
    if foundIdx then currentVehicleBoostModeIdx = foundIdx end
    currentVehicleBoostModeIdx = (currentVehicleBoostModeIdx % #vehicleBoostModesList) + 1
    V.VehicleBoostMode = vehicleBoostModesList[currentVehicleBoostModeIdx]
    notify("Vehicle", "Mode de Boost : " .. V.VehicleBoostMode, Color3.fromRGB(80, 200, 120))
    return V.VehicleBoostMode
end, "VehicleBoostMode")

createToggle("Vehicle Noclip", false, function(enabled)
    V.VehicleNoclip = enabled
    if not enabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local seat = hum and hum.SeatPart
            local veh = seat and (seat:FindFirstAncestorOfClass("Model") or seat.Parent)
            if veh then
                for _, part in ipairs(veh:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
    notify("Vehicle", "Vehicle Noclip " .. (enabled and "ACTIF" or "DÉSACTIVÉ"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent, "VehicleNoclip")

function jumpCar(force)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then
            notify("Vehicle", "Tu dois être dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = seat.Parent:IsA("Model") and seat.Parent or seat
        local primary = (veh:IsA("Model") and veh.PrimaryPart) or seat
        local jumpPower = force or V.VehicleJumpPower or 80

        local pos = primary.Position
        local rx, ry, rz = primary.CFrame:ToOrientation()
        local uprightCF = CFrame.new(pos) * CFrame.Angles(0, ry, 0)

        if veh:IsA("Model") and veh.PrimaryPart then
            veh:SetPrimaryPartCFrame(uprightCF)
        else
            primary.CFrame = uprightCF
        end

        for _, part in pairs(veh:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyAngularVelocity = Vector3.zero
                local curVel = part.AssemblyLinearVelocity
                part.AssemblyLinearVelocity = Vector3.new(curVel.X, jumpPower, curVel.Z)
            end
        end
        if seat:IsA("BasePart") then
            seat.AssemblyAngularVelocity = Vector3.zero
            local curVel = seat.AssemblyLinearVelocity
            seat.AssemblyLinearVelocity = Vector3.new(curVel.X, jumpPower, curVel.Z)
        end

        local existingStab = primary:FindFirstChild("PearlJumpCarStabilizer")
        if existingStab then existingStab:Destroy() end

        local stabilizer = Instance.new("BodyGyro")
        stabilizer.Name = "PearlJumpCarStabilizer"
        stabilizer.MaxTorque = Vector3.new(9e9, 0, 9e9)
        stabilizer.P = 2e5
        stabilizer.D = 1000
        stabilizer.CFrame = CFrame.Angles(0, ry, 0)
        stabilizer.Parent = primary

        task.spawn(function()
            local startTime = os.clock()
            while primary and primary.Parent and stabilizer and stabilizer.Parent and (os.clock() - startTime) < 4 do
                task.wait(0.03)
                
                local _, curY = primary.CFrame:ToOrientation()
                stabilizer.CFrame = CFrame.Angles(0, curY, 0)
                
                for _, part in pairs(veh:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.AssemblyAngularVelocity = Vector3.new(0, part.AssemblyAngularVelocity.Y, 0)
                    end
                end

                if (os.clock() - startTime) > 0.35 then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = { veh, char }
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local hit = workspace:Raycast(primary.Position, Vector3.new(0, -6, 0), rayParams)
                    
                    if hit or (math.abs(primary.AssemblyLinearVelocity.Y) < 1.5 and (os.clock() - startTime) > 0.6) then
                        task.wait(0.2)
                        break
                    end
                end
            end
            if stabilizer and stabilizer.Parent then
                stabilizer:Destroy()
            end
        end)

        notify("Vehicle", "Jump Car (Stabilisé Air & Sol) !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.jumpCar = jumpCar

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

createButton("Jump Car (Faire Sauter le Véhicule)", function()
    jumpCar()
end, VehicleContent)

createSlider("Puissance Saut Véhicule (Jump Power)", 20, 300, 80, function(val)
    V.VehicleJumpPower = val
end, VehicleContent, "VehicleJumpPower")

createToggle("Auto Jump Car (Touche Espace en Voiture)", false, function(enabled)
    V.VehicleAutoJump = enabled
    notify("Vehicle", "Auto Jump Car " .. (enabled and "ON (Espace pour sauter)" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent, "VehicleAutoJump")

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
        ramp.Name = "Pearl_InstantRamp"
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

addConnection(LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Pearl_InstantRamp" then
                obj:Destroy()
            end
        end
    end)
end))

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
        
        local mode = V.VehicleBoostMode or "Camera"
        local boostDir
        if mode == "Vehicle Front" then
            boostDir = root.CFrame.LookVector
            if boostDir.Magnitude < 0.001 then boostDir = seat.CFrame.LookVector end
        else
            boostDir = Camera.CFrame.LookVector
            if boostDir.Magnitude < 0.001 then boostDir = seat.CFrame.LookVector end
        end
        boostDir = boostDir.Unit
        local bv = Instance.new("BodyVelocity")
        bv.Name ="PearlBoostVel"
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = boostDir * (V.VehicleBoostSpeed or 250)
        bv.Parent = root
        V.VehicleBoostVel = bv
        Debris:AddItem(bv, 1.2)
        V.VehicleBoostEnd = os.clock() + 1.2
        notify("Vehicle","BOOST (" .. mode .. ") !", Color3.fromRGB(80, 200, 120))
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

-- ==============================================================
-- [NOUVELLES FONCTIONNALITES VEHICULE AVANCEES]
-- ==============================================================
createLabel("TENUE DE ROUTE (ANTI-CRASH)", VehicleContent)

createToggle("Anti-Flip Automatique (Auto-Stabilizer)", false, function(enabled)
    V.VehicleAutoAntiFlip = enabled
    notify("Vehicle", "Anti-Flip Auto " .. (enabled and "ACTIF" or "DESACTIVE"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent, "VehicleAutoAntiFlip")

createLabel("FRANCHISSEMENT SURNATUREL (WATER & WALL)", VehicleContent)

do
local vehicleWaterPlate = nil
createToggle("Jesus Car (Rouler sur l'eau)", false, function(enabled)
    V.VehicleWaterDrive = enabled
    if not enabled and vehicleWaterPlate and vehicleWaterPlate.Parent then
        pcall(function() vehicleWaterPlate:Destroy() end)
        vehicleWaterPlate = nil
    end
    notify("Vehicle", "Jesus Car " .. (enabled and "ACTIF" or "DESACTIVE"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent, "VehicleWaterDrive")

createLabel("CONTROLE & TACTIQUE VEHICULE", VehicleContent)


-- [FONCTIONS ROBUSTES SUPPRIMER & GHOST VEHICULE (DEFINIES EN AMONT)]
local origVehTransparency = {}

local function toggleVehicleInvisible(forcedState)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat and not V._invisVehModel then
            notify("Vehicle", "Tu dois être assis dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = (seat and (seat:FindFirstAncestorOfClass("Model") or seat.Parent)) or V._invisVehModel
        if not veh then return end

        local newState = (forcedState ~= nil) and forcedState or not V.VehicleInvisibleActive
        V.VehicleInvisibleActive = newState

        if newState then
            V._invisVehModel = veh
            for _, part in pairs(veh:GetDescendants()) do
                if part:IsA("BasePart") then
                    if origVehTransparency[part] == nil then
                        origVehTransparency[part] = part.Transparency
                    end
                    part.Transparency = 1
                    part.CastShadow = false
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    if origVehTransparency[part] == nil then
                        origVehTransparency[part] = part.Transparency
                    end
                    part.Transparency = 1
                elseif part:IsA("SurfaceGui") or part:IsA("BillboardGui") or part:IsA("ParticleEmitter") or part:IsA("Light") then
                    part.Enabled = false
                end
            end
            notify("Vehicle", "Ghost Car ACTIF (Véhicule invisible)", Color3.fromRGB(80, 200, 120))
        else
            if V._invisVehModel then
                for part, origTr in pairs(origVehTransparency) do
                    if part and part.Parent then
                        pcall(function()
                            part.Transparency = origTr
                            if part:IsA("BasePart") then part.CastShadow = true end
                            if part:IsA("SurfaceGui") or part:IsA("BillboardGui") or part:IsA("ParticleEmitter") or part:IsA("Light") then
                                part.Enabled = true
                            end
                        end)
                    end
                end
            end
            origVehTransparency = {}
            V._invisVehModel = nil
            notify("Vehicle", "Ghost Car DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
        end
    end)
end
_G.toggleVehicleInvisible = toggleVehicleInvisible
KeybindCallbacks["VehicleInvisible"] = function() toggleVehicleInvisible() end

local function deleteCurrentVehicle()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then
            notify("Vehicle", "Tu dois être assis dans un véhicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = seat:FindFirstAncestorOfClass("Model") or (seat.Parent:IsA("Model") and seat.Parent or seat)
        hum.Sit = false
        task.wait(0.05)
        pcall(function() veh:Destroy() end)
        notify("Vehicle", "Véhicule supprimé avec succès !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.deleteCurrentVehicle = deleteCurrentVehicle
KeybindCallbacks["VehicleDelete"] = function() deleteCurrentVehicle() end

-- Bouton Delete Vehicule avec bind
do
    local delCard = createCard(VehicleContent, 0, 44)
    local delTitle = Instance.new("TextLabel")
    delTitle.Size = UDim2.new(0.6, 0, 1, 0)
    delTitle.Position = UDim2.new(0, 14, 0, 0)
    delTitle.BackgroundTransparency = 1
    delTitle.Text = "Supprimer le Véhicule (Delete)"
    delTitle.TextColor3 = theme.text
    delTitle.Font = Enum.Font.GothamMedium
    delTitle.TextSize = 12
    delTitle.TextXAlignment = Enum.TextXAlignment.Left
    delTitle.Parent = delCard

    local delBtn = Instance.new("TextButton")
    delBtn.Size = UDim2.new(0, 70, 0, 26)
    delBtn.Position = UDim2.new(1, -164, 0.5, -13)
    delBtn.BackgroundColor3 = Color3.fromRGB(55, 20, 28)
    delBtn.BorderSizePixel = 0
    delBtn.Text = "Delete"
    delBtn.TextColor3 = Color3.fromRGB(255, 90, 100)
    delBtn.Font = Enum.Font.GothamBold
    delBtn.TextSize = 11
    delBtn.Parent = delCard
    makeCorner(delBtn, 6)
    makeStroke(delBtn, Color3.fromRGB(210, 48, 62), 1)

    local delKeyBtn = Instance.new("TextButton")
    delKeyBtn.Size = UDim2.new(0, 80, 0, 26)
    delKeyBtn.Position = UDim2.new(1, -88, 0.5, -13)
    delKeyBtn.BackgroundColor3 = theme.cardHover
    delKeyBtn.BorderSizePixel = 0
    delKeyBtn.Text = (Keybinds.VehicleDelete and Keybinds.VehicleDelete ~= Enum.KeyCode.Unknown) and Keybinds.VehicleDelete.Name or "Aucun"
    delKeyBtn.TextColor3 = theme.accent
    delKeyBtn.Font = Enum.Font.GothamBold
    delKeyBtn.TextSize = 11
    delKeyBtn.Parent = delCard
    makeCorner(delKeyBtn, 6)
    local dStroke = makeStroke(delKeyBtn, theme.border, 1)

    KeybindButtons["VehicleDelete"] = delKeyBtn
    delBtn.MouseButton1Click:Connect(function()
        playClick()
        deleteCurrentVehicle()
    end)
    delKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        KeybindSystem.Binding = true
        KeybindSystem.BindingName = "VehicleDelete"
        KeybindSystem.BindingBtn = delKeyBtn
        delKeyBtn.Text = "Press..."
    end)
    registerSearchCard(delCard, "Delete Supprimer Vehicule Detruire Car", VehicleContent)
end

-- Bouton Vehicule Invisible (Ghost Car) avec bind
do
    local invCard = createCard(VehicleContent, 0, 44)
    local invTitle = Instance.new("TextLabel")
    invTitle.Size = UDim2.new(0.6, 0, 1, 0)
    invTitle.Position = UDim2.new(0, 14, 0, 0)
    invTitle.BackgroundTransparency = 1
    invTitle.Text = "Véhicule Invisible (Ghost Car)"
    invTitle.TextColor3 = theme.text
    invTitle.Font = Enum.Font.GothamMedium
    invTitle.TextSize = 12
    invTitle.TextXAlignment = Enum.TextXAlignment.Left
    invTitle.Parent = invCard

    local invBtn = Instance.new("TextButton")
    invBtn.Size = UDim2.new(0, 70, 0, 26)
    invBtn.Position = UDim2.new(1, -164, 0.5, -13)
    invBtn.BackgroundColor3 = theme.cardHover
    invBtn.BorderSizePixel = 0
    invBtn.Text = "Ghost"
    invBtn.TextColor3 = theme.accent
    invBtn.Font = Enum.Font.GothamBold
    invBtn.TextSize = 11
    invBtn.Parent = invCard
    makeCorner(invBtn, 6)
    makeStroke(invBtn, theme.border, 1)

    local invKeyBtn = Instance.new("TextButton")
    invKeyBtn.Size = UDim2.new(0, 80, 0, 26)
    invKeyBtn.Position = UDim2.new(1, -88, 0.5, -13)
    invKeyBtn.BackgroundColor3 = theme.cardHover
    invKeyBtn.BorderSizePixel = 0
    invKeyBtn.Text = (Keybinds.VehicleInvisible and Keybinds.VehicleInvisible ~= Enum.KeyCode.Unknown) and Keybinds.VehicleInvisible.Name or "Aucun"
    invKeyBtn.TextColor3 = theme.accent
    invKeyBtn.Font = Enum.Font.GothamBold
    invKeyBtn.TextSize = 11
    invKeyBtn.Parent = invCard
    makeCorner(invKeyBtn, 6)
    local iStroke = makeStroke(invKeyBtn, theme.border, 1)

    KeybindButtons["VehicleInvisible"] = invKeyBtn
    invBtn.MouseButton1Click:Connect(function()
        playClick()
        toggleVehicleInvisible()
        invBtn.TextColor3 = V.VehicleInvisibleActive and Color3.fromRGB(80, 220, 140) or theme.accent
    end)
    invKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        KeybindSystem.Binding = true
        KeybindSystem.BindingName = "VehicleInvisible"
        KeybindSystem.BindingBtn = invKeyBtn
        invKeyBtn.Text = "Press..."
    end)
    registerSearchCard(invCard, "Vehicule Invisible Ghost Car Transparent", VehicleContent)
end

-- (Delete and Ghost functions already initialized)

local function toggleVehicleFreeze(enable)
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat and not V._lastAnchoredRoot then
            notify("Vehicle", "Tu dois etre dans un vehicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        local veh = seat and (seat.Parent:IsA("Model") and seat.Parent or seat) or V._lastAnchoredVeh
        local root = seat and (veh:IsA("Model") and (veh.PrimaryPart or seat) or seat) or V._lastAnchoredRoot
        if not root then return end

        local shouldFreeze = (enable ~= nil) and enable or (not root.Anchored)
        V.VehicleAnchorFreeze = shouldFreeze

        if shouldFreeze then
            V._lastAnchoredVeh = veh
            V._lastAnchoredRoot = root
            for _, p in pairs(veh:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.AssemblyLinearVelocity = Vector3.zero
                    p.AssemblyAngularVelocity = Vector3.zero
                    p.Anchored = true
                end
            end
            root.Anchored = true
            notify("Vehicle", "Vehicule Ancre / Fige (Sky Parking) !", Color3.fromRGB(80, 200, 120))
        else
            for _, p in pairs(veh:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Anchored = false
                end
            end
            root.Anchored = false
            V._lastAnchoredVeh = nil
            V._lastAnchoredRoot = nil
            notify("Vehicle", "Vehicule Libere / Defreeze !", Color3.fromRGB(255, 165, 0))
        end

        if _G.updateVehicleFreezeUI then
            _G.updateVehicleFreezeUI(shouldFreeze)
        end
    end)
end
_G.toggleVehicleFreeze = toggleVehicleFreeze

-- Carte unifiée pour Ancrage / Freeze avec support Keybind custom (défaut non défini)
local freezeCard = createCard(VehicleContent, 0, 48)

local freezeTitle = Instance.new("TextLabel")
freezeTitle.Size = UDim2.new(1, -165, 1, 0)
freezeTitle.Position = UDim2.new(0, 14, 0, 0)
freezeTitle.BackgroundTransparency = 1
freezeTitle.Text = "Ancrage / Freeze (Sky Parking)"
freezeTitle.TextColor3 = Colors.Text
freezeTitle.Font = Enum.Font.GothamMedium
freezeTitle.TextSize = 12
freezeTitle.TextXAlignment = Enum.TextXAlignment.Left
freezeTitle.ZIndex = 8
freezeTitle.Parent = freezeCard

local freezeKeyBtn = Instance.new("TextButton")
freezeKeyBtn.Size = UDim2.new(0, 72, 0, 26)
freezeKeyBtn.Position = UDim2.new(1, -140, 0.5, -13)
freezeKeyBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
freezeKeyBtn.BorderSizePixel = 0
freezeKeyBtn.Text = (Keybinds.VehicleFreeze and Keybinds.VehicleFreeze ~= Enum.KeyCode.Unknown) and Keybinds.VehicleFreeze.Name or "[None]"
freezeKeyBtn.TextColor3 = Colors.Accent
freezeKeyBtn.Font = Enum.Font.GothamBold
freezeKeyBtn.TextSize = 11
freezeKeyBtn.ZIndex = 8
freezeKeyBtn.Parent = freezeCard
makeCorner(freezeKeyBtn, 6)
local fkbStroke = makeStroke(freezeKeyBtn, Colors.Border, 1)

freezeKeyBtn.MouseEnter:Connect(function()
    if not (KeybindSystem.Binding and KeybindSystem.BindingName == "VehicleFreeze") then
        fkbStroke.Color = Colors.Accent
    end
end)
freezeKeyBtn.MouseLeave:Connect(function()
    if not (KeybindSystem.Binding and KeybindSystem.BindingName == "VehicleFreeze") then
        fkbStroke.Color = Colors.Border
    end
end)

freezeKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() GuiService.SelectedObject = nil end)
    KeybindSystem.Binding = true
    KeybindSystem.BindingName = "VehicleFreeze"
    KeybindSystem.BindingBtn = freezeKeyBtn
    freezeKeyBtn.Text = "Press..."
    freezeKeyBtn.BackgroundColor3 = Colors.Accent
    freezeKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fkbStroke.Color = Colors.Accent
end)

KeybindButtons["VehicleFreeze"] = freezeKeyBtn
KeybindCallbacks["VehicleFreeze"] = function()
    toggleVehicleFreeze()
end

local freezeToggleBtn = Instance.new("TextButton")
freezeToggleBtn.Size = UDim2.new(0, 52, 0, 24)
freezeToggleBtn.Position = UDim2.new(1, -62, 0.5, -12)
freezeToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
freezeToggleBtn.BorderSizePixel = 0
freezeToggleBtn.Text = "OFF"
freezeToggleBtn.TextColor3 = Colors.TextDim
freezeToggleBtn.Font = Enum.Font.GothamBold
freezeToggleBtn.TextSize = 10
freezeToggleBtn.AutoButtonColor = false
freezeToggleBtn.ZIndex = 8
freezeToggleBtn.Parent = freezeCard
makeCorner(freezeToggleBtn, 6)
local ftStroke = makeStroke(freezeToggleBtn, Colors.Border, 1)

local function updateFreezeBtnState(active)
    if active then
        freezeToggleBtn.Text = "ON"
        freezeToggleBtn.TextColor3 = Colors.Success
        freezeToggleBtn.BackgroundColor3 = Colors.CardActive
        ftStroke.Color = Colors.Success
    else
        freezeToggleBtn.Text = "OFF"
        freezeToggleBtn.TextColor3 = Colors.TextDim
        freezeToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
        ftStroke.Color = Colors.Border
    end
end
_G.updateVehicleFreezeUI = updateFreezeBtnState

freezeToggleBtn.MouseButton1Click:Connect(function()
    playClick()
    local newState = not V.VehicleAnchorFreeze
    toggleVehicleFreeze(newState)
    updateFreezeBtnState(newState)
end)

registerSearchCard(freezeCard, "Ancrage Freeze Vehicule Sky Parking Bind Keybind", VehicleContent)

local lastDrivenSeat = nil
local function ejectFromVehicle()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local seat = hum and hum.SeatPart
        if not seat or not hrp then
            notify("Vehicle", "Tu dois etre assis dans un vehicule !", Color3.fromRGB(255, 165, 0))
            return
        end
        lastDrivenSeat = seat
        hum.Sit = false
        task.wait(0.04)
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 35, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 25, hrp.AssemblyLinearVelocity.Z)
        notify("Vehicle", "Ejection Tactique reussie (+35 studs) !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.ejectFromVehicle = ejectFromVehicle

local function autoRecallToVehicle()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hum then return end

        local targetSeat = lastDrivenSeat
        if not targetSeat or not targetSeat.Parent then
            local closestDist = 150
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") then
                    local dist = (obj.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        targetSeat = obj
                    end
                end
            end
        end

        if not targetSeat or not targetSeat.Parent then
            notify("Vehicle", "Aucun vehicule a rappeler a proximite !", Color3.fromRGB(255, 90, 90))
            return
        end

        hrp.CFrame = targetSeat.CFrame + Vector3.new(0, 2.5, 0)
        task.wait(0.05)
        if _G.sitInSeat then
            _G.sitInSeat(hum, hrp, targetSeat)
        else
            targetSeat:Sit(hum)
        end
        lastDrivenSeat = targetSeat
        notify("Vehicle", "Retour automatique au volant !", Color3.fromRGB(80, 200, 120))
    end)
end
_G.autoRecallToVehicle = autoRecallToVehicle

createButton("Ejection Tactique (Eject 35 studs)", function()
    ejectFromVehicle()
end, VehicleContent)

createButton("Auto-Recall (Retour au Volant)", function()
    autoRecallToVehicle()
end, VehicleContent)
end

if V.VehicleBoostHoldConn then V.VehicleBoostHoldConn:Disconnect() end
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Space then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart and (V.VehicleAutoJump ~= false) then
            jumpCar(V.VehicleJumpPower or 80)
        end
    end
end)

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
                if not seat:GetAttribute("_PearlOrigMaxSpeed") then
                    seat:SetAttribute("_PearlOrigMaxSpeed", seat.MaxSpeed)
                    seat:SetAttribute("_PearlOrigTorque", seat.Torque)
                end
                local origSpeed = seat:GetAttribute("_PearlOrigMaxSpeed") or seat.MaxSpeed
                local origTorque = seat:GetAttribute("_PearlOrigTorque") or seat.Torque

                if V.VehicleSpeed and V.VehicleSpeed > 1 then
                    seat.MaxSpeed = origSpeed * V.VehicleSpeed
                    seat.Torque = origTorque * V.VehicleSpeed

                    local isForward = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
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
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then
                        moveDir = moveDir + camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then
                        moveDir = moveDir - camCF.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then
                        moveDir = moveDir - camCF.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then
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
                    local veh = seat:FindFirstAncestorOfClass("Model") or (seat.Parent:IsA("Model") and seat.Parent or seat)
                    if veh then
                        for _, part in ipairs(veh:GetDescendants()) do
                            if part:IsA("BasePart") then
                                local pName = string.lower(part.Name)
                                local isWheel = pName:find("wheel") or pName:find("tire") or pName:find("roue") or pName:find("cylind") or pName:find("rim")
                                if isWheel then
                                    part.CanCollide = true
                                else
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                    if char then
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then
                                p.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end



        -- [FEATURE: ANTI-FLIP AUTOMATIQUE PERMANENT (GYRO-STABILIZER)]
        if V.VehicleAutoAntiFlip then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if seat then
                    local vehModel = seat.Parent:IsA("Model") and seat.Parent or nil
                    local root = (vehModel and vehModel.PrimaryPart) or seat
                    local up = root.CFrame.UpVector
                    if up.Y < 0.55 then
                        local cf = root.CFrame
                        local look = cf.LookVector
                        local flatLook = Vector3.new(look.X, 0, look.Z)
                        if flatLook.Magnitude < 0.05 then flatLook = Vector3.new(0, 0, -1) else flatLook = flatLook.Unit end
                        local targetCF = CFrame.lookAt(root.Position + Vector3.new(0, 1.2, 0), root.Position + Vector3.new(0, 1.2, 0) + flatLook)
                        if vehModel and vehModel.PrimaryPart then
                            vehModel:SetPrimaryPartCFrame(targetCF)
                        else
                            root.CFrame = targetCF
                        end
                        root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y, 0)
                    end
                end
            end)
        end



        -- [FEATURE: JESUS CAR (ROULER SUR L'EAU)]
        if V.VehicleWaterDrive then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local seat = hum and hum.SeatPart
                if seat then
                    local vehModel = seat.Parent:IsA("Model") and seat.Parent or nil
                    local root = (vehModel and vehModel.PrimaryPart) or seat
                    local rootPos = root.Position

                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = { char, (vehModel or seat.Parent) }
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    rayParams.IgnoreWater = false

                    local rayResult = workspace:Raycast(rootPos + Vector3.new(0, 3, 0), Vector3.new(0, -30, 0), rayParams)
                    local isWater = false
                    local waterY = nil

                    if rayResult then
                        if rayResult.Material == Enum.Material.Water or (rayResult.Instance and (rayResult.Instance.Name:lower():find("water") or rayResult.Instance.Material == Enum.Material.Water)) then
                            isWater = true
                            waterY = rayResult.Position.Y
                        end
                    end

                    if isWater and waterY then
                        if not vehicleWaterPlate or not vehicleWaterPlate.Parent then
                            vehicleWaterPlate = Instance.new("Part")
                            vehicleWaterPlate.Name = "NebulaVehicleWaterPlate"
                            vehicleWaterPlate.Size = Vector3.new(24, 1.2, 34)
                            vehicleWaterPlate.Transparency = 1
                            vehicleWaterPlate.Anchored = true
                            vehicleWaterPlate.CanCollide = true
                            vehicleWaterPlate.Material = Enum.Material.SmoothPlastic
                            vehicleWaterPlate.Parent = workspace
                        end
                        vehicleWaterPlate.CFrame = CFrame.new(rootPos.X, waterY - 0.5, rootPos.Z) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
                    else
                        if vehicleWaterPlate and vehicleWaterPlate.Parent then
                            vehicleWaterPlate.CFrame = CFrame.new(0, -9999, 0)
                        end
                    end
                end
            end)
        elseif not V.VehicleWaterDrive and vehicleWaterPlate then
            pcall(function() vehicleWaterPlate:Destroy() end)
            vehicleWaterPlate = nil
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

function createGrappleBeam(startAtt, endAtt)
    local beam = Instance.new("Beam")
    beam.Name = "GrappleRope"
    beam.Attachment0 = startAtt
    beam.Attachment1 = endAtt
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    beam.Width0 = 0.12
    beam.Width1 = 0.12
    beam.FaceCamera = true
    beam.Texture = "rbxassetid://29712167"
    beam.TextureSpeed = 2
    beam.Transparency = NumberSequence.new(0.1)
    beam.Parent = startAtt.Parent
    return beam
end

function toggleGrappleHook(enabled)
    V.GrappleHook = enabled
    if enabled then
        if V.GrappleTool then V.GrappleTool:Destroy() end
        local tool = Instance.new("Tool")
        tool.Name = "Grappin Spider-Man"
        tool.RequiresHandle = true
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.6, 0.6, 1.5)
        handle.CanCollide = false
        handle.Transparency = 0.3
        handle.Color = Color3.fromRGB(200, 30, 40)
        handle.Material = Enum.Material.Neon
        handle.Parent = tool

        local isGrappling = false
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            local mouseLoc = UserInputService:GetMouseLocation()
            local unitRay = Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y)
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {char}
            local hitRes = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1500, rayParams)
            
            local targetPos = hitRes and hitRes.Position or (mouse.Hit and mouse.Hit.Position)
            if not targetPos then return end
            local startPos = hrp.Position
            local dist = (targetPos - startPos).Magnitude
            if dist < 4 or dist > 2000 then return end

            local hitPart = (hitRes and hitRes.Instance) or workspace.Terrain
            local endAtt = Instance.new("Attachment")
            endAtt.WorldPosition = targetPos
            endAtt.Parent = hitPart

            local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm") or hrp
            local startAtt = Instance.new("Attachment")
            startAtt.Parent = hand
            local beam = createGrappleBeam(startAtt, endAtt)

            if hrp:FindFirstChild("GrappleBV") then hrp.GrappleBV:Destroy() end
            
            local bv = Instance.new("BodyVelocity")
            bv.Name = "GrappleBV"
            bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
            local dir = (targetPos - startPos).Unit
            local pullSpeed = math.clamp(dist * 2.5, 90, 280)
            local ballisticDir = (dir + Vector3.new(0, 0.15, 0)).Unit
            bv.Velocity = ballisticDir * pullSpeed
            bv.Parent = hrp

            task.spawn(function()
                local startTime = tick()
                while (hrp.Position - targetPos).Magnitude > 6 and (tick() - startTime) < 2.5 and tool.Parent == char do
                    local curDir = (targetPos - hrp.Position).Unit
                    local curDist = (targetPos - hrp.Position).Magnitude
                    local speed = math.clamp(curDist * 2.8, 70, 260)
                    bv.Velocity = (curDir + Vector3.new(0, 0.08, 0)).Unit * speed
                    task.wait(0.02)
                end
                
                if hrp:FindFirstChild("GrappleBV") then
                    bv.Velocity = (Camera.CFrame.LookVector + Vector3.new(0, 0.5, 0)).Unit * 80
                    task.wait(0.12)
                    pcall(function() bv:Destroy() end)
                end
                pcall(function()
                    beam:Destroy()
                    startAtt:Destroy()
                    endAtt:Destroy()
                end)
            end)
        end)

        tool.Parent = LocalPlayer.Backpack
        V.GrappleTool = tool
        notify("Fun", "Grappin Spider-Man ajouté dans l'inventaire !", Color3.fromRGB(80, 200, 120))
    else
        if V.GrappleTool then
            if V.GrappleTool.Parent == LocalPlayer.Character or V.GrappleTool.Parent == LocalPlayer.Backpack then
                V.GrappleTool:Destroy()
            end
            V.GrappleTool = nil
        end
        notify("Fun", "Grappin Spider-Man retiré.", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleGrappleHook = toggleGrappleHook

createToggle("Grappin Universel (Spider-Man Rope)", false, function(enabled)
    toggleGrappleHook(enabled)
end, FunContent, "GrappleHook")

sitAirBP = nil
sitAirBG = nil

function toggleSitAir(enabled)
    V.SitAir = enabled
    if V.SitAirConn then V.SitAirConn:Disconnect() V.SitAirConn = nil end
    if sitAirBP then pcall(function() sitAirBP:Destroy() end) sitAirBP = nil end
    if sitAirBG then pcall(function() sitAirBG:Destroy() end) sitAirBG = nil end

    if enabled then
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            hum.Sit = true
            hum:ChangeState(Enum.HumanoidStateType.Seated)

            local bp = Instance.new("BodyPosition")
            bp.Name = "PearlSitAirBP"
            bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bp.D = 400
            bp.P = 1e4
            bp.Position = hrp.Position
            bp.Parent = hrp
            sitAirBP = bp

            local bg = Instance.new("BodyGyro")
            bg.Name = "PearlSitAirBG"
            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.D = 400
            bg.P = 1e4
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp
            sitAirBG = bg

            V.SitAirConn = RunService.RenderStepped:Connect(function()
                if not V.SitAir then return end
                local c = LocalPlayer.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h and not h.Sit then
                    h.Sit = true
                    h:ChangeState(Enum.HumanoidStateType.Seated)
                end
            end)
            addConnection(V.SitAirConn)
        end)
        notify("Fun", "Sit Air (Assis dans les airs) ACTIVÉ", Color3.fromRGB(80, 200, 120))
    else
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp:FindFirstChild("PearlSitAirBP") then hrp.PearlSitAirBP:Destroy() end
                if hrp:FindFirstChild("PearlSitAirBG") then hrp.PearlSitAirBG:Destroy() end
            end
            if hum then
                hum.Sit = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
        notify("Fun", "Sit Air DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
    end
end
_G.toggleSitAir = toggleSitAir

createToggle("Sit Air (Assis dans les airs)", false, function(enabled)
    toggleSitAir(enabled)
end, FunContent, "SitAir")

do
    local waterPlatform = nil
    local waterWalkSteppedConn = nil
    local waterWalkHeartbeatConn = nil
    local waterWalkCharConn = nil
    local waterWalkDescendantConn = nil
    local cachedWaterParts = {}
    local lastWaterY = nil

    local function scanWaterParts()
        cachedWaterParts = {}
        pcall(function()
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local lName = string.lower(obj.Name)
                    if string.find(lName, "water") or string.find(lName, "ocean") or string.find(lName, "sea") or string.find(lName, "lake") or string.find(lName, "river") or obj.Material == Enum.Material.Water then
                        table.insert(cachedWaterParts, obj)
                    end
                end
            end
        end)
    end

    local function disableWaterTouch()
        pcall(function()
            for _, obj in pairs(cachedWaterParts) do
                if obj and obj.Parent then
                    obj.CanTouch = false
                end
            end
        end)
    end

    local function restoreWaterTouch()
        pcall(function()
            for _, obj in pairs(cachedWaterParts) do
                if obj and obj.Parent then
                    obj.CanTouch = true
                end
            end
        end)
    end

    local function findWaterY(hrp, hum)
        if hum and (hum:GetState() == Enum.HumanoidStateType.Swimming or hum.FloorMaterial == Enum.Material.Water) then
            lastWaterY = hrp.Position.Y + 1.2
            return lastWaterY
        end

        local rayP = RaycastParams.new()
        rayP.FilterType = RaycastFilterType.Exclude
        rayP.FilterDescendantsInstances = {LocalPlayer.Character, waterPlatform}
        rayP.IgnoreWater = false

        local skyRay = workspace:Raycast(Vector3.new(hrp.Position.X, hrp.Position.Y + 120, hrp.Position.Z), Vector3.new(0, -300, 0), rayP)
        if skyRay then
            if skyRay.Material == Enum.Material.Water then
                lastWaterY = skyRay.Position.Y
                return lastWaterY
            end
            local hitName = string.lower(skyRay.Instance.Name)
            if string.find(hitName, "water") or string.find(hitName, "ocean") or string.find(hitName, "sea") or string.find(hitName, "lake") or string.find(hitName, "river") then
                lastWaterY = skyRay.Position.Y
                return lastWaterY
            end
        end

        local downRay = workspace:Raycast(Vector3.new(hrp.Position.X, hrp.Position.Y + 5, hrp.Position.Z), Vector3.new(0, -80, 0), rayP)
        if downRay then
            if downRay.Material == Enum.Material.Water then
                lastWaterY = downRay.Position.Y
                return lastWaterY
            end
            local hitName = string.lower(downRay.Instance.Name)
            if string.find(hitName, "water") or string.find(hitName, "ocean") or string.find(hitName, "sea") or string.find(hitName, "lake") or string.find(hitName, "river") then
                lastWaterY = downRay.Position.Y
                return lastWaterY
            end
        end

        if #cachedWaterParts > 0 then
            for _, part in ipairs(cachedWaterParts) do
                if part and part.Parent then
                    local topY = part.Position.Y + (part.Size.Y / 2)
                    local distH = Vector2.new(hrp.Position.X - part.Position.X, hrp.Position.Z - part.Position.Z).Magnitude
                    if distH < math.max(part.Size.X, part.Size.Z) * 0.7 or math.max(part.Size.X, part.Size.Z) > 300 then
                        if hrp.Position.Y < (topY + 30) and hrp.Position.Y > (topY - 80) then
                            lastWaterY = topY
                            return lastWaterY
                        end
                    end
                end
            end
        end

        if hrp.Position.Y <= 25 and hrp.Position.Y >= -100 then
            return 0
        end

        return lastWaterY
    end

    local function stepWaterWalk()
        if not V.WaterWalk or not waterPlatform then return end
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            local waterY = findWaterY(hrp, hum)
            if waterY ~= nil then
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, waterY - 2, hrp.Position.Z)
                waterPlatform.CanCollide = true

                if hum:GetState() == Enum.HumanoidStateType.Swimming or hum.FloorMaterial == Enum.Material.Water or hrp.Position.Y < (waterY + 1) then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    if hrp.Position.Y < (waterY + 1.5) then
                        hrp.CFrame = CFrame.new(hrp.Position.X, waterY + 3.2, hrp.Position.Z)
                        local curV = hrp.AssemblyLinearVelocity
                        if curV.Y < 0 then
                            hrp.AssemblyLinearVelocity = Vector3.new(curV.X, 0, curV.Z)
                        end
                    end
                end
            else
                waterPlatform.CFrame = CFrame.new(hrp.Position.X, -5000, hrp.Position.Z)
                waterPlatform.CanCollide = false
            end
        end)
    end

    local function toggleWaterWalk(enabled)
        V.WaterWalk = enabled
        if waterWalkSteppedConn then waterWalkSteppedConn:Disconnect() waterWalkSteppedConn = nil end
        if waterWalkHeartbeatConn then waterWalkHeartbeatConn:Disconnect() waterWalkHeartbeatConn = nil end
        if waterWalkCharConn then waterWalkCharConn:Disconnect() waterWalkCharConn = nil end
        if waterWalkDescendantConn then waterWalkDescendantConn:Disconnect() waterWalkDescendantConn = nil end
        if waterPlatform then waterPlatform:Destroy() waterPlatform = nil end

        if enabled then
            scanWaterParts()
            disableWaterTouch()

            waterPlatform = Instance.new("Part")
            waterPlatform.Name = "PearlWaterWalkPlatform"
            waterPlatform.Size = Vector3.new(120, 4, 120)
            waterPlatform.Transparency = 1
            waterPlatform.Anchored = true
            waterPlatform.CanCollide = true
            waterPlatform.Material = Enum.Material.SmoothPlastic
            waterPlatform.CustomPhysicalProperties = PhysicalProperties.new(0.7, 1.0, 0, 1.0, 1.0)
            waterPlatform.Parent = workspace

            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                end
            end)

            waterWalkSteppedConn = RunService.Stepped:Connect(stepWaterWalk)
            addConnection(waterWalkSteppedConn)

            waterWalkHeartbeatConn = RunService.Heartbeat:Connect(stepWaterWalk)
            addConnection(waterWalkHeartbeatConn)

            waterWalkCharConn = LocalPlayer.CharacterAdded:Connect(function(newChar)
                if V.WaterWalk then
                    task.wait(0.3)
                    pcall(function()
                        local hum = newChar:WaitForChild("Humanoid", 3)
                        if hum then
                            hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                        end
                    end)
                end
            end)
            addConnection(waterWalkCharConn)

            waterWalkDescendantConn = workspace.DescendantAdded:Connect(function(obj)
                if V.WaterWalk and obj:IsA("BasePart") then
                    local lName = string.lower(obj.Name)
                    if string.find(lName, "water") or string.find(lName, "ocean") or string.find(lName, "sea") or obj.Material == Enum.Material.Water then
                        table.insert(cachedWaterParts, obj)
                        pcall(function() obj.CanTouch = false end)
                    end
                end
            end)
            addConnection(waterWalkDescendantConn)

            notify("Fun", "Marcher sur l'eau (Sans degats) ACTIVE", Color3.fromRGB(80, 200, 120))
        else
            restoreWaterTouch()
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
                end
            end)
            notify("Fun", "Marcher sur l'eau DESACTIVE", Color3.fromRGB(255, 90, 90))
        end
    end

    createToggle("Marcher sur l'eau (Sans degats)", false, function(enabled)
        toggleWaterWalk(enabled)
    end, FunContent, "WaterWalk")
end

do
    local airPart = nil
    local airWalkConn = nil
    local currentPlatformY = nil

    local function toggleAirWalk(enabled)
        V.AirWalk = enabled
        if enabled then
            currentPlatformY = nil
            if airWalkConn then airWalkConn:Disconnect() airWalkConn = nil end
            airWalkConn = RunService.Heartbeat:Connect(function()
                if not V.AirWalk then return end
                pcall(function()
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                    if not char or not hum or not hrp or hum.Health <= 0 then
                        currentPlatformY = nil
                        return
                    end

                    if not airPart or not airPart.Parent then
                        airPart = Instance.new("Part")
                        airPart.Name = "Nebula_AirWalkPart"
                        airPart.Size = Vector3.new(4, 1, 4)
                        airPart.Transparency = 1
                        airPart.Anchored = true
                        airPart.CanCollide = true
                        airPart.TopSurface = Enum.SurfaceType.Smooth
                        airPart.BottomSurface = Enum.SurfaceType.Smooth
                        airPart.Parent = workspace
                    end

                    local hipHeight = (hum.HipHeight and hum.HipHeight > 0) and hum.HipHeight or 2.0
                    local feetLevel = hrp.Position.Y - hipHeight - (hrp.Size.Y / 2)

                    local isJumping = UserInputService:IsKeyDown(Enum.KeyCode.Space)
                    local isDescending = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C)

                    if currentPlatformY == nil then
                        currentPlatformY = feetLevel - 0.5
                    end

                    if isJumping then
                        currentPlatformY = feetLevel - 0.2
                        pcall(function()
                            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 35, hrp.AssemblyLinearVelocity.Z)
                        end)
                    elseif isDescending then
                        currentPlatformY = currentPlatformY - 0.7
                    else
                        if feetLevel < currentPlatformY - 1.2 or feetLevel > currentPlatformY + 3.0 then
                            currentPlatformY = feetLevel - 0.5
                        end
                    end

                    airPart.CFrame = CFrame.new(hrp.Position.X, currentPlatformY, hrp.Position.Z)
                end)
            end)
            notify("Fun", "Air Walk (Jesus Walk) ACTIVÉ — Espace pour monter, C pour descendre", Color3.fromRGB(80, 200, 120))
        else
            if airWalkConn then
                airWalkConn:Disconnect()
                airWalkConn = nil
            end
            if airPart and airPart.Parent then
                airPart:Destroy()
                airPart = nil
            end
            currentPlatformY = nil
            notify("Fun", "Air Walk DÉSACTIVÉ", Color3.fromRGB(255, 90, 90))
        end
    end

    createToggle("Air Walk / Jesus Walk (Escalier Céleste)", false, function(enabled)
        toggleAirWalk(enabled)
    end, FunContent, "AirWalk")
end

initStep = "cablage Settings"


function updateThemeAccent(col)
    V.AccentColor = col
    if setAccentColor then
        pcall(function() setAccentColor(col) end)
    end
    notify("Theme","Couleur d'accentuation mise à jour !", col)
end

do
    local KeybindHUDFrame = Instance.new("Frame")
    KeybindHUDFrame.Name ="PearlKeybindHUD"
    KeybindHUDFrame.Size = UDim2.new(0, 200, 0, 230)
    KeybindHUDFrame.Position = UDim2.new(1, -210, 0.25, 0)
    KeybindHUDFrame.BackgroundColor3 = theme.panel
    KeybindHUDFrame.BackgroundTransparency = 0.05
    KeybindHUDFrame.BorderSizePixel = 0
    KeybindHUDFrame.Visible = false
    KeybindHUDFrame.Active = true
    KeybindHUDFrame.Draggable = true
    KeybindHUDFrame.Parent = ScreenGui

    makeCorner(KeybindHUDFrame, 12)
    makeStroke(KeybindHUDFrame, theme.border, 1.2)

    local khHeader = Instance.new("Frame")
    khHeader.Size = UDim2.new(1, -12, 0, 34)
    khHeader.Position = UDim2.new(0, 6, 0, 6)
    khHeader.BackgroundColor3 = theme.panel2
    khHeader.BorderSizePixel = 0
    khHeader.Parent = KeybindHUDFrame
    makeCorner(khHeader, 8)
    makeStroke(khHeader, theme.border, 1)

    local khTitle = Instance.new("TextLabel")
    khTitle.Size = UDim2.new(1, -16, 1, 0)
    khTitle.Position = UDim2.new(0, 10, 0, 0)
    khTitle.BackgroundTransparency = 1
    khTitle.Text = "KEYBINDS HUD"
    khTitle.TextColor3 = theme.accent
    khTitle.Font = Enum.Font.GothamBold
    khTitle.TextSize = 11
    khTitle.TextXAlignment = Enum.TextXAlignment.Left
    khTitle.Parent = khHeader

    local khContent = Instance.new("ScrollingFrame")
    khContent.Size = UDim2.new(1, -12, 1, -48)
    khContent.Position = UDim2.new(0, 6, 0, 44)
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
                    row.Size = UDim2.new(1, 0, 0, 26)
                    row.BackgroundColor3 = theme.card
                    row.BorderSizePixel = 0
                    row.Parent = khContent
                    makeCorner(row, 6)
                    makeStroke(row, theme.border, 1)

                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(0.65, 0, 1, 0)
                    lbl.Position = UDim2.new(0, 8, 0, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = name .." [".. key.Name .."]"
                    lbl.TextColor3 = theme.text
                    lbl.Font = Enum.Font.GothamMedium
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.Parent = row

                    local statusBadge = Instance.new("TextLabel")
                    statusBadge.Size = UDim2.new(0, 42, 0, 18)
                    statusBadge.Position = UDim2.new(1, -48, 0.5, -9)
                    statusBadge.BackgroundColor3 = active and Color3.fromRGB(25, 55, 35) or theme.panel2
                    statusBadge.Text = active and "ON" or "OFF"
                    statusBadge.TextColor3 = active and Color3.fromRGB(80, 220, 120) or theme.sub
                    statusBadge.Font = Enum.Font.GothamBold
                    statusBadge.TextSize = 9
                    statusBadge.BorderSizePixel = 0
                    statusBadge.Parent = row
                    makeCorner(statusBadge, 4)
                    makeStroke(statusBadge, active and Color3.fromRGB(40, 90, 55) or theme.border, 1)
                end
            end
        end
    end)
end

createLabel("PERSONNALISATION DU MENU", SettingsContent)

createToggle("Bulles Animées (Background)", true, function(enabled)
    V.BubblesEnabled = enabled
    if BubblesContainer then
        BubblesContainer.Visible = enabled
    end
end, SettingsContent,"BubblesEnabled")

createToggle("Fond Sombre (Opacité / Dimmer)", true, function(enabled)
    V.DimmerEnabled = enabled
    if BackgroundDimmer then
        BackgroundDimmer.Visible = (menuOpen and not minimized and enabled) or false
    end
end, SettingsContent,"DimmerEnabled")

createSlider("Opacité Fond Sombre (Dimmer)", 0, 100, 80, function(val)
    V.DimmerOpacity = val
    if BackgroundDimmer then
        BackgroundDimmer.BackgroundTransparency = 1 - (val / 100)
    end
end, SettingsContent,"DimmerOpacity")

createLabel("SYSTEME & ACCESSIBILITE", SettingsContent)

do
    local shiftLockEnabled = false
    local shiftLockActive = false
    local shiftLockConn = nil
    local shiftLockInputConn = nil
    local shiftLockDot = nil

    local function updateShiftLockState(active)
        shiftLockActive = active
        pcall(function()
            if shiftLockActive then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.AutoRotate = false end
                if not shiftLockDot then
                    shiftLockDot = Instance.new("Frame")
                    shiftLockDot.Name = "PearlShiftLockDot"
                    shiftLockDot.Size = UDim2.new(0, 6, 0, 6)
                    shiftLockDot.AnchorPoint = Vector2.new(0.5, 0.5)
                    shiftLockDot.Position = UDim2.new(0.5, 0.5, 0.5, 0)
                    shiftLockDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    shiftLockDot.BorderSizePixel = 0
                    shiftLockDot.ZIndex = 9999
                    shiftLockDot.Parent = ScreenGui
                    makeCorner(shiftLockDot, 3)
                end
                shiftLockDot.Visible = true
            else
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.AutoRotate = true end
                if shiftLockDot then shiftLockDot.Visible = false end
            end
        end)
    end

    createToggle("Shift Lock (Any Games)", false, function(enabled)
        shiftLockEnabled = enabled
        pcall(function() LocalPlayer.DevEnableMouseLock = true end)

        if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
        if shiftLockInputConn then shiftLockInputConn:Disconnect() shiftLockInputConn = nil end

        if enabled then
            updateShiftLockState(true)

            shiftLockConn = RunService.RenderStepped:Connect(function()
                if not shiftLockEnabled then return end
                pcall(function()
                    LocalPlayer.DevEnableMouseLock = true
                    if shiftLockActive then
                        if not menuOpen and not UserInputService:GetFocusedTextBox() then
                            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                        end
                        local char = LocalPlayer.Character
                        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if hrp and hum then
                            hum.AutoRotate = false
                            local camLook = Camera.CFrame.LookVector
                            local flat = Vector3.new(camLook.X, 0, camLook.Z)
                            if flat.Magnitude > 0 then
                                hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flat.Unit)
                            end
                        end
                    end
                end)
            end)
            addConnection(shiftLockConn)

            shiftLockInputConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
                    if shiftLockEnabled then
                        updateShiftLockState(not shiftLockActive)
                    end
                end
            end)
            addConnection(shiftLockInputConn)

            notify("Settings", "Shift Lock (Any Games) ON", Color3.fromRGB(80, 200, 120))
        else
            updateShiftLockState(false)
            if shiftLockDot then shiftLockDot:Destroy() shiftLockDot = nil end
            notify("Settings", "Shift Lock (Any Games) OFF", Color3.fromRGB(255, 90, 90))
        end
    end, SettingsContent, "ShiftLockAnyGames")
end

do
    local antiAfkConn = nil
    createToggle("Real Anti-AFK System", false, function(enabled)
        V.AntiAFK = enabled
        if enabled then
            if antiAfkConn then antiAfkConn:Disconnect() end

            -- Desactivation native du signal Idled via getconnections sans VirtualUser
            pcall(function()
                if getconnections then
                    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
                        if conn.Disable then
                            conn:Disable()
                        elseif conn.Disconnect then
                            conn:Disconnect()
                        end
                    end
                end
            end)

            antiAfkConn = LocalPlayer.Idled:Connect(function()
                if V.AntiAFK then
                    pcall(function()
                        if mouse1click then
                            mouse1click()
                        elseif keypress and keyrelease then
                            keypress(0x20)
                            task.wait(0.05)
                            keyrelease(0x20)
                        end
                    end)
                end
            end)
            addConnection(antiAfkConn)

            task.spawn(function()
                while V.AntiAFK do
                    task.wait(45)
                    if V.AntiAFK then
                        pcall(function()
                            if mouse1click then
                                mouse1click()
                            elseif keypress and keyrelease then
                                keypress(0x20)
                                task.wait(0.05)
                                keyrelease(0x20)
                            end
                        end)
                    end
                end
            end)

            notify("Settings","Real Anti-AFK System ON (Zero Detection)", Color3.fromRGB(80, 200, 120))
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

V.Watermark = true
createToggle("Afficher Watermark", true, function(enabled)
    V.Watermark = enabled
    if Watermark then
        Watermark.Visible = enabled
    end
    notify("Settings", "Watermark " .. (enabled and "ON" or "OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, SettingsContent, "ShowWatermark")
do
    local MenuKeybindFrame = createCard(SettingsContent, 0, 44)

    local MenuKeyLabel = Instance.new("TextLabel")
    MenuKeyLabel.Size = UDim2.new(0.6, 0, 1, 0)
    MenuKeyLabel.Position = UDim2.new(0, 14, 0, 0)
    MenuKeyLabel.BackgroundTransparency = 1
    MenuKeyLabel.Text = "Menu Toggle Key"
    MenuKeyLabel.TextColor3 = theme.text
    MenuKeyLabel.Font = Enum.Font.GothamMedium
    MenuKeyLabel.TextSize = 12
    MenuKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    MenuKeyLabel.ZIndex = 8
    MenuKeyLabel.Parent = MenuKeybindFrame

    local MenuKeyBtn = Instance.new("TextButton")
    MenuKeyBtn.Size = UDim2.new(0, 74, 0, 26)
    MenuKeyBtn.Position = UDim2.new(1, -118, 0.5, -13)
    MenuKeyBtn.BackgroundColor3 = theme.cardHover
    MenuKeyBtn.BorderSizePixel = 0
    MenuKeyBtn.Text = (Keybinds.Menu and Keybinds.Menu ~= Enum.KeyCode.Unknown) and Keybinds.Menu.Name or "Aucun"
    MenuKeyBtn.TextColor3 = theme.accent
    MenuKeyBtn.Font = Enum.Font.GothamBold
    MenuKeyBtn.TextSize = 11
    MenuKeyBtn.ZIndex = 8
    MenuKeyBtn.Parent = MenuKeybindFrame

    makeCorner(MenuKeyBtn, 6)
    local menuBtnStroke = makeStroke(MenuKeyBtn, theme.border, 1)

    local MenuClearBtn = Instance.new("TextButton")
    MenuClearBtn.Size = UDim2.new(0, 26, 0, 26)
    MenuClearBtn.Position = UDim2.new(1, -38, 0.5, -13)
    MenuClearBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 26)
    MenuClearBtn.BorderSizePixel = 0
    MenuClearBtn.Text = "X"
    MenuClearBtn.TextColor3 = Color3.fromRGB(255, 90, 95)
    MenuClearBtn.Font = Enum.Font.GothamBold
    MenuClearBtn.TextSize = 11
    MenuClearBtn.ZIndex = 8
    MenuClearBtn.Parent = MenuKeybindFrame
    makeCorner(MenuClearBtn, 6)
    makeStroke(MenuClearBtn, Color3.fromRGB(140, 45, 55), 1)

    MenuClearBtn.MouseEnter:Connect(function()
        TweenService:Create(MenuClearBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 28, 35)}):Play()
    end)
    MenuClearBtn.MouseLeave:Connect(function()
        TweenService:Create(MenuClearBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 22, 26)}):Play()
    end)
    MenuClearBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        if KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == "Menu" then
            KeybindSystem.Binding = false
            KeybindSystem.BindingName = nil
            KeybindSystem.BindingBtn = nil
        end
        Keybinds.Menu = Enum.KeyCode.Unknown
        MenuKeyBtn.Text = "Aucun"
        MenuKeyBtn.BackgroundColor3 = theme.cardHover
        MenuKeyBtn.TextColor3 = theme.accent
        menuBtnStroke.Color = theme.border
        notify("Settings", "Bind Menu retiré (Insert toujours actif)", Color3.fromRGB(255, 90, 90))
    end)

    KeybindButtons["Menu"] = MenuKeyBtn
    registerSearchCard(MenuKeybindFrame, "Menu Keybind Touche Ouvrir Fermer", SettingsContent)

    MenuKeyBtn.MouseEnter:Connect(function()
        if not (KeybindSystem.Binding and KeybindSystem.BindingName == "Menu") then
            menuBtnStroke.Color = theme.accent
        end
    end)
    MenuKeyBtn.MouseLeave:Connect(function()
        if not (KeybindSystem.Binding and KeybindSystem.BindingName == "Menu") then
            menuBtnStroke.Color = theme.border
        end
    end)

    MenuKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() GuiService.SelectedObject = nil end)
        KeybindSystem.Binding = true
        KeybindSystem.BindingName = "Menu"
        KeybindSystem.BindingBtn = MenuKeyBtn
        MenuKeyBtn.Text = "Press..."
        MenuKeyBtn.BackgroundColor3 = theme.accent
        MenuKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        menuBtnStroke.Color = theme.accent
    end)

    createLabel("CLAVIER & DISPOSITION", SettingsContent)
createToggle("Mode Clavier AZERTY (Touches ZQSD)", true, function(enabled)
    V.KeyboardLayout = enabled and "AZERTY" or "QWERTY"
    notify("Settings", enabled and "Clavier AZERTY (ZQSD) Verrouille" or "Clavier QWERTY Actif", Color3.fromRGB(80, 200, 120))
end, SettingsContent, "KeyboardLayoutSetting")
createLabel("KEYBINDS", SettingsContent)
    local function createKeybindButton(name, defaultKey, callback)
        local KeybindFrame = createCard(SettingsContent, 0, 44)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.55, 0, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = name
        Label.TextColor3 = theme.text
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.ZIndex = 8
        Label.Parent = KeybindFrame

        local KeyBtn = Instance.new("TextButton")
        KeyBtn.Size = UDim2.new(0, 74, 0, 26)
        KeyBtn.Position = UDim2.new(1, -118, 0.5, -13)
        KeyBtn.BackgroundColor3 = theme.cardHover
        KeyBtn.BorderSizePixel = 0
        KeyBtn.Text = (Keybinds[name] and Keybinds[name] ~= Enum.KeyCode.Unknown) and Keybinds[name].Name or ((defaultKey and defaultKey ~= Enum.KeyCode.Unknown) and defaultKey.Name or "Aucun")
        KeyBtn.TextColor3 = theme.accent
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.TextSize = 11
        KeyBtn.ZIndex = 8
        KeyBtn.Parent = KeybindFrame

        makeCorner(KeyBtn, 6)
        local btnStroke = makeStroke(KeyBtn, theme.border, 1)

        local ClearBtn = Instance.new("TextButton")
        ClearBtn.Size = UDim2.new(0, 26, 0, 26)
        ClearBtn.Position = UDim2.new(1, -38, 0.5, -13)
        ClearBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 26)
        ClearBtn.BorderSizePixel = 0
        ClearBtn.Text = "X"
        ClearBtn.TextColor3 = Color3.fromRGB(255, 90, 95)
        ClearBtn.Font = Enum.Font.GothamBold
        ClearBtn.TextSize = 11
        ClearBtn.ZIndex = 8
        ClearBtn.Parent = KeybindFrame
        makeCorner(ClearBtn, 6)
        makeStroke(ClearBtn, Color3.fromRGB(140, 45, 55), 1)

        ClearBtn.MouseEnter:Connect(function()
            TweenService:Create(ClearBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65, 28, 35)}):Play()
        end)
        ClearBtn.MouseLeave:Connect(function()
            TweenService:Create(ClearBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 22, 26)}):Play()
        end)

        ClearBtn.MouseButton1Click:Connect(function()
            pcall(function() GuiService.SelectedObject = nil end)
            if KeybindSystem and KeybindSystem.Binding and KeybindSystem.BindingName == name then
                KeybindSystem.Binding = false
                KeybindSystem.BindingName = nil
                KeybindSystem.BindingBtn = nil
            end
            Keybinds[name] = Enum.KeyCode.Unknown
            KeyBtn.Text = "Aucun"
            KeyBtn.BackgroundColor3 = theme.cardHover
            KeyBtn.TextColor3 = theme.accent
            btnStroke.Color = theme.border
            if KeybindButtons and KeybindButtons[name] and KeybindButtons[name] ~= KeyBtn then
                KeybindButtons[name].Text = "Aucun"
            end
            if MeKeybindButtons and MeKeybindButtons[name] and MeKeybindButtons[name] ~= KeyBtn then
                MeKeybindButtons[name].Text = "Aucun"
            end
            notify("Settings", "Bind " .. name .. " retiré", Color3.fromRGB(255, 90, 90))
        end)

        KeybindCallbacks[name] = callback
        KeybindButtons[name] = KeyBtn

        KeyBtn.MouseEnter:Connect(function()
            if not (KeybindSystem.Binding and KeybindSystem.BindingName == name) then
                btnStroke.Color = theme.accent
            end
        end)
        KeyBtn.MouseLeave:Connect(function()
            if not (KeybindSystem.Binding and KeybindSystem.BindingName == name) then
                btnStroke.Color = theme.border
            end
        end)

        KeyBtn.MouseButton1Click:Connect(function()
            pcall(function() GuiService.SelectedObject = nil end)
            KeybindSystem.Binding = true
            KeybindSystem.BindingName = name
            KeybindSystem.BindingBtn = KeyBtn
            KeyBtn.Text = "Press..."
            KeyBtn.BackgroundColor3 = theme.accent
            KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnStroke.Color = theme.accent
        end)
    end

    createKeybindButton("Fly", Keybinds.Fly, function() toggleFlyAction() end)
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
    createKeybindButton("RecordMovement", Keybinds.RecordMovement, function() toggleMovementRecording() end)
    createKeybindButton("ReplayMovement", Keybinds.ReplayMovement, function() toggleMovementReplaying() end)
    createKeybindButton("VehicleFreeze", Keybinds.VehicleFreeze or Enum.KeyCode.Unknown, function()
        if _G.toggleVehicleFreeze then _G.toggleVehicleFreeze() end
    end)
    createKeybindButton("VehicleDelete", Keybinds.VehicleDelete or Enum.KeyCode.Unknown, function()
        if _G.deleteCurrentVehicle then _G.deleteCurrentVehicle() end
    end)
    createKeybindButton("VehicleInvisible", Keybinds.VehicleInvisible or Enum.KeyCode.Unknown, function()
        if _G.toggleVehicleInvisible then _G.toggleVehicleInvisible() end
    end)
end

createLabel("UNLOAD", SettingsContent)
createButton("Unload le Hub", function()
    performFullUnload()
end, SettingsContent, "Unload", true)

initStep = "cablage Config/Code"
createLabel("CONFIGURATION", ConfigContent)
do
    local ConfigNameBox = Instance.new("TextBox")
    ConfigNameBox.Size = UDim2.new(1, 0, 0, 34)
    ConfigNameBox.BackgroundColor3 = theme.card
    ConfigNameBox.BorderSizePixel = 0
    ConfigNameBox.PlaceholderText = "Nom de la config (ex: Main)"
    ConfigNameBox.PlaceholderColor3 = theme.sub
    ConfigNameBox.Text = "Default"
    ConfigNameBox.TextColor3 = theme.text
    ConfigNameBox.Font = Enum.Font.GothamMedium
    ConfigNameBox.TextSize = 12
    ConfigNameBox.TextXAlignment = Enum.TextXAlignment.Left
    ConfigNameBox.Parent = ConfigContent
    makeCorner(ConfigNameBox, 8)
    makeStroke(ConfigNameBox, theme.border, 1)

    local ConfigNamePadding = Instance.new("UIPadding")
    ConfigNamePadding.PaddingLeft = UDim.new(0, 10)
    ConfigNamePadding.Parent = ConfigNameBox

    local ConfigListFrame = Instance.new("Frame")
    ConfigListFrame.Size = UDim2.new(1, 0, 0, 220)
    ConfigListFrame.Position = UDim2.new(0, 0, 0, 40)
    ConfigListFrame.BackgroundColor3 = theme.panel2
    ConfigListFrame.BorderSizePixel = 0
    ConfigListFrame.Parent = ConfigContent
    makeCorner(ConfigListFrame, 10)
    makeStroke(ConfigListFrame, theme.border, 1)

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

    local function getCurrentTimestamp()
        local okD, dStr = pcall(function() return os.date("%d/%m/%Y %H:%M") end)
        if okD and type(dStr) == "string" and dStr ~= "" then
            return dStr
        end
        local okDT, dtStr = pcall(function()
            return DateTime.now():FormatLocalTime("DD/MM/YYYY HH:mm", "fr-fr")
        end)
        if okDT and type(dtStr) == "string" and dtStr ~= "" then
            return dtStr
        end
        return "N/A"
    end

    local function applyLoadedConfig(cfg, cfgName)
        pcall(function()
            for key, val in pairs(DefaultConfig) do
                if ConfigRegistry[key] then
                    pcall(ConfigRegistry[key], val)
                end
            end
            for key, setter in pairs(ConfigRegistry) do
                if cfg[key] ~= nil then
                    pcall(setter, cfg[key])
                end
            end
            if cfg.Keybinds and type(cfg.Keybinds) == "table" then
                local kb = cfg.Keybinds
                local kbNames = {
                    "Fly", "Noclip", "Invisible", "DesyncFly", "ESP", "Speed", "Respawn", "Menu", "Freecam",
                    "VehicleFly", "VehicleBoost", "InstantBrake", "VehicleSeatTP", "VehicleAutoFlip",
                    "VehicleExplode", "VehiclePropulse", "RecordMovement", "ReplayMovement",
                    "VehicleFreeze", "VehicleDelete", "VehicleInvisible"
                }
                for _, kName in ipairs(kbNames) do
                    local val = kb[kName]
                    if val == "Aucun" or val == "Unknown" then
                        Keybinds[kName] = Enum.KeyCode.Unknown
                    elseif val and Enum.KeyCode[val] then
                        Keybinds[kName] = Enum.KeyCode[val]
                    end
                end
                for bName, bCode in pairs(Keybinds) do
                    if KeybindButtons[bName] then
                        KeybindButtons[bName].Text = (bCode ~= Enum.KeyCode.Unknown) and bCode.Name or "Aucun"
                    end
                    if MeKeybindButtons and MeKeybindButtons[bName] then
                        MeKeybindButtons[bName].Text = (bCode ~= Enum.KeyCode.Unknown) and bCode.Name or "Aucun"
                    end
                end
                if kb.Aimlock then
                    local kName = tostring(kb.Aimlock)
                    _G.Aimlock_KeyName = kName
                    Aimlock_KeyName = kName
                    if kName == "M1" then
                        _G.Aimlock_Key = Enum.UserInputType.MouseButton1
                    elseif kName == "M2" then
                        _G.Aimlock_Key = Enum.UserInputType.MouseButton2
                    elseif kName == "M3" then
                        _G.Aimlock_Key = Enum.UserInputType.MouseButton3
                    elseif Enum.KeyCode[kName] then
                        _G.Aimlock_Key = Enum.KeyCode[kName]
                    end
                    Aimlock_Key = _G.Aimlock_Key
                    if AimlockKeyBtn then
                        AimlockKeyBtn.Text = "[" .. kName .. "]"
                    end
                end
            end
            if writefile then pcall(function() writefile("Pearl_LastConfig.txt", cfgName) end) end
            notify("Config", cfgName .. " chargée avec succès !", Color3.fromRGB(80, 200, 120))
        end)
    end

    local function openConfigInspector(cfgName, parsedCfg, rawContent)
        pcall(function()
            local existing = parentTarget and parentTarget:FindFirstChild("PearlConfigInspector")
            if existing then existing:Destroy() end

            local cfg = parsedCfg
            if not cfg and rawContent then
                local okDec, dec = pcall(function() return HttpService:JSONDecode(rawContent) end)
                if okDec and type(dec) == "table" then cfg = dec end
            end

            local InspGui = Instance.new("ScreenGui")
            InspGui.Name = "PearlConfigInspector"
            InspGui.ResetOnSpawn = false
            InspGui.DisplayOrder = 1050
            InspGui.Parent = parentTarget

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 340, 0, 410)
            Box.Position = UDim2.new(0.5, -170, 0.5, -205)
            Box.BackgroundColor3 = theme.panel
            Box.BorderSizePixel = 0
            Box.Active = true
            Box.Draggable = true
            Box.Parent = InspGui
            makeCorner(Box, 12)
            makeStroke(Box, theme.border, 1.2)

            local TopBarAccent = Instance.new("Frame")
            TopBarAccent.Size = UDim2.new(1, -24, 0, 2)
            TopBarAccent.Position = UDim2.new(0, 12, 0, 0)
            TopBarAccent.BackgroundColor3 = theme.accent
            TopBarAccent.BorderSizePixel = 0
            TopBarAccent.Parent = Box
            makeCorner(TopBarAccent, 2)

            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, -16, 0, 44)
            Header.Position = UDim2.new(0, 8, 0, 8)
            Header.BackgroundColor3 = theme.panel2
            Header.BorderSizePixel = 0
            Header.Parent = Box
            makeCorner(Header, 8)
            makeStroke(Header, theme.border, 1)

            local HTitle = Instance.new("TextLabel")
            HTitle.Size = UDim2.new(1, -42, 0, 18)
            HTitle.Position = UDim2.new(0, 10, 0, 5)
            HTitle.BackgroundTransparency = 1
            HTitle.Text = "CONFIG : " .. tostring(cfgName)
            HTitle.TextColor3 = theme.accent
            HTitle.Font = Enum.Font.GothamBold
            HTitle.TextSize = 12
            HTitle.TextXAlignment = Enum.TextXAlignment.Left
            HTitle.Parent = Header

            local dateText = (cfg and cfg.LastUpdated and cfg.LastUpdated ~= "") and tostring(cfg.LastUpdated) or getCurrentTimestamp()
            local HSub = Instance.new("TextLabel")
            HSub.Size = UDim2.new(1, -42, 0, 14)
            HSub.Position = UDim2.new(0, 10, 0, 23)
            HSub.BackgroundTransparency = 1
            HSub.Text = "Dernière MAJ : " .. dateText
            HSub.TextColor3 = theme.sub
            HSub.Font = Enum.Font.GothamMedium
            HSub.TextSize = 10
            HSub.TextXAlignment = Enum.TextXAlignment.Left
            HSub.Parent = Header

            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Size = UDim2.new(0, 26, 0, 26)
            CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
            CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 22, 28)
            CloseBtn.BorderSizePixel = 0
            CloseBtn.Text = "X"
            CloseBtn.TextColor3 = Color3.fromRGB(255, 90, 95)
            CloseBtn.Font = Enum.Font.GothamBold
            CloseBtn.TextSize = 11
            CloseBtn.Parent = Header
            makeCorner(CloseBtn, 6)
            makeStroke(CloseBtn, Color3.fromRGB(150, 45, 55), 1)
            CloseBtn.MouseButton1Click:Connect(function()
                InspGui:Destroy()
            end)

            local Scroll = Instance.new("ScrollingFrame")
            Scroll.Size = UDim2.new(1, -16, 1, -64)
            Scroll.Position = UDim2.new(0, 8, 0, 58)
            Scroll.BackgroundTransparency = 1
            Scroll.BorderSizePixel = 0
            Scroll.ScrollBarThickness = 2
            Scroll.ScrollBarImageColor3 = theme.accent
            Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Scroll.Parent = Box

            local Layout = Instance.new("UIListLayout")
            Layout.Padding = UDim.new(0, 4)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = Scroll

            local orderIdx = 0
            local function addSectionHeader(txt)
                orderIdx = orderIdx + 1
                local lbl = Instance.new("TextLabel")
                lbl.LayoutOrder = orderIdx
                lbl.Size = UDim2.new(1, 0, 0, 22)
                lbl.BackgroundTransparency = 1
                lbl.Text = "  " .. txt
                lbl.TextColor3 = theme.sub
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 10
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = Scroll
            end

            local function addInfoRow(leftTxt, rightTxt, rightCol)
                orderIdx = orderIdx + 1
                local row = Instance.new("Frame")
                row.LayoutOrder = orderIdx
                row.Size = UDim2.new(1, -4, 0, 26)
                row.BackgroundColor3 = theme.card
                row.BorderSizePixel = 0
                row.Parent = Scroll
                makeCorner(row, 6)

                local l = Instance.new("TextLabel")
                l.Size = UDim2.new(0.62, 0, 1, 0)
                l.Position = UDim2.new(0, 10, 0, 0)
                l.BackgroundTransparency = 1
                l.Text = tostring(leftTxt)
                l.TextColor3 = theme.text
                l.Font = Enum.Font.GothamMedium
                l.TextSize = 11
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.TextTruncate = Enum.TextTruncate.AtEnd
                l.Parent = row

                local r = Instance.new("TextLabel")
                r.Size = UDim2.new(0.35, -10, 1, 0)
                r.Position = UDim2.new(0.65, 0, 0, 0)
                r.BackgroundTransparency = 1
                r.Text = tostring(rightTxt)
                r.TextColor3 = rightCol or theme.accent
                r.Font = Enum.Font.GothamBold
                r.TextSize = 11
                r.TextXAlignment = Enum.TextXAlignment.Right
                r.TextTruncate = Enum.TextTruncate.AtEnd
                r.Parent = row
            end

            if not cfg or type(cfg) ~= "table" then
                addSectionHeader("ERREUR")
                addInfoRow("Impossible de lire le fichier", "Vide", Color3.fromRGB(255, 90, 90))
                return
            end

            addSectionHeader("OPTIONS ACTIVÉES / MODIFIÉES")
            local activeKeys = {}
            for k, v in pairs(cfg) do
                if k ~= "Keybinds" and k ~= "LastUpdated" then
                    if type(v) == "boolean" and v == true then
                        table.insert(activeKeys, { key = k, val = "ON", col = Color3.fromRGB(80, 220, 130) })
                    elseif type(v) == "number" and DefaultConfig[k] ~= nil and v ~= DefaultConfig[k] then
                        table.insert(activeKeys, { key = k, val = tostring(v), col = Color3.fromRGB(110, 185, 255) })
                    elseif type(v) == "string" and DefaultConfig[k] ~= nil and v ~= DefaultConfig[k] then
                        table.insert(activeKeys, { key = k, val = v, col = Color3.fromRGB(225, 210, 255) })
                    end
                end
            end
            table.sort(activeKeys, function(a, b) return a.key < b.key end)
            if #activeKeys == 0 then
                addInfoRow("Aucune option active", "-", theme.sub)
            else
                for _, item in ipairs(activeKeys) do
                    addInfoRow(item.key, item.val, item.col)
                end
            end

            addSectionHeader("KEYBINDS CONFIGURÉS")
            local kbRows = {}
            if type(cfg.Keybinds) == "table" then
                for kName, kVal in pairs(cfg.Keybinds) do
                    local s = tostring(kVal)
                    if s ~= "" and s ~= "Aucun" and s ~= "Unknown" then
                        table.insert(kbRows, { key = kName, val = "[" .. s .. "]" })
                    end
                end
            end
            table.sort(kbRows, function(a, b) return a.key < b.key end)
            if #kbRows == 0 then
                addInfoRow("Aucun bind actif", "-", theme.sub)
            else
                for _, item in ipairs(kbRows) do
                    addInfoRow(item.key, item.val, theme.accent)
                end
            end
        end)
    end

    local function refreshConfigList()
        pcall(function()
            for _, child in pairs(ConfigList:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
            end

            local discoveredConfigs = {}
            local configFiles = {}

            -- 1. Try listfiles with various argument styles
            if listfiles then
                local files = nil
                local ok, res = pcall(function() return listfiles("") end)
                if ok and type(res) == "table" then
                    files = res
                else
                    ok, res = pcall(function() return listfiles(".") end)
                    if ok and type(res) == "table" then
                        files = res
                    else
                        ok, res = pcall(function() return listfiles() end)
                        if ok and type(res) == "table" then
                            files = res
                        end
                    end
                end

                if files then
                    for _, filePath in ipairs(files) do
                        local fileName = string.match(filePath, "([^/\\]+)$") or filePath
                        local cfgName = string.match(fileName, "PearlConfig_(.-)%.json")
                        if cfgName and cfgName ~= "" then
                            discoveredConfigs[cfgName] = true
                            configFiles[cfgName] = filePath
                        end
                    end
                end
            end

            -- 2. Fallback / supplementary index file
            pcall(function()
                if readfile and isfile and isfile("Pearl_ConfigIndex.json") then
                    local idxRaw = readfile("Pearl_ConfigIndex.json")
                    local ok, data = pcall(function() return HttpService:JSONDecode(idxRaw) end)
                    if ok and type(data) == "table" then
                        for _, name in ipairs(data) do
                            if type(name) == "string" and name ~= "" then
                                local fname = "PearlConfig_" .. name .. ".json"
                                local fileExists = true
                                if isfile then
                                    local okCheck, exists = pcall(function() return isfile(fname) end)
                                    if okCheck then fileExists = exists end
                                end
                                if fileExists then
                                    discoveredConfigs[name] = true
                                    if not configFiles[name] then
                                        configFiles[name] = fname
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            -- Also check default config file
            pcall(function()
                if isfile and isfile("PearlConfig_Default.json") then
                    discoveredConfigs["Default"] = true
                    if not configFiles["Default"] then
                        configFiles["Default"] = "PearlConfig_Default.json"
                    end
                end
            end)

            local hasConfigs = false
            for cfgName, _ in pairs(discoveredConfigs) do
                hasConfigs = true
                local filePath = configFiles[cfgName] or ("PearlConfig_" .. cfgName .. ".json")
                local rawContent = nil
                local parsedCfg = nil
                pcall(function()
                    if readfile then
                        local okR, dR = pcall(function() return readfile(filePath) end)
                        if not okR or not dR then
                            okR, dR = pcall(function() return readfile("PearlConfig_" .. cfgName .. ".json") end)
                        end
                        if okR and dR then
                            rawContent = dR
                            local okDec, dec = pcall(function() return HttpService:JSONDecode(dR) end)
                            if okDec and type(dec) == "table" then parsedCfg = dec end
                        end
                    end
                end)
                local lastUpd = nil
                if parsedCfg and parsedCfg.LastUpdated and parsedCfg.LastUpdated ~= "" then
                    lastUpd = tostring(parsedCfg.LastUpdated)
                else
                    lastUpd = getCurrentTimestamp()
                    if parsedCfg then
                        parsedCfg.LastUpdated = lastUpd
                        if writefile then
                            pcall(function()
                                local updatedJson = HttpService:JSONEncode(parsedCfg)
                                rawContent = updatedJson
                                writefile(filePath, updatedJson)
                            end)
                        end
                    end
                end

                local CfgFrame = Instance.new("Frame")
                CfgFrame.Size = UDim2.new(1, 0, 0, 48)
                CfgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                CfgFrame.BorderSizePixel = 0
                CfgFrame.Parent = ConfigList

                local CfgCorner = Instance.new("UICorner")
                CfgCorner.CornerRadius = UDim.new(0, 8)
                CfgCorner.Parent = CfgFrame

                local CfgLabel = Instance.new("TextLabel")
                CfgLabel.Size = UDim2.new(1, -242, 0, 18)
                CfgLabel.Position = UDim2.new(0, 10, 0, 5)
                CfgLabel.BackgroundTransparency = 1
                CfgLabel.Text = cfgName
                CfgLabel.TextColor3 = Color3.fromRGB(195, 195, 208)
                CfgLabel.Font = Enum.Font.GothamMedium
                CfgLabel.TextSize = 12
                CfgLabel.TextXAlignment = Enum.TextXAlignment.Left
                CfgLabel.TextTruncate = Enum.TextTruncate.AtEnd
                CfgLabel.Parent = CfgFrame

                local DateLabel = Instance.new("TextLabel")
                DateLabel.Size = UDim2.new(1, -242, 0, 16)
                DateLabel.Position = UDim2.new(0, 10, 0, 24)
                DateLabel.BackgroundTransparency = 1
                DateLabel.Text = "MAJ : " .. lastUpd
                DateLabel.TextColor3 = Color3.fromRGB(130, 134, 152)
                DateLabel.Font = Enum.Font.Gotham
                DateLabel.TextSize = 10
                DateLabel.TextXAlignment = Enum.TextXAlignment.Left
                DateLabel.TextTruncate = Enum.TextTruncate.AtEnd
                DateLabel.Parent = CfgFrame

                local InfoBtn = Instance.new("TextButton")
                InfoBtn.Size = UDim2.new(0, 26, 0, 26)
                InfoBtn.Position = UDim2.new(1, -226, 0.5, -13)
                InfoBtn.BackgroundColor3 = Color3.fromRGB(32, 28, 52)
                InfoBtn.BorderSizePixel = 0
                InfoBtn.Text = "?"
                InfoBtn.TextColor3 = theme.accent
                InfoBtn.Font = Enum.Font.GothamBold
                InfoBtn.TextSize = 12
                InfoBtn.Parent = CfgFrame
                makeCorner(InfoBtn, 5)
                makeStroke(InfoBtn, theme.accent, 1)

                InfoBtn.MouseEnter:Connect(function()
                    TweenService:Create(InfoBtn, TweenInfo.new(0.2), {BackgroundColor3 = theme.accent, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                end)
                InfoBtn.MouseLeave:Connect(function()
                    TweenService:Create(InfoBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 28, 52), TextColor3 = theme.accent}):Play()
                end)
                InfoBtn.MouseButton1Click:Connect(function()
                    openConfigInspector(cfgName, parsedCfg, rawContent)
                end)

                local LoadBtn = Instance.new("TextButton")
                LoadBtn.Size = UDim2.new(0, 42, 0, 26)
                LoadBtn.Position = UDim2.new(1, -195, 0.5, -13)
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
                    local content = nil
                    if readfile then
                        local ok, data = pcall(function() return readfile(filePath) end)
                        if ok and data then
                            content = data
                        else
                            local ok2, data2 = pcall(function() return readfile("PearlConfig_" .. cfgName .. ".json") end)
                            if ok2 and data2 then content = data2 end
                        end
                    end
                    if content then
                        local okDecode, cfg = pcall(function() return HttpService:JSONDecode(content) end)
                        if okDecode and type(cfg) == "table" then
                            applyLoadedConfig(cfg, cfgName)
                        else
                            notify("Config", "Erreur décodage JSON pour " .. cfgName, Color3.fromRGB(255, 90, 90))
                        end
                    else
                        notify("Config", "Impossible de lire " .. cfgName, Color3.fromRGB(255, 90, 90))
                    end
                end)

                local ExportBtn = Instance.new("TextButton")
                ExportBtn.Size = UDim2.new(0, 44, 0, 26)
                ExportBtn.Position = UDim2.new(1, -148, 0.5, -13)
                ExportBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
                ExportBtn.BorderSizePixel = 0
                ExportBtn.Text = "Export"
                ExportBtn.TextColor3 = Color3.fromRGB(195, 195, 208)
                ExportBtn.Font = Enum.Font.GothamMedium
                ExportBtn.TextSize = 11
                ExportBtn.Parent = CfgFrame

                local ExpCorner = Instance.new("UICorner")
                ExpCorner.CornerRadius = UDim.new(0, 5)
                ExpCorner.Parent = ExportBtn

                ExportBtn.MouseButton1Click:Connect(function()
                    local content = nil
                    if readfile then
                        local ok, data = pcall(function() return readfile(filePath) end)
                        if ok and data then content = data
                        else
                            local ok2, data2 = pcall(function() return readfile("PearlConfig_" .. cfgName .. ".json") end)
                            if ok2 and data2 then content = data2 end
                        end
                    end
                    if content and setclipboard then
                        pcall(function() setclipboard(content) end)
                        notify("Config", "Config copiée dans le presse-papier !", Color3.fromRGB(80, 200, 120))
                    else
                        notify("Config", "Presse-papier non supporté ou fichier vide.", Color3.fromRGB(255, 90, 90))
                    end
                end)

                local UnloadBtn = Instance.new("TextButton")
                UnloadBtn.Size = UDim2.new(0, 46, 0, 26)
                UnloadBtn.Position = UDim2.new(1, -99, 0.5, -13)
                UnloadBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 22)
                UnloadBtn.BorderSizePixel = 0
                UnloadBtn.Text = "Unload"
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
                            pcall(ConfigRegistry[key], val)
                        end
                    end
                    Keybinds.Fly = Enum.KeyCode.F
                    Keybinds.Noclip = Enum.KeyCode.V
                    Keybinds.Invisible = Enum.KeyCode.C
                    Keybinds.DesyncFly = Enum.KeyCode.G
                    Keybinds.ESP = Enum.KeyCode.M
                    Keybinds.Speed = Enum.KeyCode.R
                    Keybinds.Respawn = Enum.KeyCode.B
                    Keybinds.Menu = Enum.KeyCode.Insert
                    Keybinds.Freecam = Enum.KeyCode.X
                    Keybinds.VehicleFly = Enum.KeyCode.H
                    Keybinds.VehicleBoost = Enum.KeyCode.T
                    Keybinds.InstantBrake = Enum.KeyCode.N
                    Keybinds.RecordMovement = Enum.KeyCode.Y
                    Keybinds.ReplayMovement = Enum.KeyCode.O
                    _G.Aimlock_Key = nil
                    _G.Aimlock_KeyName = "Aucun"
                    Aimlock_Key = nil
                    Aimlock_KeyName = "Aucun"
                    if AimlockKeyBtn then AimlockKeyBtn.Text = "[Aucun]" end
                    for name, btn in pairs(KeybindButtons) do
                        if Keybinds[name] then
                            btn.Text = (Keybinds[name] ~= Enum.KeyCode.Unknown) and Keybinds[name].Name or "Aucun"
                        end
                    end
                    if MeKeybindButtons then
                        for name, btn in pairs(MeKeybindButtons) do
                            if Keybinds[name] then
                                btn.Text = (Keybinds[name] ~= Enum.KeyCode.Unknown) and Keybinds[name].Name or "Aucun"
                            end
                        end
                    end
                    notify("Config", "Config déchargée (Paramètres par défaut) !", Color3.fromRGB(255, 165, 0))
                end)

                local DelBtn = Instance.new("TextButton")
                DelBtn.Size = UDim2.new(0, 46, 0, 26)
                DelBtn.Position = UDim2.new(1, -49, 0.5, -13)
                DelBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 22)
                DelBtn.BorderSizePixel = 0
                DelBtn.Text = "Delete"
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
                        pcall(function() delfile(filePath) end)
                        pcall(function() delfile("PearlConfig_" .. cfgName .. ".json") end)
                    end
                    pcall(function()
                        if readfile and isfile and isfile("Pearl_ConfigIndex.json") and writefile then
                            local idxRaw = readfile("Pearl_ConfigIndex.json")
                            local ok, data = pcall(function() return HttpService:JSONDecode(idxRaw) end)
                            if ok and type(data) == "table" then
                                local newIdx = {}
                                for _, n in ipairs(data) do
                                    if n ~= cfgName then table.insert(newIdx, n) end
                                end
                                writefile("Pearl_ConfigIndex.json", HttpService:JSONEncode(newIdx))
                            end
                        end
                    end)
                    notify("Config", cfgName .. " supprimée !", Color3.fromRGB(255, 90, 90))
                    pcall(refreshConfigList)
                end)
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
        end)
    end

    local function saveConfig(customName)
        local cfgName = customName or ConfigNameBox.Text
        if not cfgName or cfgName:gsub("%s+", "") == "" then cfgName = "Default" end
        cfgName = cfgName:gsub("[^%w_%-%s]", "")
        if cfgName == "" then cfgName = "Default" end
        local fileName = "PearlConfig_" .. cfgName .. ".json"

        local success, err = pcall(function()
            local cfg = {}
            cfg.LastUpdated = getCurrentTimestamp()
            for key, val in pairs(DefaultConfig) do
                if V[key] ~= nil then
                    cfg[key] = V[key]
                else
                    cfg[key] = val
                end
            end
            for key, _ in pairs(ConfigRegistry) do
                if V[key] ~= nil then
                    cfg[key] = V[key]
                end
            end

            local function getBindName(bind, fallback)
                if typeof(bind) == "EnumItem" then
                    return bind.Name
                elseif type(bind) == "string" then
                    return bind
                end
                return fallback
            end

            local function getBindNameClean(bind, fallback)
                if typeof(bind) == "EnumItem" then
                    if bind == Enum.KeyCode.Unknown then return "Aucun" end
                    return bind.Name
                elseif type(bind) == "string" then
                    return bind
                end
                return fallback or "Aucun"
            end

            cfg.Keybinds = {
                Fly = getBindNameClean(Keybinds.Fly),
                Noclip = getBindNameClean(Keybinds.Noclip),
                Invisible = getBindNameClean(Keybinds.Invisible),
                DesyncFly = getBindNameClean(Keybinds.DesyncFly),
                ESP = getBindNameClean(Keybinds.ESP),
                Speed = getBindNameClean(Keybinds.Speed),
                Respawn = getBindNameClean(Keybinds.Respawn),
                Menu = getBindNameClean(Keybinds.Menu, "Insert"),
                Freecam = getBindNameClean(Keybinds.Freecam),
                VehicleFly = getBindNameClean(Keybinds.VehicleFly),
                VehicleBoost = getBindNameClean(Keybinds.VehicleBoost),
                InstantBrake = getBindNameClean(Keybinds.InstantBrake),
                VehicleSeatTP = getBindNameClean(Keybinds.VehicleSeatTP),
                VehicleAutoFlip = getBindNameClean(Keybinds.VehicleAutoFlip),
                VehicleExplode = getBindNameClean(Keybinds.VehicleExplode),
                VehiclePropulse = getBindNameClean(Keybinds.VehiclePropulse),
                RecordMovement = getBindNameClean(Keybinds.RecordMovement),
                ReplayMovement = getBindNameClean(Keybinds.ReplayMovement),
                VehicleFreeze = getBindNameClean(Keybinds.VehicleFreeze),
                VehicleDelete = getBindNameClean(Keybinds.VehicleDelete),
                VehicleInvisible = getBindNameClean(Keybinds.VehicleInvisible),
                Aimlock = tostring(_G.Aimlock_KeyName or Aimlock_KeyName or "Aucun")
            }

            if writefile then
                local encoded = HttpService:JSONEncode(cfg)
                writefile(fileName, encoded)
                pcall(function() writefile("Pearl_LastConfig.txt", cfgName) end)

                pcall(function()
                    local index = {}
                    if isfile and isfile("Pearl_ConfigIndex.json") and readfile then
                        local idxRaw = readfile("Pearl_ConfigIndex.json")
                        local ok, data = pcall(function() return HttpService:JSONDecode(idxRaw) end)
                        if ok and type(data) == "table" then index = data end
                    end
                    local found = false
                    for _, n in ipairs(index) do
                        if n == cfgName then found = true break end
                    end
                    if not found then table.insert(index, cfgName) end
                    writefile("Pearl_ConfigIndex.json", HttpService:JSONEncode(index))
                end)

                if not customName then
                    notify("Config", "Config '" .. cfgName .. "' sauvegardée avec succès !", Color3.fromRGB(80, 200, 120))
                end
                pcall(refreshConfigList)
            else
                if not customName then
                    notify("Config", "writefile non supporté par l'exécuteur.", Color3.fromRGB(255, 90, 90))
                end
            end
        end)

        if not success then
            notify("Config", "Erreur sauvegarde : " .. tostring(err):sub(1, 40), Color3.fromRGB(255, 90, 90))
        end
    end
    _G.savePearlConfig = saveConfig

    local function loadConfigByName(cfgName)
        local fileName = "PearlConfig_" .. cfgName .. ".json"
        local content = nil
        if readfile then
            local ok, data = pcall(function() return readfile(fileName) end)
            if ok and data then content = data end
        end
        if content then
            local okDecode, cfg = pcall(function() return HttpService:JSONDecode(content) end)
            if okDecode and type(cfg) == "table" then
                applyLoadedConfig(cfg, cfgName)
            end
        end
    end
    _G.loadPearlConfigByName = loadConfigByName

    createButton("Save Config", function() saveConfig() end, ConfigContent)

    createButton("Importer Config", function()
        local ImportGui = Instance.new("ScreenGui")
        ImportGui.Name = "PearlImportGui"
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
        Title.Text = "IMPORTER UNE CONFIG"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = MainFrame

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, -20, 0, 20)
        NameLabel.Position = UDim2.new(0, 10, 0, 35)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = "Nom de la config:"
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
        NameBox.Text = "Imported"
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
        BoxLabel.Text = "Code JSON:"
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
        Box.PlaceholderText = "Colle le code JSON ici..."
        Box.Parent = MainFrame
        local BC = Instance.new("UICorner", Box)
        BC.CornerRadius = UDim.new(0, 6)

        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0.5, -10, 0, 30)
        CloseBtn.Position = UDim2.new(0, 10, 1, -40)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
        CloseBtn.Text = "Annuler"
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
        SaveBtn.Text = "Sauvegarder"
        SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SaveBtn.Font = Enum.Font.GothamBold
        SaveBtn.TextSize = 12
        SaveBtn.Parent = MainFrame
        local SC = Instance.new("UICorner", SaveBtn)
        SC.CornerRadius = UDim.new(0, 6)

        SaveBtn.MouseButton1Click:Connect(function()
            if writefile and Box.Text ~= "" then
                local cfgName = NameBox.Text
                if not cfgName or cfgName:gsub("%s+", "") == "" then cfgName = "Imported" end
                cfgName = cfgName:gsub("[^%w_%-%s]", "")
                if cfgName == "" then cfgName = "Imported" end
                local fileName = "PearlConfig_" .. cfgName .. ".json"
                
                local ok, err = pcall(function()
                    writefile(fileName, Box.Text)
                    pcall(function()
                        local index = {}
                        if isfile and isfile("Pearl_ConfigIndex.json") and readfile then
                            local idxRaw = readfile("Pearl_ConfigIndex.json")
                            local ok2, data = pcall(function() return HttpService:JSONDecode(idxRaw) end)
                            if ok2 and type(data) == "table" then index = data end
                        end
                        local found = false
                        for _, n in ipairs(index) do
                            if n == cfgName then found = true break end
                        end
                        if not found then table.insert(index, cfgName) end
                        writefile("Pearl_ConfigIndex.json", HttpService:JSONEncode(index))
                    end)
                    notify("Config", "Config importée : " .. cfgName, Color3.fromRGB(80, 200, 120))
                    pcall(refreshConfigList)
                    ImportGui:Destroy()
                end)
                if not ok then
                    notify("Config", "Erreur import : " .. tostring(err):sub(1, 40), Color3.fromRGB(255, 90, 90))
                end
            else
                notify("Config", "Erreur: Ecriture non supportée ou vide.", Color3.fromRGB(255, 90, 90))
            end
        end)
    end, ConfigContent)

    pcall(refreshConfigList)
end

V.SolaraBypassEnabled = true
V.SpoofedExecutorName = "Matcha"
V.SpoofedExecutorVer = "v3.0.0"
V.AntiCrashSandbox = true
V.AntiTelemetryEnabled = true
V.LuaTurboBooster = true
V.VirtualSecurityIdentity = true
V.AutoBypassFilters = true

function applyGlobalSolaraBypass()
    pcall(function()
        local spoofName = V.SpoofedExecutorName or "Matcha"
        local spoofVer = V.SpoofedExecutorVer or "v3.0.0"
        local g = (getgenv and pcall(getgenv) and getgenv()) or _G

        pcall(function() if setreadonly then setreadonly(g, false) end end)
        pcall(function() if make_writeable then make_writeable(g) end end)

        pcall(function()
            if hookfunction and rawget(g, "identifyexecutor") then
                hookfunction(rawget(g, "identifyexecutor"), function() return spoofName, spoofVer end)
            end
            if hookfunction and rawget(g, "getexecutorname") then
                hookfunction(rawget(g, "getexecutorname"), function() return spoofName end)
            end
        end)

        g.identifyexecutor = function() return spoofName, spoofVer end
        g.getexecutorname = function() return spoofName end
        g.whatexecutor = g.identifyexecutor

        _G.identifyexecutor = g.identifyexecutor
        _G.getexecutorname = g.getexecutorname
        _G.whatexecutor = g.identifyexecutor

        if shared then
            shared.identifyexecutor = g.identifyexecutor
            shared.getexecutorname = g.getexecutorname
            shared.whatexecutor = g.identifyexecutor
        end

        pcall(function()
            local f = getfenv(0)
            if f then
                f.identifyexecutor = g.identifyexecutor
                f.getexecutorname = g.getexecutorname
                f.whatexecutor = g.identifyexecutor
            end
        end)

        if not g.checkcaller then g.checkcaller = function() return true end end
        if not g.isexecutorclosure then g.isexecutorclosure = function() return true end end
        if not g.isourclosure then g.isourclosure = function() return true end end
        if not g.newcclosure then g.newcclosure = function(f) return f end end
        if not g.cloneref then g.cloneref = function(r) return r end end
        if not g.clonefunction then g.clonefunction = function(f) return function(...) return f(...) end end end
        if not g.compareinstances then g.compareinstances = function(a, b) return a == b end end

        if not g.getrawmetatable then
            g.getrawmetatable = function(t)
                local ok, res = pcall(function() return (debug and debug.getmetatable and debug.getmetatable(t)) or getmetatable(t) end)
                return (ok and res) or {}
            end
        end
        if not g.setrawmetatable then
            g.setrawmetatable = function(t, mt)
                local ok, res = pcall(function() return (debug and debug.setmetatable and debug.setmetatable(t, mt)) or setmetatable(t, mt) end)
                return (ok and res) or t
            end
        end
        if not g.setreadonly then g.setreadonly = function(t, ro) return t end end
        if not g.isreadonly then g.isreadonly = function(t) return false end end
        if not g.make_writeable then g.make_writeable = function(t) return t end end
        if not g.make_readonly then g.make_readonly = function(t) return t end end
        if not g.hookfunction then g.hookfunction = function(o, n) return o end end
        if not g.replaceclosure then g.replaceclosure = function(o, n) return o end end
        if not g.hookmetamethod then
            g.hookmetamethod = function(obj, m, hook)
                local mt = g.getrawmetatable(obj)
                if mt and type(mt) == "table" then
                    local old = mt[m]
                    pcall(function() mt[m] = hook end)
                    return old or function() end
                end
                return function() end
            end
        end
        if not g.getnamecallmethod then g.getnamecallmethod = function() return "" end end
        if not g.setnamecallmethod then g.setnamecallmethod = function(m) end end

        if not g.getinstances then g.getinstances = function() return game:GetDescendants() end end
        if not g.getnilinstances then g.getnilinstances = function() return {} end end
        if not g.getscripts then
            g.getscripts = function()
                local s = {}
                for _, v in ipairs(game:GetDescendants()) do
                    if v:IsA("LocalScript") or v:IsA("ModuleScript") then table.insert(s, v) end
                end
                return s
            end
        end
        if not g.getrunningscripts then g.getrunningscripts = g.getscripts end
        if not g.getloadedmodules then g.getloadedmodules = function() return {} end end
        if not g.getgc then g.getgc = function() return {} end end
        if not g.getreg then g.getreg = function() return {} end end

        if not g.Drawing then
            g.Drawing = {
                new = function(dtype)
                    local obj = {
                        Visible = false,
                        ZIndex = 1,
                        Transparency = 1,
                        Color = Color3.new(1, 1, 1),
                        Remove = function() end,
                        Destroy = function() end
                    }
                    if dtype == "Line" then
                        obj.From = Vector2.new(0, 0)
                        obj.To = Vector2.new(0, 0)
                        obj.Thickness = 1
                    elseif dtype == "Circle" then
                        obj.Radius = 10
                        obj.Position = Vector2.new(0, 0)
                        obj.Thickness = 1
                        obj.Filled = false
                        obj.NumSides = 16
                    elseif dtype == "Square" then
                        obj.Size = Vector2.new(0, 0)
                        obj.Position = Vector2.new(0, 0)
                        obj.Thickness = 1
                        obj.Filled = false
                    elseif dtype == "Text" then
                        obj.Text = ""
                        obj.Size = 14
                        obj.Center = false
                        obj.Outline = false
                        obj.OutlineColor = Color3.new(0, 0, 0)
                        obj.Position = Vector2.new(0, 0)
                        obj.TextBounds = Vector2.new(0, 0)
                    end
                    return obj
                end,
                Fonts = { UI = 0, System = 1, Plex = 2, Monospace = 3 }
            }
        end

        if not g.fireclickdetector then
            g.fireclickdetector = function(cd)
                pcall(function()
                    if cd and cd:IsA("ClickDetector") and LocalPlayer then
                        cd.MouseClick:Fire(LocalPlayer)
                    end
                end)
            end
        end
        if not g.fireproximityprompt then
            g.fireproximityprompt = function(pp)
                pcall(function()
                    if pp and pp:IsA("ProximityPrompt") then
                        pp:InputHoldBegin()
                        task.wait(pp.HoldDuration or 0.1)
                        pp:InputHoldEnd()
                    end
                end)
            end
        end
        if not g.firetouchinterest then
            g.firetouchinterest = function(p1, p2)
                pcall(function() if p1 and p2 then p1.CFrame = p2.CFrame end end)
            end
        end

        if not g.setclipboard then
            g.setclipboard = function(t)
                local cl = rawget(getfenv(0), "setclipboard") or rawget(getfenv(0), "toclipboard")
                if cl then cl(tostring(t)) end
            end
        end
        if not g.toclipboard then g.toclipboard = g.setclipboard end
        if not g.getclipboard then g.getclipboard = function() return "" end end

        if not g.syn then
            g.syn = {
                request = g.request or rawget(getfenv(0), "request") or rawget(getfenv(0), "http_request"),
                protect_gui = function(gui)
                    pcall(function()
                        if gethui then gui.Parent = gethui()
                        elseif CoreGui then gui.Parent = CoreGui end
                    end)
                end,
                unprotect_gui = function(gui) end,
                is_cached = function() return false end,
                cache_replace = function() end,
                cache_invalidate = function() end,
                set_thread_identity = function(id) end,
                get_thread_identity = function() return 8 end,
                queue_on_teleport = function(code)
                    local q = rawget(getfenv(0), "queue_on_teleport")
                    if q then q(code) end
                end
            }
        end
        if not g.queue_on_teleport and g.syn then g.queue_on_teleport = g.syn.queue_on_teleport end
        if not g.getthreadidentity then g.getthreadidentity = function() return 8 end end
        if not g.setthreadidentity then g.setthreadidentity = function() end end

        if not g.crypt then
            local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
            local function b64encode(data)
                return ((data:gsub(".", function(x) 
                    local r,b="",x:byte()
                    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and "1" or "0") end
                    return r
                end).."0000"):gsub("%d%d%d?%d?%d?", function(x)
                    if (#x < 6) then return "" end
                    local c=0
                    for i=1,6 do c=c+(x:sub(i,i)=="1" and 2^(6-i) or 0) end
                    return b64chars:sub(c+1,c+1)
                end)..({ "", "==", "=" })[#data%3+1])
            end
            local function b64decode(data)
                data = string.gsub(data, "[^"..b64chars.."=]", "")
                return (data:gsub(".", function(x)
                    if (x == "=") then return "" end
                    local r,f="",(b64chars:find(x)-1)
                    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and "1" or "0") end
                    return r
                end):gsub("%d%d%d%d%d%d%d%d", function(x)
                    local c=0
                    for i=1,8 do c=c+(x:sub(i,i)=="1" and 2^(8-i) or 0) end
                    return string.char(c)
                end))
            end
            g.base64_encode = b64encode
            g.base64_decode = b64decode
            g.base64 = { encode = b64encode, decode = b64decode }
            g.crypt = {
                base64_encode = b64encode,
                base64_decode = b64decode,
                base64encode = b64encode,
                base64decode = b64decode,
                base64 = { encode = b64encode, decode = b64decode },
                encrypt = function(d) return d end,
                decrypt = function(d) return d end,
                generatebytes = function(len) return string.rep("x", len or 16) end,
                generatekey = function() return string.rep("k", 32) end,
                hash = function(d) return tostring(#d * 31337) end
            }
        end
    end)
end
applyGlobalSolaraBypass()

-- ====================================================================
-- ====================================================================
-- ====================================================================
-- CATEGORIE CODE : STUDIO DEVELOPPEUR LUA REEL (EXECUTOR & TOOLS)
-- ====================================================================
do
-- ====================================================================
-- CATEGORIE CODE : STUDIO DEVELOPPEUR LUA REEL (EXECUTOR & TOOLS)
-- ====================================================================
local consoleEntries = {}
local consoleScrollFrame = nil
local consoleCountLabel = nil

local function logToDevConsole(msg, col)
    local timestamp = os.date("%H:%M:%S")
    local entry = { time = timestamp, text = tostring(msg), color = col or Color3.fromRGB(225, 225, 238) }
    table.insert(consoleEntries, entry)
    if #consoleEntries > 120 then table.remove(consoleEntries, 1) end

    if consoleCountLabel then
        consoleCountLabel.Text = tostring(#consoleEntries) .. " LOGS"
    end

    if consoleScrollFrame then
        local lineFrame = Instance.new("Frame")
        lineFrame.Size = UDim2.new(1, -6, 0, 18)
        lineFrame.BackgroundTransparency = 1
        lineFrame.BorderSizePixel = 0
        lineFrame.LayoutOrder = #consoleEntries
        lineFrame.Parent = consoleScrollFrame

        local timeLbl = Instance.new("TextLabel")
        timeLbl.Size = UDim2.new(0, 58, 1, 0)
        timeLbl.Position = UDim2.new(0, 4, 0, 0)
        timeLbl.BackgroundTransparency = 1
        timeLbl.Text = "[" .. timestamp .. "]"
        timeLbl.TextColor3 = Color3.fromRGB(110, 115, 135)
        timeLbl.Font = Enum.Font.Code
        timeLbl.TextSize = 10.5
        timeLbl.TextXAlignment = Enum.TextXAlignment.Left
        timeLbl.Parent = lineFrame

        local msgLbl = Instance.new("TextLabel")
        msgLbl.Size = UDim2.new(1, -66, 1, 0)
        msgLbl.Position = UDim2.new(0, 64, 0, 0)
        msgLbl.BackgroundTransparency = 1
        msgLbl.Text = tostring(msg)
        msgLbl.TextColor3 = entry.color
        msgLbl.Font = Enum.Font.Code
        msgLbl.TextSize = 11
        msgLbl.TextXAlignment = Enum.TextXAlignment.Left
        msgLbl.TextTruncate = Enum.TextTruncate.AtEnd
        msgLbl.Parent = lineFrame

        consoleScrollFrame.CanvasPosition = Vector2.new(0, 999999)
    end
end

function executeCodeWithSandbox(codeToRun)
    if not codeToRun or codeToRun == "" or codeToRun:match("^%s*$") then
        notify("Code", "Aucun code a executer !", Color3.fromRGB(255, 165, 0))
        logToDevConsole("[WARN] Aucun code fourni.", Color3.fromRGB(255, 165, 0))
        return false, "No code"
    end

    local startTime = tick()
    local loader = loadstring
    if not loader and getfenv then
        pcall(function() loader = getfenv().loadstring end)
    end
    if not loader then
        notify("Code", "loadstring non supporte sur cet environnement.", Color3.fromRGB(255, 90, 90))
        logToDevConsole("[FATAL] loadstring() indisponible.", Color3.fromRGB(255, 90, 90))
        return false, "loadstring unavailable"
    end

    local func, syntaxErr = loader(codeToRun)
    if not func then
        local errText = tostring(syntaxErr or "Syntax error")
        notify("Code", "Erreur Syntaxe : " .. errText:sub(1, 50), Color3.fromRGB(255, 90, 90))
        logToDevConsole("[SYNTAX ERR] " .. errText, Color3.fromRGB(255, 80, 80))
        return false, errText
    end

    local success, res = pcall(func)
    local elapsed = math.floor((tick() - startTime) * 1000)

    if success then
        notify("Code", "Succes (" .. tostring(elapsed) .. " ms) !", Color3.fromRGB(80, 200, 120))
        logToDevConsole("[OK " .. tostring(elapsed) .. "ms] Execution terminee sans erreur.", Color3.fromRGB(80, 220, 120))
        if res ~= nil then
            logToDevConsole("[RETOUR] " .. tostring(res), Color3.fromRGB(165, 140, 255))
        end
        return true, "Succes (" .. tostring(elapsed) .. " ms)"
    else
        local errStr = tostring(res or "Runtime error")
        notify("Code", "Erreur Runtime : " .. errStr:sub(1, 50), Color3.fromRGB(255, 90, 90))
        logToDevConsole("[RUNTIME ERR] " .. errStr, Color3.fromRGB(255, 90, 90))
        return false, errStr
    end
end

initStep = "cablage Code Studio"

-- SECTION 1 : EDITEUR LUA EN DIRECT
createLabel("EDITEUR LUA & CONSOLE EN TEMPS REEL", CodeContent)

do
    local editorCard = Instance.new("Frame")
    editorCard.Size = UDim2.new(1, 0, 0, 200)
    editorCard.BackgroundColor3 = Color3.fromRGB(16, 17, 24)
    editorCard.BorderSizePixel = 0
    editorCard.Parent = CodeContent
    makeCorner(editorCard, 10)
    makeStroke(editorCard, theme.border or Color3.fromRGB(38, 40, 56), 1)

    local editorTop = Instance.new("Frame")
    editorTop.Size = UDim2.new(1, 0, 0, 28)
    editorTop.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    editorTop.BorderSizePixel = 0
    editorTop.Parent = editorCard
    makeCorner(editorTop, 10)

    local editorTitle = Instance.new("TextLabel")
    editorTitle.Size = UDim2.new(1, -20, 1, 0)
    editorTitle.Position = UDim2.new(0, 10, 0, 0)
    editorTitle.BackgroundTransparency = 1
    editorTitle.Text = "SCRIPT EDITOR (LUA)"
    editorTitle.TextColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
    editorTitle.Font = Enum.Font.GothamBold
    editorTitle.TextSize = 10.5
    editorTitle.TextXAlignment = Enum.TextXAlignment.Left
    editorTitle.Parent = editorTop

    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, -16, 0, 160)
    CodeBox.Position = UDim2.new(0, 8, 0, 34)
    CodeBox.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
    CodeBox.BorderSizePixel = 0
    CodeBox.Text = ""
    CodeBox.PlaceholderText = "-- Saisis ou colle ton script Lua ici...\\nprint('Hello from Pearl Dev Studio !')"
    CodeBox.PlaceholderColor3 = Color3.fromRGB(90, 95, 115)
    CodeBox.TextColor3 = Color3.fromRGB(225, 225, 240)
    CodeBox.Font = Enum.Font.Code
    CodeBox.TextSize = 12
    CodeBox.TextWrapped = true
    CodeBox.MultiLine = true
    CodeBox.ClearTextOnFocus = false
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.Parent = editorCard
    makeCorner(CodeBox, 6)
    makeStroke(CodeBox, Color3.fromRGB(28, 30, 42), 1)

    local boxPad = Instance.new("UIPadding")
    boxPad.PaddingLeft = UDim.new(0, 8)
    boxPad.PaddingRight = UDim.new(0, 8)
    boxPad.PaddingTop = UDim.new(0, 8)
    boxPad.PaddingBottom = UDim.new(0, 8)
    boxPad.Parent = CodeBox

    -- BARRE D'ACTIONS RAPIDES (SANS EMOJIS)
    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, 0, 0, 34)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = CodeContent

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0, 6)
    btnLayout.Parent = btnRow

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0.40, -4, 1, 0)
    runBtn.BackgroundColor3 = Color3.fromRGB(38, 95, 55)
    runBtn.BorderSizePixel = 0
    runBtn.Text = "EXECUTER"
    runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    runBtn.Font = Enum.Font.GothamBold
    runBtn.TextSize = 11
    runBtn.Parent = btnRow
    makeCorner(runBtn, 7)
    makeStroke(runBtn, Color3.fromRGB(60, 180, 90), 1)

    local pasteBtn = Instance.new("TextButton")
    pasteBtn.Size = UDim2.new(0.35, -4, 1, 0)
    pasteBtn.BackgroundColor3 = Color3.fromRGB(32, 34, 48)
    pasteBtn.BorderSizePixel = 0
    pasteBtn.Text = "COLLER CLIPBOARD"
    pasteBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
    pasteBtn.Font = Enum.Font.GothamBold
    pasteBtn.TextSize = 10
    pasteBtn.Parent = btnRow
    makeCorner(pasteBtn, 7)
    makeStroke(pasteBtn, Color3.fromRGB(50, 54, 76), 1)

    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.25, -4, 1, 0)
    clearBtn.BackgroundColor3 = Color3.fromRGB(48, 24, 28)
    clearBtn.BorderSizePixel = 0
    clearBtn.Text = "VIDER"
    clearBtn.TextColor3 = Color3.fromRGB(240, 120, 120)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 10.5
    clearBtn.Parent = btnRow
    makeCorner(clearBtn, 7)
    makeStroke(clearBtn, Color3.fromRGB(110, 40, 48), 1)

    runBtn.MouseButton1Click:Connect(function()
        playClick()
        local code = CodeBox.Text
        executeCodeWithSandbox(code)
    end)

    pasteBtn.MouseButton1Click:Connect(function()
        playClick()
        local clip = ""
        pcall(function()
            if getclipboard then clip = getclipboard()
            elseif syn and syn.getclipboard then clip = syn.getclipboard() end
        end)
        if clip and clip ~= "" then
            CodeBox.Text = clip
            logToDevConsole("Contenu du presse-papier colle (" .. tostring(#clip) .. " cars).", Color3.fromRGB(145, 120, 255))
        else
            notify("Code", "Presse-papier vide ou inaccessible", Color3.fromRGB(255, 165, 0))
        end
    end)

    clearBtn.MouseButton1Click:Connect(function()
        playClick()
        CodeBox.Text = ""
        logToDevConsole("Editeur vide.", Color3.fromRGB(160, 160, 180))
        notify("Code", "Editeur vide.", Color3.fromRGB(160, 160, 180))
    end)
end

-- SECTION 2 : VRAIE CONSOLE DE SORTIE (OUTPUT LOGS - SANS EMOJIS)
createLabel("CONSOLE DE SORTIE EN DIRECT (OUTPUT)", CodeContent)

do
    local consoleCard = Instance.new("Frame")
    consoleCard.Size = UDim2.new(1, 0, 0, 175)
    consoleCard.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
    consoleCard.BorderSizePixel = 0
    consoleCard.Parent = CodeContent
    makeCorner(consoleCard, 10)
    makeStroke(consoleCard, Color3.fromRGB(34, 36, 50), 1)

    local conHeader = Instance.new("Frame")
    conHeader.Size = UDim2.new(1, 0, 0, 28)
    conHeader.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
    conHeader.BorderSizePixel = 0
    conHeader.Parent = consoleCard
    makeCorner(conHeader, 10)

    local conTitle = Instance.new("TextLabel")
    conTitle.Size = UDim2.new(0, 140, 1, 0)
    conTitle.Position = UDim2.new(0, 10, 0, 0)
    conTitle.BackgroundTransparency = 1
    conTitle.Text = "TERMINAL OUTPUT"
    conTitle.TextColor3 = Color3.fromRGB(140, 145, 170)
    conTitle.Font = Enum.Font.GothamBold
    conTitle.TextSize = 10
    conTitle.TextXAlignment = Enum.TextXAlignment.Left
    conTitle.Parent = conHeader

    consoleCountLabel = Instance.new("TextLabel")
    consoleCountLabel.Size = UDim2.new(0, 80, 1, 0)
    consoleCountLabel.Position = UDim2.new(1, -150, 0, 0)
    consoleCountLabel.BackgroundTransparency = 1
    consoleCountLabel.Text = "0 LOGS"
    consoleCountLabel.TextColor3 = Color3.fromRGB(90, 95, 115)
    consoleCountLabel.Font = Enum.Font.Code
    consoleCountLabel.TextSize = 9.5
    consoleCountLabel.TextXAlignment = Enum.TextXAlignment.Right
    consoleCountLabel.Parent = conHeader

    local clearConBtn = Instance.new("TextButton")
    clearConBtn.Size = UDim2.new(0, 58, 0, 20)
    clearConBtn.Position = UDim2.new(1, -66, 0.5, -10)
    clearConBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
    clearConBtn.BorderSizePixel = 0
    clearConBtn.Text = "Vider"
    clearConBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    clearConBtn.Font = Enum.Font.GothamBold
    clearConBtn.TextSize = 9.5
    clearConBtn.Parent = conHeader
    makeCorner(clearConBtn, 5)

    consoleScrollFrame = Instance.new("ScrollingFrame")
    consoleScrollFrame.Size = UDim2.new(1, -12, 0, 138)
    consoleScrollFrame.Position = UDim2.new(0, 6, 0, 32)
    consoleScrollFrame.BackgroundTransparency = 1
    consoleScrollFrame.BorderSizePixel = 0
    consoleScrollFrame.ScrollBarThickness = 3
    consoleScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 85, 115)
    consoleScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleScrollFrame.Parent = consoleCard

    local conLayout = Instance.new("UIListLayout")
    conLayout.SortOrder = Enum.SortOrder.LayoutOrder
    conLayout.Padding = UDim.new(0, 2)
    conLayout.Parent = consoleScrollFrame

    clearConBtn.MouseButton1Click:Connect(function()
        playClick()
        consoleEntries = {}
        for _, c in ipairs(consoleScrollFrame:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
        end
        consoleCountLabel.Text = "0 LOGS"
        logToDevConsole("Console reinitialisee.", Color3.fromRGB(130, 135, 160))
    end)

    logToDevConsole("Pearl Studio pret. Execution Lua prete.", Color3.fromRGB(80, 220, 120))
end

-- SECTION 3 : SCRIPTS ESSENTIELS DEVELOPPEUR (1-CLIC)
createLabel("SCRIPTS ESSENTIELS DEVELOPPEUR", CodeContent)

createButton("Lancer Infinite Yield (Admin Bar)", function()
    notify("Hub", "Telechargement d'Infinite Yield...", Color3.fromRGB(145, 120, 255))
    logToDevConsole("[SCRIPT HUB] Lancement Infinite Yield...", Color3.fromRGB(145, 120, 255))
    task.spawn(function()
        pcall(function()
            local rawCode = game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
            local ok, err = executeCodeWithSandbox(rawCode)
            if ok then
                logToDevConsole("[SCRIPT HUB] Infinite Yield charge avec succes.", Color3.fromRGB(80, 220, 120))
            else
                logToDevConsole("[SCRIPT HUB ERR] " .. tostring(err), Color3.fromRGB(255, 90, 90))
            end
        end)
    end)
end, CodeContent, "Lancer")

createButton("Lancer Dark Dex V3 (Game Explorer)", function()
    notify("Hub", "Telechargement de Dark Dex V3...", Color3.fromRGB(145, 120, 255))
    logToDevConsole("[SCRIPT HUB] Lancement Dark Dex V3...", Color3.fromRGB(145, 120, 255))
    task.spawn(function()
        pcall(function()
            local rawCode = game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua")
            local ok, err = executeCodeWithSandbox(rawCode)
            if ok then
                logToDevConsole("[SCRIPT HUB] Dark Dex V3 charge avec succes.", Color3.fromRGB(80, 220, 120))
            else
                logToDevConsole("[SCRIPT HUB ERR] " .. tostring(err), Color3.fromRGB(255, 90, 90))
            end
        end)
    end)
end, CodeContent, "Lancer")

createButton("Lancer SimpleSpy V3 (Remote Logger)", function()
    notify("Hub", "Telechargement de SimpleSpy V3...", Color3.fromRGB(145, 120, 255))
    logToDevConsole("[SCRIPT HUB] Lancement SimpleSpy V3...", Color3.fromRGB(145, 120, 255))
    task.spawn(function()
        pcall(function()
            local rawCode = game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua")
            local ok, err = executeCodeWithSandbox(rawCode)
            if ok then
                logToDevConsole("[SCRIPT HUB] SimpleSpy V3 charge avec succes.", Color3.fromRGB(80, 220, 120))
            else
                logToDevConsole("[SCRIPT HUB ERR] " .. tostring(err), Color3.fromRGB(255, 90, 90))
            end
        end)
    end)
end, CodeContent, "Lancer")
end

-- ==============================================================
-- [VERROUILLAGE PERMANENT DE L'ORDRE ORIGINAL (ANTI-DESORDRE RECHERCHE)]
-- ==============================================================
local function lockAllNebulaLayoutOrders()
    for _, p in pairs(panels) do
        if p and p ~= SearchPanel and p:IsA("ScrollingFrame") then
            local counter = 0
            for _, child in ipairs(p:GetChildren()) do
                if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    counter = counter + 1
                    child.LayoutOrder = counter
                    pcall(function() child:SetAttribute("NebulaOrigOrder", counter) end)
                end
            end
        end
    end
    for _, item in ipairs(AllRegisteredCards) do
        if item.card then
            local attrOrder = nil
            pcall(function() attrOrder = item.card:GetAttribute("NebulaOrigOrder") end)
            if attrOrder and attrOrder > 0 then
                item.origOrder = attrOrder
            elseif item.card.LayoutOrder > 0 then
                item.origOrder = item.card.LayoutOrder
            end
        end
    end
end
pcall(lockAllNebulaLayoutOrders)
_G.lockAllNebulaLayoutOrders = lockAllNebulaLayoutOrders

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
                if KeybindSystem.BindingBtn and Keybinds[KeybindSystem.BindingName] then
                    KeybindSystem.BindingBtn.Text = Keybinds[KeybindSystem.BindingName].Name
                    KeybindSystem.BindingBtn.BackgroundColor3 = theme.cardHover
                    KeybindSystem.BindingBtn.TextColor3 = theme.accent
                    local s = KeybindSystem.BindingBtn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = theme.border end
                end
                notify("Settings","Key already used by another bind!", Color3.fromRGB(255, 90, 90))
            else
                Keybinds[KeybindSystem.BindingName] = newKey
                if KeybindSystem.BindingBtn then
                    KeybindSystem.BindingBtn.Text = newKey.Name
                    KeybindSystem.BindingBtn.BackgroundColor3 = theme.cardHover
                    KeybindSystem.BindingBtn.TextColor3 = theme.accent
                    local s = KeybindSystem.BindingBtn:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = theme.border end
                end
                if KeybindButtons and KeybindButtons[KeybindSystem.BindingName] and KeybindButtons[KeybindSystem.BindingName] ~= KeybindSystem.BindingBtn then
                    KeybindButtons[KeybindSystem.BindingName].Text = newKey.Name
                end
                if MeKeybindButtons and MeKeybindButtons[KeybindSystem.BindingName] and MeKeybindButtons[KeybindSystem.BindingName] ~= KeybindSystem.BindingBtn then
                    MeKeybindButtons[KeybindSystem.BindingName].Text = newKey.Name
                end
                notify("Settings", KeybindSystem.BindingName .." set to ".. newKey.Name, Color3.fromRGB(80, 200, 120))
            end
            KeybindSystem.Binding = false
            KeybindSystem.BindingName = nil
            KeybindSystem.BindingBtn = nil
            return
        end

        local isMenuKey = (Keybinds and Keybinds.Menu and input.KeyCode == Keybinds.Menu) or (input.KeyCode == Enum.KeyCode.Insert)
        if isMenuKey then
            pcall(function() GuiService.SelectedObject = nil end)
            if not UserInputService:GetFocusedTextBox() then
                if toggleMenu then
                    toggleMenu()
                elseif _G.togglePearlMenu then
                    _G.togglePearlMenu()
                elseif Panel then
                    Panel.Visible = not Panel.Visible
                elseif BloxFruitsPanel then
                    BloxFruitsPanel.Visible = not BloxFruitsPanel.Visible
                end
            end
            return
        end

        local isTyping = (UserInputService:GetFocusedTextBox() ~= nil)
        if not isTyping then
            pcall(function() GuiService.SelectedObject = nil end)

            for name, key in pairs(Keybinds) do
                if name ~= "Menu" and input.KeyCode == key and KeybindCallbacks[name] then
                    local success, err = pcall(KeybindCallbacks[name])
                    if not success then
                        warn("Erreur Keybind ".. name ..": ".. tostring(err))
                    end
                    return
                end
            end
        end
    end
end)
addConnection(V.UnifiedInputConn)

if BloxFruitsPanel then BloxFruitsPanel.Visible = true end
notify("Pearl V2.0","Script loaded successfully!", Color3.fromRGB(80, 200, 120))

InspectorGui = nil
function openPlayerInspector(targetPlayer)
    if not targetPlayer then return end
    if InspectorGui then InspectorGui:Destroy() end

InspectorGui = Instance.new("ScreenGui")
InspectorGui.Name ="PearlPlayerInspector"
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
            if GuiService:IsTenFootInterface() or UserInputService.GamepadEnabled then
                return "Console (PlayStation/Xbox)"
            elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                return "Mobile (iOS/Android)"
            elseif UserInputService.KeyboardEnabled or UserInputService.MouseEnabled then
                return "PC / Mac (Keyboard & Mouse)"
            end
        end

        local pg = targetPlayer:FindFirstChild("PlayerGui")
        if pg then
            if pg:FindFirstChild("TouchGui") or pg:FindFirstChild("TouchCameraControlFrame") or pg:FindFirstChild("MobileGui") or pg:FindFirstChild("TouchControls") then
                return "Mobile (iOS/Android)"
            end
            if pg:FindFirstChild("ConsoleGui") or pg:FindFirstChild("GamepadGui") or pg:FindFirstChild("XboxGui") or pg:FindFirstChild("PSGui") then
                return "Console (PlayStation/Xbox)"
            end
        end

        local char = targetPlayer.Character
        if char then
            if char:FindFirstChild("VRCharacter") or char:FindFirstChild("Left Hand") or char:FindFirstChild("LeftHandVR") then
                return "VR Headset"
            end
            for _, obj in pairs(char:GetChildren()) do
                local n = obj.Name:lower()
                if n:find("touch") or n:find("mobile") then return "Mobile (iOS/Android)"
                elseif n:find("console") or n:find("gamepad") or n:find("controller") then return "Console (Xbox/PS)"
                end
            end
        end

        local devAttr = targetPlayer:GetAttribute("Device") or targetPlayer:GetAttribute("Platform")
        if devAttr then return tostring(devAttr) end

        return "PC / Mac (Keyboard & Mouse)"
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
        addInfoRow("AccountAge", "Âge du Compte:", targetPlayer.AccountAge .. " jours")
        addInfoRow("Health", "Santé (Health):", "Chargement...")
    addInfoRow("Speed","Vitesse (WalkSpeed):","Chargement...")
    addInfoRow("Distance","Distance:","Chargement...")
    addInfoRow("Tool","Objet en main:","Chargement...")
        addInfoRow("Team", "Équipe (Team):", targetPlayer.Team and targetPlayer.Team.Name or "Aucune")
        addInfoRow("Rank", "Rang Créateur:", rankInGroup)
        addInfoRow("Fruit", "Fruit Blox:", "Chargement...")

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
                if _G.getPlayerBloxFruit and valueLabels["Fruit"] then
                    local fName, fPerm = _G.getPlayerBloxFruit(targetPlayer)
                    if fName and fName ~= "Aucun" then
                        valueLabels["Fruit"].Text = fName .. (fPerm and " [PERM]" or " [Physique]")
                        valueLabels["Fruit"].TextColor3 = fPerm and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(175, 110, 255)
                    else
                        valueLabels["Fruit"].Text = "Aucun"
                        valueLabels["Fruit"].TextColor3 = Color3.fromRGB(150, 150, 160)
                    end
                end
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

            notify("Cosmetics","Tenue de ".. targetPlayer.Name .. " copiée !", Color3.fromRGB(80, 200, 120))
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
    if V.AdminJoinNotif or V.AutoPanicStaff then
        task.spawn(function()
            local isStaff, reason = isRobloxAdminOrStaff(p)
            if isStaff then
                if V.AdminJoinNotif then
                    notify("ADMIN REJOINT", p.DisplayName .. " (" .. reason .. ")", Color3.fromRGB(255, 50, 50))
                end
                if V.AutoPanicStaff then
                    if triggerStaffPanic then triggerStaffPanic(p, reason) end
                end
            end
        end)
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
    if V.AdminJoinNotif then
        task.spawn(function()
            local isStaff, reason = isRobloxAdminOrStaff(p)
            if isStaff then
                notify("ADMIN QUITTÉ", p.DisplayName .. " a quitté", Color3.fromRGB(80, 200, 120))
            end
        end)
    end
end)


task.spawn(function()
    task.wait(1)
    pcall(function()
        if sendCheatLoadedWebhook then
            sendCheatLoadedWebhook()
        end
    end)
end)
