-- Panel de Servidores Brainrots Secretos CORREGIDO - LocalScript para StarterGui
-- Presiona G para mostrar/ocultar panel, H para activar/desactivar ESP
-- Versión corregida para ReplicatedStorage.Models

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local gui = nil
local panelVisible = false
local espActive = false
local espObjects = {}
local updateConnection = nil
local modelsFolder = nil

-- Lista exacta de Brainrots Secretos
local SECRET_BRAINROTS = {
    "Karkerkar Kurkur",
    "Los Matteos", 
    "Bisonte Giuppitere",
    "La vacca Saturno",
    "Trenostruzzo Turbo 4000",
    "Sammyni Sypderini",
    "Chimpanzini Sipderini",
    "Torrtuginni Dragonfrutini",
    "Dul Dul Dul",
    "Blackhole Goat",
    "Los Spyderinis",
    "Agarrini la Palini",
    "Fragola La La La",
    "Los Tralaleritos",
    "Guerriro Digitale",
    "Las Tralaleritas",
    "Job Sahur",
    "Las Vaquitas Saturnitas",
    "Graipuss Medussi",
    "No mi Hotspot",
    "La sahur Combinasion",
    "Pot Hotspot",
    "Chicleteira Bicicleteira",
    "Los No mis Hotspotsitos",
    "La Grande Combinasion",
    "Los Combinasionas",
    "Nuclearo Dinossauro",
    "Los Hotspotsitos",
    "Tralaledon",
    "Esok Sekolah",
    "Ketupat Kepat",
    "Los bros",
    "La Supreme Combinasion",
    "Ketchuru and Musturu",
    "Garama And Madundung",
    "Spaghetti Tualetti",
    "Dragon Cannelloni"
}

-- Función para esperar y obtener la carpeta Models
local function getModelsFolder()
    if modelsFolder and modelsFolder.Parent then
        return modelsFolder
    end
    
    modelsFolder = ReplicatedStorage:WaitForChild("Models", 10)
    if modelsFolder then
        print("✅ Carpeta Models encontrada en ReplicatedStorage")
        return modelsFolder
    else
        warn("❌ No se pudo encontrar la carpeta Models en ReplicatedStorage")
        return nil
    end
end

-- Función para limpiar ESP
local function clearESP()
    for _, espObj in pairs(espObjects) do
        if espObj.highlight and espObj.highlight.Parent then
            espObj.highlight:Destroy()
        end
        if espObj.billboardGui and espObj.billboardGui.Parent then
            espObj.billboardGui:Destroy()
        end
        if espObj.beam and espObj.beam.Parent then
            espObj.beam:Destroy()
        end
        if espObj.attachment0 and espObj.attachment0.Parent then
            espObj.attachment0:Destroy()
        end
        if espObj.attachment1 and espObj.attachment1.Parent then
            espObj.attachment1:Destroy()
        end
    end
    espObjects = {}
    print("🧹 ESP limpiado")
end

-- Función para crear ESP en un brainrot
local function createESPForModel(model)
    if not model or not model.Parent or espObjects[model] then
        return
    end
    
    local primaryPart = model.PrimaryPart or model:FindFirstChildOfClass("Part")
    if not primaryPart then
        return
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Crear Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BrainrotESP"
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(255, 0, 255) -- Magenta brillante
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    -- Crear BillboardGui con nombre y distancia
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "BrainrotLabel"
    billboardGui.Size = UDim2.new(0, 250, 0, 60)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.Adornee = primaryPart
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = workspace
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.7, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🧠 " .. model.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.7, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📏 Calculando..."
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distanceLabel.Parent = frame
    
    -- Crear línea (Beam)
    local attachment0 = Instance.new("Attachment")
    attachment0.Name = "ESPAttachment0"
    attachment0.Parent = humanoidRootPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Name = "ESPAttachment1"
    attachment1.Parent = primaryPart
    
    local beam = Instance.new("Beam")
    beam.Name = "ESPBeam"
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
    beam.Width0 = 0.8
    beam.Width1 = 0.8
    beam.Transparency = NumberSequence.new(0.2)
    beam.FaceCamera = true
    beam.Parent = workspace
    
    -- Guardar referencias
    espObjects[model] = {
        highlight = highlight,
        billboardGui = billboardGui,
        beam = beam,
        attachment0 = attachment0,
        attachment1 = attachment1,
        distanceLabel = distanceLabel
    }
    
    print("✨ ESP creado para: " .. model.Name)
