local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local webhook = "https://discord.com/api/webhooks/1554482088869371908/BDQlRiXrzBgIdu2v4wedTNZprXGHPEt4l75kCCVqYxmuIjpmWcF1POPdoVoqG1Mq4qMo"

local executor = "Unknown"
pcall(function()
    if identifyexecutor then
        executor = identifyexecutor()
    end
end)

local data = {
    username = "executor info",
    embeds = {{
        title = "Script Executed",
        color = 65280,
        fields = {
            { name = "Username", value = player.Name, inline = true },
            { name = "UserId", value = tostring(player.UserId), inline = true },
            { name = "Executor", value = executor, inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true }
        }
    }}
}

local json = HttpService:JSONEncode(data)

local req = (syn and syn.request) or request or http_request
if req then
    req({
        Url = webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = json
    })
else
    warn("No HTTP request support")
end


local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/7braga/ui.lua/refs/heads/main/jjjkj%7B.lua"))()

WindUI:Notify({
                        Title = "OUSA Hub is Back",
                        Content = "Lunched OUSA hub 6.7",
                        Duration = 3
                    })



WindUI:Popup({
    Title = "Discord",
    Icon = "info",
    Content = "Join our Discord server!",
    Buttons = {
        {
            Title = "Cancel",
            Variant = "Tertiary",
            Callback = function()
                -- nothing
            end,
        },
        {
            Title = "Copy Discord",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function()
                if setclipboard then
                    setclipboard("https://discord.gg/dCnvGNYANP")
                    WindUI:Notify({
                        Title = "Copied!",
                        Content = "Discord invite copied to clipboard.",
                        Duration = 3
                    })
                else
                    warn("Clipboard function not supported by this executor.")
                end
            end,
        }
    }
})






-- Update your window creation with the new theme
local Window = WindUI:CreateWindow({
    Title = "OUSA Hub",
    Icon = "moon",
    Author = "by archi",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(800, 700),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(1000, 1000),
    Transparent = true,
    Theme = "Dark",  -- Changed to new theme
    Resizable = true,
	Background = "rbxassetid://134927494800983",
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.3,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

--//CONTIUNE HERE!!




Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "OUSA Hub by archi",
    Icon = "moon",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- blue gradient for glow
        Color3.fromHex("1e40ff"), -- deep blue
        Color3.fromHex("60a5fa")  -- lighter neon blue
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local main = Window:Tab({
    Title = "Main",
    Locked = false,
})

local Techs = Window:Tab({
    Title = "Techs/Macro",
    Locked = false,
})

local meowtech = Window:Tab({
    Title = "meowtech/uppercut",
    Locked = false,
})



local k1ngtech = Window:Tab({
    Title = "k1ng tech/uppercut",
    Locked = false,
})

local oreo = Window:Tab({
    Title = "Oreo tech/uppercut",
    Locked = false,
})

local kitty = Window:Tab({
    Title = "kitty tech/uppercut",
    Locked = false,
})

local kak = Window:Tab({
    Title = "kakyo tech/uppercut",
    Locked = false,
})

local inner = Window:Tab({
    Title = "inner dash/uppercut",
    Locked = false,
})

local instanttwis = Window:Tab({
    Title = "instant twisted/m4",
    Locked = false,
})

local lethal = Window:Tab({
    Title = "lethal/lethalwhirlwind",
    Locked = false,
})



local tech = Window:Tab({
    Title = "kyoto",
    Locked = false,
})

local plat = Window:Tab({
    Title = "youtube/tiktok/discord",
    Locked = false,
})


local tp = Window:Tab({
    Title = "teleport",
    Locked = false,
})


local esp = Window:Tab({
    Title = "Esp",
    Locked = false,
})

local M1reset = Window:Tab({
    Title = "m1 reset",
    Locked = false,
})

local reduce = Window:Tab({
    Title = "reduce lag",
    Locked = false,
})




main:Select() -- Select Tab

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera
local DashRemote = ReplicatedStorage.Resources.Brother["#Friend"].Communicate

-- CONSTANTS
local UPPERCUT = {
    ["rbxassetid://10503381238"] = true,
    ["rbxassetid://13379003796"] = true,
}
local REQUIRED_ANIM_FOR_ATTACH = 10479335397
local TARGET_ANIM_ID = 12296113986 -- Instant Lethal Trigger
local M4_ANIM_ID = 13294471966 -- your new animation


--var
local hrp
local followConnection
local attached = false
local MeowTechEnabled = false
local lethalEnabled = false
local KingTechEnabled = false
local LethalDashEnabled = false
local attachCooldown = false
local AutoKyotoEnabled = false
local lunarextender = false
local AutoKyotoLegitEnabled = false
local oreov2 = false
local oreorev = false
local kyokiedash = false

local didUppercut = false
local dripz = false
local GlobalCooldown = false
local GlobalCooldownTime = 5 -- seconds

local instanttwistedv2 = false
local instantlethal = false
local deathcounter = false
local AutoKyototween = false
local meowtechv2 = false
local boomy = false
local kakyo = false

--meowsetting
local meowstart = 0.3
local meowDuration = 0.3

--kingsetting
local kingstart = 0.3
local kingwait = 0.2

--oreosettings
local oreostart = 0.3
local oreowait = 0.5
local oreocam = 1
local oreojump = 54

--kittysettings
local kittystartjump = 0.1
local kittystart = 0.3
local kittywait = 0.1
local kittycam = 1
local kittydur = 0.2

--kakyosettings
local kakyostart = 0.3
local kakyojump = 40
local kakyocam = 4

--leeset
local waitpress = 0.2
local leewait = 0.2
local turn = -90
local leewait2 = 0.05
local turn2 = 115

--lethal settings
--meowlethal
local meowlethalstart = 1.7
local meowlethaldur = 0.5
--normallethal
local normallethalstart = 1.7
local secondforflip = 0.2

local instantlethalstart = 1.7
local instantlethalwait = 0.5

local boomystart = 1.7
local boomyjump = 65
local boomywait = 0.1
local boomycam = 3
-- UTIL FUNCTIONS
local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("LowerTorso")
        or char:FindFirstChild("Torso")
end





-- ATTACH / DETACH


local hiddenfling = false
local flingPower = 10000
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

local function flingLoop()
    local hrp, c, vel, movel = nil, nil, nil, 0.1
    while true do
        RunService.Heartbeat:Wait()
        if hiddenfling then
            c = lp.Character
            hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                vel = hrp.Velocity
                hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                RunService.RenderStepped:Wait()
                if c and hrp then
                    hrp.Velocity = vel
                end
                RunService.Stepped:Wait()
                if c and hrp then
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            end
        end
    end
end

-- Start the loop in the background
task.spawn(flingLoop)

local function detach()
    -- Stop follow connection if it exists
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end

    attached = false
    -- Make player visible again
    -- Enable hidden fling but weaker-- tweak this for ~30 studs effect

    -- Automatically disable fling after a short duration
end




local function attachTo(enemyHRP, duration, ignoreAnim)
    if attached then return end
    enemyHRP = getRoot(enemyHRP.Parent)
    if not hrp or not enemyHRP then return end

    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if not ignoreAnim then
        local animPlaying = false
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            local animIdNumber = tonumber(track.Animation.AnimationId:match("%d+"))
            if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
                animPlaying = true
                break
            end
        end
        if not animPlaying then return end
    end

    attached = true
    

    local start = tick()
    followConnection = RunService.Heartbeat:Connect(function()
        if not enemyHRP or not enemyHRP.Parent then
            detach()
            return
        end
        hrp.CFrame = CFrame.new(enemyHRP.Position + Vector3.new(0,1,0)) * CFrame.Angles(math.rad(90),0,0)
        if tick() - start >= (duration or 0.3) then
            detach()
        end
    end)
end



-- Handle when animations play
local function onAnimationPlayed(track)
    local animIdNumber = tonumber(track.Animation.AnimationId:match("%d+"))

    -- If Uppercut animation plays, attempt to attach immediately
   if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
    if attached then return end
    if attachCooldown then return end

    attachCooldown = true
    task.delay(0.35, function()
        attachCooldown = false
    end)

    -- short delay ensures animation is actually playing
    task.delay(0.08, function()
        local enemy = getClosestEnemy(12)
        if enemy then
            attachTo(enemy, 0.3, true) -- ignore animation checks
        end
    end)
end
end









local function getPing()
    local stats = player:FindFirstChild("PlayerStats") or player:FindFirstChild("Stats") -- fallback
    if player and player:GetNetworkPing() then
        return player:GetNetworkPing() * 1000 -- converts seconds to ms
    else
        return 0
    end
end

local player1 = game:GetService("Players")
local localPlayer2 = player1.LocalPlayer
local character3 = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
local humanoid4 = character3:WaitForChild("Humanoid")






-- GET CLOSEST ENEMY
-- GET CLOSEST ENEMY (workspace.Live FIX)
local function getClosestEnemy(maxDist)
    if not hrp then return nil end

    local liveFolder = workspace:FindFirstChild("Live")
    if not liveFolder then
        warn("workspace.Live not found")
        return nil
    end

    local best, bestDist = nil, maxDist

    for _, model in ipairs(liveFolder:GetChildren()) do
        if model:IsA("Model")
        and model ~= player.Character then

            local humanoid = model:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local root = getRoot(model)
                if root then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist < bestDist then
                        best = root
                        bestDist = dist
                    end
                end
            end
        end
    end

    return best
end


-- FIRE Q

local function fireQ()
    DashRemote:FireServer({
        [1] = {Dash = Enum.KeyCode.W, Key = Enum.KeyCode.Q, Goal = "KeyPress"}
    })
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

end


workspace.FallenPartsDestroyHeight = 0/0
workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
    workspace.FallenPartsDestroyHeight = 0/0
end)

-- Function to make your character immune
local function AntiDeath(char)
    local hum = char:WaitForChild("Humanoid")
    local hrp = char:WaitForChild("HumanoidRootPart")

    -- Store last health every frame
    local lastHealth
    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        lastHealth = hum.Health
    end)

    -- Reset health if it hits 0 below Y=0
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 and hrp.Position.Y <= 0 then
            hum.Health = lastHealth
        end
    end)
