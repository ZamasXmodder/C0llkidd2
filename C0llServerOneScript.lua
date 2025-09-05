local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de todos los brainrots
local brainrotList = {
    "Noobini Pizzanini", "Lirili Larila", "TIM Cheese", "Flurifura", "Talpa Di Fero",
    "Svinia Bombardino", "Pipi Kiwi", "Racooni Jandelini", "Pipi Corni", "Trippi Troppi",
    "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu",
    "Cacto Hipopotamo", "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom", "Steal a Brainrot Pipi Avocado",
    "Cappuccino Assassino", "Brr Brr Patapin", "Trulimero Trulicina", "Bambini Crostini",
    "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo", "Salamino Penguino", "Ti Ti Ti Sahur", "Penguino Cocosino",
    "Burbalini Loliloli", "Chimpanzini Bananini", "Ballerina Cappuccina", "Chef Crabracadabra",
    "Lionel Cactuseli", "Glorbo Fruttodrillo", "Blueberrini Octapusini", "Strawberelli Flamingelli",
    "Pandaccini Bananini", "Cocosini Mama", "Sigma Boy", "Pi Pi Watermelon", "Frigo Camelo",
    "Orangutini Ananasini", "Rhino Toasterino", "Bombardiro Crocodilo", "Bombombini Gusini",
    "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla", "Tob Tobi Tobi",
    "Gangazelli Trulala", "Te Te Te Sahur", "Tracoducotulu Delapeladustuz", "Lerulerulerule",
    "Carloo", "Spioniro Golubiro", "Zibra Zubra Zibralini", "Tigrilini Watermelini",
    "Cocofanta Elefanto", "Girafa Celestre", "Gyattatino Nyanino", "Matteo",
    "Tralalero Tralala", "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino",
    "Trenostruzzo Turbo 3000", "Ballerino Lololo", "Los Orcalitos", "Tralalita Tralala",
    "Urubini Flamenguini", "Trigoligre Frutonni", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Los Crocodilitos", "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtuntuncitos",
    "Tukanno Bananno", "Alessio", "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii",
    "La Vacca Saturno Saturnita", "Chimpanzini Spiderini", "Los Tralaleritos", "Las Tralaleritas",
    "Graipuss Medussi", "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung",
    "Tortuginni Dragonfruitini", "Pot Hotspot", "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira",
    "Agarrini la Palini", "Dragon Cannelloni", "Los Combinasionas", "Karkerkar Kurkur",
    "Los Hotspotsitos", "Esok Sekolah", "Los Matteos", "Dul Dul Dul", "Blackhole Goat",
    "Nooo My Hotspot", "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat"
}

-- Variables de estado
local autoStealActive = false
local currentConnection = nil
local homePosition = nil
local isMoving = false
local floatSpeed = 50 -- Velocidad inicial
local carrierParts = {}
local bodyVelocity = nil

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoStealPanel"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 200)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 25)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🚀 Auto Steal Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = frame

-- Botón principal
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 35)
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
button.Text = "🔄 Auto Steal: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

-- Control de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 85)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Float Speed: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = frame

-- Botones de velocidad
local speedDownButton = Instance.new("TextButton")
speedDownButton.Size = UDim2.new(0, 40, 0, 25)
speedDownButton.Position = UDim2.new(0, 10, 0, 110)
speedDownButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedDownButton.Text = "➖"
speedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDownButton.TextScaled = true
speedDownButton.Font = Enum.Font.GothamBold
speedDownButton.Parent = frame

local speedDownCorner = Instance.new("UICorner")
speedDownCorner.CornerRadius = UDim.new(0, 6)
speedDownCorner.Parent = speedDownButton

local speedUpButton = Instance.new("TextButton")
speedUpButton.Size = UDim2.new(0, 40, 0, 25)
speedUpButton.Position = UDim2.new(1, -50, 0, 110)
speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
speedUpButton.Text = "➕"
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextScaled = true
speedUpButton.Font = Enum.Font.GothamBold
speedUpButton.Parent = frame

local speedUpCorner = Instance.new("UICorner")
speedUpCorner.CornerRadius = UDim.new(0, 6)
speedUpCorner.Parent = speedUpButton

