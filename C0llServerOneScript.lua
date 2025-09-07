-- ========================================
-- 🎮 PANEL DE HACKS - LOS COMBINASIONAS
-- ========================================
-- Creado para Roblox - GUI Completa

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ========================================
-- VARIABLES GLOBALES
-- ========================================
local flingEnabled = false
local antiFpsEnabled = false
local speedBoostEnabled = false
local jumpBoostEnabled = false
local espCombiEnabled = false
local espGodEnabled = false

local currentSpeed = 50
local currentJump = 100

local espConnections = {}
local espGodConnections = {}

-- ========================================
-- LISTAS DE BRAINROTS
-- ========================================
local combinasionas = {
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
-- FUNCIÓN PARA CREAR LA GUI PRINCIPAL
-- ========================================
local function createMainGUI()
    -- Eliminar GUI anterior si existe
    if CoreGui:FindFirstChild("CombinasionasHackGUI") then
        CoreGui:FindFirstChild("CombinasionasHackGUI"):Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CombinasionasHackGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Borde brillante
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(78, 205, 196)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Header con título
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 70)
    headerFrame.Position = UDim2.new(0, 0, 0, 0)
    headerFrame.BackgroundColor3 = Color3.fromRGB(78, 205, 196)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = headerFrame
    
    -- Fix para que solo la parte superior tenga esquinas redondeadas
    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 35)
    headerFix.Position = UDim2.new(0, 0, 1, -35)
    headerFix.BackgroundColor3 = Color3.fromRGB(78, 205, 196)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = headerFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎮 LOS COMBINASIONAS"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = headerFrame
    
    -- Subtítulo
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -100, 0.4, 0)
    subLabel.Position = UDim2.new(0, 10, 0.6, 0)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "Hack Panel v2.0"
    subLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    subLabel.TextScaled = true
    subLabel.Font = Enum.Font.Gotham
    subLabel.Parent = headerFrame
    
    -- Botón cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = headerFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 20)
    closeCorner.Parent = closeButton
    
    -- ScrollingFrame para el contenido
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -90)
    scrollFrame.Position = UDim2.new(0, 10, 0, 80)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(78, 205, 196)
    scrollFrame.Parent = mainFrame
    
    return screenGui, mainFrame, scrollFrame, closeButton
end

-- ========================================
-- FUNCIÓN PARA CREAR BOTONES
-- ========================================
local function createButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0.9, 0, 0, 50)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(200, 200, 200)
    stroke.Thickness = 1
    stroke.Transparency = 0.7
    stroke.Parent = button
    
    -- Efecto hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = (size or UDim2.new(0.9, 0, 0, 50)) + UDim2.new(0, 5, 0, 2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            Size = size or UDim2.new(0.9, 0, 0, 50)
        }):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- ========================================
-- FUNCIÓN PARA CREAR SLIDERS
-- ========================================
local function createSlider(parent, text, minVal, maxVal, currentVal, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 70)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = sliderFrame
    
    -- Etiqueta
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0.5, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    -- Valor actual
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0.5, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(currentVal)
    valueLabel.TextColor3 = Color3.fromRGB(78, 205, 196)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    -- Slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(0.9, 0, 0, 6)
    sliderTrack.Position = UDim2.new(0.05, 0, 0.7, 0)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = sliderTrack
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(78, 205, 196)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill
    
    -- Slider handle
    local sliderHandle = Instance.new("Frame")
    sliderHandle.Size = UDim2.new(0, 20, 0, 20)
    sliderHandle.Position = UDim2.new((currentVal - minVal) / (maxVal - minVal), -10, 0.5, -10)
    sliderHandle.BackgroundColor3 = Color3.fromRGB(78, 205, 196)
    sliderHandle.BorderSizePixel = 0
    sliderHandle.Parent = sliderTrack
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 10)
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
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Players.LocalPlayer:GetMouse()
            local relativeX = mouse.X - sliderTrack.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderTrack.AbsoluteSize.X, 0, 1)
            
            local newValue = math.floor(minVal + (maxVal - minVal) * percentage)
            valueLabel.Text = tostring(newValue)
            
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderHandle.Position = UDim2.new(percentage, -10, 0.5, -10)
            
            if callback then
                callback(newValue)
            end
        end
    end)
    
    return sliderFrame, valueLabel
