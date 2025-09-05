local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local floatPart = nil
local flyPart = nil
local isFloatActive = false
local isFlyActive = false
local panelOpen = false
local floatConnection = nil
local flyConnection = nil
local rainbowConnection = nil
local godModeConnection = nil
local savedStateConnection = nil
local teleportCapsule = {}

-- Variables de vuelo suave
local flyDirection = Vector3.new(0, 0, 0)
local keysPressed = {}
local currentFloatHeight = 0
local targetFloatHeight = 0
local floatVelocity = Vector3.new(0, 0, 0)

-- Variables de estado guardado
local savedPosition = nil
local isGoingToSavedState = false

-- Configuración por defecto
local config = {
    floatSpeed = 16,
    jumpPower = 50,
    walkSpeed = 16,
    flySpeed = 8,
    floatHeight = 10,
    partSize = Vector3.new(8, 1, 8),
    partColor = Color3.fromRGB(0, 162, 255),
    partTransparency = 0.3
}

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatPartPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 470)
mainFrame.Position = UDim2.new(1, -260, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleLabel.Text = "Float & Fly Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de activar/desactivar float
local toggleFloatButton = Instance.new("TextButton")
toggleFloatButton.Name = "ToggleFloat"
toggleFloatButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleFloatButton.Position = UDim2.new(0.05, 0, 0, 50)
toggleFloatButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
toggleFloatButton.Text = "Float Part (T)"
toggleFloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFloatButton.TextScaled = true
toggleFloatButton.Font = Enum.Font.Gotham
toggleFloatButton.Parent = mainFrame

local toggleFloatCorner = Instance.new("UICorner")
toggleFloatCorner.CornerRadius = UDim.new(0, 5)
toggleFloatCorner.Parent = toggleFloatButton

-- Botón de activar/desactivar fly suave
local toggleFlyButton = Instance.new("TextButton")
toggleFlyButton.Name = "ToggleFly"
toggleFlyButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleFlyButton.Position = UDim2.new(0.05, 0, 0, 90)
toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 85, 255)
toggleFlyButton.Text = "Float Mode (WASD)"
toggleFlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleFlyButton.TextScaled = true
toggleFlyButton.Font = Enum.Font.Gotham
toggleFlyButton.Parent = mainFrame

local toggleFlyCorner = Instance.new("UICorner")
toggleFlyCorner.CornerRadius = UDim.new(0, 5)
toggleFlyCorner.Parent = toggleFlyButton

-- Botón para guardar estado
local saveStateButton = Instance.new("TextButton")
saveStateButton.Name = "SaveState"
saveStateButton.Size = UDim2.new(0.43, 0, 0, 30)
saveStateButton.Position = UDim2.new(0.05, 0, 0, 130)
saveStateButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
saveStateButton.Text = "Guardar Estado"
saveStateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveStateButton.TextScaled = true
saveStateButton.Font = Enum.Font.Gotham
saveStateButton.Parent = mainFrame

local saveStateCorner = Instance.new("UICorner")
saveStateCorner.CornerRadius = UDim.new(0, 5)
saveStateCorner.Parent = saveStateButton

-- Botón para ir al estado guardado
local goToStateButton = Instance.new("TextButton")
goToStateButton.Name = "GoToState"
goToStateButton.Size = UDim2.new(0.43, 0, 0, 30)
goToStateButton.Position = UDim2.new(0.52, 0, 0, 130)
goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
goToStateButton.Text = "Ir al Estado"
goToStateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
goToStateButton.TextScaled = true
goToStateButton.Font = Enum.Font.Gotham
goToStateButton.Parent = mainFrame

local goToStateCorner = Instance.new("UICorner")
goToStateCorner.CornerRadius = UDim.new(0, 5)
goToStateCorner.Parent = goToStateButton

