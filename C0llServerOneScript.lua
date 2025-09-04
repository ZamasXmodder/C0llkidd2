local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamePanel"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Game Panel"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- ScrollingFrame para los botones
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ButtonContainer"
scrollFrame.Size = UDim2.new(1, -20, 1, -60)
scrollFrame.Position = UDim2.new(0, 10, 0, 50)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scrollFrame

-- Variables para funciones
local laserAimbotEnabled = false
local espEnabled = false
local secretEspEnabled = false
local laserAimbotConnection = nil
local spawnPosition = nil
local deliveryHitbox = nil
local isTeleporting = false

-- Lista COMPLETA de brainrots (secrets + normales)
local allBrainrots = {
    -- Secrets originales
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
    "Secret Lucky Block",
    
    -- Brainrots normales nuevos
    "Noobini Pizzanini",
    "Lirili Larila",
    "TIM Cheese",
    "Flurifura",
    "Talpa Di Fero",
    "Svinia Bombardino",
    "Pipi Kiwi",
    "Racooni Jandelini",
    "Pipi Corni",
    "Trippi Troppi",
    "Tung Tung Tung Sahur",
    "Gangster Footera",
    "Bandito Bobritto",
    "Boneca Ambalabu",
    "Cacto Hipopotamo",
    "Ta Ta Ta Ta Sahur",
    "Tric Trac Baraboom",
    "Steal a Brainrot Pipi Avocado",
    "Cappuccino Assassino",
    "Brr Brr Patapin",
    "Trulimero Trulicina",
    "Bambini Crostini",
    "Bananita Dolphinita",
    "Perochello Lemonchello",
    "Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo",
    "Salamino Penguino",
    "Ti Ti Ti Sahur",
    "Penguino Cocosino",
    "Burbalini Loliloli",
    "Chimpanzini Bananini",
    "Ballerina Cappuccina",
    "Chef Crabracadabra",
    "Lionel Cactuseli",
    "Glorbo Fruttodrillo",
    "Blueberrini Octapusini",
    "Strawberelli Flamingelli",
    "Pandaccini Bananini",
    "Cocosini Mama",
    "Sigma Boy",
    "Pi Pi Watermelon",
    "frigo Camelo",
    "Orangutini Ananasini",
    "Rhino Toasterino",
    "Bombardiro Crocodilo",
    "Bombombini Gusini",
    "Cavallo Virtuso",
    "Gorillo Watermelondrillo",
    "Avocadorilla",
    "Tob Tobi Tobi",
    "Gangazelli Trulala",
    "Te Te Te Sahur",
    "Tracoducotulu Delapeladustuz",
    "Lerulerulerule",
    "Carloo",
    "Spioniro Golubiro",
    "Zibra Zubra Zibralini",
    "Tigrilini Watermelini",
    "Cocofanta Elefanto",
    "Girafa Celestre",
    "Gyattatino Nyanino",
    "Matteo",
    "Tralalero Tralala",
    "Espresso Signora",
    "Odin Din Din Dun",
    "Statutino Libertino",
    "Trenostruzzo Turbo 3000",
    "Ballerino Lololo",
    "Los Orcalitos",
    "Tralalita Tralala",
    "Urubini Flamenguini",
    "Trigoligre Frutonni",
    "Orcalero Orcala",
    "Bulbito Bandito Traktorito",
    "Los Crocodilitos",
    "Piccione Macchina",
    "Trippi Troppi Troppa Trippa",
    "Los Tungtuntuncitos",
    "Tukanno Bananno",
    "Alessio",
    "Tipi Topi Taco",
    "Pakrahmatmamat",
    "Bombardini Tortinii",
    "La Vacca Staturno Saturnita",
    "Chimpanzini Spiderini",
    "Los Tralaleirtos",
    "Tortuginni Dragonfruitini",
    "Karkerkar Kurkur",
    "Dul Dul Dul",
    "Blackhole Goat",
    "Nooo My Hotspot",
    "Sammyini Spyderini"
}

-- Lista SOLO de secrets para ESP específico
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

-- Función para guardar posición de spawn
local function saveSpawnPosition()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = player.Character.HumanoidRootPart.Position
        print("🏠 Posición de spawn guardada: " .. tostring(spawnPosition))
    end
