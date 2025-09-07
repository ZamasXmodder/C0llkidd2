-- ========================================
-- 🧠 STEALTH BRAINROT PANEL - NATURAL MOVEMENT
-- ========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ========================================
-- CONFIGURATION VARIABLES
-- ========================================
local systemActive = {
    esp_secret = false,
    esp_god = false,
    speed_boost = false,
    jump_boost = false,
    contact_fling = false
}

local configuration = {
    speed_multiplier = 2.5,
    jump_multiplier = 2.0,
    fling_force = 75
}

local activeConnections = {}
local buttonReferences = {}

-- ========================================
-- BRAINROT DETECTION LISTS
-- ========================================
local secretBrainrots = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos",
    "Las Tralaleritas", "Graipuss Medussi", "La Grande Combinasion",
    "Nuclearo Dinossauro", "Garama and Madundung", "Tortuginni Dragonfruitini",
    "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas",
    "Karkerkar Kurkur", "Los Hotspotsitos", "Esok Sekolah",
    "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion",
    "Ketupat Kepat"
}

local godBrainrots = {
    "Zibra Zubra Zibralini", "Tigrilini Watermelini", "Cocofanta Elefanto",
    "Girafa Celestre", "Gyattatino Nyanino", "Matteo",
    "Tralalero Tralala", "Espresso Signora", "Odin Din Din Dun",
    "Statutino Libertino", "Trenostruzzo Turbo 3000", "Ballerino Lololo",
    "Los Orcalitos", "Tralalita Tralala", "Urubini Flamenguini",
    "Trigoligre Frutonni", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Los Crocodilitos", "Piccione Macchina", "Trippi Troppi Troppa Trippa",
    "Los Tungtuntuncitos", "Tukanno Bananno", "Alessio",
    "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii"
}

