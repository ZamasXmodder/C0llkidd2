-- Rainbow Air Walk Script with Control Panel for Roblox
-- Press F to toggle floating with a single rainbow floor that follows you

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local airWalkEnabled = false
local floorPart = nil
local rainbowConnection = nil
local followConnection = nil
local flyConnection = nil
local controlPanel = nil
local toggleButton = nil
local backpackForceEnabled = false
local backpackForceConnection = nil

-- Base teleport variables
local baseReturnEnabled = false
local basePosition = nil
local teleportPart = nil
local teleportConnection = nil
local brainrotDetectionConnection = nil
local baseReturnButton = nil

-- Settings
local settings = {
    flySpeed = 50,
    hoverHeight = 16,
    rainbowSpeed = 5,
    floorSize = 12,
    teleportSpeed = 30  -- Speed for base teleport
}

-- Key states for smooth movement
local keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false
}

-- Force backpack visibility
local function forceBackpackVisible()
    if backpackForceConnection then
        backpackForceConnection:Disconnect()
    end
    
    backpackForceConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            
            -- Also try to make sure it's visible in PlayerGui
            local backpackGui = playerGui:FindFirstChild("Backpack")
            if backpackGui then
                backpackGui.Enabled = true
                if backpackGui:FindFirstChild("Hotbar") then
                    backpackGui.Hotbar.Visible = true
                end
            end
        end)
    end)
end

-- Stop forcing backpack visibility
local function stopBackpackForce()
    if backpackForceConnection then
        backpackForceConnection:Disconnect()
        backpackForceConnection = nil
    end
end

-- Base teleport functions
local function setBasePosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        basePosition = player.Character.HumanoidRootPart.Position
        print("🏠 Base position set at: " .. tostring(basePosition))
    end
end

local function createTeleportPart()
    if teleportPart then
        teleportPart:Destroy()
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart

    -- Create teleport part
    teleportPart = Instance.new("Part")
    teleportPart.Name = "BaseTeleportPart"
    teleportPart.Size = Vector3.new(8, 2, 8)
    teleportPart.Position = rootPart.Position + Vector3.new(0, 5, 0)
    teleportPart.Anchored = true
    teleportPart.CanCollide = false
    teleportPart.Transparency = 0.3
    teleportPart.Material = Enum.Material.Neon
    teleportPart.Shape = Enum.PartType.Block
    teleportPart.Color = Color3.fromRGB(255, 215, 0) -- Gold color
    teleportPart.Parent = workspace

    -- Add highlight
    local highlight = Instance.new("Highlight")
    highlight.Parent = teleportPart
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

    -- Add text label
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.Parent = teleportPart

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🏠 RETURN TO BASE"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboardGui

    -- Add particles
    local attachment = Instance.new("Attachment")
    attachment.Parent = teleportPart

    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Lifetime = NumberRange.new(1, 3)
    particles.Rate = 30
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(3, 8)
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))

    -- Add touch detection
    teleportPart.Touched:Connect(function(hit)
        local character = hit.Parent
        if character == player.Character and character:FindFirstChild("HumanoidRootPart") then
            teleportToBase()
        end
    end)
end

local function teleportToBase()
    if not basePosition or not player.Character then
        return
    end

    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if not rootPart then
        return
    end

    print("🚀 Teleporting to base...")

    -- Smooth teleport using TweenService
    local TweenService = game:GetService("TweenService")
    local tweenInfo = TweenInfo.new(
        2, -- Duration
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        0, -- Repeat count
        false, -- Reverses
        0 -- Delay
    )

    local tween = TweenService:Create(rootPart, tweenInfo, {
        Position = basePosition + Vector3.new(0, 5, 0)
    })

    tween:Play()

    tween.Completed:Connect(function()
        print("🏠 Arrived at base!")
    end)
end