-- Función para crear sliders más pequeños
local function createSlider(name, yPos, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Frame"
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, yPos)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = mainFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = sliderFrame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 15)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 7)
    sliderBgCorner.Parent = sliderBg
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 15, 1, 0)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -7, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(1, 0)
    sliderButtonCorner.Parent = sliderButton
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
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
            local relativeX = mouse.X - sliderBg.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -7, 0, 0)
            
            local value = math.floor(minVal + (maxVal - minVal) * percentage)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
end

-- Crear sliders
createSlider("Float Speed", 335, 1, 50, config.flySpeed, function(value)
    config.flySpeed = value
end)

createSlider("Jump Power", 225, 10, 150, config.jumpPower, function(value)
    config.jumpPower = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
    end
end)

createSlider("Walk Speed", 280, 1, 100, config.walkSpeed, function(value)
    config.walkSpeed = value
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
    end
end)

createSlider("Float Speed", 335, 1, 30, config.flySpeed, function(value)
    config.flySpeed = value
end)

createSlider("Float Height", 390, 5, 50, config.floatHeight, function(value)
    config.floatHeight = value
end)

-- Función para crear cápsula de teletransporte
local function createTeleportCapsule(position)
    -- Limpiar cápsula anterior si existe
    for _, part in pairs(teleportCapsule) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    teleportCapsule = {}
    
        local capsuleSize = Vector3.new(8, 12, 8)
    local wallThickness = 1
    
    -- Crear las 6 paredes de la cápsula
    local walls = {
        {name = "Bottom", size = Vector3.new(capsuleSize.X, wallThickness, capsuleSize.Z), offset = Vector3.new(0, -capsuleSize.Y/2, 0)},
        {name = "Top", size = Vector3.new(capsuleSize.X, wallThickness, capsuleSize.Z), offset = Vector3.new(0, capsuleSize.Y/2, 0)},
        {name = "Front", size = Vector3.new(capsuleSize.X, capsuleSize.Y, wallThickness), offset = Vector3.new(0, 0, -capsuleSize.Z/2)},
        {name = "Back", size = Vector3.new(capsuleSize.X, capsuleSize.Y, wallThickness), offset = Vector3.new(0, 0, capsuleSize.Z/2)},
        {name = "Left", size = Vector3.new(wallThickness, capsuleSize.Y, capsuleSize.Z), offset = Vector3.new(-capsuleSize.X/2, 0, 0)},
        {name = "Right", size = Vector3.new(wallThickness, capsuleSize.Y, capsuleSize.Z), offset = Vector3.new(capsuleSize.X/2, 0, 0)}
    }
    
    for _, wallData in pairs(walls) do
        local wall = Instance.new("Part")
        wall.Name = "TeleportCapsule_" .. wallData.name
        wall.Size = wallData.size
        wall.Position = position + wallData.offset
        wall.Material = Enum.Material.ForceField
        wall.Color = Color3.fromRGB(0, 255, 255)
        wall.Transparency = 0.2
        wall.Anchored = true
        wall.CanCollide = true
        wall.Parent = workspace
        
        -- Efecto de brillo
        local selectionBox = Instance.new("SelectionBox")
        selectionBox.Adornee = wall
        selectionBox.Color3 = Color3.fromRGB(0, 255, 255)
        selectionBox.LineThickness = 0.3
        selectionBox.Transparency = 0.1
        selectionBox.Parent = wall
        
        table.insert(teleportCapsule, wall)
    end
    
    -- Crear efecto rainbow en las paredes
    spawn(function()
        local hue = 0
        while #teleportCapsule > 0 and teleportCapsule[1] and teleportCapsule[1].Parent do
            hue = (hue + 2) % 360
            local color = Color3.fromHSV(hue / 360, 1, 1)
            
            for _, wall in pairs(teleportCapsule) do
                if wall and wall.Parent then
                    wall.Color = color
                    local selectionBox = wall:FindFirstChild("SelectionBox")
                    if selectionBox then
                        selectionBox.Color3 = color
                    end
                end
            end
            
            wait(0.05)
        end
    end)
end

