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

-- Variables de vuelo
local flyDirection = Vector3.new(0, 0, 0)
local keysPressed = {}

-- Variables de estado guardado
local savedPosition = nil
local isGoingToSavedState = false

-- Configuración por defecto
local config = {
    floatSpeed = 16,
    jumpPower = 50,
    walkSpeed = 16,
    flySpeed = 20,
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
mainFrame.Size = UDim2.new(0, 250, 0, 420)
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

-- Botón de activar/desactivar fly
local toggleFlyButton = Instance.new("TextButton")
toggleFlyButton.Name = "ToggleFly"
toggleFlyButton.Size = UDim2.new(0.9, 0, 0, 30)
toggleFlyButton.Position = UDim2.new(0.05, 0, 0, 90)
toggleFlyButton.BackgroundColor3 = Color3.fromRGB(255, 85, 255)
toggleFlyButton.Text = "Fly Mode (WASD)"
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
createSlider("Float Speed", 170, 1, 50, config.floatSpeed, function(value)
    config.floatSpeed = value
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

createSlider("Fly Speed", 335, 1, 100, config.flySpeed, function(value)
    config.flySpeed = value
end)

-- Función para protección contra muerte
local function enableGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            humanoid.Health = humanoid.MaxHealth
            
            -- Protección adicional
            if player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
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

-- Función para crear la part de vuelo rainbow
local function createFlyPart()
    if flyPart then
        flyPart:Destroy()
    end
    
    flyPart = Instance.new("Part")
    flyPart.Name = "FlyPart"
    flyPart.Size = Vector3.new(6, 0.5, 6)
    flyPart.Material = Enum.Material.ForceField
    flyPart.Transparency = 0.2
    flyPart.Anchored = true
    flyPart.CanCollide = true
    flyPart.Parent = workspace
    
    -- Efecto rainbow
    local hue = 0
    rainbowConnection = RunService.Heartbeat:Connect(function()
        hue = (hue + 1) % 360
        flyPart.Color = Color3.fromHSV(hue / 360, 1, 1)
    end)
    
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Adornee = flyPart
    selectionBox.LineThickness = 0.3
    selectionBox.Transparency = 0.3
    selectionBox.Parent = flyPart
    
    spawn(function()
        while flyPart and flyPart.Parent do
            selectionBox.Color3 = flyPart.Color
            wait(0.1)
        end
    end)
end

-- Función para forzar posición al estado guardado
local function forceToSavedPosition()
    if not savedPosition or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Teletransporte instantáneo y forzado
    humanoidRootPart.CFrame = CFrame.new(savedPosition)
    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    humanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    
    -- Asegurar que la fly part también esté en la posición correcta
    if isFlyActive and flyPart then
        flyPart.Position = savedPosition - Vector3.new(0, 2, 0)
    end
end

-- Función para ir al estado guardado
local function goToSavedState()
    if not savedPosition then

                -- Crear notificación si no hay estado guardado
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
        
        -- Eliminar notificación después de 2 segundos
        game:GetService("Debris"):AddItem(notification, 2)
        return
    end
    
    if not isFlyActive then
        -- Crear notificación si no está en modo fly
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 250, 0, 50)
        notification.Position = UDim2.new(0.5, -125, 0, 100)
        notification.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
        notification.Text = "¡Activa Fly Mode primero!"
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
    
    isGoingToSavedState = true
    goToStateButton.Text = "Yendo..."
    goToStateButton.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
    
    -- Conexión para forzar la posición constantemente
    if savedStateConnection then
        savedStateConnection:Disconnect()
    end
    
    savedStateConnection = RunService.Heartbeat:Connect(function()
        if isGoingToSavedState and savedPosition then
            forceToSavedPosition()
        end
    end)
    
    -- Detener después de 3 segundos o cuando llegue
    spawn(function()
        wait(3)
        isGoingToSavedState = false
        goToStateButton.Text = "Ir al Estado"
        goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
        
        if savedStateConnection then
            savedStateConnection:Disconnect()
            savedStateConnection = nil
        end
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
    
    -- Crear notificación de éxito
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(0.5, -100, 0, 100)
    notification.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
    notification.Text = "¡Estado guardado!"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    game:GetService("Debris"):AddItem(notification, 2)
    
    -- Restaurar texto del botón después de 2 segundos
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

-- Función para actualizar el vuelo
local function updateFly()
    if not isFlyActive or not flyPart or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
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
        
        -- Normalizar dirección
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end
        
        -- Mover la part y el jugador
        local targetPosition = flyPart.Position + (direction * config.flySpeed * 0.1)
        flyPart.Position = targetPosition
        
        -- Mantener al jugador en la part
        humanoidRootPart.CFrame = CFrame.new(flyPart.Position + Vector3.new(0, 2, 0))
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
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
        enableGodMode()
        
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
        
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        
        toggleFloatButton.Text = "Float Part (T)"
        toggleFloatButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    end
end

-- Función para activar/desactivar fly mode
local function toggleFlyMode()
    isFlyActive = not isFlyActive
    
    if isFlyActive then
        createFlyPart()
        toggleFlyButton.Text = "Desactivar Fly"
        toggleFlyButton.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
        
        flyConnection = RunService.Heartbeat:Connect(updateFly)
        enableGodMode()
        
        -- Posicionar la fly part inicialmente
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            flyPart.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
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
        
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        
        -- Detener ir al estado guardado si está activo
        if isGoingToSavedState then
            isGoingToSavedState = false
            goToStateButton.Text = "Ir al Estado"
            goToStateButton.BackgroundColor3 = Color3.fromRGB(170, 85, 170)
            
            if savedStateConnection then
                savedStateConnection:Disconnect()
                savedStateConnection = nil
            end
        end
        
        toggleFlyButton.Text = "Fly Mode (WASD)"
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
            Size = UDim2.new(0, 250, 0, 420),
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
    wait(1) -- Esperar a que el personaje se cargue
    
    if isFloatActive then
        createFloatPart()
        floatConnection = RunService.Heartbeat:Connect(updateFloatPart)
        enableGodMode()
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = config.jumpPower
            player.Character.Humanoid.WalkSpeed = config.walkSpeed
        end
    end
    
    if isFlyActive then
        createFlyPart()
        flyConnection = RunService.Heartbeat:Connect(updateFly)
        enableGodMode()
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            flyPart.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0, 2, 0)
        end
    end
end

-- Eventos de botones
toggleFloatButton.MouseButton1Click:Connect(toggleFloatPart)
toggleFlyButton.MouseButton1Click:Connect(toggleFlyMode)
saveStateButton.MouseButton1Click:Connect(saveCurrentState)
goToStateButton.MouseButton1Click:Connect(goToSavedState)

-- Input para controles
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Panel con F
    if input.KeyCode == Enum.KeyCode.F then
        togglePanel()
    end
    
    -- Float part con T
    if input.KeyCode == Enum.KeyCode.T then
        toggleFloatPart()
    end
    
    -- Controles de vuelo WASD
    if input.KeyCode == Enum.KeyCode.W or 
       input.KeyCode == Enum.KeyCode.A or 
       input.KeyCode == Enum.KeyCode.S or 
       input.KeyCode == Enum.KeyCode.D then
        keysPressed[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    -- Controles de vuelo WASD
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
        if floatConnection then floatConnection:Disconnect() end
        if flyConnection then flyConnection:Disconnect() end
        if rainbowConnection then rainbowConnection:Disconnect() end
        if godModeConnection then godModeConnection:Disconnect() end
        if savedStateConnection then savedStateConnection:Disconnect() end
    end
end)
