-- Rainbow Air Walk Script for Roblox
-- Press F to toggle floating with a single rainbow floor that follows you

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Variables
local airWalkEnabled = false
local floorPart = nil
local rainbowConnection = nil
local followConnection = nil

-- Create single rainbow floor that follows player
local function createFollowingFloor()
    -- Clean up existing floor
    if floorPart then
        floorPart:Destroy()
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart

    -- Create single rainbow floor
    floorPart = Instance.new("Part")
    floorPart.Name = "RainbowAirWalkFloor"
    floorPart.Size = Vector3.new(12, 0.8, 12)
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = true
    floorPart.Transparency = 0.3
    floorPart.Material = Enum.Material.Neon
    floorPart.Shape = Enum.PartType.Block
    floorPart.Parent = workspace

    -- Add highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = floorPart
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- Start rainbow effect
    startRainbowEffect()

    -- Start following player
    startFollowingPlayer()
end

-- Rainbow color effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if floorPart and floorPart.Parent then
            hue = (hue + 2) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)

            floorPart.Color = color

            -- Update highlight color
            local highlight = floorPart:FindFirstChild("Highlight")
            if highlight then
                highlight.FillColor = color
                highlight.OutlineColor = color
            end
        end
    end)
end

-- Make floor follow player
local function startFollowingPlayer()
    if followConnection then
        followConnection:Disconnect()
    end

    followConnection = RunService.Heartbeat:Connect(function()
        if floorPart and floorPart.Parent and player.Character then
            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")

            if rootPart then
                -- Update floor position to follow player
                floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
            end
        end
    end)
end

-- Toggle rainbow air walk
local function toggleRainbowAirWalk()
    if airWalkEnabled then
        -- Disable air walk
        airWalkEnabled = false

        -- Clean up floor
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end

        -- Stop effects
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end

        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end

        print("🌈 Rainbow Air Walk: DISABLED")
    else
        -- Enable air walk
        airWalkEnabled = true
        createFollowingFloor()
        print("🌈 Rainbow Air Walk: ENABLED - Floor will follow you!")
    end
end

-- Connect F key press to toggle air walk
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleRainbowAirWalk()
    end
end)

-- Clean up when player leaves
player.CharacterRemoving:Connect(function()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
    end

    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end

    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
end)

print("🌈 Rainbow Air Walk loaded! Press F to toggle floating with rainbow floor!")