end

-- Función para detectar DeliveryHitbox
local function detectDeliveryHitbox()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "DeliveryHitbox" or obj.Name:find("Delivery") then
            deliveryHitbox = obj
            print("📦 DeliveryHitbox encontrado: " .. tostring(obj.Position))
            return obj
        end
    end
    
    print("❌ DeliveryHitbox no encontrado")
    return nil
end

-- Función MEJORADA para verificar si tenemos CUALQUIER brainrot
local function hasStolenBrainrot()
    if not player.Character then return false end
    
    local function checkContainer(container)
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                -- Buscar coincidencias exactas o parciales
                for _, brainrotName in pairs(allBrainrots) do
                    if string.find(item.Name:lower(), brainrotName:lower()) or 
                       string.find(brainrotName:lower(), item.Name:lower()) then
                        return true, item.Name
                    end
                end
                
                -- Búsqueda adicional por palabras clave comunes
                local itemNameLower = item.Name:lower()
                if string.find(itemNameLower, "brainrot") or
                   string.find(itemNameLower, "pipi") or
                   string.find(itemNameLower, "sahur") or
                   string.find(itemNameLower, "ini") or
                   string.find(itemNameLower, "ino") or
                   string.find(itemNameLower, "los") or
                   string.find(itemNameLower, "las") or
                   string.find(itemNameLower, "la ") then
                                        return true, item.Name
                end
            end
        end
        return false, nil
    end
    
    local hasItem, itemName = checkContainer(player.Backpack)
    if not hasItem then
        hasItem, itemName = checkContainer(player.Character)
    end
    
    return hasItem, itemName
end

-- Función para crear botones
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    
    return button
end

-- Función para encontrar el jugador más cercano
local function getClosestPlayer()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance and distance <= 200 then
                shortestDistance = distance
                closestPlayer = otherPlayer
            end
        end
    end
    
    return closestPlayer
end

-- Función para interceptar y redirigir el láser
local function setupLaserRedirection()
    local oldFireServer = nil
    
    for _, remoteEvent in pairs(ReplicatedStorage:GetDescendants()) do
        if remoteEvent:IsA("RemoteEvent") and (remoteEvent.Name == "UseItem" or remoteEvent.Name:find("Laser") or remoteEvent.Name:find("Fire")) then
            if not oldFireServer then
                oldFireServer = remoteEvent.FireServer
                
                remoteEvent.FireServer = function(self, ...)
                    local args = {...}
                    
                    if laserAimbotEnabled then
                        local target = getClosestPlayer()
                        if target and target.Character and target.Character:FindFirstChild("Head") then
                            args[1] = target.Character.Head.Position
                            args[2] = target.Character
                            print("🎯 Láser redirigido hacia: " .. target.Name)
                        end
                    end
                    
                    return oldFireServer(self, unpack(args))
                end
            end
        end
    end
end

-- Función Laser Aimbot
local function toggleLaserAimbot()
    laserAimbotEnabled = not laserAimbotEnabled
    
    if laserAimbotEnabled then
        setupLaserRedirection()
        print("🎯 Laser Aimbot activado - Todos los disparos serán redirigidos automáticamente")
    else
        print("❌ Laser Aimbot desactivado")
    end
end