-- Indicador de velocidad visual
local speedIndicator = Instance.new("Frame")
speedIndicator.Size = UDim2.new(0, 170, 0, 25)
speedIndicator.Position = UDim2.new(0, 60, 0, 110)
speedIndicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedIndicator.Parent = frame

local speedIndicatorCorner = Instance.new("UICorner")
speedIndicatorCorner.CornerRadius = UDim.new(0, 6)
speedIndicatorCorner.Parent = speedIndicator

local speedBar = Instance.new("Frame")
speedBar.Size = UDim2.new((floatSpeed - 10) / 190, 0, 1, 0)
speedBar.Position = UDim2.new(0, 0, 0, 0)
speedBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
speedBar.Parent = speedIndicator

local speedBarCorner = Instance.new("UICorner")
speedBarCorner.CornerRadius = UDim.new(0, 6)
speedBarCorner.Parent = speedBar

-- Status labels
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 145)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "💤 Status: Inactive"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = frame

local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 18)
countLabel.Position = UDim2.new(0, 10, 0, 170)
countLabel.BackgroundTransparency = 1
countLabel.Text = "🎯 Found: 0 brainrots"
countLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
countLabel.TextScaled = true
countLabel.Font = Enum.Font.Gotham
countLabel.Parent = frame

-- Función para actualizar la velocidad (cambiado de 10 a 5)
local function updateSpeed(newSpeed)
    floatSpeed = math.clamp(newSpeed, 10, 200)
    speedLabel.Text = "⚡ Float Speed: " .. floatSpeed
    speedBar.Size = UDim2.new((floatSpeed - 10) / 190, 0, 1, 0)
end

-- Eventos de los botones de velocidad (ahora de 5 en 5)
speedDownButton.MouseButton1Click:Connect(function()
    updateSpeed(floatSpeed - 5)
end)

speedUpButton.MouseButton1Click:Connect(function()
    updateSpeed(floatSpeed + 5)
end)

-- Función para detectar obstáculos usando raycast
local function checkObstacle(from, to)
    local rayDirection = (to - from)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character, unpack(carrierParts)}
    
    local raycastResult = workspace:Raycast(from, rayDirection, raycastParams)
    return raycastResult
end

-- Función para encontrar una ruta alternativa cuando hay obstáculo
local function findAlternatePath(startPos, targetPos)
    -- Intentar diferentes alturas para evitar obstáculos
    local testPositions = {
        targetPos + Vector3.new(0, 10, 0), -- Más alto
        targetPos + Vector3.new(5, 5, 0),  -- Lateral derecho
        targetPos + Vector3.new(-5, 5, 0), -- Lateral izquierdo
        targetPos + Vector3.new(0, 5, 5),  -- Lateral adelante
        targetPos + Vector3.new(0, 5, -5), -- Lateral atrás
        targetPos + Vector3.new(0, 15, 0)  -- Mucho más alto
    }
    
    for _, testPos in pairs(testPositions) do
        local obstacle = checkObstacle(startPos, testPos)
        if not obstacle then
            return testPos
        end
    end
    
    -- Si no encuentra ruta, volar muy alto
    return targetPos + Vector3.new(0, 25, 0)
end

-- Función para encontrar brainrots en workspace
local function findBrainrots()
    local brainrots = {}
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            for _, brainrotName in pairs(brainrotList) do
                if obj.Name == brainrotName then
                    if obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("Part") then
                        table.insert(brainrots, obj)
                    end
                    break
                end
            end
        end
    end
    
    return brainrots
end

-- Función para obtener la posición del brainrot
local function getBrainrotPosition(brainrot)
    if brainrot.PrimaryPart then
        return brainrot.PrimaryPart.Position
    elseif brainrot:FindFirstChild("HumanoidRootPart") then
        return brainrot.HumanoidRootPart.Position
    elseif brainrot:FindFirstChildOfClass("Part") then
        return brainrot:FindFirstChildOfClass("Part").Position
    end
    return nil
end