end

-- ========================================
-- FUNCIONES DE HACKS
-- ========================================

-- Fling Player
local function toggleFling(button)
    flingEnabled = not flingEnabled
    if flingEnabled then
        button.Text = "🚀 Fling Player [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        print("🚀 FLING ACTIVADO - Haz clic en jugadores para flingearlos!")
    else
        button.Text = "🚀 Fling Player [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        print("🚀 FLING DESACTIVADO")
    end
end

-- Anti FPS Killer
local function toggleAntiFPS(button)
    antiFpsEnabled = not antiFpsEnabled
    if antiFpsEnabled then
        button.Text = "🛡️ Anti FPS Killer [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        
        -- Aplicar optimizaciones
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Fire") or obj:IsA("SpotLight") or obj:IsA("Smoke") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0.9
            end
        end
        
        print("🛡️ ANTI FPS KILLER ACTIVADO")
    else
        button.Text = "🛡️ Anti FPS Killer [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        print("🛡️ ANTI FPS KILLER DESACTIVADO")
    end
end

-- Speed Boost
local function toggleSpeed(button)
    speedBoostEnabled = not speedBoostEnabled
    if speedBoostEnabled then
        button.Text = "⚡ Speed Boost [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
        print("⚡ SPEED BOOST ACTIVADO: " .. currentSpeed)
    else
        button.Text = "⚡ Speed Boost [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        
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
        button.Text = "🦘 Jump Boost [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = currentJump
                
                -- Sistema de salto mejorado
                humanoid.Jumping:Connect(function()
                    local rootPart = character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Velocity = Vector3.new(0, currentJump * 1.2, 0)
                        bodyVelocity.Parent = rootPart
                        
                        wait(0.3)
                        if bodyVelocity and bodyVelocity.Parent then
                            bodyVelocity.Velocity = Vector3.new(0, currentJump * 0.6, 0)
                        end
                        
                        wait(0.2)
                        if bodyVelocity and bodyVelocity.Parent then
                            bodyVelocity:Destroy()
                        end
                    end
                end)
            end
        end
        print("🦘 JUMP BOOST ACTIVADO: " .. currentJump)
    else
        button.Text = "🦘 Jump Boost [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        
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

-- ESP Combinasionas
local function createESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Crear highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 100, 100)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    -- Crear BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = humanoidRootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "⭐ " .. player.Name .. " ⭐"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    print("👁️ ESP COMBINASIONAS activado para: " .. player.Name)
end

local function createGodESP(player)
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Crear highlight GOD
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 0, 255)
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    -- Animación de color
    spawn(function()
        while highlight and highlight.Parent do
            for i = 0, 1, 0.1 do
                if highlight and highlight.Parent then
                    highlight.FillColor = Color3.fromRGB(255, 215 * (1-i), 255 * i)
                    wait(0.1)
                end
            end
            for i = 0, 1, 0.1 do
                if highlight and highlight.Parent then
                    highlight.FillColor = Color3.fromRGB(255, 215 * i, 255 * (1-i))
                    wait(0.1)
                end
            end
        end
    end)
    
    -- Crear BillboardGui GOD
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 250, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Parent = humanoidRootPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    frame.Parent = billboard
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "👑 " .. player.Name .. " 👑"
    nameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    
    local godLabel = Instance.new("TextLabel")
    godLabel.Size = UDim2.new(1, 0, 0.4, 0)
    godLabel.Position = UDim2.new(0, 0, 0.6, 0)
    godLabel.BackgroundTransparency = 1
    godLabel.Text = "⚡ GOD MODE ⚡"
    godLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    godLabel.TextStrokeTransparency = 0
    godLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    godLabel.TextScaled = true
    godLabel.Font = Enum.Font.GothamBold
    godLabel.Parent = frame
    
    print("🌟 ESP GOD activado para: " .. player.Name)