end

-- Connect for current character
if player.Character then
    AntiDeath(player.Character)
end

-- Reconnect after respawn
player.CharacterAdded:Connect(AntiDeath)

--flip cam

local function flip() 
    if cam then
        local cf = cam.CFrame
        local look = cf.LookVector
        local newLook = Vector3.new(-look.X, look.Y, -look.Z)
        cam.CFrame = CFrame.new(cf.Position, cf.Position + newLook)
     end
end


-- GLOBAL COOLDOWN FOR REQUIRED_ANIM_FOR_ATTACH
local GlobalCooldown = false
local GlobalCooldownTime = 5
local LastDashTime = 0

local function canUseGlobalCooldown()
    if GlobalCooldown and tick() - LastDashTime < GlobalCooldownTime then
        return false
    end

    -- Start cooldown
    GlobalCooldown = true
    LastDashTime = tick()

    -- Reset after 5 seconds
    task.delay(GlobalCooldownTime, function()
        GlobalCooldown = false
    end)

    return true
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local attachConnection
local isAttaching = false

local function attachUnderTarget(targetCharacter, duration)
    if isAttaching then return end
    if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    isAttaching = true
    local endTime = os.clock() + duration

    attachConnection = RunService.RenderStepped:Connect(function()
        if os.clock() >= endTime then
            attachConnection:Disconnect()
            attachConnection = nil
            isAttaching = false
            return
        end

        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local targetHRP = targetCharacter.HumanoidRootPart
            hrp.CFrame =
                CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
                * CFrame.Angles(math.rad(90), 0, 0)
        end
    end)
end



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager") -- make sure this exists in your exploit environment

