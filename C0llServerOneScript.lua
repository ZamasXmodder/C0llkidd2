local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables globales
local rainbowPart = nil
local targetPoint = nil
local transportParts = {}
local isTransporting = false
local flyMode = false
local flyConnection = nil
local ladderPart = nil
local climbAnimationTrack = nil
local floatSpeed = 50 -- Velocidad de flote por defecto

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 310)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Panel Rainbow"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Botón para activar/desactivar caminar
local walkButton = Instance.new("TextButton")
walkButton.Size = UDim2.new(0.9, 0, 0, 30)
walkButton.Position = UDim2.new(0.05, 0, 0, 40)
walkButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
walkButton.Text = "Activar Caminar Rainbow"
walkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
walkButton.TextScaled = true
walkButton.Font = Enum.Font.SourceSans
walkButton.Parent = frame

-- Botón para establecer punto
local setPointButton = Instance.new("TextButton")
setPointButton.Size = UDim2.new(0.9, 0, 0, 30)
setPointButton.Position = UDim2.new(0.05, 0, 0, 80)
setPointButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
setPointButton.Text = "Establecer Punto"
setPointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setPointButton.TextScaled = true
setPointButton.Font = Enum.Font.SourceSans
setPointButton.Parent = frame

-- Botón para ir al punto
local goToPointButton = Instance.new("TextButton")
goToPointButton.Size = UDim2.new(0.9, 0, 0, 30)
goToPointButton.Position = UDim2.new(0.05, 0, 0, 120)
goToPointButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
goToPointButton.Text = "Ir al Punto"
goToPointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
goToPointButton.TextScaled = true
goToPointButton.Font = Enum.Font.SourceSans
goToPointButton.Parent = frame

-- Botón para modo escalera/vuelo
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0, 160)
flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
flyButton.Text = "Activar Modo Escalera"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.SourceSans
flyButton.Parent = frame

-- Slider de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad de Flote: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = frame

local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
speedSliderFrame.Position = UDim2.new(0.05, 0, 0, 225)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedSliderFrame.BorderSizePixel = 1
speedSliderFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
speedSliderFrame.Parent = frame

local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 20, 1, 0)
speedSlider.Position = UDim2.new((floatSpeed - 20) / 80, -10, 0, 0) -- Escala de 20-100
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
speedSlider.Text = ""
speedSlider.Parent = speedSliderFrame

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0, 250)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Listo"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame

-- Instrucciones de vuelo
local flyInstructions = Instance.new("TextLabel")
flyInstructions.Size = UDim2.new(0.9, 0, 0, 20)
flyInstructions.Position = UDim2.new(0.05, 0, 0, 275)
flyInstructions.BackgroundTransparency = 1
flyInstructions.Text = "WASD + Space/Shift para volar"
flyInstructions.TextColor3 = Color3.fromRGB(200, 200, 200)
flyInstructions.TextScaled = true
flyInstructions.Font = Enum.Font.SourceSans
flyInstructions.Visible = false
flyInstructions.Parent = frame

-- Función para crear animación de escalada
local function createClimbAnimation()
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://507765644" -- ID de animación de escalada
    
    climbAnimationTrack = humanoid:LoadAnimation(animation)
    climbAnimationTrack.Looped = true
    climbAnimationTrack.Priority = Enum.AnimationPriority.Action
    
    return climbAnimationTrack
end

-- Función para activar ragdoll
local function enableRagdoll()
    for _, joint in pairs(character:GetDescendants()) do
        if joint:IsA("Motor6D") then
            local attachment0 = Instance.new("Attachment")
            local attachment1 = Instance.new("Attachment")
            
            attachment0.Parent = joint.Part0
            attachment1.Parent = joint.Part1
            
            attachment0.CFrame = joint.C0
            attachment1.CFrame = joint.C1
            
            local ballSocket = Instance.new("BallSocketConstraint")
            ballSocket.Attachment0 = attachment0
            ballSocket.Attachment1 = attachment1
            ballSocket.Parent = joint.Part0
            
            joint.Enabled = false
        end
    end
    humanoid.PlatformStand = true
end