-- Función para destruir cápsula de teletransporte
local function destroyTeleportCapsule()
    for _, part in pairs(teleportCapsule) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    teleportCapsule = {}
end

-- Función para protección absoluta durante teletransporte
local function enableAbsoluteGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            -- Protección absoluta
            humanoid.Health = humanoid.MaxHealth
            humanoid.PlatformStand = true -- Evita que caiga o se mueva
            
            if humanoidRootPart then
                humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                humanoidRootPart.Anchored = true -- Completamente inmóvil
            end
        end
    end)
end

-- Función para protección sutil contra muerte
local function enableSubtleGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            -- Protección más sutil
            if humanoid.Health < humanoid.MaxHealth * 0.1 then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Asegurar que no esté anclado en modo normal
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and not isGoingToSavedState then
                humanoidRootPart.Anchored = false
                humanoid.PlatformStand = false
            end
        end
    end)
end

-- Función para crear la part flotante
local function createFloatPart()
    if floatPart then
        floatPart:Destroy()
    end
    
    floatPart = Instance.new("Part")
    floatPart.Name = "FloatPart"
    floatPart.Size = config.partSize
    floatPart.Material = Enum.Material.Neon
    floatPart.Color = config.partColor
    floatPart.Transparency = config.partTransparency
    floatPart.Anchored = true
    floatPart.CanCollide = true
    floatPart.Parent = workspace
    
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = floatPart
    selectionBox.Color3 = config.partColor
    selectionBox.LineThickness = 0.2
    selectionBox.Transparency = 0.5
    selectionBox.Parent = floatPart
end

-- Función para crear la part de flotación rainbow
local function createFlyPart()
    if flyPart then
        flyPart:Destroy()
    end
    
    flyPart = Instance.new("Part")
    flyPart.Name = "FloatSupportPart"
    flyPart.Size = Vector3.new(4, 0.2, 4)
    flyPart.Material = Enum.Material.ForceField
    flyPart.Transparency = 0.8
    flyPart.Anchored = true
    flyPart.CanCollide = false
    flyPart.Parent = workspace
    
    -- Efecto rainbow sutil
    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        hue = (hue + 0.5) % 360
        flyPart.Color = Color3.fromHSV(hue / 360, 0.8, 0.9)
    end)
end