local function doTwisted2()
    -- Get nearest enemy torso (R6/R15 compatible)
    local function getNearestPlayerTorso()
        local nearest = nil
        local shortestDistance = math.huge

        local myChar = player.Character
        local myHRP = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
        if not myHRP then return nil end

        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local char = otherPlayer.Character
                local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                if torso then
                    local distance = (torso.Position - myHRP.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearest = torso
                    end
                end
            end
        end

        return nearest
    end

    local target = getNearestPlayerTorso()
    if not target then return end -- no target found

    -- Aim camera at target (unchanged)
    cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)

    -- Press Q
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

    -- Teleport above enemy AND make character face enemy
    local hrp = player.Character and (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso"))
    

    -- Camera rotations: -70 then +120 degrees (unchanged)
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


-- FORCE JUMP
local function autoPressQ()
    DashRemote:FireServer({
        [1] = {Dash = Enum.KeyCode.W, Key = Enum.KeyCode.Q, Goal = "KeyPress"}
    })
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end

local function forceJump(height)
    height = height or 50 -- default to 50 if no value is provided
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    hrp.Velocity = Vector3.new(hrp.Velocity.X, height, hrp.Velocity.Z)
end

local onCooldown = false

-- CHARACTER SETUP
local function setupCharacter(char)
    -- Wait for essential parts
    local humanoid = char:WaitForChild("Humanoid")
    hrp = getRoot(char) -- Get HumanoidRootPart (or fallback)

    -- Reset state
    attached = false
    attachCooldown = false
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
	

    -- Handle death
    humanoid.Died:Connect(function()
        attached = false
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        hrp = nil
    end)

    -- Handle animations
    humanoid.AnimationPlayed:Connect(function(track)
        local anim = track.Animation
        if not anim then return end
        local animIdNumber = tonumber(anim.AnimationId:match("%d+"))

        -- Required attach animation
		
		-- M4 animation detection


		-- Arm attach ONLY after uppercut
if UPPERCUT[anim.AnimationId] then
    didUppercut = true

    -- auto reset (prevents false attach later)
    task.delay(0.6, function()
        didUppercut = false
    end)
end


	if animIdNumber == REQUIRED_ANIM_FOR_ATTACH then
        canUseGlobalCooldown() -- start cooldown here
    end
			
		if MeowTechEnabled and animIdNumber == REQUIRED_ANIM_FOR_ATTACH and didUppercut then
    if attached or attachCooldown then return end
    attachCooldown = true
    didUppercut = false -- consume the uppercut

    task.delay(0.35, function() attachCooldown = false end)

    task.delay(0.08, function()
        local enemy = getClosestEnemy(12)
        if enemy then
            attachTo(enemy, 0.3, true)
        end
    end)
end

local animId5 = 10479335397


		if animIdNumber == animId5 then
			onCooldown = true
			task.delay(5,function()
				onCooldown = false
			end)
		end

        -- MeowTech
        if MeowTechEnabled and UPPERCUT[anim.AnimationId] and not attachCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(meowstart, function()
                    fireQ()
                    attachTo(enemy, meowDuration)
                end)
            end
        end

if meowtechv2 and UPPERCUT[anim.AnimationId] then
	if not onCooldown then
    local enemyHRP = getClosestEnemy(10)
    if enemyHRP then
	
        task.delay(meowstart, function()
            autoPressQ()
            attachUnderTarget(enemyHRP.Parent, meowDuration)
        end)
		end
    end
end

if kyokie and UPPERCUT[anim.AnimationId] then
			if not onCooldown then
            local enemy = getClosestEnemy(10)
            if enemy then
                task.delay(0.3, function()
                    
                end)
            end
        end
end

        -- KingTech
if oreorev and UPPERCUT[anim.AnimationId] then
    if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
            task.delay(0.3, function()
                autoPressQ()
                
                -- Services
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                
                -- Player
                local player = Players.LocalPlayer
                
                -- Configuration - ADJUST THESE VALUES
                local ROTATION_SPEED = 1.5  -- Tweaked from 0.3 to variable
                local RANGE_LIMIT = 100  -- Distance in studs
                local BYPASS_DURATION = 0.4  -- How long the bypass stays active
                
                -- State
                local bypassActive = true
                local connection = nil
                local shiftLockWasEnabled = false
                
                -- Find nearest player
                local function getNearestPlayer()
                    local character = player.Character
                    if not character then return nil end
                    
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return nil end
                    
                    local nearestPlayer = nil
                    local nearestDistance = math.huge
                    
                    for _, otherPlayer in pairs(Players:GetPlayers()) do
                        if otherPlayer ~= player and otherPlayer.Character then
                            local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if otherHrp then
                                local distance = (hrp.Position - otherHrp.Position).Magnitude
                                if distance < nearestDistance then
                                    nearestDistance = distance
                                    nearestPlayer = otherPlayer
                                end
                            end
                        end
                    end
                    
                    return nearestPlayer, nearestDistance
                end
                
                -- Override ShiftLock rotation with adjustable speed
                local function enableShiftlockBypass(speedMultiplier)
                    if connection then
                        connection:Disconnect()
                    end
                    
                    bypassActive = true
                    
                    -- Use custom speed or default
                    local rotationSpeed = speedMultiplier or ROTATION_SPEED
                    
                    -- Store original shiftlock state
                    shiftLockWasEnabled = player.DevEnableMouseLock
                    
                    connection = RunService.RenderStepped:Connect(function()
                        local character = player.Character
                        if not character then 
                            disableShiftlockBypass()
                            return 
                        end
                        
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChild("Humanoid")
                        if not hrp or not humanoid then return end
                        
                        -- Temporarily disable auto-rotate
                        humanoid.AutoRotate = false
                        
                        -- Get nearest player
                        local nearestPlayer, distance = getNearestPlayer()
                        
                        if nearestPlayer and nearestPlayer.Character then
                            local targetHrp = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if targetHrp and distance < RANGE_LIMIT then
                                -- Calculate direction to nearest player (ignore Y axis)
                                local targetPos = targetHrp.Position
                                local selfPos = hrp.Position
                                local direction = Vector3.new(
                                    targetPos.X - selfPos.X,
                                    0,
                                    targetPos.Z - selfPos.Z
                                )
                                
                                if direction.Magnitude > 0.1 then
                                    -- Force rotation toward nearest player
                                    local newCFrame = CFrame.lookAt(
                                        hrp.Position,
                                        hrp.Position + direction.Unit
                                    )
                                    
                                    -- Apply rotation with adjustable speed
                                    hrp.CFrame = hrp.CFrame:Lerp(newCFrame, rotationSpeed)
                                end
                            end
                        end
                    end)
                end
                
                local function disableShiftlockBypass()
                    bypassActive = false
                    
                    if connection then
                        connection:Disconnect()
                        connection = nil
                    end
                    
                    -- Restore original state
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.AutoRotate = true
                        end
                    end
                end
                
                -- Start the bypass with custom rotation speed
                    -- You can adjust the rotation speed here:
                    -- 0.1 = very slow/smooth, 0.5 = moderate, 1.0 = instant snap
                    enableShiftlockBypass(0.5) -- Change this value as needed
                
                -- Auto-disable after configured duration
                task.delay(BYPASS_DURATION, function()
                    disableShiftlockBypass()
                end)
                
                -- Auto-disable on character death
                if player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Died:Connect(function()
                            disableShiftlockBypass()
                        end)
                    end
                end
                
                player.CharacterAdded:Connect(function(character)
                    character:WaitForChild("Humanoid").Died:Connect(function()
                        disableShiftlockBypass()
                    end)
                end)
            end)
        end
    end
end

if KingTechEnabled and UPPERCUT[anim.AnimationId] then
	if not onCooldown then
	
        local enemy = getClosestEnemy(10)
        if enemy then
            task.delay(kingstart, function()
				autoPressQ()
                forceJump()
                task.delay(kingwait, flip)
            end)
        end
    end
end

if innerlethal and animIdNumber == TARGET_ANIM_ID then
        task.spawn(function()
            task.delay(1.7, function()
                local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
--// Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

--// Settings
local KEY = Enum.KeyCode.E
local RANGE = 25                 -- Max attach range
local OFFSET = Vector3.new(0, 7, 0)  -- Up 10 studs, behind
local LAY_ROT = CFrame.Angles(math.rad(90), 0, 0)
local TWEEN_TIME = 0.2
local AUTO_TIME = 1             -- Seconds before auto detach
local MAX_DISTANCE = 30          -- Detach if target moves too far

--// State
local attached = false
local targetHRP
local followConn
local lockedY
local storedCollisions = {}

--// Find nearest player
local function getNearestHRP()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
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





--// Collision handling
local function disableCollision()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            storedCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

local function restoreCollision()
    for part, state in pairs(storedCollisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    storedCollisions = {}
end

--// Detach
local function detach()
    if followConn then
        followConn:Disconnect()
        followConn = nil
    end

    humanoid.PlatformStand = false
    restoreCollision()

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    attached = false
    targetHRP = nil
    lockedY = nil
end

--// Attach
local function attach()
    targetHRP = getNearestHRP()
    if not targetHRP then return end

    attached = true
    humanoid.PlatformStand = true
    disableCollision()

    -- Initial tween
    local startPos = Vector3.new(targetHRP.Position.X, targetHRP.Position.Y, targetHRP.Position.Z - 2)
    local endPos = startPos + OFFSET
    lockedY = endPos.Y

    hrp.CFrame = CFrame.new(startPos) * LAY_ROT

    TweenService:Create(
        hrp,
        TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { CFrame = CFrame.new(endPos) * LAY_ROT }
    ):Play()

    -- Follow X/Z + anti-fling
    followConn = RunService.RenderStepped:Connect(function()
        if not attached or not targetHRP or not targetHRP.Parent then
            detach()
            return
        end

        local pos = targetHRP.Position
        hrp.CFrame = CFrame.new(pos.X + OFFSET.X, lockedY, pos.Z + OFFSET.Z) * LAY_ROT

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- Auto detach by distance
        if (hrp.Position - targetHRP.Position).Magnitude > MAX_DISTANCE then
            detach()
        end
    end)

    -- Auto detach by timer
    task.spawn(function()
        task.wait(AUTO_TIME)
        if attached then detach() end
    end)
end


	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

    if attached then
        detach()
    else
        attach()
    end
            end)
        end)
    end

if kyokiedash and UPPERCUT[anim.AnimationId] then
    if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
            task.delay(0.3, function()
                --// Services
                local Players = game:GetService("Players")
                local RunService = game:GetService("RunService")
                local VirtualInputManager = game:GetService("VirtualInputManager")
                
                --// Player
                local player = Players.LocalPlayer
                local character = player.Character
                if not character then return end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if not hrp or not humanoid then return end

				local moveme = hrp:WaitForChild("moveme")
				if moveme then
					move:Destroy()
				end

                --// Settings
                local OFFSET = Vector3.new(0, 7, 0)  -- 10 studs above enemy
                local AUTO_TIME = 1
                
                --// State
                local kyokieFollowConn
                
                --// Detach
                local function detach()
                    if kyokieFollowConn then
                        kyokieFollowConn:Disconnect()
                        kyokieFollowConn = nil
                    end
                    humanoid.PlatformStand = false
                    -- Reset velocity
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
                
                --// Press Q
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                
                local enemyRoot = getRoot(enemy.Parent)
                if not enemyRoot then return end
                
                -- Get current rotation to maintain it
                local currentCFrame = hrp.CFrame
                local currentLook = currentCFrame.LookVector
                
                -- Position above enemy but keep original rotation
                hrp.CFrame = CFrame.new(enemyRoot.Position + OFFSET) * CFrame.new(0, 0, 0) -- No rotation change
                
                -- Follow enemy X/Z movement for AUTO_TIME seconds
                local startTime = tick()
                kyokieFollowConn = RunService.Heartbeat:Connect(function()
                    if not enemyRoot or not enemyRoot.Parent or tick() - startTime >= AUTO_TIME then
                        detach()
                        return
                    end
                    
                    -- Move with enemy but keep character's original facing direction
                    hrp.CFrame = CFrame.new(
                        enemyRoot.Position.X + OFFSET.X,
                        enemyRoot.Position.Y + OFFSET.Y,
                        enemyRoot.Position.Z + OFFSET.Z
                    ) * CFrame.Angles(0, math.atan2(currentLook.X, currentLook.Z), 0)
                    
                    -- Prevent fling
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
                
                -- Auto detach after time
                task.delay(AUTO_TIME, function()
                    if kyokieFollowConn then
                        detach()
                    end
                end)
            end)
        end
    end
end  -- DON'T FORGET THIS END

if innerdash and UPPERCUT[anim.AnimationId] then
	if not onCooldown then
	
        local enemy = getClosestEnemy(10)
        if enemy then
            task.delay(0.3, function()
				--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
--// Player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

--// Settings
local KEY = Enum.KeyCode.E
local RANGE = 25                 -- Max attach range
local OFFSET = Vector3.new(0, 3, 0)  -- Up 10 studs, behind
local LAY_ROT = CFrame.Angles(math.rad(90), 0, 0)
local TWEEN_TIME = 0.2
local AUTO_TIME = 1             -- Seconds before auto detach
local MAX_DISTANCE = 30          -- Detach if target moves too far

--// State
local attached = false
local targetHRP
local followConn
local lockedY
local storedCollisions = {}

--// Find nearest player
local function getNearestHRP()
    local closest, shortest = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
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



--// Collision handling
local function disableCollision()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            storedCollisions[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

local function restoreCollision()
    for part, state in pairs(storedCollisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    storedCollisions = {}
end

--// Detach
local function detach()
    if followConn then
        followConn:Disconnect()
        followConn = nil
    end

    humanoid.PlatformStand = false
    restoreCollision()

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero

    attached = false
    targetHRP = nil
    lockedY = nil
end

--// Attach
local function attach()
    targetHRP = getNearestHRP()
    if not targetHRP then return end

    attached = true
    humanoid.PlatformStand = true
    disableCollision()

    -- Initial tween
    local startPos = Vector3.new(targetHRP.Position.X, targetHRP.Position.Y, targetHRP.Position.Z - 2)
    local endPos = startPos + OFFSET
    lockedY = endPos.Y

    hrp.CFrame = CFrame.new(startPos) * LAY_ROT

    TweenService:Create(
        hrp,
        TweenInfo.new(TWEEN_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { CFrame = CFrame.new(endPos) * LAY_ROT }
    ):Play()

    -- Follow X/Z + anti-fling
    followConn = RunService.RenderStepped:Connect(function()
        if not attached or not targetHRP or not targetHRP.Parent then
            detach()
            return
        end

        local pos = targetHRP.Position
        hrp.CFrame = CFrame.new(pos.X + OFFSET.X, lockedY, pos.Z + OFFSET.Z) * LAY_ROT

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- Auto detach by distance
        if (hrp.Position - targetHRP.Position).Magnitude > MAX_DISTANCE then
            detach()
        end
    end)

    -- Auto detach by timer
    task.spawn(function()
        task.wait(AUTO_TIME)
        if attached then detach() end
    end)
end


	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

    if attached then
        detach()
    else
        attach()
    end

            end)
        end
    end
end

if instanttwisted and animIdNumber == M4_ANIM_ID then
	if not onCooldown then
		local enemy = getClosestEnemy(12)
		if enemy then
			task.delay(0.25, function()
				doTwisted()
			end)
		end
	end
end

if leeinstanttwisted and animIdNumber == M4_ANIM_ID then
	if not onCooldown then
			task.delay(waitpress, function()
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

local cam = workspace.CurrentCamera

		task.wait(leewait)


        local cf = cam.CFrame
        -- Step 1: rotate +90° around Y
        cam.CFrame = cf * CFrame.Angles(0, math.rad(turn), 0)

        -- Step 2: wait 0.5 seconds
        task.wait(leewait2)

        -- Step 3: rotate -100° around Y (from current)
        cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(turn2), 0)


		end)
	end
end






if kakyo and UPPERCUT[anim.AnimationId] then
    if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
            task.delay(kakyostart, function()
                forceJump(kakyojump)
                
                -- Camera follow for 0.5 seconds
                local startTime = tick()
                local cam = workspace.CurrentCamera
                local targetChar = enemy.Parent
                local targetPart = targetChar:FindFirstChild("Right Arm") -- R6 Right Arm
                -- Fallback to HRP if Right Arm missing
                if not targetPart then
                    targetPart = getRoot(targetChar)
                end
                local DRIPZ_CAMERA_SPEED = kakyocam
                local connection
                connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        connection:Disconnect()
                        return
                    end
                    local camCF = cam.CFrame
                    local camPos = camCF.Position
                    -- Focus on a point slightly BEHIND the Right Arm
                    local armCF = targetPart.CFrame
                    -- Offset: -Z in local space (back of the arm)
                    local backOffset = armCF:VectorToWorldSpace(Vector3.new(0, 0, 0)) -- 2 studs behind
                    local backPosition = armCF.Position + backOffset
                    -- Horizontal direction only (keep camera pitch)
                    local dir = Vector3.new(
                        backPosition.X - camPos.X,
                        0, -- Ignore vertical for yaw
                        backPosition.Z - camPos.Z
                    )
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local targetYaw = math.atan2(dir.Z, dir.X)
                        local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                        local newYaw = currentYaw + (targetYaw - currentYaw) * DRIPZ_CAMERA_SPEED
                        local pitch = math.asin(camCF.LookVector.Y)
                        local newLook = Vector3.new(
                            math.cos(newYaw) * math.cos(pitch),
                            math.sin(pitch),
                            math.sin(newYaw) * math.cos(pitch)
                        )
                        cam.CFrame = CFrame.new(camPos, camPos + newLook)
                    end
                    if tick() - startTime >= 0.3 then
                        connection:Disconnect()
                    end
                end)
            end)
        end
    end
end

if oreov2 and UPPERCUT[anim.AnimationId] then
		if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
		task.delay(kittystartjump,function()
			forceJump(60)
		end)
		
			
            task.delay(kittystart, function()
			autoPressQ()
			flip()
			
			-- Spawn dripz visual par
			
-- optional auto cleanup
				task.wait(kittywait)

                    

                -- Camera follow for 0.5 seconds
                local startTime = tick()
                local cam = workspace.CurrentCamera
                local targetChar = enemy.Parent
                local targetPart = targetChar:FindFirstChild("Left Arm") -- R6 left hand

                -- fallback to HRP if Left Arm missing
                if not targetPart then
                    targetPart = getRoot(targetChar)
                end

                local DRIPZ_CAMERA_SPEED = kittycam

                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        connection:Disconnect()
                        return
                    end

                    local camCF = cam.CFrame
                    local camPos = camCF.Position

                    -- Horizontal direction only
                    local lookCF = targetPart.CFrame
                    local backPosition = lookCF.Position
                    local dir = Vector3.new(
                        backPosition.X - camPos.X,
                        0,
                        backPosition.Z - camPos.Z
                    )

                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local targetYaw = math.atan2(dir.Z, dir.X)
                        local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                        local newYaw = currentYaw + (targetYaw - currentYaw) * DRIPZ_CAMERA_SPEED
                        local pitch = math.asin(camCF.LookVector.Y)
                        local newLook = Vector3.new(
                            math.cos(newYaw) * math.cos(pitch),
                            math.sin(pitch),
                            math.sin(newYaw) * math.cos(pitch)
                        )
                        cam.CFrame = CFrame.new(camPos, camPos + newLook)
                    end

                    if tick() - startTime >= 0.2 then
                        connection:Disconnect()
                    end
                end)
            end)
        end
	end
end




if dripz and UPPERCUT[anim.AnimationId] then
    if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
		task.delay(oreostart,function()
				autoPressQ()
                forceJump(oreojump)
		end)
            task.delay(oreowait, function()
                
                
                -- Camera follow for 0.5 seconds
                local startTime = tick()
                local cam = workspace.CurrentCamera
                local targetChar = enemy.Parent
                local targetPart = targetChar:FindFirstChild("Right Arm") -- R6 Right Arm
                -- Fallback to HRP if Right Arm missing
                if not targetPart then
                    targetPart = getRoot(targetChar)
                end
                local DRIPZ_CAMERA_SPEED = oreocam
                local connection
                connection = game:GetService("RunService").RenderStepped:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        connection:Disconnect()
                        return
                    end
                    local camCF = cam.CFrame
                    local camPos = camCF.Position
                    -- Focus on a point slightly BEHIND the Right Arm
                    local armCF = targetPart.CFrame
                    -- Offset: -Z in local space (back of the arm)
                    local backOffset = armCF:VectorToWorldSpace(Vector3.new(0, 0, -1)) -- 2 studs behind
                    local backPosition = armCF.Position + backOffset
                    -- Horizontal direction only (keep camera pitch)
                    local dir = Vector3.new(
                        backPosition.X - camPos.X,
                        0, -- Ignore vertical for yaw
                        backPosition.Z - camPos.Z
                    )
                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local targetYaw = math.atan2(dir.Z, dir.X)
                        local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                        local newYaw = currentYaw + (targetYaw - currentYaw) * DRIPZ_CAMERA_SPEED
                        local pitch = math.asin(camCF.LookVector.Y)
                        local newLook = Vector3.new(
                            math.cos(newYaw) * math.cos(pitch),
                            math.sin(pitch),
                            math.sin(newYaw) * math.cos(pitch)
                        )
                        cam.CFrame = CFrame.new(camPos, camPos + newLook)
                    end
                    if tick() - startTime >= 0.2 then
                        connection:Disconnect()
                    end
                end)
            end)
        end
    end
end

if boomy and animIdNumber == TARGET_ANIM_ID then
        local enemy = getClosestEnemy(10)
        if enemy then
			
            task.delay(boomystart, function()
			autoPressQ()
			flip()
			forceJump(boomyjump)
			-- Spawn dripz visual par
			
-- optional auto cleanup
				task.wait(0.1)

                    

                -- Camera follow for 0.5 seconds
                local startTime = tick()
                local cam = workspace.CurrentCamera
                local targetChar = enemy.Parent
                local targetPart = targetChar:FindFirstChild("Right Arm") -- R6 left hand

                -- fallback to HRP if Left Arm missing
                if not targetPart then
                    targetPart = getRoot(targetChar)
                end

                local DRIPZ_CAMERA_SPEED = 3

                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        connection:Disconnect()
                        return
                    end

                    local camCF = cam.CFrame
                    local camPos = camCF.Position

                    -- Horizontal direction only
                    local lookCF = targetPart.CFrame
                    local backPosition = lookCF.Position
                    local dir = Vector3.new(
                        backPosition.X - camPos.X,
                        0,
                        backPosition.Z - camPos.Z
                    )

                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local targetYaw = math.atan2(dir.Z, dir.X)
                        local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                        local newYaw = currentYaw + (targetYaw - currentYaw) * DRIPZ_CAMERA_SPEED
                        local pitch = math.asin(camCF.LookVector.Y)
                        local newLook = Vector3.new(
                            math.cos(newYaw) * math.cos(pitch),
                            math.sin(pitch),
                            math.sin(newYaw) * math.cos(pitch)
                        )
                        cam.CFrame = CFrame.new(camPos, camPos + newLook)
                    end

                    if tick() - startTime >= 0.2 then
                        connection:Disconnect()
                    end
                end)
            end)
        end
end



if instantlethal and animIdNumber == TARGET_ANIM_ID then
    if not onCooldown then
        local enemy = getClosestEnemy(10)
        if enemy then
			
            task.delay(instantlethalstart, function()
			autoPressQ()
			forceJump(60)
			-- Spawn dripz visual par
			
-- optional auto cleanup
task.delay(instantlethalwait, function()
    if part then part:Destroy() end
end)

                    

                -- Camera follow for 0.5 seconds
                local startTime = tick()
                local cam = workspace.CurrentCamera
                local targetChar = enemy.Parent
                local targetPart = targetChar:FindFirstChild("Right Arm") -- R6 left hand

                -- fallback to HRP if Left Arm missing
                if not targetPart then
                    targetPart = getRoot(targetChar)
                end

                local DRIPZ_CAMERA_SPEED = 3

                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not targetPart or not targetPart.Parent then
                        connection:Disconnect()
                        return
                    end

                    local camCF = cam.CFrame
                    local camPos = camCF.Position

                    -- Horizontal direction only
                    local lookCF = targetPart.CFrame
                    local backPosition = lookCF.Position
                    local dir = Vector3.new(
                        backPosition.X - camPos.X,
                        0,
                        backPosition.Z - camPos.Z
                    )

                    if dir.Magnitude > 0 then
                        dir = dir.Unit
                        local targetYaw = math.atan2(dir.Z, dir.X)
                        local currentYaw = math.atan2(camCF.LookVector.Z, camCF.LookVector.X)
                        local newYaw = currentYaw + (targetYaw - currentYaw) * DRIPZ_CAMERA_SPEED
                        local pitch = math.asin(camCF.LookVector.Y)
                        local newLook = Vector3.new(
                            math.cos(newYaw) * math.cos(pitch),
                            math.sin(pitch),
                            math.sin(newYaw) * math.cos(pitch)
                        )
                        cam.CFrame = CFrame.new(camPos, camPos + newLook)
                    end

                    if tick() - startTime >= 0.3 then
                        connection:Disconnect()
                    end
                end)
            end)
        end
    end
end



		if supatech and not attachCooldown and UPPERCUT[anim.AnimationId] then
    local enemy = getClosestEnemy(10)
    print("Closest enemy:", enemy)
	
	task.delay(0.3,function ()
		if enemy then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
			forceJump()
            autoPressQ()
			local backwardVector = -hrp.CFrame.LookVector * 13
			hrp.CFrame = hrp.CFrame + backwardVector
        else
            warn("HRP missing")
        end
    end
	end)
    
end


if deathcounter and animIdNumber == 11343250001 then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local TELEPORT_DISTANCE = -10000 -- how far down to go
    local platformSize = Vector3.new(10, 1, 10) -- size of invisible platform

    local originalCFrame = nil
    local platform = nil
    local inVoid = false

    local function getRoot()
        local char = player.Character
        if char then
            return char:FindFirstChild("HumanoidRootPart")
        end
    end

    local function teleport()
        local root = getRoot()
        if not root then return end

        if not inVoid then
            -- Store original position
            originalCFrame = root.CFrame

            -- Create invisible platform
            platform = Instance.new("Part")
            platform.Size = platformSize
            platform.Anchored = true
            platform.Transparency = 1
            platform.CanCollide = true
            platform.Position = root.Position + Vector3.new(0, TELEPORT_DISTANCE - platformSize.Y/2, 0)
            platform.Parent = workspace

            -- Move player down onto platform
            root.CFrame = platform.CFrame + Vector3.new(0, 3, 0)

            inVoid = true

            -- Automatically teleport back after 3 seconds
            task.delay(6, function()
                if root and originalCFrame then
                    root.CFrame = originalCFrame
                end
                if platform then
                    platform:Destroy()
                    platform = nil
                end
				local camera = workspace.CurrentCamera

-- Function to reset camera
local function resetCamera()
    local char = player.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    if humanoid then
        camera.CameraSubject = humanoid
        camera.CameraType = Enum.CameraType.Custom
    elseif hrp then
        camera.CameraSubject = hrp
        camera.CameraType = Enum.CameraType.Custom
    end
end

-- Run immediately
resetCamera()

                inVoid = false
            end)
        end
    end

    teleport()
end

    --------------------------------------------------------------------
    -- Instant Lethal
    --------------------------------------------------------------------
    if lethalEnabled and animIdNumber == TARGET_ANIM_ID then
        task.spawn(function()
            task.delay(meowlethalstart, function()
                local enemy = getClosestEnemy(10)
                if enemy then
                    fireQ()
                    attachTo(enemy, 0.5, true)
                end
            end)
        end)
    end

    --------------------------------------------------------------------
    -- Lethal Dash
    --------------------------------------------------------------------
    if LethalDashEnabled and animIdNumber == TARGET_ANIM_ID then
        task.spawn(function()
            task.delay(normallethalstart, function()
                forceJump()
				autoPressQ()
                task.delay(secondforflip, function()
                    flip()
                end)
            end)
        end)
    end

    --------------------------------------------------------------------
-- Auto Kyoto
--------------------------------------------------------------------
if AutoKyotoEnabled and animIdNumber == 12273188754 then
    task.delay(1.6, function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Press "2" key briefly
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            
            -- Move forward 22 studs, keeping same Y (horizontal plane only)
            local look = hrp.CFrame.LookVector
            local horizontalLook = Vector3.new(look.X, 0, look.Z)
            if horizontalLook.Magnitude > 0 then
                horizontalLook = horizontalLook.Unit
            end
            hrp.CFrame = hrp.CFrame + horizontalLook * 22
        end
    end)
end

-------------------------------------------------------------------
if AutoKyototween and animIdNumber == 12273188754 then
    task.delay(1.6, function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Press "2" key briefly
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
            
			connecth = RunService.Heartbeat:Connect(function()
				hrp.AssemblyLinearVelocity = hrp.CFrame.LookVector * 150
			end)
			task.delay(0.1,function()
				connecth:Disconnect()
			end)
        end
    end)
end

-- Auto Kyoto Legit Mode
-- Auto Kyoto Legit Mode
if AutoKyotoLegitEnabled and animIdNumber == 12273188754 then
    task.delay(1.6, function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and cam then
            -- Press keys
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)

            -- Instant forward push: move exactly 10 studs forward
            hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 30)
        end
    end)