end

-- Función para actualizar ESP y distancias
local function updateESP()
    if not espActive then return end
    
    local models = getModelsFolder()
    if not models then
        warn("⚠️ No se encontró la carpeta Models en ReplicatedStorage")
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    -- Buscar nuevos brainrots
    for _, brainrotName in pairs(SECRET_BRAINROTS) do
        local brainrotModel = models:FindFirstChild(brainrotName)
        if brainrotModel and brainrotModel:IsA("Model") and not espObjects[brainrotModel] then
            createESPForModel(brainrotModel)
        end
    end
    
    -- Actualizar distancias
    if humanoidRootPart then
        for model, espObj in pairs(espObjects) do
            if model.Parent and espObj.distanceLabel then
                local primaryPart = model.PrimaryPart or model:FindFirstChildOfClass("Part")
                if primaryPart then
                    local distance = (humanoidRootPart.Position - primaryPart.Position).Magnitude
                    espObj.distanceLabel.Text = string.format("📏 %.1f studs", distance)
                end
            end
        end
    end
end

-- Función para buscar brainrots en ReplicatedStorage.Models
local function findLocalBrainrots()
    local foundBrainrots = {}
    local models = getModelsFolder()
    
    if models then
        for _, brainrotName in pairs(SECRET_BRAINROTS) do
            local brainrotModel = models:FindFirstChild(brainrotName)
            if brainrotModel and brainrotModel:IsA("Model") then
                table.insert(foundBrainrots, brainrotName)
            end
        end
        print("🔍 Búsqueda en ReplicatedStorage.Models completada: " .. #foundBrainrots .. " brainrots encontrados")
    else
        warn("❌ No se pudo acceder a ReplicatedStorage.Models")
    end
    
    return foundBrainrots
end

-- Función mejorada para obtener lista de servidores (simulada pero más realista)
local function getServerList()
    local servers = {}
    local currentPlayers = #Players:GetPlayers()
    
    -- Añadir servidor actual primero
    local localBrainrots = findLocalBrainrots()
    table.insert(servers, {
        id = "CURRENT_SERVER",
        region = "Servidor Actual",
        players = currentPlayers,
        maxPlayers = 50,
        ping = 0,
        brainrots = localBrainrots,
        hasSecrets = #localBrainrots > 0,
        isCurrent = true
    })
    
    -- Simular otros servidores con patrones más realistas
    local regions = {"US-East", "US-West", "Europe", "Asia", "Brazil", "Australia"}
    local serverCount = math.random(8, 15)
    
    for i = 1, serverCount do
        local region = regions[math.random(1, #regions)]
        local playerCount = math.random(5, 48)
        
        -- Probabilidad realista de tener brainrots secretos
        local hasSecrets = math.random(1, 4) == 1 -- 25% de probabilidad
        local serverBrainrots = {}
        
        if hasSecrets then
            local brainrotCount = math.random(1, 4) -- 1-4 brainrots por servidor
            local availableBrainrots = {unpack(SECRET_BRAINROTS)}
            
            for j = 1, brainrotCount do
                if #availableBrainrots > 0 then
                    local randomIndex = math.random(1, #availableBrainrots)
                    local selectedBrainrot = availableBrainrots[randomIndex]
                    table.insert(serverBrainrots, selectedBrainrot)
                    table.remove(availableBrainrots, randomIndex)
                end
            end
        end
        
        -- Solo añadir servidores que tienen brainrots secretos (excepto algunos aleatorios para variedad)
        if hasSecrets or math.random(1, 6) == 1 then
            table.insert(servers, {
                id = string.format("SRV_%s_%04d", string.upper(string.sub(region, 1, 2)), math.random(1000, 9999)),
                region = region,
                players = playerCount,
                maxPlayers = 50,
                ping = math.random(15, 250),
                brainrots = serverBrainrots,
                hasSecrets = hasSecrets,
                isCurrent = false
            })
        end
    end
    
    -- Ordenar: servidor actual primero, luego por cantidad de brainrots
    table.sort(servers, function(a, b)
        if a.isCurrent then return true end
        if b.isCurrent then return false end
        if a.hasSecrets and not b.hasSecrets then return true end
        if b.hasSecrets and not a.hasSecrets then return false end
        return #a.brainrots > #b.brainrots
    end)
    
    return servers
end

-- Función para actualizar lista de servidores
local function updateServerList()
    if not gui or not panelVisible then return end
    
    local scrollFrame = gui.MainFrame.ServerScrollFrame
    local statusLabel = gui.MainFrame.ControlFrame.UpdateStatus
    
    statusLabel.Text = "🔄 Escaneando servidores..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Obtener lista de servidores
    local servers = getServerList()
    
    -- Limpiar lista anterior
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("Server_") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    local serversWithSecrets = 0
    
    for i, server in pairs(servers) do
        if server.hasSecrets or server.isCurrent then
            serversWithSecrets = serversWithSecrets + 1
            
            -- Frame del servidor
            local serverFrame = Instance.new("Frame")
            serverFrame.Name = "Server_" .. i
            serverFrame.Size = UDim2.new(1, -10, 0, 110)
            serverFrame.Position = UDim2.new(0, 5, 0, yOffset)
            
            -- Colores según el tipo de servidor
            if server.isCurrent then
                serverFrame.BackgroundColor3 = Color3.fromRGB(70, 50, 90) -- Morado para actual
            elseif #server.brainrots >= 3 then
                serverFrame.BackgroundColor3 = Color3.fromRGB(90, 70, 50) -- Dorado para muchos brainrots
            elseif server.hasSecrets then
                serverFrame.BackgroundColor3 = Color3.fromRGB(50, 70, 50) -- Verde para con secretos
            else
                serverFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Gris normal
            end
            
            serverFrame.BorderSizePixel = 0
            serverFrame.Parent = scrollFrame
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = serverFrame
            
            -- Borde especial para servidor actual
            if server.isCurrent then
                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(255, 100, 255)
                stroke.Thickness = 3
                stroke.Parent = serverFrame
            end
            
            -- Información del servidor
            local serverInfo = Instance.new("TextLabel")
            serverInfo.Size = UDim2.new(0.65, 0, 0.25, 0)
            serverInfo.Position = UDim2.new(0, 10, 0, 5)
            serverInfo.BackgroundTransparency = 1
            
            local statusIcon = server.isCurrent and "📍" or (server.hasSecrets and "✨" or "🌐")
            local serverText = server.isCurrent and "SERVIDOR ACTUAL" or server.id
            
            serverInfo.Text = string.format("%s %s | 👥 %d/%d | 📡 %dms", 
                statusIcon, serverText, server.players, server.maxPlayers, server.ping)
            serverInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
            serverInfo.TextScaled = true
            serverInfo.Font = Enum.Font.Gotham
            serverInfo.TextXAlignment = Enum.TextXAlignment.Left
            serverInfo.Parent = serverFrame
            
            -- Región
            local regionLabel = Instance.new("TextLabel")
            regionLabel.Size = UDim2.new(0.65, 0, 0.2, 0)
            regionLabel.Position = UDim2.new(0, 10, 0.25, 0)
            regionLabel.BackgroundTransparency = 1
            regionLabel.Text = "🌍 " .. server.region
            regionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            regionLabel.TextScaled = true
            regionLabel.Font = Enum.Font.Gotham
            regionLabel.TextXAlignment = Enum.TextXAlignment.Left
            regionLabel.Parent = serverFrame
            
            -- Estado de brainrots
            local brainrotStatus = Instance.new("TextLabel")
            brainrotStatus.Size = UDim2.new(0.65, 0, 0.25, 0)
            brainrotStatus.Position = UDim2.new(0, 10, 0.45, 0)
            brainrotStatus.BackgroundTransparency = 1
            
            if #server.brainrots > 0 then
                brainrotStatus.Text = string.format("🧠 %d Brainrots Secretos Detectados", #server.brainrots)
                brainrotStatus.TextColor3 = Color3.fromRGB(255, 150, 255)
            else
                brainrotStatus.Text = "❌ Sin Brainrots Secretos"
                brainrotStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            
            brainrotStatus.TextScaled = true
            brainrotStatus.Font = Enum.Font.GothamBold
            brainrotStatus.TextXAlignment = Enum.TextXAlignment.Left
            brainrotStatus.Parent = serverFrame
            
            -- Lista específica de brainrots
            if #server.brainrots > 0 then
                local brainrotList = Instance.new("TextLabel")
                brainrotList.Size = UDim2.new(0.65, 0, 0.25, 0)
                brainrotList.Position = UDim2.new(0, 10, 0.7, 0)
                brainrotList.BackgroundTransparency = 1
                
                local listText = "📋 " .. table.concat(server.brainrots, " • ")
                if #listText > 90 then
                    listText = string.sub(listText, 1, 87) .. "..."
                end
                
                brainrotList.Text = listText
                brainrotList.TextColor3 = Color3.fromRGB(150, 255, 150)
                brainrotList.TextScaled = true
                brainrotList.Font = Enum.Font.Gotham
                brainrotList.TextXAlignment = Enum.TextXAlignment.Left
                brainrotList.Parent = serverFrame
            end
            
            -- Botón de acción
            local actionButton = Instance.new("TextButton")
            actionButton.Size = UDim2.new(0.3, -10, 0.75, 0)
            actionButton.Position = UDim2.new(0.7, 0, 0.125, 0)
            
            if server.isCurrent then
                actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
                actionButton.Text = "📍\nACTUAL"
            elseif server.hasSecrets then
                actionButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                actionButton.Text = "🚀\nUNIRSE"
            else
                actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                actionButton.Text = "⚪\nUNIRSE"
            end
            
            actionButton.BorderSizePixel = 0
            actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionButton.TextScaled = true
            actionButton.Font = Enum.Font.GothamBold
            actionButton.Parent = serverFrame
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = actionButton
            
            -- Evento del botón
            if not server.isCurrent then
                actionButton.MouseButton1Click:Connect(function()
                    if #server.brainrots > 0 then
                        print("🚀 Intentando unirse al servidor: " .. server.id)
                        print("✨ Brainrots disponibles: " .. table.concat(server.brainrots, ", "))
                        print("📍 Región: " .. server.region .. " | Jugadores: " .. server.players)
                        
                        -- Aquí irían las funciones de teleport reales
                        -- En un entorno real necesitarías el JobId específico del servidor
                        warn("⚠️ Teleport simulado - En el juego real necesitarías JobId específico")
                    else
                        print("❌ Este servidor no tiene brainrots secretos")
                    end
                end)
            end
            
            yOffset = yOffset + 115
        end
    end
    
    -- Actualizar canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    
    -- Actualizar estado
    local totalWithSecrets = serversWithSecrets - (servers[1].isCurrent and 1 or 0)
    statusLabel.Text = string.format("✅ %d servidores encontrados | %d con brainrots", 
        #servers, totalWithSecrets)
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    print("📊 Actualización completada: " .. #servers .. " servidores, " .. totalWithSecrets .. " con brainrots secretos")
end

-- Función para crear GUI principal
local function createMainGUI()
    local existing = playerGui:FindFirstChild("BrainrotServerGUI")
    if existing then existing:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotServerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 750, 0, 650)
    mainFrame.Position = UDim2.new(0.5, -375, -1, -325)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Gradiente de fondo
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 10, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 20))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🧠 STEAL A BRAINROT - BUSCADOR AVANZADO DE SECRETOS"
    title.TextColor3 = Color3.fromRGB(255, 100, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Información local
    local localBrainrots = findLocalBrainrots()
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -20, 0, 25)
    subtitle.Position = UDim2.new(0, 10, 0, 60)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = string.format("📍 ReplicatedStorage.Models: %d/%d brainrots secretos • %d jugadores online", 
        #localBrainrots, #SECRET_BRAINROTS, #Players:GetPlayers())
    subtitle.TextColor3 = Color3.fromRGB(150, 255, 150)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Frame de controles
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(1, -20, 0, 50)
    controlFrame.Position = UDim2.new(0, 10, 0, 90)
    controlFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mainFrame
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 10)
    controlCorner.Parent = controlFrame
    
    -- Botón ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0.22, -5, 1, -10)
    espButton.Position = UDim2.new(0, 5, 0, 5)
    espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    espButton.BorderSizePixel = 0
    espButton.Text = "🔍 ESP: OFF"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.TextScaled = true
    espButton.Font = Enum.Font.GothamBold
    espButton.Parent = controlFrame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espButton
    
    -- Status de actualización
    local updateStatus = Instance.new("TextLabel")
    updateStatus.Name = "UpdateStatus"
    updateStatus.Size = UDim2.new(0.5, -5, 1, -10)
    updateStatus.Position = UDim2.new(0.22, 5, 0, 5)
    updateStatus.BackgroundTransparency = 1
    updateStatus.Text = "🔄 Auto-actualización cada 5 segundos"
    updateStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    updateStatus.TextScaled = true
    updateStatus.Font = Enum.Font.Gotham
    updateStatus.Parent = controlFrame
    
    -- Botón refrescar
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0.28, -5, 1, -10)
    refreshButton.Position = UDim2.new(0.72, 5, 0, 5)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "🔄 REFRESCAR AHORA"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.TextScaled = true
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.Parent = controlFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshButton
    
    -- ScrollFrame para servidores
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ServerScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -155)
    scrollFrame.Position = UDim2.new(0, 10, 0, 145)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 12
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 10)
    scrollCorner.Parent = scrollFrame
    
    -- Eventos
    espButton.MouseButton1Click:Connect(function()
        espActive = not espActive
        if espActive then
            espButton.Text = "🔍 ESP: ON"
            espButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            print("✅ ESP de Brainrots Secretos ACTIVADO")
            print("🔍 Buscando en ReplicatedStorage.Models...")
            updateESP()
        else
            espButton.Text = "🔍 ESP: OFF"
            espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            print("❌ ESP de Brainrots Secretos DESACTIVADO")
            clearESP()
        end
    end)
    
    refreshButton.MouseButton1Click:Connect(function()
        print("🔄 Refrescando servidores manualmente...")
        updateServerList()
    end)
    
    gui = screenGui
    return screenGui
