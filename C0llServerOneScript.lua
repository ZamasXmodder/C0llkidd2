-- Panel GUI de administración para Steal a Brainrot

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables de estado
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local isFloating = false
local isFrozen = false
local bodyVelocity = nil
local bodyPosition = nil
local frozenPosition = nil
local instantGrab = false
local autoEquip = false
local noclipEnabled = false
local autoBlock = false

-- Variables para noclip
local noclipConnections = {}

-- Variables para autobloqueo
local autoBlockConnection = nil
local baseBlockParts = {}

-- Configuración de velocidades y teletransporte
local FLOAT_SPEED = 25
local FROZEN_SPEED = 3
local KNOCKBACK_FORCE = 150
local TELEPORT_HEIGHT = 45

-- Configuración de teclas para movimiento
local FORWARD_KEY = Enum.KeyCode.W
local UP_KEY = Enum.KeyCode.Q
local DOWN_KEY = Enum.KeyCode.E

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 600)
mainFrame.Position = UDim2.new(0, 10, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas para el panel principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Admin Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de toggle (abrir/cerrar)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Panel"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton

-- Contenedor de controles
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "Controls"
controlsFrame.Size = UDim2.new(1, -20, 1, -60)
controlsFrame.Position = UDim2.new(0, 10, 0, 50)
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = mainFrame

-- Layout para organizar controles
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = controlsFrame

-- Función para crear botones
local function createButton(name, text, layoutOrder, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.LayoutOrder = layoutOrder
    button.Parent = controlsFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Función para crear slider
local function createSlider(name, text, minVal, maxVal, defaultVal, layoutOrder, callback)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = layoutOrder
    frame.Parent = controlsFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 18)
    sliderFrame.Position = UDim2.new(0, 0, 0, 22)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 9)
    sliderCorner.Parent = sliderFrame
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 18, 1, 0)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -9, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 9)
    buttonCorner.Parent = sliderButton
    
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
            local relativeX = mouse.X - sliderFrame.AbsolutePosition.X
            local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -9, 0, 0)
            
            local value = math.floor(minVal + (maxVal - minVal) * percentage)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return frame
end

-- Variables para los botones
local floatButton, freezeButton, instantGrabButton, autoEquipButton, noclipButton, autoBlockButton

-- Función para teletransporte hacia arriba
local function teleportUp()
    if rootPart then
        local currentPosition = rootPart.Position
        local newPosition = currentPosition + Vector3.new(0, TELEPORT_HEIGHT, 0)
        
        -- Crear efecto visual
        local teleportEffect = Instance.new("Part")
        teleportEffect.Name = "TeleportEffect"
        teleportEffect.Size = Vector3.new(4, 8, 4)
        teleportEffect.Position = currentPosition
        teleportEffect.Anchored = true
        teleportEffect.CanCollide = false
        teleportEffect.Transparency = 0.5
        teleportEffect.BrickColor = BrickColor.new("Bright blue")
        teleportEffect.Material = Enum.Material.Neon
        teleportEffect.Shape = Enum.PartType.Cylinder
        teleportEffect.Parent = workspace
        
        -- Efecto de rotación
        local spin = Instance.new("BodyAngularVelocity")
        spin.AngularVelocity = Vector3.new(0, 10, 0)
        spin.MaxTorque = Vector3.new(0, math.huge, 0)
        spin.Parent = teleportEffect
        
        -- Teletransportar
        rootPart.CFrame = CFrame.new(newPosition, newPosition + rootPart.CFrame.LookVector)
        
        -- Crear efecto en la nueva posición
        local arrivalEffect = teleportEffect:Clone()
        arrivalEffect.Position = newPosition
        arrivalEffect.Parent = workspace
        
        -- Limpiar efectos después de 2 segundos
        game:GetService("Debris"):AddItem(teleportEffect, 2)
        game:GetService("Debris"):AddItem(arrivalEffect, 2)
        
        print("Teletransportado " .. TELEPORT_HEIGHT .. " studs hacia arriba")
    end
end