end



        -- Lunar Uppercut Extender
        if lunarextender and UPPERCUT[anim.AnimationId] and not attachCooldown then
            local enemyHRP = getClosestEnemy(10)
            if enemyHRP then
                task.delay(0.3, function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                end)

                task.delay(0.5, function()
                    local start = tick()
                    while tick() - start < 0.3 do
                        local hrp = getRoot(player.Character)
                        if not hrp or not enemyHRP or not enemyHRP.Parent then break end
                        local selfPos = hrp.Position
                        local lookPos = enemyHRP.Position
                        if (lookPos - selfPos).Magnitude < 0.05 then
                            lookPos = lookPos + Vector3.new(0.1, 0, 0)
                        end
                        hrp.CFrame = CFrame.lookAt(selfPos, lookPos)
                        task.wait()
                    end
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                end)
            end
        end
		

		


    end)
end

-- Connect respawn
player.CharacterAdded:Connect(function(char)
    setupCharacter(char)
end)

-- Initial setup if already spawned
if player.Character then
    setupCharacter(player.Character)
end


Techs:Toggle({
    Title = "Enable inner dash (100%)",
	Icon = "cat",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        innerdash = state
    end
})





Techs:Toggle({
    Title = "Enable MeowTech",
	Icon = "cat",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        MeowTechEnabled = state
    end
})