-- Función para limpiar efectos
local function cleanupEffects()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    for _, part in pairs(carrierParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    carrierParts = {}
    
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = false
    end
end

-- Función para crear las partes que llevarán al jugador
local function createCarrierParts()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Limpiar partes anteriores
    cleanupEffects()
    
    -- Crear 6 partes flotantes
    for i = 1, 6 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 2, 2)
        part.Material = Enum.Material.ForceField
        part.BrickColor = BrickColor.new("Bright blue")
        part.CanCollide = false
        part.Anchored = false
        part.Shape = Enum.PartType.Ball
        part.TopSurface = Enum.SurfaceType.Smooth
        part.BottomSurface = Enum.SurfaceType.Smooth
        
        local angle = (i - 1) * (math.pi * 2 / 6)
        local radius = 8
        part.Position = humanoidRootPart.Position + Vector3.new(
            math.cos(angle) * radius,
            math.random(3, 7),
            math.sin(angle) * radius
        )
        
        part.Parent = workspace
        table.insert(carrierParts, part)
        
        -- Efecto de brillo
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(0, 162, 255)
        pointLight.Brightness = 3
        pointLight.Range = 15
        pointLight.Parent = part
        
        -- BodyVelocity para movimiento suave
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = part
        
        -- BodyAngularVelocity para rotación
        local bodyAngular = Instance.new("BodyAngularVelocity")
        bodyAngular.AngularVelocity = Vector3.new(0, math.random(5, 15), 0)
        bodyAngular.MaxTorque = Vector3.new(0, math.huge, 0)
        bodyAngular.Parent = part
    end
    
    -- Crear BodyVelocity para el jugador
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Inmovilizar al jugador
    if player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.PlatformStand = true
    end
end

-- Función para mover flotando hacia el objetivo (mejorada con detección de obstáculos)
local function floatToTarget(targetPosition, isReturningHome)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    isMoving = true
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    -- Crear las partes que llevarán al jugador
    createCarrierParts()
    
    -- Verificar si hay obstáculos y encontrar ruta alternativa
    local obstacle = checkObstacle(humanoidRootPart.Position, targetPosition)
    local finalTarget = targetPosition
    
    if obstacle then
        finalTarget = findAlternatePath(humanoidRootPart.Position, targetPosition)
        statusLabel.Text = "🧭 Avoiding obstacles..."
    end
    
    -- Movimiento flotante
    spawn(function()
        local startTime = tick()
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not autoStealActive or tick() - startTime > 20 then -- Aumentado el tiempo límite
                connection:Disconnect()
                isMoving = false
                cleanupEffects()
                return
            end
            
            if humanoidRootPart and humanoidRootPart.Parent then
                local direction = (finalTarget - humanoidRootPart.Position)
                local distance = direction.Magnitude
                
                if distance < 8 then
                    -- Llegamos al objetivo
                    connection:Disconnect()
                    isMoving = false
                    
                    if not isReturningHome then
                        -- Simular recolección más rápida (reducido de 2 a 0.5 segundos)
                        statusLabel.Text = "✨ Collecting brainrot..."
                        wait(0.5)
                        
                        -- Regresar a casa inmediatamente
                        if homePosition and autoStealActive then
                            statusLabel.Text = "🏠 Returning home..."
                            floatToTarget(homePosition, true, nil)
                        else
                            cleanupEffects()
                        end
                    else
                        cleanupEffects()
                    end
                    return
                end
                
                -- Verificar obstáculos durante el movimiento
                local currentObstacle = checkObstacle(humanoidRootPart.Position, finalTarget)
                if currentObstacle and distance > 15 then
                    -- Recalcular ruta si encontramos un obstáculo nuevo
                    finalTarget = findAlternatePath(humanoidRootPart.Position, targetPosition)
                end
                
                -- Calcular velocidad
                direction = direction.Unit
                local velocity = direction * floatSpeed
                
                -- Aplicar movimiento al jugador
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity.Velocity = velocity
                end
                
                -- Mover las partes flotantes alrededor del jugador (EN EL SUELO)
                for i, part in pairs(carrierParts) do
                    if part and part.Parent and part:FindFirstChild("BodyVelocity") then
                        local angle = (i - 1) * (math.pi * 2 / 6) + tick() * 1.5
                        local radius = 4  -- Radio pequeño
                        local targetPartPos = humanoidRootPart.Position + Vector3.new(
                            math.cos(angle) * radius,
                            0, -- COMPLETAMENTE en el suelo
                            math.sin(angle) * radius
                        )
                        
                        local partDirection = (targetPartPos - part.Position)
                        -- Solo movimiento horizontal, Y = 0
                        partDirection = Vector3.new(partDirection.X, 0, partDirection.Z).Unit
                        part.BodyVelocity.Velocity = partDirection * (floatSpeed * 0.9)
                    end
                end
            end
        end)
    end)
