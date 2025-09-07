-- Panel de Funciones para Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variables de configuración
local speedBoostEnabled = false
local jumpBoostEnabled = false
local antiFpsKillerEnabled = false
local flingPlayerEnabled = false
local espCombinacionasEnabled = false
local espGodEnabled = false

local speedMultiplier = 16
local jumpPower = 50

-- Listas de brainrots
local combinacionasList = {
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat"
}

local godList = {
    "Zibra Zubra Zibralini", "Tigrilini Watermelini", "Cocofanta Elefanto", "Girafa Celestre",
    "Gyattatino Nyanino", "Matteo", "Tralalero Tralala", "Espresso Signora", "Odin Din Din Dun",
    "Statutino Libertino", "Trenostruzzo Turbo 3000", "Ballerino Lololo", "Los Orcalitos",
    "Tralalita Tralala", "Urubini Flamenguini", "Trigoligre Frutonni", "Orcalero Orcala",
    "Bulbito Bandito Traktorito", "Los Crocodilitos", "Piccione Macchina", "Trippi Troppi Troppa Trippa",
    "Los Tungtuntuncitos", "Tukanno Bananno", "Alessio", "Tipi Topi Taco", "Pakrahmatmamat",
    "Bombardini Tortinii"
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RobloxPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Panel de Funciones"
title.TextColor3 = Color3.white
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = title

-- Scroll Frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = scrollFrame

-- Función para crear botones
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.white
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Función para crear sliders
local function createSlider(text, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = scrollFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 5)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.white
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.Parent = frame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, -20, 0, 20)
    slider.Position = UDim2.new(0, 10, 0, 35)
    slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    slider.Text = ""
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = slider
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 1, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = slider
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 10)
    knobCorner.Parent = knob
    
    local dragging = false
    local currentValue = defaultVal
    
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = slider.AbsolutePosition
            local relativePos = math.clamp((mousePos.X - sliderPos.X) / slider.AbsoluteSize.X, 0, 1)
            
            currentValue = math.floor(minVal + (maxVal - minVal) * relativePos)
            knob.Position = UDim2.new(relativePos, -10, 0, 0)
            label.Text = text .. ": " .. currentValue
            
            callback(currentValue)
        end
    end)
    
    return currentValue
end

-- Crear todos los botones y sliders AQUÍ
print("Creando botones...")

-- Botón Fling Player
local flingButton = createButton("Fling Player: OFF", function()
    flingPlayerEnabled = not flingPlayerEnabled
    flingButton.Text = "Fling Player: " .. (flingPlayerEnabled and "ON" or "OFF")
    flingButton.BackgroundColor3 = flingPlayerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("Fling Player:", flingPlayerEnabled)
end)

-- Botón Anti FPS Killer
local antiFpsButton = createButton("Anti FPS Killer: OFF", function()
    antiFpsKillerEnabled = not antiFpsKillerEnabled
    antiFpsButton.Text = "Anti FPS Killer: " .. (antiFpsKillerEnabled and "ON" or "OFF")
    antiFpsButton.BackgroundColor3 = antiFpsKillerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("Anti FPS Killer:", antiFpsKillerEnabled)
end)

-- Botón Speed Boost
local speedButton = createButton("Speed Boost: OFF", function()
    speedBoostEnabled = not speedBoostEnabled
    speedButton.Text = "Speed Boost: " .. (speedBoostEnabled and "ON" or "OFF")
    speedButton.BackgroundColor3 = speedBoostEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("Speed Boost:", speedBoostEnabled)
end)

-- Botón Jump Boost
local jumpButton = createButton("Jump Boost: OFF", function()
    jumpBoostEnabled = not jumpBoostEnabled
    jumpButton.Text = "Jump Boost: " .. (jumpBoostEnabled and "ON" or "OFF")
    jumpButton.BackgroundColor3 = jumpBoostEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("Jump Boost:", jumpBoostEnabled)
end)

-- Botón ESP Combinasionas
local espCombButton = createButton("ESP Los Combinasionas: OFF", function()
    espCombinacionasEnabled = not espCombinacionasEnabled
    espCombButton.Text = "ESP Los Combinasionas: " .. (espCombinacionasEnabled and "ON" or "OFF")
    espCombButton.BackgroundColor3 = espCombinacionasEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("ESP Combinasionas:", espCombinacionasEnabled)
end)