-- Función para desactivar ragdoll
local function disableRagdoll()
    for _, constraint in pairs(character:GetDescendants()) do
        if constraint:IsA("BallSocketConstraint") then
            constraint:Destroy()
        end
    end
    
    for _, attachment in pairs(character:GetDescendants()) do
        if attachment:IsA("Attachment") and attachment.Parent ~= rootPart then
            attachment:Destroy()
        end
    end
    
    for _, joint in pairs(character:GetDescendants()) do
        if joint:IsA("Motor6D") then
            joint.Enabled = true
        end
    end
    
    humanoid.PlatformStand = false
end

-- Función para verificar si hay obstáculos entre dos puntos
local function isPathClear(startPos, endPos)
    local direction = (endPos - startPos).Unit
    local distance = (endPos - startPos).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character, rainbowPart}
    
    -- Hacer múltiples raycasts para verificar el camino
    for i = 0, distance, 2 do
        local currentPos = startPos + direction * i
        local rayResult = workspace:Raycast(currentPos, direction * 2, raycastParams)
        
        if rayResult and rayResult.Instance.CanCollide then
            return false
        end
    end
    
    return true
end

-- Función para crear part rainbow
local function createRainbowPart()
    if rainbowPart then
        rainbowPart:Destroy()
    end
    
    rainbowPart = Instance.new("Part")
    rainbowPart.Name = "RainbowWalkPart"
    rainbowPart.Size = Vector3.new(6, 0.5, 6)
    rainbowPart.Material = Enum.Material.Neon
    rainbowPart.Anchored = true
    rainbowPart.CanCollide = true
    rainbowPart.Parent = workspace
    
    -- Efecto rainbow
    local hue = 0
    local rainbowConnection
    rainbowConnection = RunService.Heartbeat:Connect(function()
        if rainbowPart and rainbowPart.Parent then
            hue = (hue + 2) % 360
            rainbowPart.Color = Color3.fromHSV(hue / 360, 1, 1)
            
            -- Posicionar debajo del jugador
            local newPosition = rootPart.Position - Vector3.new(0, 3, 0)
            rainbowPart.Position = newPosition
        else
            rainbowConnection:Disconnect()
        end
    end)
end

-- Función mejorada para crear escalera invisible con animación de escalada
local function createLadder()
    if ladderPart then
        ladderPart:Destroy()
    end
    
    ladderPart = Instance.new("TrussPart")
    ladderPart.Name = "InvisibleLadder"
    ladderPart.Size = Vector3.new(4, 20, 1)
    ladderPart.Material = Enum.Material.ForceField
    ladderPart.Transparency = 0.3
    ladderPart.Color = Color3.fromRGB(0, 255, 255)
    ladderPart.Anchored = true
    ladderPart.CanCollide = true
    ladderPart.Parent = workspace
    
    -- Crear y reproducir animación de escalada
    if not climbAnimationTrack then
        createClimbAnimation()
    end
    
    -- Posicionar la escalera
    local ladderConnection
    ladderConnection = RunService.Heartbeat:Connect(function()
        if ladderPart and ladderPart.Parent and flyMode then
            ladderPart.Position = rootPart.Position
            
            -- Reproducir animación cuando el jugador esté escalando
            local isClimbing = UserInputService:IsKeyDown(Enum.KeyCode.Space) or 
                              UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            
            if isClimbing and climbAnimationTrack and not climbAnimationTrack.IsPlaying then
                climbAnimationTrack:Play()
            elseif not isClimbing and climbAnimationTrack and climbAnimationTrack.IsPlaying then
                climbAnimationTrack:Stop()
            end
        elseif not flyMode then
            if climbAnimationTrack and climbAnimationTrack.IsPlaying then
                climbAnimationTrack:Stop()
            end
            ladderConnection:Disconnect()
        end
    end)
end