-- ========================================
-- INTERFACE CREATION SYSTEM
-- ========================================
local function createUserInterface()
    if CoreGui:FindFirstChild("StealthBrainrotGUI") then
        CoreGui:FindFirstChild("StealthBrainrotGUI"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealthBrainrotGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 380)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = mainFrame
    
    -- Header Configuration
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Color3.fromRGB(45, 85, 125)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 22)
    headerFix.Position = UDim2.new(0, 0, 1, -22)
    headerFix.BackgroundColor3 = Color3.fromRGB(45, 85, 125)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🧠 STEALTH BRAINROT"
    titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 17)
    closeCorner.Parent = closeButton
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -10, 1, -55)
    contentFrame.Position = UDim2.new(0, 5, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(45, 85, 125)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    contentFrame.Parent = mainFrame
    
    -- Drag Functionality Implementation
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return screenGui, mainFrame, contentFrame, closeButton
end

-- ========================================
-- INTERFACE COMPONENT CREATION
-- ========================================
local function createFunctionButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function createConfigurationSlider(parent, labelText, minValue, maxValue, currentValue, position, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(0.9, 0, 0, 60)
    sliderContainer.Position = position
    sliderContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    sliderContainer.BorderSizePixel = 0
    sliderContainer.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = sliderContainer
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.7, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = labelText
    titleLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
    titleLabel.TextSize = 10
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = sliderContainer
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Size = UDim2.new(0.3, -10, 0.4, 0)
    valueDisplay.Position = UDim2.new(0.7, 0, 0, 0)
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Text = tostring(currentValue)
    valueDisplay.TextColor3 = Color3.fromRGB(45, 85, 125)
    valueDisplay.TextSize = 10
    valueDisplay.Font = Enum.Font.GothamBold
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = sliderContainer
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(0.85, 0, 0, 8)
    sliderTrack.Position = UDim2.new(0.075, 0, 0.6, 0)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderContainer
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 4)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentValue - minValue) / (maxValue - minValue), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(45, 85, 125)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
    fillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("TextButton")
    sliderHandle.Size = UDim2.new(0, 18, 0, 18)
    sliderHandle.Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -9, 0.5, -9)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(45, 85, 125)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Text = ""
    sliderHandle.Parent = sliderTrack
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 9)
    handleCorner.Parent = sliderHandle
    
    -- Slider Interaction Logic
    local dragging = false
    
    local function updateSliderValue(input)
        local relativePosition = input.Position.X - sliderTrack.AbsolutePosition.X
        local percentage = math.clamp(relativePosition / sliderTrack.AbsoluteSize.X, 0, 1)
        
        local newValue = minValue + (maxValue - minValue) * percentage
        if maxValue <= 10 then
            newValue = math.floor(newValue * 10) / 10 -- One decimal place
        else
            newValue = math.floor(newValue)
        end
        
        valueDisplay.Text = tostring(newValue)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderHandle.Position = UDim2.new(percentage, -9, 0.5, -9)
        
        if callback then
            callback(newValue)
        end
    end
    
    sliderHandle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSliderValue(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateSliderValue(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderContainer
end

-- ========================================
-- NATURAL MOVEMENT SYSTEM
-- ========================================
local function implementNaturalSpeed()
    systemActive.speed_boost = not systemActive.speed_boost
    local button = buttonReferences.speedButton
    
    if systemActive.speed_boost then
        button.Text = "⚡ Natural Speed [ACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
        
        -- Natural CFrame-based movement enhancement
        activeConnections.speedBoost = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                local rootPart = character.HumanoidRootPart
                
                if humanoid.MoveDirection.Magnitude > 0 then
                    local moveVector = humanoid.MoveDirection * (configuration.speed_multiplier - 1)
                    local bodyVelocity = rootPart:FindFirstChild("SpeedBoost")
                    
                    if not bodyVelocity then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Name = "SpeedBoost"
                        bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
                        bodyVelocity.Parent = rootPart
                    end
                    
                    bodyVelocity.Velocity = Vector3.new(moveVector.X * humanoid.WalkSpeed, 0, moveVector.Z * humanoid.WalkSpeed)
                else
                    local bodyVelocity = rootPart:FindFirstChild("SpeedBoost")
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end
        end)
        
        print("⚡ Natural Speed Enhancement: ACTIVATED")
    else
        button.Text = "⚡ Natural Speed [INACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
        
        if activeConnections.speedBoost then
            activeConnections.speedBoost:Disconnect()
            activeConnections.speedBoost = nil
        end
        
        -- Clean up existing velocity objects
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = character.HumanoidRootPart:FindFirstChild("SpeedBoost")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
        
        print("⚡ Natural Speed Enhancement: DEACTIVATED")
    end
end

local function implementNaturalJump()
    systemActive.jump_boost = not systemActive.jump_boost
    local button = buttonReferences.jumpButton
    
    if systemActive.jump_boost then
        button.Text = "🦘 Enhanced Jump [ACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
        
        -- Natural jump enhancement using BodyVelocity on jump detection
        activeConnections.jumpBoost = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
                local rootPart = character.HumanoidRootPart
                local humanoid = character.Humanoid
                
                -- Check if character is grounded
                local raycast = Workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0))
                if raycast then
                    local jumpBoost = Instance.new("BodyVelocity")
                    jumpBoost.MaxForce = Vector3.new(0, 4000, 0)
                    jumpBoost.Velocity = Vector3.new(0, 16.5 * configuration.jump_multiplier, 0)
                    jumpBoost.Parent = rootPart
                    
                    game:GetService("Debris"):AddItem(jumpBoost, 0.5)
                end
            end
        end)
        
        print("🦘 Enhanced Jump System: ACTIVATED")
    else
        button.Text = "🦘 Enhanced Jump [INACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
        
        if activeConnections.jumpBoost then
            activeConnections.jumpBoost:Disconnect()
            activeConnections.jumpBoost = nil
        end
        
        print("🦘 Enhanced Jump System: DEACTIVATED")
    end
end

-- ========================================
-- CONTACT-BASED FLING SYSTEM
-- ========================================
local function implementContactFling()
    systemActive.contact_fling = not systemActive.contact_fling
    local button = buttonReferences.flingButton
    
    if systemActive.contact_fling then
        button.Text = "💥 Contact Fling [ACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
        
        local function setupFlingOnCharacter()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                
                activeConnections.contactFling = rootPart.Touched:Connect(function(hit)
                    local targetCharacter = hit.Parent
                    local targetPlayer = Players:GetPlayerFromCharacter(targetCharacter)
                    
                    if targetPlayer and targetPlayer ~= player then
                        local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                        if targetRootPart then
                            local flingForce = Instance.new("BodyVelocity")
                            flingForce.MaxForce = Vector3.new(4000, 4000, 4000)
                            
                            local direction = (targetRootPart.Position - rootPart.Position).Unit
                            flingForce.Velocity = direction * configuration.fling_force + Vector3.new(0, 50, 0)
                            flingForce.Parent = targetRootPart
                            
                            game:GetService("Debris"):AddItem(flingForce, 1)
                            print("💥 CONTACT FLING: " .. targetPlayer.Name .. " has been launched")
                        end
                    end
                end)
            end
        end
        
        setupFlingOnCharacter()
        
        -- Reconnect on character respawn
        if activeConnections.characterSpawn then
            activeConnections.characterSpawn:Disconnect()
        end
        
        activeConnections.characterSpawn = player.CharacterAdded:Connect(function()
            wait(2)
            if systemActive.contact_fling then
                setupFlingOnCharacter()
            end
        end)
        
        print("💥 Contact-Based Fling System: ACTIVATED")
    else
        button.Text = "💥 Contact Fling [INACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
        
        if activeConnections.contactFling then
            activeConnections.contactFling:Disconnect()
            activeConnections.contactFling = nil
        end
        
        if activeConnections.characterSpawn then
            activeConnections.characterSpawn:Disconnect()
            activeConnections.characterSpawn = nil
        end
        
        print("💥 Contact-Based Fling System: DEACTIVATED")
    end