Techs:Toggle({
    Title = "Enable MeowTechv2",
	Icon = "cat",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        meowtechv2 = state
    end
})

Techs:Toggle({
    Title = "Enable K1ng tech",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        KingTechEnabled = state
    end
})

Techs:Toggle({
    Title = "Enable oreo tech",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    dripz = state
    end
})


Techs:Toggle({
    Title = "kitty dash",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    oreov2 = state
    end
})

Techs:Toggle({
    Title = "kakyo under flip(new)",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    kakyo = state
    end
})

Techs:Toggle({
    Title = "lee instant twisted",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    leeinstanttwisted = state
    end
})


Techs:Toggle({
    Title = "Enable MeowTech + lethal",
	Icon = "cat",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        lethalEnabled = state
    end
})

Techs:Toggle({
    Title = "LethalDash Enabled",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        LethalDashEnabled = state
    end
})

Techs:Toggle({
	Title = "Instant lethal",
	Icon = "moon",
	Type = "Checkbox",
	Value = false,
	Callback = function(state)
		instantlethal = state
	end
})

Techs:Toggle({
    Title = "booomy instant lethal",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    boomy = state
    end
})

Techs:Toggle({
    Title = "inner lethal(90% headglide)",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    innerlethal = state
    end
})

--settl





meowtech:Input({
    Title = "Start Time",
    Desc = "on how long the tech start",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        meowstart = input
    end
})