-- Botón ESP God
local espGodButton = createButton("ESP God: OFF", function()
    espGodEnabled = not espGodEnabled
    espGodButton.Text = "ESP God: " .. (espGodEnabled and "ON" or "OFF")
    espGodButton.BackgroundColor3 = espGodEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    print("ESP God:", espGodEnabled)
end)

-- Slider de Velocidad
createSlider("Velocidad", 16, 100, 16, function(value)
    speedMultiplier = value
    print("Velocidad cambiada a:", value)
end)

-- Slider de Salto
createSlider("Salto", 50, 200, 50, function(value)
    jumpPower = value
    print("Salto cambiado a:", value)
end)

-- Funciones principales
mouse.Button1Down:Connect(function()
    if flingPlayerEnabled then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local character = target.Parent
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
                bodyVelocity.Parent = humanoidRootPart
                
                game:GetService("Debris"):AddItem(bodyVelocity, 1)
                print("Jugador enviado volando!")
            end
        end
    end
end)

-- Speed Boost
RunService.Heartbeat:Connect(function()
    if speedBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speedMultiplier
    end
end)

-- Jump Boost
RunService.Heartbeat:Connect(function()
    if jumpBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = jumpPower
    end
end)

-- Anti FPS Killer
RunService.Heartbeat:Connect(function()
    if antiFpsKillerEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end
    end
end)

-- Hacer el frame arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.white
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = title

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("Panel cerrado")
end)

-- Botón de minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.white
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = title

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeButton

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 400, 0, 40), "Out", "Quad", 0.3, true)
        scrollFrame.Visible = false
        minimizeButton.Text = "+"
    else
        mainFrame:TweenSize(UDim2.new(0, 400, 0, 600), "Out", "Quad", 0.3, true)
        scrollFrame.Visible = true
        minimizeButton.Text = "-"
    end
end)

-- Sistema ESP mejorado
local espHighlights = {}

local function clearAllESP()
    for _, highlight in pairs(espHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    espHighlights = {}
end

local function createESPHighlight(character, color, espType)
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Remover highlight existente
    local existingHighlight = character:FindFirstChild("ESPHighlight")
    if existingHighlight then
        existingHighlight:Destroy()
    end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.Parent = character
    
    table.insert(espHighlights, highlight)
    
    -- Efecto especial para ESP God
    if espType == "god" then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local pointLight = Instance.new("PointLight")
            pointLight.Name = "ESPLight"
            pointLight.Color = color
            pointLight.Brightness = 2
            pointLight.Range = 15
            pointLight.Parent = humanoidRootPart
            
            table.insert(espHighlights, pointLight)
        end
    end
end

local function checkPlayerName(playerName, targetList)
    playerName = playerName:lower()
    for _, brainrot in pairs(targetList) do
        if playerName:find(brainrot:lower()) then
            return true
        end
    end
    return false
end

local function updateESP()
    if espCombinacionasEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                if checkPlayerName(targetPlayer.Name, combinacionasList) or 
                   checkPlayerName(targetPlayer.DisplayName, combinacionasList) then
                    createESPHighlight(targetPlayer.Character, Color3.fromRGB(255, 255, 0), "combinasionas")
                end
            end
        end
    end
    
    if espGodEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character then
                if checkPlayerName(targetPlayer.Name, godList) or 
                   checkPlayerName(targetPlayer.DisplayName, godList) then
                    createESPHighlight(targetPlayer.Character, Color3.fromRGB(255, 0, 0), "god")
                end
            end
        end
    end
end

-- Actualizar ESP cuando cambian los estados
local function updateESPCombinasionas()
    if espCombinacionasEnabled then
        updateESP()
    else
        clearAllESP()
    end
end

local function updateESPGod()
    if espGodEnabled then
        updateESP()
    else
        clearAllESP()
    end
end

-- Reconectar los botones ESP con las nuevas funciones
espCombButton.MouseButton1Click:Connect(updateESPCombinasionas)
espGodButton.MouseButton1Click:Connect(updateESPGod)

-- Actualizar ESP cuando los jugadores spawnean
Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que el personaje se cargue
        if espCombinacionasEnabled or espGodEnabled then
            updateESP()
        end
    end)
end)