local function detectBrainrot()
    if brainrotDetectionConnection then
        brainrotDetectionConnection:Disconnect()
    end

    brainrotDetectionConnection = RunService.Heartbeat:Connect(function()
        if not baseReturnEnabled or not player.Character then
            return
        end

        local character = player.Character
        local backpack = player:FindFirstChild("Backpack")

        -- Check for brainrot in backpack or equipped
        local hasBrainrot = false

        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and (
                    string.find(string.lower(tool.Name), "brainrot") or
                    string.find(string.lower(tool.Name), "brain") or
                    string.find(string.lower(tool.Name), "rot") or
                    string.find(string.lower(tool.Name), "italian") or
                    string.find(string.lower(tool.Name), "tralalero")
                ) then
                    hasBrainrot = true
                    break
                end
            end
        end

        -- Check equipped tool
        if not hasBrainrot and character then
            local equippedTool = character:FindFirstChildOfClass("Tool")
            if equippedTool and (
                string.find(string.lower(equippedTool.Name), "brainrot") or
                string.find(string.lower(equippedTool.Name), "brain") or
                string.find(string.lower(equippedTool.Name), "rot") or
                string.find(string.lower(equippedTool.Name), "italian") or
                string.find(string.lower(equippedTool.Name), "tralalero")
            ) then
                hasBrainrot = true
            end
        end

        -- Create/destroy teleport part based on brainrot detection
        if hasBrainrot and not teleportPart then
            createTeleportPart()
            print("🧠 Brainrot detected! Teleport part created.")
        elseif not hasBrainrot and teleportPart then
            teleportPart:Destroy()
            teleportPart = nil
        end

        -- Update teleport part position to follow player
        if teleportPart and character:FindFirstChild("HumanoidRootPart") then
            teleportPart.Position = character.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
        end
    end)
end

local function toggleBaseReturn()
    if baseReturnEnabled then
        -- Disable base return
        baseReturnEnabled = false

        if brainrotDetectionConnection then
            brainrotDetectionConnection:Disconnect()
            brainrotDetectionConnection = nil
        end

        if teleportPart then
            teleportPart:Destroy()
            teleportPart = nil
        end

        if baseReturnButton then
            baseReturnButton.Text = "AUTO RETURN TO BASE: OFF"
            baseReturnButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        end

        print("🏠 Auto Return to Base: DISABLED")
    else
        -- Enable base return
        if not basePosition then
            setBasePosition()
        end

        baseReturnEnabled = true
        detectBrainrot()

        if baseReturnButton then
            baseReturnButton.Text = "AUTO RETURN TO BASE: ON"
            baseReturnButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        end

        print("🏠 Auto Return to Base: ENABLED")
        print("🧠 Will detect brainrots and create teleport part")
    end
end