-- Función para vuelo automático con cápsula protectora
local function safeFloatToSavedState()
    if not savedPosition or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character.Humanoid
    local startPosition = humanoidRootPart.Position
    
    -- Crear cápsula de protección móvil
    createTeleportCapsule(startPosition)
    
    -- Activar protección absoluta
    enableAbsoluteGodMode()
    
    -- Notificación de inicio
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, 100)
    notification.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    notification.Text = "🛡️ Cápsula Activada - Volando al destino..."
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    -- Configuración del vuelo automático
    local flySpeed = 25 -- Velocidad de vuelo (ajustable)
    local currentPos = startPosition
    local targetPos = savedPosition
    local totalDistance = (targetPos - startPosition).Magnitude
    local progress = 0
    
    -- Crear BodyVelocity para movimiento suave
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "AutoFloatVelocity"
    bodyVelocity.MaxForce = Vector3.new(8000, 8000, 8000)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Crear BodyPosition para estabilidad adicional
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.Name = "AutoFloatPosition"
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.P = 3000
    bodyPosition.D = 500
    bodyPosition.Parent = humanoidRootPart
    
    -- Función para actualizar la posición de la cápsula
    local function updateCapsulePosition(position)
        for i, wall in pairs(teleportCapsule) do
            if wall and wall.Parent then
                local wallData = {
                    {offset = Vector3.new(0, -6, 0)}, -- Bottom
                    {offset = Vector3.new(0, 6, 0)},  -- Top
                    {offset = Vector3.new(0, 0, -4)}, -- Front
                    {offset = Vector3.new(0, 0, 4)},  -- Back
                    {offset = Vector3.new(-4, 0, 0)}, -- Left
                    {offset = Vector3.new(4, 0, 0)}   -- Right
                }
                
                if wallData[i] then
                    wall.Position = position + wallData[i].offset
                end
            end
        end
    end
    
    -- Bucle de vuelo automático
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not isGoingToSavedState or not humanoidRootPart.Parent then
            flyConnection:Disconnect()
            return
        end
        
        currentPos = humanoidRootPart.Position
        local direction = (targetPos - currentPos)
        local distance = direction.Magnitude
        
        -- Calcular progreso
        progress = 1 - (distance / totalDistance)
        
        -- Actualizar notificación con progreso
        local progressPercent = math.floor(progress * 100)
        notification.Text = string.format("🚀 Volando... %d%% (%d studs restantes)", 
            progressPercent, math.floor(distance))
        
        if distance > 3 then
            -- Calcular velocidad adaptativa (más lento al acercarse)
            local adaptiveSpeed = flySpeed
            if distance < 20 then
                adaptiveSpeed = flySpeed * (distance / 20) * 0.5 + flySpeed * 0.5
            end
            
            -- Normalizar dirección y aplicar velocidad
            direction = direction.Unit
            local targetVelocity = direction * adaptiveSpeed
            
            -- Aplicar movimiento suave
            bodyVelocity.Velocity = targetVelocity
            bodyPosition.Position = currentPos + (direction * 2)
            
            -- Actualizar posición de la cápsula
            updateCapsulePosition(currentPos)

                            -- Actualizar fly part si está activa
            if isFlyActive and flyPart then
                flyPart.Position = currentPos - Vector3.new(0, config.floatHeight + 1, 0)
            end
        else
            -- Llegamos al destino
            flyConnection:Disconnect()
            
            -- Posición final exacta
            humanoidRootPart.CFrame = CFrame.new(targetPos)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyPosition.Position = targetPos
            
            -- Actualizar cápsula a posición final
            updateCapsulePosition(targetPos)
            
            -- Actualizar notificación
            notification.Text = "✅ Destino Alcanzado - Estabilizando..."
            notification.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
            
            -- Esperar estabilización
            spawn(function()
                wait(2)
                
                -- Limpiar BodyVelocity y BodyPosition
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
                if bodyPosition and bodyPosition.Parent then
                    bodyPosition:Destroy()
                end
                
                -- Destruir cápsula
                destroyTeleportCapsule()
                
                -- Restaurar protección normal
                if isFlyActive or isFloatActive then
                    enableSubtleGodMode()
                else
                    if godModeConnection then
                        godModeConnection:Disconnect()
                        godModeConnection = nil
                    end
                end
                
                -- Restaurar controles normales
                humanoidRootPart.Anchored = false
                humanoid.PlatformStand = false
                
                -- Asegurar que la fly part esté en la posición correcta
                if isFlyActive and flyPart then
                    flyPart.Position = targetPos - Vector3.new(0, config.floatHeight + 1, 0)
                end
                
                -- Eliminar notificación
                game:GetService("Debris"):AddItem(notification, 2)
                
                -- Restaurar botón
                isGoingToSavedState = false
                goToStateButton.Text = "Ir al Estado"
                goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
            end)
        end
    end)
end

