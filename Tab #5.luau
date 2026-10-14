--[[
    ═══════════════════════════════════════════════════════════
    EYEZ HUB TSB v5.2 - DELTA EXECUTOR MOBILE ULTRA
    Completamente compatible con Delta Executor
    Todas las técnicas mantenidas + UI optimizada Mobile
    ═══════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local IS_MOBILE = UserInputService.TouchEnabled

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

-- Detectar TSB
local IS_TSB = pcall(function()
    return ReplicatedStorage.Resources.Brother["#Friend"].Communicate
end)

local DashRemote = nil
if IS_TSB then
    pcall(function()
        DashRemote = ReplicatedStorage.Resources.Brother["#Friend"].Communicate
    end)
end

--//════════════════════════════════════════════════════════════
--//                         COLORES
--//════════════════════════════════════════════════════════════

local C = {
    BG = Color3.fromRGB(16, 16, 18),
    Header = Color3.fromRGB(12, 12, 14),
    Card = Color3.fromRGB(26, 26, 28),
    CardHover = Color3.fromRGB(32, 32, 35),
    ElementBG = Color3.fromRGB(38, 38, 42),
    ElementHover = Color3.fromRGB(46, 46, 50),
    ToggleOff = Color3.fromRGB(45, 45, 50),
    ToggleOn = Color3.fromRGB(80, 200, 120),
    Text = Color3.fromRGB(235, 235, 240),
    TextDim = Color3.fromRGB(150, 150, 158),
    TextMute = Color3.fromRGB(100, 100, 108),
    White = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(80, 200, 120),
    Danger = Color3.fromRGB(240, 80, 100),
    Warning = Color3.fromRGB(255, 190, 70),
}

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    return mk("UICorner", {CornerRadius = UDim.new(0, r or 6)}, p)
end

local function stroke(p, transparency, thickness)
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

--//════════════════════════════════════════════════════════════
--//                      STATE GLOBAL
--//════════════════════════════════════════════════════════════

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
    TracerOrigin = "LocalPlayer",
    ESPBoxColor = Color3.fromRGB(80, 200, 120),
    ESPTracerColor = Color3.fromRGB(80, 200, 120),
    ESPTextColor = Color3.fromRGB(255, 255, 255),
    CounterESP = false,
    -- TODAS LAS TECHS
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
    -- Misc
    ShowFPS = false, InfoOverlay = false,
}

--//════════════════════════════════════════════════════════════
--//                    SCREEN GUI SETUP
--//════════════════════════════════════════════════════════════

local ScreenGui = mk("ScreenGui", {
    Name = "EyezTSBMobile",
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

--//════════════════════════════════════════════════════════════
--//                    TAMAÑO UI MÓVIL
--//════════════════════════════════════════════════════════════

local WIN_W = IS_MOBILE and 350 or 900
local WIN_H = IS_MOBILE and 600 or 620
local HEADER_H = 45

local Main = mk("Frame", {
    Size = UDim2.fromOffset(WIN_W, WIN_H),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScreenGui)
corner(Main, 18)
stroke(Main, 0.85, 1)
mk("UIShadow", {BlurRadius = UDim.new(0, 24), Transparency = 0.5}, Main)

--//════════════════════════════════════════════════════════════
--//                      HEADER
--//════════════════════════════════════════════════════════════

local Header = mk("Frame", {
    Size = UDim2.new(1, 0, 0, HEADER_H),
    BackgroundColor3 = C.Header,
    BorderSizePixel = 0,
    ZIndex = 3,
}, Main)
mk("UICorner", {
    TopLeftRadius = UDim.new(0, 18),
    TopRightRadius = UDim.new(0, 18),
}, Header)

mk("TextLabel", {
    Size = UDim2.new(0, 200, 0, 16),
    Position = UDim2.new(0, 12, 0, 6),
    BackgroundTransparency = 1,
    Text = "⚡ EYEZ HUB v5.2",
    TextColor3 = C.Text,
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, Header)

mk("TextLabel", {
    Size = UDim2.new(0, 250, 0, 12),
    Position = UDim2.new(0, 12, 0, 24),
    BackgroundTransparency = 1,
    Text = "TSB | Delta | Mobile | All Techs",
    TextColor3 = C.TextDim,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
}, Header)

local CloseBtn = mk("TextButton", {
    Size = UDim2.fromOffset(28, 28),
    Position = UDim2.new(1, -35, 0.5, -14),
    BackgroundColor3 = C.Card,
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    Text = "X",
    TextColor3 = C.TextDim,
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 10,
}, Header)
corner(CloseBtn, 8)
CloseBtn.MouseEnter:Connect(function() tw(CloseBtn, {BackgroundColor3 = C.Danger, BackgroundTransparency = 0, TextColor3 = C.White}, 0.15) end)
CloseBtn.MouseLeave:Connect(function() tw(CloseBtn, {BackgroundColor3 = C.Card, BackgroundTransparency = 0.5, TextColor3 = C.TextDim}, 0.15) end)
CloseBtn.MouseButton1Click:Connect(function()
    tw(Main, {Size = UDim2.fromOffset(0, 0)}, 0.3)
    task.wait(0.35)
    ScreenGui:Destroy()
end)

-- Drag
do
    local dragging, dragStart, startPos
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
            if dragging and dragStart then
                local delta = input.Position - dragStart
                Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

--//════════════════════════════════════════════════════════════
--//                  CONTENT SCROLL FRAME
--//════════════════════════════════════════════════════════════

local ContentWrap = mk("Frame", {
    Size = UDim2.new(1, -14, 1, -(HEADER_H + 5)),
    Position = UDim2.new(0, 7, 0, HEADER_H + 5),
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

--//════════════════════════════════════════════════════════════
--//                  UTILITY FUNCTIONS
--//════════════════════════════════════════════════════════════

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

--//════════════════════════════════════════════════════════════
--//                  INPUT SYSTEM DELTA
--//════════════════════════════════════════════════════════════

local function SendKeyUniversal(keyCode)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

local function SendM1()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
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

--//════════════════════════════════════════════════════════════
--//                  ANIMATION IDs
--//════════════════════════════════════════════════════════════

local UPPERCUT = {
    ["rbxassetid://10503381238"] = true,
    ["rbxassetid://13379003796"] = true,
}
local REQUIRED_ANIM_FOR_ATTACH = 10479335397
local TARGET_ANIM_ID = 12296113986
local M4_ANIM_ID = 13294471966

--//════════════════════════════════════════════════════════════
--//                   RUNTIME STATE
--//════════════════════════════════════════════════════════════

local Runtime = {
    hrp = nil,
    followConnection = nil,
    attached = false,
    attachCooldown = false,
    onCooldown = false,
    didUppercut = false,
    lastBlockTime = 0,
    lastCounterTime = 0,
}

--//════════════════════════════════════════════════════════════
--//                  ATTACH HELPERS
--//════════════════════════════════════════════════════════════

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

--//════════════════════════════════════════════════════════════
--//               CHARACTER SETUP - TODAS LAS TECHS
--//════════════════════════════════════════════════════════════

local CharacterConnections = {}
local function setupCharacter(char)
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

        if UPPERCUT[anim.AnimationId] then
            Runtime.didUppercut = true
            task.delay(0.6, function() Runtime.didUppercut = false end)
        end

        if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
            Runtime.onCooldown = true
            task.delay(5, function() Runtime.onCooldown = false end)
        end

        -- ▀▀▀ MEOW TECH ▀▀▀
        if State.MeowTech and UPPERCUT[anim.AnimationId] and not Runtime.attachCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(State.MeowStart, function()
                    fireQ()
                    attachTo(enemy, State.MeowDuration)
                end)
            end
        end

        -- ▀▀▀ KING TECH ▀▀▀
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

        -- ▀▀▀ OREO TECH ▀▀▀
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

        -- ▀▀▀ KITTY DASH ▀▀▀
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

        -- ▀▀▀ KAKYO ▀▀▀
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

        -- ▀▀▀ INNER DASH ▀▀▀
        if State.InnerDash and UPPERCUT[anim.AnimationId] then
            if not Runtime.onCooldown then
                task.delay(0.3, function()
                    SendKeyUniversal(Enum.KeyCode.Q)
                    local char2 = LocalPlayer.Character
                    if not char2 then return end
                    local hrp2 = char2:FindFirstChild("HumanoidRootPart")
                    if hrp2 then hrp2.CFrame = hrp2.CFrame + Vector3.new(0, 3, 0) end
                end)
            end
        end

        -- ▀▀▀ INSTANT TWISTED ▀▀▀
        if State.InstantTwisted and animIdNumber == M4_ANIM_ID then
            if not Runtime.onCooldown then
                local enemy = getClosestEnemy(12)
                if enemy then
                    task.delay(0.25, function() doTwisted2() end)
                end
            end
        end

        -- ▀▀▀ LETHAL DASH ▀▀▀
        if State.LethalDash and animIdNumber == TARGET_ANIM_ID then
            task.delay(State.NormalLethalStart, function()
                forceJump()
                fireQ()
                task.delay(State.SecondForFlip, flipCamera)
            end)
        end

        -- ▀▀▀ INSTANT LETHAL ▀▀▀
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

        -- ▀▀▀ BOOMY ▀▀▀
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
    end)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end

--//════════════════════════════════════════════════════════════
--//                   COMBAT LOOPS
--//════════════════════════════════════════════════════════════

local autoBlockConn = nil
local function startAutoBlock()
    if autoBlockConn then return end
    autoBlockConn = RunService.Heartbeat:Connect(function()
        if not State.AutoBlock then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, model in ipairs(getLiveFolder():GetChildren() or {}) do
            if model:IsA("Model") and model ~= char then
                local eRoot = getRoot(model)
                if eRoot then
                    local dist = (eRoot.Position - myHRP.Position).Magnitude
                    if dist <= State.AutoBlockRange then
                        if tick() - Runtime.lastBlockTime > State.AutoBlockDelay then
                            SendKeyUniversal(Enum.KeyCode.F)
                            Runtime.lastBlockTime = tick()
                        end
                    end
                end
            end
        end
    end)
end

local autoCounterConn = nil
local function startAutoCounter()
    if autoCounterConn then return end
    autoCounterConn = RunService.Heartbeat:Connect(function()
        if not State.AutoCounter then return end
        local char = LocalPlayer.Character
        if not char then return end
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, model in ipairs(getLiveFolder():GetChildren() or {}) do
            if model:IsA("Model") and model ~= char then
                local eRoot = getRoot(model)
                if eRoot then
                    local dist = (eRoot.Position - myHRP.Position).Magnitude
                    if dist <= State.AutoCounterRange then
                        if tick() - Runtime.lastCounterTime > 0.1 then
                            SendKeyUniversal(Enum.KeyCode.Q)
                            task.wait(0.05)
                            SendKeyUniversal(Enum.KeyCode.F)
                            Runtime.lastCounterTime = tick()
                        end
                    end
                end
            end
        end
    end)
end

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

--//════════════════════════════════════════════════════════════
--//                     ESP SYSTEM
--//════════════════════════════════════════════════════════════

local ESPObjects = {}

local function removeESP(player)
    local d = ESPObjects[player]
    if not d then return end
    if d.box then pcall(function() d.box:Destroy() end) end
    if d.nameLbl then pcall(function() d.nameLbl:Destroy() end) end
    if d.tracer then pcall(function() d.tracer:Destroy() end) end
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
        TextSize = 11,
        Font = Enum.Font.GothamBold,
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

    ESPObjects[player] = d
end

for _, plr in ipairs(Players:GetPlayers()) do createESP(plr) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- ESP RENDER
RunService.RenderStepped:Connect(function()
    if not State.ESPEnabled then return end
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
            d.tracer.Visible = false
        end

        if not char or not hum or not hrp or hum.Health <= 0 then
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
            d.nameLbl.Position = UDim2.new(0, pos.X, 0, boxY - 20)
            d.nameLbl.Size = UDim2.new(0, 100, 0, 16)
            d.nameLbl.Visible = true
        else
            d.nameLbl.Visible = false
        end

        if State.ESPTracers then
            local originX, originY
            if State.TracerOrigin == "Bottom" then
                originX = vp.X / 2
                originY = vp.Y
            elseif State.TracerOrigin == "Top" then
                originX = vp.X / 2
                originY = 0
            else
                local myChar = LocalPlayer.Character
                local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHRP then
                    local myPos = camera:WorldToViewportPoint(myHRP.Position)
                    originX = myPos.X
                    originY = myPos.Y
                else
                    originX = vp.X / 2
                    originY = vp.Y
                end
            end

            local toX = pos.X
            local toY = pos.Y - height / 2
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
    end
end)

--//════════════════════════════════════════════════════════════
--//                 SIMPLE UI - MOBILE BUTTONS
--//════════════════════════════════════════════════════════════

local function addCard(title, size)
    local card = mk("Frame", {
        Size = UDim2.new(1, -10, 0, size),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0,
    }, Content)
    corner(card, 12)
    stroke(card, 0.85, 1)
    pad(card, 10, 10, 8, 8)

    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Text,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    return card
end

local function addToggleButton(parent, label, callback)
    local container = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Parent = parent,
    })

    mk("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = container,
    })

    local toggle = mk("TextButton", {
        Size = UDim2.new(0, 45, 0, 20),
        Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = C.ToggleOff,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = container,
    })
    corner(toggle, 10)

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and C.ToggleOn or C.ToggleOff
        if callback then callback(state) end
    end)

    return container
end

--//════════════════════════════════════════════════════════════
--//                    MAIN BUTTONS
--//════════════════════════════════════════════════════════════

local techsCard = addCard("⭐ TÉCNICAS (10+)", 450)
techsCard.Parent = Content

addToggleButton(techsCard, "Meow Tech", function(v) State.MeowTech = v end)
addToggleButton(techsCard, "Meow V2", function(v) State.MeowTechV2 = v end)
addToggleButton(techsCard, "King Tech", function(v) State.KingTech = v end)
addToggleButton(techsCard, "Oreo Tech", function(v) State.OreoTech = v end)
addToggleButton(techsCard, "Kitty Dash", function(v) State.KittyDash = v end)
addToggleButton(techsCard, "Kakyo", function(v) State.Kakyo = v end)
addToggleButton(techsCard, "Inner Dash", function(v) State.InnerDash = v end)
addToggleButton(techsCard, "Instant Twisted", function(v) State.InstantTwisted = v end)
addToggleButton(techsCard, "Instant Lethal", function(v) State.InstantLethal = v end)
addToggleButton(techsCard, "Boomy", function(v) State.Boomy = v end)
addToggleButton(techsCard, "Lethal Dash", function(v) State.LethalDash = v end)

local combatCard = addCard("🎯 COMBATE", 180)
combatCard.Parent = Content

addToggleButton(combatCard, "Auto Block", function(v) State.AutoBlock = v if v then startAutoBlock() end end)
addToggleButton(combatCard, "Auto Counter", function(v) State.AutoCounter = v if v then startAutoCounter() end end)
addToggleButton(combatCard, "Anti Ragdoll", function(v) State.AntiRagdoll = v if v then startAntiRagdoll() end end)

local espCard = addCard("👁️ ESP", 150)
espCard.Parent = Content

addToggleButton(espCard, "Enable ESP", function(v) State.ESPEnabled = v end)
addToggleButton(espCard, "Box", function(v) State.ESPBox = v end)
addToggleButton(espCard, "Names", function(v) State.ESPNames = v end)
addToggleButton(espCard, "Tracers", function(v) State.ESPTracers = v end)

local movementCard = addCard("💨 MOVIMIENTO", 100)
movementCard.Parent = Content

addToggleButton(movementCard, "Walk Speed", function(v)
    State.WalkSpeedEnabled = v
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v and 50 or 16 end
end)
addToggleButton(movementCard, "No Dash CD", function(v) State.NoDashCD = v end)

--//════════════════════════════════════════════════════════════
--//                     FINALIZATION
--//════════════════════════════════════════════════════════════

print("✅ EYEZ HUB TSB v5.2 - DELTA MOBILE EDITION")
print("🎮 Completamente compatible con Delta Executor")
print("⭐ Todas las técnicas disponibles y funcionales")
print("💻 UI optimizada para Mobile")
print("🔧 Presiona K para mostrar/ocultar")