-- Función para encontrar la base del jugador
local function findPlayerBase()
    local bases = {}
    
    -- Buscar en workspace por estructuras que parezcan bases
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            -- Buscar por nombres comunes de bases
            local name = obj.Name:lower()
            if name:find("base") or name:find("house") or name:find("home") or 
               name:find("spawn") or name:find("plot") then
                
                -- Verificar si tiene partes sólidas
                                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        table.insert(bases, part)
                    end
                end
            end
        elseif obj:IsA("BasePart") then
            -- Buscar partes individuales que puedan ser de la base
            local name = obj.Name:lower()
            if name:find("base") or name:find("floor") or name:find("wall") or
               name:find("foundation") or name:find("platform") then
                table.insert(bases, obj)
            end
        end
    end
    
    -- Si no encuentra bases específicas, buscar partes grandes cerca del spawn
    if #bases == 0 then
        local spawnLocation = workspace.SpawnLocation or workspace:FindFirstChild("Spawn")
        if spawnLocation then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj ~= spawnLocation then
                    local distance = (obj.Position - spawnLocation.Position).Magnitude
                    local size = obj.Size.Magnitude
                    
                    -- Si es una parte grande cerca del spawn, probablemente sea parte de la base
                    if distance < 100 and size > 10 and obj.CanCollide then
                        table.insert(bases, obj)
                    end
                end
            end
        end
    end
    
    return bases
end

-- Función para bloquear base automáticamente
local function blockBase()
    if not autoBlock then return end
    
    for _, part in pairs(baseBlockParts) do
        if part and part.Parent then
            -- Crear barrera invisible
            local barrier = Instance.new("Part")
            barrier.Name = "AutoBlockBarrier_" .. part.Name
            barrier.Size = part.Size + Vector3.new(2, 2, 2)
            barrier.Position = part.Position
            barrier.Anchored = true
            barrier.CanCollide = true
            barrier.Transparency = 0.8
            barrier.BrickColor = BrickColor.new("Really red")
            barrier.Material = Enum.Material.ForceField
            barrier.Parent = workspace
            
            -- Hacer que solo otros jugadores no puedan pasar
            local function onTouched(hit)
                local humanoidHit = hit.Parent:FindFirstChild("Humanoid")
                if humanoidHit then
                    local playerHit = Players:GetPlayerFromCharacter(hit.Parent)
                    if playerHit and playerHit ~= player then
                        -- Empujar al jugador lejos de la base
                        local humanoidRootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local direction = (humanoidRootPart.Position - part.Position).Unit
                            local pushForce = Instance.new("BodyVelocity")
                            pushForce.MaxForce = Vector3.new(4000, 0, 4000)
                            pushForce.Velocity = direction * 50
                            pushForce.Parent = humanoidRootPart
                            
                            game:GetService("Debris"):AddItem(pushForce, 0.5)
                        end
                    end
                end
            end
            
            barrier.Touched:Connect(onTouched)
            
            -- Eliminar barrera después de un tiempo
            game:GetService("Debris"):AddItem(barrier, 30)
        end
    end
end

