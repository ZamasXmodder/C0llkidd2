-- ========================================
-- 🎮 PANEL MODERNO - STEAL A BRAINROT
-- ========================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
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

local espConnections = {}
local floorPart = nil
local speedConnection = nil

-- ========================================
-- LISTAS DE BRAINROTS (MODELS)
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
-- FUNCIÓN PARA CREAR LA GUI MODERNA
-- ========================================
local function createModernGUI()
    -- Eliminar GUI anterior
    if CoreGui:FindFirstChild("ModernBrainrotGUI") then
        CoreGui:FindFirstChild("ModernBrainrotGUI"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ModernBrainrotGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    -- Frame principal más pequeño y moderno
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 320, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas modernas
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Borde moderno con gradiente
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(120, 120, 255)
    stroke.Thickness = 1.5
    stroke.Parent = mainFrame
    
    -- Sombra moderna
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Header moderno (draggable)
    local headerFrame = Instance.new("Frame")
    headerFrame.Name = "Header"
    headerFrame.Size = UDim2.new(1, 0, 0, 45)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    headerFrame.BorderSizePixel = 0
    headerFrame.Active = true
    headerFrame.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame
    
    -- Fix para header
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 22)
    headerFix.Position = UDim2.new(0, 0, 1, -22)
    headerFix.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = headerFrame
    
    -- Título moderno
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🧠 STEAL A BRAINROT"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    -- Botón cerrar moderno
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -38, 0, 7)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 16
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = headerFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Contenido scrolleable
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 255)
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    contentFrame.Parent = mainFrame
    
    -- Hacer draggable solo desde el header
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
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
-- FUNCIÓN PARA CREAR BOTONES MODERNOS
-- ========================================
local function createModernButton(parent, text, position, callback, isToggle)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = isToggle and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(60, 60, 80)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Efecto moderno
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = button.BackgroundColor3:lerp(Color3.fromRGB(255, 255, 255), 0.1)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        local targetColor = isToggle and (button.Text:find("%[ON%]") and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(255, 60, 60)) or Color3.fromRGB(60, 60, 80)
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = targetColor
        }):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- ========================================
-- FUNCIÓN PARA CREAR SLIDERS MODERNOS
-- ========================================
local function createModernSlider(parent, text, minVal, maxVal, currentVal, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 8)
    sliderCorner.Parent = sliderFrame
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    -- Value
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -8, 0.5, 0)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = Color3.fromRGB(120, 120, 255)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    -- Slider track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.9, 0, 0, 4)
    track.Position = UDim2.new(0.05, 0, 0.7, 0)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = track
    
    -- Slider fill
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    
    -- Handle
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 12, 0, 12)
    handle.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -6, 0.5, -6)
    handle.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
    handle.BorderSizePixel = 0
    handle.Parent = track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 6)
    handleCorner.Parent = handle
    
    -- Slider functionality
    local dragging = false
    
    handle.InputBegan:Connect(function(input)
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
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - track.AbsolutePosition.X
            local percentage = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
            
            local newValue = math.floor(minVal + (maxVal - minVal) * percentage)
            valueLabel.Text = tostring(newValue)
            
            fill.Size = UDim2.new(percentage, 0, 1, 0)
            handle.Position = UDim2.new(percentage, -6, 0.5, -6)
            
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

-- Fling Player (arreglado)
local function toggleFling(button)
    flingEnabled = not flingEnabled
    if flingEnabled then
        button.Text = "🚀 Fling Player [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        print("🚀 FLING ACTIVADO")
    else
        button.Text = "🚀 Fling Player [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        print("🚀 FLING DESACTIVADO")
    end
end

-- Anti FPS Killer
local function toggleAntiFPS(button)
    antiFpsEnabled = not antiFpsEnabled
    if antiFpsEnabled then
        button.Text = "🛡️ Anti FPS [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
        print("🛡️ ANTI FPS ACTIVADO")
    else
        button.Text = "🛡️ Anti FPS [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        print("🛡️ ANTI FPS DESACTIVADO")
    end
end

-- Speed Boost (corregido)
local function toggleSpeed(button)
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        button.Text = "⚡ Speed [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Corregir speed boost
        speedConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentSpeed
                end
            end
        end)
        print("⚡ SPEED BOOST ACTIVADO: " .. currentSpeed)
    else
        button.Text = "⚡ Speed [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        print("⚡ SPEED BOOST DESACTIVADO")
    end