-- Create GUI Panel
local function createControlPanel()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RainbowAirWalkPanel"
    screenGui.Parent = playerGui
    
    -- Main Frame (increased height for new button)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 500)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "🌈 Rainbow Air Walk Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleButton"
    toggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
    toggleBtn.Position = UDim2.new(0.05, 0, 0, 60)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.Text = "ACTIVAR VUELO (F)"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 5)
    toggleCorner.Parent = toggleBtn
    
    -- Backpack Force Button
    local backpackBtn = Instance.new("TextButton")
    backpackBtn.Name = "BackpackButton"
    backpackBtn.Size = UDim2.new(0.9, 0, 0, 35)
    backpackBtn.Position = UDim2.new(0.05, 0, 0, 110)
    backpackBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    backpackBtn.Text = "FORZAR BACKPACK VISIBLE"
    backpackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    backpackBtn.TextScaled = true
    backpackBtn.Font = Enum.Font.Gotham
    backpackBtn.Parent = mainFrame
    
    local backpackCorner = Instance.new("UICorner")
    backpackCorner.CornerRadius = UDim.new(0, 5)
    backpackCorner.Parent = backpackBtn

    -- Base Return Button
    local baseBtn = Instance.new("TextButton")
    baseBtn.Name = "BaseReturnButton"
    baseBtn.Size = UDim2.new(0.9, 0, 0, 35)
    baseBtn.Position = UDim2.new(0.05, 0, 0, 155)
    baseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    baseBtn.Text = "AUTO RETURN TO BASE: OFF"
    baseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    baseBtn.TextScaled = true
    baseBtn.Font = Enum.Font.Gotham
    baseBtn.Parent = mainFrame

    local baseCorner = Instance.new("UICorner")
    baseCorner.CornerRadius = UDim.new(0, 5)
    baseCorner.Parent = baseBtn

    -- Speed Control
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 205)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Velocidad de Vuelo: " .. settings.flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = mainFrame

    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
    speedSlider.Position = UDim2.new(0.05, 0, 0, 240)
    speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    speedSlider.Parent = mainFrame
    
    local speedSliderCorner = Instance.new("UICorner")
    speedSliderCorner.CornerRadius = UDim.new(0, 10)
    speedSliderCorner.Parent = speedSlider
    
    local speedButton = Instance.new("TextButton")
    speedButton.Size = UDim2.new(0, 20, 1, 0)
    speedButton.Position = UDim2.new(settings.flySpeed / 100, -10, 0, 0)
    speedButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    speedButton.Text = ""
    speedButton.Parent = speedSlider
    
    local speedButtonCorner = Instance.new("UICorner")
    speedButtonCorner.CornerRadius = UDim.new(1, 0)
    speedButtonCorner.Parent = speedButton
    
    -- Rainbow Speed Control
    local rainbowLabel = Instance.new("TextLabel")
    rainbowLabel.Size = UDim2.new(0.9, 0, 0, 30)
    rainbowLabel.Position = UDim2.new(0.05, 0, 0, 275)
    rainbowLabel.BackgroundTransparency = 1
    rainbowLabel.Text = "Velocidad Arcoíris: " .. settings.rainbowSpeed
    rainbowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rainbowLabel.TextScaled = true
    rainbowLabel.Font = Enum.Font.Gotham
    rainbowLabel.Parent = mainFrame

    local rainbowSlider = Instance.new("Frame")
    rainbowSlider.Size = UDim2.new(0.9, 0, 0, 20)
    rainbowSlider.Position = UDim2.new(0.05, 0, 0, 310)
    rainbowSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    rainbowSlider.Parent = mainFrame
    
    local rainbowSliderCorner = Instance.new("UICorner")
    rainbowSliderCorner.CornerRadius = UDim.new(0, 10)
    rainbowSliderCorner.Parent = rainbowSlider
    
    local rainbowButton = Instance.new("TextButton")
    rainbowButton.Size = UDim2.new(0, 20, 1, 0)
    rainbowButton.Position = UDim2.new(settings.rainbowSpeed / 20, -10, 0, 0)
    rainbowButton.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
    rainbowButton.Text = ""
    rainbowButton.Parent = rainbowSlider
    
    local rainbowButtonCorner = Instance.new("UICorner")
    rainbowButtonCorner.CornerRadius = UDim.new(1, 0)
    rainbowButtonCorner.Parent = rainbowButton
    
    -- Floor Size Control
    local sizeLabel = Instance.new("TextLabel")
    sizeLabel.Size = UDim2.new(0.9, 0, 0, 30)
    sizeLabel.Position = UDim2.new(0.05, 0, 0, 345)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Tamaño del Suelo: " .. settings.floorSize
    sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeLabel.TextScaled = true
    sizeLabel.Font = Enum.Font.Gotham
    sizeLabel.Parent = mainFrame

    local sizeSlider = Instance.new("Frame")
    sizeSlider.Size = UDim2.new(0.9, 0, 0, 20)
    sizeSlider.Position = UDim2.new(0.05, 0, 0, 380)
    sizeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sizeSlider.Parent = mainFrame
    
    local sizeSliderCorner = Instance.new("UICorner")
    sizeSliderCorner.CornerRadius = UDim.new(0, 10)
    sizeSliderCorner.Parent = sizeSlider
    
    local sizeButton = Instance.new("TextButton")
    sizeButton.Size = UDim2.new(0, 20, 1, 0)
    sizeButton.Position = UDim2.new((settings.floorSize - 5) / 25, -10, 0, 0)
    sizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    sizeButton.Text = ""
    sizeButton.Parent = sizeSlider
    
        local sizeButtonCorner = Instance.new("UICorner")
    sizeButtonCorner.CornerRadius = UDim.new(1, 0)
    sizeButtonCorner.Parent = sizeButton
    
    -- Controls Info
    local controlsLabel = Instance.new("TextLabel")
    controlsLabel.Size = UDim2.new(0.9, 0, 0, 60)
    controlsLabel.Position = UDim2.new(0.05, 0, 0, 415)
    controlsLabel.BackgroundTransparency = 1
    controlsLabel.Text = "Controles:\nW/A/S/D - Movimiento\nEspacio - Subir\nShift - Bajar"
    controlsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    controlsLabel.TextScaled = true
    controlsLabel.Font = Enum.Font.Gotham
    controlsLabel.Parent = mainFrame
    
    -- Slider functionality
    local function setupSlider(slider, button, label, min, max, current, callback)
        local dragging = false
        
        button.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouse = Players.LocalPlayer:GetMouse()
                local sliderPos = slider.AbsolutePosition
                local sliderSize = slider.AbsoluteSize
                local relativeX = math.clamp((mouse.X - sliderPos.X) / sliderSize.X, 0, 1)
                
                button.Position = UDim2.new(relativeX, -10, 0, 0)
                
                local value = math.floor(min + (max - min) * relativeX)
                callback(value)
            end
        end)
    end
    
    setupSlider(speedSlider, speedButton, speedLabel, 10, 100, settings.flySpeed, function(value)
        settings.flySpeed = value
        speedLabel.Text = "Velocidad de Vuelo: " .. value
    end)
    
    setupSlider(rainbowSlider, rainbowButton, rainbowLabel, 1, 20, settings.rainbowSpeed, function(value)
        settings.rainbowSpeed = value
        rainbowLabel.Text = "Velocidad Arcoíris: " .. value
    end)
    
    setupSlider(sizeSlider, sizeButton, sizeLabel, 5, 30, settings.floorSize, function(value)
        settings.floorSize = value
        sizeLabel.Text = "Tamaño del Suelo: " .. value
        if floorPart then
            floorPart.Size = Vector3.new(value, 1, value)
        end
    end)
    
    -- Toggle button functionality
    toggleBtn.MouseButton1Click:Connect(function()
        toggleRainbowAirWalk()
    end)
    
    -- Backpack button functionality
    backpackBtn.MouseButton1Click:Connect(function()
        if backpackForceEnabled then
            backpackForceEnabled = false
            stopBackpackForce()
            backpackBtn.Text = "FORZAR BACKPACK VISIBLE"
            backpackBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            print("🎒 Forzado de Backpack: DESACTIVADO")
        else
            backpackForceEnabled = true
            forceBackpackVisible()
            backpackBtn.Text = "PARAR FORZADO BACKPACK"
            backpackBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
            print("🎒 Forzado de Backpack: ACTIVADO")
        end
    end)

    -- Base return button functionality
    baseBtn.MouseButton1Click:Connect(function()
        toggleBaseReturn()
    end)

    baseReturnButton = baseBtn
    return screenGui, toggleBtn