-- Función para toggle de autobloqueo de base
local function toggleAutoBlock()
    autoBlock = not autoBlock
    
    if autoBlock then
        autoBlockButton.Text = "Auto-Block: ON"
        autoBlockButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        
        -- Encontrar partes de la base
        baseBlockParts = findPlayerBase()
        
        if #baseBlockParts > 0 then
            print("Auto-Block activado - " .. #baseBlockParts .. " partes de base detectadas")
            
            -- Crear conexión para bloquear automáticamente
            autoBlockConnection = RunService.Heartbeat:Connect(function()
                -- Verificar si hay jugadores cerca de la base
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character then
                        local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if otherRoot then
                            -- Verificar distancia a cualquier parte de la base
                            for _, basePart in pairs(baseBlockParts) do
                                if basePart and basePart.Parent then
                                    local distance = (otherRoot.Position - basePart.Position).Magnitude
                                    if distance < 20 then -- Si está cerca de la base
                                        blockBase()
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        else
            print("No se detectaron partes de base automáticamente")
            autoBlock = false
            autoBlockButton.Text = "Auto-Block: OFF"
            autoBlockButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
    else
        autoBlockButton.Text = "Auto-Block: OFF"
        autoBlockButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        
        if autoBlockConnection then
            autoBlockConnection:Disconnect()
            autoBlockConnection = nil
        end
        
        -- Limpiar barreras existentes
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name:find("AutoBlockBarrier_") then
                obj:Destroy()
            end
        end
        
        print("Auto-Block desactivado")
    end
end

-- Función para activar/desactivar noclip
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipButton.Text = "NoClip: ON"
        noclipButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Función para hacer noclip en una parte
        local function noclipPart(part)
            if part and part.Parent then
                part.CanCollide = false
                
                -- Crear conexión para mantener CanCollide en false
                local connection = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                    if noclipEnabled then
                        part.CanCollide = false
                    end
                end)
                
                table.insert(noclipConnections, connection)
            end
        end
        
        -- Aplicar noclip a todas las partes del personaje
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    noclipPart(part)
                end
            end
        end
        
        -- Conexión para nuevas partes que se agreguen
        local newPartConnection = character.ChildAdded:Connect(function(child)
            if child:IsA("BasePart") and noclipEnabled then
                wait(0.1)
                noclipPart(child)
            end
        end)
        
        table.insert(noclipConnections, newPartConnection)
        
        print("NoClip activado - Antireversible")
    else
        noclipButton.Text = "NoClip: OFF"
        noclipButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        
        -- Desconectar todas las conexiones de noclip
        for _, connection in pairs(noclipConnections) do
            if connection then
                connection:Disconnect()
            end
        end
        noclipConnections = {}
        
        -- Restaurar colisiones
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        print("NoClip desactivado")
    end
end

-- Función para auto-equipar todas las tools
local function autoEquipAllTools()
    if not autoEquip then return end
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            humanoid:EquipTool(tool)
            wait(0.1) -- Pequeña pausa entre equipamientos
        end
    end
end

-- Función para toggle de auto-equipar
local function toggleAutoEquip()
    autoEquip = not autoEquip
    
    if autoEquip then
        autoEquipButton.Text = "Auto-Equip: ON"
        autoEquipButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        print("Auto-equipar activado - Las tools se equiparán automáticamente")
    else
        autoEquipButton.Text = "Auto-Equip: OFF"
        autoEquipButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        print("Auto-equipar desactivado")
    end
end

-- Función para activar/desactivar flotación
local function toggleFloat()
    if not isFloating then
        isFloating = true
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        floatButton.Text = "Desactivar Float"
        floatButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        isFloating = false
        
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        
        floatButton.Text = "Activar Float"
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end
end

-- Función para congelar/descongelar personaje
local function toggleFreeze()
    if not isFrozen then
        isFrozen = true
        frozenPosition = rootPart.Position
        
        bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = frozenPosition
        bodyPosition.Parent = rootPart
        
        humanoid.PlatformStand = true
        
        freezeButton.Text = "Descongelar"
        freezeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        isFrozen = false
        frozenPosition = nil
        
        if bodyPosition then
            bodyPosition:Destroy()
            bodyPosition = nil
        end
        
        humanoid.PlatformStand = false
        
        freezeButton.Text = "Congelar"
        freezeButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end
end

-- Función para toggle de agarrar instantáneo
local function toggleInstantGrab()
    instantGrab = not instantGrab
    
    if instantGrab then
        instantGrabButton.Text = "Grab Instantáneo: ON"
        instantGrabButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Modificar todos los ProximityPrompts existentes
        for _, descendant in pairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                descendant.HoldDuration = 0
            end
        end
        
        print("Grab instantáneo activado - Todos los brainrots se agarran al instante")
    else
                instantGrabButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        print("Grab instantáneo desactivado")
    end
end

-- Función para lanzar a todos los jugadores
local function launchAllPlayers()
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if otherRoot then
                local direction = (otherRoot.Position - rootPart.Position).Unit
                
                local bodyVel = Instance.new("BodyVelocity")
                bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
                
                local launchDirection = direction + Vector3.new(0, 0.5, 0)
                bodyVel.Velocity = launchDirection.Unit * KNOCKBACK_FORCE
                bodyVel.Parent = otherRoot
                
                game:GetService("Debris"):AddItem(bodyVel, 1)
            end
        end
    end
end

-- Función para hacer el bate lanzador
local function makeBatLauncher()
    local function setupBat(tool)
        if tool.Name:lower():find("bat") or tool.Name:lower():find("bate") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local connection
                connection = tool.Activated:Connect(function()
                    launchAllPlayers()
                end)
                
                tool.Unequipped:Connect(function()
                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end
    end
    
    for _, tool in pairs(player.Backpack:GetChildren()) do
        setupBat(tool)
    end
    
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                setupBat(tool)
            end
        end
    end
    
    player.Backpack.ChildAdded:Connect(setupBat)
    if character then
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                setupBat(child)
            end
        end)
    end
end

-- Crear controles del panel
floatButton = createButton("FloatButton", "Activar Float", 1, toggleFloat)
freezeButton = createButton("FreezeButton", "Congelar", 2, toggleFreeze)
instantGrabButton = createButton("InstantGrabButton", "Grab Instantáneo: OFF", 3, toggleInstantGrab)
autoEquipButton = createButton("AutoEquipButton", "Auto-Equip: OFF", 4, toggleAutoEquip)
noclipButton = createButton("NoclipButton", "NoClip: OFF", 5, toggleNoclip)
autoBlockButton = createButton("AutoBlockButton", "Auto-Block: OFF", 6, toggleAutoBlock)

-- Nuevo botón de teletransporte
createButton("TeleportUpButton", "Teleport +45 Studs", 7, teleportUp)

createSlider("FrozenSpeed", "Velocidad Congelado", 1, 20, FROZEN_SPEED, 8, function(value)
    FROZEN_SPEED = value
end)

createSlider("FloatSpeed", "Velocidad Float", 10, 50, FLOAT_SPEED, 9, function(value)
    FLOAT_SPEED = value
end)

createSlider("KnockbackForce", "Fuerza Bate", 50, 300, KNOCKBACK_FORCE, 10, function(value)
    KNOCKBACK_FORCE = value
end)

-- Nuevo slider para altura de teletransporte
createSlider("TeleportHeight", "Altura Teleport", 10, 100, TELEPORT_HEIGHT, 11, function(value)
    TELEPORT_HEIGHT = value
end)

createButton("LaunchButton", "Lanzar Todos", 12, launchAllPlayers)

-- Función para bloqueo manual de base
local function manualBlockBase()
    -- Encontrar partes de la base si no están definidas
    if #baseBlockParts == 0 then
        baseBlockParts = findPlayerBase()
    end
    
    if #baseBlockParts > 0 then
        blockBase()
        print("Base bloqueada manualmente - " .. #baseBlockParts .. " barreras creadas")
    else
        print("No se encontraron partes de base para bloquear")
    end
end

-- Agregar botón de bloqueo manual
createButton("ManualBlockButton", "Bloquear Base Manual", 13, manualBlockBase)

-- Toggle del panel
local panelOpen = false

local function togglePanel()
    panelOpen = not panelOpen
    
    local targetPosition = panelOpen and UDim2.new(0, 10, 0.5, -300) or UDim2.new(0, -300, 0.5, -300)
    
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = targetPosition}
    )
    
    mainFrame.Visible = true
    tween:Play()
    
    if not panelOpen then
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

