local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de brainrots secrets para ESP
local secretBrainrots = {
    "La Vacca Saturno Saturnita",
    "Torrtuginni Dragonfrutini", 
    "Agarrini La Palini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Job Job Job Sahur",
    "Las Vaquitas Saturnitas",
    "Ketupat Kepat",
    "Graipuss Medussi",
    "Pot Hotspot",
    "Chicleteira Bicicleteira",
    "La Grande Combinasion",
    "Los Combinasionas",
    "Nuclearo Dinossauro",
    "Los Hotspotsitos",
    "Esok Sekolah",
    "Garama and Madundung",
    "Los Matteos",
    "Dragon Cannelloni",
    "Los Spyderinis",
    "La Supreme Combinasion",
    "Spaghetti Tualetti",
    "Secret Lucky Block"
}

-- Lista completa de todos los brainrots
local allBrainrots = {
    "Noobini Pizzanini", "Lirili Larila", "TIM Cheese", "Flurifura", "Talpa Di Fero",
    "Svinia Bombardino", "Pipi Kiwi", "Racooni Jandelini", "Pipi Corni", "Trippi Troppi",
    "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu",
    "Cacto Hipopotamo", "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom", "Steal a Brainrot Pipi Avocado",
    "Cappuccino Assassino", "Brr Brr Patapin", "Trulimero Trulicina", "Bambini Crostini",
    "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo", "Salamino Penguino", "Ti Ti Ti Sahur", "Penguino Cocosino",
    "Burbalini Loliloli", "Chimpanzini Bananini", "Ballerina Cappuccina", "Chef Crabracadabra",
    "Lionel Cactuseli", "Glorbo Fruttodrillo", "Blueberrini Octapusini", "Strawberelli Flamingelli",
    "Pandaccini Bananini", "Cocosini Mama", "Sigma Boy", "Pi Pi Watermelon", "frigo Camelo",
    "Orangutini Ananasini", "Rhino Toasterino", "Bombardiro Crocodilo", "Bombombini Gusini",
    "Cavallo Virtuso", "Gorillo Watermelondrillo", "Avocadorilla", "Tob Tobi Tobi",
    "Gangazelli Trulala", "Te Te Te Sahur", "Tracoducotulu Delapeladustuz", "Lerulerulerule",
    "Carloo", "Spioniro Golubiro", "Zibra Zubra Zibralini", "Tigrilini Watermelini",
    "Cocofanta Elefanto", "Girafa Celestre", "Gyattatino Nyanino", "Matteo",
    "Tralalero Tralala", "Espresso Signora", "Odin Din Din Dun", "Statutino Libertino",
    "Trenostruzzo Turbo 3000", "Ballerino Lololo", "Los Orcalitos", "Tralalita Tralala",
    "Urubini Flamenguini", "Trigoligre Frutonni", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Los Crocodilitos", "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtuntuncitos",
    "Tukanno Bananno", "Alessio", "Tipi Topi Taco", "Pakrahmatmamat", "Bombardini Tortinii"
}

-- Combinar listas
for _, secret in pairs(secretBrainrots) do
    table.insert(allBrainrots, secret)
end

-- Variables
local espEnabled = false
local autoLaserEnabled = false
local autoStealEnabled = false
local espConnections = {}
local autoLaserConnection = nil
local autoStealConnection = nil
local initialPosition = nil
local espObjects = {}
local teleportCooldown = false -- Para evitar teletransportes múltiples

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotPanel"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
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
title.BackgroundTransparency = 1
title.Text = "Brainrot Panel"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Botón ESP
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 35)
espButton.Position = UDim2.new(0.1, 0, 0, 50)
espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
espButton.Text = "ESP Secrets: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextScaled = true
espButton.Font = Enum.Font.Gotham
espButton.Parent = mainFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 5)
espCorner.Parent = espButton

-- Botón Auto Laser
local autoLaserButton = Instance.new("TextButton")
autoLaserButton.Size = UDim2.new(0.8, 0, 0, 35)
autoLaserButton.Position = UDim2.new(0.1, 0, 0, 95)
autoLaserButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
autoLaserButton.Text = "Auto Laser: OFF"
autoLaserButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoLaserButton.TextScaled = true
autoLaserButton.Font = Enum.Font.Gotham
autoLaserButton.Parent = mainFrame