-- Función TP Flotante a DeliveryHitbox (CORREGIDA)
local function floatingTpToDelivery()
    local hasItem, itemName = hasStolenBrainrot()
    
    if not hasItem then
        print("❌ No tienes ningún brainrot. TP cancelado.")
        return
    end
    
    if isTeleporting then
        print("⚠️ Ya hay un TP en progreso...")
        return
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("❌ Character no encontrado")
        return
    end
    
    if not deliveryHitbox then
        detectDeliveryHitbox()
        if not deliveryHitbox then
            print("❌ DeliveryHitbox no encontrado")
            return
        end
    end
    
    isTeleporting = true
    local humanoidRootPart = player.Character.HumanoidRootPart
    local startPosition = humanoidRootPart.Position
    local targetPosition = deliveryHitbox.Position    
    print("🚁 Iniciando TP Flotante hacia DeliveryHitbox...")
    print("📦 Brainrot detectado: " .. itemName)
    print("🎯 Destino: " .. tostring(targetPosition))
    
    -- Vuelo directo sin PathfindingService para evitar errores
    local direction = (targetPosition - startPosition).Unit
    local totalDistance = (targetPosition - startPosition).Magnitude
    local stepSize = 12
    local steps = math.ceil(totalDistance / stepSize)
    local flyHeight = 15
    
    print("📏 Distancia de vuelo: " .. math.floor(totalDistance) .. " studs")
    print("👣 Pasos de vuelo: " .. steps)
    
    for i = 1, steps do
        local hasItemNow = hasStolenBrainrot()
        if not hasItemNow then
            print("❌ Brainrot perdido durante el vuelo en paso " .. i .. ". TP detenido.")
            break
        end
        
        local stepDistance = math.min(stepSize, totalDistance - (i-1) * stepSize)
        local currentTarget = startPosition + direction * (i * stepSize)
        currentTarget = currentTarget + Vector3.new(0, flyHeight, 0)
        
        -- Verificar obstáculos y ajustar altura si es necesario
        local rayOrigin = humanoidRootPart.Position
        local rayDirection = currentTarget - rayOrigin
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if raycastResult and raycastResult.Instance.CanCollide then
            currentTarget = currentTarget + Vector3.new(0, 8, 0)
            print("⚠️ Evitando obstáculo en paso " .. i .. "...")
        end
        
        -- Teleportarse flotando
        humanoidRootPart.CFrame = CFrame.new(currentTarget)
        
        wait(0.08)
        print("🚁 Paso " .. i .. "/" .. steps .. " - Volando...")
    end
    
    -- Aterrizaje final en DeliveryHitbox
    local finalPosition = Vector3.new(targetPosition.X, targetPosition.Y + 3, targetPosition.Z)
    humanoidRootPart.CFrame = CFrame.new(finalPosition)
    
    isTeleporting = false
    print("✅ ¡LLEGASTE AL DELIVERYHITBOX! Vuelo completado")
end

-- Función Ultra Fast TP to Spawn (CORREGIDA)
local function ultraFastTpToSpawn()
    if isTeleporting then
        print("⚠️ Ya hay un TP en progreso...")
        return
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("❌ Character no encontrado")
        return
    end
    
    if not spawnPosition then
        print("❌ Posición de spawn no detectada. Reintentando...")
        saveSpawnPosition()
        if not spawnPosition then
            -- Usar posición por defecto si no se puede detectar
            spawnPosition = Vector3.new(0, 50, 0)
            print("🏠 Usando posición por defecto: " .. tostring(spawnPosition))
        end
    end
    
    isTeleporting = true
    local humanoidRootPart = player.Character.HumanoidRootPart
    local startPosition = humanoidRootPart.Position
    
    print("🚀 Iniciando Ultra Fast TP hacia SPAWN...")
    
    local direction = (spawnPosition - startPosition).Unit
    local totalDistance = (spawnPosition - startPosition).Magnitude
    local stepSize = 15 -- Pasos de 15 studs
    local steps = math.ceil(totalDistance / stepSize)
    
    print("📏 Distancia total: " .. math.floor(totalDistance) .. " studs")
    print("👣 Pasos necesarios: " .. steps)
    
    for i = 1, steps do
        local stepDistance = math.min(stepSize, totalDistance - (i-1) * stepSize)
        local targetPos = startPosition + direction * (i * stepSize)
        targetPos = targetPos + Vector3.new(0, 15, 0) -- Altura de 15 studs
        
        -- Verificar obstáculos con raycast
        local rayOrigin = humanoidRootPart.Position
        local rayDirection = (targetPos - rayOrigin)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        
        if raycastResult and raycastResult.Instance.CanCollide then
            targetPos = targetPos + Vector3.new(0, 10, 0)
            print("⚠️ Obstáculo detectado en paso " .. i .. ", subiendo altura...")
        end
        
        -- Teleportarse
        humanoidRootPart.CFrame = CFrame.new(targetPos)
        wait(0.03) -- TP súper rápido
        
        print("⚡ Paso " .. i .. "/" .. steps .. " - Posición: " .. tostring(targetPos))
    end
    
    -- Aterrizaje final en spawn
    humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 5, 0))
    
    isTeleporting = false
    print("✅ ¡LLEGASTE AL SPAWN! TP completado exitosamente")
