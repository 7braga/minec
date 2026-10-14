-- =================================================================
-- 👑 Braga HUB — MINE ANTARCTICA MASTER SUITE
-- Game        : Mine Antarctica
-- Place ID    : 138686218420016
-- Standard    : 1:1 My Flower Shop Exact Architecture
-- Features    : Full Autonomous AFK Suite, Auto Dig & Instant Mine,
--               Auto Collect Gems & Crystals, Auto Backpack Sell,
--               Auto Buy & Equip Pickaxe, Auto Upgrades & Potions,
--               Teleports, ESP, Free Mode
-- =================================================================

-- [0] MULTI-INSTANCE CLEANUP GUARD
if _G.BH_MINE_ANTARCTICA_CLEANUP then
    pcall(_G.BH_MINE_ANTARCTICA_CLEANUP)
end

local scriptConnections = {}
local scriptThreads = {}

local function track(conn)
    table.insert(scriptConnections, conn)
    return conn
end

local function registerThread(f)
    local t = task.spawn(f)
    table.insert(scriptThreads, t)
    return t
end

-- [1] SERVICES & LOCAL PLAYER
local Players             = game:GetService("Players")
local CoreGui             = game:GetService("CoreGui")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local HttpService         = game:GetService("HttpService")
local Workspace           = game:GetService("Workspace")
local Lighting            = game:GetService("Lighting")
local VirtualUser         = game:GetService("VirtualUser")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local MarketplaceService  = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- 🌐 SMART BILINGUAL & REGION DETECTOR (ID / EN)
-- ====================================================================
local LocalizationService = game:GetService("LocalizationService")
local isIndo = false
pcall(function()
    if _G.BROTHERHUB_LANG then
        isIndo = (_G.BROTHERHUB_LANG == "ID")
        return
    end
    local reg = LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
    local lang = string.lower(LocalizationService.RobloxLocaleId or "")
    if reg == "ID" or string.find(lang, "id") or string.find(lang, "indonesia") then
        isIndo = true
    end
end)

local function L(idText, enText)
    return isIndo and idText or enText
end

local camera      = Workspace.CurrentCamera

-- Anti-AFK
track(LocalPlayer.Idled:Connect(function()
    pcall(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end))

-- [2] THEME PALETTE (1:1 My Flower Shop Standard)
local THEME = {
    Bg        = Color3.fromRGB(15, 17, 24),
    Panel     = Color3.fromRGB(24, 27, 38),
    Slot      = Color3.fromRGB(34, 38, 54),
    Stroke    = Color3.fromRGB(60, 68, 96),
    Title     = Color3.fromRGB(255, 215, 0),    -- Gold
    Accent    = Color3.fromRGB(0, 255, 200),    -- Cyan Neon
    Text      = Color3.fromRGB(240, 244, 255),
    SubText   = Color3.fromRGB(150, 160, 185),
    On        = Color3.fromRGB(0, 200, 110),    -- Green
    Off       = Color3.fromRGB(210, 55, 70),    -- Red
    Blue      = Color3.fromRGB(40, 130, 230),
    Purple    = Color3.fromRGB(150, 90, 230),
    Cyan      = Color3.fromRGB(50, 220, 255),
    Yellow    = Color3.fromRGB(255, 215, 60),
    Pink      = Color3.fromRGB(255, 105, 180),
    Orange    = Color3.fromRGB(255, 150, 50),
    Font      = Enum.Font.GothamBold,
    FontReg   = Enum.Font.GothamMedium,
}

local tweenBounce = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenFast   = TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function corner(inst, r)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function stroke(inst, col, th)
    local s = Instance.new("UIStroke", inst)
    s.Color = col or THEME.Stroke
    s.Thickness = th or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function gradient(inst, c1, c2, rot)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 90
    return g
end

local function neonStroke(inst, thickness)
    local s = Instance.new("UIStroke", inst)
    s.Thickness = thickness or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Transparency = 0
    s.Color = Color3.new(1, 1, 1)
    local g = Instance.new("UIGradient", s)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 40, 255)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 25, 45)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(20, 255, 80)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 40, 255)),
    })
    g.Rotation = 0
    local tw = TweenService:Create(g,
        TweenInfo.new(3.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360})
    tw:Play()
    return s, tw
end

-- [3] ZERO ROBUX POPUP BLOCKER (100% Free Mode)
pcall(function()
    MarketplaceService.PromptPurchaseRequested:Connect(function(player)
        if player == LocalPlayer then pcall(function() end) end
    end)
    MarketplaceService.PromptProductPurchaseRequested:Connect(function(player)
        if player == LocalPlayer then pcall(function() end) end
    end)
    MarketplaceService.PromptGamePassPurchaseRequested:Connect(function(player)
        if player == LocalPlayer then pcall(function() end) end
    end)
end)