-- Función para cancelar vuelo automático
local function cancelAutoFlight()
    if not isGoingToSavedState then
        return
    end
    
    isGoingToSavedState = false
    
    -- Limpiar BodyVelocity y BodyPosition si existen
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        
        local bodyVelocity = humanoidRootPart:FindFirstChild("AutoFloatVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        
        local bodyPosition = humanoidRootPart:FindFirstChild("AutoFloatPosition")
        if bodyPosition then
            bodyPosition:Destroy()
        end
        
        -- Restaurar controles
        humanoidRootPart.Anchored = false
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.PlatformStand = false
        end
    end
    
    -- Destruir cápsula
    destroyTeleportCapsule()
    
    -- Restaurar protección normal
    if isFlyActive or isFloatActive then
        enableSubtleGodMode()
    else
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
    end
    
    -- Restaurar botón
    goToStateButton.Text = "Ir al Estado"
    goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
    
    -- Notificación de cancelación
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(0.5, -100, 0, 100)
    notification.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
    notification.Text = "🚫 Vuelo Cancelado"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    game:GetService("Debris"):AddItem(notification, 2)
end

-- Función para ir al estado guardado
local function goToSavedState()
    if not savedPosition then
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 200, 0, 50)
        notification.Position = UDim2.new(0.5, -100, 0, 100)
        notification.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        notification.Text = "¡No hay estado guardado!"
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextScaled = true
        notification.Font = Enum.Font.GothamBold
        notification.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification
        
        game:GetService("Debris"):AddItem(notification, 2)
        return
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Si ya está volando, cancelar
    if isGoingToSavedState then
        cancelAutoFlight()
        return
    end
    
    isGoingToSavedState = true
    goToStateButton.Text = "Cancelar Vuelo"
    goToStateButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    
    -- Ejecutar vuelo automático seguro
    spawn(function()
        safeFloatToSavedState()
    end)
end

-- Función para guardar estado actual
local function saveCurrentState()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    savedPosition = player.Character.HumanoidRootPart.Position
    saveStateButton.Text = "Estado Guardado!"
    saveStateButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(0.5, -100, 0, 100)
    notification.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    notification.Text = "💾 Estado guardado!"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    game:GetService("Debris"):AddItem(notification, 2)
    
    spawn(function()
        wait(2)
        saveStateButton.Text = "Guardar Estado"
        saveStateButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    end)
end

-- Función para actualizar la posición de la float part
local function updateFloatPart()
    if not isFloatActive or not floatPart or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local targetPosition = humanoidRootPart.Position - Vector3.new(0, 4, 0)
        floatPart.Position = floatPart.Position:Lerp(targetPosition, config.floatSpeed * 0.01)
    end
end

-- Función para actualizar el float suave (simula saltos lentos)
local function updateSmoothFloat()
    if not isFlyActive or not flyPart or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoidRootPart and humanoid then
        -- Si está yendo al estado guardado, no procesar controles WASD
        if isGoingToSavedState then
            return
        end
        
        -- Calcular dirección basada en las teclas presionadas
        local camera = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)
        
        if keysPressed[Enum.KeyCode.W] then
            direction = direction + camera.CFrame.LookVector
        end
        if keysPressed[Enum.KeyCode.S] then
            direction = direction - camera.CFrame.LookVector
        end
        if keysPressed[Enum.KeyCode.A] then
            direction = direction - camera.CFrame.RightVector
        end
        if keysPressed[Enum.KeyCode.D] then
            direction = direction + camera.CFrame.RightVector
        end
        
        -- Normalizar dirección horizontal
        if direction.Magnitude > 0 then
            direction = Vector3.new(direction.X, 0, direction.Z).Unit
        end
        
        -- Aplicar movimiento suave y natural
        local currentVelocity = humanoidRootPart.Velocity
        local targetVelocity = direction * config.flySpeed
        
        -- Mantener flotación suave
        local raycast = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -100, 0))
        local groundHeight = raycast and raycast.Position.Y or (humanoidRootPart.Position.Y - 50)
        local targetHeight = groundHeight + config.floatHeight
        
        -- Ajuste suave de altura
        local heightDifference = targetHeight - humanoidRootPart.Position.Y
        local verticalVelocity = heightDifference * 0.1
        
        -- Aplicar velocidad combinada (más natural)
        local newVelocity = Vector3.new(
            targetVelocity.X,
            math.clamp(verticalVelocity, -10, 10),
            targetVelocity.Z
        )
        
        -- Usar BodyVelocity para movimiento más suave
        local bodyVelocity = humanoidRootPart:FindFirstChild("FloatBodyVelocity")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "FloatBodyVelocity"
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = humanoidRootPart
        end
        
        bodyVelocity.Velocity = newVelocity

                -- Posicionar la part de soporte
        flyPart.Position = humanoidRootPart.Position - Vector3.new(0, config.floatHeight + 1, 0)
        
        -- Simular estado de salto para evitar detección
        if math.abs(heightDifference) > 2 then
            humanoid.Jump = false
        end
    end
