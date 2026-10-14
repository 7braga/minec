--[[
    ═══════════════════════════════════════════════════════════
    Eyez Hub TSB v5.0 — PARTE 1/3
    UI oxluu + Core + State
    Rebranded by Ousaware | Original by Eyez
    ═══════════════════════════════════════════════════════════
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser      = game:GetService("VirtualUser")
local TeleportService  = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")
local Stats            = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()
local Camera      = workspace.CurrentCamera
local IS_MOBILE   = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

-- ═══ DETECCIÓN TSB ═══
local IS_TSB = pcall(function()
    return ReplicatedStorage.Resources.Brother["#Friend"].Communicate
end)

local DashRemote = nil
if IS_TSB then
    pcall(function()
        DashRemote = ReplicatedStorage.Resources.Brother["#Friend"].Communicate
    end)
end

-- ═══ COLORES ═══
local C = {
    BG          = Color3.fromRGB(16, 16, 18),
    Header      = Color3.fromRGB(12, 12, 14),
    Card        = Color3.fromRGB(26, 26, 28),
    CardHover   = Color3.fromRGB(32, 32, 35),
    ElementBG   = Color3.fromRGB(38, 38, 42),
    ElementHover= Color3.fromRGB(46, 46, 50),
    ToggleOff   = Color3.fromRGB(45, 45, 50),
    ToggleOn    = Color3.fromRGB(80, 200, 120),
    Text        = Color3.fromRGB(235, 235, 240),
    TextDim     = Color3.fromRGB(150, 150, 158),
    TextMute    = Color3.fromRGB(100, 100, 108),
    White       = Color3.fromRGB(255, 255, 255),
    Accent      = Color3.fromRGB(80, 200, 120),
    Danger      = Color3.fromRGB(240, 80, 100),
    Warning     = Color3.fromRGB(255, 190, 70),
    GearIdle    = Color3.fromRGB(150, 150, 160),
    GearActive  = Color3.fromRGB(80, 200, 120),
    PanelBG     = Color3.fromRGB(0, 0, 0),
    TabActiveBG = Color3.fromRGB(52, 52, 58),
    TabActiveTX = Color3.fromRGB(235, 235, 240),
    TabHoverBG  = Color3.fromRGB(38, 38, 44),
    Keybind     = Color3.fromRGB(80, 150, 220),
}

local BorderWhite = {
    Card    = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.85},
    Window  = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.85},
    Divider = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.88},
    Element = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.8},
    Panel   = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.82},
    Slider  = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.75},
    ToggleOff = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.7},
    ToggleOn  = {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.45},
}

local FontBody, FontMedium, FontBold
pcall(function()
    FontBody   = Font.new("rbxasset://fonts/families/Inter.json", Enum.FontWeight.Regular)
    FontMedium = Font.new("rbxasset://fonts/families/Inter.json", Enum.FontWeight.Medium)
    FontBold   = Font.new("rbxasset://fonts/families/Inter.json", Enum.FontWeight.SemiBold)
end)

-- ═══ HELPERS ═══
local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r) return mk("UICorner", {CornerRadius = UDim.new(0, r or 6)}, p) end
local function cornerPill(p) return mk("UICorner", {CornerRadius = UDim.new(1, 0)}, p) end

local function strokeWhite(p, transparency, thickness)
    return mk("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 1,
        Transparency = transparency or 0.8,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end

local function tw(o, props, dur, style)
    local t = TweenService:Create(o, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad), props)
    t:Play()
    return t
end

local function pad(p, l, r, t, b)
    return mk("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
    }, p)
end

-- ═══ STATE ═══
local State = {
    -- Main
    WalkSpeedEnabled = false, WalkSpeedValue = 16,
    TouchFling = false, NoDashCD = false, AntiDeathCounter = false,
    -- Combat
    AutoBlock = false, AutoBlockRange = 12, AutoBlockDelay = 0.05,
    AutoCounter = false, AutoCounterRange = 15,
    AutoGrasp = false, AutoGraspRange = 10,
    AntiRagdoll = false,
    AutoUltimate = false, AutoTarget = false, AutoSpamSkills = false,
    SafeZoneTP = false,
    -- Hitbox/Reach
    HitboxEnabled = false, HitboxSize = 8, HitboxTransparency = 0.7,
    ReachEnabled = false, ReachStuds = 20,
    -- ESP
    ESPEnabled = false, ESPBox = true, ESPTracers = false, ESPNames = false,
    ESPDistance = false, ESPHealth = false, ESPTeamCheck = true,
    ESPMaxDistance = 1000,
    ESPBoxColor = Color3.fromRGB(80, 200, 120),
    ESPTracerColor = Color3.fromRGB(80, 200, 120),
    ESPTextColor = Color3.fromRGB(255, 255, 255),
    CounterESP = false,
    -- Techs
    MeowTech = false, MeowTechV2 = false,
    MeowStart = 0.3, MeowDuration = 0.3,
    KingTech = false, KingStart = 0.3, KingWait = 0.2,
    OreoTech = false, OreoStart = 0.3, OreoWait = 0.5, OreoCam = 1, OreoJump = 54,
    KittyDash = false, KittyStartJump = 0.1, KittyStart = 0.3, KittyWait = 0.1, KittyCam = 1,
    Kakyo = false, KakyoStart = 0.3, KakyoJump = 40, KakyoCam = 4,
    InnerDash = false, InnerLethal = false,
    InstantTwisted = false, LeeInstantTwisted = false,
    WaitPress = 0.2, LeeWait = 0.1, Turn = -90, LeeWait2 = 0.05, Turn2 = 115,
    LethalEnabled = false, LethalDash = false, InstantLethal = false, Boomy = false,
    MeowLethalStart = 1.7, NormalLethalStart = 1.7, SecondForFlip = 0.2,
    InstantLethalStart = 1.7, InstantLethalWait = 0.5,
    BoomyStart = 1.7, BoomyJump = 60, BoomyWait = 0.1, BoomyCam = 3,
    AutoKyoto = false, AutoKyotoTween = false, AutoKyotoLegit = false,
    SupaTech = false, LunarExtender = false, KyokieDash = false, BackDash = false,
    -- Movement
    FlyEnabled = false, FlySpeed = 60,
    -- Whitelist
    Whitelist = {}, WhitelistEnabled = true, FlingDelay = 0.3,
    -- Misc
    ShowFPS = false, InfoOverlay = false,
}

-- ═══ CONFIG ═══
local CONFIG_FILE = "EyezTSB_Config.json"

local function SaveConfig()
    if not writefile then return end
    local data = {}
    for k, v in pairs(State) do
        if typeof(v) == "Color3" then
            data[k] = {R = v.R, G = v.G, B = v.B, _type = "Color3"}
        elseif typeof(v) == "EnumItem" then
            data[k] = {Name = v.Name, EnumType = tostring(v.EnumType), _type = "Enum"}
        else
            data[k] = v
        end
    end
    pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if not readfile or not isfile or not isfile(CONFIG_FILE) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or not data then return false end
    for k, v in pairs(data) do
        if type(v) == "table" and v._type == "Color3" then
            State[k] = Color3.new(v.R, v.G, v.B)
        elseif type(v) == "table" and v._type == "Enum" then
            pcall(function()
                local enumType = Enum[v.EnumType]
                if enumType then State[k] = enumType[v.Name] end
            end)
        else
            if State[k] ~= nil then State[k] = v end
        end
    end
    return true
end

local function ResetConfig()
    if delfile and isfile and isfile(CONFIG_FILE) then
        pcall(function() delfile(CONFIG_FILE) end)
    end
end

-- ═══ SCREEN GUI ═══
local ScreenGui = mk("ScreenGui", {
    Name = "EyezTSB",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    IgnoreGuiInset = true,
}, CoreGui)

local ESPGui = mk("ScreenGui", {
    Name = "EyezTSB_ESP",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, CoreGui)

-- ═══ MAIN WINDOW ═══
local WIN_W = IS_MOBILE and 400 or 900
local WIN_H = IS_MOBILE and 500 or 620
local HEADER_H = 50

local Main = mk("Frame", {
    Size = UDim2.fromOffset(0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScreenGui)
corner(Main, 18)
strokeWhite(Main, BorderWhite.Window.Transparency, 1)
mk("UIShadow", {BlurRadius = UDim.new(0, 24), Transparency = 0.5}, Main)
tw(Main, {Size = UDim2.fromOffset(WIN_W, WIN_H)}, 0.5, Enum.EasingStyle.Quint)

-- Header
local Header = mk("Frame", {
    Size = UDim2.new(1, 0, 0, HEADER_H),
    BackgroundColor3 = C.Header,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Main)
mk("UICorner", {
    TopLeftRadius = UDim.new(0, 18),
    TopRightRadius = UDim.new(0, 18),
    BottomLeftRadius = UDim.new(0, 0),
    BottomRightRadius = UDim.new(0, 0),
}, Header)

mk("TextLabel", {
    Size = UDim2.new(0, 200, 0, 18),
    Position = UDim2.new(0, 16, 0, 8),
    BackgroundTransparency = 1,
    Text = "Eyez Hub",
    TextColor3 = C.Text,
    TextSize = 15,
    FontFace = FontBold,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, Header)

mk("TextLabel", {
    Size = UDim2.new(0, 300, 0, 14),
    Position = UDim2.new(0, 16, 0, 27),
    BackgroundTransparency = 1,
    Text = "by Ousaware | v5.0 | " .. (IS_TSB and "TSB detected" or "not in TSB"),
    TextColor3 = C.TextDim,
    TextSize = 11,
    FontFace = FontBody,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, Header)

local CloseBtn = mk("TextButton", {
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = C.Card,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = C.TextDim,
    TextSize = 12,
    FontFace = FontBold,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 10,
}, Header)
corner(CloseBtn, 10)
strokeWhite(CloseBtn, 0.75)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn, {BackgroundColor3 = C.Danger, BackgroundTransparency = 0, TextColor3 = C.White}, 0.15) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn, {BackgroundColor3 = C.Card, BackgroundTransparency = 0.5, TextColor3 = C.TextDim}, 0.15) end)
CloseBtn.MouseButton1Click:Connect(function()
    SaveConfig()
    tw(Main, {Size = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Quint)
    task.wait(0.35)
    ScreenGui:Destroy()
    ESPGui:Destroy()
end)

mk("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    ZIndex = 4,
}, Header)

-- Drag
do
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Tab bar
local TabBar = mk("Frame", {
    Size = UDim2.new(0, 700, 0, 26),
    Position = UDim2.new(1, -50, 0, 14),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
    ZIndex = 6,
}, Header)

local TabList = mk("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.X,
    ZIndex = 7,
}, TabBar)

mk("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 3),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
}, TabList)

-- Content
local ContentWrap = mk("Frame", {
    Size = UDim2.new(1, -20, 1, -(HEADER_H + 5)),
    Position = UDim2.new(0, 10, 0, HEADER_H + 5),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2,
}, Main)

local Content = mk("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = C.TextMute,
    ScrollBarImageTransparency = 0.5,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 2,
}, ContentWrap)

