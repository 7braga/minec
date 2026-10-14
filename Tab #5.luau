--[[
    ═══════════════════════════════════════════════════════════
    Eyez Hub TSB v5.0 — MOBILE LITE EDITION
    Optimizado para móviles sin crashes
    ═══════════════════════════════════════════════════════════
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera      = workspace.CurrentCamera
local IS_MOBILE   = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ═══ DETECCIÓN TSB ═══
local IS_TSB = pcall(function()
    return ReplicatedStorage.Resources.Brother["#Friend"].Communicate
end)

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")
local DashRemote = nil
if IS_TSB then
    pcall(function()
        DashRemote = ReplicatedStorage.Resources.Brother["#Friend"].Communicate
    end)
end

-- ═══ COLORES SIMPLIFICADOS ═══
local C = {
    BG          = Color3.fromRGB(16, 16, 18),
    Header      = Color3.fromRGB(12, 12, 14),
    Card        = Color3.fromRGB(26, 26, 28),
    Button      = Color3.fromRGB(80, 200, 120),
    ButtonHover = Color3.fromRGB(100, 220, 140),
    Text        = Color3.fromRGB(235, 235, 240),
    TextDim     = Color3.fromRGB(150, 150, 158),
}

-- ═══ HELPERS SIMPLIFICADOS ═══
local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    return mk("UICorner", {CornerRadius = UDim.new(0, r or 6)}, p)
end

-- ═══ STATE ═══
local State = {
    -- Combat
    AutoBlock = false,
    AutoCounter = false,
    AutoGrasp = false,
    AutoUltimate = false,
    -- Techs
    MeowTech = false,
    KingTech = false,
    OreoTech = false,
    KittyDash = false,
    -- Movement
    FlyEnabled = false,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16,
}

-- ═══ SCREEN GUI ═══
local ScreenGui = mk("ScreenGui", {
    Name = "EyezTSB_Lite",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global,
    IgnoreGuiInset = true,
}, CoreGui)

-- ═══ MAIN WINDOW (MÓVIL OPTIMIZADO) ═══
local WIN_W = IS_MOBILE and 300 or 800
local WIN_H = IS_MOBILE and 500 or 550
local HEADER_H = 35

local Main = mk("Frame", {
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScreenGui)
corner(Main, 8)

-- HEADER
local Header = mk("Frame", {
    Size = UDim2.new(1, 0, 0, HEADER_H),
    BackgroundColor3 = C.Header,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Main)
corner(Header, 8)

mk("TextLabel", {
    Size = UDim2.new(1, -30, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚡ Eyez Hub",
    TextColor3 = C.Button,
    TextSize = IS_MOBILE and 12 or 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, Header)

local CloseBtn = mk("TextButton", {
    Size = UDim2.fromOffset(25, 25),
    Position = UDim2.new(1, -30, 0.5, -12),
    BackgroundColor3 = Color3.fromRGB(220, 50, 50),
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    ZIndex = 5,
}, Header)
corner(CloseBtn, 4)

-- CONTENT AREA (ScrollingFrame para no lag)
local Content = mk("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -HEADER_H),
    Position = UDim2.new(0, 0, 0, HEADER_H),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ZIndex = 2,
}, Main)

mk("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, Content)

mk("UIPadding", {
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 8),
    PaddingBottom = UDim.new(0, 8),
}, Content)

-- ═══ CREAR SECCIONES ═══
local function CreateSection(title, order)
    local section = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0,
        LayoutOrder = order,
        AutomaticSize = Enum.AutomaticSize.Y,
    }, Content)
    corner(section, 6)
    
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Button,
        TextSize = IS_MOBILE and 10 or 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        LayoutOrder = 1,
    }, section)
    
    mk("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, section)
    
    mk("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
    }, section)
    
    return section
end

-- ═══ CREAR TOGGLE ═══
local function CreateToggle(parent, label, stateKey, order)
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = order,
    }, parent)
    
    mk("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Text,
        TextSize = IS_MOBILE and 8 or 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, row)
    
    local toggle = mk("TextButton", {
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundColor3 = State[stateKey] and C.Button or Color3.fromRGB(60, 60, 70),
        BorderSizePixel = 0,
        Text = State[stateKey] and "ON" or "OFF",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 8,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    }, row)
    corner(toggle, 3)
    
    toggle.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        toggle.BackgroundColor3 = State[stateKey] and C.Button or Color3.fromRGB(60, 60, 70)
        toggle.Text = State[stateKey] and "ON" or "OFF"
    end)
end

-- ═══ CREAR BOTÓN ═══
local function CreateButton(parent, label, callback, order)
    local btn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundColor3 = C.Button,
        BorderSizePixel = 0,
        Text = label,
        TextColor3 = Color3.new(0, 0, 0),
        TextSize = IS_MOBILE and 9 or 11,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = order,
    }, parent)
    corner(btn, 4)
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        task.wait(0.1)
        btn.BackgroundColor3 = C.Button
        pcall(callback)
    end)