-- Función para modo vuelo mejorado
local function toggleFlyMode()
    flyMode = not flyMode
    
    if flyMode then
        createLadder()
        humanoid.PlatformStand = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        flyButton.Text = "Desactivar Modo Escalera"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
        flyInstructions.Visible = true
        statusLabel.Text = "Modo vuelo activado - Usa Space/Shift para subir/bajar"
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyMode then return end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            local speed = 60 -- Velocidad aumentada
            
            -- Obtener dirección de la cámara
            local cameraCFrame = camera.CFrame
            local forward = cameraCFrame.LookVector
            local right = cameraCFrame.RightVector
            
            -- Controles de movimiento
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            -- Aplicar velocidad
            if bodyVelocity then
                bodyVelocity.Velocity = moveVector * speed
            end
        end)
        
    else
        humanoid.PlatformStand = false
        
        if ladderPart then
            ladderPart:Destroy()
            ladderPart = nil
        end
        
        if climbAnimationTrack then
            climbAnimationTrack:Stop()
        end
        
        local bodyVelocity = rootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        flyButton.Text = "Activar Modo Escalera"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
        flyInstructions.Visible = false
        statusLabel.Text = "Modo vuelo desactivado"
    end
end

-- Función para limpiar parts de transporte
local function cleanupTransportParts()
    for _, part in pairs(transportParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    transportParts = {}
end

-- Función de flote suave para ir al punto con ragdoll
local function goToEstablishedPoint()
    if not targetPoint then
        statusLabel.Text = "No hay punto establecido"
        return
    end
    
    if isTransporting then
        statusLabel.Text = "Ya transportando..."
        return
    end
    
    isTransporting = true
    statusLabel.Text = "Iniciando flote hacia el punto..."
    
    cleanupTransportParts()
    
    -- Activar ragdoll al iniciar el transporte
    enableRagdoll()
    
    -- Crear 6 parts suaves que flotan alrededor del jugador
    local partCount = 6
    local radius = 3
    
    for i = 1, partCount do
        local part = Instance.new("Part")
        part.Name = "FloatPart" .. i
        part.Size = Vector3.new(1.2, 1.2, 1.2)
        part.Material = Enum.Material.ForceField
        part.Color = Color3.fromHSV((i-1) / partCount, 0.7, 1)
        part.Anchored = true
        part.CanCollide = false
        part.Shape = Enum.PartType.Ball
        part.Transparency = 0.3
        part.Parent = workspace
        
        local angle = (i-1) * (360 / partCount)
        local offset = Vector3.new(
            math.cos(math.rad(angle)) * radius,
            math.sin(i * 0.8) * 1.5, -- Movimiento vertical suave
            math.sin(math.rad(angle)) * radius
        )
        part.Position = rootPart.Position + offset
        
        table.insert(transportParts, part)
    end
    
    -- Crear BodyPosition para controlar el movimiento suave
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.Position = rootPart.Position
    bodyPosition.D = 2000 -- Amortiguación para suavidad
    bodyPosition.P = 8000 -- Potencia
    bodyPosition.Parent = rootPart
    
    local startPos = rootPart.Position
    local endPos = targetPoint
    local totalDistance = (endPos - startPos).Magnitude
    local totalTime = totalDistance / floatSpeed
    
    statusLabel.Text = string.format("Flotando %.0f metros... (Ragdoll)", totalDistance)
    
    -- Efecto de partículas flotantes durante el transporte
    local floatTime = 0
    local effectConnection = RunService.Heartbeat:Connect(function(deltaTime)
        floatTime = floatTime + deltaTime
        
        -- Actualizar posición del jugador gradualmente
        local progress = math.min(floatTime / totalTime, 1)
        local currentPos = startPos:Lerp(endPos, progress)
        bodyPosition.Position = currentPos + Vector3.new(0, 2, 0) -- Flotar ligeramente arriba
        
        -- Actualizar partículas flotantes
        for i, part in pairs(transportParts) do
            if part and part.Parent then
                local angle = (i-1) * (360 / partCount) + (floatTime * 30)
                local bobbing = math.sin(floatTime * 2 + i) * 1
                local offset = Vector3.new(
                    math.cos(math.rad(angle)) * radius,
                    bobbing,
                    math.sin(math.rad(angle)) * radius
                )
                part.Position = currentPos + offset
                
                -- Cambiar color suavemente
                part.Color = Color3.fromHSV(((floatTime * 60 + i * 60) % 360) / 360, 0.7, 1)
            end
        end
        
        -- Verificar si llegamos al destino
        if progress >= 1 then
            effectConnection:Disconnect()
            
            -- Desactivar ragdoll al llegar
            disableRagdoll()
            
            bodyPosition:Destroy()
            cleanupTransportParts()
            isTransporting = false
            statusLabel.Text = "¡Flote completado!"
            
            -- Efecto de llegada suave
            local arrivalPart = Instance.new("Part")
            arrivalPart.Name = "ArrivalEffect"
            arrivalPart.Size = Vector3.new(6, 0.2, 6)
            arrivalPart.Material = Enum.Material.ForceField
            arrivalPart.Color = Color3.fromRGB(100, 255, 100)
            arrivalPart.Anchored = true
            arrivalPart.CanCollide = false
            arrivalPart.Position = endPos - Vector3.new(0, 2, 0)
            arrivalPart.Transparency = 0.5
            arrivalPart.Parent = workspace
            
            -- Tween para desvanecer el efecto de llegada
            local fadeTween = TweenService:Create(
                arrivalPart,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Transparency = 1, Size = Vector3.new(12, 0.1, 12)}
            )
            
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                arrivalPart:Destroy()
            end)
        end
    end)