-- [4] CHARACTER & MOVEMENT HELPERS
local function getChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHrp()
    local c = getChar()
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function safeTeleport(pos)
    local hrp = getHrp()
    if not hrp then return end
    local finalPos = typeof(pos) == "CFrame" and pos.Position or pos
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(finalPos + Vector3.new(0, 2.5, 0))
    task.wait(0.05)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- [5] CONFIGURATION & STATE
local config = {
    -- Auto Mine & Dig
    autoDig             = false,
    digRadius           = 150,
    instantMineBreak    = true,
    autoCollectGems     = false,
    autoSellBackpack    = false,
    autoSellThreshold   = 50,

    -- Upgrades & Equipment
    autoBuyPickaxe      = false,
    autoEquipBestPick   = false,
    autoBuyCapacity     = false,
    autoUsePotions      = false,

    -- Movement & Cheats
    walkSpeed           = 16,
    customSpeed         = false,
    jumpPower           = 50,
    customJump          = false,
    flyMode             = false,
    flySpeed            = 60,
    noclip              = false,
    infiniteJump        = false,
    fullbright          = false,

    -- Visuals / ESP
    espGems             = false,
    espCrystals         = false,
    espMerchant         = false,
    espPlayers          = false,
}

-- [6] REMOTES DISCOVERY
local remotes = {}
local function findRemote(name)
    if remotes[name] then return remotes[name] end
    local found = ReplicatedStorage:FindFirstChild(name, true)
    if found and (found:IsA("RemoteEvent") or found:IsA("RemoteFunction")) then
        remotes[name] = found
        return found
    end
    return nil
end

local function fireRE(name, ...)
    local re = findRemote(name)
    if re and re:IsA("RemoteEvent") then
        local args = {...}
        pcall(function() re:FireServer(unpack(args)) end)
        return true
    end
    return false
end

local function invokeRF(name, ...)
    local rf = findRemote(name)
    if rf and rf:IsA("RemoteFunction") then
        local args = {...}
        local ok, res = pcall(function() return rf:InvokeServer(unpack(args)) end)
        if ok then return res end
    end
    return nil
end

-- [7] AUTONOMOUS GAME LOOPS

-- Helper: Find nearest ore or ice block to dig
local function findMineableBlock()
    local hrp = getHrp()
    if not hrp then return nil end

    local candidates = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local nl = obj.Name:lower()
            if nl:find("ice") or nl:find("ore") or nl:find("mine") or nl:find("rock") or nl:find("crystal") or nl:find("gem") then
                if not nl:find("gui") and not nl:find("ui") and not nl:find("frame") and not nl:find("hud") then
                    local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                    if part and part.Transparency < 0.9 then
                        local d = (part.Position - hrp.Position).Magnitude
                        if d <= config.digRadius then
                            table.insert(candidates, {part = part, model = obj, dist = d})
                        end
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    return candidates[1]
end

-- Auto Mine & Dig Master Thread
registerThread(function()
    while true do
        if config.autoDig then
            pcall(function()
                local hrp = getHrp()
                local target = findMineableBlock()
                if hrp and target then
                    -- Fire dig network requests
                    fireRE("DigRequest", target.part)
                    fireRE("DigHit", target.part)
                    fireRE("MineHit", target.part)
                    fireRE("BeginMine", target.part)

                    -- Tool activation
                    local char = getChar()
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                end
            end)
        end
        task.wait(config.instantMineBreak and 0.08 or 0.25)
    end
end)

-- Auto Collect Gems & Crystals Thread
registerThread(function()
    while true do
        if config.autoCollectGems then
            pcall(function()
                local hrp = getHrp()
                if not hrp then return end
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    local nl = obj.Name:lower()
                    if (nl:find("gem") or nl:find("crystal") or nl:find("drop")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
                        local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude < 120 then
                            fireRE("PickupGem", obj)
                            fireRE("GemCollected", obj)
                            fireRE("TakeCrystal", obj)
                            if firetouchinterest then
                                firetouchinterest(hrp, part, 0)
                                task.wait(0.01)
                                firetouchinterest(hrp, part, 1)
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.4)
    end
end)

-- Auto Sell Backpack Thread
registerThread(function()
    while true do
        if config.autoSellBackpack then
            pcall(function()
                fireRE("RequestSell")
                fireRE("TeleportSell")
                local sellPrompt = Workspace:FindFirstChild("SellPrompt", true)
                if sellPrompt and sellPrompt:IsA("ProximityPrompt") then
                    pcall(function() fireproximityprompt(sellPrompt, 0) end)
                    pcall(function() fireproximityprompt(sellPrompt) end)
                end
            end)
        end
        task.wait(4.0)
    end
end)

-- Auto Buy & Equip Pickaxe & Upgrades
registerThread(function()
    while true do
        if config.autoBuyPickaxe then
            pcall(function()
                fireRE("BuyPickaxe")
            end)
        end
        if config.autoEquipBestPick then
            pcall(function()
                fireRE("EquipPickaxe")
            end)
        end
        if config.autoBuyCapacity then
            pcall(function()
                fireRE("BuyCapacity")
                fireRE("BuyUpgrade")
            end)
        end
        if config.autoUsePotions then
            pcall(function()
                fireRE("UsePotion")
            end)
        end
        task.wait(3.0)
    end
end)

-- [8] ESP SYSTEM
local espObjects = {}
local function removeEsp(key)
    if espObjects[key] then
        pcall(function() espObjects[key]:Destroy() end)
        espObjects[key] = nil
    end
end

local function addHighlightEsp(target, key, color)
    removeEsp(key)
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.Name = "BH_ESP_" .. key
        hl.Adornee = target
        hl.FillColor = color or THEME.Accent
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.OutlineTransparency = 0.1
        hl.Parent = CoreGui
        espObjects[key] = hl
    end)
