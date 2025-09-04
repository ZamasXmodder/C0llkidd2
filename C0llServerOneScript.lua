-- Rainbow Air Walk Script for Roblox
-- Press F to toggle air walk with visible rainbow floor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Variables
local airWalkEnabled = false
local floorPart = nil
local updateConnection = nil
local rainbowConnection = nil

-- Create rainbow floor under player
local function createRainbowFloor()
    if floorPart then
        floorPart:Destroy()
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart

    -- Create visible rainbow part
    floorPart = Instance.new("Part")
    floorPart.Name = "RainbowAirWalkFloor"
    floorPart.Size = Vector3.new(12, 0.5, 12)
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = true
    floorPart.Transparency = 0.3 -- Semi-transparent
    floorPart.Material = Enum.Material.Neon
    floorPart.Shape = Enum.PartType.Block
    floorPart.Parent = workspace

    -- Add rainbow effect
    startRainbowEffect()

    return floorPart
end

-- Rainbow color effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if floorPart then
            hue = (hue + 2) % 360
            floorPart.Color = Color3.fromHSV(hue / 360, 1, 1)
        end
    end)
end

-- Update floor position to follow player
local function updateFloorPosition()
    if not airWalkEnabled or not floorPart then
        return
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
end

-- Toggle air walk
local function toggleAirWalk()
    if airWalkEnabled then
        -- Disable air walk
        airWalkEnabled = false
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
        if updateConnection then
            updateConnection:Disconnect()
            updateConnection = nil
        end
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        print("🌈 Rainbow Air Walk: DISABLED")
    else
        -- Enable air walk
        airWalkEnabled = true
        createRainbowFloor()
        updateConnection = RunService.Heartbeat:Connect(updateFloorPosition)
        print("🌈 Rainbow Air Walk: ENABLED")
    end
end

-- Connect F key press to toggle air walk
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleAirWalk()
    end
end)

-- Clean up when player leaves
player.CharacterRemoving:Connect(function()
    if floorPart then
        floorPart:Destroy()
        floorPart = nil
    end
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
end)

print("🌈 Rainbow Air Walk loaded! Press F to toggle air walk.")