-- Info overlay
local InfoOverlay = mk("TextLabel", {
    Size = UDim2.new(0, 300, 0, 30),
    Position = UDim2.new(0, 10, 1, -50),
    BackgroundColor3 = C.Card,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Text = "",
    TextColor3 = C.Text,
    TextSize = 12,
    FontFace = FontMedium,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    Visible = false,
    ZIndex = 100,
    Parent = ScreenGui,
})
corner(InfoOverlay, 10)
strokeWhite(InfoOverlay, 0.7)
pad(InfoOverlay, 12, 12, 0, 0)

-- ═══ TABS ═══
local Tabs = {}
local CurrentTab = nil
local numCols = IS_MOBILE and 1 or 3

local function createTab(name)
    local TabBtn = mk("TextButton", {
        Size = UDim2.new(0, 0, 0, 26),
        BackgroundColor3 = C.TabActiveBG,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = name,
        TextColor3 = C.TextDim,
        TextSize = 12,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 7,
    }, TabList)
    cornerPill(TabBtn)
    mk("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)}, TabBtn)

    local TabContent = mk("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 2,
    }, Content)

    local ColFrame = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 2,
    }, TabContent)
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
    }, ColFrame)

    local tabCols = {}
    for i = 1, numCols do
        local col = mk("Frame", {
            Size = UDim2.new(1 / numCols, -(10 * (numCols - 1) / numCols), 0, 0),
            BackgroundTransparency = 1,
            LayoutOrder = i,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
        }, ColFrame)
        mk("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, col)
        tabCols[i] = {frame = col, height = 0}
    end

    TabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            tw(t.btn, {BackgroundColor3 = C.TabActiveBG, BackgroundTransparency = 1, TextColor3 = C.TextDim}, 0.15)
            t.content.Visible = false
        end
        tw(TabBtn, {BackgroundColor3 = C.TabActiveBG, BackgroundTransparency = 0, TextColor3 = C.TabActiveTX}, 0.15)
        TabContent.Visible = true
        CurrentTab = name
    end)
    TabBtn.MouseEnter:Connect(function()
        if CurrentTab ~= name then tw(TabBtn, {BackgroundColor3 = C.TabHoverBG, BackgroundTransparency = 0.5, TextColor3 = C.Text}, 0.15) end
    end)
    TabBtn.MouseLeave:Connect(function()
        if CurrentTab ~= name then tw(TabBtn, {BackgroundColor3 = C.TabActiveBG, BackgroundTransparency = 1, TextColor3 = C.TextDim}, 0.15) end
    end)

    local Tab = {name = name, btn = TabBtn, content = TabContent, cols = tabCols, cardIdx = 0}
    table.insert(Tabs, Tab)

    if #Tabs == 1 then
        task.defer(function()
            tw(TabBtn, {BackgroundColor3 = C.TabActiveBG, BackgroundTransparency = 0, TextColor3 = C.TabActiveTX}, 0.15)
            TabContent.Visible = true
            CurrentTab = name
        end)
    end
    return Tab
end

-- ═══ CARDS ═══
local function addCard(tab, title, icon)
    tab.cardIdx = tab.cardIdx + 1
    local bestIdx, minH = 1, math.huge
    for i, c in ipairs(tab.cols) do
        if c.height < minH then bestIdx = i; minH = c.height end
    end

    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0,
        LayoutOrder = tab.cardIdx,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
    }, tab.cols[bestIdx].frame)
    corner(card, 14)
    strokeWhite(card, BorderWhite.Card.Transparency, 1)
    pad(card, 14, 14, 12, 12)

    local vLayout = mk("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, card)

    local headFrame = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ZIndex = 4,
    }, card)

    mk("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Text,
        TextSize = 13,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
    }, headFrame)

    mk("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1,
        Text = icon or "○",
        TextColor3 = Color3.fromRGB(200, 200, 205),
        TextSize = 14,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
    }, headFrame)

    local divider = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = BorderWhite.Divider.Transparency,
        BorderSizePixel = 0,
        LayoutOrder = 2,
        ZIndex = 4,
    }, card)

    local Card = {frame = card, layout = vLayout, head = headFrame, divider = divider, idx = 2, colIdx = bestIdx, tab = tab}
    task.defer(function()
        tab.cols[bestIdx].height = tab.cols[bestIdx].height + card.AbsoluteSize.Y + 10
    end)
    return Card
end

-- ═══ SLIDER ═══
local function createSlider(parent, order, cfg)
    local lbl = cfg.Label or "Value"
    local minV = cfg.Min or 0
    local maxV = cfg.Max or 100
    local cur = cfg.Value or math.floor((minV + maxV) / 2)
    local cb = cfg.Callback or function() end
    local suffix = cfg.Suffix or ""

    local srow = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 6,
    }, parent)

    mk("TextLabel", {
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundTransparency = 1,
        Text = lbl,
        TextColor3 = C.Text,
        TextSize = 11,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 7,
    }, srow)

    local trackH = 4
    local track = mk("Frame", {
        Size = UDim2.new(1, -120, 0, trackH),
        Position = UDim2.new(0, 74, 0.5, -trackH/2),
        BackgroundColor3 = C.ToggleOff,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, srow)
    cornerPill(track)
    strokeWhite(track, BorderWhite.Slider.Transparency, 1)

    local fill = mk("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, track)
    cornerPill(fill)

    local thumb = mk("Frame", {
        Size = UDim2.new(0, 11, 0, 11),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0,
        ZIndex = 8,
    }, track)
    cornerPill(thumb)
    strokeWhite(thumb, 0.4, 1)

    local valLbl = mk("TextLabel", {
        Size = UDim2.new(0, 42, 1, 0),
        Position = UDim2.new(1, -42, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(cur) .. suffix,
        TextColor3 = C.Accent,
        TextSize = 11,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 7,
    }, srow)

    local click = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 12,
    }, track)

    local dragging = false
    local function setFrom(inp)
        local rx = math.clamp(inp.Position.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local pct = rx / track.AbsoluteSize.X
        local raw = minV + (maxV - minV) * pct
        local val = math.clamp(math.floor(raw + 0.5), minV, maxV)
        valLbl.Text = tostring(val) .. suffix
        local tp = (val - minV) / (maxV - minV)
        tw(fill, {Size = UDim2.new(tp, 0, 1, 0)}, 0.05)
        tw(thumb, {Position = UDim2.new(tp, 0, 0.5, 0)}, 0.05)
        pcall(cb, val)
    end

    click.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFrom(inp)
        end
    end)
    click.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            setFrom(inp)
        end
    end)

    local ip = (cur - minV) / (maxV - minV)
    fill.Size = UDim2.new(ip, 0, 1, 0)
    thumb.Position = UDim2.new(ip, 0, 0.5, 0)
end

-- ═══ KEYBIND ROW ═══
local function createKeybindRow(parent, order, kbCfg)
    local kbState = {
        Key = kbCfg.default or Enum.KeyCode.E,
        Mode = kbCfg.mode or "Toggle",
        Listening = false,
    }
    if kbCfg.onKey then pcall(kbCfg.onKey, kbState.Key) end

    local srow = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 6,
    }, parent)

    mk("TextLabel", {
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundTransparency = 1,
        Text = "Keybind",
        TextColor3 = C.Text,
        TextSize = 11,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }, srow)

    local kbBtn = mk("TextButton", {
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(0, 74, 0.5, -9),
        BackgroundColor3 = C.ElementBG,
        BorderSizePixel = 0,
        Text = kbState.Key.Name,
        TextColor3 = C.Keybind,
        TextSize = 10,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 15,
    }, srow)
    corner(kbBtn, 5)
    strokeWhite(kbBtn, 0.6)

    local modeBtn = mk("TextButton", {
        Size = UDim2.new(0, 60, 0, 18),
        Position = UDim2.new(1, -60, 0.5, -9),
        BackgroundColor3 = C.ElementBG,
        BorderSizePixel = 0,
        Text = kbState.Mode,
        TextColor3 = kbState.Mode == "Hold" and C.Warning or C.Accent,
        TextSize = 10,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 15,
    }, srow)
    corner(modeBtn, 5)
    strokeWhite(modeBtn, 0.6)

    kbBtn.MouseEnter:Connect(function() if not kbState.Listening then tw(kbBtn, {BackgroundColor3 = C.ElementHover}, 0.1) end end)
    kbBtn.MouseLeave:Connect(function() if not kbState.Listening then tw(kbBtn, {BackgroundColor3 = C.ElementBG}, 0.1) end end)
    modeBtn.MouseEnter:Connect(function() tw(modeBtn, {BackgroundColor3 = C.ElementHover}, 0.1) end)
    modeBtn.MouseLeave:Connect(function() tw(modeBtn, {BackgroundColor3 = C.ElementBG}, 0.1) end)

    kbBtn.MouseButton1Click:Connect(function()
        if kbState.Listening then return end
        kbState.Listening = true
        kbBtn.Text = "…"
        kbBtn.TextColor3 = C.Warning
    end)

    modeBtn.MouseButton1Click:Connect(function()
        if kbState.Mode == "Hold" then
            kbState.Mode = "Toggle"
            modeBtn.Text = "Toggle"
            modeBtn.TextColor3 = C.Accent
        else
            kbState.Mode = "Hold"
            modeBtn.Text = "Hold"
            modeBtn.TextColor3 = C.Warning
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if kbState.Listening then
            kbState.Key = input.KeyCode
            kbBtn.Text = input.KeyCode.Name
            kbBtn.TextColor3 = C.Keybind
            kbState.Listening = false
            if kbCfg.onKey then pcall(kbCfg.onKey, kbState.Key) end
            return
        end
        if kbState.Key and input.KeyCode == kbState.Key then
            if kbState.Mode == "Toggle" then
                if kbCfg.onPress then pcall(kbCfg.onPress) end
            elseif kbState.Mode == "Hold" then
                if kbCfg.onHoldStart then pcall(kbCfg.onHoldStart) end
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if kbState.Key and input.KeyCode == kbState.Key then
            if kbState.Mode == "Hold" and kbCfg.onHoldEnd then pcall(kbCfg.onHoldEnd) end
        end
    end)

    return kbState
end

-- ═══ TOGGLE (con gear + keybind) ═══
local function nextRow(card)
    card.idx = card.idx + 1
    return card.idx
end