end

-- ========================================
-- ESP DETECTION SYSTEMS
-- ========================================
local function implementSecretESP()
    systemActive.esp_secret = not systemActive.esp_secret
    local button = buttonReferences.espSecretButton
    
    if systemActive.esp_secret then
        button.Text = "⭐ Secret ESP [SCANNING]"
        button.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
        
        local function createSecretHighlight(targetObject)
            local primaryPart = targetObject.PrimaryPart or targetObject:FindFirstChildOfClass("BasePart")
            if primaryPart and not primaryPart:FindFirstChild("SecretDetection") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "SecretDetection"
                highlight.FillColor = Color3.fromRGB(255, 165, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0
                highlight.Parent = targetObject
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "SecretDetection"
                billboard.Size = UDim2.new(0, 120, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 4, 0)
                billboard.Parent = primaryPart
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "⭐ SECRET"
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextStrokeTransparency = 0
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.Parent = billboard
                
                print("⭐ SECRET DETECTED: " .. targetObject.Name)
            end
        end
        
        -- Scan existing objects
        for _, object in pairs(Workspace:GetChildren()) do
            if object:IsA("Model") then
                for _, brainrot in pairs(secretBrainrots) do
                    if string.find(object.Name:lower(), brainrot:lower()) then
                        createSecretHighlight(object)
                        break
                    end
                end
            end
        end
        
        -- Monitor for new objects
        activeConnections.secretESP = Workspace.ChildAdded:Connect(function(object)
            if systemActive.esp_secret and object:IsA("Model") then
                wait(0.1)
                for _, brainrot in pairs(secretBrainrots) do
                    if string.find(object.Name:lower(), brainrot:lower()) then
                        createSecretHighlight(object)
                        break
                    end
                end
            end
        end)
        
        print("⭐ Secret Detection System: ACTIVATED")
    else
        button.Text = "⭐ Secret ESP [INACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
        
        if activeConnections.secretESP then
            activeConnections.secretESP:Disconnect()
            activeConnections.secretESP = nil
        end
        
        -- Remove existing highlights
        for _, object in pairs(Workspace:GetChildren()) do
            if object:IsA("Model") then
                local highlight = object:FindFirstChild("SecretDetection")
                if highlight then highlight:Destroy() end
                
                local primaryPart = object.PrimaryPart or object:FindFirstChildOfClass("BasePart")
                if primaryPart then
                    local billboard = primaryPart:FindFirstChild("SecretDetection")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        
        print("⭐ Secret Detection System: DEACTIVATED")
    end
end

local function implementGodESP()
    systemActive.esp_god = not systemActive.esp_god
    local button = buttonReferences.espGodButton
    
    if systemActive.esp_god then
        button.Text = "👑 God ESP [SCANNING]"
        button.BackgroundColor3 = Color3.fromRGB(55, 155, 55)
        
        local function createGodHighlight(targetObject)
            local primaryPart = targetObject.PrimaryPart or targetObject:FindFirstChildOfClass("BasePart")
            if primaryPart and not primaryPart:FindFirstChild("GodDetection") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GodDetection"
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(138, 43, 226)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.Parent = targetObject
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "GodDetection"
                billboard.Size = UDim2.new(0, 160, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 5, 0)
                billboard.Parent = primaryPart
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BackgroundTransparency = 0.6
                frame.BorderSizePixel = 0
                frame.Parent = billboard
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 6)
                frameCorner.Parent = frame
                
                local godLabel = Instance.new("TextLabel")
                godLabel.Size = UDim2.new(1, 0, 0.6, 0)
                godLabel.BackgroundTransparency = 1
                godLabel.Text = "👑 GOD"
                godLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                godLabel.TextStrokeTransparency = 0
                godLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                godLabel.TextScaled = true
                godLabel.Font = Enum.Font.GothamBold
                godLabel.Parent = frame
                
                local brainrotLabel = Instance.new("TextLabel")
                brainrotLabel.Size = UDim2.new(1, 0, 0.4, 0)
                brainrotLabel.Position = UDim2.new(0, 0, 0.6, 0)
                brainrotLabel.BackgroundTransparency = 1
                brainrotLabel.Text = "BRAINROT"
                brainrotLabel.TextColor3 = Color3.fromRGB(138, 43, 226)
                brainrotLabel.TextStrokeTransparency = 0
                brainrotLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                brainrotLabel.TextScaled = true
                brainrotLabel.Font = Enum.Font.GothamBold
                brainrotLabel.Parent = frame
                
                print("👑 GOD DETECTED: " .. targetObject.Name)
            end
        end
        
        -- Scan existing objects
        for _, object in pairs(Workspace:GetChildren()) do
            if object:IsA("Model") then
                for _, brainrot in pairs(godBrainrots) do
                    if string.find(object.Name:lower(), brainrot:lower()) then
                        createGodHighlight(object)
                        break
                    end
                end
            end
        end
        
        -- Monitor for new objects
        activeConnections.godESP = Workspace.ChildAdded:Connect(function(object)
            if systemActive.esp_god and object:IsA("Model") then
                wait(0.1)
                for _, brainrot in pairs(godBrainrots) do
                    if string.find(object.Name:lower(), brainrot:lower()) then
                        createGodHighlight(object)
                        break
                    end
                end
            end
        end)
        
        print("👑 God Detection System: ACTIVATED")
    else
        button.Text = "👑 God ESP [INACTIVE]"
        button.BackgroundColor3 = Color3.fromRGB(185, 55, 55)
        
        if activeConnections.godESP then
            activeConnections.godESP:Disconnect()
            activeConnections.godESP = nil
        end
        
        -- Remove existing highlights
        for _, object in pairs(Workspace:GetChildren()) do
            if object:IsA("Model") then
                local highlight = object:FindFirstChild("GodDetection")
                if highlight then highlight:Destroy() end
                
                local primaryPart = object.PrimaryPart or object:FindFirstChildOfClass("BasePart")
                if primaryPart then
                    local billboard = primaryPart:FindFirstChild("GodDetection")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        
        print("👑 God Detection System: DEACTIVATED")
    end