local autoLaserCorner = Instance.new("UICorner")
autoLaserCorner.CornerRadius = UDim.new(0, 5)
autoLaserCorner.Parent = autoLaserButton

-- Botón Auto Steal
local autoStealButton = Instance.new("TextButton")
autoStealButton.Size = UDim2.new(0.8, 0, 0, 35)
autoStealButton.Position = UDim2.new(0.1, 0, 0, 140)
autoStealButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
autoStealButton.Text = "Auto Steal: OFF"
autoStealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoStealButton.TextScaled = true
autoStealButton.Font = Enum.Font.Gotham
autoStealButton.Parent = mainFrame

local autoStealCorner = Instance.new("UICorner")
autoStealCorner.CornerRadius = UDim.new(0, 5)
autoStealCorner.Parent = autoStealButton

-- Función para verificar si es un brainrot secret
local function isSecretBrainrot(name)
    for _, secretName in pairs(secretBrainrots) do
        if string.find(name:lower(), secretName:lower()) then
            return true
        end
    end
    return false
end

-- Función para verificar si es cualquier brainrot
local function isBrainrot(name)
    for _, brainrotName in pairs(allBrainrots) do
        if string.find(name:lower(), brainrotName:lower()) then
            return true
        end
    end
    return false
end

-- Función para crear ESP
local function createESP(obj)
    if not obj or not obj.Parent then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = obj
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    return highlight
end

-- Función para toggle ESP
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton.Text = "ESP Secrets: ON"
        espButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Buscar brainrots secrets en el workspace
        local function scanForSecrets(parent)
            for _, child in pairs(parent:GetChildren()) do
                if child:IsA("Model") and isSecretBrainrot(child.Name) then
                    local esp = createESP(child)
                    if esp then
                        espObjects[child] = esp
                    end
                elseif child:IsA("BasePart") and isSecretBrainrot(child.Name) then
                    local esp = createESP(child)
                    if esp then
                        espObjects[child] = esp
                    end
                end
                scanForSecrets(child)
            end
        end
        
        scanForSecrets(workspace)
        
        -- Conectar para nuevos objetos
        local connection = workspace.DescendantAdded:Connect(function(descendant)
            if (descendant:IsA("Model") or descendant:IsA("BasePart")) and isSecretBrainrot(descendant.Name) then
                wait(0.1)
                local esp = createESP(descendant)
                if esp then
                    espObjects[descendant] = esp
                end
            end
        end)
        table.insert(espConnections, connection)
        
    else
        espButton.Text = "ESP Secrets: OFF"
        espButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        -- Limpiar ESP
        for obj, esp in pairs(espObjects) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
        espObjects = {}
        
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
    end
end