local function addToggle(card, label, default, callback, config)
    config = config or {}
    local hasSliders = config.sliders and #config.sliders > 0
    local hasKeybind = config.keybind ~= nil
    local hasGear = hasSliders or hasKeybind

    local wrapper = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = nextRow(card),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 4,
    }, card.frame)
    mk("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, wrapper)

    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ZIndex = 4,
    }, wrapper)

    local tw_ = 42
    local th_ = 22
    local gearW = hasGear and 24 or 0
    local gearGap = hasGear and 8 or 0
    local totalRight = 8 + tw_ + gearGap + gearW
    local labelWidth = totalRight + 10

    mk("TextLabel", {
        Size = UDim2.new(1, -labelWidth, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Text,
        TextSize = 12,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
    }, row)

    local track = mk("Frame", {
        Size = UDim2.fromOffset(tw_, th_),
        Position = UDim2.new(1, -(8 + tw_), 0.5, -th_/2),
        BackgroundColor3 = default and C.ToggleOn or C.ToggleOff,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, row)
    cornerPill(track)

    local trackStroke = mk("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = default and BorderWhite.ToggleOn.Transparency or BorderWhite.ToggleOff.Transparency,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, track)

    local ks = th_ - 6
    local knob = mk("Frame", {
        Size = UDim2.fromOffset(ks, ks),
        Position = default and UDim2.new(1, -(ks + 3), 0.5, -ks/2) or UDim2.new(0, 3, 0.5, -ks/2),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, track)
    cornerPill(knob)

    local click = mk("TextButton", {
        Size = UDim2.new(0, tw_ + 10, 1, 0),
        Position = UDim2.new(1, -(tw_ + 10), 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 10,
    }, row)

    local state = default
    local function setState(newState, fireCallback)
        state = newState
        if state then
            tw(track, {BackgroundColor3 = C.ToggleOn}, 0.2)
            tw(trackStroke, {Transparency = BorderWhite.ToggleOn.Transparency}, 0.2)
            tw(knob, {Position = UDim2.new(1, -(ks + 3), 0.5, -ks/2)}, 0.2)
        else
            tw(track, {BackgroundColor3 = C.ToggleOff}, 0.2)
            tw(trackStroke, {Transparency = BorderWhite.ToggleOff.Transparency}, 0.2)
            tw(knob, {Position = UDim2.new(0, 3, 0.5, -ks/2)}, 0.2)
        end
        if fireCallback ~= false and callback then pcall(callback, state) end
    end

    click.MouseButton1Click:Connect(function() setState(not state) end)

    if hasGear then
        local gearBtn = mk("TextButton", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -(8 + tw_ + gearGap + 24), 0.5, -12),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "⋯",
            TextColor3 = C.GearIdle,
            TextSize = 16,
            FontFace = FontBold,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            ZIndex = 20,
        }, row)
        corner(gearBtn, 6)
        gearBtn.MouseEnter:Connect(function() if not gearBtn:GetAttribute("open") then tw(gearBtn, {TextColor3 = C.Text, BackgroundTransparency = 0.9}, 0.15) end end)
        gearBtn.MouseLeave:Connect(function() if not gearBtn:GetAttribute("open") then tw(gearBtn, {TextColor3 = C.GearIdle, BackgroundTransparency = 1}, 0.15) end end)

        local panel = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = C.PanelBG,
            BackgroundTransparency = 0.75,
            BorderSizePixel = 0,
            LayoutOrder = 2,
            ClipsDescendants = true,
            ZIndex = 5,
        }, wrapper)
        corner(panel, 10)
        strokeWhite(panel, BorderWhite.Panel.Transparency, 1)
        pad(panel, 10, 10, 8, 8)
        mk("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, panel)

        local itemCount = 0
        if hasSliders then
            for i, s in ipairs(config.sliders) do
                createSlider(panel, i, s)
                itemCount = i
            end
        end
        if hasKeybind then
            local kbCfg = config.keybind
            createKeybindRow(panel, itemCount + 1, {
                default = kbCfg.default, mode = kbCfg.mode,
                onKey = kbCfg.onKey,
                onPress = function() setState(not state) end,
                onHoldStart = function() if not state then setState(true) end end,
                onHoldEnd = function() if state then setState(false) end end,
            })
            itemCount = itemCount + 1
        end

        local totalH = itemCount * 22 + (itemCount - 1) * 6 + 16
        local isOpen = false
        gearBtn:SetAttribute("open", false)
        gearBtn.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            gearBtn:SetAttribute("open", isOpen)
            if isOpen then
                tw(panel, {Size = UDim2.new(1, 0, 0, totalH)}, 0.25, Enum.EasingStyle.Quint)
                tw(gearBtn, {Rotation = 90, TextColor3 = C.GearActive, BackgroundTransparency = 0.85}, 0.25)
            else
                tw(panel, {Size = UDim2.new(1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
                tw(gearBtn, {Rotation = 0, TextColor3 = C.GearIdle, BackgroundTransparency = 1}, 0.25)
            end
        end)
    end

    return {Set = setState, Get = function() return state end}
end

-- ═══ DROPDOWN ═══
local function addDropdown(card, label, options, default, callback)
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = nextRow(card),
        ZIndex = 4,
    }, card.frame)

    mk("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Text,
        TextSize = 12,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
    }, row)

    local dropW = 140
    local dropdown = mk("TextButton", {
        Size = UDim2.fromOffset(dropW, 26),
        Position = UDim2.new(1, -dropW, 0.5, -13),
        BackgroundColor3 = C.ElementBG,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5,
    }, row)
    corner(dropdown, 8)
    strokeWhite(dropdown, BorderWhite.Element.Transparency)

    local selLbl = mk("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        TextColor3 = C.Text,
        TextSize = 11,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 6,
    }, dropdown)

    mk("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text = "▾",
        TextColor3 = Color3.fromRGB(200, 200, 205),
        TextSize = 12,
        FontFace = FontBold,
        Font = Enum.Font.GothamBold,
        ZIndex = 6,
    }, dropdown)

    local listH = #options * 26
    local listF = mk("Frame", {
        Size = UDim2.fromOffset(dropW, 0),
        Position = UDim2.new(1, -dropW, 0.5, 16),
        BackgroundColor3 = C.ElementBG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 20,
    }, row)
    corner(listF, 10)
    strokeWhite(listF, BorderWhite.Element.Transparency)
    mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, listF)

    local isOpen = false
    local cur = default

    for i, opt in ipairs(options) do
        local optBtn = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            Text = "  " .. opt,
            TextColor3 = C.TextDim,
            TextSize = 11,
            FontFace = FontMedium,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = i,
            ZIndex = 21,
        }, listF)
        optBtn.MouseButton1Click:Connect(function()
            cur = opt
            selLbl.Text = opt
            isOpen = false
            tw(listF, {Size = UDim2.fromOffset(dropW, 0)}, 0.15)
            task.wait(0.15)
            listF.Visible = false
            if callback then pcall(callback, opt) end
        end)
        optBtn.MouseEnter:Connect(function() optBtn.TextColor3 = C.Text end)
        optBtn.MouseLeave:Connect(function() if opt ~= cur then optBtn.TextColor3 = C.TextDim end end)
    end

    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            listF.Visible = true
            tw(listF, {Size = UDim2.fromOffset(dropW, listH)}, 0.15)
        else
            tw(listF, {Size = UDim2.fromOffset(dropW, 0)}, 0.15)
            task.wait(0.15)
            listF.Visible = false
        end
    end)
end

-- ═══ BUTTON ═══
local function addButton(card, label, callback, color)
    color = color or C.ElementBG
    local row = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = label,
        TextColor3 = C.Text,
        TextSize = 12,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = nextRow(card),
        ZIndex = 4,
    }, card.frame)
    corner(row, 10)
    strokeWhite(row, 0.8)
    pad(row, 12, 12, 0, 0)
    row.MouseEnter:Connect(function() tw(row, {BackgroundColor3 = C.ElementHover}, 0.1) end)
    row.MouseLeave:Connect(function() tw(row, {BackgroundColor3 = color}, 0.1) end)
    row.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
end

