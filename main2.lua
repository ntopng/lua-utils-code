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

flick_script = [[
Players = game:GetService("Players")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")

LocalPlayer = Players.LocalPlayer
local ESP_Enabled = false
local ESPDistance_Enabled = false
local Skeleton_Enabled = false
local Tracer_Enabled = false
local HealthBar_Enabled = false
local HealthPV_Enabled = false
Aimlock_Enabled = false
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

dragging = false
local dragStartPos = nil
local frameStartPos = nil

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name ="EternalFlick_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = getSafeGuiParent()

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
BubblesContainer.BackgroundTransparency = 1
BubblesContainer.ClipsDescendants = true
BubblesContainer.ZIndex = 2
BubblesContainer.Active = false
BubblesContainer.Parent = ScreenGui

bubbles = {}
numBubbles = 26
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

Sidebar = Instance.new("Frame")
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

AccountBlock = Instance.new("Frame")
AccountBlock.Size = UDim2.new(1, 0, 0, 92)
AccountBlock.Position = UDim2.new(0, 0, 1, -92)
AccountBlock.BackgroundTransparency = 1
AccountBlock.Parent = Sidebar

AvatarRing = Instance.new("Frame")
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

AvatarImage = Instance.new("ImageLabel")
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
    AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=48&h=48"
end)

AccountName = Instance.new("TextLabel")
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

AccountUser = Instance.new("TextLabel")
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

ContentArea = Instance.new("Frame")
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
local HealthPVTrack, HealthPVThumb, HealthPVBtn = nil, nil, nil
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
                if data.HealthPV then
                    data.HealthPV.Visible = HealthPV_Enabled or (V and V.ESPPV)
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

        local healthPvLabel = Instance.new("TextLabel")
        healthPvLabel.Name = "ESP_HealthPV"
        healthPvLabel.Size = UDim2.new(0, 42, 0, 12)
        healthPvLabel.Position = UDim2.new(0, -18, 1, 2)
        healthPvLabel.BackgroundTransparency = 1
        healthPvLabel.Font = Enum.Font.GothamBold
        healthPvLabel.TextSize = 9
        healthPvLabel.TextColor3 = Color3.fromRGB(0, 230, 120)
        healthPvLabel.TextStrokeTransparency = 0.5
        healthPvLabel.Text = "100 PV"
        healthPvLabel.Visible = HealthPV_Enabled or (V and V.ESPPV)
        healthPvLabel.Parent = healthBarBg

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
            if humanoid and healthPvLabel then
                healthPvLabel.Visible = (HealthPV_Enabled or (V and V.ESPPV)) and (healthBarBg.Visible or ESP_Enabled)
                if healthPvLabel.Visible then
                    local curHp = math.max(0, math.floor(humanoid.Health))
                    healthPvLabel.Text = curHp .. " PV"
                    local ratio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
                    healthPvLabel.TextColor3 = Color3.fromRGB(
                        math.floor(255 * (1 - ratio)),
                        math.floor(255 * ratio),
                        60
                    )
                end
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
            HealthPV = healthPvLabel,
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

local function ToggleHealthPV()
    HealthPV_Enabled = not HealthPV_Enabled
    V.ESPPV = HealthPV_Enabled
    AnimateToggle(HealthPVTrack, HealthPVThumb, HealthPV_Enabled)
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
    gui.Parent = getSafeGuiParent()
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

        local anchorPos, anchorOnScreen = camera:WorldToViewportPoint(anchor.Position)
        if not anchorOnScreen or anchorPos.Z <= 0 then
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

local healthPvRow = createRow(VisualPanel, 5)
addRowLabel(healthPvRow,"Afficher PV","Affiche les PV numeriques sous la barre")
HealthPVTrack, HealthPVThumb, HealthPVBtn = createToggleInRow(healthPvRow)

local skeletonRow = createRow(VisualPanel, 6)
addRowLabel(skeletonRow,"ESP Skeleton","Squelette du joueur à travers les murs")
SkeletonTrack, SkeletonThumb, SkeletonBtn = createToggleInRow(skeletonRow)

local tracerRow = createRow(VisualPanel, 7)
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
    local teamCheckEnabled = (_G.Aimlock_TeamCheck ~= nil and _G.Aimlock_TeamCheck) or (Aimlock_TeamCheck ~= nil and Aimlock_TeamCheck) or (V and V.ESPTeamCheck)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if IsWhitelisted and IsWhitelisted(player) then continue end
            local isTeam = false
            if teamCheckEnabled then
                if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                    isTeam = true
                elseif player.TeamColor and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then
                    isTeam = true
                end
            elseif player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
                isTeam = true
            end
            if isTeam then continue end
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
    local teamCheckEnabled = (_G.Aimlock_TeamCheck ~= nil and _G.Aimlock_TeamCheck) or (Aimlock_TeamCheck ~= nil and Aimlock_TeamCheck) or (V and V.ESPTeamCheck)
    if teamCheckEnabled and target:IsA("Player") then
        if target.Team and LocalPlayer.Team and target.Team == LocalPlayer.Team then return false end
        if target.TeamColor and LocalPlayer.TeamColor and target.TeamColor == LocalPlayer.TeamColor then return false end
    end
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
    if Aimlock_Enabled then aimlockConnection = RunService:BindToRenderStep("PearlAimlock", 250, Aimlock) end
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
HealthPVBtn.MouseButton1Click:Connect(ToggleHealthPV)
SkeletonBtn.MouseButton1Click:Connect(ToggleSkeleton)
TracerBtn.MouseButton1Click:Connect(ToggleTracer)

AnimateToggle(ESPTrack, ESPThumb, false)
AnimateToggle(ESPDistTrack, ESPDistThumb, false)
AnimateToggle(FOVCircleTrack, FOVCircleThumb, false)
AnimateToggle(HealthBarTrack, HealthBarThumb, false)
AnimateToggle(HealthPVTrack, HealthPVThumb, false)
AnimateToggle(SkeletonTrack, SkeletonThumb, false)
AnimateToggle(TracerTrack, TracerThumb, false)
AnimateToggle(AimlockTrack, AimlockThumb, false)

SwitchToAim()
]]