end

registerThread(function()
    while true do
        if config.espGems then
            pcall(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    local nl = obj.Name:lower()
                    if (nl:find("gem") or nl:find("crystal")) and (obj:IsA("Model") or obj:IsA("BasePart")) then
                        if not nl:find("gui") and not nl:find("icon") then
                            addHighlightEsp(obj, "Gem_" .. obj.Name, THEME.Yellow)
                        end
                    end
                end
            end)
        else
            for k in pairs(espObjects) do
                if k:sub(1, 4) == "Gem_" then removeEsp(k) end
            end
        end

        if config.espMerchant then
            pcall(function()
                local merch = Workspace:FindFirstChild("Seller", true) or Workspace:FindFirstChild("Shop", true)
                if merch then
                    addHighlightEsp(merch, "Merchant", THEME.Cyan)
                end
            end)
        else
            removeEsp("Merchant")
        end

        if config.espPlayers then
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        addHighlightEsp(plr.Character, "Plr_" .. plr.Name, THEME.Pink)
                    end
                end
            end)
        else
            for k in pairs(espObjects) do
                if k:sub(1, 4) == "Plr_" then removeEsp(k) end
            end
        end
        task.wait(2.5)
    end
end)

-- Movement Modifier Thread
track(RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if config.customSpeed then hum.WalkSpeed = config.walkSpeed end
            if config.customJump then hum.JumpPower = config.jumpPower end
        end
        if config.noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end))

-- Fly Implementation
local flyBodyGyro, flyBodyVel
local function toggleFly(enable)
    local hrp = getHrp()
    if not hrp then return end
    if enable then
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.P = 9e4
        flyBodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBodyGyro.cframe = hrp.CFrame

        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.velocity = Vector3.zero
        flyBodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)

        registerThread(function()
            while config.flyMode and hrp and flyBodyGyro and flyBodyVel do
                local cam = Workspace.CurrentCamera
                local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

                flyBodyGyro.cframe = cam.CFrame
                flyBodyVel.velocity = moveDir * config.flySpeed
                task.wait(0.03)
            end
            if flyBodyGyro then flyBodyGyro:Destroy() end
            if flyBodyVel then flyBodyVel:Destroy() end
        end)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVel then flyBodyVel:Destroy() end
    end
end

-- Infinite Jump
track(UserInputService.JumpRequest:Connect(function()
    if config.infiniteJump then
        local hum = getHumanoid()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- Fullbright
local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
}
local function setFullbright(enable)
    if enable then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
    end
end

-- =========================================================================
-- [9] USER INTERFACE (1:1 MY FLOWER SHOP EXACT ARCHITECTURE)
-- =========================================================================

local guiParent = (gethui and gethui()) or CoreGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "BrotherHub_MineAntarctica"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = guiParent

-- Responsive Viewport Scale on ScreenGui
local ViewportScale = Instance.new("UIScale", ScreenGui)
local function updateViewportScale()
    if not camera then return end
    local v = camera.ViewportSize
    local s = math.min(v.X / 1280, v.Y / 720)
    ViewportScale.Scale = math.clamp(s, 0.5, 1.1)
end
track(camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateViewportScale))
updateViewportScale()

-- Main Frame
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name             = "MainFrame"
MainFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
MainFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size             = UDim2.fromOffset(660, 440)
MainFrame.BackgroundColor3 = THEME.Bg
MainFrame.BorderSizePixel  = 0
corner(MainFrame, 14)
neonStroke(MainFrame, 2)

-- MainScale strictly parented to MainFrame
local MainScale = Instance.new("UIScale", MainFrame)
MainScale.Scale = 0
TweenService:Create(MainScale, tweenBounce, {Scale = 1}):Play()

-- Header
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = THEME.Panel
Header.BorderSizePixel = 0
corner(Header, 14)
gradient(Header, THEME.Purple, THEME.Blue, 0)