-- ═══ INPUT (TextBox) ═══
local function addInput(card, label, placeholder, default, callback)
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = nextRow(card),
        ZIndex = 4,
    }, card.frame)

    mk("TextLabel", {
        Size = UDim2.new(0, 110, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Text,
        TextSize = 12,
        FontFace = FontMedium,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5,
    }, row)

    local box = mk("TextBox", {
        Size = UDim2.new(1, -120, 0, 24),
        Position = UDim2.new(0, 114, 0.5, -12),
        BackgroundColor3 = C.ElementBG,
        BorderSizePixel = 0,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = C.TextMute,
        TextColor3 = C.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 5,
    }, row)
    corner(box, 6)
    strokeWhite(box, 0.6)
    pad(box, 8, 8, 0, 0)

    box.FocusLost:Connect(function()
        if callback then pcall(callback, box.Text) end
    end)
end

-- ═══ FIN PARTE 1 ═══
--[[
    ═══════════════════════════════════════════════════════════
    Eyez Hub TSB v5.0 — PARTE 2/3
    Input + Techs + Combat + ESP (Frames) + Movement
    ═══════════════════════════════════════════════════════════
]]

-- ═══ INPUT SYSTEM ═══
local KeyCodeMap = {
    [Enum.KeyCode.Q] = 0x51, [Enum.KeyCode.W] = 0x57, [Enum.KeyCode.E] = 0x45,
    [Enum.KeyCode.R] = 0x52, [Enum.KeyCode.T] = 0x54, [Enum.KeyCode.F] = 0x46,
    [Enum.KeyCode.G] = 0x47, [Enum.KeyCode.S] = 0x53, [Enum.KeyCode.A] = 0x41,
    [Enum.KeyCode.D] = 0x44, [Enum.KeyCode.Z] = 0x5A, [Enum.KeyCode.X] = 0x58,
    [Enum.KeyCode.C] = 0x43, [Enum.KeyCode.One] = 0x31, [Enum.KeyCode.Two] = 0x32,
    [Enum.KeyCode.Three] = 0x33, [Enum.KeyCode.Four] = 0x34,
    [Enum.KeyCode.LeftShift] = 0xA0, [Enum.KeyCode.Space] = 0x20,
}

local function SendKeyUniversal(keyCode)
    pcall(function()
        if keypress and keyrelease then
            local vkCode = KeyCodeMap[keyCode]
            if vkCode then
                keypress(vkCode)
                task.wait(0.05)
                keyrelease(vkCode)
                return
            end
        end
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

local function SendM1()
    pcall(function()
        if mouse1click then mouse1click() return end
        if mouse1press and mouse1release then
            mouse1press() task.wait(0.05) mouse1release() return
        end
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

local function SendBlock()
    pcall(function()
        if keypress and keyrelease then
            keypress(0x46) task.wait(0.05) keyrelease(0x46) return
        end
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

local function SendDash()
    pcall(function()
        if keypress and keyrelease then
            keypress(0xA0) task.wait(0.05) keyrelease(0xA0) return
        end
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    end)
end

local function ForceTouchControls()
    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if not pg then return end
        local tg = pg:FindFirstChild("TouchGui")
        if tg then
            tg.Enabled = true
            local tf = tg:FindFirstChild("TouchControlFrame")
            if tf then
                for _, child in ipairs(tf:GetDescendants()) do
                    if child:IsA("GuiObject") then
                        child.Visible = true
                        child.Active = true
                    end
                end
            end
        end
    end)
end

-- ═══ UTIL FUNCTIONS ═══
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("LowerTorso")
        or char:FindFirstChild("Torso")
end

local function getMyHRP()
    local char = LocalPlayer.Character
    return char and getRoot(char)
end

local function getLiveFolder()
    return workspace:FindFirstChild("Live")
end

local function getClosestEnemy(maxDist)
    local myHRP = getMyHRP()
    if not myHRP then return nil end
    local live = getLiveFolder()
    if not live then return nil end
    local best, bestDist = nil, maxDist or 15
    for _, model in ipairs(live:GetChildren()) do
        if model:IsA("Model") and model ~= LocalPlayer.Character then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local root = getRoot(model)
                if root then
                    local dist = (root.Position - myHRP.Position).Magnitude
                    if dist < bestDist then best = root bestDist = dist end
                end
            end
        end
    end
    return best
end

local function getNearestHRP(maxRange)
    local myHRP = getMyHRP()
    if not myHRP then return nil end
    maxRange = maxRange or 25
    local closest, shortest = nil, maxRange
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local dist = (myHRP.Position - tHRP.Position).Magnitude
                if dist < shortest then shortest = dist closest = tHRP end
            end
        end
    end
    return closest
end

local function fireQ()
    if DashRemote then
        DashRemote:FireServer({ [1] = {Dash = Enum.KeyCode.W, Key = Enum.KeyCode.Q, Goal = "KeyPress"} })
    end
    SendKeyUniversal(Enum.KeyCode.Q)
end

local function forceJump(height)
    height = height or 50
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, height, hrp.Velocity.Z)
    end
end

local function flipCamera()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local cf = cam.CFrame
    local look = cf.LookVector
    local newLook = Vector3.new(-look.X, look.Y, -look.Z)
    cam.CFrame = CFrame.new(cf.Position, cf.Position + newLook)
end

-- ═══ ANIM IDs ═══
local UPPERCUT = {
    ["rbxassetid://10503381238"] = true,
    ["rbxassetid://13379003796"] = true,
}
local REQUIRED_ANIM_FOR_ATTACH = 10479335397
local TARGET_ANIM_ID = 12296113986
local M4_ANIM_ID = 13294471966

-- ═══ GLOBAL RUNTIME STATE (solo lo necesario) ═══
local Runtime = {
    hrp = nil,
    followConnection = nil,
    attachConnection = nil,
    isAttaching = false,
    attached = false,
    attachCooldown = false,
    onCooldown = false,
    didUppercut = false,
    flingConnection = nil,
    lastBlockTime = 0,
    lastCounterTime = 0,
    lastGraspTime = 0,
    lastUltimateTime = 0,
    lastSpamTime = 0,
    lastSafeZoneTP = 0,
    lastReload = 0,
    hiddenfling = false,
    flingPower = 10000,
}

-- ═══ ANTI DEATH (memory-safe) ═══
local AntiDeathConnection = nil
local function SetupAntiDeath(char)
    if AntiDeathConnection then AntiDeathConnection:Disconnect() end
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    local lastHealth = hum.Health
    AntiDeathConnection = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 and hrp.Position.Y <= 0 then
            hum.Health = lastHealth
        end
        if hum.Health > 0 then lastHealth = hum.Health end
    end)
end

-- ═══ TOUCH FLING (memory-safe) ═══
local function StartTouchFling()
    if Runtime.flingConnection then return end
    Runtime.flingConnection = RunService.Heartbeat:Connect(function()
        if not Runtime.hiddenfling then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local vel = hrp.Velocity
        hrp.Velocity = vel * Runtime.flingPower + Vector3.new(0, Runtime.flingPower, 0)
        RunService.RenderStepped:Wait()
        if hrp and hrp.Parent then
            hrp.Velocity = vel + Vector3.new(0, 0.1, 0)
        end
    end)
end
StartTouchFling()

-- ═══ ATTACH HELPERS ═══
local function detach()
    if Runtime.followConnection then
        Runtime.followConnection:Disconnect()
        Runtime.followConnection = nil
    end
    Runtime.attached = false
end

local function attachTo(enemyHRP, duration, ignoreAnim)
    if Runtime.attached then return end
    if not enemyHRP then return end
    local myHRP = Runtime.hrp or getMyHRP()
    if not myHRP then return end
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if not ignoreAnim then
        local animPlaying = false
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            local id = tonumber(track.Animation.AnimationId:match("%d+"))
            if id == REQUIRED_ANIM_FOR_ATTACH then animPlaying = true break end
        end
        if not animPlaying then return end
    end
    Runtime.attached = true
    local start = tick()
    Runtime.followConnection = RunService.Heartbeat:Connect(function()
        if not enemyHRP or not enemyHRP.Parent then detach() return end
        myHRP.CFrame = CFrame.new(enemyHRP.Position + Vector3.new(0, 1, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        if tick() - start >= (duration or 0.3) then detach() end
    end)
end

local function attachUnderTarget(targetChar, duration)
    if Runtime.isAttaching then return end
    if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    Runtime.isAttaching = true
    local endTime = os.clock() + duration
    Runtime.attachConnection = RunService.RenderStepped:Connect(function()
        if os.clock() >= endTime then
            if Runtime.attachConnection then
                Runtime.attachConnection:Disconnect()
                Runtime.attachConnection = nil
            end
            Runtime.isAttaching = false
            return
        end
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("HumanoidRootPart") and targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            c.HumanoidRootPart.CFrame = CFrame.new(targetChar.HumanoidRootPart.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        end
    end)
end

-- ═══ TECH: KAKYO CAMERA TRACK ═══
local function KakyoCamera(targetPart, speed, duration)
    local camLocal = workspace.CurrentCamera
    local startTime = tick()
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not targetPart or not targetPart.Parent then
            if conn then conn:Disconnect() end
            return
        end
        local camCF = camLocal.CFrame
        local camPos = camCF.Position
        local backPosition = targetPart.Position
        local dir = Vector3.new(backPosition.X - camPos.X, 0, backPosition.Z - camPos.Z)
        if dir.Magnitude > 0 then
            dir = dir.Unit
            local targetYaw = math.atan2(dir.Z, dir.X)
            local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
            local newYaw = currentYaw + (targetYaw - currentYaw) * speed
            local pitch = math.asin(camCF.LookVector.Y)
            local newLook = Vector3.new(math.cos(newYaw) * math.cos(pitch), math.sin(pitch), math.sin(newYaw) * math.cos(pitch))
            camLocal.CFrame = CFrame.new(camPos, camPos + newLook)
        end
        if tick() - startTime >= duration then
            if conn then conn:Disconnect() end
        end
    end)
end

-- ═══ TECH: INSTANT TWISTED (doTwisted) ═══
local function doTwisted2()
    local myHRP = getMyHRP()
    if not myHRP then return end
    local target = getNearestHRP(20)
    if not target then return end
    local cam = workspace.CurrentCamera
    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
    SendKeyUniversal(Enum.KeyCode.Q)
    local function rotateCamera(angle)
        local cf = cam.CFrame
        local look = cf.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude == 0 then flat = Vector3.new(0, 0, 1) end
        flat = flat.Unit
        local rot = CFrame.fromAxisAngle(Vector3.yAxis, math.rad(angle))
        cam.CFrame = CFrame.new(cf.Position, cf.Position + (rot * flat + Vector3.new(0, look.Y, 0)))
    end
    rotateCamera(-70)
    task.wait(0.50)
    rotateCamera(120)
end

-- ═══ INNER LETHAL / INNER DASH (función compartida) ═══
local function runInnerAttach(offset, lockedYMode)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hrp or not hum then return end

    local RANGE = 25
    local OFFSET = offset or Vector3.new(0, 7, 0)
    local LAY_ROT = CFrame.Angles(math.rad(90), 0, 0)
    local TWEEN_TIME = 0.2
    local AUTO_TIME = 1
    local MAX_DISTANCE = 30
    local attached = false
    local targetHRP
    local followConn
    local lockedY
    local storedCollisions = {}

    local function getTarget()
        local closest, shortest = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local dist = (hrp.Position - tHRP.Position).Magnitude
                    if dist < shortest and dist <= RANGE then
                        shortest = dist
                        closest = tHRP
                    end
                end
            end
        end
        return closest
    end

    local function disableCollision()
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                storedCollisions[part] = part.CanCollide
                part.CanCollide = false
            end
        end
    end

    local function restoreCollision()
        for part, state in pairs(storedCollisions) do
            if part and part.Parent then part.CanCollide = state end
        end
        storedCollisions = {}
    end

    local function detachLocal()
        if followConn then followConn:Disconnect() followConn = nil end
        hum.PlatformStand = false
        restoreCollision()
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        attached = false
        targetHRP = nil
        lockedY = nil
    end

    local function attachLocal()
        targetHRP = getTarget()
        if not targetHRP then return end
        attached = true
        hum.PlatformStand = true
        disableCollision()
        local startPos = Vector3.new(targetHRP.Position.X, targetHRP.Position.Y, targetHRP.Position.Z - 2)
        local endPos = startPos + OFFSET
        lockedY = endPos.Y
        hrp.CFrame = CFrame.new(startPos) * LAY_ROT
        TweenService:Create(hrp, TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = CFrame.new(endPos) * LAY_ROT
        }):Play()
        followConn = RunService.RenderStepped:Connect(function()
            if not attached or not targetHRP or not targetHRP.Parent then detachLocal() return end
            local pos = targetHRP.Position
            hrp.CFrame = CFrame.new(pos.X + OFFSET.X, lockedY, pos.Z + OFFSET.Z) * LAY_ROT
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            if (hrp.Position - targetHRP.Position).Magnitude > MAX_DISTANCE then detachLocal() end
        end)
        task.delay(AUTO_TIME, function()
            if attached then detachLocal() end
        end)
    end

    SendKeyUniversal(Enum.KeyCode.Q)
    if attached then detachLocal() else attachLocal() end
end

-- ═══ CHARACTER SETUP (solo una vez por personaje) ═══
local CharacterConnections = {}
local function setupCharacter(char)
    -- Limpiar conexiones previas
    if CharacterConnections.anim then CharacterConnections.anim:Disconnect() end
    if CharacterConnections.died then CharacterConnections.died:Disconnect() end

    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    Runtime.hrp = getRoot(char)

    local function cleanup()
        Runtime.attached = false
        if Runtime.followConnection then
            Runtime.followConnection:Disconnect()
            Runtime.followConnection = nil
        end
        Runtime.hrp = nil
    end

    CharacterConnections.died = humanoid.Died:Connect(cleanup)

    CharacterConnections.anim = humanoid.AnimationPlayed:Connect(function(track)
        local anim = track.Animation
        if not anim then return end
        local animIdNumber = tonumber(anim.AnimationId:match("%d+"))

        -- Uppercut tracking
        if UPPERCUT[anim.AnimationId] then
            Runtime.didUppercut = true
            task.delay(0.6, function() Runtime.didUppercut = false end)
        end

        -- onCooldown tracking
        if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
            Runtime.onCooldown = true
            task.delay(5, function() Runtime.onCooldown = false end)
        end

        -- ─── MEOW TECH ───
        if State.MeowTech and animIdNumber == REQUIRED_ANIM_FOR_ATTACH and Runtime.didUppercut then
            if Runtime.attached or Runtime.attachCooldown then return end
            Runtime.attachCooldown = true
            Runtime.didUppercut = false
            task.delay(0.35, function() Runtime.attachCooldown = false end)
            task.delay(0.08, function()
                local enemy = getClosestEnemy(12)
                if enemy then attachTo(enemy, 0.3, true) end
            end)
        end
        if State.MeowTech and UPPERCUT[anim.AnimationId] and not Runtime.attachCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(State.MeowStart, function()
                    fireQ()
                    attachTo(enemy, State.MeowDuration)
                end)
            end
        end

        -- ─── MEOW V2 ───
        if State.MeowTechV2 and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemyHRP = getClosestEnemy(10)
                if enemyHRP then
                    task.delay(State.MeowStart, function()
                        fireQ()
                        attachUnderTarget(enemyHRP.Parent, State.MeowDuration)
                    end)
                end
            end
        end

        -- ─── KING TECH ───
        if State.KingTech and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(State.KingStart, function()
                        fireQ()
                        forceJump()
                        task.delay(State.KingWait, flipCamera)
                    end)
                end
            end
        end

        -- ─── INNER LETHAL ───
        if State.InnerLethal and animIdNumber == TARGET_ANIM_ID then
            task.delay(1.7, function()
                runInnerAttach(Vector3.new(0, 7, 0), true)
            end)
        end

        -- ─── INNER DASH ───
        if State.InnerDash and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                task.delay(0.3, function()
                    runInnerAttach(Vector3.new(0, 3, 0), true)
                end)
            end
        end

        -- ─── KYOKIE DASH ───
        if State.KyokieDash and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(0.3, function()
                        local char2 = LocalPlayer.Character
                        if not char2 then return end
                        local hrp2 = char2:FindFirstChild("HumanoidRootPart")
                        local hum2 = char2:FindFirstChild("Humanoid")
                        if not hrp2 or not hum2 then return end
                        local OFFSET = Vector3.new(0, 7, 0)
                        local AUTO_TIME = 1
                        local kyokieConn
                        local function detachKyokie()
                            if kyokieConn then kyokieConn:Disconnect() kyokieConn = nil end
                            hum2.PlatformStand = false
                            hrp2.AssemblyLinearVelocity = Vector3.zero
                            hrp2.AssemblyAngularVelocity = Vector3.zero
                        end
                        SendKeyUniversal(Enum.KeyCode.Q)
                        local enemyRoot = getRoot(enemy.Parent)
                        if not enemyRoot then return end
                        local currentLook = hrp2.CFrame.LookVector
                        hrp2.CFrame = CFrame.new(enemyRoot.Position + OFFSET)
                        local startTime = tick()
                        kyokieConn = RunService.Heartbeat:Connect(function()
                            if not enemyRoot or not enemyRoot.Parent or tick() - startTime >= AUTO_TIME then
                                detachKyokie() return
                            end
                            hrp2.CFrame = CFrame.new(enemyRoot.Position.X + OFFSET.X, enemyRoot.Position.Y + OFFSET.Y, enemyRoot.Position.Z + OFFSET.Z) * CFrame.Angles(0, math.atan2(currentLook.X, currentLook.Z), 0)
                            hrp2.AssemblyLinearVelocity = Vector3.zero
                            hrp2.AssemblyAngularVelocity = Vector3.zero
                        end)
                        task.delay(AUTO_TIME, function()
                            if kyokieConn then detachKyokie() end
                        end)
                    end)
                end
            end
        end

        -- ─── INSTANT TWISTED ───
        if State.InstantTwisted and animIdNumber == M4_ANIM_ID then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(12)
                if enemy then
                    task.delay(0.25, function() doTwisted2() end)
                end
            end
        end

        -- ─── LEE INSTANT TWISTED ───
        if State.LeeInstantTwisted and animIdNumber == M4_ANIM_ID then
            if not Runtime.onCooldown then
                task.delay(State.WaitPress, function()
                    SendKeyUniversal(Enum.KeyCode.Q)
                    local camLocal = workspace.CurrentCamera
                    task.wait(State.LeeWait)
                    local cf = camLocal.CFrame
                    camLocal.CFrame = cf * CFrame.Angles(0, math.rad(State.Turn), 0)
                    task.wait(State.LeeWait2)
                    camLocal.CFrame = camLocal.CFrame * CFrame.Angles(0, math.rad(State.Turn2), 0)
                end)
            end
        end

        -- ─── KAKYO ───
        if State.Kakyo and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(State.KakyoStart, function()
                        forceJump(State.KakyoJump)
                        local targetChar = enemy.Parent
                        local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                        if targetPart then
                            KakyoCamera(targetPart, State.KakyoCam, 0.3)
                        end
                    end)
                end
            end
        end

        -- ─── OREO V2 (Kitty) ───
        if State.KittyDash and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(State.KittyStartJump, function() forceJump(60) end)
                    task.delay(State.KittyStart, function()
                        fireQ()
                        flipCamera()
                        task.wait(State.KittyWait)
                        local targetChar = enemy.Parent
                        local targetPart = targetChar:FindFirstChild("Left Arm") or getRoot(targetChar)
                        if targetPart then
                            KakyoCamera(targetPart, State.KittyCam, 0.2)
                        end
                    end)
                end
            end
        end

        -- ─── OREO (dripz) ───
        if State.OreoTech and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(State.OreoStart, function()
                        fireQ()
                        forceJump(State.OreoJump)
                    end)
                    task.delay(State.OreoWait, function()
                        local targetChar = enemy.Parent
                        local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                        if targetPart then
                            KakyoCamera(targetPart, State.OreoCam, 0.2)
                        end
                    end)
                end
            end
        end

        -- ─── BOOMY ───
        if State.Boomy and animIdNumber == TARGET_ANIM_ID then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(State.BoomyStart, function()
                    fireQ()
                    flipCamera()
                    forceJump(State.BoomyJump)
                    task.wait(0.1)
                    local targetChar = enemy.Parent
                    local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                    if targetPart then
                        KakyoCamera(targetPart, State.BoomyCam, 0.2)
                    end
                end)
            end
        end

        -- ─── INSTANT LETHAL ───
        if State.InstantLethal and animIdNumber == TARGET_ANIM_ID then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(10)
                if enemy then
                    task.delay(State.InstantLethalStart, function()
                        fireQ()
                        forceJump(60)
                        task.delay(State.InstantLethalWait, function() end)
                        local targetChar = enemy.Parent
                        local targetPart = targetChar:FindFirstChild("Right Arm") or getRoot(targetChar)
                        if targetPart then
                            KakyoCamera(targetPart, 3, 0.3)
                        end
                    end)
                end
            end
        end

        -- ─── SUPA TECH ───
        if State.SupaTech and not Runtime.attachCooldown and UPPERCUT[anim.AnimationId] then
            local enemy = getClosestEnemy(10)
            task.delay(0.3, function()
                if enemy then
                    local c = LocalPlayer.Character
                    local cHRP = c and c:FindFirstChild("HumanoidRootPart")
                    if cHRP then
                        forceJump()
                        fireQ()
                        cHRP.CFrame = cHRP.CFrame + (-cHRP.CFrame.LookVector * 13)
                    end
                end
            end)
        end

        -- ─── MEOW + LETHAL ───
        if State.LethalEnabled and animIdNumber == TARGET_ANIM_ID then
            task.delay(State.MeowLethalStart, function()
                local enemy = getClosestEnemy(10)
                if enemy then
                    fireQ()
                    attachTo(enemy, 0.5, true)
                end
            end)
        end

        -- ─── LETHAL DASH ───
        if State.LethalDash and animIdNumber == TARGET_ANIM_ID then
            task.delay(State.NormalLethalStart, function()
                forceJump()
                fireQ()
                task.delay(State.SecondForFlip, flipCamera)
            end)
        end

        -- ─── AUTO KYOTO ───
        if State.AutoKyoto and animIdNumber == 12273188754 then
            task.delay(1.6, function()
                local c = LocalPlayer.Character
                local cHRP = c and c:FindFirstChild("HumanoidRootPart")
                if cHRP then
                    SendKeyUniversal(Enum.KeyCode.Two)
                    local look = cHRP.CFrame.LookVector
                    local horiz = Vector3.new(look.X, 0, look.Z)
                    if horiz.Magnitude > 0 then horiz = horiz.Unit end
                    cHRP.CFrame = cHRP.CFrame + horiz * 22
                end
            end)
        end

        if State.AutoKyotoTween and animIdNumber == 12273188754 then
            task.delay(1.6, function()
                local c = LocalPlayer.Character
                local cHRP = c and c:FindFirstChild("HumanoidRootPart")
                if cHRP then
                    SendKeyUniversal(Enum.KeyCode.Two)
                    local conn = RunService.Heartbeat:Connect(function()
                        cHRP.AssemblyLinearVelocity = cHRP.CFrame.LookVector * 150
                    end)
                    task.delay(0.1, function() conn:Disconnect() end)
                end
            end)
        end

        if State.AutoKyotoLegit and animIdNumber == 12273188754 then
            task.delay(1.6, function()
                local c = LocalPlayer.Character
                local cHRP = c and c:FindFirstChild("HumanoidRootPart")
                if cHRP then
                    SendKeyUniversal(Enum.KeyCode.Two)
                    cHRP.CFrame = cHRP.CFrame + (cHRP.CFrame.LookVector * 30)
                end
            end)
        end

        -- ─── LUNAR EXTENDER ───
        if State.LunarExtender and UPPERCUT[anim.AnimationId] and not Runtime.attachCooldown then
            local enemyHRP = getClosestEnemy(10)
            if enemyHRP then
                task.delay(0.3, function() SendKeyUniversal(Enum.KeyCode.LeftShift) end)
                task.delay(0.5, function()
                    local start = tick()
                    while tick() - start < 0.3 do
                        local cHRP = getMyHRP()
                        if not cHRP or not enemyHRP or not enemyHRP.Parent then break end
                        local selfPos = cHRP.Position
                        local lookPos = enemyHRP.Position
                        if (lookPos - selfPos).Magnitude < 0.05 then
                            lookPos = lookPos + Vector3.new(0.1, 0, 0)
                        end
                        cHRP.CFrame = CFrame.lookAt(selfPos, lookPos)
                        task.wait()
                    end
                    SendKeyUniversal(Enum.KeyCode.LeftShift)
                end)
            end
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end

-- ═══ ANTI DEATH SETUP ═══
if LocalPlayer.Character then SetupAntiDeath(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(SetupAntiDeath)

-- ═══════════════════════════════════════════════════
-- COMBAT LOOPS (AutoBlock / Counter / Grasp / Ultimate / Target / Spam)
-- ═══════════════════════════════════════════════════

-- AutoBlock
local autoBlockConn = nil
local function startAutoBlock()
    if autoBlockConn then return end
    autoBlockConn = RunService.Heartbeat:Connect(function()
        if not State.AutoBlock then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local live = getLiveFolder()
        if not live then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local eHum = model:FindFirstChildOfClass("Humanoid")
                if eHum and eHum.Health > 0 then
                    local eRoot = getRoot(model)
                    if eRoot then
                        local dist = (eRoot.Position - myHRP.Position).Magnitude
                        if dist <= State.AutoBlockRange then
                            local attacking = false
                            for _, track in ipairs(eHum:GetPlayingAnimationTracks()) do
                                local id = tonumber(track.Animation.AnimationId:match("%d+"))
                                if id == 10479335397 or id == 10503381238 or id == 13379003796 then
                                    attacking = true break
                                end
                            end
                            if attacking and tick() - Runtime.lastBlockTime > State.AutoBlockDelay then
                                SendBlock()
                                Runtime.lastBlockTime = tick()
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- AutoCounter
local autoCounterConn = nil
local function startAutoCounter()
    if autoCounterConn then return end
    autoCounterConn = RunService.Heartbeat:Connect(function()
        if not State.AutoCounter then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local live = getLiveFolder()
        if not live then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local eHum = model:FindFirstChildOfClass("Humanoid")
                if eHum and eHum.Health > 0 then
                    local eRoot = getRoot(model)
                    if eRoot then
                        local dist = (eRoot.Position - myHRP.Position).Magnitude
                        if dist <= State.AutoCounterRange then
                            local attacking = false
                            for _, track in ipairs(eHum:GetPlayingAnimationTracks()) do
                                local id = tonumber(track.Animation.AnimationId:match("%d+"))
                                if id == 10479335397 or id == 10503381238 then
                                    attacking = true break
                                end
                            end
                            if attacking and tick() - Runtime.lastCounterTime > 0.1 then
                                SendKeyUniversal(Enum.KeyCode.Q)
                                task.wait(0.05)
                                SendBlock()
                                Runtime.lastCounterTime = tick()
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- AutoGrasp
local autoGraspConn = nil
local function startAutoGrasp()
    if autoGraspConn then return end
    autoGraspConn = RunService.Heartbeat:Connect(function()
        if not State.AutoGrasp then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local live = getLiveFolder()
        if not live then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local eHum = model:FindFirstChildOfClass("Humanoid")
                if eHum and eHum.Health > 0 then
                    local eRoot = getRoot(model)
                    if eRoot then
                        local dist = (eRoot.Position - myHRP.Position).Magnitude
                        if dist <= State.AutoGraspRange and tick() - Runtime.lastGraspTime > 0.15 then
                            SendKeyUniversal(Enum.KeyCode.Q)
                            task.wait(0.05)
                            SendM1()
                            task.wait(0.05)
                            SendKeyUniversal(Enum.KeyCode.Q)
                            Runtime.lastGraspTime = tick()
                        end
                    end
                end
            end
        end
    end)
end

-- Anti-Ragdoll
local antiRagdollConn = nil
local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.AntiRagdoll then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.PlatformStand then hum.PlatformStand = false end
        if hum:GetState() == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

-- Auto Ultimate
local autoUltConn = nil
local function startAutoUltimate()
    if autoUltConn then return end
    autoUltConn = RunService.Heartbeat:Connect(function()
        if not State.AutoUltimate then return end
        if tick() - Runtime.lastUltimateTime < 0.5 then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local live = getLiveFolder()
        if not live then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local eRoot = getRoot(model)
                if eRoot and (eRoot.Position - myHRP.Position).Magnitude <= 15 then
                    SendKeyUniversal(Enum.KeyCode.R)
                    Runtime.lastUltimateTime = tick()
                    break
                end
            end
        end
    end)
end

-- Auto Target
local autoTargetConn = nil
local function startAutoTarget()
    if autoTargetConn then return end
    autoTargetConn = RunService.RenderStepped:Connect(function()
        if not State.AutoTarget then return end
        local myHRP = getMyHRP()
        if not myHRP then return end
        local closest, dist = nil, 100
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local eRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local d = (eRoot.Position - myHRP.Position).Magnitude
                    if d < dist then dist = d closest = eRoot end
                end
            end
        end
        if closest then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position + Vector3.new(0, 1, 0))
        end
    end)
end

-- Auto Spam Skills
local autoSpamConn = nil
local function startAutoSpam()
    if autoSpamConn then return end
    autoSpamConn = RunService.Heartbeat:Connect(function()
        if not State.AutoSpamSkills then return end
        if tick() - Runtime.lastSpamTime < 0.15 then return end
        local myHRP = getMyHRP()
        if not myHRP then return end
        local live = getLiveFolder()
        if not live then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= LocalPlayer.Character then
                local eRoot = getRoot(model)
                if eRoot and (eRoot.Position - myHRP.Position).Magnitude <= 10 then
                    SendKeyUniversal(Enum.KeyCode.One)
                    task.wait(0.02)
                    SendKeyUniversal(Enum.KeyCode.Two)
                    Runtime.lastSpamTime = tick()
                    break
                end
            end
        end
    end)
end

-- Safe Zone TP
local safeZoneConn = nil
local function startSafeZoneTP()
    if safeZoneConn then return end
    safeZoneConn = RunService.Heartbeat:Connect(function()
        if not State.SafeZoneTP then return end
        if tick() - Runtime.lastSafeZoneTP < 5 then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if hum.Health < hum.MaxHealth * 0.3 then
            local spawn = workspace:FindFirstChild("SpawnLocation")
            if spawn then
                hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                Runtime.lastSafeZoneTP = tick()
            end
        end
    end)
end

-- Reach Extender
local reachConn = nil
local function startReach()
    if reachConn then return end
    reachConn = RunService.Heartbeat:Connect(function()
        if not State.ReachEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local live = getLiveFolder()
        if not live then return end
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local eHRP = model:FindFirstChild("HumanoidRootPart")
                if eHRP then
                    local dist = (eHRP.Position - hrp.Position).Magnitude
                    if dist <= State.ReachStuds then
                        eHRP.Size = Vector3.new(State.ReachStuds, State.ReachStuds, State.ReachStuds)
                        eHRP.CanCollide = false
                        eHRP.Massless = true
                    end
                end
            end
        end
    end)
end

-- Hitbox Loop
task.spawn(function()
    while true do
        task.wait(0.05)
        if State.HitboxEnabled then
            local live = getLiveFolder()
            if live then
                for _, model in ipairs(live:GetChildren()) do
                    if model:IsA("Model") and model ~= LocalPlayer.Character then
                        local hrp = model:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                            hrp.Transparency = State.HitboxTransparency
                            hrp.CanCollide = false
                            hrp.Massless = true
                        end
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════
-- ESP CON FRAMES
-- ═══════════════════════════════════════════════════
local ESPObjects = {}
local CounterHighlights = {}
local counterConnections = {}

local function removeESP(player)
    local d = ESPObjects[player]
    if not d then return end
    if d.box then d.box:Destroy() end
    if d.nameLbl then d.nameLbl:Destroy() end
    if d.distLbl then d.distLbl:Destroy() end
    if d.tracer then d.tracer:Destroy() end
    if d.healthBg then d.healthBg:Destroy() end
    if d.healthBar then d.healthBar:Destroy() end
    ESPObjects[player] = nil
end

local function createESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    local d = {}
    d.box = mk("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
    }, ESPGui)
    corner(d.box, 2)
    d.boxStroke = mk("UIStroke", {
        Color = State.ESPBoxColor,
        Thickness = 1.5,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, d.box)

    d.nameLbl = mk("TextLabel", {
        BackgroundTransparency = 1,
        TextColor3 = State.ESPTextColor,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextStrokeTransparency = 0.3,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        ZIndex = 7,
    }, ESPGui)

    d.distLbl = mk("TextLabel", {
        BackgroundTransparency = 1,
        TextColor3 = State.ESPTextColor,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextStrokeTransparency = 0.3,
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        ZIndex = 7,
    }, ESPGui)

    d.tracer = mk("Frame", {
        BackgroundColor3 = State.ESPTracerColor,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 4,
    }, ESPGui)

    d.healthBg = mk("Frame", {
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
    }, ESPGui)
    d.healthBar = mk("Frame", {
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 6,
    }, ESPGui)

    ESPObjects[player] = d
end

for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ESP Render Loop
RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local vp = camera.ViewportSize

    for player, d in pairs(ESPObjects) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        local function hideAll()
            d.box.Visible = false
            d.nameLbl.Visible = false
            d.distLbl.Visible = false
            d.tracer.Visible = false
            d.healthBg.Visible = false
            d.healthBar.Visible = false
        end

        if not State.ESPEnabled or not char or not hum or not hrp or hum.Health <= 0 then
            hideAll()
            continue
        end
        if State.ESPTeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            hideAll()
            continue
        end

        local dist3D = (hrp.Position - camera.CFrame.Position).Magnitude
        if dist3D > State.ESPMaxDistance then
            hideAll()
            continue
        end

        local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
        if not onScreen or pos.Z <= 0 then
            hideAll()
            continue
        end

        local top = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 2.5, 0))
        local bottom = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
        local height = math.abs(top.Y - bottom.Y)
        if height < 15 then height = 15 end
        local width = height * 0.7
        local boxX = pos.X - width / 2
        local boxY = pos.Y - height / 2

        if State.ESPBox then
            d.box.Position = UDim2.new(0, boxX, 0, boxY)
            d.box.Size = UDim2.new(0, width, 0, height)
            d.boxStroke.Color = State.ESPBoxColor
            d.box.Visible = true
        else
            d.box.Visible = false
        end

        if State.ESPNames then
            d.nameLbl.Text = player.Name
            d.nameLbl.Position = UDim2.new(0, boxX - 20, 0, boxY - 20)
            d.nameLbl.Size = UDim2.new(0, width + 40, 0, 16)
            d.nameLbl.Visible = true
        else
            d.nameLbl.Visible = false
        end

        if State.ESPDistance then
            d.distLbl.Text = math.floor(dist3D) .. "m"
            d.distLbl.Position = UDim2.new(0, boxX - 20, 0, boxY + height + 2)
            d.distLbl.Size = UDim2.new(0, width + 40, 0, 12)
            d.distLbl.Visible = true
        else
            d.distLbl.Visible = false
        end

        if State.ESPTracers then
            local originX = vp.X / 2
            local originY = vp.Y
            local toX = pos.X
            local toY = pos.Y
            local dx = toX - originX
            local dy = toY - originY
            local len = math.sqrt(dx * dx + dy * dy)
            if len < 1 then len = 1 end
            d.tracer.Position = UDim2.new(0, originX, 0, originY)
            d.tracer.Size = UDim2.new(0, len, 0, 1.5)
            d.tracer.Rotation = math.deg(math.atan2(dy, dx))
            d.tracer.AnchorPoint = Vector2.new(0, 0.5)
            d.tracer.BackgroundColor3 = State.ESPTracerColor
            d.tracer.Visible = true
        else
            d.tracer.Visible = false
        end

        if State.ESPHealth then
            local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            d.healthBg.Position = UDim2.new(0, boxX - 6, 0, boxY)
            d.healthBg.Size = UDim2.new(0, 3, 0, height)
            d.healthBg.Visible = true
            d.healthBar.Position = UDim2.new(0, boxX - 6, 0, boxY + height * (1 - hp))
            d.healthBar.Size = UDim2.new(0, 3, 0, height * hp)
            d.healthBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - hp), 255 * hp, 40)
            d.healthBar.Visible = true
        else
            d.healthBg.Visible = false
            d.healthBar.Visible = false
        end
    end
end)

-- Counter ESP (Highlight)
local function setupCounterWatch(char)
    if counterConnections[char] then
        for _, c in pairs(counterConnections[char]) do c:Disconnect() end
    end
    counterConnections[char] = {}
    local function checkAndAdd()
        for _, acc in ipairs(char:GetChildren()) do
            if acc:IsA("Accessory") and acc.Name == "Counter" then
                if not CounterHighlights[char] then
                    local h = Instance.new("Highlight")
                    h.Name = "CounterHL"
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 0, 0)
                    h.FillTransparency = 0.45
                    h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = char
                    h.Parent = char
                    CounterHighlights[char] = h
                end
                return
            end
        end
        if CounterHighlights[char] then
            CounterHighlights[char]:Destroy()
            CounterHighlights[char] = nil
        end
    end
    checkAndAdd()
    table.insert(counterConnections[char], char.ChildAdded:Connect(function(c)
        if c:IsA("Accessory") and c.Name == "Counter" then checkAndAdd() end
    end))
    table.insert(counterConnections[char], char.ChildRemoved:Connect(function(c)
        if c:IsA("Accessory") and c.Name == "Counter" then checkAndAdd() end
    end))