end

-- Función para mostrar/ocultar panel
local function togglePanel()
    if not gui then return end
    
    panelVisible = not panelVisible
    local frame = gui.MainFrame
    
    local targetPos = panelVisible and UDim2.new(0.5, -375, 0.5, -325) or UDim2.new(0.5, -375, -1, -325)
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Panel mostrado (Presiona G para ocultar)")
        updateServerList()
        
        -- Auto-actualización cada 5 segundos
        updateConnection = task.spawn(function()
            while panelVisible and gui do
                task.wait(5)
                if panelVisible then
                    updateServerList()
                end
            end
        end)
    else
        print("📱 Panel ocultado (Presiona G para mostrar)")
        if updateConnection then
            task.cancel(updateConnection)
            updateConnection = nil
        end
    end
end

-- Crear GUI
createMainGUI()

-- Loop continuo para ESP (cada 0.5 segundos para mejor rendimiento)
task.spawn(function()
    while true do
        if espActive then
            updateESP()
        end
        task.wait(0.5)
    end
end)

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        togglePanel()
    elseif input.KeyCode == Enum.KeyCode.H then
        if gui then
            gui.MainFrame.ControlFrame.ESPButton.MouseButton1Click:Fire()
        end
    end
end)

-- Limpiar al salir
Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        clearESP()
        if updateConnection then
            task.cancel(updateConnection)
        end
    end
end)

-- Mensaje inicial mejorado
print("🚀 Panel de Brainrots Secretos CORREGIDO cargado!")
print("📂 Ubicación: ReplicatedStorage.Models")
print("🎮 Controles:")
print("   G - Mostrar/ocultar panel de servidores")
print("   H - Activar/desactivar ESP de brainrots")
print("🧠 " .. #SECRET_BRAINROTS .. " brainrots en la base de datos")

-- Verificar carpeta Models
task.spawn(function()
    local models = getModelsFolder()
    if models then
        local localBrainrots = findLocalBrainrots()
        if #localBrainrots > 0 then
            print("✨ ¡Servidor actual tiene " .. #localBrainrots .. " brainrots secretos!")
            print("📋 Encontrados: " .. table.concat(localBrainrots, ", "))
        else
            print("📍 Servidor actual sin brainrots secretos en ReplicatedStorage.Models")
        end
    else
        warn("❌ No se pudo encontrar ReplicatedStorage.Models")
    end
end)