end

-- Función ESP Players
local function togglePlayerEsp()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PlayerESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = otherPlayer.Character
            end
        end
        print("👁️ ESP Players activado")
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character and otherPlayer.Character:FindFirstChild("PlayerESP") then
                otherPlayer.Character.PlayerESP:Destroy()
            end
        end
        print("❌ ESP Players desactivado")
    end
end

-- Función ESP SOLO Secrets (CORREGIDA)
local function toggleSecretEsp()
    secretEspEnabled = not secretEspEnabled
    
    if secretEspEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                -- Buscar SOLO en la lista de secrets
                for _, secretName in pairs(secretBrainrots) do
                    if string.find(obj.Name:lower(), secretName:lower()) or 
                       (obj.Parent and string.find(obj.Parent.Name:lower(), secretName:lower())) then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "SecretESP"
                        highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Dorado para secrets
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 255) -- Magenta para destacar
                        highlight.Parent = obj
                        print("✨ Secret detectado: " .. obj.Name)
                        break
                    end
                end
            end
        end
        print("👁️ ESP Secrets activado (SOLO brainrots secretos)")
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("SecretESP") then
                obj.SecretESP:Destroy()
            end
        end
        print("❌ ESP Secrets desactivado")
    end
end

-- Función ESP TODOS los Brainrots
local function toggleAllBrainrotsEsp()
    local allEspEnabled = not (workspace:FindFirstChild("AllBrainrotsESP") ~= nil)
    
    if allEspEnabled then
        -- Crear marcador para saber que está activado
        local marker = Instance.new("BoolValue")
        marker.Name = "AllBrainrotsESP"
        marker.Parent = workspace
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                -- Buscar en TODA la lista de brainrots
                for _, brainrotName in pairs(allBrainrots) do
                    if string.find(obj.Name:lower(), brainrotName:lower()) or 
                       (obj.Parent and string.find(obj.Parent.Name:lower(), brainrotName:lower())) then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "AllBrainrotESP"
                        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Verde para todos
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
                        highlight.Parent = obj
                        print("🎯 Brainrot detectado: " .. obj.Name)
                        break
                    end
                end
            end
        end
        print("👁️ ESP ALL Brainrots activado (TODOS los brainrots)")
    else
        -- Remover marcador
        if workspace:FindFirstChild("AllBrainrotsESP") then
            workspace.AllBrainrotsESP:Destroy()
        end
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("AllBrainrotESP") then
                obj.AllBrainrotESP:Destroy()
            end
        end
        print("❌ ESP ALL Brainrots desactivado")
    end
end

-- Crear botones
createButton("Laser Aimbot (Auto-Redirect)", toggleLaserAimbot)
createButton("🚁 Fly to DeliveryHitbox", floatingTpToDelivery)
createButton("🚀 Ultra Fast TP to Spawn", ultraFastTpToSpawn)
createButton("ESP Players", togglePlayerEsp)
createButton("ESP Secrets ONLY", toggleSecretEsp)
createButton("ESP ALL Brainrots", toggleAllBrainrotsEsp)

-- Botón para abrir/cerrar panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
toggleButton.Text = "Panel"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Función para toggle del panel
local function togglePanel()
    mainFrame.Visible = not mainFrame.Visible
    
    if mainFrame.Visible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        toggleButton.Text = "Cerrar"
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "Panel"
    end
end

toggleButton.MouseButton1Click:Connect(togglePanel)

-- Tecla para abrir/cerrar (Insert)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        togglePanel()
    end
end)

-- Actualizar canvas size del scroll frame
local function updateScrollSize()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)
updateScrollSize()

-- Guardar posición de spawn al cargar
spawn(function()
    wait(2) -- Esperar a que el character se cargue
    saveSpawnPosition()
    wait(1)
    detectDeliveryHitbox()
end)