end

-- Función para crear efectos visuales en el brainrot
local function createBrainrotEffects(position)
    for i = 1, 3 do
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Material = Enum.Material.Neon
        effect.BrickColor = BrickColor.new("Bright green")
        effect.CanCollide = false
        effect.Anchored = true
        effect.Shape = Enum.PartType.Ball
        effect.Transparency = 0.3
        
        local angle = (i - 1) * (math.pi * 2 / 3)
        local radius = 5
        effect.Position = position + Vector3.new(
            math.cos(angle) * radius,
            math.random(1, 4),
            math.sin(angle) * radius
        )
        
        effect.Parent = workspace
        
        -- Animación de crecimiento y desvanecimiento
        spawn(function()
            for t = 0, 3, 0.1 do
                if effect.Parent then
                    effect.Size = Vector3.new(1 + t, 1 + t, 1 + t)
                    effect.Transparency = 0.3 + (t / 3) * 0.7
                    effect.Position = effect.Position + Vector3.new(0, 0.1, 0)
                end
                wait(0.1)
            end
            if effect.Parent then
                effect:Destroy()
            end
        end)
    end
end

-- Función principal de auto steal
local function autoStealLoop()
    if not autoStealActive or isMoving then return end
    
    local brainrots = findBrainrots()
    countLabel.Text = "🎯 Found: " .. #brainrots .. " brainrots"
    
    if #brainrots > 0 then
        local closestBrainrot = nil
        local closestDistance = math.huge
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = player.Character.HumanoidRootPart.Position
            
            for _, brainrot in pairs(brainrots) do
                local brainrotPos = getBrainrotPosition(brainrot)
                if brainrotPos then
                    local distance = (brainrotPos - playerPos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestBrainrot = brainrot
                    end
                end
            end
            
            if closestBrainrot then
                local targetPos = getBrainrotPosition(closestBrainrot)
                if targetPos then
                    statusLabel.Text = "🚀 Flying to: " .. closestBrainrot.Name
                    createBrainrotEffects(targetPos)
                    floatToTarget(targetPos, false)
                end
            end
        end
    else
        statusLabel.Text = "🔍 Searching for brainrots..."
    end
end

-- Evento del botón principal
button.MouseButton1Click:Connect(function()
    autoStealActive = not autoStealActive
    
    if autoStealActive then
        button.Text = "🟢 Auto Steal: ON"
        button.BackgroundColor3 = Color3.fromRGB(46, 125, 50)
        statusLabel.Text = "⚡ Active - Scanning..."
        
        -- Guardar posición inicial
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            homePosition = player.Character.HumanoidRootPart.Position
        end
        
        -- Iniciar loop
        currentConnection = RunService.Heartbeat:Connect(function()
            wait(2) -- Reducido de 3 a 2 segundos para mayor velocidad
            autoStealLoop()
        end)
    else
        button.Text = "🔴 Auto Steal: OFF"
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        statusLabel.Text = "💤 Status: Inactive"
        countLabel.Text = "🎯 Found: 0 brainrots"
        isMoving = false
        
        -- Limpiar todo
        cleanupEffects()
        
        -- Detener loop
        if currentConnection then
            currentConnection:Disconnect()
            currentConnection = nil
        end
    end
end)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Función para limpiar al salir
game.Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        if currentConnection then
            currentConnection:Disconnect()
        end
        cleanupEffects()
        if screenGui then
            screenGui:Destroy()
        end
    end
end)

-- Notificación de inicio
spawn(function()
    wait(1)
    statusLabel.Text = "✅ Auto Steal Panel Ready!"
    wait(2)
    if not autoStealActive then
        statusLabel.Text = "💤 Status: Inactive"
    end
end)

print("🎮 Auto Steal Panel loaded successfully!")
print("📋 Monitoring " .. #brainrotList .. " different brainrots")
print("🚀 Float system activated with obstacle avoidance!")
print("⚡ Speed controls: Use ➖ and ➕ buttons (Range: 10-200, steps of 5)")
print("🧭 New features: Wall detection and faster collection!")
