-- ========================================
-- 🎮 PANEL FUNCIONAL - STEAL A BRAINROT
-- ========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ========================================
-- VARIABLES GLOBALES
-- ========================================
local flingEnabled = false
local antiFpsEnabled = false
local speedBoostEnabled = false
local jumpBoostEnabled = false
local espSecretEnabled = false
local espGodEnabled = false
local autoFloorEnabled = false
local gravityEnabled = false

local currentSpeed = 50
local currentJump = 100
local currentGravity = 196.2
local originalGravity = 196.2

local speedConnection = nil
local floorPart = nil
local rainbowConnection = nil
local espConnections = {}

-- ========================================
-- LISTAS DE BRAINROTS
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
-- CREAR GUI PRINCIPAL
-- ========================================
local function createGUI()
    -- Eliminar GUI anterior
    if CoreGui:FindFirstChild("BrainrotHackGUI") then
        CoreGui:FindFirstChild("BrainrotHackGUI"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotHackGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Header draggable
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    -- Fix header bottom
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 20)
    headerFix.Position = UDim2.new(0, 0, 1, -20)
    headerFix.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 STEAL A BRAINROT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 15)
    closeBtnCorner.Parent = closeBtn
    
    -- Scroll frame para contenido
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -50)
    scrollFrame.Position = UDim2.new(0, 5, 0, 45)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 180)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    scrollFrame.Parent = mainFrame
    
    -- Hacer draggable desde header
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
    
    return screenGui, mainFrame, scrollFrame, closeBtn
end

-- ========================================
-- CREAR BOTÓN
-- ========================================
local function createButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- ========================================
-- CREAR SLIDER
-- ========================================
local function createSlider(parent, labelText, minVal, maxVal, currentVal, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.4, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 10
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -5, 0.4, 0)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = Color3.fromRGB(70, 130, 180)
    valueLabel.TextSize = 10
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.9, 0, 0, 4)
    sliderBar.Position = UDim2.new(0.05, 0, 0.7, 0)
    sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = sliderFill
    
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 12, 0, 12)
    sliderHandle.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderBar
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = sliderHandle
    
    -- Funcionalidad del slider
    local dragging = false
    
    sliderHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local mouseX = mouse.X
            local relativeX = mouseX - sliderBar.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
            
            local newValue = math.floor(minVal + (maxVal - minVal) * percentage)
            valueLabel.Text = tostring(newValue)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percentage, -6, 0.5, -6)
            
            if callback then
                callback(newValue)
                                end
        end
    end)
    
    return sliderFrame, valueLabel
end

-- ========================================
-- FUNCIONES DE HACK
-- ========================================

-- Fling Player
local function toggleFling(button)
    flingEnabled = not flingEnabled
    if flingEnabled then
        button.Text = "🚀 Fling Player [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
    else
        button.Text = "🚀 Fling Player [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
    print("🚀 Fling: " .. (flingEnabled and "ON" or "OFF"))
end

-- Anti FPS
local function toggleAntiFPS(button)
    antiFpsEnabled = not antiFpsEnabled
    if antiFpsEnabled then
        button.Text = "🛡️ Anti FPS [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").FogEnd = 9e9
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    else
        button.Text = "🛡️ Anti FPS [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    end
    print("🛡️ Anti FPS: " .. (antiFpsEnabled and "ON" or "OFF"))
end

-- Speed Boost
local function toggleSpeed(button)
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        button.Text = "⚡ Speed [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        speedConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentSpeed
            end
        end)
    else
        button.Text = "⚡ Speed [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        end
    end
    print("⚡ Speed: " .. (speedBoostEnabled and "ON (" .. currentSpeed .. ")" or "OFF"))
end

-- Jump Boost
local function toggleJump(button)
    jumpBoostEnabled = not jumpBoostEnabled
    if jumpBoostEnabled then
        button.Text = "🦘 Jump [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = currentJump
        end
    else
        button.Text = "🦘 Jump [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50
        end
    end
    print("🦘 Jump: " .. (jumpBoostEnabled and "ON (" .. currentJump .. ")" or "OFF"))
end