end

-- Jump Boost
local function toggleJump(button)
    jumpBoostEnabled = not jumpBoostEnabled
    if jumpBoostEnabled then
        button.Text = "🦘 Jump [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = currentJump
            end
        end
        print("🦘 JUMP BOOST ACTIVADO: " .. currentJump)
    else
        button.Text = "🦘 Jump [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
        end
        print("🦘 JUMP BOOST DESACTIVADO")
    end
end

-- Auto Floor Rainbow
local function toggleAutoFloor(button)
    autoFloorEnabled = not autoFloorEnabled
    if autoFloorEnabled then
        button.Text = "🌈 Auto Floor [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Crear suelo rainbow
        floorPart = Instance.new("Part")
        floorPart.Name = "RainbowFloor"
        floorPart.Size = Vector3.new(20, 0.5, 20)
        floorPart.Material = Enum.Material.Neon
        floorPart.Anchored = true
        floorPart.CanCollide = true
        floorPart.Parent = Workspace
        
        -- Animación rainbow
        spawn(function()
            local hue = 0
            while autoFloorEnabled and floorPart.Parent do
                hue = hue + 0.01
                if hue > 1 then hue = 0 end
                floorPart.Color = Color3.fromHSV(hue, 1, 1)
                
                -- Seguir al jugador
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        floorPart.Position = humanoidRootPart.Position - Vector3.new(0, 8, 0)
                    end
                end
                
                wait(0.1)
            end
        end)
        
        print("🌈 AUTO FLOOR RAINBOW ACTIVADO")
    else
        button.Text = "🌈 Auto Floor [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
        print("🌈 AUTO FLOOR DESACTIVADO")
    end
end

-- Gravity Control
local function toggleGravity(button)
    gravityEnabled = not gravityEnabled
    if gravityEnabled then
        button.Text = "🌍 Gravity [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        Workspace.Gravity = currentGravity
        print("🌍 GRAVEDAD CONTROLADA: " .. currentGravity)
    else
        button.Text = "🌍 Gravity [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        Workspace.Gravity = originalGravity
        print("🌍 GRAVEDAD NORMAL")
    end
end

-- ESP Secret (corregido para models)
local function createSecretESP(model)
    if not model or not model:FindFirstChildOfClass("BasePart") then return end
    
    local primaryPart = model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 100, 100)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Parent = primaryPart
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "⭐ " .. model.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    print("⭐ ESP SECRET: " .. model.Name)
end

local function createGodESP(model)
    if not model or not model:FindFirstChildOfClass("BasePart") then return end
    
    local primaryPart = model.PrimaryPart or model:FindFirstChildOfClass("BasePart")
    
    -- Highlight GOD
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    
    -- Animación de color
    spawn(function()
        local hue = 0
        while highlight.Parent do
            hue = hue + 0.02
            if hue > 1 then hue = 0 end
            highlight.FillColor = Color3.fromHSV(hue, 1, 1)
            wait(0.1)
        end
    end)
    
    -- Billboard GOD
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
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "👑 " .. model.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    
    local godLabel = Instance.new("TextLabel")
    godLabel.Size = UDim2.new(1, 0, 0.4, 0)
    godLabel.Position = UDim2.new(0, 0, 0.6, 0)
    godLabel.BackgroundTransparency = 1
    godLabel.Text = "⚡ GOD BRAINROT ⚡"
    godLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    godLabel.TextStrokeTransparency = 0
    godLabel.TextScaled = true
    godLabel.Font = Enum.Font.GothamBold
    godLabel.Parent = frame
    
    print("👑 ESP GOD: " .. model.Name)
end

