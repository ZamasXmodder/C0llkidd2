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

-- Funciones principales
local function flingPlayer()
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
                end
            end
        end
    end)
end

local function speedBoost()
    RunService.Heartbeat:Connect(function()
        if speedBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speedMultiplier
        end
    end)
end

local function jumpBoost()
    RunService.Heartbeat:Connect(function()
        if jumpBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = jumpPower
        end
    end)
end

local function antiFpsKiller()
    RunService.Heartbeat:Connect(function()
        if antiFpsKillerEnabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end
        end
    end)
end

local function createESP(targetList, color)
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player then
            local character = targetPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, brainrot in pairs(targetList) do
                    if string.find(targetPlayer.Name:lower(), brainrot:lower()) or 
                       string.find(targetPlayer.DisplayName:lower(), brainrot:lower()) then
                        
                        local highlight = Instance.new("Highlight")
                        highlight.FillColor = color
                        highlight.OutlineColor = color
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                        break
                    end
                end
            end
        end
    end
end

-- Crear botones del panel
local flingButton = createButton("Fling Player: OFF", function()
    flingPlayerEnabled = not flingPlayerEnabled
    flingButton.Text = "Fling Player: " .. (flingPlayerEnabled and "ON" or "OFF")
    flingButton.BackgroundColor3 = flingPlayerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

local antiFpsButton = createButton("Anti FPS Killer: OFF", function()
    antiFpsKillerEnabled = not antiFpsKillerEnabled
    antiFpsButton.Text = "Anti FPS Killer: " .. (antiFpsKillerEnabled and "ON" or "OFF")
    antiFpsButton.BackgroundColor3 = antiFpsKillerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

local speedButton = createButton("Speed Boost: OFF", function()
    speedBoostEnabled = not speedBoostEnabled
    speedButton.Text = "Speed Boost: " .. (speedBoostEnabled and "ON" or "OFF")
    speedButton.BackgroundColor3 = speedBoostEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

local jumpButton = createButton("Jump Boost: OFF", function()
    jumpBoostEnabled = not jumpBoostEnabled
    jumpButton.Text = "Jump Boost: " .. (jumpBoostEnabled and "ON" or "OFF")
    jumpButton.BackgroundColor3 = jumpBoostEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
end)

local espCombButton = createButton("ESP Los Combinasionas: OFF", function()
    espCombinacionasEnabled = not espCombinacionasEnabled
    espCombButton.Text = "ESP Los Combinasionas: " .. (espCombinacionasEnabled and "ON" or "OFF")
    espCombButton.BackgroundColor3 = espCombinacionasEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if espCombinacionasEnabled then
        createESP(combinacionasList, Color3.fromRGB(255, 255, 0))
    end
end)

local espGodButton = createButton("ESP God: OFF", function()
    espGodEnabled = not espGodEnabled
    espGodButton.Text = "ESP God: " .. (espGodEnabled and "ON" or "OFF")
    espGodButton.BackgroundColor3 = espGodEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if espGodEnabled then
        createESP(godList, Color3.fromRGB(255, 0, 0))
    end
end)

-- Sliders
createSlider("Velocidad", 16, 100, 16, function(value)
    speedMultiplier = value
end)

createSlider("Salto", 50, 200, 50, function(value)
    jumpPower = value
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

-- Actualizar tamaño del scroll frame
local function updateScrollSize()
    local totalHeight = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + 5
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)

-- Inicializar funciones
flingPlayer()
speedBoost()
jumpBoost()
antiFpsKiller()

-- Sistema de ESP mejorado con actualización continua
local espConnections = {}

local function clearESP()
    for _, connection in pairs(espConnections) do
        connection:Disconnect()
    end
    espConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, highlight in pairs(player.Character:GetChildren()) do
                if highlight:IsA("Highlight") then
                    highlight:Destroy()
                end
            end
        end
    end
end

local function startESP(targetList, color, espType)
    local function checkPlayer(targetPlayer)
        if targetPlayer == player then return false end
        
        for _, brainrot in pairs(targetList) do
            if string.find(targetPlayer.Name:lower(), brainrot:lower()) or 
               string.find(targetPlayer.DisplayName:lower(), brainrot:lower()) then
                return true
            end
        end
        return false
    end
    
    local function createHighlight(character, color)
        local existingHighlight = character:FindFirstChild("Highlight")
        if existingHighlight then
            existingHighlight:Destroy()
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        -- Efecto de brillo para ESP God
        if espType == "god" then
            local pointLight = Instance.new("PointLight")
            pointLight.Color = color
            pointLight.Brightness = 2
            pointLight.Range = 10
            pointLight.Parent = character:FindFirstChild("HumanoidRootPart")
        end
    end
    
    -- Conexión para jugadores existentes
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if checkPlayer(targetPlayer) and targetPlayer.Character then
            createHighlight(targetPlayer.Character, color)
        end
    end
    
    -- Conexión para nuevos jugadores
    local playerAddedConnection = Players.PlayerAdded:Connect(function(targetPlayer)
        if checkPlayer(targetPlayer) then
            targetPlayer.CharacterAdded:Connect(function(character)
                wait(1) -- Esperar a que el personaje se cargue completamente
                createHighlight(character, color)
            end)
        end
    end)
    
    -- Conexión para personajes que respawnean
    local characterAddedConnection = Players.PlayerAdded:Connect(function(targetPlayer)
        targetPlayer.CharacterAdded:Connect(function(character)
            if checkPlayer(targetPlayer) then
                wait(1)
                createHighlight(character, color)
            end
        end)
    end)
    
    table.insert(espConnections, playerAddedConnection)
    table.insert(espConnections, characterAddedConnection)
end

-- Actualizar botones ESP
espCombButton.MouseButton1Click:Connect(function()
    espCombinacionasEnabled = not espCombinacionasEnabled
    espCombButton.Text = "ESP Los Combinasionas: " .. (espCombinacionasEnabled and "ON" or "OFF")
    espCombButton.BackgroundColor3 = espCombinacionasEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if espCombinacionasEnabled then
        startESP(combinacionasList, Color3.fromRGB(255, 255, 0), "combinasionas")
    else
        clearESP()
    end
end)

espGodButton.MouseButton1Click:Connect(function()
    espGodEnabled = not espGodEnabled
    espGodButton.Text = "ESP God: " .. (espGodEnabled and "ON" or "OFF")
    espGodButton.BackgroundColor3 = espGodEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(70, 70, 70)
    
    if espGodEnabled then
        startESP(godList, Color3.fromRGB(255, 0, 0), "god")
    else
        clearESP()
    end
end)

-- Mejorar el sistema de salto
local originalJumpPower = 50
local jumpConnection

local function enhancedJumpBoost()
    if jumpConnection then
        jumpConnection:Disconnect()
    end
    
    jumpConnection = RunService.Heartbeat:Connect(function()
        if jumpBoostEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                -- Detectar cuando el jugador salta
                if humanoid.Jump and humanoidRootPart.Velocity.Y > 0 then
                    -- Aplicar impulso hacia arriba
                    local bodyVelocity = humanoidRootPart:FindFirstChild("JumpBoost")
                    if not bodyVelocity then
                        bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.Name = "JumpBoost"
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Parent = humanoidRootPart
                    end
                    
                    bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0)
                    
                    -- Remover el impulso después de un tiempo
                    game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
                end
            end
        end
    end)
end

-- Reemplazar la función de salto anterior
enhancedJumpBoost()

-- Sistema de notificaciones
local function createNotification(text, color)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "Notification"
    notificationGui.Parent = player:WaitForChild("PlayerGui")
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 300, 0, 60)
    notificationFrame.Position = UDim2.new(1, -320, 0, 20)
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
end

-- Agregar notificaciones a las funciones
local originalFlingClick = flingButton.MouseButton1Click
flingButton.MouseButton1Click:Connect(function()
    spawn(function()
        createNotification("Fling Player " .. (flingPlayerEnabled and "Activado" or "Desactivado"), 
                         flingPlayerEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0))
    end)
end)

-- Tecla de acceso rápido para mostrar/ocultar el panel
UserInputService.InputBegan:Connect(function(key, gameProcessed)
    if not gameProcessed and key.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Información del panel
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 20)
infoLabel.Position = UDim2.new(0, 0, 1, -20)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Presiona INSERT para mostrar/ocultar | Arrastra desde el título"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = mainFrame

print("Panel de Funciones cargado exitosamente!")
print("Presiona INSERT para mostrar/ocultar el panel")