end

local function enableCounterESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then setupCounterWatch(plr.Character) end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(function(c)
                if State.CounterESP then setupCounterWatch(c) end
            end)
        end
    end
end

local function disableCounterESP()
    for char, h in pairs(CounterHighlights) do
        if h then h:Destroy() end
    end
    CounterHighlights = {}
    for char, conns in pairs(counterConnections) do
        for _, c in pairs(conns) do c:Disconnect() end
    end
    counterConnections = {}
end

-- ═══ FLY ═══
local flyBV, flyBG, flyConn
local function startFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    flyBG = Instance.new("BodyGyro")
    flyBG.P = 9e4
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp
    if flyConn then flyConn:Disconnect() end
    flyConn = RunService.Heartbeat:Connect(function()
        if not State.FlyEnabled or not hrp or not hrp.Parent then return end
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
        flyBV.Velocity = move.Magnitude > 0 and move.Unit * State.FlySpeed or Vector3.zero
        flyBG.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.LookVector)
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end) flyBG = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- ═══ FLING ALL ═══
local function isWhitelisted(name)
    if not State.WhitelistEnabled then return false end
    for _, n in ipairs(State.Whitelist) do
        if n:lower() == name:lower() then return true end
    end
    return false
end

local function flingAllPlayers()
    local live = getLiveFolder()
    if not live then return end
    task.spawn(function()
        local count = 0
        for _, model in ipairs(live:GetChildren()) do
            if model:IsA("Model") and model ~= LocalPlayer.Character then
                local plr = Players:GetPlayerFromCharacter(model)
                if plr and not isWhitelisted(plr.Name) then
                    local eHRP = model:FindFirstChild("HumanoidRootPart")
                    if eHRP then
                        eHRP.Velocity = Vector3.new(0, 500, 0) + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
                        eHRP.RotVelocity = Vector3.new(math.random(-100, 100), math.random(-100, 100), math.random(-100, 100))
                        count = count + 1
                        task.wait(State.FlingDelay)
                    end
                end
            end
        end
    end)