local HeaderSquareFix = Instance.new("Frame", Header)
HeaderSquareFix.Size = UDim2.new(1, 0, 0, 14)
HeaderSquareFix.Position = UDim2.new(0, 0, 1, -14)
HeaderSquareFix.BackgroundColor3 = THEME.Panel
HeaderSquareFix.BorderSizePixel = 0
HeaderSquareFix.ZIndex = 0
gradient(HeaderSquareFix, THEME.Purple, THEME.Blue, 0)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Active = false
Title.Text = "⚡ BROTHER HUB — MINE ANTARCTICA"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 17
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Header Buttons (Minimize & Close)
local BTN_SIZE = UDim2.new(0, 32, 0, 32)
local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = BTN_SIZE
MinBtn.AnchorPoint = Vector2.new(0, 0.5)
MinBtn.Position = UDim2.new(1, -94, 0.5, 0)
MinBtn.BackgroundColor3 = THEME.Yellow
MinBtn.Text = "–"
MinBtn.TextColor3 = Color3.new(0, 0, 0)
MinBtn.Font = THEME.Font
MinBtn.TextSize = 16
corner(MinBtn, 8)

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = BTN_SIZE
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.Position = UDim2.new(1, -44, 0.5, 0)
CloseBtn.BackgroundColor3 = THEME.Off
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = THEME.Font
CloseBtn.TextSize = 16
corner(CloseBtn, 8)

-- Horizontal Scrolling TabBar
local TabBar = Instance.new("ScrollingFrame", MainFrame)
TabBar.Size = UDim2.new(1, -24, 0, 32)
TabBar.Position = UDim2.new(0, 12, 0, 58)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 3
TabBar.ScrollBarImageColor3 = THEME.Title
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
local tabList = Instance.new("UIListLayout", TabBar)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0, 6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Tab Management
local TABS = {}
local activeTab = nil

local function makeTabBody()
    local b = Instance.new("ScrollingFrame", MainFrame)
    b.Size = UDim2.new(1, -24, 1, -104)
    b.Position = UDim2.new(0, 12, 0, 96)
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.ScrollBarThickness = 5
    b.ScrollBarImageColor3 = THEME.Title
    b.AutomaticCanvasSize = Enum.AutomaticSize.Y
    b.CanvasSize = UDim2.new(0, 0, 0, 0)
    b.Visible = false
    local l = Instance.new("UIListLayout", b)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, 10)
    local p = Instance.new("UIPadding", b)
    p.PaddingTop = UDim.new(0, 6)
    p.PaddingBottom = UDim.new(0, 14)
    p.PaddingLeft = UDim.new(0, 6)
    p.PaddingRight = UDim.new(0, 10)
    return b
end

local function switchTab(name)
    activeTab = name
    for _, t in pairs(TABS) do
        local on = (t.name == name)
        t.body.Visible = on
        t.btn.BackgroundColor3 = on and THEME.Title or THEME.Slot
        t.btn.TextColor3 = on and Color3.new(0, 0, 0) or THEME.Text
    end
end

local function addTab(name, label)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 115, 1, 0)
    btn.BackgroundColor3 = THEME.Slot
    btn.Text = label
    btn.TextColor3 = THEME.Text
    btn.Font = THEME.Font
    btn.TextSize = 12
    btn.LayoutOrder = #TABS + 1
    corner(btn, 8)
    local body = makeTabBody()
    local t = { btn = btn, body = body, name = name }
    TABS[#TABS + 1] = t
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    return body
end

local TAB_MINE   = addTab("mine",   "⛏️ Auto Mine")
local TAB_SHOP   = addTab("shop",   "🛒 Shop & Upgrade")
local TAB_POTION = addTab("potion", "🧪 Potions")
local TAB_TP     = addTab("tp",     "📍 Teleport")
local TAB_PLAYER = addTab("player", "🏃 Karakter")
local TAB_ESP    = addTab("esp",    "👁️ Visual/ESP")
local TAB_CREDIT = addTab("credit", "👑 Credit")

-- Drag MainFrame
do
    local dragging, dragStart, startPos = false, nil, nil
    Header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = i.Position; startPos = MainFrame.Position
        end
    end)
    track(UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    track(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

-- Resize Grip (Bottom Right Corner)
local ResizeGrip = Instance.new("TextButton", MainFrame)
ResizeGrip.Name = "ResizeGrip"
ResizeGrip.Size = UDim2.fromOffset(22, 22)
ResizeGrip.Position = UDim2.new(1, -22, 1, -22)
ResizeGrip.BackgroundTransparency = 1
ResizeGrip.Text = "◢"
ResizeGrip.TextSize = 15
ResizeGrip.TextColor3 = THEME.Stroke
ResizeGrip.Font = THEME.Font
ResizeGrip.ZIndex = 15
ResizeGrip.AutoButtonColor = false

do
    local resizing = false
    local startPos = nil
    local startSize = nil
    ResizeGrip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true; startPos = i.Position; startSize = MainFrame.AbsoluteSize
        end
    end)
    track(UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - startPos
            local newW = math.clamp(startSize.X + d.X, 520, 1100)
            local newH = math.clamp(startSize.Y + d.Y, 360, 750)
            MainFrame.Size = UDim2.fromOffset(newW, newH)
        end
    end))
    track(UserInputService.InputEnded:Connect(function(i)
        if not resizing then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end))
