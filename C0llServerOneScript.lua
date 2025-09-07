-- Panel de Servidores Brainrots Secretos - LocalScript para StarterGui
-- Presiona G para mostrar/ocultar panel, H para activar/desactivar ESP
-- Creado para el juego "Steal a brainrot" de Sammy

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
local espConnections = {}

-- Lista de Brainrots Secretos
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

-- Función para crear el ESP highlight
local function createESPHighlight(brainrotModel)
    if not brainrotModel or espConnections[brainrotModel] then return end
    
    -- Crear highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "SecretBrainrotESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 255) -- Magenta brillante
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0) -- Amarillo
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = brainrotModel
    
    -- Crear línea hacia el brainrot
    local connection = RunService.Heartbeat:Connect(function()
        if not brainrotModel.Parent or not player.Character then
            highlight:Destroy()
            if espConnections[brainrotModel] then
                espConnections[brainrotModel]:Disconnect()
                espConnections[brainrotModel] = nil
            end
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Crear/actualizar línea
        local lineName = "ESPLine_" .. brainrotModel.Name
        local existingLine = workspace:FindFirstChild(lineName)
        if existingLine then existingLine:Destroy() end
        
        local line = Instance.new("Part")
        line.Name = lineName
        line.Anchored = true
        line.CanCollide = false
        line.Material = Enum.Material.Neon
        line.BrickColor = BrickColor.new("Bright yellow")
        line.Transparency = 0.2
        
        local distance = (brainrotModel.Position - humanoidRootPart.Position).Magnitude
        line.Size = Vector3.new(0.2, 0.2, distance)
        line.CFrame = CFrame.lookAt(
            humanoidRootPart.Position:lerp(brainrotModel.Position, 0.5),
            brainrotModel.Position
        )
        line.Parent = workspace
        
        -- Eliminar línea después de un frame
        game:GetService("Debris"):AddItem(line, 0.1)
    end)
    
    espConnections[brainrotModel] = connection
end

-- Función para buscar brainrots secretos en el workspace
local function scanForSecretBrainrots()
    if not espActive then return end
    
    for _, brainrotName in ipairs(SECRET_BRAINROTS) do
        local brainrotModel = workspace:FindFirstChild(brainrotName)
        if brainrotModel and not espConnections[brainrotModel] then
            createESPHighlight(brainrotModel)
            print("🔍 ESP activado para: " .. brainrotName)
        end
    end
end