meowtech:Input({
    Title = "duration",
    Desc = "on how long the tech end",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        meowDuration = input
    end
})



k1ngtech:Input({
    Title = "Start Time",
    Desc = "on how long the tech start",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kingstart = input
    end
})

k1ngtech:Input({
    Title = "Flip Time",
    Desc = "on how long the flip trigger",
    Value = "0.2",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kingwait = input
    end
})



oreo:Input({
    Title = "Start Time",
    Desc = "on how long the tech start",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        oreostart = input
    end
})

oreo:Input({
    Title = "Rotation time",
    Desc = "on how long it wait until the camera rotate",
    Value = "0.5",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        oreowait = input
    end
})

oreo:Input({
    Title = "camera speed",
    Desc = "on how fast the camera rotate",
    Value = "1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        oreocam = input
    end
})

oreo:Input({
    Title = "oreo duration",
    Desc = "on how long the camera rotation stop",
    Value = "0.2",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        oreodur = input
    end
})

oreo:Input({
    Title = "Jump height",
    Desc = "on how high the jump when do the tech",
    Value = "54",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        oreojump = input
    end
})



kitty:Input({
    Title = "kitty jump",
    Desc = "start to jump when do the tech",
    Value = "0.1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kittystartjump = input
    end
})

kitty:Input({
    Title = "Start Time",
    Desc = "start to jump when do the tech",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kittystart = input
    end
})

kitty:Input({
    Title = "Rotate Time",
    Desc = "wait for the camera to rotate",
    Value = "0.1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kittywait = input
    end
})

kitty:Input({
    Title = "camera speed",
    Desc = "on how fast camera rotate",
    Value = "1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kittycam = input
    end
})

kitty:Input({
    Title = "kitty duration",
    Desc = "on how long the camera rotation stop",
    Value = "0.2",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kittydur = input
    end
})



kak:Input({
    Title = "Start Time",
    Desc = "on how long the tech start",
    Value = "0.3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kakyostart = input
    end
})

kak:Input({
    Title = "kakyo jump height",
    Desc = "on how high the jump when do the tech",
    Value = "40",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kakyojump = input
    end
})



kak:Input({
    Title = "camera speed",
    Desc = "speed of camera rotation",
    Value = "4",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        kakyocam = input
    end
})



instanttwis:Input({
    Title = "press Q Time",
    Desc = "delay to press Q",
    Value = "0.2",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        waitpress = input
    end
})

instanttwis:Input({
    Title = "wait",
    Desc = "wait",
    Value = "0.1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        leewait = input
    end
})

instanttwis:Input({
    Title = "rotate Degree",
    Desc = "rotate ur camera",
    Value = "-90",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        turn = input
    end
})

instanttwis:Input({
    Title = "wait2",
    Desc = "wait2",
    Value = "0.05",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        leewait2 = input
    end
})

instanttwis:Input({
    Title = "rotate Degree",
    Desc = "rotate ur camera ",
    Value = "110",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        turn2 = input
    end
})








lethal:Input({
    Title = "Start Time(meowtech + lethal)",
    Desc = "type a number",
    Value = "1.7",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        meowlethalstart = input
    end
})



lethal:Divider()



lethal:Input({
    Title = "Start Time(lethal Dash)",
    Desc = "type a number",
    Value = "1.7",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        meowlethalstart = input
    end
})

lethal:Input({
    Title = "Flip Time",
    Desc = "type a number",
    Value = "0.2",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        secondforflip = input
    end
})

lethal:Divider()




lethal:Input({
    Title = "Start Time(instant Lethal)",
    Desc = "type a number",
    Value = "1.7",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        instantlethalstart = input
    end
})

lethal:Input({
    Title = "Rotate Time",
    Desc = "type a number",
    Value = "0.5",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        instantlethalwait = input
    end
})

lethal:Divider()




lethal:Input({
    Title = "Start Time(Boomy Instant Lethal)",
    Desc = "type a number",
    Value = "1.7",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        boomystart = input
    end
})

lethal:Input({
    Title = "Jump Height",
    Desc = "type a number",
    Value = "60",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        boomyjump = input
    end
})

lethal:Input({
    Title = "Rotate Time",
    Desc = "type a number",
    Value = "0.1",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        boomywait = input
    end
})

lethal:Input({
    Title = "camera speed",
    Desc = "type a number",
    Value = "3",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter a number",
    Callback = function(input) 
        boomycam = input
    end
})




lethal:Divider()

















tech:Toggle({
    Title = "Auto Kyoto",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    AutoKyotoEnabled = state
    end
})

tech:Toggle({
    Title = "Auto Kyoto tween mode",
	Icon = "moon",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state)    
    AutoKyototween = state
    end
})