end

-- Floating 80x80 MinCircle (Minimize Restore Button)
local MinCircle = Instance.new("TextButton", ScreenGui)
MinCircle.Name = "MinCircle"
MinCircle.Size = UDim2.fromOffset(80, 80)
MinCircle.Position = UDim2.new(0, 20, 0.5, -40)
MinCircle.BackgroundColor3 = THEME.Panel
MinCircle.Text = ""
MinCircle.Visible = false
MinCircle.ZIndex = 50
corner(MinCircle, 40)
neonStroke(MinCircle, 2)

local MinCrown = Instance.new("TextLabel", MinCircle)
MinCrown.Size = UDim2.new(1, 0, 0, 28)
MinCrown.Position = UDim2.new(0, 0, 0, 12)
MinCrown.BackgroundTransparency = 1
MinCrown.Text = "👑"
MinCrown.TextSize = 22
MinCrown.Font = THEME.Font

local MinBh = Instance.new("TextLabel", MinCircle)
MinBh.Size = UDim2.new(1, 0, 0, 26)
MinBh.Position = UDim2.new(0, 0, 0, 40)
MinBh.BackgroundTransparency = 1
MinBh.Text = "BH"
MinBh.TextColor3 = THEME.Title
MinBh.TextSize = 20
MinBh.Font = Enum.Font.GothamBlack

do
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    local function release(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if not moved and MinCircle.Visible then
                MinCircle.Visible = false
                MainFrame.Visible = true
                MainScale.Scale = 0
                TweenService:Create(MainScale, tweenBounce, {Scale = 1}):Play()
            end
        end
    end

    MinCircle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; moved = false; dragStart = i.Position; startPos = MinCircle.Position
        end
    end)
    track(UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - dragStart
            if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then moved = true end
            MinCircle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    MinCircle.InputEnded:Connect(release)
    track(UserInputService.InputEnded:Connect(release))
end

MinBtn.MouseButton1Click:Connect(function()
    local tw = TweenService:Create(MainScale, tweenFast, {Scale = 0})
    tw:Play()
    tw.Completed:Wait()
    MainFrame.Visible = false
    MinCircle.Visible = true
end)

-- Modal Dialog Konfirmasi Tutup ('X')
local CloseModal = Instance.new("Frame", ScreenGui)
CloseModal.Name = "CloseModal"
CloseModal.Size = UDim2.fromOffset(360, 200)
CloseModal.AnchorPoint = Vector2.new(0.5, 0.5)
CloseModal.Position = UDim2.new(0.5, 0, 0.5, 0)
CloseModal.BackgroundColor3 = THEME.Panel
CloseModal.Visible = false
CloseModal.ZIndex = 100
corner(CloseModal, 14)
neonStroke(CloseModal, 2)

local ModalTitle = Instance.new("TextLabel", CloseModal)
ModalTitle.Size = UDim2.new(1, -20, 0, 36)
ModalTitle.Position = UDim2.new(0, 10, 0, 12)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = "👑 KONFIRMASI TUTUP GUI"
ModalTitle.TextColor3 = THEME.Title
ModalTitle.Font = THEME.Font
ModalTitle.TextSize = 16

local ModalDesc = Instance.new("TextLabel", CloseModal)
ModalDesc.Size = UDim2.new(1, -30, 0, 60)
ModalDesc.Position = UDim2.new(0, 15, 0, 48)
ModalDesc.BackgroundTransparency = 1
ModalDesc.Text = "Apakah Anda yakin ingin mematikan seluruh script Brother Hub dan menutup antarmuka?"
ModalDesc.TextColor3 = THEME.Text
ModalDesc.Font = THEME.FontReg
ModalDesc.TextSize = 13
ModalDesc.TextWrapped = true

local ModalYes = Instance.new("TextButton", CloseModal)
ModalYes.Size = UDim2.new(0, 140, 0, 38)
ModalYes.Position = UDim2.new(0, 25, 1, -54)
ModalYes.BackgroundColor3 = THEME.On
ModalYes.Text = "Ya, Tutup"
ModalYes.TextColor3 = Color3.new(1, 1, 1)
ModalYes.Font = THEME.Font
ModalYes.TextSize = 13
corner(ModalYes, 8)

local ModalCancel = Instance.new("TextButton", CloseModal)
ModalCancel.Size = UDim2.new(0, 140, 0, 38)
ModalCancel.Position = UDim2.new(1, -165, 1, -54)
ModalCancel.BackgroundColor3 = THEME.Off
ModalCancel.Text = "Batal"
ModalCancel.TextColor3 = Color3.new(1, 1, 1)
ModalCancel.Font = THEME.Font
ModalCancel.TextSize = 13
corner(ModalCancel, 8)

CloseBtn.MouseButton1Click:Connect(function()
    CloseModal.Visible = true
end)

ModalCancel.MouseButton1Click:Connect(function()
    CloseModal.Visible = false
end)

local function cleanupAll()
    for _, conn in ipairs(scriptConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, thr in ipairs(scriptThreads) do
        pcall(function() task.cancel(thr) end)
    end
    for k in pairs(espObjects) do
        removeEsp(k)
    end
    pcall(function()
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end)
    pcall(function() setFullbright(false) end)
    pcall(function() toggleFly(false) end)
    pcall(function() ScreenGui:Destroy() end)
    _G.BH_MINE_ANTARCTICA_CLEANUP = nil
end

_G.BH_MINE_ANTARCTICA_CLEANUP = cleanupAll

ModalYes.MouseButton1Click:Connect(function()
    cleanupAll()
end)

-- UI BUILDER FUNCTIONS
local orderIndex = 0
local function getOrder() orderIndex = orderIndex + 1; return orderIndex end

local function makeCard(parent, titleText, accent)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, 0, 0, 38)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = THEME.Panel
    card.BorderSizePixel = 0
    card.LayoutOrder = getOrder()
    corner(card, 10)
    stroke(card, accent or THEME.Stroke, 1)

    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 4, 1, -10)
    bar.Position = UDim2.new(0, 0, 0, 5)
    bar.BackgroundColor3 = accent or THEME.Title
    bar.BorderSizePixel = 0
    corner(bar, 4)

    local head = Instance.new("TextLabel", card)
    head.Size = UDim2.new(1, -28, 0, 26)
    head.Position = UDim2.new(0, 14, 0, 6)
    head.BackgroundTransparency = 1
    head.Text = titleText
    head.TextColor3 = accent or THEME.Title
    head.Font = THEME.Font
    head.TextSize = 13
    head.TextXAlignment = Enum.TextXAlignment.Left

    local holder = Instance.new("Frame", card)
    holder.Name = "Holder"
    holder.Size = UDim2.new(1, -28, 0, 0)
    holder.Position = UDim2.new(0, 14, 0, 34)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.BackgroundTransparency = 1
    local hl = Instance.new("UIListLayout", holder)
    hl.SortOrder = Enum.SortOrder.LayoutOrder
    hl.Padding = UDim.new(0, 8)
    local hp = Instance.new("UIPadding", holder)
    hp.PaddingBottom = UDim.new(0, 10)
    return holder