-- Auto Floor
local function toggleAutoFloor(button)
    autoFloorEnabled = not autoFloorEnabled
    if autoFloorEnabled then
        button.Text = "🌈 Auto Floor [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        -- Crear suelo
        floorPart = Instance.new("Part")
        floorPart.Name = "RainbowFloor"
        floorPart.Size = Vector3.new(15, 0.5, 15)
        floorPart.Material = Enum.Material.Neon
        floorPart.Anchored = true
        floorPart.CanCollide = true
        floorPart.Parent = Workspace
        
        -- Animación rainbow y seguimiento
        rainbowConnection = RunService.Heartbeat:Connect(function()
            if floorPart and floorPart.Parent then
                -- Color rainbow
                local hue = tick() % 5 / 5
                floorPart.Color = Color3.fromHSV(hue, 1, 1)
                
                -- Seguir jugador
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    floorPart.Position = character.HumanoidRootPart.Position + Vector3.new(0, -8, 0)
                end
            end
        end)
    else
        button.Text = "🌈 Auto Floor [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
    end
    print("🌈 Auto Floor: " .. (autoFloorEnabled and "ON" or "OFF"))
end

-- Gravity Control
local function toggleGravity(button)
    gravityEnabled = not gravityEnabled
    if gravityEnabled then
        button.Text = "🌍 Gravity [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        Workspace.Gravity = currentGravity
    else
        button.Text = "🌍 Gravity [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        Workspace.Gravity = originalGravity
    end
    print("🌍 Gravity: " .. (gravityEnabled and "ON (" .. currentGravity .. ")" or "OFF"))
end

-- ESP Secret
local function toggleESPSecret(button)
    espSecretEnabled = not espSecretEnabled
    if espSecretEnabled then
        button.Text = "⭐ ESP Secret [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        -- Buscar models existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                for _, brainrot in pairs(secretBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                        if primaryPart then
                            -- Highlight
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 100, 100)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                            highlight.FillTransparency = 0.3
                            highlight.OutlineTransparency = 0
                            highlight.Parent = obj
                            
                            -- Billboard
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 150, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.Parent = primaryPart
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = "⭐ SECRET"
                            label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            label.TextStrokeTransparency = 0
                            label.TextScaled = true
                            label.Font = Enum.Font.GothamBold
                            label.Parent = billboard
                            
                            print("⭐ ESP Secret encontrado: " .. obj.Name)
                        end
                        break
                    end
                end
            end
        end
        
        -- Monitor nuevos models
        espConnections.secret = Workspace.ChildAdded:Connect(function(obj)
            if espSecretEnabled and obj:IsA("Model") then
                wait(0.1)
                for _, brainrot in pairs(secretBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                        if primaryPart then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 100, 100)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                            highlight.FillTransparency = 0.3
                            highlight.OutlineTransparency = 0
                            highlight.Parent = obj
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 150, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.Parent = primaryPart
                            
                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.Text = "⭐ SECRET"
                            label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            label.TextStrokeTransparency = 0
                            label.TextScaled = true
                            label.Font = Enum.Font.GothamBold
                            label.Parent = billboard
                            
                            print("⭐ Nuevo ESP Secret: " .. obj.Name)
                        end
                        break
                    end
                end
            end
        end)
    else
        button.Text = "⭐ ESP Secret [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        if espConnections.secret then
            espConnections.secret:Disconnect()
            espConnections.secret = nil
        end
        
        -- Limpiar ESP existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                local highlight = obj:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if primaryPart then
                    local billboard = primaryPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end
    print("⭐ ESP Secret: " .. (espSecretEnabled and "ON" or "OFF"))
end