local function toggleESPSecret(button)
    espSecretEnabled = not espSecretEnabled
    if espSecretEnabled then
        button.Text = "⭐ ESP Secret [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Buscar models existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                for _, brainrot in pairs(secretBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        createSecretESP(obj)
                        break
                    end
                end
            end
        end
        
        -- Monitor nuevos models
        espConnections.secret = Workspace.ChildAdded:Connect(function(obj)
            if espSecretEnabled and obj:IsA("Model") then
                for _, brainrot in pairs(secretBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        wait(0.1)
                        createSecretESP(obj)
                        break
                    end
                end
            end
        end)
        
        print("⭐ ESP SECRET ACTIVADO")
    else
        button.Text = "⭐ ESP Secret [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if espConnections.secret then
            espConnections.secret:Disconnect()
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
        
        print("⭐ ESP SECRET DESACTIVADO")
    end
end

local function toggleESPGod(button)
    espGodEnabled = not espGodEnabled
    if espGodEnabled then
        button.Text = "👑 ESP God [ON]"
        button.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        -- Buscar models existentes
        for _, obj in pairs(Workspace:GetChildren()) do
            if obj:IsA("Model") then
                for _, brainrot in pairs(godBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        createGodESP(obj)
                        break
                    end
                end
            end
        end
        
        -- Monitor nuevos models
        espConnections.god = Workspace.ChildAdded:Connect(function(obj)
            if espGodEnabled and obj:IsA("Model") then
                for _, brainrot in pairs(godBrainrots) do
                    if obj.Name:lower():find(brainrot:lower()) then
                        wait(0.1)
                        createGodESP(obj)
                        break
                    end
                end
            end
        end)
        
        print("👑 ESP GOD ACTIVADO")
    else
        button.Text = "👑 ESP God [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if espConnections.god then
            espConnections.god:Disconnect()
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
        
        print("👑 ESP GOD DESACTIVADO")
    end
end

-- ========================================
-- CONFIGURAR GUI PRINCIPAL
-- ========================================
local function setupMainGUI()
    local gui, mainFrame, contentFrame, closeButton = createModernGUI()
    
    -- Crear botones
    local flingButton = createModernButton(contentFrame, "🚀 Fling Player [OFF]", UDim2.new(0.05, 0, 0, 10), function() toggleFling(flingButton) end, true)
    local antiFpsButton = createModernButton(contentFrame, "🛡️ Anti FPS [OFF]", UDim2.new(0.05, 0, 0, 55), function() toggleAntiFPS(antiFpsButton) end, true)
    local speedButton = createModernButton(contentFrame, "⚡ Speed [OFF]", UDim2.new(0.05, 0, 0, 100), function() toggleSpeed(speedButton) end, true)
    local jumpButton = createModernButton(contentFrame, "🦘 Jump [OFF]", UDim2.new(0.05, 0, 0, 205), function() toggleJump(jumpButton) end, true)
    local floorButton = createModernButton(contentFrame, "🌈 Auto Floor [OFF]", UDim2.new(0.05, 0, 0, 310), function() toggleAutoFloor(floorButton) end, true)
    local gravityButton = createModernButton(contentFrame, "🌍 Gravity [OFF]", UDim2.new(0.05, 0, 0, 415), function() toggleGravity(gravityButton) end, true)
    local espSecretButton = createModernButton(contentFrame, "⭐ ESP Secret [OFF]", UDim2.new(0.05, 0, 0, 520), function() toggleESPSecret(espSecretButton) end, true)
    local espGodButton = createModernButton(contentFrame, "👑 ESP God [OFF]", UDim2.new(0.05, 0, 0, 565), function() toggleESPGod(espGodButton) end, true)
    
    -- Crear sliders
    local speedSlider = createModernSlider(contentFrame, "Speed:", 16, 200, currentSpeed, UDim2.new(0.05, 0, 0, 145), function(value)
        currentSpeed = value
        if speedBoostEnabled and speedConnection then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentSpeed
                end
            end
        end
    end)
    
    local jumpSlider = createModernSlider(contentFrame, "Jump:", 50, 300, currentJump, UDim2.new(0.05, 0, 0, 250), function(value)
        currentJump = value
        if jumpBoostEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = currentJump
                end
            end
        end
    end)
    
    local gravitySlider = createModernSlider(contentFrame, "Gravity:", -200, 400, currentGravity, UDim2.new(0.05, 0, 0, 460), function(value)
        currentGravity = value
        if gravityEnabled then
            Workspace.Gravity = currentGravity
        end
    end)
    
    -- Evento cerrar
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("👋 Panel cerrado!")
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
    
    -- Fling súper XD
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(
        math.random(-200, 200),
        math.random(100, 300),
        math.random(-200, 200)
    )
    bodyVelocity.Parent = humanoidRootPart
    
    -- Efecto visual
    local explosion = Instance.new("Explosion")
    explosion.Position = humanoidRootPart.Position
    explosion.BlastRadius = 0
    explosion.BlastPressure = 0
    explosion.Parent = Workspace
    
    game:GetService("Debris"):AddItem(bodyVelocity, 2)
    print("💥 FLINGEADO: " .. targetPlayer.Name .. " ¡SÚPER XD!")
end)

-- Mantener configuraciones al respawn
player.CharacterAdded:Connect(function()
    wait(1)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if speedBoostEnabled then
        -- Reconectar speed boost
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = currentSpeed
                end
            end
        end)
        print("⚡ Speed restaurado: " .. currentSpeed)
    end
    
    if jumpBoostEnabled then
        humanoid.JumpPower = currentJump
        
        -- Sistema de salto mejorado
        humanoid.Jumping:Connect(function()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                spawn(function()
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyVelocity.Velocity = Vector3.new(0, currentJump * 1.5, 0)
                    bodyVelocity.Parent = rootPart
                    
                    wait(0.3)
                    if bodyVelocity.Parent then
                        bodyVelocity.Velocity = Vector3.new(0, currentJump * 0.8, 0)
                    end
                    
                    wait(0.2)
                    if bodyVelocity.Parent then
                        bodyVelocity:Destroy()
                    end
                end)
            end
        end)
        
        print("🦘 Jump restaurado: " .. currentJump)
    end
end)

