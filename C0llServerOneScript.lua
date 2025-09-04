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
    floorPart.Size = Vector3.new(12, 1, 12)
    floorPart.Position = rootPart.Position - Vector3.new(0, 4, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = true
    floorPart.Transparency = 0.2
    floorPart.Material = Enum.Material.ForceField
    floorPart.Shape = Enum.PartType.Block
    floorPart.TopSurface = Enum.SurfaceType.Smooth
    floorPart.BottomSurface = Enum.SurfaceType.Smooth
    floorPart.Parent = workspace

    -- Add highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = floorPart
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    -- Start rainbow effect
    startRainbowEffect()

    -- Start following player
    startFollowingPlayer()
    
    -- Make player float
    makePlayerFloat()
end

-- Rainbow color effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if floorPart and floorPart.Parent then
            hue = (hue + 3) % 360
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

-- Make player float
local function makePlayerFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart then
        -- Create BodyVelocity to control floating
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        -- Create BodyPosition to maintain height
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
        bodyPosition.Position = rootPart.Position
        bodyPosition.D = 2000
        bodyPosition.P = 10000
        bodyPosition.Parent = rootPart
    end
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
                floorPart.Position = rootPart.Position - Vector3.new(0, 4, 0)
                
                -- Update body position to maintain floating
                local bodyPosition = rootPart:FindFirstChild("BodyPosition")
                if bodyPosition then
                    bodyPosition.Position = Vector3.new(rootPart.Position.X, rootPart.Position.Y, rootPart.Position.Z)
                end
            end
        end
    end)
end

-- Clean up floating effects
local function cleanupFloating()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        -- Remove floating objects
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        local bodyPosition = rootPart:FindFirstChild("BodyPosition")
        
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyPosition then bodyPosition:Destroy() end
    end
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
        
        -- Clean up floating
        cleanupFloating()

        print("🌈 Rainbow Air Walk: DISABLED")
    else
        -- Enable air walk
        airWalkEnabled = true
        createFollowingFloor()
        print("🌈 Rainbow Air Walk: ENABLED - ¡Ahora estás volando!")
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
    
    cleanupFloating()
end)

-- Clean up when character respawns
player.CharacterAdded:Connect(function()
    if airWalkEnabled then
        wait(1) -- Wait for character to load
        createFollowingFloor()
    end
end)

print("🌈 Rainbow Air Walk cargado! Presiona F para volar con suelo arcoíris!")