tech:Divider()

















plat:Button({
    Title = "Copy Discord Link",
    Desc = "Click to copy Discord link",
    Locked = false,
    Callback = function()
        local success, err = pcall(function()
            setclipboard("https://discord.gg/n7rjmS4sNp")
        end)

        if success then
            print("Discord link copied to clipboard!")
			WindUI:Notify({
    Title = "link copied",
    Content = "link copied",
    Duration = 3, -- 3 seconds
    Icon = "bird",
})
            -- Optionally, show a small notification in your UI
        else
            warn("Failed to copy: "..tostring(err))
        end
    end
})

plat:Button({
    Title = "Copy youtube Link",
    Desc = "Click to copy youtube link",
    Locked = false,
    Callback = function()
        local success, err = pcall(function()
            setclipboard("http://youtube.com/@kyokiee")
        end)

        if success then
			WindUI:Notify({
    Title = "link copied",
    Content = "link copied",
    Duration = 3, -- 3 seconds
    Icon = "bird",
})
            -- Optionally, show a small notification in your UI
        else
            warn("Failed to copy: "..tostring(err))
        end
    end
})

plat:Button({
    Title = "Copy tiktok Link",
    Desc = "Click to copy tiktok link",
    Locked = false,
    Callback = function()
        local success, err = pcall(function()
            setclipboard("http://tiktok.com/@kyokieut")
        end)

        if success then
			WindUI:Notify({
    Title = "link copied",
    Content = "link copied",
    Duration = 3, -- 3 seconds
    Icon = "bird",
})
            -- Optionally, show a small notification in your UI
        else
            warn("Failed to copy: "..tostring(err))
        end
    end
})


main:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "also make u no stun",
    Icon = "cat",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
		WalkSpeedEnabled = state

        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                if state then
                    humanoid.WalkSpeed = walkSpeedValue
                else
                    humanoid.WalkSpeed = 23 -- reset to default
                end
            end
        end
    end
})




main:Slider({
    Title = "WalkSpeed",
    Desc = "change ur walkspeed",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 1,
    Value = {
        Min = 0,
        Max = 1000,
        Default = walkSpeedValue,
    },
    Callback = function(value)
        print(value)

		walkSpeedValue = value
		 if WalkSpeedEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = value
                end
            end
        end
    end
})

-- WalkSpeed Slider

main:Toggle({
    Title = "touch fling",
    Desc = "fling other player when touch",
    Icon = "bird",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(v) 
        hiddenfling = v
    end
})

-- Enforce WalkSpeed only when enabled
RunService.RenderStepped:Connect(function()
    if not WalkSpeedEnabled then return end

    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= walkSpeedValue then
            humanoid.WalkSpeed = walkSpeedValue
        end
    end
end)

-- Apply WalkSpeed on respawn if enabled
player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    if WalkSpeedEnabled then
        humanoid.WalkSpeed = walkSpeedValue
    end
end)


local nocd = false
local nocdConnection = nil

local Toggle = main:Toggle({
    Title = "No Dash Cooldown (new)",
    Desc = "Toggle to remove dash cooldown",
    Icon = "bird",
    Type = "Checkbox",
    Value = false, -- default state
    Callback = function(state)
        if state then
            -- Enable No Dash Cooldown
            workspace:SetAttribute("EffectAffects", 1)
            workspace:SetAttribute("NoDashCooldown", true)

        else
            workspace:SetAttribute("NoDashCooldown", false)
        end
    end
})



main:Toggle({
    Title = "anti death counter",
    Desc = "make u not die in deathcounter",
    Icon = "bird",
    Type = "Checkbox",
    Value = false, -- default value
    Callback = function(v) 
        deathcounter = v
    end
})

-- Services
-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Table to store player buttons
local playerButtons = {}

-- Function to teleport to a player
local function teleportToPlayer(targetPlayer)
    if LocalPlayer.Character and targetPlayer.Character then
        local hrp = getRoot(LocalPlayer.Character) -- Using your getRoot function
        local targetHrp = getRoot(targetPlayer.Character)
        if hrp and targetHrp then
            hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 0, 3) -- Teleport 3 studs behind
        end
    end
end

-- Function to add a button for a player
local function addPlayerButton(player)
    if player == LocalPlayer then return end -- Skip local player
    local button = tp:Button({
        Title = player.Name,
        Desc = "Teleport to " .. player.Name,
        Locked = false,
        Callback = function()
            teleportToPlayer(player)
        end
    })
    playerButtons[player] = button -- Store button reference
end

-- Function to remove a button for a player
local function removePlayerButton(player)
    if playerButtons[player] then
        -- WindUI doesn't have a direct destroy method, so we hide it
        -- If WindUI supports destroying elements, replace with proper method
        playerButtons[player] = nil -- Remove reference
    end
end

-- Add buttons for existing players
for _, player in ipairs(Players:GetPlayers()) do
    addPlayerButton(player)
end

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    addPlayerButton(player)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    removePlayerButton(player)
end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local highlights = {}
local connections = {}  -- To store and clean up connections
local enabled = false

-- Add highlight
local function addHighlight(character)
    if highlights[character] then return end
    local h = Instance.new("Highlight")
    h.Name = "CounterHighlight"
    h.FillColor = Color3.fromRGB(255, 0, 0)
    h.OutlineColor = Color3.fromRGB(255, 0, 0)
    h.FillTransparency = 0.45
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = character
    h.Parent = character
    highlights[character] = h
end

-- Remove highlight
local function removeHighlight(character)
    if highlights[character] then
        highlights[character]:Destroy()
        highlights[character] = nil
    end
end

-- Clear all highlights
local function clearAllHighlights()
    for char, _ in pairs(highlights) do
        removeHighlight(char)
    end
end

-- Check if character currently has the Counter accessory
local function hasCounterAccessory(character)
    for _, acc in ipairs(character:GetChildren()) do
        if acc:IsA("Accessory") and acc.Name == "Counter" then
            return true
        end
    end
    return false
end

-- Setup watching for a single character
local function setupCharacterWatch(character)
    -- Clean up any old connections for this character
    if connections[character] then
        for _, conn in pairs(connections[character]) do
            conn:Disconnect()
        end
    end
    connections[character] = {}

    -- Immediate check
    if hasCounterAccessory(character) then
        addHighlight(character)
    end

    -- Watch for added accessories
    local addedConn = character.ChildAdded:Connect(function(child)
        if child:IsA("Accessory") and child.Name == "Counter" then
            addHighlight(character)
        end
    end)

    -- Watch for removed accessories
    local removedConn = character.ChildRemoved:Connect(function(child)
        if child:IsA("Accessory") and child.Name == "Counter" then
            removeHighlight(character)
        end
    end)

    -- Store connections
    connections[character].added = addedConn
    connections[character].removed = removedConn
end

-- Remove watching for a character
local function cleanupCharacterWatch(character)
    removeHighlight(character)
    if connections[character] then
        for _, conn in pairs(connections[character]) do
            conn:Disconnect()
        end
        connections[character] = nil
    end
end

-- Enable function (called when toggle ON)
local function enableESP()
    enabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            setupCharacterWatch(player.Character)
        end
    end
end

-- Disable function (called when toggle OFF)
local function disableESP()
    enabled = false
    clearAllHighlights()
    for character, _ in pairs(connections) do
        if connections[character] then
            for _, conn in pairs(connections[character]) do
                conn:Disconnect()
            end
        end
    end
    connections = {}
end

-- Player handling
local function onPlayerAdded(player)
    if player == LocalPlayer then return end

    if player.Character then
        if enabled then
            setupCharacterWatch(player.Character)
        end
    end

    player.CharacterAdded:Connect(function(char)
        if enabled then
            setupCharacterWatch(char)
        end
    end)

    player.CharacterRemoving:Connect(function(char)
        cleanupCharacterWatch(char)
    end)
end

-- Initial setup
for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end
Players.PlayerAdded:Connect(onPlayerAdded)

-- === UI Toggle ===
local Toggle = esp:Toggle({
    Title = "Counter ESP",
    Desc = "Highlights players with death counter",
    Icon = "crosshair",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        if state then
            print("Counter ESP: ON")
            enableESP()
        else
            print("Counter ESP: OFF")
            disableESP()
        end
    end
})