end

local function makeToggle(parent, label, accent, onChanged, initial)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = THEME.Slot
    row.BorderSizePixel = 0
    row.LayoutOrder = getOrder()
    corner(row, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 58, 0, 24)
    btn.Position = UDim2.new(1, -66, 0.5, -12)
    btn.BackgroundColor3 = THEME.Off
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = THEME.Font
    btn.TextSize = 12
    corner(btn, 12)

    local clickArea = Instance.new("TextButton", row)
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 4

    local isOn = false
    local function setVisual(v)
        isOn = v and true or false
        btn.Text = isOn and "ON" or "OFF"
        TweenService:Create(btn, tweenFast, {BackgroundColor3 = isOn and (accent or THEME.On) or THEME.Off}):Play()
        pcall(onChanged, isOn)
    end
    btn.MouseButton1Click:Connect(function() setVisual(not isOn) end)
    clickArea.MouseButton1Click:Connect(function() setVisual(not isOn) end)
    if initial then setVisual(true) end
    return setVisual
end

local function makeSlider(parent, label, val, minv, maxv, step, accent, onChanged)
    local con = Instance.new("Frame", parent)
    con.Size = UDim2.new(1, 0, 0, 42)
    con.BackgroundColor3 = THEME.Slot
    con.BorderSizePixel = 0
    con.LayoutOrder = getOrder()
    corner(con, 8)

    local lbl = Instance.new("TextLabel", con)
    lbl.Size = UDim2.new(1, -78, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = THEME.Text
    lbl.Font = THEME.FontReg
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valBox = Instance.new("TextBox", con)
    valBox.Size = UDim2.new(0, 54, 0, 18)
    valBox.Position = UDim2.new(1, -60, 0, 3)
    valBox.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    valBox.Text = tostring(math.floor(val + 0.5))
    valBox.TextColor3 = THEME.Title
    valBox.Font = THEME.Font
    valBox.TextSize = 12
    valBox.ZIndex = 4
    corner(valBox, 6)
    stroke(valBox, THEME.Stroke, 1)

    local line = Instance.new("Frame", con)
    line.Size = UDim2.new(1, -24, 0, 6)
    line.Position = UDim2.new(0, 12, 0, 27)
    line.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    corner(line, 4)

    local pct0 = (val - minv) / math.max(maxv - minv, 0.0001)
    local fill = Instance.new("Frame", line)
    fill.Size = UDim2.new(pct0, 0, 1, 0)
    fill.BackgroundColor3 = accent or THEME.Cyan
    corner(fill, 4)

    local knob = Instance.new("Frame", line)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(pct0, -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    corner(knob, 7)

    local hit = Instance.new("TextButton", con)
    hit.Size = UDim2.new(1, -24, 0, 24)
    hit.Position = UDim2.new(0, 12, 0, 18)
    hit.BackgroundTransparency = 1
    hit.Text = ""

    local current = val
    local function applyVal(n)
        n = math.clamp(n, minv, maxv)
        if step and step > 0 then n = math.floor(n / step + 0.5) * step end
        current = n
        local pct = (n - minv) / math.max(maxv - minv, 0.0001)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        valBox.Text = tostring(math.floor(n + 0.5))
        pcall(onChanged, n)
    end

    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then applyVal(n) else valBox.Text = tostring(math.floor(current + 0.5)) end
    end)

    local dragging = false
    local function upd(px)
        local rel = px - line.AbsolutePosition.X
        local pct = math.clamp(rel / math.max(line.AbsoluteSize.X, 1), 0, 1)
        applyVal(minv + pct * (maxv - minv))
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; upd(i.Position.X)
        end
    end)
    track(UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            upd(i.Position.X)
        end
    end))
    track(UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

local function makeButton(parent, label, bg, onClick)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = bg or THEME.Blue
    b.Text = label
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = THEME.Font
    b.TextSize = 12
    b.LayoutOrder = getOrder()
    corner(b, 8)
    b.MouseButton1Click:Connect(function() pcall(onClick) end)
    return b
end

-- =========================================================================
-- [10] POPULATING UI TABS
-- =========================================================================

-- TAB 1: AUTO MINE
do
    local c1 = makeCard(TAB_MINE, "⛏️ MASTER AUTO MINE & DIG (ANTARCTICA ICE)", THEME.Title)
    makeToggle(c1, "Auto Tambang Es & Ores (Instant Loop)", THEME.On, function(v) config.autoDig = v end)
    makeToggle(c1, "Mode Hancur Seketika (Instant Break)", THEME.Cyan, function(v) config.instantMineBreak = v end, true)
    makeToggle(c1, "Auto Sedot Gems & Crystals (Vacuum)", THEME.Yellow, function(v) config.autoCollectGems = v end, true)
    makeToggle(c1, "Auto Jual Saat Tas Penuh (Auto Sell)", THEME.Orange, function(v) config.autoSellBackpack = v end, true)
    makeSlider(c1, "Radius Jangkauan Tambang", config.digRadius, 20, 500, 10, THEME.Blue, function(v) config.digRadius = v end)

    local c2 = makeCard(TAB_MINE, "💰 FAST SELL CONTROLS", THEME.On)
    makeButton(c2, "⚡ Instan Jual Semua Hasil Tambang (Sell All)", THEME.On, function()
        fireRE("RequestSell")
        fireRE("TeleportSell")
    end)
end

-- TAB 2: SHOP & UPGRADE
do
    local c1 = makeCard(TAB_SHOP, "🛒 SHOP AUTOMATION (100% FREE IN-GAME)", THEME.Cyan)
    makeToggle(c1, "Auto Beli Pickaxe Terbaik Tersedia", THEME.On, function(v) config.autoBuyPickaxe = v end)
    makeToggle(c1, "Auto Equip Pickaxe Terkuat", THEME.Purple, function(v) config.autoEquipBestPick = v end, true)
    makeToggle(c1, "Auto Upgrade Kapasitas Tas (Backpack)", THEME.Yellow, function(v) config.autoBuyCapacity = v end)
    makeButton(c1, "🔨 Beli & Equip Pickaxe Sekarang", THEME.Blue, function()
        fireRE("BuyPickaxe")
        fireRE("EquipPickaxe")
    end)
    makeButton(c1, "🎒 Beli Upgrade Kapasitas Tas", THEME.Orange, function()
        fireRE("BuyCapacity")
        fireRE("BuyUpgrade")
    end)
end

-- TAB 3: POTIONS & BUFFS
do
    local c1 = makeCard(TAB_POTION, "🧪 POTION AUTO CONSUMER", THEME.Purple)
    makeToggle(c1, "Auto Minum Potion Keberuntungan & Dig Speed", THEME.On, function(v) config.autoUsePotions = v end)
    makeButton(c1, "✨ Minum Semua Potion Tersedia Sekarang", THEME.Pink, function()
        fireRE("UsePotion")
        fireRE("SyncAllPotions")
    end)
end

-- TAB 4: TELEPORTS
do
    local c1 = makeCard(TAB_TP, "📍 TELEPORT ANTARCTICA DEPTHS", THEME.Cyan)
    makeButton(c1, "⛺ Teleport ke Surface Base / Merchant", THEME.Blue, function()
        local merch = Workspace:FindFirstChild("Seller", true) or Workspace:FindFirstChild("Shop", true)
        if merch then
            local p = merch:IsA("BasePart") and merch or merch.PrimaryPart or merch:FindFirstChildWhichIsA("BasePart")
            if p then safeTeleport(p.Position + Vector3.new(0, 3, 0)) end
        else
            fireRE("TeleportHome")
        end
    end)
    makeButton(c1, "❄️ Teleport ke Gua Es Dalam (Deep Ice Caves)", THEME.Cyan, function()
        local cave = Workspace:FindFirstChild("Cave", true) or Workspace:FindFirstChild("Mine", true)
        if cave then
            local p = cave:IsA("BasePart") and cave or cave.PrimaryPart or cave:FindFirstChildWhichIsA("BasePart")
            if p then safeTeleport(p.Position + Vector3.new(0, 3, 0)) end
        end
    end)
    makeButton(c1, "💎 Teleport ke Kawah Kristal (Crystal Crater)", THEME.Purple, function()
        local crater = Workspace:FindFirstChild("Crater", true) or Workspace:FindFirstChild("Crystal", true)
        if crater then
            local p = crater:IsA("BasePart") and crater or crater.PrimaryPart or crater:FindFirstChildWhichIsA("BasePart")
            if p then safeTeleport(p.Position + Vector3.new(0, 3, 0)) end
        end
    end)
end

-- TAB 5: PLAYER & MOVEMENT
do
    local c1 = makeCard(TAB_PLAYER, "🏃 MOVEMENT & CHARACTER HACKS", THEME.Blue)
    makeToggle(c1, "Custom WalkSpeed", THEME.On, function(v) config.customSpeed = v end)
    makeSlider(c1, "WalkSpeed Value", config.walkSpeed, 16, 180, 1, THEME.Cyan, function(v) config.walkSpeed = v end)
    makeToggle(c1, "Custom JumpPower", THEME.On, function(v) config.customJump = v end)
    makeSlider(c1, "JumpPower Value", config.jumpPower, 50, 300, 5, THEME.Yellow, function(v) config.jumpPower = v end)
    makeToggle(c1, "Fly Mode (WASD + Space/Shift)", THEME.Purple, function(v) config.flyMode = v; toggleFly(v) end)
    makeSlider(c1, "Fly Speed", config.flySpeed, 20, 250, 5, THEME.Pink, function(v) config.flySpeed = v end)
    makeToggle(c1, "Noclip (Tembus Tembok)", THEME.Orange, function(v) config.noclip = v end)
    makeToggle(c1, "Infinite Jump (Lompat Tanpa Batas)", THEME.Green, function(v) config.infiniteJump = v end)
    makeToggle(c1, "Fullbright (Terang Benderang)", THEME.Yellow, function(v) config.fullbright = v; setFullbright(v) end)
end

-- TAB 6: VISUAL & ESP
do
    local c1 = makeCard(TAB_ESP, "👁️ ESP & SENSOR VISUAL", THEME.Pink)
    makeToggle(c1, "ESP Permata & Kristal (Gems/Crystals)", THEME.Yellow, function(v) config.espGems = v end)
    makeToggle(c1, "ESP Merchant & Seller Menu", THEME.Cyan, function(v) config.espMerchant = v end)
    makeToggle(c1, "ESP Pemain Lain", THEME.Pink, function(v) config.espPlayers = v end)
end

-- TAB 7: CREDITS
do
    local c1 = makeCard(TAB_CREDIT, "👑 BROTHER HUB OFFICIAL CREDITS", THEME.Title)
    local l1 = Instance.new("TextLabel", c1)
    l1.Size = UDim2.new(1, 0, 0, 24)
    l1.BackgroundTransparency = 1
    l1.Text = "👑 Founder & Lead Developer: prawiraxliv"
    l1.TextColor3 = THEME.Title
    l1.Font = THEME.Font
    l1.TextSize = 13
    l1.TextXAlignment = Enum.TextXAlignment.Left
    l1.LayoutOrder = getOrder()

    makeButton(c1, "💬 Salin Link Discord Resmi", THEME.Blue, function()
        if setclipboard then
        end
    end)
    makeButton(c1, "☕ Donasi Saweria (Founder)", THEME.Orange, function()
        if setclipboard then
        end
    end)
    makeButton(c1, "💎 Donasi SociaBuzz (Tribe/QRIS)", THEME.Purple, function()
        if setclipboard then
        end
    end)
end

switchTab("mine")