end

-- Rainbow color effect
local function startRainbowEffect()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end

    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if floorPart and floorPart.Parent then
            hue = (hue + settings.rainbowSpeed) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)

            floorPart.Color = color

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
                floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
            end
        end
    end)
end

-- Flying system (FIXED CONTROLS - W/S corrected)
local function startFlying()
    if flyConnection then
        flyConnection:Disconnect()
    end

    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not rootPart or not humanoid then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    flyConnection = RunService.Heartbeat:Connect(function()
        if not rootPart.Parent then return end
        
        local camera = workspace.CurrentCamera
        local velocity = Vector3.new(0, settings.hoverHeight, 0)
        
        -- Movement based on key states (FIXED W/S)
        local moveX = 0
        local moveZ = 0
        local moveY = 0
        
        -- FIXED: W now goes forward (negative Z), S goes backward (positive Z)
        if keys.W then moveZ = moveZ + 1 end  -- Forward
        if keys.S then moveZ = moveZ - 1 end  -- Backward
        if keys.A then moveX = moveX - 1 end  -- Left
        if keys.D then moveX = moveX + 1 end  -- Right
        if keys.Space then moveY = moveY + 1 end  -- Up
        if keys.LeftShift then moveY = moveY - 1 end  -- Down
        
        if moveX ~= 0 or moveZ ~= 0 then
            local cameraCFrame = camera.CFrame
            local direction = (cameraCFrame.LookVector * moveZ + cameraCFrame.RightVector * moveX).Unit
            velocity = velocity + direction * settings.flySpeed
        end
        
        if moveY ~= 0 then
            velocity = velocity + Vector3.new(0, moveY * settings.flySpeed, 0)
        end
        
        bodyVelocity.Velocity = velocity
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
        
        for _, obj in pairs(rootPart:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") or obj:IsA("BodyPosition") then
                obj:Destroy()
            end
        end
    end
end

-- Create single rainbow floor that follows player
local function createFollowingFloor()
    if floorPart then
        floorPart:Destroy()
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local rootPart = character.HumanoidRootPart

    floorPart = Instance.new("Part")
    floorPart.Name = "RainbowAirWalkFloor"
    floorPart.Size = Vector3.new(settings.floorSize, 1, settings.floorSize)
    floorPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
    floorPart.Anchored = true
    floorPart.CanCollide = false
    floorPart.Transparency = 0.1
    floorPart.Material = Enum.Material.ForceField
    floorPart.Shape = Enum.PartType.Block
    floorPart.Color = Color3.fromRGB(255, 0, 0)
    floorPart.Parent = workspace

    local highlight = Instance.new("Highlight")
    highlight.Parent = floorPart
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)

    local attachment = Instance.new("Attachment")
    attachment.Parent = floorPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particles.Lifetime = NumberRange.new(1, 2)
    particles.Rate = 50
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(5, 10)

    startRainbowEffect()
    startFollowingPlayer()
    startFlying()
end

-- Toggle rainbow air walk
local function toggleRainbowAirWalk()
    if airWalkEnabled then
        airWalkEnabled = false

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
        
        if toggleButton then
            toggleButton.Text = "ACTIVAR VUELO (F)"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end

        print("🌈 Rainbow Air Walk: DISABLED")
    else
        airWalkEnabled = true
        createFollowingFloor()
        
        if toggleButton then
            toggleButton.Text = "DESACTIVAR VUELO (F)"
            toggleButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        print("🌈 Rainbow Air Walk: ENABLED - ¡Controles corregidos!")
    end
end

-- Key input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.F then
        toggleRainbowAirWalk()
    elseif airWalkEnabled then
        if input.KeyCode == Enum.KeyCode.W then
            keys.W = true
                elseif input.KeyCode == Enum.KeyCode.A then
            keys.A = true
        elseif input.KeyCode == Enum.KeyCode.S then
            keys.S = true
        elseif input.KeyCode == Enum.KeyCode.D then
            keys.D = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            keys.Space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            keys.LeftShift = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.W then
        keys.W = false
    elseif input.KeyCode == Enum.KeyCode.A then
        keys.A = false
    elseif input.KeyCode == Enum.KeyCode.S then
        keys.S = false
    elseif input.KeyCode == Enum.KeyCode.D then
        keys.D = false
    elseif input.KeyCode == Enum.KeyCode.Space then
        keys.Space = false
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        keys.LeftShift = false
    end
end)

-- Clean up functions
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

    if teleportPart then
        teleportPart:Destroy()
        teleportPart = nil
    end

    if brainrotDetectionConnection then
        brainrotDetectionConnection:Disconnect()
        brainrotDetectionConnection = nil
    end

    stopFlying()
    stopBackpackForce()
end)

player.CharacterAdded:Connect(function()
    wait(2)
    if airWalkEnabled then
        createFollowingFloor()
    end
    if backpackForceEnabled then
        forceBackpackVisible()
    end
end)

-- Clean up when leaving game
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopBackpackForce()
        if brainrotDetectionConnection then
            brainrotDetectionConnection:Disconnect()
            brainrotDetectionConnection = nil
        end
        if teleportPart then
            teleportPart:Destroy()
            teleportPart = nil
        end
    end
end)

-- Initialize control panel
controlPanel, toggleButton = createControlPanel()

print("🌈 Rainbow Air Walk con Panel de Control cargado!")
print("✅ Controles W/S corregidos")
print("🎒 Nueva función: Forzar Backpack Visible")
print("Presiona F para activar/desactivar el vuelo")
print("Usa el panel para ajustar velocidades y configuraciones")
