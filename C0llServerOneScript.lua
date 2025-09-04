-- Rainbow Air Walk Script for Roblox
-- Press F to toggle air walk with visible rainbow floor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Variables
local airWalkEnabled = false
local floorParts = {}
local rainbowConnection = nil
local highlightConnections = {}

-- Configuration
local FLOOR_COUNT = 10 -- Number of floors to create
local FLOOR_SPACING = 8 -- Distance between each floor (studs)
local FLOOR_SIZE = Vector3.new(15, 0.8, 15) -- Size of each floor

-- Create multiple rainbow floors stacked upward
local function createRainbowFloors()
    -- Clean up existing floors
    for _, part in pairs(floorParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    floorParts = {}

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart
    local basePosition = rootPart.Position

    -- Create multiple floors going upward
    for i = 1, FLOOR_COUNT do
        local floorPart = Instance.new("Part")
        floorPart.Name = "RainbowFloor_" .. i
        floorPart.Size = FLOOR_SIZE
        floorPart.Position = basePosition + Vector3.new(0, (i - 1) * FLOOR_SPACING - 3, 0)
        floorPart.Anchored = true
        floorPart.CanCollide = true
        floorPart.Transparency = 0.2
        floorPart.Material = Enum.Material.Neon
        floorPart.Shape = Enum.PartType.Block
        floorPart.Parent = workspace

        -- Add highlight effect
        local highlight = Instance.new("Highlight")
        highlight.Parent = floorPart
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        table.insert(floorParts, floorPart)
    end

    -- Start rainbow effects
    startRainbowEffect()
end

-- Rainbow color and highlight effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        hue = (hue + 1.5) % 360

        for i, floorPart in pairs(floorParts) do
            if floorPart and floorPart.Parent then
                -- Different hue offset for each floor to create wave effect
                local floorHue = (hue + (i * 30)) % 360
                local color = Color3.fromHSV(floorHue / 360, 1, 1)

                floorPart.Color = color

                -- Update highlight color
                local highlight = floorPart:FindFirstChild("Highlight")
                if highlight then
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                end
            end
        end
    end)
end

-- Toggle rainbow floors
local function toggleRainbowFloors()
    if airWalkEnabled then
        -- Disable rainbow floors
        airWalkEnabled = false

        -- Clean up all floors
        for _, part in pairs(floorParts) do
            if part and part.Parent then
                part:Destroy()
            end
        end
        floorParts = {}

        -- Stop rainbow effect
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end

        print("🌈 Rainbow Floors: DISABLED")
    else
        -- Enable rainbow floors
        airWalkEnabled = true
        createRainbowFloors()
        print("🌈 Rainbow Floors: ENABLED - " .. FLOOR_COUNT .. " floors created!")
    end
end

-- Connect F key press to toggle rainbow floors
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleRainbowFloors()
    end
end)

-- Clean up when player leaves
player.CharacterRemoving:Connect(function()
    -- Clean up all floors
    for _, part in pairs(floorParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    floorParts = {}

    -- Stop rainbow effect
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
end)

print("🌈 Rainbow Floors loaded! Press F to create " .. FLOOR_COUNT .. " rainbow floors!")