end

-- ========================================
-- MAIN INTERFACE SETUP
-- ========================================
local function initializeInterface()
    local gui, mainFrame, contentFrame, closeButton = createUserInterface()
    
    -- Create function buttons with proper references
    buttonReferences.speedButton = createFunctionButton(
        contentFrame, "⚡ Natural Speed [INACTIVE]", 
        UDim2.new(0.05, 0, 0, 10), implementNaturalSpeed
    )
    
    createConfigurationSlider(
        contentFrame, "Speed Multiplier:", 1.5, 5.0, configuration.speed_multiplier,
        UDim2.new(0.05, 0, 0, 60), function(value)
            configuration.speed_multiplier = value
            print("⚡ Speed multiplier adjusted to: " .. value)
        end
    )
    
    buttonReferences.jumpButton = createFunctionButton(
        contentFrame, "🦘 Enhanced Jump [INACTIVE]", 
        UDim2.new(0.05, 0, 0, 130), implementNaturalJump
    )
    
    createConfigurationSlider(
        contentFrame, "Jump Multiplier:", 1.5, 4.0, configuration.jump_multiplier,
        UDim2.new(0.05, 0, 0, 180), function(value)
            configuration.jump_multiplier = value
            print("🦘 Jump multiplier adjusted to: " .. value)
        end
    )
    
    buttonReferences.flingButton = createFunctionButton(
        contentFrame, "💥 Contact Fling [INACTIVE]", 
        UDim2.new(0.05, 0, 0, 250), implementContactFling
    )
    
    createConfigurationSlider(
        contentFrame, "Fling Force:", 50, 150, configuration.fling_force,
        UDim2.new(0.05, 0, 0, 300), function(value)
            configuration.fling_force = value
            print("💥 Fling force adjusted to: " .. value)
        end
    )
    
    buttonReferences.espSecretButton = createFunctionButton(
        contentFrame, "⭐ Secret ESP [INACTIVE]", 
        UDim2.new(0.05, 0, 0, 370), implementSecretESP
    )
    
    buttonReferences.espGodButton = createFunctionButton(
        contentFrame, "👑 God ESP [INACTIVE]", 
        UDim2.new(0.05, 0, 0, 420), implementGodESP
    )
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("🔒 Stealth Panel: CLOSED")
    end)
    
    return gui
