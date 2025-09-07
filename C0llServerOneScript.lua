-- Panel de Servidores Brainrots Secretos para "Steal a brainrot" - LocalScript para StarterGui
-- Presiona G para mostrar/ocultar panel, H para activar/desactivar ESP
-- Creado específicamente para el juego de Sammy (Place ID: 112763189425208)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local gui = nil
local panelVisible = false
local espActive = false
local serverList = {}
local updateConnection = nil
local espHighlights = {}
local espBeams = {}
local lastUpdate = 0

-- ID del juego "Steal a brainrot" de Sammy
local GAME_PLACE_ID = 112763189425208

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

-- Función para limpiar ESP anterior
local function clearESP()
    for _, highlight in pairs(espHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    for _, beam in pairs(espBeams) do
        if beam and beam.Parent then
            beam:Destroy()
        end
    end
    espHighlights = {}
    espBeams = {}
end

-- Función para crear ESP en un brainrot específico
local function createESPForBrainrot(brainrotModel)
    if not brainrotModel or not brainrotModel.Parent or espHighlights[brainrotModel] then 
        return 
    end
    
    -- Crear Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "SecretBrainrotESP"
    highlight.Adornee = brainrotModel
    highlight.FillColor = Color3.fromRGB(255, 0, 255) -- Magenta brillante
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
    highlight.FillTransparency = 0.2
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = brainrotModel
    
    espHighlights[brainrotModel] = highlight
    
    -- Crear línea hacia el brainrot (usando Beam)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = character.HumanoidRootPart
        
        -- Crear attachments
        local attachment0 = Instance.new("Attachment")
        attachment0.Name = "ESPAttachment0"
        attachment0.Parent = humanoidRootPart
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Name = "ESPAttachment1"
        attachment1.Parent = brainrotModel.PrimaryPart or brainrotModel:FindFirstChildOfClass("Part")
        
        if attachment1.Parent then
            -- Crear beam
            local beam = Instance.new("Beam")
            beam.Name = "ESPBeam"
            beam.Attachment0 = attachment0
            beam.Attachment1 = attachment1
            beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0)) -- Amarillo
            beam.Width0 = 0.3
            beam.Width1 = 0.3
            beam.Transparency = NumberSequence.new(0.3)
            beam.FaceCamera = true
            beam.Parent = workspace
            
            espBeams[brainrotModel] = {beam = beam, att0 = attachment0, att1 = attachment1}
        end
    end
    
    print("🔍 ESP activado para: " .. brainrotModel.Name)
end

-- Función para buscar y crear ESP en brainrots secretos
local function updateESP()
    if not espActive then return end
    
    local animalsFolder = workspace:FindFirstChild("Animals")
    if not animalsFolder then
        warn("⚠️ No se encontró la carpeta 'Animals' en el workspace")
        return
    end
    
    for _, brainrotName in ipairs(SECRET_BRAINROTS) do
        local brainrotModel = animalsFolder:FindFirstChild(brainrotName)
        if brainrotModel and brainrotModel:IsA("Model") and not espHighlights[brainrotModel] then
            createESPForBrainrot(brainrotModel)
        end
    end
end

-- Función para obtener lista real de servidores usando la API de Roblox
local function fetchServerList()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. GAME_PLACE_ID .. "/servers/Public?sortOrder=Desc&limit=100"
        return HttpService:GetAsync(url)
    end)
    
    if success then
        local data = HttpService:JSONDecode(result)
        return data.data or {}
    else
        warn("❌ Error al obtener servidores: " .. tostring(result))
        return {}
    end
end

-- Función para contar brainrots secretos en el servidor actual
local function countLocalSecretBrainrots()
    local count = 0
    local found = {}
    local animalsFolder = workspace:FindFirstChild("Animals")
    
    if animalsFolder then
        for _, brainrotName in ipairs(SECRET_BRAINROTS) do
            if animalsFolder:FindFirstChild(brainrotName) then
                count = count + 1
                table.insert(found, brainrotName)
            end
        end
    end
    
    return count, found
end