end

-- Función para activar/desactivar float part
local function toggleFloatPart()
    isFloatActive = not isFloatActive
    
    if isFloatActive then
        createFloatPart()
        toggleFloatButton.Text = "Desactivar Float (T)"
        toggleFloatButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
        
        floatConnection = RunService.Heartbeat:Connect(updateFloatPart)
        enableSubtleGodMode()
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = config.jumpPower
            player.Character.Humanoid.WalkSpeed = config.walkSpeed
        end
    else
        if floatPart then
            floatPart:Destroy()
            floatPart = nil
        end
        
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        if not isFlyActive and godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        
        toggleFloatButton.Text = "Float Part (T)"
        toggleFloatButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    end
end

-- Función para activar/desactivar float mode suave
local function toggleSmoothFloat()
    isFlyActive = not isFlyActive
    
    if isFlyActive then
        createFlyPart()
        toggleFlyButton.Text = "Desactivar Float"
        toggleFlyButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
        
        flyConnection = RunService.Heartbeat:Connect(updateSmoothFloat)
        enableSubtleGodMode()
        
        -- Inicializar altura de flotación
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            currentFloatHeight = player.Character.HumanoidRootPart.Position.Y
            targetFloatHeight = currentFloatHeight + config.floatHeight
        end
    else
        if flyPart then
            flyPart:Destroy()
            flyPart = nil
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
        
        -- Limpiar BodyVelocity
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = player.Character.HumanoidRootPart:FindFirstChild("FloatBodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
        
        if not isFloatActive and godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        
        -- Detener ir al estado guardado si está activo
        if isGoingToSavedState then
            cancelAutoFlight()
        end
        
        toggleFlyButton.Text = "Float Mode (WASD)"
        toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 85, 255)
    end
end

-- Función para mostrar/ocultar panel
local function togglePanel()
    panelOpen = not panelOpen
    
    if panelOpen then
        mainFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 250, 0, 470),
            Position = UDim2.new(1, -260, 0, 10)
        })
        tween:Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(mainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, 0, 0, 10)
        })
        tween:Play()
        
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

-- Función para restaurar estado después de respawn
local function restoreStateAfterRespawn()
    wait(1)
    
    if isFloatActive then
        createFloatPart()
        floatConnection = RunService.Heartbeat:Connect(updateFloatPart)
        enableSubtleGodMode()
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = config.jumpPower
            player.Character.Humanoid.WalkSpeed = config.walkSpeed
        end
        
        toggleFloatButton.Text = "Desactivar Float (T)"
        toggleFloatButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    end
    
    if isFlyActive then
        createFlyPart()
        flyConnection = RunService.Heartbeat:Connect(updateSmoothFloat)
        enableSubtleGodMode()
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            currentFloatHeight = player.Character.HumanoidRootPart.Position.Y
            targetFloatHeight = currentFloatHeight + config.floatHeight
        end
        
        toggleFlyButton.Text = "Desactivar Float"
        toggleFlyButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    end
    
    if panelOpen then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 250, 0, 470)
        mainFrame.Position = UDim2.new(1, -260, 0, 10)
    end
end

-- Eventos de botones
toggleFloatButton.MouseButton1Click:Connect(toggleFloatPart)
toggleFlyButton.MouseButton1Click:Connect(toggleSmoothFloat)
saveStateButton.MouseButton1Click:Connect(saveCurrentState)
goToStateButton.MouseButton1Click:Connect(goToSavedState)