end

local function toggleESPCombi(button)
    espCombiEnabled = not espCombiEnabled
    if espCombiEnabled then
        button.Text = "👁️ ESP Combinasionas [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        
        -- Verificar todos los jugadores
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                local playerName = targetPlayer.Name:lower()
                
                for _, brainrot in pairs(combinasionas) do
                    if playerName:find(brainrot:lower()) or targetPlayer.DisplayName:lower():find(brainrot:lower()) then
                        espConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function()
                            wait(1)
                            createESP(targetPlayer)
                        end)
                        
                        if targetPlayer.Character then
                            createESP(targetPlayer)
                        end
                        break
                    end
                end
            end
        end
        
        print("👁️ ESP COMBINASIONAS ACTIVADO")
    else
        button.Text = "👁️ ESP Combinasionas [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        
        -- Limpiar ESP
        for targetPlayer, connection in pairs(espConnections) do
            if connection then
                connection:Disconnect()
            end
            if targetPlayer.Character then
                local highlight = targetPlayer.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local billboard = humanoidRootPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        espConnections = {}
        
        print("👁️ ESP COMBINASIONAS DESACTIVADO")
    end
end

local function toggleESPGod(button)
    espGodEnabled = not espGodEnabled
    if espGodEnabled then
        button.Text = "🌟 ESP God Mode [ON]"
        button.BackgroundColor3 = Color3.fromRGB(46, 213, 115)
        
        -- Verificar todos los jugadores
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                local playerName = targetPlayer.Name:lower()
                
                for _, brainrot in pairs(godBrainrots) do
                    if playerName:find(brainrot:lower()) or targetPlayer.DisplayName:lower():find(brainrot:lower()) then
                        espGodConnections[targetPlayer] = targetPlayer.CharacterAdded:Connect(function()
                            wait(1)
                            createGodESP(targetPlayer)
                        end)
                        
                        if targetPlayer.Character then
                            createGodESP(targetPlayer)
                        end
                        break
                    end
                end
            end
        end
        
        print("🌟 ESP GOD MODE ACTIVADO")
    else
        button.Text = "🌟 ESP God Mode [OFF]"
        button.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
        
        -- Limpiar ESP God
        for targetPlayer, connection in pairs(espGodConnections) do
            if connection then
                connection:Disconnect()
            end
            if targetPlayer.Character then
                local highlight = targetPlayer.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local billboard = humanoidRootPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        espGodConnections = {}
        
        print("🌟 ESP GOD MODE DESACTIVADO")
    end
end