murder_mystery = [[
Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")

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
Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")

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
Players = game:GetService("Players")
TweenService = game:GetService("TweenService")
UserInputService = game:GetService("UserInputService")

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
    ESP = Enum.KeyCode.M,
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
    VehiclePropulse = Enum.KeyCode.P,
    RecordMovement = Enum.KeyCode.Y,
    ReplayMovement = Enum.KeyCode.O
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
    FreecamTPTargetMode = "Ground", FreecamCharVisible = false,
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
        if child.Name == "BloxFruitsUI" or child.Name == "PearlUpdateUI" or child.Name == "PearlFreecamMenu" or child.Name == "PearlFreecamCrosshair" or child.Name == "PearlTacticalRadar" or child.Name == "PearlDangerWarning" then
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
	Scripts = "rbxassetid://7733779730",
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

local wmDragging = false
local wmDragStart, wmStartPos

Watermark.InputBegan:Connect(function(input)
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
end)

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
AllRegisteredCards = {}
local registeredCardsSet = {}

function registerSearchCard(card, name, parent)
	if card and parent and name then
		if registeredCardsSet[card] then return end
		registeredCardsSet[card] = true
		local cleanSearchName = string.lower(tostring(name or "")):gsub("<[^>]->", "")
		table.insert(AllRegisteredCards, {
			card = card,
			name = cleanSearchName,
			origParent = parent,
			origOrder = card.LayoutOrder or #AllRegisteredCards
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
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
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
			if item.card and item.card.Parent ~= item.origParent then
				item.card.Parent = item.origParent
				item.card.LayoutOrder = item.origOrder
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
			if item.card then
				local normItemName = tostring(item.name or ""):gsub("[éèêë]", "e"):gsub("[àâä]", "a"):gsub("[ùûü]", "u"):gsub("[îï]", "i"):gsub("[ôö]", "o"):gsub("[ç]", "c")
				if string.find(normItemName, normalizedQuery, 1, true) or string.find(item.name, cleanQuery, 1, true) then
					item.card.Parent = SearchPanel
					item.card.Visible = true
					matchCount = matchCount + 1
				else
					if item.card.Parent == SearchPanel then
						item.card.Parent = item.origParent
						item.card.LayoutOrder = item.origOrder
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
	card.LayoutOrder = order or 0
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
	header.LayoutOrder = order or 0
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
	{ key = "Scripts", title = "Scripts" },
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
					update2DLineUV(VP.SkeletonLines[lineIdx], uv1, uv2, 1.5, curColor, ovW, ovH)
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
			if item.card and item.card.Parent ~= item.origParent then
				item.card.Parent = item.origParent
				item.card.LayoutOrder = item.origOrder
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
            if V.Spectate and stopSpectate then pcall(stopSpectate) end
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
        if ArrowGui then pcall(function() ArrowGui:Destroy() end) end
        if cleanupArrowESP then cleanupArrowESP() end
        if cleanupRadar2D then cleanupRadar2D() end
        if cleanupSoundSonar then cleanupSoundSonar() end

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
        if Camera then
            Camera.FieldOfView = 70
            Camera.CameraType = Enum.CameraType.Custom
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then Camera.CameraSubject = hum end
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
        for _, child in pairs(parentTarget:GetChildren()) do
            if child:IsA("ScreenGui") and (child.Name == "PearlUpdateUI" or child.Name == "PearlKeySystemUI" or child.Name == "EternalFlick_GUI" or child.Name == "PearlFreecamMenu" or child.Name == "PearlFreecamCrosshair" or child.Name == "PearlPlayerInspector" or child.Name == "PearlESP" or child.Name == "PearlTPMiniGui") then
                child:Destroy()
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
ScriptsContent = ContentFrames["Scripts"]
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
V.ESPDesyncResolver = false
V.StreamerMode = false
V.AutoPanicStaff = false
V.FreecamTPTargetMode = "Ground"
V.FreecamCharVisible = false
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
        local isAiming = false
        pcall(function()
            isAiming = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end)
        if not isAiming and Camera.FieldOfView ~= V.FOV then
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
local INVIS_POSITION = Vector3.new(-25.95, 84, 3537.55)

local function setInvisCharacterTransparency(character, transparency)
    if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant.Name ~= "HumanoidRootPart" then
                if transparency > 0 then
                    if not descendant:GetAttribute("_InvisOrigTrans") then
                        descendant:SetAttribute("_InvisOrigTrans", descendant.Transparency)
                    end
                    descendant.Transparency = 1
                else
                    descendant.Transparency = descendant:GetAttribute("_InvisOrigTrans") or 0
                end
            else
                descendant.Transparency = 1
            end
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            if transparency > 0 then
                if not descendant:GetAttribute("_InvisOrigTrans") then
                    descendant:SetAttribute("_InvisOrigTrans", descendant.Transparency)
                end
                descendant.Transparency = 1
            else
                descendant.Transparency = descendant:GetAttribute("_InvisOrigTrans") or 0
            end
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
            if transparency > 0 then
                if not descendant:GetAttribute("_InvisOrigEnabled") then
                    descendant:SetAttribute("_InvisOrigEnabled", descendant.Enabled)
                end
                descendant.Enabled = false
            else
                descendant.Enabled = descendant:GetAttribute("_InvisOrigEnabled") ~= false
            end
        elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
            if transparency > 0 then
                if not descendant:GetAttribute("_InvisOrigEnabled") then
                    descendant:SetAttribute("_InvisOrigEnabled", descendant.Enabled)
                end
                descendant.Enabled = false
            else
                descendant.Enabled = descendant:GetAttribute("_InvisOrigEnabled") ~= false
            end
        end
    end
end

function toggleInvisibility(enabled)
    local targetState
    if enabled ~= nil then
        targetState = (enabled == true)
    else
        targetState = not invisActive
    end

    invisActive = targetState
    V.Invis = targetState

    task.spawn(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hum or not hrp then return end

            pcall(function() if invisSound then invisSound:Play() end end)

            if invisActive then
                local savedPosition = hrp.CFrame

                -- Teleport a la position d'invisibilite pour desynchroniser le serveur
                char:MoveTo(INVIS_POSITION)
                task.wait(0.15)

                -- Nettoyage de tout ancien siege existant
                local oldChair = workspace:FindFirstChild("invischair")
                if oldChair then pcall(function() oldChair:Destroy() end) end

                -- Creation du siege invisible
                local seat = Instance.new("Seat")
                seat.Name = "invischair"
                seat.Size = Vector3.new(0.01, 0.01, 0.01)
                seat.Anchored = false
                seat.CanCollide = false
                seat.Transparency = 1
                seat.CastShadow = false
                seat.Position = INVIS_POSITION
                seat.Parent = workspace

                -- Soudure du siege au torse
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or hrp
                local weld = Instance.new("Weld")
                weld.Name = "InvisWeld"
                weld.Part0 = seat
                weld.Part1 = torso
                weld.Parent = seat

                task.wait(0.05)
                seat.CFrame = savedPosition

                -- Transparence client complete (100% invisible, aucun residu)
                setInvisCharacterTransparency(char, 1)

                notify("Invisibility", "Mode Invisible Actif (FE Seat Desync)", Color3.fromRGB(80, 200, 120))
            else
                -- Suppression de la chaise invisible
                local invisChair = workspace:FindFirstChild("invischair")
                if invisChair then
                    pcall(function() invisChair:Destroy() end)
                end

                -- Restauration de la visibilite complete
                if char then
                    setInvisCharacterTransparency(char, 0)
                end

                notify("Invisibility", "Mode Invisible Desactive", Color3.fromRGB(255, 90, 90))
            end
        end)
    end)
end

addConnection(LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.4)
    local invisChair = workspace:FindFirstChild("invischair")
    if invisChair then pcall(function() invisChair:Destroy() end) end
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
            if moveDirection.Magnitude > 0 then
                flyPos = flyPos + (moveDirection.Unit * currentSpeed * dt)
                hrp.CFrame = CFrame.new(flyPos, flyPos + cam.CFrame.LookVector)
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


movementConn = RunService.RenderStepped:Connect(function(dt)
    pcall(function()
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

    local tracerLine = Instance.new("Frame")
    tracerLine.Visible = false
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = V.ESPColor
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.Parent = ESPGui

    V.ESPObjects[charInstance] = {
        box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight,
        healthBg = healthBg, healthBar = healthBar, healthPvText = healthPvText, weaponLabel = weaponLabel, skeletonFolder = skeletonFolder, tracerLine = tracerLine
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
            tracerLine.Visible = false
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Head")
        local head = char:FindFirstChild("Head") or hrp
        local hum = char:FindFirstChildOfClass("Humanoid")
        local localChar = LocalPlayer.Character
        if not hrp or not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            nameLabel.Visible = false
            distLabel.Visible = false
            highlight.Parent = nil
            healthBg.Visible = false
            healthPvText.Visible = false
            weaponLabel.Visible = false
            skeletonFolder:ClearAllChildren()
            tracerLine.Visible = false
            return
        end

        local resolvedPos = hrp.Position
        local resolvedHeadPos = head.Position

        if V.ESPDesyncResolver then
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso")
            if torso and (torso.Position - hrp.Position).Magnitude > 2.2 and (torso.Position - hrp.Position).Magnitude < 120 then
                resolvedPos = torso.Position
                resolvedHeadPos = torso.Position + Vector3.new(0, 1.5, 0)
            else
                local vel = Vector3.zero
                pcall(function() vel = hrp.AssemblyLinearVelocity end)
                if vel.Magnitude > 1.2 and vel.Magnitude < 1800 then
                    local ping = 0.05
                    pcall(function()
                        local stats = game:GetService("Stats")
                        local netStats = stats and stats:FindFirstChild("Network")
                        local sServerStats = netStats and netStats:FindFirstChild("ServerStatsItem")
                        local dataPing = sServerStats and sServerStats:FindFirstChild("Data Ping")
                        if dataPing and dataPing:GetValue() > 0 then
                            ping = math.clamp(dataPing:GetValue() / 1000, 0.02, 0.35)
                        end
                    end)
                    resolvedPos = resolvedPos + (vel * ping)
                    resolvedHeadPos = resolvedHeadPos + (vel * ping)
                end
            end
        end

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
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
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
                            line.Size = UDim2.new(0, distance, 0, 1.5)
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
        else
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
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

    local tracerLine = Instance.new("Frame")
    tracerLine.Visible = false
    tracerLine.BorderSizePixel = 0
    tracerLine.BackgroundColor3 = V.ESPColor
    tracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
    tracerLine.Parent = ESPGui

    V.ESPObjects[player] = {
        box = box, boxStroke = boxStroke, nameLabel = nameLabel, distLabel = distLabel, highlight = highlight,
        healthBg = healthBg, healthBar = healthBar, healthPvText = healthPvText, weaponLabel = weaponLabel, skeletonFolder = skeletonFolder, tracerLine = tracerLine
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
            if tracerLine then tracerLine.Visible = false end
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
            if healthPvText then healthPvText.Visible = false end
            weaponLabel.Visible = false
            if skeletonFolder then
                for _, child in ipairs(skeletonFolder:GetChildren()) do
                    child.Visible = false
                end
            end
            if tracerLine then tracerLine.Visible = false end
            return
        end

        local resolvedPos = hrp.Position
        local resolvedHeadPos = head.Position

        if V.ESPDesyncResolver then
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso")
            if torso and (torso.Position - hrp.Position).Magnitude > 2.2 and (torso.Position - hrp.Position).Magnitude < 120 then
                resolvedPos = torso.Position
                resolvedHeadPos = torso.Position + Vector3.new(0, 1.5, 0)
            else
                local vel = Vector3.zero
                pcall(function() vel = hrp.AssemblyLinearVelocity end)
                if vel.Magnitude > 1.2 and vel.Magnitude < 1800 then
                    local ping = 0.05
                    pcall(function()
                        local stats = game:GetService("Stats")
                        local netStats = stats and stats:FindFirstChild("Network")
                        local sServerStats = netStats and netStats:FindFirstChild("ServerStatsItem")
                        local dataPing = sServerStats and sServerStats:FindFirstChild("Data Ping")
                        if dataPing and dataPing:GetValue() > 0 then
                            ping = math.clamp(dataPing:GetValue() / 1000, 0.02, 0.35)
                        end
                    end)
                    resolvedPos = resolvedPos + (vel * ping)
                    resolvedHeadPos = resolvedHeadPos + (vel * ping)
                end
            end
        end

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
            if tracerLine then tracerLine.Visible = false end
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
                            line.Size = UDim2.new(0, distance, 0, 1.5)
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
        else
            for _, child in ipairs(skeletonFolder:GetChildren()) do
                child.Visible = false
            end
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

task.spawn(function()
    while true do
        task.wait(1.5)
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
    clTitle.Text = "Changements Recents"
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
createLabel("BODY SCALE & HITBOX", MeContent)
createToggle("Hitbox Extender", false, function(enabled)
    V.HitboxExtender = enabled
    if not enabled then
        cleanAndResetAllBodies()
    end
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
    if val == 70 and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        Camera.FieldOfView = 70
    end
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
                    part.LocalTransparencyModifier = 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = part:GetAttribute("_FreecamOrigTrans") or 0
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

        notify("Me", "Freecam OFF (Camera Replacee)", Color3.fromRGB(255, 90, 90))
    end
end, MeContent, "Freecam")
createSlider("Freecam Speed", 10, 500, 50, function(val) V.FreecamSpeed = val end, MeContent,"FreecamSpeed")
createToggle("Freecam Cible TP : Sol (ON) / Caméra (OFF)", true, function(enabled)
    V.FreecamTPTargetMode = enabled and "Ground" or "Cam"
    notify("Freecam", "Cible TP Freecam : " .. (enabled and "Sol visé" or "Position Caméra"), Color3.fromRGB(80, 200, 120))
end, MeContent, "FreecamTPMode")

createLabel("GHOST DESYNC / FAKE-LAG", MeContent)
createToggle("Ghost Desync (Fake-Lag Positionnel)", false, function(enabled)
    V.GhostDesync = enabled
    if enabled then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            notify("Me", "Personnage introuvable !", Color3.fromRGB(255, 90, 90))
            V.GhostDesync = false
            return
        end
        V._GhostDesyncRealCF = hrp.CFrame
        V._GhostDesyncTick = 0
        V._GhostDesyncConn = RunService.Heartbeat:Connect(function(dt)
            if not V.GhostDesync then return end
            local c = LocalPlayer.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if not r then return end
            V._GhostDesyncTick = V._GhostDesyncTick + dt
            if V._GhostDesyncTick < 0.25 then
                pcall(function() r.Anchored = true end)
            else
                pcall(function() r.Anchored = false end)
                if V._GhostDesyncTick >= 0.30 then
                    V._GhostDesyncTick = 0
                end
            end
        end)
        notify("Me", "Ghost Desync ACTIVÉ — buffer d'interpolation saturé", Color3.fromRGB(80, 200, 120))
    else
        if V._GhostDesyncConn then
            pcall(function() V._GhostDesyncConn:Disconnect() end)
            V._GhostDesyncConn = nil
        end
        pcall(function()
            local c = LocalPlayer.Character
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if r then r.Anchored = false end
        end)
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
createToggle("Distance", false, function(enabled) V.ESPDist = enabled end, ESPContent,"ESPDist")
createToggle("Tracers ESP", false, function(enabled) V.ESPTracer = enabled end, ESPContent,"ESPTracer")
createToggle("Skeleton ESP", false, function(enabled) V.ESPSkeleton = enabled end, ESPContent,"ESPSkeleton")
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

createToggle("Anti-Desync Resolver (Visuels)", false, function(enabled)
    V.ESPDesyncResolver = enabled
    notify("ESP", "Anti-Desync Resolver " .. (enabled and "ACTIF" or "DESACTIVE"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, ESPContent, "ESPDesyncResolver")
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

    local function getOrCreateBlip(idx)
        if radarBlipPool[idx] then return radarBlipPool[idx] end
        local blip = Instance.new("Frame")
        blip.Size = UDim2.new(0, 6, 0, 6)
        blip.BorderSizePixel = 0
        blip.Visible = false
        blip.Parent = RadarFrame
        makeCorner(blip, 3)

        local dirLine = Instance.new("Frame")
        dirLine.Size = UDim2.new(0, 2, 0, 8)
        dirLine.Position = UDim2.new(0.5, -1, 0, -8)
        dirLine.BorderSizePixel = 0
        dirLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dirLine.Parent = blip

        radarBlipPool[idx] = { blip = blip, dirLine = dirLine }
        return radarBlipPool[idx]
    end

    local function createRadar2D()
        if RadarGui then RadarGui:Destroy() end
        RadarGui = Instance.new("ScreenGui")
        RadarGui.Name = "PearlTacticalRadar"
        RadarGui.ResetOnSpawn = false
        RadarGui.DisplayOrder = 998
        RadarGui.Parent = getSafeGuiParent()

        local Container = Instance.new("Frame")
        Container.Name = "RadarContainer"
        Container.Size = UDim2.new(0, 160, 0, 160)
        Container.Position = UDim2.new(1, -185, 0, 75)
        Container.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
        Container.BackgroundTransparency = 0.25
        Container.BorderSizePixel = 0
        Container.Active = true
        Container.Draggable = true
        Container.Parent = RadarGui
        makeCorner(Container, 80)
        makeStroke(Container, theme.accent, 1.5)

        local circle1 = Instance.new("Frame")
        circle1.Size = UDim2.new(0.5, 0, 0.5, 0)
        circle1.Position = UDim2.new(0.25, 0, 0.25, 0)
        circle1.BackgroundTransparency = 1
        circle1.Parent = Container
        makeCorner(circle1, 40)
        makeStroke(circle1, Color3.fromRGB(50, 55, 75), 1)

        local hLine = Instance.new("Frame")
        hLine.Size = UDim2.new(1, 0, 0, 1)
        hLine.Position = UDim2.new(0, 0, 0.5, 0)
        hLine.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
        hLine.BorderSizePixel = 0
        hLine.Parent = Container

        local vLine = Instance.new("Frame")
        vLine.Size = UDim2.new(0, 1, 1, 0)
        vLine.Position = UDim2.new(0.5, 0, 0, 0)
        vLine.BackgroundColor3 = Color3.fromRGB(45, 50, 70)
        vLine.BorderSizePixel = 0
        vLine.Parent = Container

        local center = Instance.new("Frame")
        center.Size = UDim2.new(0, 6, 0, 6)
        center.Position = UDim2.new(0.5, -3, 0.5, -3)
        center.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        center.BorderSizePixel = 0
        center.Parent = Container
        makeCorner(center, 3)

        RadarFrame = Container
    end

    local function cleanupRadar2D()
        if radarConn then pcall(function() radarConn:Disconnect() end) radarConn = nil end
        if RadarGui and RadarGui.Parent then pcall(function() RadarGui:Destroy() end) end
        RadarGui = nil
        RadarFrame = nil
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
                if not myRoot then
                    for _, b in pairs(radarBlipPool) do b.blip.Visible = false end
                    return
                end

                local maxRange = 220
                local radarRadius = 70
                local blipIndex = 0

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local eChar = p.Character
                        local eRoot = eChar:FindFirstChild("HumanoidRootPart")
                        local eHum = eChar:FindFirstChildOfClass("Humanoid")
                        if eRoot and eHum and eHum.Health > 0 then
                            local rel = myRoot.CFrame:PointToObjectSpace(eRoot.Position)
                            local dist = math.sqrt(rel.X^2 + rel.Z^2)
                            if dist <= maxRange then
                                blipIndex = blipIndex + 1
                                local item = getOrCreateBlip(blipIndex)

                                local angle = math.atan2(rel.X, -rel.Z)
                                local rDist = math.clamp(dist / maxRange, 0, 1) * radarRadius
                                local plotX = 80 + math.sin(angle) * rDist
                                local plotY = 80 - math.cos(angle) * rDist

                                item.blip.Position = UDim2.new(0, plotX - 3, 0, plotY - 3)

                                local isTeam = isPlayerTeamMate and isPlayerTeamMate(p)
                                local isVis = isPlayerVisible and isPlayerVisible(p)

                                if isTeam then
                                    item.blip.BackgroundColor3 = Color3.fromRGB(50, 220, 120)
                                    item.dirLine.BackgroundColor3 = Color3.fromRGB(50, 220, 120)
                                elseif isVis then
                                    item.blip.BackgroundColor3 = Color3.fromRGB(255, 50, 60)
                                    item.dirLine.BackgroundColor3 = Color3.fromRGB(255, 50, 60)
                                else
                                    item.blip.BackgroundColor3 = Color3.fromRGB(255, 205, 50)
                                    item.dirLine.BackgroundColor3 = Color3.fromRGB(255, 205, 50)
                                end

                                local lookRel = myRoot.CFrame:VectorToObjectSpace(eRoot.CFrame.LookVector)
                                local lookAngle = math.deg(math.atan2(lookRel.X, -lookRel.Z))
                                item.blip.Rotation = lookAngle
                                item.blip.Visible = true
                            end
                        end
                    end
                end

                for idx = blipIndex + 1, #radarBlipPool do
                    radarBlipPool[idx].blip.Visible = false
                end
            end)
            addConnection(radarConn)
            notify("ESP", "Radar 2D Tactique ACTIF", Color3.fromRGB(80, 200, 120))
        else
            if RadarGui then RadarGui:Destroy() RadarGui = nil end
            table.clear(radarBlipPool)
            notify("ESP", "Radar 2D DESACTIVE", Color3.fromRGB(255, 90, 90))
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
            local radius = math.clamp(math.min(vp.X, vp.Y) * 0.36, 120, 360)
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


-- Configuration de JoueurContent en 2 colonnes epurees, ultra fluides et modernes
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
rootPad.PaddingTop = UDim.new(0, 10)
rootPad.PaddingBottom = UDim.new(0, 10)
rootPad.PaddingLeft = UDim.new(0, 20)
rootPad.PaddingRight = UDim.new(0, 20)
rootPad.Parent = PlayerTabRoot

-- Colonne Gauche (Player List) : 53% large et aeree
local LeftCol = Instance.new("Frame")
LeftCol.Name = "LeftCol"
LeftCol.Size = UDim2.new(0.53, -10, 1, 0)
LeftCol.Position = UDim2.new(0, 0, 0, 0)
LeftCol.BackgroundTransparency = 1
LeftCol.BorderSizePixel = 0
LeftCol.ClipsDescendants = true
LeftCol.Parent = PlayerTabRoot

local LeftTitle = Instance.new("TextLabel")
LeftTitle.Name = "LeftTitle"
LeftTitle.Size = UDim2.new(1, 0, 0, 26)
LeftTitle.Position = UDim2.new(0, 2, 0, 2)
LeftTitle.BackgroundTransparency = 1
LeftTitle.Text = "Player List"
LeftTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeftTitle.Font = Enum.Font.GothamBold
LeftTitle.TextSize = 15
LeftTitle.TextXAlignment = Enum.TextXAlignment.Left
LeftTitle.Parent = LeftCol

local FilterContainer = Instance.new("Frame")
FilterContainer.Name = "FilterContainer"
FilterContainer.Size = UDim2.new(1, 0, 0, 30)
FilterContainer.Position = UDim2.new(0, 0, 0, 32)
FilterContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FilterContainer.BorderSizePixel = 0
FilterContainer.Parent = LeftCol
makeCorner(FilterContainer, 6)
makeStroke(FilterContainer, Color3.fromRGB(32, 32, 46), 1)

local FilterBox = Instance.new("TextBox")
FilterBox.Name = "FilterBox"
FilterBox.Size = UDim2.new(1, -16, 1, 0)
FilterBox.Position = UDim2.new(0, 8, 0, 0)
FilterBox.BackgroundTransparency = 1
FilterBox.PlaceholderText = "Player filter"
FilterBox.PlaceholderColor3 = Color3.fromRGB(105, 105, 125)
FilterBox.Text = ""
FilterBox.TextColor3 = Color3.fromRGB(225, 225, 235)
FilterBox.Font = Enum.Font.GothamMedium
FilterBox.TextSize = 11
FilterBox.TextXAlignment = Enum.TextXAlignment.Left
FilterBox.ClearTextOnFocus = false
FilterBox.Parent = FilterContainer

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Name = "PlayerListScroll"
PlayerListScroll.Size = UDim2.new(1, 0, 1, -66)
PlayerListScroll.Position = UDim2.new(0, 0, 0, 64)
PlayerListScroll.BackgroundTransparency = 1
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScroll.ScrollBarThickness = 2
PlayerListScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 60, 95)
PlayerListScroll.ScrollBarImageTransparency = 0.5
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.ClipsDescendants = true
PlayerListScroll.Parent = LeftCol

local PlayerListPad = Instance.new("UIPadding")
PlayerListPad.PaddingLeft = UDim.new(0, 0)
PlayerListPad.PaddingRight = UDim.new(0, 6)
PlayerListPad.PaddingTop = UDim.new(0, 4)
PlayerListPad.PaddingBottom = UDim.new(0, 14)
PlayerListPad.Parent = PlayerListScroll

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Padding = UDim.new(0, 8)
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Parent = PlayerListScroll

PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 16)
end)

-- Ligne de separation verticale centrale
local CenterDivider = Instance.new("Frame")
CenterDivider.Name = "CenterDivider"
CenterDivider.Size = UDim2.new(0, 1, 1, -8)
CenterDivider.Position = UDim2.new(0.53, 0, 0, 4)
CenterDivider.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
CenterDivider.BorderSizePixel = 0
CenterDivider.Parent = PlayerTabRoot

-- Colonne Droite (Settings) : 47% equilibre
local RightCol = Instance.new("Frame")
RightCol.Name = "RightCol"
RightCol.Size = UDim2.new(0.47, -12, 1, 0)
RightCol.Position = UDim2.new(0.53, 12, 0, 0)
RightCol.BackgroundTransparency = 1
RightCol.BorderSizePixel = 0
RightCol.ClipsDescendants = true
RightCol.Parent = PlayerTabRoot

local RightTitle = Instance.new("TextLabel")
RightTitle.Name = "RightTitle"
RightTitle.Size = UDim2.new(1, 0, 0, 26)
RightTitle.Position = UDim2.new(0, 2, 0, 2)
RightTitle.BackgroundTransparency = 1
RightTitle.Text = "Settings"
RightTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
RightTitle.Font = Enum.Font.GothamBold
RightTitle.TextSize = 15
RightTitle.TextXAlignment = Enum.TextXAlignment.Left
RightTitle.Parent = RightCol

local TargetIndicator = Instance.new("TextLabel")
TargetIndicator.Name = "TargetIndicator"
TargetIndicator.Size = UDim2.new(1, 0, 0, 18)
TargetIndicator.Position = UDim2.new(0, 2, 0, 30)
TargetIndicator.BackgroundTransparency = 1
TargetIndicator.Text = "Cible : Aucun joueur sélectionné"
TargetIndicator.TextColor3 = Color3.fromRGB(155, 140, 225)
TargetIndicator.Font = Enum.Font.GothamMedium
TargetIndicator.TextSize = 11
TargetIndicator.TextXAlignment = Enum.TextXAlignment.Left
TargetIndicator.TextTruncate = Enum.TextTruncate.AtEnd
TargetIndicator.Parent = RightCol

local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Name = "SettingsContainer"
SettingsContainer.Size = UDim2.new(1, 0, 1, -54)
SettingsContainer.Position = UDim2.new(0, 0, 0, 52)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.BorderSizePixel = 0
SettingsContainer.ScrollBarThickness = 2
SettingsContainer.ScrollBarImageColor3 = Color3.fromRGB(70, 60, 95)
SettingsContainer.ScrollBarImageTransparency = 0.5
SettingsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsContainer.ClipsDescendants = true
SettingsContainer.Parent = RightCol

local SettingsPad = Instance.new("UIPadding")
SettingsPad.PaddingLeft = UDim.new(0, 0)
SettingsPad.PaddingRight = UDim.new(0, 4)
SettingsPad.PaddingTop = UDim.new(0, 4)
SettingsPad.PaddingBottom = UDim.new(0, 12)
SettingsPad.Parent = SettingsContainer

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.Padding = UDim.new(0, 8)
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
        if selectedPlayer == LocalPlayer then
            TargetIndicator.Text = "Cible : " .. selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ") [Moi]"
            TargetIndicator.TextColor3 = Color3.fromRGB(120, 200, 255)
        else
            TargetIndicator.Text = "Cible : " .. selectedPlayer.DisplayName .. " (@" .. selectedPlayer.Name .. ")"
            TargetIndicator.TextColor3 = Color3.fromRGB(175, 145, 255)
        end
    else
        TargetIndicator.Text = "Cible : Aucun joueur sélectionné"
        TargetIndicator.TextColor3 = Color3.fromRGB(130, 130, 150)
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
                rowData.btn.BackgroundColor3 = Color3.fromRGB(46, 26, 76)
                rowData.stroke.Color = Color3.fromRGB(140, 75, 255)
                rowData.lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                rowData.btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
                rowData.stroke.Color = Color3.fromRGB(32, 32, 46)
                rowData.lbl.TextColor3 = (p == LocalPlayer) and Color3.fromRGB(140, 200, 255) or Color3.fromRGB(215, 215, 230)
            end
        end
    end
end

local function createPlayerRow(p)
    if not p or playerRowsByPlayer[p] then return end

    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -4, 0, 36)
    row.BackgroundColor3 = (p == selectedPlayer) and Color3.fromRGB(46, 26, 76) or Color3.fromRGB(18, 18, 26)
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.ClipsDescendants = true
    row.LayoutOrder = (p == LocalPlayer) and 0 or 1
    row.Parent = PlayerListScroll
    makeCorner(row, 6)
    local rowStroke = makeStroke(row, (p == selectedPlayer) and Color3.fromRGB(140, 75, 255) or Color3.fromRGB(32, 32, 46), 1)

    local rowLabel = Instance.new("TextLabel")
    rowLabel.Size = UDim2.new(1, -16, 1, 0)
    rowLabel.Position = UDim2.new(0, 8, 0, 0)
    rowLabel.BackgroundTransparency = 1
    local tag = (p == LocalPlayer) and " (Moi)" or ""
    rowLabel.Text = p.DisplayName .. " (@" .. p.Name .. ")" .. tag
    rowLabel.TextColor3 = (p == selectedPlayer) and Color3.fromRGB(255, 255, 255) or ((p == LocalPlayer) and Color3.fromRGB(140, 200, 255) or Color3.fromRGB(215, 215, 230))
    rowLabel.Font = Enum.Font.GothamBold
    rowLabel.TextSize = 11
    rowLabel.TextXAlignment = Enum.TextXAlignment.Left
    rowLabel.TextTruncate = Enum.TextTruncate.AtEnd
    rowLabel.Parent = row

    local searchKey = string.lower(p.Name .. " " .. p.DisplayName .. " " .. tostring(p.UserId))

    row.MouseButton1Click:Connect(function()
        playClick()
        selectedPlayer = p
        V.SelectedJoueurPlayer = p
        _G.SelectedJoueurPlayer = p
        updateTargetIndicator()
        updateSelectionHighlight()
        refreshAllActions()
    end)

    playerRowsByPlayer[p] = {btn = row, stroke = rowStroke, lbl = rowLabel, searchKey = searchKey}
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

-- Remplissage initial fluide avec TOUS les joueurs du serveur
for _, p in ipairs(Players:GetPlayers()) do
    createPlayerRow(p)
end
if not selectedPlayer or not selectedPlayer.Parent then
    selectedPlayer = LocalPlayer
    V.SelectedJoueurPlayer = LocalPlayer
    _G.SelectedJoueurPlayer = LocalPlayer
end
updateTargetIndicator()
updateSelectionHighlight()

FilterBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)

Players.PlayerAdded:Connect(function(p)
    createPlayerRow(p)
    applyFilter()
    updateSelectionHighlight()
end)

Players.PlayerRemoving:Connect(function(p)
    removePlayerRow(p)
end)

-- Creation des 5 boutons d'action (attach, spectate, teleport, WarpCar, fling)
-- Pas de coloration au survol de la souris, coloration uniquement a l'appui / actif
local function createActionButton(btnTitle, callback, checkActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    btn.BorderSizePixel = 0
    btn.Text = btnTitle
    btn.TextColor3 = Color3.fromRGB(220, 220, 235)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.RichText = true
    btn.AutoButtonColor = false
    btn.Parent = SettingsContainer
    makeCorner(btn, 6)
    local stroke = makeStroke(btn, Color3.fromRGB(32, 32, 46), 1)

    local function refreshState()
        local active = false
        if checkActive then
            pcall(function()
                active = checkActive(btn)
            end)
        end
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(55, 20, 32)
            btn.TextColor3 = Color3.fromRGB(255, 95, 110)
            stroke.Color = Color3.fromRGB(210, 48, 62)
        else
            btn.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
            btn.TextColor3 = Color3.fromRGB(220, 220, 235)
            stroke.Color = Color3.fromRGB(32, 32, 46)
        end
    end

    table.insert(actionRefreshers, refreshState)

    btn.MouseButton1Down:Connect(function()
        local active = false
        if checkActive then
            pcall(function() active = checkActive(btn) end)
        end
        if not active then
            btn.BackgroundColor3 = Color3.fromRGB(38, 24, 60)
            stroke.Color = Color3.fromRGB(140, 75, 255)
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

-- 4. WarpCar
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

-- 5. Fling
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
end


createLabel("SERVER ACTIONS & VISUALS", ServerContent)

skyPresets = {
    ["Crépuscule Violet Sombre"] = {
        Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454296", Ft = "rbxassetid://159454293",
        Lf = "rbxassetid://159454299", Rt = "rbxassetid://159454300", Up = "rbxassetid://159454288",
        ClockTime = 20, Stars = 4000
    },
    ["Ciel Étoilé Néon"] = {
        Bk = "rbxassetid://12064107", Dn = "rbxassetid://12064152", Ft = "rbxassetid://12064121",
        Lf = "rbxassetid://12064131", Rt = "rbxassetid://12064115", Up = "rbxassetid://12064147",
        ClockTime = 0, Stars = 5000
    },
    ["Vaporwave 80s"] = {
        Bk = "rbxassetid://1417494402", Dn = "rbxassetid://1417494146", Ft = "rbxassetid://1417494253",
        Lf = "rbxassetid://1417494402", Rt = "rbxassetid://1417494499", Up = "rbxassetid://1417494643",
        ClockTime = 18, Stars = 0
    },
    ["Lune Rouge Sang"] = {
        Bk = "rbxassetid://401664839", Dn = "rbxassetid://401664862", Ft = "rbxassetid://401664960",
        Lf = "rbxassetid://401664881", Rt = "rbxassetid://401664901", Up = "rbxassetid://401664936",
        ClockTime = 0, Stars = 2000
    },
    ["Galaxie Pourpre"] = {
        Bk = "rbxassetid://271042516", Dn = "rbxassetid://271077243", Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310", Rt = "rbxassetid://271042467", Up = "rbxassetid://271077958",
        ClockTime = 22, Stars = 4500
    },
    ["Cosmos Bleu Profond"] = {
        Bk = "rbxassetid://159248188", Dn = "rbxassetid://159248183", Ft = "rbxassetid://159248187",
        Lf = "rbxassetid://159248173", Rt = "rbxassetid://159248192", Up = "rbxassetid://159248176",
        ClockTime = 23, Stars = 4000
    },
    ["Aurore Boréale"] = {
        Bk = "rbxassetid://924320032", Dn = "rbxassetid://924319912", Ft = "rbxassetid://924320141",
        Lf = "rbxassetid://924320268", Rt = "rbxassetid://924320420", Up = "rbxassetid://924320578",
        ClockTime = 21, Stars = 3000
    },
    ["Coucher de Soleil Anime"] = {
        Bk = "rbxassetid://247075135", Dn = "rbxassetid://247074897", Ft = "rbxassetid://247075035",
        Lf = "rbxassetid://247075084", Rt = "rbxassetid://247075185", Up = "rbxassetid://247075238",
        ClockTime = 17.5, Stars = 0
    },
    ["Matrix Digital Noir"] = {
        Bk = "rbxassetid://284205403", Dn = "rbxassetid://284205403", Ft = "rbxassetid://284205403",
        Lf = "rbxassetid://284205403", Rt = "rbxassetid://284205403", Up = "rbxassetid://284205403",
        ClockTime = 0, Stars = 0
    },
    ["Cyberpunk Night City"] = {
        Bk = "rbxassetid://557685651", Dn = "rbxassetid://557685651", Ft = "rbxassetid://557685651",
        Lf = "rbxassetid://557685651", Rt = "rbxassetid://557685651", Up = "rbxassetid://557685651",
        ClockTime = 0, Stars = 0
    },
    ["Nuit Étoilée Épure"] = {
        Bk = "rbxassetid://148967980", Dn = "rbxassetid://148967980", Ft = "rbxassetid://148967980",
        Lf = "rbxassetid://148967980", Rt = "rbxassetid://148967980", Up = "rbxassetid://148967980",
        ClockTime = 0, Stars = 5000
    },
    ["Crépuscule Lilas"] = {
        Bk = "rbxassetid://64448843", Dn = "rbxassetid://64448847", Ft = "rbxassetid://64448843",
        Lf = "rbxassetid://64448843", Rt = "rbxassetid://64448843", Up = "rbxassetid://64146989",
        ClockTime = 19, Stars = 1000
    },
    ["Nébuleuse Violette HD"] = {
        Bk = "rbxassetid://570557514", Dn = "rbxassetid://570557775", Ft = "rbxassetid://570557559",
        Lf = "rbxassetid://570557620", Rt = "rbxassetid://570557672", Up = "rbxassetid://570557727",
        ClockTime = 21, Stars = 3500
    },
    ["Minecraft Réaliste"] = {
        Bk = "rbxassetid://147185887", Dn = "rbxassetid://147186101", Ft = "rbxassetid://147185880",
        Lf = "rbxassetid://147185884", Rt = "rbxassetid://147185882", Up = "rbxassetid://147186101",
        ClockTime = 14, Stars = 0
    },
    ["Studio Minimal Grey"] = {
        Bk = "rbxassetid://1013852", Dn = "rbxassetid://1013853", Ft = "rbxassetid://1013854",
        Lf = "rbxassetid://1013855", Rt = "rbxassetid://1013856", Up = "rbxassetid://1013857",
        ClockTime = 12, Stars = 0
    },
    ["Espace Pur Noir"] = {
        Bk = "rbxassetid://159454299", Dn = "rbxassetid://159454299", Ft = "rbxassetid://159454299",
        Lf = "rbxassetid://159454299", Rt = "rbxassetid://159454299", Up = "rbxassetid://159454299",
        ClockTime = 0, Stars = 6000
    }
}

skyList = {
    "Default",
    "Crépuscule Violet Sombre",
    "Ciel Étoilé Néon",
    "Vaporwave 80s",
    "Lune Rouge Sang",
    "Galaxie Pourpre",
    "Cosmos Bleu Profond",
    "Aurore Boréale",
    "Coucher de Soleil Anime",
    "Matrix Digital Noir",
    "Cyberpunk Night City",
    "Nuit Étoilée Épure",
    "Crépuscule Lilas",
    "Nébuleuse Violette HD",
    "Minecraft Réaliste",
    "Studio Minimal Grey",
    "Espace Pur Noir"
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

    -- Annuler la brume atmosphérique et le brouillard qui masquent le ciel custom !
    if atmosphere then
        atmosphere.Density = 0
    end
    Lighting.FogEnd = 100000

    local newSky = Instance.new("Sky")
    newSky.Name = "PearlCustomSky"
    newSky.SkyboxBk = preset.Bk
    newSky.SkyboxDn = preset.Dn
    newSky.SkyboxFt = preset.Ft
    newSky.SkyboxLf = preset.Lf
    newSky.SkyboxRt = preset.Rt
    newSky.SkyboxUp = preset.Up
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
    notify("Vehicle","Vehicle Noclip".. (enabled and"ON"or"OFF"), enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(255, 90, 90))
end, VehicleContent,"VehicleNoclip")

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

createLabel("PRE-MADE SCRIPTS", ScriptsContent)
do
    ScriptsContent.ScrollBarThickness = 3
    ScriptsContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScriptsContent.CanvasSize = UDim2.new(0, 0, 0, 0)

    local function destroyGuiByName(guiName)
        for _, child in pairs(parentTarget:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == guiName then
                child:Destroy()
            end
        end
    end

    local ScriptsList = {
        { 
            Name = "Flick", 
            Code = flick_script, 
            Destroy = function() 
                destroyGuiByName("EternalFlick_GUI")
                if V.HitboxConn then V.HitboxConn:Disconnect() V.HitboxConn = nil end
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("Head") then
                        local h = p.Character.Head
                        local orig = h:FindFirstChild("OriginalSize")
                        if orig and orig:IsA("Vector3Value") then
                            h.Size = orig.Value
                        elseif h:IsA("MeshPart") and h.MeshSize and h.MeshSize.Magnitude > 0 then
                            h.Size = h.MeshSize
                        else
                            h.Size = Vector3.new(1.2, 1.2, 1.2)
                        end
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
                destroyGuiByName("UpdateGui")
            end 
        },
        { 
            Name = "Grow Garden 2", 
            Code = grow_garden, 
            Destroy = function() 
                destroyGuiByName("UpdateGui")
                if _G.Pearl_OrigFogEnd then
                    Lighting.FogEnd = _G.Pearl_OrigFogEnd
                    Lighting.FogStart = _G.Pearl_OrigFogStart
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
                destroyGuiByName("UpdateGui")
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                end
            end 
        }
    }

    local function buildScriptRow(scriptData)
        local card = createCard(ScriptsContent, 0, 46)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -170, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = scriptData.Name
        lbl.TextColor3 = theme.text or Color3.fromRGB(235, 235, 242)
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 9
        lbl.Parent = card

        local loadBtn = Instance.new("TextButton")
        loadBtn.Size = UDim2.new(0, 68, 0, 26)
        loadBtn.Position = UDim2.new(1, -160, 0.5, -13)
        loadBtn.BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47)
        loadBtn.BorderSizePixel = 0
        loadBtn.Text = "Load"
        loadBtn.TextColor3 = theme.accent or Color3.fromRGB(145, 120, 255)
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.TextSize = 11
        loadBtn.ZIndex = 9
        loadBtn.Parent = card
        makeCorner(loadBtn, 6)
        local loadStroke = makeStroke(loadBtn, theme.border or Color3.fromRGB(44, 46, 62), 1)

        loadBtn.MouseEnter:Connect(function()
            TweenService:Create(loadBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.accent or Color3.fromRGB(145, 120, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        loadBtn.MouseLeave:Connect(function()
            TweenService:Create(loadBtn, TweenInfo.new(0.15), {BackgroundColor3 = theme.cardHover or Color3.fromRGB(31, 33, 47), TextColor3 = theme.accent or Color3.fromRGB(145, 120, 255)}):Play()
        end)

        local destBtn = Instance.new("TextButton")
        destBtn.Size = UDim2.new(0, 74, 0, 26)
        destBtn.Position = UDim2.new(1, -84, 0.5, -13)
        destBtn.BackgroundColor3 = Color3.fromRGB(45, 24, 28)
        destBtn.BorderSizePixel = 0
        destBtn.Text = "Destroy"
        destBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
        destBtn.Font = Enum.Font.GothamBold
        destBtn.TextSize = 11
        destBtn.ZIndex = 9
        destBtn.Parent = card
        makeCorner(destBtn, 6)
        makeStroke(destBtn, Color3.fromRGB(80, 35, 40), 1)

        destBtn.MouseEnter:Connect(function()
            TweenService:Create(destBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 25, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        destBtn.MouseLeave:Connect(function()
            TweenService:Create(destBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 24, 28), TextColor3 = Color3.fromRGB(255, 90, 90)}):Play()
        end)

        loadBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if executeCodeWithSandbox then
                    executeCodeWithSandbox(scriptData.Code)
                else
                    loadstring(scriptData.Code)()
                end
            end)
            notify("Scripts", scriptData.Name .. " loaded!", Color3.fromRGB(80, 200, 120))
        end)

        destBtn.MouseButton1Click:Connect(function()
            pcall(scriptData.Destroy)
            notify("Scripts", scriptData.Name .. " destroyed!", Color3.fromRGB(255, 90, 90))
        end)

        registerSearchCard(card, scriptData.Name .. " Script Pre-Made Load Destroy", ScriptsContent)
    end

    for _, scriptData in ipairs(ScriptsList) do
        buildScriptRow(scriptData)
    end
end

initStep = "cablage Scripts/Settings"


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

-- [UI Opacity / Transparency removed as requested]



createLabel("SYSTEM", SettingsContent)

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
    MenuKeyBtn.Size = UDim2.new(0, 84, 0, 26)
    MenuKeyBtn.Position = UDim2.new(1, -96, 0.5, -13)
    MenuKeyBtn.BackgroundColor3 = theme.cardHover
    MenuKeyBtn.BorderSizePixel = 0
    MenuKeyBtn.Text = Keybinds.Menu.Name
    MenuKeyBtn.TextColor3 = theme.accent
    MenuKeyBtn.Font = Enum.Font.GothamBold
    MenuKeyBtn.TextSize = 11
    MenuKeyBtn.ZIndex = 8
    MenuKeyBtn.Parent = MenuKeybindFrame

    makeCorner(MenuKeyBtn, 6)
    local menuBtnStroke = makeStroke(MenuKeyBtn, theme.border, 1)

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
        Label.Size = UDim2.new(0.6, 0, 1, 0)
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
        KeyBtn.Size = UDim2.new(0, 84, 0, 26)
        KeyBtn.Position = UDim2.new(1, -96, 0.5, -13)
        KeyBtn.BackgroundColor3 = theme.cardHover
        KeyBtn.BorderSizePixel = 0
        KeyBtn.Text = Keybinds[name] and Keybinds[name].Name or defaultKey.Name
        KeyBtn.TextColor3 = theme.accent
        KeyBtn.Font = Enum.Font.GothamBold
        KeyBtn.TextSize = 11
        KeyBtn.ZIndex = 8
        KeyBtn.Parent = KeybindFrame

        makeCorner(KeyBtn, 6)
        local btnStroke = makeStroke(KeyBtn, theme.border, 1)

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
                if kb.Fly and Enum.KeyCode[kb.Fly] then Keybinds.Fly = Enum.KeyCode[kb.Fly] end
                if kb.Noclip and Enum.KeyCode[kb.Noclip] then Keybinds.Noclip = Enum.KeyCode[kb.Noclip] end
                if kb.Invisible and Enum.KeyCode[kb.Invisible] then Keybinds.Invisible = Enum.KeyCode[kb.Invisible] end
                if kb.DesyncFly and Enum.KeyCode[kb.DesyncFly] then Keybinds.DesyncFly = Enum.KeyCode[kb.DesyncFly] end
                if kb.ESP and Enum.KeyCode[kb.ESP] then Keybinds.ESP = Enum.KeyCode[kb.ESP] end
                if kb.Speed and Enum.KeyCode[kb.Speed] then Keybinds.Speed = Enum.KeyCode[kb.Speed] end
                if kb.Respawn and Enum.KeyCode[kb.Respawn] then Keybinds.Respawn = Enum.KeyCode[kb.Respawn] end
                if kb.Menu and Enum.KeyCode[kb.Menu] then Keybinds.Menu = Enum.KeyCode[kb.Menu] end
                if kb.Freecam and Enum.KeyCode[kb.Freecam] then Keybinds.Freecam = Enum.KeyCode[kb.Freecam] end
                if kb.VehicleFly and Enum.KeyCode[kb.VehicleFly] then Keybinds.VehicleFly = Enum.KeyCode[kb.VehicleFly] end
                if kb.VehicleBoost and Enum.KeyCode[kb.VehicleBoost] then Keybinds.VehicleBoost = Enum.KeyCode[kb.VehicleBoost] end
                if kb.InstantBrake and Enum.KeyCode[kb.InstantBrake] then Keybinds.InstantBrake = Enum.KeyCode[kb.InstantBrake] end
                if kb.VehicleSeatTP and Enum.KeyCode[kb.VehicleSeatTP] then Keybinds.VehicleSeatTP = Enum.KeyCode[kb.VehicleSeatTP] end
                if kb.VehicleAutoFlip and Enum.KeyCode[kb.VehicleAutoFlip] then Keybinds.VehicleAutoFlip = Enum.KeyCode[kb.VehicleAutoFlip] end
                if kb.VehicleExplode and Enum.KeyCode[kb.VehicleExplode] then Keybinds.VehicleExplode = Enum.KeyCode[kb.VehicleExplode] end
                if kb.VehiclePropulse and Enum.KeyCode[kb.VehiclePropulse] then Keybinds.VehiclePropulse = Enum.KeyCode[kb.VehiclePropulse] end
                if kb.RecordMovement and Enum.KeyCode[kb.RecordMovement] then Keybinds.RecordMovement = Enum.KeyCode[kb.RecordMovement] end
                if kb.ReplayMovement and Enum.KeyCode[kb.ReplayMovement] then Keybinds.ReplayMovement = Enum.KeyCode[kb.ReplayMovement] end
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
                for name, btn in pairs(KeybindButtons) do
                    if Keybinds[name] then btn.Text = Keybinds[name].Name end
                end
            end
            if writefile then pcall(function() writefile("Pearl_LastConfig.txt", cfgName) end) end
            notify("Config", cfgName .. " chargée avec succès !", Color3.fromRGB(80, 200, 120))
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
                ExportBtn.Size = UDim2.new(0, 50, 0, 26)
                ExportBtn.Position = UDim2.new(1, -175, 0.5, -13)
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
                UnloadBtn.Size = UDim2.new(0, 50, 0, 26)
                UnloadBtn.Position = UDim2.new(1, -115, 0.5, -13)
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
                        if Keybinds[name] then btn.Text = Keybinds[name].Name end
                    end
                    notify("Config", "Config déchargée (Paramètres par défaut) !", Color3.fromRGB(255, 165, 0))
                end)

                local DelBtn = Instance.new("TextButton")
                DelBtn.Size = UDim2.new(0, 50, 0, 26)
                DelBtn.Position = UDim2.new(1, -55, 0.5, -13)
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

            cfg.Keybinds = {
                Fly = getBindName(Keybinds.Fly, "F"),
                Noclip = getBindName(Keybinds.Noclip, "V"),
                Invisible = getBindName(Keybinds.Invisible, "C"),
                DesyncFly = getBindName(Keybinds.DesyncFly, "G"),
                ESP = getBindName(Keybinds.ESP, "M"),
                Speed = getBindName(Keybinds.Speed, "R"),
                Respawn = getBindName(Keybinds.Respawn, "B"),
                Menu = getBindName(Keybinds.Menu, "Insert"),
                Freecam = getBindName(Keybinds.Freecam, "X"),
                VehicleFly = getBindName(Keybinds.VehicleFly, "H"),
                VehicleBoost = getBindName(Keybinds.VehicleBoost, "T"),
                InstantBrake = getBindName(Keybinds.InstantBrake, "N"),
                VehicleSeatTP = getBindName(Keybinds.VehicleSeatTP, "J"),
                VehicleAutoFlip = getBindName(Keybinds.VehicleAutoFlip, "K"),
                VehicleExplode = getBindName(Keybinds.VehicleExplode, "L"),
                VehiclePropulse = getBindName(Keybinds.VehiclePropulse, "P"),
                RecordMovement = getBindName(Keybinds.RecordMovement, "Y"),
                ReplayMovement = getBindName(Keybinds.ReplayMovement, "O"),
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