-- ========================================
-- KEYBINDS MODERNOS
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        -- Toggle GUI
        local gui = CoreGui:FindFirstChild("ModernBrainrotGUI")
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
        
        -- Resetear todo
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
        
        Workspace.Gravity = originalGravity
        
        if floorPart then
            floorPart:Destroy()
            floorPart = nil
        end
        
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
        
        print("🛑 EMERGENCY STOP - Todo desactivado!")
        
    elseif input.KeyCode == Enum.KeyCode.Home then
        -- Recrear GUI si no existe
        if not CoreGui:FindFirstChild("ModernBrainrotGUI") then
            setupMainGUI()
            print("🔄 Panel recreado!")
        end
    end
end)

-- ========================================
-- INICIALIZAR PANEL MODERNO
-- ========================================
print("🧠 ========================================")
print("🧠 CARGANDO PANEL MODERNO...")
print("🧠 ========================================")
print("🎮 STEAL A BRAINROT HACK PANEL v3.0")
print("🔧 Funciones disponibles:")
print("   🚀 Fling Player")
print("   🛡️ Anti FPS Killer")
print("   ⚡ Speed Boost (mejorado)")
print("   🦘 Jump Boost")
print("   🌈 Auto Floor Rainbow")
print("   🌍 Gravity Control (-200 a +400)")
print("   ⭐ ESP Secret (" .. #secretBrainrots .. " brainrots)")
print("   👑 ESP God (" .. #godBrainrots .. " brainrots)")
print("🧠 ========================================")
print("⌨️ CONTROLES:")
print("   INSERT = Mostrar/Ocultar Panel")
print("   DELETE = Emergency Stop")
print("   HOME = Recrear Panel")
print("🧠 ========================================")

-- Crear GUI principal
local mainGUI = setupMainGUI()

print("✅ PANEL MODERNO CARGADO!")
print("🎯 Panel más pequeño y moderno")
print("🎨 Movimiento solo desde título")
print("🌈 Auto Floor Rainbow incluido")
print("🌍 Control de gravedad añadido")
print("⭐ ESP corregido para models de brainrots")
print("🧠 ========================================")