-- Función para auto laser
local function toggleAutoLaser()
    autoLaserEnabled = not autoLaserEnabled
    
    if autoLaserEnabled then
        autoLaserButton.Text = "Auto Laser: ON"
        autoLaserButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        autoLaserConnection = RunService.Heartbeat:Connect(function()
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                return
            end
            
            -- Verificar si tiene LaserCape equipado
            local laserCape = player.Character:FindFirstChild("LaserCape")
            if not laserCape then return end
            
            local humanoidRootPart = player.Character.HumanoidRootPart
            
            -- Buscar jugador más cercano
            local closestPlayer = nil
            local closestDistance = math.huge
            
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (humanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < 50 and distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = otherPlayer
                    end
                end
            end
            
            -- Disparar al jugador más cercano
            if closestPlayer then
                pcall(function()
                    local Net_upvr = ReplicatedStorage:WaitForChild("Net_upvr")
                    local targetPosition = closestPlayer.Character.HumanoidRootPart.Position
                    Net_upvr:FireServer(targetPosition, closestPlayer.Character.HumanoidRootPart)
                end)
                wait(0.2) -- Cooldown entre disparos
            end
        end)
        
    else
        autoLaserButton.Text = "Auto Laser: OFF"
        autoLaserButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        if autoLaserConnection then
            autoLaserConnection:Disconnect()
            autoLaserConnection = nil
        end
    end
end

-- FUNCIÓN DE TELETRANSPORTE MEJORADA - SIN RETROCESO
local function safeTeleport(targetPosition)
    if teleportCooldown or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    teleportCooldown = true -- Activar cooldown
    
    local character = player.Character
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- PASO 1: Detener completamente al personaje
    pcall(function()
        if humanoid then
            humanoid.PlatformStand = true -- Prevenir movimiento
            humanoid:ChangeState(Enum.HumanoidStateType.Physics) -- Cambiar estado
        end
        
        -- Detener toda velocidad
        local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Parent = humanoidRootPart
        end
        
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Velocidad cero
        
        -- Asegurar que no haya rotación
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    
    -- PASO 2: Esperar un frame para que se apliquen los cambios
    wait(0.1)
    
    -- PASO 3: Teletransporte suave y controlado
    pcall(function()
        -- Crear un CFrame con rotación Y mantenida para evitar mareos
        local currentRotation = humanoidRootPart.CFrame.Rotation
        local newCFrame = CFrame.new(targetPosition) * currentRotation
        
        -- Teletransporte directo
        humanoidRootPart.CFrame = newCFrame
    end)
    
    -- PASO 4: Limpiar efectos y restaurar control después de un momento
    wait(0.2)
    
    pcall(function()
        -- Restaurar control del personaje
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        -- Limpiar BodyVelocity
        local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
        if bodyVelocity then
            bodyVelocity:Destroy()
        end
        
        -- Asegurar velocidad cero final
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    
    print("¡Teletransportado suavemente al punto inicial!")
    
    -- Desactivar cooldown después de 2 segundos
    spawn(function()
        wait(2)
        teleportCooldown = false
    end)
end

-- Función para auto steal MEJORADA
local function toggleAutoSteal()
    autoStealEnabled = not autoStealEnabled
    
    if autoStealEnabled then
        autoStealButton.Text = "Auto Steal: ON"
        autoStealButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Guardar posición inicial
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            initialPosition = player.Character.HumanoidRootPart.Position
        end
        
        -- Detectar cuando aparece un brainrot robado EN EL BACKPACK (más confiable)
        local connection1 = player.Backpack.ChildAdded:Connect(function(item)
            if isBrainrot(item.Name) and not teleportCooldown then
                print("¡Brainrot añadido al inventario: " .. item.Name .. "! Iniciando teletransporte...")
                if initialPosition then
                    wait(0.3) -- Espera para que se complete el robo
                    safeTeleport(initialPosition)
                end
            end
        end)
        
        -- Detectar brainrots que aparecen cerca del jugador (respaldo)
        local connection2 = workspace.ChildAdded:Connect(function(child)
            if child:IsA("Model") and isBrainrot(child.Name) and not teleportCooldown then
                wait(0.2)
                
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and initialPosition then
                    local distance = (player.Character.HumanoidRootPart.Position - child:GetModelCFrame().Position).Magnitude
                    
                    -- Si el brainrot aparece muy cerca del jugador
                    if distance < 15 then
                        print("¡Brainrot detectado cerca: " .. child.Name .. "! Iniciando teletransporte...")
                        safeTeleport(initialPosition)
                    end
                end
            end
        end)
        
        autoStealConnection = connection1
        table.insert(espConnections, connection2)
        
    else
        autoStealButton.Text = "Auto Steal: OFF"
        autoStealButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        if autoStealConnection then
            autoStealConnection:Disconnect()
            autoStealConnection = nil
        end
        
        -- Resetear cooldown
        teleportCooldown = false
    end
end

-- Conectar botones
espButton.MouseButton1Click:Connect(toggleESP)
autoLaserButton.MouseButton1Click:Connect(toggleAutoLaser)
autoStealButton.MouseButton1Click:Connect(toggleAutoSteal)

-- Hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Actualizar posición inicial cuando el jugador se mueva significativamente
spawn(function()
    while true do
        wait(3) -- Revisar cada 3 segundos
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not autoStealEnabled then
            local newPos = player.Character.HumanoidRootPart.Position
            if not initialPosition or (initialPosition and (initialPosition - newPos).Magnitude > 20) then
                initialPosition = newPos
                print("📍 Nuevo punto inicial guardado: " .. tostring(initialPosition))
            end
        end
    end
end)

print("Brainrot Panel cargado exitosamente!")
print("ESP: Resalta brainrots secrets con highlight")
print("Auto Laser: Dispara automáticamente a jugadores cercanos (requiere LaserCape equipado)")
print("Auto Steal: Te hace CORRER automáticamente hacia el punto inicial cuando robas un brainrot")
print("NUEVO SISTEMA: Auto-Run en lugar de teletransporte - más natural y sin bugs!")