print("Counter ESP with reliable toggle loaded!")

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

--// Player
local plr = Players.LocalPlayer

--// State
local debounce = false
local connect

--// Character refs
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

--// Animation
local ANIM_ID = "rbxassetid://10480793962"
local anim = Instance.new("Animation")
anim.AnimationId = ANIM_ID
local track = animator:LoadAnimation(anim)

local dashDuration = 0.2
local dashforce = 150

--// Dash Function
local function triggerDash()
    if debounce then return end
    if not char or not hrp or humanoid.Health <= 0 then return end

    debounce = true

    -- Disable existing BodyVelocities except "moveme"
    local disabled = {}
    for _, v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") and v.Name ~= "moveme" then
            disabled[v] = v.MaxForce
            v.MaxForce = Vector3.zero
        end
    end

    connect = RunService.Heartbeat:Connect(function()
        hrp.AssemblyLinearVelocity = hrp.CFrame.RightVector * dashforce
    end)

    -- Camera spin effect
    local cam = workspace.CurrentCamera
    local originalCamCF = cam.CFrame
    cam.CFrame = originalCamCF * CFrame.Angles(0, math.rad(-90), 0)

    -- Play animation
    if track then
        track:Play()
    end

    task.wait(dashDuration)


    -- Simulate Q key press
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)

    -- Stop dash
    hrp.AssemblyLinearVelocity = Vector3.zero
    cam.CFrame = originalCamCF

    if connect then
        connect:Disconnect()
        connect = nil
    end

    -- Restore disabled BodyVelocities
    for bv, maxForce in pairs(disabled) do
        if bv and bv.Parent then
            bv.MaxForce = maxForce
        end
    end

    debounce = false
end

--// GUI Creation
local m1reset = Instance.new("ScreenGui")
m1reset.Name = "m1reset"
m1reset.Parent = plr:WaitForChild("PlayerGui")
m1reset.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
m1reset.ResetOnSpawn = false 

local dashframe = Instance.new("Frame")
dashframe.Name = "dashframe"
dashframe.Parent = m1reset
dashframe.BackgroundTransparency = 1
dashframe.Size = UDim2.new(0, 150, 0, 150)
dashframe.Position = UDim2.new(0.5, -75, 0.5, -75)
dashframe.Active = true
dashframe.Draggable = true

local cat = Instance.new("ImageButton")
cat.Name = "cat"
cat.Parent = dashframe
cat.BackgroundTransparency = 1
cat.Position = UDim2.new(0.1, 0, 0.2, 0)
cat.Size = UDim2.new(0, 79, 0, 72)
cat.Image = "rbxassetid://124624838814157"

local idk = Instance.new("TextLabel")
idk.Name = "idk"
idk.Parent = dashframe
idk.BackgroundTransparency = 0
idk.Position = UDim2.new(0.1, 0, 0.05, 0)
idk.Size = UDim2.new(0, 79, 0, 18)
idk.Font = Enum.Font.SourceSans
idk.Text = "drag"
idk.TextColor3 = Color3.new(0, 0, 0)
idk.TextSize = 14

--// GUI Interactions
cat.Activated:Connect(triggerDash)

--// Tech UI Keybind Integration
-- Assuming 'tech' is your UI library
local DashKeybind = M1reset:Keybind({ 
    Title = "Dash Key",
    Desc = "Key to trigger dash",
    Value = "E",  -- default dash key
    Callback = function(v)
        if m1reset.Enabled then  -- Only trigger if GUI toggle is on
            triggerDash()
        end
    end
})


local Toggle = M1reset:Toggle({
    Title = "M1Reset",
    Desc = "Toggle dash GUI",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        m1reset.Enabled = state
    end
})

-- Default dash duration


-- Update dash duration based on input
M1reset:Input({
    Title = "duration",
    Desc = "on how long to dash",
    Value = tostring(dashDuration),
    InputIcon = "bird",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter duration in seconds...",
    Callback = function(input) 
        local num = tonumber(input)
        if num then
            dashDuration = num
            print("Dash duration set to: " .. dashDuration)
        else
            warn("Invalid input for dash duration")
        end
    end
})

M1reset:Input({
    Title = "dash force",
    Desc = "speed",
    Value = tostring(dashforce),
    InputIcon = "bird",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter force in number...",
    Callback = function(input) 
        local num1 = tonumber(input)
        if num1 then
            dashforce = num1
            print("Dash duration set to: " .. dashDuration)
        else
            warn("Invalid input for dash duration")
        end
    end
})


--// Handle character respawn
plr.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
    
    track = animator:LoadAnimation(anim)
end)

reduce:Button({
    Title = "potato graphics",
    Desc = "no texture",
    Locked = false,
    Callback = function()
        local Workspace = game:GetService("Workspace")

-- Function to remove all textures/decals from a part
local function RemoveTextures(inst)
    -- Remove decals and textures
    for _, child in ipairs(inst:GetChildren()) do
        if child:IsA("Decal") or child:IsA("Texture") or child:IsA("SurfaceAppearance") then
            child:Destroy()
        end
    end

    -- For MeshParts, remove the texture ID
    if inst:IsA("MeshPart") then
        inst.TextureID = ""
        inst.Material = Enum.Material.SmoothPlastic
    elseif inst:IsA("Part") or inst:IsA("UnionOperation") then
        inst.Material = Enum.Material.SmoothPlastic
    end
end

-- Clean existing parts
for _, inst in ipairs(Workspace:GetDescendants()) do
    RemoveTextures(inst)
end

-- Auto-clean new parts added to the workspace
Workspace.DescendantAdded:Connect(function(inst)
    RemoveTextures(inst)
end)

print("✅ All part textures removed")

    end
})

reduce:Button({
    Title = "reduce lag(max)",
    Desc = "",
    Locked = false,
    Callback = function()
        --// WORLD OPTIMIZER + MAP CLEANER + PARTICLE REMOVER
--// MainPart slightly dark

local Workspace = game:GetService("Workspace")

-- Names to KEEP inside workspace.Map
local KEEP_NAMES = {
    Floor = true,
    Roads = true,
    MainPart = true
}

-- Dark color for MainPart (adjust if needed)
local MAINPART_COLOR = Color3.fromRGB(80, 80, 80) -- dark gray

-- Remove textures, decals, and particles
local function CleanVisuals(inst)
    -- Remove decals/textures
    if inst:IsA("Decal") or inst:IsA("Texture") then
        inst:Destroy()

    elseif inst:IsA("SurfaceAppearance") then
        inst:Destroy()

    elseif inst:IsA("MeshPart") then
        inst.Material = Enum.Material.SmoothPlastic
        inst.TextureID = ""

    elseif inst:IsA("SpecialMesh") then
        inst.TextureId = ""

    elseif inst:IsA("Part") or inst:IsA("UnionOperation") then
        inst.Material = Enum.Material.SmoothPlastic
    end

    -- Remove particle effects
    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Beam") then
        inst.Enabled = false
        inst:Destroy()
    end
end

-- Apply darker color to MainPart (including models)
local function DarkenMainPart(obj)
    if obj.Name == "MainPart" then
        if obj:IsA("BasePart") then
            obj.Color = MAINPART_COLOR
        end

        for _, d in ipairs(obj:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Color = MAINPART_COLOR
            end
        end
    end
end

-- Clean whole world visuals
for _, inst in ipairs(Workspace:GetDescendants()) do
    CleanVisuals(inst)
end

-- Map folder logic
local Map = Workspace:FindFirstChild("Map")
if Map then
    -- Initial cleanup
    for _, obj in ipairs(Map:GetChildren()) do
        if not KEEP_NAMES[obj.Name] then
            obj:Destroy()
        else
            DarkenMainPart(obj)
        end
    end

    -- Block new unwanted objects
    Map.ChildAdded:Connect(function(obj)
        if not KEEP_NAMES[obj.Name] then
            obj:Destroy()
        else
            DarkenMainPart(obj)
        end
    end)
end

-- Auto-clean new world visuals & particles
Workspace.DescendantAdded:Connect(function(inst)
    CleanVisuals(inst)
end)

print("✅ MainPart darkened | Textures & particles removed | UI untouched")

    end
})