-- ========================================
-- FUNCIÓN PRINCIPAL PARA CREAR LA GUI
-- ========================================
local function setupGUI()
    local gui, mainFrame, scrollFrame, closeButton = createMainGUI()
    
    -- Configurar el tamaño del scroll
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    
    -- Crear botones principales
    local flingButton = createButton(scrollFrame, "🚀 Fling Player [OFF]", UDim2.new(0.05, 0, 0, 10), UDim2.new(0.9, 0, 0, 50))
    local antiFpsButton = createButton(scrollFrame, "🛡️ Anti FPS Killer [OFF]", UDim2.new(0.05, 0, 0, 70), UDim2.new(0.9, 0, 0, 50))
    local speedButton = createButton(scrollFrame, "⚡ Speed Boost [OFF]", UDim2.new(0.05, 0, 0, 130), UDim2.new(0.9, 0, 0, 50))
    local jumpButton = createButton(scrollFrame, "🦘 Jump Boost [OFF]", UDim2.new(0.05, 0, 0, 270), UDim2.new(0.9, 0, 0, 50))
    local espCombiButton = createButton(scrollFrame, "👁️ ESP Combinasionas [OFF]", UDim2.new(0.05, 0, 0, 410), UDim2.new(0.9, 0, 0, 50))
    local espGodButton = createButton(scrollFrame, "🌟 ESP God Mode [OFF]", UDim2.new(0.05, 0, 0, 470), UDim2.new(0.9, 0, 0, 50))
    
    -- Crear sliders
    local speedSlider, speedLabel = createSlider(scrollFrame, "Speed Value:", 16, 200, currentSpeed, UDim2.new(0.05, 0, 0, 190), function(value)
        currentSpeed = value
        if speedBoostEnabled then
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = currentSpeed
                end
            end
        end
    end)
    
    local jumpSlider, jumpLabel = createSlider(scrollFrame, "Jump Power:", 50, 300, currentJump, UDim2.new(0.05, 0, 0, 330), function(value)
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
    
    -- Conectar eventos de botones
    flingButton.MouseButton1Click:Connect(function() toggleFling(flingButton) end)
    antiFpsButton.MouseButton1Click:Connect(function() toggleAntiFPS(antiFpsButton) end)
    speedButton.MouseButton1Click:Connect(function() toggleSpeed(speedButton) end)
    jumpButton.MouseButton1Click:Connect(function() toggleJump(jumpButton) end)
    espCombiButton.MouseButton1Click:Connect(function() toggleESPCombi(espCombiButton) end)
    espGodButton.MouseButton1Click:Connect(function() toggleESPGod(espGodButton) end)
    
    -- Evento del botón cerrar
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
        print("👋 Panel cerrado!")
    end)
    
    return gui
end

-- ========================================
-- CONFIGURAR EVENTOS GLOBALES
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
    
    -- Efecto de fling súper XD
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(
        math.random(-150, 150),
        math.random(80, 200),
        math.random(-150, 150)
    )
    bodyVelocity.Parent = humanoidRootPart
    
    -- Efectos visuales
    local explosion = Instance.new("Explosion")
    explosion.Position = humanoidRootPart.Position
    explosion.BlastRadius = 0
    explosion.BlastPressure = 0
    explosion.Parent = workspace
    
    game:GetService("Debris"):AddItem(bodyVelocity, 3)
    print("💥 FLINGEADO: " .. targetPlayer.Name .. " - ¡VOLANDO SÚPER XD!")
end)

-- Mantener configuraciones al respawn
player.CharacterAdded:Connect(function()
    wait(2)
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if speedBoostEnabled then
        humanoid.WalkSpeed = currentSpeed
        print("⚡ Speed restaurado: " .. currentSpeed)
    end
    
    if jumpBoostEnabled then
        humanoid.JumpPower = currentJump
        print("🦘 Jump restaurado: " .. currentJump)
        
        -- Reconectar sistema de salto mejorado
        humanoid.Jumping:Connect(function()
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                spawn(function()
                    local bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyVelocity.Velocity = Vector3.new(0, currentJump * 1.2, 0)
                    bodyVelocity.Parent = rootPart
                    
                    wait(0.3)
                    if bodyVelocity and bodyVelocity.Parent then
                        bodyVelocity.Velocity = Vector3.new(0, currentJump * 0.6, 0)
                    end
                    
                    wait(0.2)
                    if bodyVelocity and bodyVelocity.Parent then
                        bodyVelocity:Destroy()
                    end
                end)
            end
        end)
    end
end)

