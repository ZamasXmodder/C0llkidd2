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
local flyConnection = nil

-- Rainbow color effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if floorPart and floorPart.Parent then
            hue = (hue + 5) % 360
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

-- Flying system
local function startFlying()
    if flyConnection then
        flyConnection:Disconnect()
    end

    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then return end

    -- Create BodyVelocity for movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    -- Create BodyAngularVelocity for rotation control
    local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart

    flyConnection = RunService.Heartbeat:Connect(function()
        if not rootPart.Parent then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        local speed = 50

        if moveVector.Magnitude > 0 then
            -- Move in the direction the player is walking, but relative to camera
            local cameraCFrame = camera.CFrame
            local direction = (cameraCFrame.LookVector * moveVector.Z + cameraCFrame.RightVector * moveVector.X)
            bodyVelocity.Velocity = direction * speed + Vector3.new(0, 16, 0)
        else
            -- Just hover
            bodyVelocity.Velocity = Vector3.new(0, 16, 0)
        end
    end)
end

-- Stop flying
local function stopFlying()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        -- Remove all body movers
        for _, obj in pairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") then
                obj:Destroy()
            end
        end
    end
end

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
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = false  -- No collision so it doesn't interfere
    floorPart.Transparency = 0.1
    floorPart.Material = Enum.Material.ForceField
    floorPart.Shape = Enum.PartType.Block
    floorPart.Color = Color3.fromRGB(255, 0, 0)  -- Start with red
    floorPart.Parent = workspace

    -- Add highlight effect for extra glow
    local highlight = Instance.new("Highlight")
    highlight.Parent = floorPart
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

    -- Add particle effect for extra rainbow effect
    local attachment = Instance.new("Attachment")
    attachment.Parent = floorPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Rate = 50
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(5, 10)

    -- Start rainbow effect
    startRainbowEffect()

    -- Start following player
    startFollowingPlayer()
    
    -- Start flying
    startFlying()
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
        
        -- Stop flying
        stopFlying()

        print("🌈 Rainbow Air Walk: DISABLED")
    else
        -- Enable air walk
        airWalkEnabled = true
        createFollowingFloor()
        print("🌈 Rainbow Air Walk: ENABLED - ¡Usa WASD para volar en cualquier dirección!")
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
    
    stopFlying()
end)

-- Clean up when character respawns
player.CharacterAdded:Connect(function()
    wait(2)
    if airWalkEnabled then
        createFollowingFloor()
    end
end)

print("🌈 Rainbow Air Walk cargado! Presiona F para volar con suelo arcoíris!")
