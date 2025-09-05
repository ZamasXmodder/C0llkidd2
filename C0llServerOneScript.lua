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

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
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

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0, 200)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Listo"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame

-- Instrucciones de vuelo
local flyInstructions = Instance.new("TextLabel")
flyInstructions.Size = UDim2.new(0.9, 0, 0, 20)
flyInstructions.Position = UDim2.new(0.05, 0, 0, 220)
flyInstructions.BackgroundTransparency = 1
flyInstructions.Text = "WASD + Space/Shift para volar"
flyInstructions.TextColor3 = Color3.fromRGB(200, 200, 200)
flyInstructions.TextScaled = true
flyInstructions.Font = Enum.Font.SourceSans
flyInstructions.Visible = false
flyInstructions.Parent = frame

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

-- Función para crear escalera invisible
local function createLadder()
    if ladderPart then
        ladderPart:Destroy()
    end
    
    ladderPart = Instance.new("TrussPart")
    ladderPart.Name = "InvisibleLadder"
    ladderPart.Size = Vector3.new(4, 20, 1)
    ladderPart.Material = Enum.Material.ForceField
    ladderPart.Transparency = 0.8
    ladderPart.Color = Color3.fromRGB(0, 255, 255)
    ladderPart.Anchored = true
    ladderPart.CanCollide = true
    ladderPart.Parent = workspace
    
    -- Posicionar la escalera
    local ladderConnection
    ladderConnection = RunService.Heartbeat:Connect(function()
        if ladderPart and ladderPart.Parent and flyMode then
            ladderPart.Position = rootPart.Position
        elseif not flyMode then
            ladderConnection:Disconnect()
        end
    end)
end

-- Función para modo vuelo
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
        statusLabel.Text = "Modo vuelo activado"
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flyMode then return end
            
            local camera = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            local speed = 50
            
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

-- Función mejorada para crear path respetando obstáculos
local function createSmartPath(startPos, endPos)
    -- Configuración más precisa del pathfinding
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentCanClimb = false,
        WaypointSpacing = 3,
        Costs = {
            Water = 20,
            DangerousLava = math.huge,
            Cracked = 5
        }
    })
    
    local success, errorMessage = pcall(function()
        path:ComputeAsync(startPos, endPos)
    end)
    
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        
        -- Verificar que cada segmento del path sea válido
        local validWaypoints = {waypoints[1]}
        
        for i = 2, #waypoints do
            local prevPos = validWaypoints[#validWaypoints].Position
            local currentPos = waypoints[i].Position
            
            -- Verificar si el camino está libre
            if isPathClear(prevPos, currentPos) then
                table.insert(validWaypoints, waypoints[i])
            else
                -- Si hay obstáculo, intentar encontrar ruta alternativa
                statusLabel.Text = "Buscando ruta alternativa..."
                break
            end
        end
        
        return validWaypoints
    else
        -- Si falla el pathfinding, usar humanoid pathfinding como respaldo
        statusLabel.Text = "Usando navegación básica..."
        humanoid:MoveTo(endPos)
        
        -- Crear waypoints básicos siguiendo al humanoid
        return {{Position = startPos, Action = Enum.PathWaypointAction.Walk}, 
                {Position = endPos, Action = Enum.PathWaypointAction.Walk}}
    end
end

-- Función para ir al punto establecido con navegación inteligente
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
    statusLabel.Text = "Calculando ruta..."
    
    cleanupTransportParts()
    
    local startPos = rootPart.Position
    local waypoints = createSmartPath(startPos, targetPoint)
    
    if not waypoints or #waypoints < 2 then
                statusLabel.Text = "No se pudo encontrar ruta válida"
        isTransporting = false
        return
    end
    
    statusLabel.Text = "Transportando..."
    
    -- Crear 6 parts que forman un círculo alrededor del jugador
    local angles = {0, 60, 120, 180, 240, 300}
    local radius = 4
    
    for i = 1, 6 do
        local part = Instance.new("Part")
        part.Name = "TransportPart" .. i
        part.Size = Vector3.new(2, 1, 2)
        part.Material = Enum.Material.ForceField
        part.Color = Color3.fromHSV((i-1) / 6, 1, 1)
        part.Anchored = true
        part.CanCollide = false
        part.Parent = workspace
        
        local angle = math.rad(angles[i])
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        part.Position = rootPart.Position + offset
        
        table.insert(transportParts, part)
    end
    
    -- Mover las parts y el jugador a través del path respetando obstáculos
    local currentWaypoint = 1
    local moveConnection
    local stuckTimer = 0
    local lastPosition = rootPart.Position
    
    moveConnection = RunService.Heartbeat:Connect(function()
        if currentWaypoint > #waypoints then
            moveConnection:Disconnect()
            cleanupTransportParts()
            isTransporting = false
            statusLabel.Text = "¡Llegaste al punto!"
            return
        end
        
        local targetPos = waypoints[currentWaypoint].Position
        local currentPos = rootPart.Position
        local distance = (targetPos - currentPos).Magnitude
        
        -- Verificar si estamos atascados
        if (currentPos - lastPosition).Magnitude < 1 then
            stuckTimer = stuckTimer + RunService.Heartbeat:Wait()
            if stuckTimer > 2 then -- Si estamos atascados por 2 segundos
                statusLabel.Text = "Obstáculo detectado, recalculando..."
                currentWaypoint = currentWaypoint + 1
                stuckTimer = 0
            end
        else
            stuckTimer = 0
            lastPosition = currentPos
        end
        
        if distance < 5 then
            currentWaypoint = currentWaypoint + 1
        else
            local direction = (targetPos - currentPos).Unit
            local speed = 60 -- Velocidad rápida pero controlada
            local deltaTime = RunService.Heartbeat:Wait()
            
            -- Verificar que el próximo movimiento no atraviese paredes
            local nextPos = currentPos + direction * speed * deltaTime
            
            if isPathClear(currentPos, nextPos) then
                -- Mover jugador
                rootPart.CFrame = CFrame.new(nextPos, nextPos + direction)
                
                -- Mover parts alrededor del jugador
                for i, part in pairs(transportParts) do
                    if part and part.Parent then
                        local angle = math.rad(angles[i])
                        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                        part.Position = nextPos + offset
                        
                        -- Efecto de rotación en las parts
                        part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(5), 0)
                    end
                end
            else
                -- Si hay obstáculo, saltar al siguiente waypoint
                currentWaypoint = currentWaypoint + 1
                statusLabel.Text = "Evitando obstáculo..."
            end
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
    statusLabel.Text = "Punto establecido en posición actual"
end)

goToPointButton.MouseButton1Click:Connect(function()
    goToEstablishedPoint()
end)

flyButton.MouseButton1Click:Connect(function()
    toggleFlyMode()
end)

-- Limpiar al morir o cambiar de personaje
character.Humanoid.Died:Connect(function()
    if rainbowPart then
        rainbowPart:Destroy()
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
    
    -- Reconectar eventos de muerte
    character.Humanoid.Died:Connect(function()
        if rainbowPart then
            rainbowPart:Destroy()
        end
        cleanupTransportParts()
        if flyMode then
            toggleFlyMode()
        end
    end)
end)