-- Input para controles
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
    
    if input.KeyCode == Enum.KeyCode.T then
        toggleFloatPart()
    end
    
    -- Controles de flotación suave WASD
    if input.KeyCode == Enum.KeyCode.W or 
       input.KeyCode == Enum.KeyCode.A or 
       input.KeyCode == Enum.KeyCode.S or 
       input.KeyCode == Enum.KeyCode.D then
        keysPressed[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    -- Controles de flotación suave WASD
    if input.KeyCode == Enum.KeyCode.W or 
       input.KeyCode == Enum.KeyCode.A or 
       input.KeyCode == Enum.KeyCode.S or 
       input.KeyCode == Enum.KeyCode.D then
        keysPressed[input.KeyCode] = false
    end
end)

-- Restaurar estado al respawnear
player.CharacterAdded:Connect(restoreStateAfterRespawn)

-- Limpiar al salir del juego
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        if floatPart then floatPart:Destroy() end
        if flyPart then flyPart:Destroy() end
        destroyTeleportCapsule()
        
        if floatConnection then floatConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if rainbowConnection then rainbowConnection:Disconnect() end
        if godModeConnection then godModeConnection:Disconnect() end
        if savedStateConnection then savedStateConnection:Disconnect() end
        
        -- Limpiar BodyVelocity si existe
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = player.Character.HumanoidRootPart:FindFirstChild("FloatBodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            local autoVelocity = player.Character.HumanoidRootPart:FindFirstChild("AutoFloatVelocity")
            if autoVelocity then
                autoVelocity:Destroy()
            end
            
            local autoPosition = player.Character.HumanoidRootPart:FindFirstChild("AutoFloatPosition")
            if autoPosition then
                autoPosition:Destroy()
            end
        end
    end
end)

-- Limpiar BodyVelocity al cambiar de personaje
player.CharacterRemoving:Connect(function(character)
    destroyTeleportCapsule()
    
    if character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = character.HumanoidRootPart:FindFirstChild("FloatBodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        
        local autoVelocity = character.HumanoidRootPart:FindFirstChild("AutoFloatVelocity")
        if autoVelocity then
            autoVelocity:Destroy()
        end
        
        local autoPosition = character.HumanoidRootPart:FindFirstChild("AutoFloatPosition")
        if autoPosition then
            autoPosition:Destroy()
        end
    end
end)

-- Función de emergencia para limpiar todo (por si algo sale mal)
local function emergencyCleanup()
    isGoingToSavedState = false
    destroyTeleportCapsule()
    
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = player.Character:FindFirstChild("Humanoid")
        
        if humanoidRootPart then
            humanoidRootPart.Anchored = false
            
            local bodyVelocity = humanoidRootPart:FindFirstChild("FloatBodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            
            local autoVelocity = humanoidRootPart:FindFirstChild("AutoFloatVelocity")
            if autoVelocity then
                autoVelocity:Destroy()
            end
            
            local autoPosition = humanoidRootPart:FindFirstChild("AutoFloatPosition")
            if autoPosition then
                autoPosition:Destroy()
            end
        end
        
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    goToStateButton.Text = "Ir al Estado"
    goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
end

-- Tecla de emergencia (Ctrl + E) para limpiar todo
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        emergencyCleanup()
        
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 250, 0, 50)
        notification.Position = UDim2.new(0.5, -125, 0, 100)
        notification.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
        notification.Text = "🚨 Limpieza de emergencia activada"
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextScaled = true
        notification.Font = Enum.Font.GothamBold
        notification.Parent = screenGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification
        
        game:GetService("Debris"):AddItem(notification, 3)
    end
end)

-- Crear botón flotante para abrir/cerrar panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -50, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
toggleButton.Text = "F"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(1, 0)
toggleButtonCorner.Parent = toggleButton

-- Evento del botón flotante
toggleButton.MouseButton1Click:Connect(togglePanel)

-- Efecto hover para el botón flotante
toggleButton.MouseEnter:Connect(function()
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(toggleButton, tweenInfo, {
        Size = UDim2.new(0, 45, 0, 45),
        BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    })
    tween:Play()
end)

toggleButton.MouseLeave:Connect(function()
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(toggleButton, tweenInfo, {
        Size = UDim2.new(0, 40, 0, 40),
        BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    })
    tween:Play()
end)

