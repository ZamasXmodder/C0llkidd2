local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
local floatSpeed = 50

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 320)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
frame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Panel Rainbow"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Botón caminar rainbow
local walkButton = Instance.new("TextButton")
walkButton.Size = UDim2.new(0.9, 0, 0, 30)
walkButton.Position = UDim2.new(0.05, 0, 0, 40)
walkButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
walkButton.Text = "Activar Caminar Rainbow"
walkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
walkButton.TextScaled = true
walkButton.Font = Enum.Font.SourceSans
walkButton.Parent = frame

-- Botón establecer punto
local setPointButton = Instance.new("TextButton")
setPointButton.Size = UDim2.new(0.9, 0, 0, 30)
setPointButton.Position = UDim2.new(0.05, 0, 0, 80)
setPointButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
setPointButton.Text = "Establecer Punto"
setPointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
setPointButton.TextScaled = true
setPointButton.Font = Enum.Font.SourceSans
setPointButton.Parent = frame

-- Botón ir al punto
local goToPointButton = Instance.new("TextButton")
goToPointButton.Size = UDim2.new(0.9, 0, 0, 30)
goToPointButton.Position = UDim2.new(0.05, 0, 0, 120)
goToPointButton.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
goToPointButton.Text = "Ir al Punto"
goToPointButton.TextColor3 = Color3.fromRGB(255, 255, 255)
goToPointButton.TextScaled = true
goToPointButton.Font = Enum.Font.SourceSans
goToPointButton.Parent = frame

-- Botón escalera
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, 30)
flyButton.Position = UDim2.new(0.05, 0, 0, 160)
flyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
flyButton.Text = "Activar Modo Escalera"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.SourceSans
flyButton.Parent = frame

-- Label velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Parent = frame

-- Frame del slider
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
speedSliderFrame.Position = UDim2.new(0.05, 0, 0, 225)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedSliderFrame.BorderSizePixel = 1
speedSliderFrame.BorderColor3 = Color3.fromRGB(200, 200, 200)
speedSliderFrame.Parent = frame

-- Botón del slider
local speedSlider = Instance.new("TextButton")
speedSlider.Size = UDim2.new(0, 20, 1, 0)
speedSlider.Position = UDim2.new(0.375, -10, 0, 0) -- Posición inicial en el medio
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

-- Funciones
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
    
    local hue = 0
    local rainbowConnection = RunService.Heartbeat:Connect(function()
        if rainbowPart and rainbowPart.Parent then
            hue = (hue + 2) % 360
            rainbowPart.Color = Color3.fromHSV(hue / 360, 1, 1)
            rainbowPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
        else
            rainbowConnection:Disconnect()
        end
    end)
end

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
    
    local ladderConnection = RunService.Heartbeat:Connect(function()
        if ladderPart and ladderPart.Parent and flyMode then
            ladderPart.Position = rootPart.Position
        elseif not flyMode then
            ladderConnection:Disconnect()
        end
    end)
end

local function enableRagdoll()
    pcall(function()
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
    end)
end

local function disableRagdoll()
    pcall(function()
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
    end)
end

local function cleanupTransportParts()
    for _, part in pairs(transportParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    transportParts = {}
end

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
    statusLabel.Text = "Iniciando flote con ragdoll..."
    
    cleanupTransportParts()
    enableRagdoll()
    
    -- Crear partículas flotantes
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
            math.sin(i * 0.8) * 1.5,
            math.sin(math.rad(angle)) * radius
        )
        part.Position = rootPart.Position + offset
        
        table.insert(transportParts, part)
    end
    
    -- Sistema de transporte mejorado
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    local startPos = rootPart.Position
    local endPos = targetPoint
    local totalDistance = (endPos - startPos).Magnitude
    
    statusLabel.Text = string.format("Flotando %.0f metros...", totalDistance)
    
    -- Función para detectar obstáculos
    local function checkForObstacles(currentPos, targetPos)
        local direction = (targetPos - currentPos).Unit
        local distance = (targetPos - currentPos).Magnitude
        
        -- Raycast para detectar obstáculos
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {character}
        
        local raycastResult = workspace:Raycast(currentPos, direction * math.min(distance, 10), raycastParams)
        
        if raycastResult then
            -- Si hay obstáculo, intentar ir por los lados
            local rightDirection = direction:Cross(Vector3.new(0, 1, 0)).Unit
            local leftDirection = -rightDirection
            
            -- Probar ir por la derecha
            local rightPos = currentPos + rightDirection * 5
            local rightRaycast = workspace:Raycast(currentPos, (rightPos - currentPos), raycastParams)
            
            if not rightRaycast then
                return rightDirection * floatSpeed
            end
            
            -- Probar ir por la izquierda
            local leftPos = currentPos + leftDirection * 5
            local leftRaycast = workspace:Raycast(currentPos, (leftPos - currentPos), raycastParams)
            
            if not leftRaycast then
                return leftDirection * floatSpeed
            end
            
            -- Si ambos lados están bloqueados, ir hacia arriba
            return Vector3.new(0, floatSpeed, 0)
        end
        
        return direction * floatSpeed
    end
    
    local effectConnection = RunService.Heartbeat:Connect(function(deltaTime)
        local currentPos = rootPart.Position
                local distanceToTarget = (endPos - currentPos).Magnitude
        
        -- Si estamos cerca del objetivo, ir directamente
        if distanceToTarget < 3 then
            local direction = (endPos - currentPos).Unit
            bodyVelocity.Velocity = direction * floatSpeed
        else
            -- Usar detección de obstáculos
            local moveDirection = checkForObstacles(currentPos, endPos)
            bodyVelocity.Velocity = moveDirection
        end
        
        -- Actualizar partículas
        for i, part in pairs(transportParts) do
            if part and part.Parent then
                local angle = (i-1) * (360 / partCount) + (tick() * 30)
                local bobbing = math.sin(tick() * 2 + i) * 1
                local offset = Vector3.new(
                    math.cos(math.rad(angle)) * radius,
                    bobbing,
                    math.sin(math.rad(angle)) * radius
                )
                part.Position = currentPos + offset
                part.Color = Color3.fromHSV(((tick() * 60 + i * 60) % 360) / 360, 0.7, 1)
            end
        end
        
        -- Verificar si hemos llegado al destino
        if distanceToTarget < 2 then
            effectConnection:Disconnect()
            
            -- Asegurar que se desactive el ragdoll al llegar
            wait(0.1) -- Pequeña pausa para estabilizar
            disableRagdoll()
            
            -- Limpiar todo
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
            cleanupTransportParts()
            isTransporting = false
            statusLabel.Text = "¡Flote completado!"
            
            -- Asegurar que el personaje esté en estado normal
            wait(0.2)
            humanoid.PlatformStand = false
        end
    end)
end

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
        statusLabel.Text = "Modo escalera activado"
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyMode then return end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            local speed = 60
            
            local cameraCFrame = camera.CFrame
            local forward = cameraCFrame.LookVector
            local right = cameraCFrame.RightVector
            
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
        statusLabel.Text = "Modo escalera desactivado"
    end
end

-- Configurar slider
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
            floatSpeed = math.floor(20 + (percentage * 80))
            speedLabel.Text = "Velocidad: " .. floatSpeed
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
    statusLabel.Text = "Punto establecido!"
end)

goToPointButton.MouseButton1Click:Connect(function()
    goToEstablishedPoint()
end)

flyButton.MouseButton1Click:Connect(function()
    toggleFlyMode()
end)

setupSpeedSlider()

print("Panel Rainbow cargado correctamente!")