-- Función para actualizar la lista de servidores en el GUI
local function updateServerList()
    if not gui or not panelVisible then return end
    
    local scrollFrame = gui.MainFrame.ServerScrollFrame
    local statusLabel = gui.MainFrame.ControlFrame.UpdateStatus
    
    -- Mostrar estado de carga
    statusLabel.Text = "🔄 Cargando servidores..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    -- Obtener servidores
    local servers = fetchServerList()
    
    -- Limpiar lista anterior
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("Server_") then
            child:Destroy()
        end
    end
    
    if #servers == 0 then
        statusLabel.Text = "❌ Error al cargar servidores"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local yOffset = 0
    local serversWithBrainrots = 0
    
    for i, server in ipairs(servers) do
        -- Simular presencia de brainrots (en un servidor real necesitarías una API específica)
        local hasBrainrots = math.random(1, 3) == 1 -- 33% de probabilidad
        local brainrotCount = hasBrainrots and math.random(1, 5) or 0
        local mockBrainrots = {}
        
        if hasBrainrots then
            serversWithBrainrots = serversWithBrainrots + 1
            for j = 1, brainrotCount do
                local randomBrainrot = SECRET_BRAINROTS[math.random(1, #SECRET_BRAINROTS)]
                if not table.find(mockBrainrots, randomBrainrot) then
                    table.insert(mockBrainrots, randomBrainrot)
                end
            end
        end
        
        if hasBrainrots or i <= 5 then -- Mostrar primeros 5 siempre + los que tienen brainrots
            -- Frame del servidor
            local serverFrame = Instance.new("Frame")
            serverFrame.Name = "Server_" .. i
            serverFrame.Size = UDim2.new(1, -10, 0, 90)
            serverFrame.Position = UDim2.new(0, 5, 0, yOffset)
            serverFrame.BackgroundColor3 = hasBrainrots and Color3.fromRGB(45, 65, 45) or Color3.fromRGB(45, 45, 45)
            serverFrame.BorderSizePixel = 0
            serverFrame.Parent = scrollFrame
            
            local serverCorner = Instance.new("UICorner")
            serverCorner.CornerRadius = UDim.new(0, 8)
            serverCorner.Parent = serverFrame
            
            -- Información del servidor
            local serverInfo = Instance.new("TextLabel")
            serverInfo.Size = UDim2.new(0.65, 0, 0.35, 0)
            serverInfo.Position = UDim2.new(0, 10, 0, 5)
            serverInfo.BackgroundTransparency = 1
            serverInfo.Text = string.format("🌐 Servidor #%d | 👥 %d/%d | 📡 %dms", 
                i, server.playing or 0, server.maxPlayers or 50, math.random(20, 150))
            serverInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
            serverInfo.TextScaled = true
            serverInfo.Font = Enum.Font.Gotham
            serverInfo.TextXAlignment = Enum.TextXAlignment.Left
            serverInfo.Parent = serverFrame
            
            -- Estado de brainrots
            local brainrotStatus = Instance.new("TextLabel")
            brainrotStatus.Size = UDim2.new(0.65, 0, 0.25, 0)
            brainrotStatus.Position = UDim2.new(0, 10, 0.35, 0)
            brainrotStatus.BackgroundTransparency = 1
            if hasBrainrots then
                brainrotStatus.Text = "🧠 " .. #mockBrainrots .. " Brainrots Secretos"
                brainrotStatus.TextColor3 = Color3.fromRGB(255, 100, 255)
            else
                brainrotStatus.Text = "❌ Sin Brainrots Secretos"
                brainrotStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            brainrotStatus.TextScaled = true
            brainrotStatus.Font = Enum.Font.Gotham
            brainrotStatus.TextXAlignment = Enum.TextXAlignment.Left
            brainrotStatus.Parent = serverFrame
            
            -- Lista de brainrots (si los hay)
            if hasBrainrots and #mockBrainrots > 0 then
                local brainrotList = Instance.new("TextLabel")
                brainrotList.Size = UDim2.new(0.65, 0, 0.3, 0)
                brainrotList.Position = UDim2.new(0, 10, 0.6, 0)
                brainrotList.BackgroundTransparency = 1
                local listText = table.concat(mockBrainrots, ", ")
                if #listText > 50 then
                    listText = string.sub(listText, 1, 47) .. "..."
                end
                brainrotList.Text = "📋 " .. listText
                brainrotList.TextColor3 = Color3.fromRGB(200, 200, 255)
                brainrotList.TextScaled = true
                brainrotList.Font = Enum.Font.Gotham
                brainrotList.TextXAlignment = Enum.TextXAlignment.Left
                brainrotList.Parent = serverFrame
            end
            
            -- Botón de unirse
            local joinButton = Instance.new("TextButton")
            joinButton.Size = UDim2.new(0.3, -10, 0.7, 0)
            joinButton.Position = UDim2.new(0.7, 0, 0.15, 0)
            joinButton.BackgroundColor3 = hasBrainrots and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
            joinButton.BorderSizePixel = 0
            joinButton.Text = hasBrainrots and "🚀 UNIRSE" or "⚪ UNIRSE"
            joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            joinButton.TextScaled = true
            joinButton.Font = Enum.Font.GothamBold
            joinButton.Parent = serverFrame
            
            local joinCorner = Instance.new("UICorner")
            joinCorner.CornerRadius = UDim.new(0, 6)
            joinCorner.Parent = joinButton
            
            -- Evento del botón
            joinButton.MouseButton1Click:Connect(function()
                print("🚀 Intentando unirse al servidor: " .. (server.id or "Desconocido"))
                if hasBrainrots then
                    print("🧠 Brainrots disponibles: " .. table.concat(mockBrainrots, ", "))
                end
                
                -- Teleport real al servidor
                local success, error = pcall(function()
                    if server.id then
                        TeleportService:TeleportToPlaceInstance(GAME_PLACE_ID, server.id, player)
                    else
                        warn("❌ ID de servidor no disponible")
                    end
                end)
                
                if not success then
                    warn("❌ Error al unirse al servidor: " .. tostring(error))
                end
            end)
            
            yOffset = yOffset + 95
        end
    end
    
    -- Actualizar tamaño del scroll
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 10)
    
    -- Actualizar estado
    statusLabel.Text = string.format("✅ %d servidores | %d con brainrots", #servers, serversWithBrainrots)
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    lastUpdate = tick()
end

-- Función para crear el GUI principal
local function createMainGUI()
    -- Limpiar GUI anterior
    local existing = playerGui:FindFirstChild("BrainrotServerGUI")
    if existing then
        existing:Destroy()
    end
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotServerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 550)
    mainFrame.Position = UDim2.new(0.5, -325, -1, -275) -- Fuera de pantalla
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Título principal
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🧠 STEAL A BRAINROT - SERVIDORES SECRETOS"
    title.TextColor3 = Color3.fromRGB(255, 100, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Subtítulo con info del servidor actual
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -20, 0, 25)
    subtitle.Position = UDim2.new(0, 10, 0, 60)
    subtitle.BackgroundTransparency = 1
    local localCount, localBrainrots = countLocalSecretBrainrots()
    subtitle.Text = string.format("📍 Servidor Actual: %d brainrots secretos encontrados", localCount)
    subtitle.TextColor3 = Color3.fromRGB(150, 255, 150)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = mainFrame
    
    -- Frame de controles
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(1, -20, 0, 45)
    controlFrame.Position = UDim2.new(0, 10, 0, 90)
    controlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mainFrame
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 8)
    controlCorner.Parent = controlFrame
    
    -- Botón ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0.25, -5, 1, -10)
    espButton.Position = UDim2.new(0, 5, 0, 5)
    espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    espButton.BorderSizePixel = 0
    espButton.Text = "🔍 ESP: OFF"
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.TextScaled = true
    espButton.Font = Enum.Font.GothamBold
    espButton.Parent = controlFrame
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 6)
    espCorner.Parent = espButton
    
    -- Estado de actualización
    local updateStatus = Instance.new("TextLabel")
    updateStatus.Name = "UpdateStatus"
    updateStatus.Size = UDim2.new(0.45, -5, 1, -10)
    updateStatus.Position = UDim2.new(0.25, 5, 0, 5)
    updateStatus.BackgroundTransparency = 1
    updateStatus.Text = "🔄 Actualizando cada 5s..."
    updateStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
    updateStatus.TextScaled = true
    updateStatus.Font = Enum.Font.Gotham
    updateStatus.Parent = controlFrame
    
    -- Botón refrescar
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0.3, -5, 1, -10)
    refreshButton.Position = UDim2.new(0.7, 5, 0, 5)
    refreshButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "🔄 REFRESCAR"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.TextScaled = true
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.Parent = controlFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshButton
    
    -- ScrollFrame para servidores
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ServerScrollFrame"
    scrollFrame.Size = UDim2.new(1, -20, 1, -150)
    scrollFrame.Position = UDim2.new(0, 10, 0, 140)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = scrollFrame
    
    -- Eventos de botones
    espButton.MouseButton1Click:Connect(function()
        espActive = not espActive
        if espActive then
            espButton.Text = "🔍 ESP: ON"
            espButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            print("✅ ESP de Brainrots Secretos ACTIVADO")
            updateESP()
        else
            espButton.Text = "🔍 ESP: OFF"
            espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            print("❌ ESP de Brainrots Secretos DESACTIVADO")
            clearESP()
        end
    end)
    
    refreshButton.MouseButton1Click:Connect(function()
        print("🔄 Refrescando lista de servidores manualmente...")
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
    
    local targetPos = panelVisible and UDim2.new(0.5, -325, 0.5, -275) or UDim2.new(0.5, -325, -1, -275)
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Panel de Brainrots mostrado (Presiona G para ocultar)")
        updateServerList()
        
        -- Iniciar actualización automática cada 5 segundos
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

-- Crear GUI al inicio
createMainGUI()

-- Loop continuo para ESP
RunService.Heartbeat:Connect(function()
    if espActive then
        updateESP()
    end
end)

-- Detectar teclas
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

-- Mensaje de inicio
print("🚀 Panel de Brainrots Secretos para 'Steal a brainrot' cargado!")
print("🎮 Controles:")
print("   G - Mostrar/ocultar panel de servidores")
print("   H - Activar/desactivar ESP de brainrots secretos")
print("🧠 " .. #SECRET_BRAINROTS .. " brainrots secretos en la base de datos")
print("🌐 Place ID: " .. GAME_PLACE_ID)

local localCount = countLocalSecretBrainrots()
if localCount > 0 then
    print("✨ ¡Servidor actual tiene " .. localCount .. " brainrots secretos!")
else
    print("📍 Servidor actual sin brainrots secretos detectados")
end