end

-- ═══ AUTOSAVE al cerrar ═══
pcall(function()
    game:BindToClose(function() SaveConfig() end)
end)

-- ═══ FIN PARTE 2 ═══
--[[
    ═══════════════════════════════════════════════════════════
    Eyez Hub TSB v5.0 — PARTE 3/3
    Tabs + UI + Init
    ═══════════════════════════════════════════════════════════
]]

-- ═══════════════════════════════════════════════════
-- TAB 1: MAIN
-- ═══════════════════════════════════════════════════
local tMain = createTab("Main")
local cMain = addCard(tMain, "Main", "●")

addToggle(cMain, "WalkSpeed", false, function(v)
    State.WalkSpeedEnabled = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v and State.WalkSpeedValue or 16 end
end, {
    keybind = {default = Enum.KeyCode.V, mode = "Toggle"},
    sliders = {
        {Label = "Speed", Min = 16, Max = 500, Value = 30, Callback = function(val)
            State.WalkSpeedValue = val
            if State.WalkSpeedEnabled then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = val end
            end
        end},
    }
})

addToggle(cMain, "Touch Fling", false, function(v)
    State.TouchFling = v
    Runtime.hiddenfling = v
end)

addToggle(cMain, "No Dash Cooldown", false, function(v)
    State.NoDashCD = v
    pcall(function()
        workspace:SetAttribute("NoDashCooldown", v)
        if v then workspace:SetAttribute("EffectAffects", 1) end
    end)
end)

