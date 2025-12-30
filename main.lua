-- SERVICES
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- WHITELIST / GAMEPASS
local GAMEPASS_ID = 1537679659
local hasPass = false
pcall(function()
    hasPass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, GAMEPASS_ID)
end)
if not hasPass then
    LocalPlayer:Kick("You are not whitelisted. Get access in discord.gg/xtXPAbZ4sG")
end

-- SETTINGS
local DESYNC_ACTIVE = false
local WALK_ANIM_DISABLED = false

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 120) -- small side panel
frame.Position = UDim2.new(0.85, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.BackgroundTransparency = 1
title.Text = "OctoHub | discord.gg/xtXPAbZ4sG"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.fromRGB(255,255,255)

-- BUTTON FUNCTION
local function CreateButton(text)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1,-10,0,25)
    btn.Position = UDim2.new(0,5,0,25 + (#frame:GetChildren()-2)*30)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(255, 221, 51) -- yellow
    btn.TextColor3 = Color3.fromRGB(0,0,0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    return btn
end

-- DESYNC BUTTON
local desBtn = CreateButton("No Tool Desync: Click to run")
desBtn.MouseButton1Click:Connect(function()
    if not DESYNC_ACTIVE then
        -- Activate desync
        local DESYNCFLAGS = {
            {"S2PhysicsSenderRate","15000"},{"GameNetPVHeaderRotationalVelocityZeroCutoffExponent","-5000"},
            {"GameNetPVHeaderLinearVelocityZeroCutoffExponent","-5000"},{"AngularVelociryLimit","360"},
            {"PhysicsSenderMaxBandwidthBps","20000"},{"MaxDataPacketPerSend","2147483647"},
            {"ServerMaxBandwith","52"},{"SimExplicitlyCappedTimestepMultiplier","2147483646"},
            {"TimestepArbiterVelocityCriteriaThresholdTwoDt","2147483646"},{"MaxTimestepMultiplierBuoyancy","2147483647"},
            {"MaxTimestepMultiplierAcceleration","2147483647"},{"MaxTimestepMultiplierContstraint","2147483647"},
            {"LargeReplicatorWrite5","true"},{"LargeReplicatorRead5","true"},{"LargeReplicatorEnabled9","true"},
            {"NextGenReplicatorEnabledWrite4","true"}
        }
        for _,flag in ipairs(DESYNCFLAGS) do
            pcall(function() setfflag(flag[1],flag[2]) end)
        end
        DESYNC_ACTIVE = true
        desBtn.Text = "Running..."
        task.wait(0.5)
        desBtn.Text = "Desync Active | Rejoin to disable"
    end
end)

-- WALK ANIMATION BUTTON
local walkBtn = CreateButton("Disable Walk Animation: OFF")
walkBtn.MouseButton1Click:Connect(function()
    WALK_ANIM_DISABLED = not WALK_ANIM_DISABLED
    walkBtn.Text = WALK_ANIM_DISABLED and "Disable Walk Animation: ON" or "Disable Walk Animation: OFF"
end)

-- WALK ANIMATION DISABLE LOOP
RunService.Heartbeat:Connect(function()
    if WALK_ANIM_DISABLED then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end
end)

print("OctoHub | Small Side Panel UI Loaded | discord.gg/xtXPAbZ4sG")
