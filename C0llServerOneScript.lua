local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables globales
local rainbowPart = nil
local targetPoint = nil
local transportParts = {}
local isTransporting = false

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowPanel"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
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

-- Label de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 20)
statusLabel.Position = UDim2.new(0.05, 0, 0, 160)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Listo"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = frame

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

-- Función para limpiar parts de transporte
local function cleanupTransportParts()
    for _, part in pairs(transportParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    transportParts = {}
end

-- Función para crear path con pathfinding
local function createPathToPoint(startPos, endPos)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4
    })
    
    path:ComputeAsync(startPos, endPos)
    
    if path.Status == Enum.PathStatus.Success then
        return path:GetWaypoints()
    else
        -- Si falla el pathfinding, crear línea recta
        local distance = (endPos - startPos).Magnitude
        local direction = (endPos - startPos).Unit
        local waypoints = {}
        
        for i = 0, math.floor(distance / 8) do
            local pos = startPos + direction * (i * 8)
            table.insert(waypoints, {Position = pos, Action = Enum.PathWaypointAction.Walk})
        end
        
        table.insert(waypoints, {Position = endPos, Action = Enum.PathWaypointAction.Walk})
        return waypoints
    end
end

-- Función para ir al punto establecido
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
    statusLabel.Text = "Transportando..."
    
    cleanupTransportParts()
    
    local startPos = rootPart.Position
    local waypoints = createPathToPoint(startPos, targetPoint)
    
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
    
    -- Mover las parts y el jugador a través del path
    local currentWaypoint = 1
    local moveConnection
    
    moveConnection = RunService.Heartbeat:Connect(function()
        if currentWaypoint > #waypoints then
            moveConnection:Disconnect()
            cleanupTransportParts()
            isTransporting = false
            statusLabel.Text = "Llegaste al punto!"
            return
        end
        
        local targetPos = waypoints[currentWaypoint].Position
        local currentPos = rootPart.Position
        local distance = (targetPos - currentPos).Magnitude
        
        if distance < 3 then
            currentWaypoint = currentWaypoint + 1
        else
            local direction = (targetPos - currentPos).Unit
            local speed = 16 -- Velocidad rápida
            local newPos = currentPos + direction * speed * RunService.Heartbeat:Wait()
            
            -- Mover jugador
            rootPart.CFrame = CFrame.new(newPos, newPos + direction)
            
            -- Mover parts alrededor del jugador
            for i, part in pairs(transportParts) do
                if part and part.Parent then
                    local angle = math.rad(angles[i])
                    local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                    part.Position = newPos + offset
                end
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

-- Limpiar al morir
character.Humanoid.Died:Connect(function()
    if rainbowPart then
        rainbowPart:Destroy()
    end
    cleanupTransportParts()
end)