end

-- ═══ SECCIONES DE LA UI ═══

-- COMBAT
local CombatSection = CreateSection("⚔️ COMBAT", 1)
CreateToggle(CombatSection, "Auto Block", "AutoBlock", 1)
CreateToggle(CombatSection, "Auto Counter", "AutoCounter", 2)
CreateToggle(CombatSection, "Auto Grasp", "AutoGrasp", 3)
CreateToggle(CombatSection, "Auto Ultimate", "AutoUltimate", 4)

-- TECHS
local TechsSection = CreateSection("✨ TECHS (Ligero)", 2)
CreateToggle(TechsSection, "Meow Tech", "MeowTech", 1)
CreateToggle(TechsSection, "King Tech", "KingTech", 2)
CreateToggle(TechsSection, "Oreo Tech", "OreoTech", 3)
CreateToggle(TechsSection, "Kitty Dash", "KittyDash", 4)

-- MOVEMENT
local MoveSection = CreateSection("🏃 MOVEMENT", 3)
CreateToggle(MoveSection, "Walk Speed", "WalkSpeedEnabled", 1)
CreateToggle(MoveSection, "Fly", "FlyEnabled", 2)

-- ═══ DRAGGABLE ═══
local dragging = false
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragStart then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ═══ CLOSE BUTTON ═══
CloseBtn.MouseButton1Click:Connect(function()
    Main:Destroy()
end)

-- ═══ IMPLEMENTACIÓN DE FEATURES LIGERA ═══

-- Walk Speed
RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and State.WalkSpeedEnabled then
        Humanoid.WalkSpeed = State.WalkSpeedValue
    end
end)

-- Auto Block (VERSIÓN ULTRALIGERA - SIN CRASHES)
RunService.Heartbeat:Connect(function()
    if not State.AutoBlock or not IS_TSB or not DashRemote then return end
    
    pcall(function()
        -- Ejecutar solo cada 3 frames para no saturar
        if tick() % 0.15 > 0.08 then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Enviar comando de bloqueo de forma simple y sin loops
        pcall(function()
            DashRemote:FireServer("Block")
        end)
    end)
end)

-- Auto Counter (VERSIÓN ULTRALIGERA - SIN CRASHES)
RunService.Heartbeat:Connect(function()
    if not State.AutoCounter or not IS_TSB or not DashRemote then return end
    
    pcall(function()
        if tick() % 0.20 > 0.10 then return end
        
        local char = LocalPlayer.Character
        if not char then return end
        
        pcall(function()
            DashRemote:FireServer("Counter")
        end)
    end)
end)

-- Tech execution (ULTRA SIMPLE - SIN MEMORY LEAK)
local TechLoops = {}

local function SetupTechLoop(techName, stateKey)
    if TechLoops[techName] then
        pcall(function() TechLoops[techName]:Disconnect() end)
        TechLoops[techName] = nil
    end
    
    if State[stateKey] then
        TechLoops[techName] = RunService.Heartbeat:Connect(function()
            if not State[stateKey] or not LocalPlayer.Character then return end
            
            pcall(function()
                if tick() % 0.3 > 0.15 then return end
                
                local char = LocalPlayer.Character
                if not char or not DashRemote then return end
                
                -- Ejecutar tech con delays para evitar crashes
                DashRemote:FireServer("Tech", techName)
                task.wait(0.05)
            end)
        end)
    end
end

-- Monitorear cambios de state
for techName in pairs({MeowTech = true, KingTech = true, OreoTech = true, KittyDash = true}) do
    local stateKey = techName
    RunService.Heartbeat:Connect(function()
        if State[stateKey] and not TechLoops[techName] then
            SetupTechLoop(techName, stateKey)
        elseif not State[stateKey] and TechLoops[techName] then
            pcall(function() TechLoops[techName]:Disconnect() end)
            TechLoops[techName] = nil
        end
    end)
end

-- ═══ GARBAGE COLLECTION AGRESIVO ═══
game:GetService("RunService").Stepped:Connect(function()
    if tick() % 5 > 4.5 then
        collectgarbage("collect")
    end
end)

-- ═══ CLEANUP AL CERRAR ═══
LocalPlayer.CharacterAdded:Connect(function()
    for _, loop in pairs(TechLoops) do
        pcall(function() loop:Disconnect() end)
    end
end)

print("════════════════════════════════════════")
print("  ✅ Eyez Hub TSB - MOBILE LITE LOADED")
print("════════════════════════════════════════")
print("  Device: " .. (IS_MOBILE and "📱 MOBILE" or "🖥️ DESKTOP"))
print("  TSB Detected: " .. (IS_TSB and "✅ YES" or "❌ NO"))
print("════════════════════════════════════════")