-- Nuevos jugadores para ESP
Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer == player then return end
    
    local function checkESP()
        if espCombiEnabled then
            local playerName = newPlayer.Name:lower()
            for _, brainrot in pairs(combinasionas) do
                if playerName:find(brainrot:lower()) or newPlayer.DisplayName:lower():find(brainrot:lower()) then
                    espConnections[newPlayer] = newPlayer.CharacterAdded:Connect(function()
                        wait(1)
                        createESP(newPlayer)
                    end)
                    
                    if newPlayer.Character then
                        createESP(newPlayer)
                    end
                    break
                end
            end
        end
        
        if espGodEnabled then
            local playerName = newPlayer.Name:lower()
            for _, brainrot in pairs(godBrainrots) do
                if playerName:find(brainrot:lower()) or newPlayer.DisplayName:lower():find(brainrot:lower()) then
                    espGodConnections[newPlayer] = newPlayer.CharacterAdded:Connect(function()
                        wait(1)
                        createGodESP(newPlayer)
                    end)
                    
                    if newPlayer.Character then
                        createGodESP(newPlayer)
                    end
                    break
                end
            end
        end
    end
    
    checkESP()
end)

-- Limpiar al salir jugadores
Players.PlayerRemoving:Connect(function(removedPlayer)
    if espConnections[removedPlayer] then
        espConnections[removedPlayer]:Disconnect()
        espConnections[removedPlayer] = nil
    end
    
    if espGodConnections[removedPlayer] then
        espGodConnections[removedPlayer]:Disconnect()
        espGodConnections[removedPlayer] = nil
    end
end)

-- ========================================
-- KEYBINDS (ATAJOS DE TECLADO)
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        -- Toggle GUI visibility
        local existingGui = CoreGui:FindFirstChild("CombinasionasHackGUI")
        if existingGui then
            existingGui.MainFrame.Visible = not existingGui.MainFrame.Visible
            print("👀 GUI " .. (existingGui.MainFrame.Visible and "mostrada" or "ocultada"))
        end
        
    elseif input.KeyCode == Enum.KeyCode.Delete then
        -- Emergency stop
        flingEnabled = false
        speedBoostEnabled = false
        jumpBoostEnabled = false
        espCombiEnabled = false
        espGodEnabled = false
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
        
        -- Limpiar todos los ESP
        for targetPlayer, connection in pairs(espConnections) do
            if connection then connection:Disconnect() end
            if targetPlayer.Character then
                local highlight = targetPlayer.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local billboard = humanoidRootPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        
        for targetPlayer, connection in pairs(espGodConnections) do
            if connection then connection:Disconnect() end
            if targetPlayer.Character then
                local highlight = targetPlayer.Character:FindFirstChild("Highlight")
                if highlight then highlight:Destroy() end
                
                local humanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local billboard = humanoidRootPart:FindFirstChild("BillboardGui")
                    if billboard then billboard:Destroy() end
                end
            end
        end
        
        espConnections = {}
        espGodConnections = {}
        
        print("🛑 EMERGENCY STOP - Todos los hacks desactivados!")
    end
end)

-- ========================================
-- INICIALIZAR EL PANEL
-- ========================================
print("🎮 ========================================")
print("🎮 CARGANDO PANEL DE HACKS...")
print("🎮 ========================================")
print("👑 LOS COMBINASIONAS HACK PANEL v2.0")
print("🔧 Funciones disponibles:")
print("   🚀 Fling Player (clic en jugadores)")
print("   🛡️ Anti FPS Killer")
print("   ⚡ Speed Boost (ajustable)")
print("   🦘 Jump Boost (ajustable)")
print("   👁️ ESP Combinasionas (" .. #combinasionas .. " brainrots)")
print("   🌟 ESP God Mode (" .. #godBrainrots .. " brainrots)")
print("🎮 ========================================")
print("⌨️ CONTROLES:")
print("   INSERT = Mostrar/Ocultar GUI")
print("   DELETE = Emergency Stop (desactivar todo)")
print("🎮 ========================================")

-- Crear la GUI
local mainGUI = setupGUI()

print("✅ PANEL CARGADO EXITOSAMENTE!")
print("🎯 ¡Disfruta hackeando responsablemente!")
print("🎮 ========================================")