addToggle(cMain, "Anti Death Counter", false, function(v)
    State.AntiDeathCounter = v
end)

-- Character persistence for walkspeed
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if State.WalkSpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.WalkSpeedValue end
    end
end)

-- Loop para mantener walkspeed
RunService.RenderStepped:Connect(function()
    if not State.WalkSpeedEnabled then return end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.WalkSpeed ~= State.WalkSpeedValue then
        hum.WalkSpeed = State.WalkSpeedValue
    end
end)

-- ═══════════════════════════════════════════════════
-- TAB 2: COMBAT
-- ═══════════════════════════════════════════════════
local tCombat = createTab("Combat")
local cAB = addCard(tCombat, "Auto Block", "◆")

addToggle(cAB, "Auto Block", false, function(v)
    State.AutoBlock = v
    if v then startAutoBlock() end
end, {
    keybind = {default = Enum.KeyCode.B, mode = "Toggle"},
    sliders = {
        {Label = "Range", Min = 5, Max = 30, Value = 12, Callback = function(val) State.AutoBlockRange = val end},
        {Label = "Delay", Min = 1, Max = 50, Value = 5, Suffix = "ds", Callback = function(val) State.AutoBlockDelay = val / 100 end},
    }
})

addToggle(cAB, "Auto Counter", false, function(v)
    State.AutoCounter = v
    if v then startAutoCounter() end
end, {
    keybind = {default = Enum.KeyCode.N, mode = "Toggle"},
    sliders = {
        {Label = "Range", Min = 5, Max = 30, Value = 15, Callback = function(val) State.AutoCounterRange = val end},
    }
})

addToggle(cAB, "Auto Grasp", false, function(v)
    State.AutoGrasp = v
    if v then startAutoGrasp() end
end, {
    sliders = {
        {Label = "Range", Min = 5, Max = 30, Value = 10, Callback = function(val) State.AutoGraspRange = val end},
    }
})

local cAuto = addCard(tCombat, "Automation", "○")

addToggle(cAuto, "Anti-Ragdoll", false, function(v)
    State.AntiRagdoll = v
    if v then startAntiRagdoll() end
end)

addToggle(cAuto, "Auto Ultimate", false, function(v)
    State.AutoUltimate = v
    if v then startAutoUltimate() end
end)

addToggle(cAuto, "Auto Target (Camlock)", false, function(v)
    State.AutoTarget = v
    if v then startAutoTarget() end
end, {
    keybind = {default = Enum.KeyCode.C, mode = "Hold"},
})

addToggle(cAuto, "Auto Spam Skills", false, function(v)
    State.AutoSpamSkills = v
    if v then startAutoSpam() end
end)

addToggle(cAuto, "Safe Zone TP", false, function(v)
    State.SafeZoneTP = v
    if v then startSafeZoneTP() end
end)

-- ═══════════════════════════════════════════════════
-- TAB 3: TECHS
-- ═══════════════════════════════════════════════════
local tTechs = createTab("Techs")

-- ═══ Meow ═══
local cMeow = addCard(tTechs, "Meow Tech", "✦")
addToggle(cMeow, "Meow Tech", false, function(v) State.MeowTech = v end, {
    keybind = {default = Enum.KeyCode.M, mode = "Toggle"},
    sliders = {
        {Label = "Start", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.MeowStart = val / 100 end},
        {Label = "Duration", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.MeowDuration = val / 100 end},
    }
})
addToggle(cMeow, "Meow Tech V2", false, function(v) State.MeowTechV2 = v end)

-- ═══ King ═══
local cKing = addCard(tTechs, "King Tech", "◆")
addToggle(cKing, "King Tech", false, function(v) State.KingTech = v end, {
    keybind = {default = Enum.KeyCode.K, mode = "Toggle"},
    sliders = {
        {Label = "Start", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.KingStart = val / 100 end},
        {Label = "Flip Wait", Min = 1, Max = 100, Value = 20, Suffix = "ds", Callback = function(val) State.KingWait = val / 100 end},
    }
})

-- ═══ Oreo ═══
local cOreo = addCard(tTechs, "Oreo Tech", "○")
addToggle(cOreo, "Oreo Tech", false, function(v) State.OreoTech = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.OreoStart = val / 100 end},
        {Label = "Jump", Min = 20, Max = 200, Value = 54, Callback = function(val) State.OreoJump = val end},
        {Label = "Wait", Min = 1, Max = 100, Value = 50, Suffix = "ds", Callback = function(val) State.OreoWait = val / 100 end},
        {Label = "Cam Speed", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.OreoCam = val / 10 end},
    }
})

-- ═══ Kitty ═══
local cKitty = addCard(tTechs, "Kitty Dash", "◉")
addToggle(cKitty, "Kitty Dash", false, function(v) State.KittyDash = v end, {
    sliders = {
        {Label = "Jump Time", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.KittyStartJump = val / 100 end},
        {Label = "Start", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.KittyStart = val / 100 end},
        {Label = "Rotate Wait", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.KittyWait = val / 100 end},
        {Label = "Cam Speed", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.KittyCam = val / 10 end},
    }
})

-- ═══ Kakyo ═══
local cKakyo = addCard(tTechs, "Kakyo", "◐")
addToggle(cKakyo, "Kakyo Under Flip", false, function(v) State.Kakyo = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.KakyoStart = val / 100 end},
        {Label = "Jump", Min = 20, Max = 200, Value = 40, Callback = function(val) State.KakyoJump = val end},
        {Label = "Cam Speed", Min = 1, Max = 100, Value = 40, Suffix = "ds", Callback = function(val) State.KakyoCam = val / 10 end},
    }
})

-- ═══ Inner ═══
local cInner = addCard(tTechs, "Inner Techs", "◎")
addToggle(cInner, "Inner Dash", false, function(v) State.InnerDash = v end)
addToggle(cInner, "Inner Lethal", false, function(v) State.InnerLethal = v end)

-- ═══ Instant Twisted ═══
local cTwist = addCard(tTechs, "Instant Twisted", "⊙")
addToggle(cTwist, "Instant Twisted", false, function(v) State.InstantTwisted = v end)
addToggle(cTwist, "Lee Instant Twisted", false, function(v) State.LeeInstantTwisted = v end, {
    sliders = {
        {Label = "Wait Press", Min = 1, Max = 100, Value = 20, Suffix = "ds", Callback = function(val) State.WaitPress = val / 100 end},
        {Label = "Lee Wait", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.LeeWait = val / 100 end},
        {Label = "Turn 1", Min = -180, Max = 180, Value = -90, Callback = function(val) State.Turn = val end},
        {Label = "Wait 2", Min = 1, Max = 100, Value = 5, Suffix = "ds", Callback = function(val) State.LeeWait2 = val / 100 end},
        {Label = "Turn 2", Min = -180, Max = 180, Value = 115, Callback = function(val) State.Turn2 = val end},
    }
})

-- ═══ Lethal ═══
local cLethal = addCard(tTechs, "Lethal Techs", "■")
addToggle(cLethal, "Meow + Lethal", false, function(v) State.LethalEnabled = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 300, Value = 170, Suffix = "ds", Callback = function(val) State.MeowLethalStart = val / 100 end},
    }
})
addToggle(cLethal, "Lethal Dash", false, function(v) State.LethalDash = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 300, Value = 170, Suffix = "ds", Callback = function(val) State.NormalLethalStart = val / 100 end},
        {Label = "Flip Wait", Min = 1, Max = 100, Value = 20, Suffix = "ds", Callback = function(val) State.SecondForFlip = val / 100 end},
    }
})
addToggle(cLethal, "Instant Lethal", false, function(v) State.InstantLethal = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 300, Value = 170, Suffix = "ds", Callback = function(val) State.InstantLethalStart = val / 100 end},
        {Label = "Rotate Wait", Min = 1, Max = 100, Value = 50, Suffix = "ds", Callback = function(val) State.InstantLethalWait = val / 100 end},
    }
})
addToggle(cLethal, "Boomy Instant Lethal", false, function(v) State.Boomy = v end, {
    sliders = {
        {Label = "Start", Min = 1, Max = 300, Value = 170, Suffix = "ds", Callback = function(val) State.BoomyStart = val / 100 end},
        {Label = "Jump", Min = 20, Max = 200, Value = 60, Callback = function(val) State.BoomyJump = val end},
        {Label = "Wait", Min = 1, Max = 100, Value = 10, Suffix = "ds", Callback = function(val) State.BoomyWait = val / 100 end},
        {Label = "Cam Speed", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.BoomyCam = val / 10 end},
    }
})