-- Función para simular obtención de servidores (en un juego real usarías APIs)
local function getServerList()
    -- Esta función simula la obtención de servidores reales
    -- En un entorno real, usarías HttpService para obtener datos de servidores
    local mockServers = {}
    
    for i = 1, math.random(5, 15) do
        local serverBrainrots = {}
        local numBrainrots = math.random(1, 5)
        
        for j = 1, numBrainrots do
            local randomBrainrot = SECRET_BRAINROTS[math.random(1, #SECRET_BRAINROTS)]
            if not table.find(serverBrainrots, randomBrainrot) then
                table.insert(serverBrainrots, randomBrainrot)
            end
        end
        
        table.insert(mockServers, {
            id = "Server_" .. i,
            players = math.random(1, 50),
            maxPlayers = 50,
            ping = math.random(10, 200),
            brainrots = serverBrainrots,
            region = ({"US-East", "US-West", "Europe", "Asia", "Brazil"})[math.random(1, 5)]
        })
    end
    
    return mockServers
end

-- Función para actualizar la lista de servidores
local function updateServerList()
    if not gui then return end
    
    serverList = getServerList()
    local scrollFrame = gui.MainFrame.ServerScrollFrame
    
    -- Limpiar lista anterior
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local yOffset = 0
    for i, server in ipairs(serverList) do
        -- Frame del servidor
        local serverFrame = Instance.new("Frame")
        serverFrame.Name = "Server_" .. i
        serverFrame.Size = UDim2.new(1, -10, 0, 80)
        serverFrame.Position = UDim2.new(0, 5, 0, yOffset)
        serverFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        serverFrame.BorderSizePixel = 0
        serverFrame.Parent = scrollFrame
        
        local serverCorner = Instance.new("UICorner")
        serverCorner.CornerRadius = UDim.new(0, 8)
        serverCorner.Parent = serverFrame
        
        -- Información del servidor
        local serverInfo = Instance.new("TextLabel")
        serverInfo.Size = UDim2.new(0.6, 0, 0.4, 0)
        serverInfo.Position = UDim2.new(0, 10, 0, 5)
        serverInfo.BackgroundTransparency = 1
        serverInfo.Text = string.format("🌐 %s | 👥 %d/%d | 📡 %dms", 
            server.region, server.players, server.maxPlayers, server.ping)
        serverInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
        serverInfo.TextScaled = true
        serverInfo.Font = Enum.Font.Gotham
        serverInfo.TextXAlignment = Enum.TextXAlignment.Left
        serverInfo.Parent = serverFrame
        
        -- Lista de brainrots
        local brainrotText = "🧠 Secretos: " .. table.concat(server.brainrots, ", ")
        if #brainrotText > 60 then
            brainrotText = string.sub(brainrotText, 1, 57) .. "..."
        end
        
        local brainrotInfo = Instance.new("TextLabel")
        brainrotInfo.Size = UDim2.new(0.6, 0, 0.5, 0)
        brainrotInfo.Position = UDim2.new(0, 10, 0.4, 0)
        brainrotInfo.BackgroundTransparency = 1
        brainrotInfo.Text = brainrotText
        brainrotInfo.TextColor3 = Color3.fromRGB(255, 100, 255)
        brainrotInfo.TextScaled = true
        brainrotInfo.Font = Enum.Font.Gotham
        brainrotInfo.TextXAlignment = Enum.TextXAlignment.Left
        brainrotInfo.Parent = serverFrame
        
        -- Botón de unirse
        local joinButton = Instance.new("TextButton")
        joinButton.Size = UDim2.new(0.3, -10, 0.6, 0)
        joinButton.Position = UDim2.new(0.7, 0, 0.2, 0)
        joinButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        joinButton.BorderSizePixel = 0
        joinButton.Text = "🚀 UNIRSE"
        joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        joinButton.TextScaled = true
        joinButton.Font = Enum.Font.GothamBold
        joinButton.Parent = serverFrame
        
        local joinCorner = Instance.new("UICorner")
        joinCorner.CornerRadius = UDim.new(0, 6)
        joinCorner.Parent = joinButton
        
        -- Evento del botón
        joinButton.MouseButton1Click:Connect(function()
            print("🚀 Intentando unirse al servidor: " .. server.id)
            print("🧠 Brainrots disponibles: " .. table.concat(server.brainrots, ", "))
            -- Aquí irían las funciones de teleport reales
            -- TeleportService:TeleportToPlaceInstance(gameId, server.id, player)
        end)
        
        yOffset = yOffset + 85
    end
    
    -- Actualizar tamaño del scroll
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
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
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, -1, -250) -- Fuera de pantalla
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🧠 BRAINROTS SECRETOS - SERVIDORES EN VIVO"
    title.TextColor3 = Color3.fromRGB(255, 100, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Frame de controles
    local controlFrame = Instance.new("Frame")
    controlFrame.Name = "ControlFrame"
    controlFrame.Size = UDim2.new(1, -20, 0, 40)
    controlFrame.Position = UDim2.new(0, 10, 0, 70)
    controlFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mainFrame
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 8)
    controlCorner.Parent = controlFrame
    
    -- Botón ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0.3, -5, 1, -10)
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
    updateStatus.Size = UDim2.new(0.4, -5, 1, -10)
    updateStatus.Position = UDim2.new(0.3, 5, 0, 5)
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
    scrollFrame.Size = UDim2.new(1, -20, 1, -130)
    scrollFrame.Position = UDim2.new(0, 10, 0, 120)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 100, 255)
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
        else
            espButton.Text = "🔍 ESP: OFF"
            espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            print("❌ ESP de Brainrots Secretos DESACTIVADO")
            -- Limpiar ESP existente
            for model, connection in pairs(espConnections) do
                connection:Disconnect()
                local highlight = model:FindFirstChild("SecretBrainrotESP")
                if highlight then highlight:Destroy() end
            end
            espConnections = {}
        end
    end)
    
    refreshButton.MouseButton1Click:Connect(function()
        print("🔄 Refrescando lista de servidores...")
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
    
    local targetPos = panelVisible and UDim2.new(0.5, -300, 0.5, -250) or UDim2.new(0.5, -300, -1, -250)
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Panel de Brainrots mostrado (Presiona G para ocultar)")
        updateServerList()
        -- Iniciar actualización automática
        updateConnection = task.spawn(function()
            while panelVisible and gui do
                wait(5)
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

-- Escaneo continuo de ESP
RunService.Heartbeat:Connect(function()
    if espActive then
        scanForSecretBrainrots()
    end
end)

-- Limpiar al salir
Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player then
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        if updateConnection then
            task.cancel(updateConnection)
        end
    end
end)

print("🚀 Panel de Brainrots Secretos cargado correctamente!")
print("🎮 Presiona G para mostrar/ocultar el panel")
print("🔍 Presiona H para activar/desactivar ESP")
print("🧠 Lista de " .. #SECRET_BRAINROTS .. " brainrots secretos cargada")
