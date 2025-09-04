-- Rainbow Air Walk Script with Control Panel for Roblox
-- Press F to toggle floating with a single rainbow floor that follows you

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

-- Settings
local settings = {
    flySpeed = 50,
    hoverHeight = 16,
    rainbowSpeed = 5,
    floorSize = 12
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

-- Create GUI Panel
local function createControlPanel()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RainbowAirWalkPanel"
    screenGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
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
    
    -- Speed Control
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.9, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 120)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Velocidad de Vuelo: " .. settings.flySpeed
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = mainFrame
    
    local speedSlider = Instance.new("Frame")
    speedSlider.Size = UDim2.new(0.9, 0, 0, 20)
    speedSlider.Position = UDim2.new(0.05, 0, 0, 155)
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
    rainbowLabel.Position = UDim2.new(0.05, 0, 0, 190)
    rainbowLabel.BackgroundTransparency = 1
    rainbowLabel.Text = "Velocidad Arcoíris: " .. settings.rainbowSpeed
    rainbowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rainbowLabel.TextScaled = true
    rainbowLabel.Font = Enum.Font.Gotham
    rainbowLabel.Parent = mainFrame
    
    local rainbowSlider = Instance.new("Frame")
    rainbowSlider.Size = UDim2.new(0.9, 0, 0, 20)
    rainbowSlider.Position = UDim2.new(0.05, 0, 0, 225)
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
    sizeLabel.Position = UDim2.new(0.05, 0, 0, 260)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Tamaño del Suelo: " .. settings.floorSize
    sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeLabel.TextScaled = true
    sizeLabel.Font = Enum.Font.Gotham
    sizeLabel.Parent = mainFrame
    
    local sizeSlider = Instance.new("Frame")
    sizeSlider.Size = UDim2.new(0.9, 0, 0, 20)
    sizeSlider.Position = UDim2.new(0.05, 0, 0, 295)
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
    controlsLabel.Position = UDim2.new(0.05, 0, 0, 330)
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

-- Flying system (FIXED CONTROLS)
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
        
        -- Movement based on key states
        local moveX = 0
        local moveZ = 0
        local moveY = 0
        
        if keys.W then moveZ = moveZ - 1 end
        if keys.S then moveZ = moveZ + 1 end
        if keys.A then moveX = moveX - 1 end
        if keys.D then moveX = moveX + 1 end
        if keys.Space then moveY = moveY + 1 end
        if keys.LeftShift then moveY = moveY - 1 end
        
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
        
        print("🌈 Rainbow Air Walk: ENABLED - ¡Usa WASD + Espacio/Shift para volar!")
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
    
    stopFlying()
end)

player.CharacterAdded:Connect(function()
    wait(2)
    if airWalkEnabled then
        createFollowingFloor()
    end
end)

-- Initialize control panel
controlPanel, toggleButton = createControlPanel()

print("🌈 Rainbow Air Walk con Panel de Control cargado!")
print("Presiona F para activar/desactivar el vuelo")
print("Usa el panel para ajustar velocidades y configuraciones")