end

-- Función para manejar el slider de velocidad
local function setupSpeedSlider()
    local dragging = false
    
    speedSlider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local frameSize = speedSliderFrame.AbsoluteSize.X
            local mousePos = input.Position.X - speedSliderFrame.AbsolutePosition.X
            local percentage = math.clamp(mousePos / frameSize, 0, 1)
            
            speedSlider.Position = UDim2.new(percentage, -10, 0, 0)
            floatSpeed = math.floor(20 + (percentage * 80)) -- Rango de 20 a 100
            speedLabel.Text = "Velocidad de Flote: " .. floatSpeed
        end
    end)
end

-- Eventos de botones
local walkActive = false
walkButton.MouseButton1Click:Connect(function()
    walkActive = not walkActive
    if walkActive then
        createRainbowPart()
        walkButton.Text = "Desactivar Caminar Rainbow"
        walkButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        statusLabel.Text = "Caminar Rainbow activado"
    else
        if rainbowPart then
            rainbowPart:Destroy()
            rainbowPart = nil
        end
        walkButton.Text = "Activar Caminar Rainbow"
        walkButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "Caminar Rainbow desactivado"
    end
end)

setPointButton.MouseButton1Click:Connect(function()
    targetPoint = rootPart.Position
    statusLabel.Text = "Punto establecido - Listo para flote con ragdoll"
    
    -- Efecto visual al establecer punto
    local pointMarker = Instance.new("Part")
    pointMarker.Name = "PointMarker"
    pointMarker.Size = Vector3.new(4, 8, 4)
    pointMarker.Material = Enum.Material.ForceField
    pointMarker.Color = Color3.fromRGB(255, 255, 0)
    pointMarker.Anchored = true
    pointMarker.CanCollide = false
    pointMarker.Position = targetPoint + Vector3.new(0, 4, 0)
    pointMarker.Parent = workspace
    
    -- Efecto de pulso
    local pulseTween = TweenService:Create(
        pointMarker,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Size = Vector3.new(6, 10, 6), Transparency = 0.5}
    )
    
    pulseTween:Play()
    
    -- Eliminar el marcador después de 3 segundos
    task.wait(3)
    pulseTween:Cancel()
    pointMarker:Destroy()
end)

goToPointButton.MouseButton1Click:Connect(function()
    goToEstablishedPoint()
end)

flyButton.MouseButton1Click:Connect(function()
    toggleFlyMode()
end)

-- Configurar el slider de velocidad
setupSpeedSlider()

-- Limpiar al morir o cambiar de personaje
character.Humanoid.Died:Connect(function()
    if rainbowPart then
        rainbowPart:Destroy()
    end
    if climbAnimationTrack then
        climbAnimationTrack:Stop()
    end
    cleanupTransportParts()
    if flyMode then
        toggleFlyMode()
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Recrear animación de escalada para el nuevo personaje
    climbAnimationTrack = nil
    
    -- Reconectar eventos de muerte
    character.Humanoid.Died:Connect(function()
        if rainbowPart then
            rainbowPart:Destroy()
        end
        if climbAnimationTrack then
            climbAnimationTrack:Stop()
        end
        cleanupTransportParts()
        if flyMode then
            toggleFlyMode()
        end
    end)
end)