toggleButton.MouseButton1Click:Connect(togglePanel)

-- Función para movimiento con W + cámara
local function handleCameraMovement()
    if not (isFloating or isFrozen) then return end
    
    local camera = workspace.CurrentCamera
    local isMoving = UserInputService:IsKeyDown(FORWARD_KEY)
    local isGoingUp = UserInputService:IsKeyDown(UP_KEY)
    local isGoingDown = UserInputService:IsKeyDown(DOWN_KEY)
    
    if isFloating and bodyVelocity then
        local velocity = Vector3.new(0, 0, 0)
        
        if isMoving then
            local cameraCFrame = camera.CFrame
            local forward = cameraCFrame.LookVector
            velocity = velocity + (forward * FLOAT_SPEED)
        end
        
        if isGoingUp then
            velocity = velocity + Vector3.new(0, FLOAT_SPEED, 0)
        end
        
        if isGoingDown then
            velocity = velocity + Vector3.new(0, -FLOAT_SPEED, 0)
        end
        
        bodyVelocity.Velocity = velocity
        
    elseif isFrozen and bodyPosition then
        local moveVector = Vector3.new(0, 0, 0)
        
        if isMoving then
            local cameraCFrame = camera.CFrame
            local forward = cameraCFrame.LookVector
            moveVector = moveVector + forward
        end
        
        if isGoingUp then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        
        if isGoingDown then
            moveVector = moveVector + Vector3.new(0, -1, 0)
        end
        
        if moveVector.Magnitude > 0 then
            frozenPosition = frozenPosition + (moveVector.Unit * FROZEN_SPEED)
            bodyPosition.Position = frozenPosition
        end
    end