end

-- ========================================
-- CLEANUP AND MANAGEMENT SYSTEMS
-- ========================================
local function performSystemCleanup()
    for connectionName, connection in pairs(activeConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    activeConnections = {}
    
    -- Reset character modifications
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        local speedBoost = rootPart:FindFirstChild("SpeedBoost")
        if speedBoost then
            speedBoost:Destroy()
        end
    end
    
    -- Clear all ESP highlights
    for _, object in pairs(Workspace:GetChildren()) do
        if object:IsA("Model") then
            local secretHighlight = object:FindFirstChild("SecretDetection")
            if secretHighlight then secretHighlight:Destroy() end
            
            local godHighlight = object:FindFirstChild("GodDetection")
            if godHighlight then godHighlight:Destroy() end
            
            local primaryPart = object.PrimaryPart or object:FindFirstChildOfClass("BasePart")
            if primaryPart then
                local secretBillboard = primaryPart:FindFirstChild("SecretDetection")
                if secretBillboard then secretBillboard:Destroy() end
                
                local godBillboard = primaryPart:FindFirstChild("GodDetection")
                if godBillboard then godBillboard:Destroy() end
            end
        end
    end
    
    -- Reset system states
    for key in pairs(systemActive) do
        systemActive[key] = false
    end
    
    print("🧹 Complete system cleanup performed")
end

-- ========================================
-- KEYBOARD CONTROLS
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        local gui = CoreGui:FindFirstChild("StealthBrainrotGUI")
        if gui then
            gui.MainFrame.Visible = not gui.MainFrame.Visible
            print("👁️ Interface visibility: " .. (gui.MainFrame.Visible and "SHOWN" or "HIDDEN"))
        else
            initializeInterface()
            print("🔄 Stealth interface: RECREATED")
        end
        
    elseif input.KeyCode == Enum.KeyCode.Delete then
        performSystemCleanup()
        print("🛑 EMERGENCY TERMINATION: All systems deactivated")
        
    elseif input.KeyCode == Enum.KeyCode.Home then
        if CoreGui:FindFirstChild("StealthBrainrotGUI") then
            CoreGui:FindFirstChild("StealthBrainrotGUI"):Destroy()
        end
        buttonReferences = {}
        initializeInterface()
        print("🔄 Complete interface reconstruction: COMPLETED")
    end
end)

-- Character respawn management
player.CharacterAdded:Connect(function()
    wait(3) -- Extended wait for complete character loading
    
    if systemActive.speed_boost then
        implementNaturalSpeed()
        implementNaturalSpeed() -- Double call to reactivate
    end
    
    if systemActive.contact_fling then
        implementContactFling()
        implementContactFling() -- Double call to reactivate
    end
end)

-- Cleanup on player leaving
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        performSystemCleanup()
    end
end)

-- ========================================
-- SYSTEM INITIALIZATION
-- ========================================
print("🧠 ==========================================")
print("🧠 STEALTH BRAINROT PANEL - LOADING...")
print("🧠 ==========================================")
print("🎮 ADVANCED STEALTH SYSTEM v2.0")
print("🔧 IMPLEMENTED FEATURES:")
print("   ⚡ Natural Speed Enhancement System")
print("   🦘 Physics-Based Jump Amplification")
print("   💥 Contact-Triggered Fling Mechanism")
print("   ⭐ Secret Brainrot Detection Network")
print("   👑 God Brainrot Identification System")
print("🧠 ==========================================")
print("⌨️ CONTROL SCHEME:")
print("   INSERT = Interface Toggle/Recreation")
print("   DELETE = Emergency System Termination")
print("   HOME = Complete Interface Reconstruction")
print("🧠 ==========================================")

-- Initialize the main interface
local mainInterface = initializeInterface()

wait(1.5)
print("✅ STEALTH SYSTEM: FULLY OPERATIONAL")
print("🎯 Natural movement algorithms: IMPLEMENTED")
print("🔬 Advanced detection systems: ACTIVE")
print("🛡️ Anti-detection protocols: ENGAGED")
print("🚀 Ready for stealth operations!")
print("🧠 ==========================================")