-- Monitor de brainrots robados con indicadores visuales mejorados
spawn(function()
    while true do
        wait(0.5)
        local hasItem, itemName = hasStolenBrainrot()
        
        for _, button in pairs(scrollFrame:GetChildren()) do
            if button:IsA("TextButton") then
                if button.Text:find("Fly to DeliveryHitbox") then
                    if hasItem and deliveryHitbox then
                        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Azul para vuelo
                        button.Text = "🚁 FLY READY! (DeliveryHitbox)"
                    else
                        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                        button.Text = "🚁 Fly to DeliveryHitbox"
                    end
                elseif button.Text:find("Ultra Fast TP") then
                    -- Ultra Fast TP siempre disponible
                    button.BackgroundColor3 = Color3.fromRGB(0, 200, 0) -- Verde siempre
                    button.Text = "🚀 FAST TP (ALWAYS READY!)"
                end
            end
        end
    end
end)

-- Sistema de notificaciones en pantalla mejorado
local function createNotification(text, color, duration)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 350, 0, 60)
    notification.Position = UDim2.new(0.5, -175, 0, 100)
    notification.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
    notification.BackgroundTransparency = 0.2
    notification.Text = text
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.SourceSansBold
    notification.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    -- Borde brillante
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Animación de aparición
    notification.BackgroundTransparency = 1
    notification.TextTransparency = 1
    stroke.Transparency = 1
    
    local fadeIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(stroke, TweenInfo.new(0.3), {
        Transparency = 0
    })
    
    fadeIn:Play()
    strokeFadeIn:Play()
    
    -- Desaparecer después del tiempo especificado
    wait(duration or 4)
    local fadeOut = TweenService:Create(notification, TweenInfo.new(0.5), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    })
    local strokeFadeOut = TweenService:Create(stroke, TweenInfo.new(0.5), {
        Transparency = 1
    })
    
    fadeOut:Play()
    strokeFadeOut:Play()
    fadeOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

-- Monitor de brainrots con notificaciones mejoradas
spawn(function()
    local lastHadItem = false
    while true do
        wait(1)
        local hasItem, itemName = hasStolenBrainrot()
        
        if hasItem and not lastHadItem then
            spawn(function()
                createNotification("🎉 Brainrot detectado: " .. itemName .. "\n🚁 Vuelo a DeliveryHitbox disponible!", Color3.fromRGB(0, 150, 0), 5)
            end)
        elseif not hasItem and lastHadItem then
            spawn(function()
                createNotification("❌ Brainrot perdido!\n⚠️ Función de vuelo deshabilitada", Color3.fromRGB(150, 0, 0), 3)
            end)
        end
        
        lastHadItem = hasItem
    end
end)

-- Monitor de DeliveryHitbox
spawn(function()
    while true do
        wait(5) -- Verificar cada 5 segundos
        if not deliveryHitbox or not deliveryHitbox.Parent then
            print("🔍 Redetectando DeliveryHitbox...")
            detectDeliveryHitbox()
        end
    end
end)

-- Función para mostrar información del sistema
local function showSystemInfo()
    spawn(function()
        local info = "📊 INFORMACIÓN DEL SISTEMA:\n"
        info = info .. "🏠 Spawn: " .. (spawnPosition and "✅ Detectado" or "❌ No detectado") .. "\n"
        info = info .. "📦 DeliveryHitbox: " .. (deliveryHitbox and "✅ Encontrado" or "❌ No encontrado") .. "\n"
        local hasItem, itemName = hasStolenBrainrot()
        info = info .. "🎯 Brainrot: " .. (hasItem and ("✅ " .. itemName) or "❌ Ninguno")
        
                createNotification(info, Color3.fromRGB(50, 50, 150), 6)
    end)
end

-- Agregar botón de información del sistema
createButton("📊 System Info", showSystemInfo)

-- Función para actualizar ESP cuando aparezcan nuevos jugadores
Players.PlayerAdded:Connect(function(newPlayer)
    if espEnabled then
        newPlayer.CharacterAdded:Connect(function(character)
            wait(1) -- Esperar a que el character se cargue completamente
            if espEnabled and character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "PlayerESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Parent = character
            end
        end)
    end
end)