-- ESP God
local function toggleESPGod(button)
    espGodEnabled = not espGodEnabled
    if espGodEnabled then
        button.Text = "👑 ESP God [ON]"
        button.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        
        -- Buscar models existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                for _, brainrot in pairs(godBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                        if primaryPart then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 215, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
                            highlight.FillTransparency = 0.2
                            highlight.OutlineTransparency = 0
                            highlight.Parent = obj
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 200, 0, 60)
                            billboard.StudsOffset = Vector3.new(0, 6, 0)
                            billboard.Parent = primaryPart
                            
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            frame.BackgroundTransparency = 0.5
                            frame.BorderSizePixel = 0
                            frame.Parent = billboard
                            
                            local frameCorner = Instance.new("UICorner")
                            frameCorner.CornerRadius = UDim.new(0, 8)
                            frameCorner.Parent = frame
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 0.7, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = "👑 GOD"
                            nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                            nameLabel.TextStrokeTransparency = 0
                            nameLabel.TextScaled = true
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.Parent = frame
                            
                            local godLabel = Instance.new("TextLabel")
                            godLabel.Size = UDim2.new(1, 0, 0.3, 0)
                            godLabel.Position = UDim2.new(0, 0, 0.7, 0)
                            godLabel.BackgroundTransparency = 1
                            godLabel.Text = "BRAINROT"
                            godLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
                            godLabel.TextStrokeTransparency = 0
                            godLabel.TextScaled = true
                            godLabel.Font = Enum.Font.GothamBold
                            godLabel.Parent = frame
                            
                            print("👑 ESP God encontrado: " .. obj.Name)
                        end
                        break
                    end
                end
            end
        end
        
        -- Monitor nuevos models
        espConnections.god = Workspace.ChildAdded:Connect(function(obj)
            if espGodEnabled and obj:IsA("Model") then
                wait(0.1)
                for _, brainrot in pairs(godBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                        if primaryPart then
                                                        local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 215, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
                            highlight.FillTransparency = 0.2
                            highlight.OutlineTransparency = 0
                            highlight.Parent = obj
                            
                            local billboard = Instance.new("BillboardGui")
                            billboard.Size = UDim2.new(0, 200, 0, 60)
                            billboard.StudsOffset = Vector3.new(0, 6, 0)
                            billboard.Parent = primaryPart
                            
                            local frame = Instance.new("Frame")
                            frame.Size = UDim2.new(1, 0, 1, 0)
                            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                            frame.BackgroundTransparency = 0.5
                            frame.BorderSizePixel = 0
                            frame.Parent = billboard
                            
                            local frameCorner = Instance.new("UICorner")
                            frameCorner.CornerRadius = UDim.new(0, 8)
                            frameCorner.Parent = frame
                            
                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(1, 0, 0.7, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = "👑 GOD"
                            nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
                            nameLabel.TextStrokeTransparency = 0
                            nameLabel.TextScaled = true
                            nameLabel.Font = Enum.Font.GothamBold
                            nameLabel.Parent = frame
                            
                            local godLabel = Instance.new("TextLabel")
                            godLabel.Size = UDim2.new(1, 0, 0.3, 0)
                            godLabel.Position = UDim2.new(0, 0, 0.7, 0)
                            godLabel.BackgroundTransparency = 1
                            godLabel.Text = "BRAINROT"
                            godLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
                            godLabel.TextStrokeTransparency = 0
                            godLabel.TextScaled = true
                            godLabel.Font = Enum.Font.GothamBold
                            godLabel.Parent = frame
                            
                            print("👑 Nuevo ESP God: " .. obj.Name)
                        end
                        break
                    end
                end
            end
        end)
    else
        button.Text = "👑 ESP God [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        
        if espConnections.god then
            espConnections.god:Disconnect()
            espConnections.god = nil
        end
        
        -- Limpiar ESP existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                local highlight = obj:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if primaryPart then
                    local billboard = primaryPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
    end
    print("👑 ESP God: " .. (espGodEnabled and "ON" or "OFF"))
end

-- ========================================
-- CONFIGURAR GUI PRINCIPAL
-- ========================================
local function setupGUI()
    local gui, mainFrame, scrollFrame, closeBtn = createGUI()
    
    -- Crear botones
    local flingBtn = createButton(scrollFrame, "🚀 Fling Player [OFF]", UDim2.new(0.05, 0, 0, 10), function() toggleFling(flingBtn) end)
    local antiFpsBtn = createButton(scrollFrame, "🛡️ Anti FPS [OFF]", UDim2.new(0.05, 0, 0, 50), function() toggleAntiFPS(antiFpsBtn) end)
    local speedBtn = createButton(scrollFrame, "⚡ Speed [OFF]", UDim2.new(0.05, 0, 0, 90), function() toggleSpeed(speedBtn) end)
    local jumpBtn = createButton(scrollFrame, "🦘 Jump [OFF]", UDim2.new(0.05, 0, 0, 170), function() toggleJump(jumpBtn) end)
    local floorBtn = createButton(scrollFrame, "🌈 Auto Floor [OFF]", UDim2.new(0.05, 0, 0, 250), function() toggleAutoFloor(floorBtn) end)
    local gravityBtn = createButton(scrollFrame, "🌍 Gravity [OFF]", UDim2.new(0.05, 0, 0, 330), function() toggleGravity(gravityBtn) end)
    local espSecretBtn = createButton(scrollFrame, "⭐ ESP Secret [OFF]", UDim2.new(0.05, 0, 0, 410), function() toggleESPSecret(espSecretBtn) end)
    local espGodBtn = createButton(scrollFrame, "👑 ESP God [OFF]", UDim2.new(0.05, 0, 0, 450), function() toggleESPGod(espGodBtn) end)
    
    -- Crear sliders
    local speedSlider = createSlider(scrollFrame, "Speed Value:", 16, 200, currentSpeed, UDim2.new(0.05, 0, 0, 130), function(value)
        currentSpeed = value
    end)
    
    local jumpSlider = createSlider(scrollFrame, "Jump Power:", 50, 300, currentJump, UDim2.new(0.05, 0, 0, 210), function(value)
        currentJump = value
    end)
    
    local gravitySlider = createSlider(scrollFrame, "Gravity:", -200, 400, currentGravity, UDim2.new(0.05, 0, 0, 370), function(value)
        currentGravity = value
        if gravityEnabled then
            Workspace.Gravity = currentGravity
        end
    end)
    
    -- Evento cerrar
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("👋 Panel cerrado")
    end)
    
    return gui
end

-- ========================================
-- EVENTOS GLOBALES
-- ========================================

-- Fling functionality
mouse.Button1Down:Connect(function()
    if not flingEnabled then return end
    
    local target = mouse.Target
    if not target then return end
    
    local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
    if not targetPlayer or targetPlayer == player then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Fling effect
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(
        math.random(-100, 100),
        math.random(80, 150),
        math.random(-100, 100)
    )
    bodyVelocity.Parent = humanoidRootPart
    
    game:GetService("Debris"):AddItem(bodyVelocity, 2)
    print("💥 FLINGED: " .. targetPlayer.Name)
end)

-- Mantener configuraciones al respawn
player.CharacterAdded:Connect(function()
    wait(1)
    
    if speedBoostEnabled then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = currentSpeed
            end
        end)
        print("⚡ Speed restaurado: " .. currentSpeed)
    end
    
    if jumpBoostEnabled then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = currentJump
        end
        print("🦘 Jump restaurado: " .. currentJump)
    end
end)