-- Notificación de bienvenida
spawn(function()
    wait(1)
    
    local welcomeNotification = Instance.new("TextLabel")
    welcomeNotification.Size = UDim2.new(0, 350, 0, 80)
    welcomeNotification.Position = UDim2.new(0.5, -175, 0, 50)
    welcomeNotification.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    welcomeNotification.Text = "🚀 Float & Fly Panel Cargado!\nPresiona F para abrir el panel"
    welcomeNotification.TextColor3 = Color3.fromRGB(255, 255, 255)
    welcomeNotification.TextScaled = true
    welcomeNotification.Font = Enum.Font.GothamBold
    welcomeNotification.Parent = screenGui
    
    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 10)
    welcomeCorner.Parent = welcomeNotification
    
    -- Animación de entrada
    welcomeNotification.Size = UDim2.new(0, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(welcomeNotification, tweenInfo, {
        Size = UDim2.new(0, 350, 0, 80)
    })
    tween:Play()
    
    -- Eliminar después de 5 segundos
    game:GetService("Debris"):AddItem(welcomeNotification, 5)
end)

-- Función para mostrar controles
local function showControls()
    local controlsNotification = Instance.new("TextLabel")
    controlsNotification.Size = UDim2.new(0, 300, 0, 120)
    controlsNotification.Position = UDim2.new(0.5, -150, 0, 150)
    controlsNotification.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    controlsNotification.Text = "🎮 CONTROLES:\nF - Abrir/Cerrar Panel\nT - Float Part\nWASD - Float Mode\nCtrl+E - Emergencia"
    controlsNotification.TextColor3 = Color3.fromRGB(255, 255, 255)
    controlsNotification.TextScaled = true
    controlsNotification.Font = Enum.Font.Gotham
    controlsNotification.Parent = screenGui
    
    local controlsCorner = Instance.new("UICorner")
    controlsCorner.CornerRadius = UDim.new(0, 10)
    controlsCorner.Parent = controlsNotification
    
    game:GetService("Debris"):AddItem(controlsNotification, 4)
end

-- Botón de ayuda en el panel
local helpButton = Instance.new("TextButton")
helpButton.Name = "HelpButton"
helpButton.Size = UDim2.new(0.9, 0, 0, 25)
helpButton.Position = UDim2.new(0.05, 0, 0, 440)
helpButton.BackgroundColor3 = Color3.fromRGB(85, 85, 255)
helpButton.Text = "❓ Mostrar Controles"
helpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
helpButton.TextScaled = true
helpButton.Font = Enum.Font.Gotham
helpButton.Parent = mainFrame

local helpCorner = Instance.new("UICorner")
helpCorner.CornerRadius = UDim.new(0, 5)
helpCorner.Parent = helpButton

helpButton.MouseButton1Click:Connect(showControls)

-- Sistema de auto-guardado de configuración
local function saveConfig()
    -- Aquí podrías implementar un sistema de guardado si lo necesitas
    -- Por ahora solo mantenemos la configuración en memoria
end

local function loadConfig()
    -- Aquí podrías cargar configuración guardada
    -- Por ahora usamos valores por defecto
end

-- Cargar configuración al inicio
loadConfig()

print("🚀 Float & Fly Panel v2.0 - Cargado exitosamente!")
print("📋 Controles:")
print("   F - Abrir/Cerrar Panel")
print("   T - Activar/Desactivar Float Part")
print("   WASD - Controlar Float Mode")
print("   Ctrl+E - Limpieza de emergencia")
print("🛡️ Características:")
print("   ✅ Float Part con seguimiento")
print("   ✅ Float Mode suave con WASD")
print("   ✅ Sistema de guardado de estado")
print("   ✅ Vuelo automático con cápsula protectora")
print("   ✅ God Mode sutil anti-detección")
print("   ✅ Configuración ajustable con sliders")
print("   ✅ Efectos visuales rainbow")
print("   ✅ Sistema de emergencia")