-- Función para actualizar ESP cuando aparezcan nuevos brainrots
workspace.DescendantAdded:Connect(function(descendant)
    wait(0.1) -- Pequeña espera para asegurar que el objeto esté completamente cargado
    
    -- ESP para secrets si está activado
    if secretEspEnabled and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
        for _, secretName in pairs(secretBrainrots) do
            if string.find(descendant.Name:lower(), secretName:lower()) or 
               (descendant.Parent and string.find(descendant.Parent.Name:lower(), secretName:lower())) then
                local highlight = Instance.new("Highlight")
                highlight.Name = "SecretESP"
                highlight.FillColor = Color3.fromRGB(255, 215, 0) -- Dorado para secrets
                highlight.OutlineColor = Color3.fromRGB(255, 0, 255) -- Magenta
                highlight.Parent = descendant
                print("✨ Nuevo secret detectado: " .. descendant.Name)
                break
            end
        end
    end
    
    -- ESP para todos los brainrots si está activado
    if workspace:FindFirstChild("AllBrainrotsESP") and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
        for _, brainrotName in pairs(allBrainrots) do
            if string.find(descendant.Name:lower(), brainrotName:lower()) or 
               (descendant.Parent and string.find(descendant.Parent.Name:lower(), brainrotName:lower())) then
                local highlight = Instance.new("Highlight")
                highlight.Name = "AllBrainrotESP"
                highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Verde
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
                highlight.Parent = descendant
                print("🎯 Nuevo brainrot detectado: " .. descendant.Name)
                break
            end
        end
    end
end)

-- Función para guardar nueva posición de spawn cuando el jugador respawnea
player.CharacterAdded:Connect(function(character)
    wait(2) -- Esperar a que se cargue completamente
    saveSpawnPosition()
end)

-- Función de limpieza cuando el jugador se va
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        -- Limpiar ESP y conexiones
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("PlayerESP") or obj:FindFirstChild("SecretESP") or obj:FindFirstChild("AllBrainrotESP") then
                obj:FindFirstChild("PlayerESP"):Destroy()
                obj:FindFirstChild("SecretESP"):Destroy()
                obj:FindFirstChild("AllBrainrotESP"):Destroy()
            end
        end
    end
end)

-- Función para detectar automáticamente cuando aparece un DeliveryHitbox
workspace.ChildAdded:Connect(function(child)
    if child.Name == "DeliveryHitbox" or child.Name:find("Delivery") then
        deliveryHitbox = child
        print("📦 Nuevo DeliveryHitbox detectado automáticamente: " .. tostring(child.Position))
    end
end)

-- Sistema de auto-detección mejorado
spawn(function()
    while true do
        wait(10) -- Verificar cada 10 segundos
        
        -- Re-detectar spawn si no está guardado
        if not spawnPosition then
            saveSpawnPosition()
        end
        
        -- Re-detectar DeliveryHitbox si se perdió
        if not deliveryHitbox or not deliveryHitbox.Parent then
            detectDeliveryHitbox()
        end
    end
end)

print("🎮 Panel CORREGIDO cargado exitosamente!")
print("🔧 Funciones disponibles:")
print("   🎯 Laser Aimbot: Redirige TODOS los disparos hacia jugadores")
print("   🚁 Fly to DeliveryHitbox: Vuelo flotante hacia el punto de entrega (REQUIERE BRAINROT)")
print("   🚀 Ultra Fast TP to Spawn: TP súper rápido hacia tu SPAWN (SIN REQUISITOS)")
print("   👁️ ESP Players: Resalta jugadores")
print("   👁️ ESP Secrets ONLY: Resalta SOLO brainrots secretos (dorado/magenta)")
print("   👁️ ESP ALL Brainrots: Resalta TODOS los brainrots (verde/amarillo)")
print("   📊 System Info: Muestra estado del sistema")
print("⌨️ Presiona Insert o el botón 'Panel' para abrir/cerrar")
print("✅ CORRECCIONES APLICADAS:")
print("   - TP ahora va al SPAWN en lugar de 'base'")
print("   - ESP Secrets separado del ESP All Brainrots")
print("   - Eliminados errores de PathfindingService")
print("   - Auto-detección mejorada de spawn y DeliveryHitbox")
print("   - Sistema de notificaciones funcional")
print("   - " .. #secretBrainrots .. " secrets y " .. #allBrainrots .. " brainrots totales en las listas")