-- ========================================
-- KEYBINDS
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        -- Toggle GUI
        local gui = CoreGui:FindFirstChild("BrainrotHackGUI")
        if gui then
            gui.MainFrame.Visible = not gui.MainFrame.Visible
            print("👀 Panel " .. (gui.MainFrame.Visible and "mostrado" or "ocultado"))
        end
        
    elseif input.KeyCode == Enum.KeyCode.Delete then
        -- Emergency stop
        flingEnabled = false
        speedBoostEnabled = false
        jumpBoostEnabled = false
        autoFloorEnabled = false
        gravityEnabled = false
        espSecretEnabled = false
        espGodEnabled = false
        
        -- Desconectar todo
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
        
        -- Resetear jugador
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
            character.Humanoid.JumpPower = 50
        end
        
        -- Resetear gravedad
        Workspace.Gravity = originalGravity
        
        -- Limpiar ESP
        for _, connection in pairs(espConnections) do
            if connection then connection:Disconnect() end
        end
        espConnections = {}
        
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                local highlight = obj:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                if primaryPart then
                    local billboard = primaryPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        
        print("🛑 EMERGENCY STOP - Todo desactivado")
        
    elseif input.KeyCode == Enum.KeyCode.Home then
        -- Recrear panel
        if not CoreGui:FindFirstChild("BrainrotHackGUI") then
            setupGUI()
            print("🔄 Panel recreado")
        end
    end
end)

-- ========================================
-- INICIALIZAR
-- ========================================
print("🧠 ========================================")
print("🧠 CARGANDO HACK PANEL FUNCIONAL...")
print("🧠 ========================================")
print("🎮 STEAL A BRAINROT HACK PANEL v4.0")
print("🔧 Funciones:")
print("   🚀 Fling Player - Clic en jugadores")
print("   🛡️ Anti FPS Killer")
print("   ⚡ Speed Boost - Slider funcional")
print("   🦘 Jump Boost - Slider funcional")
print("   🌈 Auto Floor Rainbow - Te sigue")
print("   🌍 Gravity Control - -200 a +400")
print("   ⭐ ESP Secret - " .. #secretBrainrots .. " brainrots")
print("   👑 ESP God - " .. #godBrainrots .. " brainrots")
print("🧠 ========================================")
print("⌨️ CONTROLES:")
print("   INSERT = Mostrar/Ocultar")
print("   DELETE = Emergency Stop")
print("   HOME = Recrear Panel")
print("🧠 ========================================")

-- Crear GUI
local mainGUI = setupGUI()

wait(1)
print("✅ PANEL CARGADO CORRECTAMENTE!")
print("🎯 Todas las funciones están funcionando")
print("🎨 Panel compacto y moderno")
print("🖱️ Draggable desde el título")
print("🔥 Listo para usar!")
print("🧠 ========================================")