-- ═══ Kyoto ═══
local cKyoto = addCard(tTechs, "Kyoto", "✧")
addToggle(cKyoto, "Auto Kyoto", false, function(v) State.AutoKyoto = v end)
addToggle(cKyoto, "Auto Kyoto Tween", false, function(v) State.AutoKyotoTween = v end)
addToggle(cKyoto, "Auto Kyoto Legit", false, function(v) State.AutoKyotoLegit = v end)

-- ═══ Quick Techs ═══
local cQuick = addCard(tTechs, "Quick Techs", "⌬")
addToggle(cQuick, "Supa Tech", false, function(v) State.SupaTech = v end)
addToggle(cQuick, "Lunar Uppercut Extender", false, function(v) State.LunarExtender = v end)
addToggle(cQuick, "Kyokie Dash", false, function(v) State.KyokieDash = v end)
addToggle(cQuick, "Back Dash Cancel", false, function(v) State.BackDash = v end)

-- ═══════════════════════════════════════════════════
-- TAB 4: HITBOX / REACH
-- ═══════════════════════════════════════════════════
local tHitbox = createTab("Hitbox")
local cHitbox = addCard(tHitbox, "Hitbox Expander", "◆")

addToggle(cHitbox, "Enable Hitbox", false, function(v) State.HitboxEnabled = v end, {
    keybind = {default = Enum.KeyCode.H, mode = "Toggle"},
    sliders = {
        {Label = "Size", Min = 2, Max = 30, Value = 8, Callback = function(val) State.HitboxSize = val end},
        {Label = "Transparency", Min = 0, Max = 100, Value = 70, Suffix = "%", Callback = function(val) State.HitboxTransparency = val / 100 end},
    }
})

local cReach = addCard(tHitbox, "Reach Extender", "○")
addToggle(cReach, "Enable Reach", false, function(v)
    State.ReachEnabled = v
    if v then startReach() end
end, {
    keybind = {default = Enum.KeyCode.R, mode = "Toggle"},
    sliders = {
        {Label = "Studs", Min = 5, Max = 50, Value = 20, Callback = function(val) State.ReachStuds = val end},
    }
})

-- ═══════════════════════════════════════════════════
-- TAB 5: ESP
-- ═══════════════════════════════════════════════════
local tESP = createTab("ESP")
local cESP = addCard(tESP, "ESP", "◉")

addToggle(cESP, "Enable ESP", false, function(v)
    State.ESPEnabled = v
    if not v then
        for plr, _ in pairs(ESPObjects) do removeESP(plr) end
        for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
    end
end, {
    keybind = {default = Enum.KeyCode.P, mode = "Toggle"},
})

addToggle(cESP, "Box ESP", true, function(v) State.ESPBox = v end)
addToggle(cESP, "Names", false, function(v) State.ESPNames = v end)
addToggle(cESP, "Distance", false, function(v) State.ESPDistance = v end)
addToggle(cESP, "Health Bar", false, function(v) State.ESPHealth = v end)
addToggle(cESP, "Tracers", false, function(v) State.ESPTracers = v end)
addToggle(cESP, "Team Check", true, function(v) State.ESPTeamCheck = v end)

local cESPSettings = addCard(tESP, "ESP Settings", "⚙")
addToggle(cESPSettings, "Limit Distance", false, nil, {
    sliders = {
        {Label = "Max Dist", Min = 100, Max = 2000, Value = 1000, Callback = function(val) State.ESPMaxDistance = val end},
    }
})

addDropdown(cESPSettings, "Box Color", {"Green", "White", "Red", "Cyan", "Purple"}, "Green", function(v)
    local colors = {
        White = Color3.fromRGB(255, 255, 255),
        Green = Color3.fromRGB(80, 200, 120),
        Red = Color3.fromRGB(240, 80, 100),
        Cyan = Color3.fromRGB(80, 200, 255),
        Purple = Color3.fromRGB(180, 100, 255),
    }
    State.ESPBoxColor = colors[v] or Color3.fromRGB(80, 200, 120)
    for _, d in pairs(ESPObjects) do
        if d.boxStroke then d.boxStroke.Color = State.ESPBoxColor end
    end
end)

addToggle(cESPSettings, "Counter ESP", false, function(v)
    State.CounterESP = v
    if v then enableCounterESP() else disableCounterESP() end
end)

-- ═══════════════════════════════════════════════════
-- TAB 6: MOVEMENT
-- ═══════════════════════════════════════════════════
local tMove = createTab("Movement")
local cFly = addCard(tMove, "Fly", "✦")

addToggle(cFly, "Fly", false, function(v)
    State.FlyEnabled = v
    if v then startFly() else stopFly() end
end, {
    keybind = {default = Enum.KeyCode.F, mode = "Toggle"},
    sliders = {
        {Label = "Speed", Min = 20, Max = 300, Value = 60, Callback = function(val) State.FlySpeed = val end},
    }
})

-- ═══════════════════════════════════════════════════
-- TAB 7: FUN/TROLL
-- ═══════════════════════════════════════════════════
local tFun = createTab("Fun")
local cFling = addCard(tFun, "Fling All", "■")

addButton(cFling, "FLING ALL NOW", function()
    flingAllPlayers()
end, Color3.fromRGB(200, 60, 80))

addToggle(cFling, "Whitelist Enabled", true, function(v) State.WhitelistEnabled = v end, {
    sliders = {
        {Label = "Fling Delay", Min = 1, Max = 100, Value = 30, Suffix = "ds", Callback = function(val) State.FlingDelay = val / 100 end},
    }
})

local cWL = addCard(tFun, "Whitelist", "○")

local function addPlayerToWL(name)
    if not name or name == "" then return end
    for _, n in ipairs(State.Whitelist) do
        if n:lower() == name:lower() then return end
    end
    table.insert(State.Whitelist, name)
end

addInput(cWL, "Add Player", "Type player name...", "", function(input)
    addPlayerToWL(input)
end)

addInput(cWL, "Remove Player", "Type player name...", "", function(input)
    for i, n in ipairs(State.Whitelist) do
        if n:lower() == input:lower() then
            table.remove(State.Whitelist, i)
            break
        end
    end
end)

addButton(cWL, "Clear Whitelist", function()
    State.Whitelist = {}
end)

-- ═══════════════════════════════════════════════════
-- TAB 8: CONFIG
-- ═══════════════════════════════════════════════════
local tConfig = createTab("Config")

local cConfig = addCard(tConfig, "Config", "⚙")

addButton(cConfig, "💾 Save Config", function()
    SaveConfig()
end, Color3.fromRGB(60, 150, 90))

addButton(cConfig, "📂 Load Config", function()
    local ok = LoadConfig()
    if ok then
        -- Reaplicar toggles complejos
    end
end, Color3.fromRGB(80, 150, 200))

addButton(cConfig, "🗑️ Reset Config", function()
    ResetConfig()
end, Color3.fromRGB(200, 60, 80))

local cPresets = addCard(tConfig, "Presets", "◆")

addButton(cPresets, "🎯 Legit Preset", function()
    State.AutoBlock = false
    State.AutoCounter = false
    State.AutoGrasp = false
    State.KingTech = false
    State.MeowTech = false
    State.ESPNames = false
    State.ESPTracers = false
end)

addButton(cPresets, "💀 Rage Preset", function()
    State.AutoBlock = true
    State.AutoCounter = true
    State.AutoGrasp = true
    State.KingTech = true
    State.MeowTech = true
    State.InnerLethal = true
    State.ESPTracers = true
end, Color3.fromRGB(200, 80, 80))

local cInfo = addCard(tConfig, "About", "ℹ")
addButton(cInfo, "Eyez Hub TSB v5.0 | by Ousaware", function() end)
addButton(cInfo, "TSB Detected: " .. (IS_TSB and "YES" or "NO"), function() end)

-- ═══════════════════════════════════════════════════
-- INFO OVERLAY (FPS/PING)
-- ═══════════════════════════════════════════════════
local frameCount = 0
local lastFPS = tick()
local currentFPS = 60

task.spawn(function()
    while true do
        frameCount = frameCount + 1
        if tick() - lastFPS >= 1 then
            currentFPS = frameCount
            frameCount = 0
            lastFPS = tick()
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if State.InfoOverlay then
            local ping = 0
            pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
            InfoOverlay.Text = string.format("FPS: %d  |  Ping: %dms", currentFPS, ping)
            InfoOverlay.Visible = true
        else
            InfoOverlay.Visible = false
        end
    end
end)

-- Añadir overlay toggle en Config
local cOverlay = addCard(tConfig, "Overlay", "◉")
addToggle(cOverlay, "Show FPS/Ping", false, function(v) State.InfoOverlay = v end)

-- ═══════════════════════════════════════════════════
-- KEYBINDS GLOBALES
-- ═══════════════════════════════════════════════════
local isMinimized = false

local function ToggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        tw(Main, {Size = UDim2.fromOffset(Main.Size.X.Offset, HEADER_H)}, 0.3, Enum.EasingStyle.Quint)
        ContentWrap.Visible = false
        TabBar.Visible = false
    else
        tw(Main, {Size = UDim2.fromOffset(WIN_W, WIN_H)}, 0.3, Enum.EasingStyle.Quint)
        task.wait(0.15)
        ContentWrap.Visible = true
        TabBar.Visible = true
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.K and not (input.KeyCode == Enum.KeyCode.K) then
            -- K está reservada por el keybind de King Tech
        end
        -- Toggle UI con RightControl (para no chocar con keybinds de techs)
        if input.KeyCode == Enum.KeyCode.RightControl then
            Main.Visible = not Main.Visible
        end
        if input.KeyCode == Enum.KeyCode.RightAlt then
            if not Main.Visible then Main.Visible = true return end
            ToggleMinimize()
        end
    end
end)

-- ═══════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════
task.spawn(function()
    task.wait(0.5)
    LoadConfig()
end)

-- Reaplicar cosas que dependen de character
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if State.WalkSpeedEnabled then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.WalkSpeedValue end
    end
    if State.FlyEnabled then
        task.wait(0.3)
        startFly()
    end
end)

-- ═══════════════════════════════════════════════════
-- PRINT
-- ═══════════════════════════════════════════════════
print("════════════════════════════════════════")
print("  Eyez Hub TSB v5.0")
print("  by Ousaware")
print("════════════════════════════════════════")
print("  TSB Detected: " .. (IS_TSB and "YES" or "NO"))
print("  Tabs: Main | Combat | Techs | Hitbox | ESP | Movement | Fun | Config")
print("  RightCtrl = Ocultar/Mostrar UI")
print("  RightAlt  = Minimizar/Restaurar")
print("  Cada keybind se configura desde el panel ⋯")
print("════════════════════════════════════════")