-- Actualizar ESP para jugadores existentes cuando respawnean
for _, existingPlayer in pairs(Players:GetPlayers()) do
    if existingPlayer ~= player then
        existingPlayer.CharacterAdded:Connect(function(character)
            wait(1)
            if espCombinacionasEnabled or espGodEnabled then
                updateESP()
            end
        end)
    end
end

-- Mejorar el sistema de salto
local jumpConnection
local function enhancedJumpBoost()
    if jumpConnection then
        jumpConnection:Disconnect()
    end
    
    jumpConnection = RunService.Heartbeat:Connect(function()
        if jumpBoostEnabled and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoidRootPart then
                -- Detectar cuando el jugador está saltando
                if humanoid.Jump and humanoidRootPart.Velocity.Y > 0 then
                    -- Aplicar impulso hacia arriba más fuerte
                    local bodyVelocity = humanoidRootPart:FindFirstChild("JumpBoostVelocity")
                    if not bodyVelocity then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Name = "JumpBoostVelocity"
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Parent = humanoidRootPart
                        
                        -- Remover después de un tiempo corto
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.3)
                    end
                    
                    bodyVelocity.Velocity = Vector3.new(0, jumpPower * 1.5, 0)
                end
                
                -- Aplicar caída más rápida cuando está bajando
                if humanoidRootPart.Velocity.Y < -10 then
                    local bodyVelocity = humanoidRootPart:FindFirstChild("FallBoostVelocity")
                    if not bodyVelocity then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Name = "FallBoostVelocity"
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Parent = humanoidRootPart
                        
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
                    end
                    
                    bodyVelocity.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y * 1.3, 0)
                end
            end
        end
    end)
end

-- Inicializar el sistema de salto mejorado
enhancedJumpBoost()

-- Tecla de acceso rápido para mostrar/ocultar el panel
UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if not gameProcessed and key.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
        print("Panel", mainFrame.Visible and "mostrado" or "ocultado")
    end
end)

-- Sistema de notificaciones
local function createNotification(text, color)
    spawn(function()
        local notificationGui = Instance.new("ScreenGui")
        notificationGui.Name = "Notification"
        notificationGui.Parent = player:WaitForChild("PlayerGui")
        
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Size = UDim2.new(0, 300, 0, 60)
        notificationFrame.Position = UDim2.new(1, 0, 0, 20)
        notificationFrame.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
        notificationFrame.BorderSizePixel = 0
        notificationFrame.Parent = notificationGui
        
        local notificationCorner = Instance.new("UICorner")
        notificationCorner.CornerRadius = UDim.new(0, 10)
        notificationCorner.Parent = notificationFrame
        
        local notificationText = Instance.new("TextLabel")
        notificationText.Size = UDim2.new(1, -20, 1, -20)
        notificationText.Position = UDim2.new(0, 10, 0, 10)
        notificationText.BackgroundTransparency = 1
        notificationText.Text = text
        notificationText.TextColor3 = Color3.white
        notificationText.TextScaled = true
        notificationText.Font = Enum.Font.SourceSans
        notificationText.Parent = notificationFrame
        
        -- Animación de entrada
        notificationFrame:TweenPosition(UDim2.new(1, -320, 0, 20), "Out", "Quad", 0.5, true)
        
        -- Remover después de 3 segundos
        wait(3)
        notificationFrame:TweenPosition(UDim2.new(1, 0, 0, 20), "In", "Quad", 0.5, true)
        wait(0.5)
        notificationGui:Destroy()
    end)
end

-- Información del panel
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 1, -25)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Presiona INSERT para mostrar/ocultar"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = mainFrame

-- Actualizar el tamaño del canvas del scroll frame
local function updateScrollSize()
    local totalHeight = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + 5
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 50)
end

-- Conectar la actualización del tamaño
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
updateScrollSize()

-- Mensaje de confirmación
print("✅ Panel de Funciones cargado exitosamente!")
print("📋 Funciones disponibles:")
print("   • Fling Player")
print("   • Anti FPS Killer") 
print("   • Speed Boost (ajustable)")
print("   • Jump Boost (ajustable)")
print("   • ESP Los Combinasionas")
print("   • ESP God")
print("🎮 Presiona INSERT para mostrar/ocultar el panel")
print("🖱️ Arrastra desde el título para mover el panel")

-- Crear notificación de bienvenida
createNotification("Panel cargado exitosamente!", Color3.fromRGB(0, 150, 0))