end

-- Función para monitorear ProximityPrompts y auto-equipar
local function setupProximityPromptMonitoring()
    -- Modificar ProximityPrompts existentes
    local function modifyPrompt(prompt)
        if instantGrab then
            prompt.HoldDuration = 0
        end
    end
    
    -- Aplicar a todos los ProximityPrompts existentes
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            modifyPrompt(descendant)
        end
    end
    
    -- Monitorear nuevos ProximityPrompts
    workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            wait(0.1)
            modifyPrompt(descendant)
        end
    end)
    
    -- Monitorear cuando se activa un ProximityPrompt (agarrar brainrot)
    ProximityPromptService.PromptTriggered:Connect(function(prompt, playerWhoTriggered)
        if playerWhoTriggered == player and autoEquip then
            wait(0.2) -- Esperar a que se agregue la tool al backpack
            autoEquipAllTools()
        end
    end)
end

-- Función para aplicar noclip a personaje respawneado
local function setupNoclipForCharacter()
    if not noclipEnabled then return end
    
    wait(1) -- Esperar a que el personaje cargue completamente
    
    local function noclipPart(part)
        if part and part.Parent and noclipEnabled then
            part.CanCollide = false
            
            local connection = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
                if noclipEnabled then
                    part.CanCollide = false
                end
            end)
            
            table.insert(noclipConnections, connection)
        end
    end
    
    -- Aplicar a todas las partes del personaje
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            noclipPart(part)
        end
    end
    
    -- Monitorear nuevas partes
    local newPartConnection = character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") and noclipEnabled then
            wait(0.1)
            noclipPart(child)
        end
    end)
    
    table.insert(noclipConnections, newPartConnection)
end

-- Loop principal para movimiento
RunService.Heartbeat:Connect(function()
    handleCameraMovement()
end)

-- Configurar monitoreo inicial
setupProximityPromptMonitoring()
makeBatLauncher()

-- Reconfigurar cuando respawnee
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Resetear estados de movimiento
    isFloating = false
    isFrozen = false
    
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyPosition then bodyPosition:Destroy() bodyPosition = nil end
    
    -- Resetear botones de movimiento
    floatButton.Text = "Activar Float"
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    freezeButton.Text = "Congelar"
    freezeButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    
    -- Limpiar conexiones de noclip anteriores
    for _, connection in pairs(noclipConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    noclipConnections = {}
    
    -- Limpiar conexión de autobloqueo
    if autoBlockConnection then
        autoBlockConnection:Disconnect()
        autoBlockConnection = nil
    end
    
    -- Resetear autobloqueo
    if autoBlock then
        autoBlock = false
        autoBlockButton.Text = "Auto-Block: OFF"
        autoBlockButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end
    
    -- Limpiar barreras existentes
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("AutoBlockBarrier_") then
            obj:Destroy()
                end
    end
    
    -- Reconfigurar funciones
    wait(1)
    makeBatLauncher()
    setupProximityPromptMonitoring()
    setupNoclipForCharacter()
end)

-- Información de controles
print("=== PANEL GUI COMPLETO CON TELETRANSPORTE ===")
print("Botón 'Panel' - Abrir/Cerrar GUI")
print("W - Mover hacia donde mira la cámara")
print("Q/E - Subir/Bajar")
print("Funciones disponibles:")
print("• Float - Flotación con cámara")
print("• Congelar - Movimiento congelado")
print("• Grab Instantáneo - Brainrots sin espera")
print("• Auto-Equip - Equipar tools automáticamente")
print("• NoClip - Atravesar paredes (antireversible)")
print("• Auto-Block - Bloquear base automáticamente")
print("• Teleport +45 Studs - Teletransporte hacia arriba")
print("• Bloquear Base Manual - Bloqueo inmediato")
print("• Lanzar Todos - Bate lanzador")
print("• Sliders - Velocidades y altura personalizables")
print("==============================================")
