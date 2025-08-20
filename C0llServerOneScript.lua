
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Lista de brainrots secretos a detectar
local SECRET_BRAINROTS = {
    "La Vacca Staturno Saturnita",
    "Chimpanzini Spiderini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Graipuss Medussi",
    "La Grande Combinasion",
    "Nuclearo Dinossauro",
    "Garama and Madundung",
    "Tortuginni Dragonfruitini (Lucky)",
    "Pot Hotspot (Lucky)",
    "Las Vaquitas Saturnitas",
    "Chicleteira Bicicleteira",
    "Agarrini la Palini",
    "Dragon Cannelloni",
    "Los Combinasionas",
    "Karkerkar Kurkur"
}

-- Variables de control
local isScanning = false
local foundServers = {}
local gui = nil

-- Función para crear la interfaz gráfica
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotScanner"
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "🔍 Brainrot Scanner"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 50)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Estado: Iniciando..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ServerList"
    scrollFrame.Size = UDim2.new(1, -20, 1, -90)
    scrollFrame.Position = UDim2.new(0, 10, 0, 80)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 4)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = scrollFrame
    
    return screenGui
end

-- Función para actualizar la GUI
local function updateGUI(status, servers)
    if not gui then return end
    
    local statusLabel = gui.Frame.StatusLabel
    local serverList = gui.Frame.ServerList
    
    statusLabel.Text = "Estado: " .. status
    
    -- Limpiar lista anterior
    for _, child in pairs(serverList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Agregar servidores encontrados
    for i, serverInfo in pairs(servers) do
        local serverLabel = Instance.new("TextLabel")
        serverLabel.Size = UDim2.new(1, -10, 0, 25)
        serverLabel.Position = UDim2.new(0, 5, 0, (i-1) * 27)
        serverLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        serverLabel.Text = string.format("🎯 Servidor: %s | Brainrot: %s", 
            serverInfo.id or "Unknown", serverInfo.brainrot or "Unknown")
        serverLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        serverLabel.TextScaled = true
        serverLabel.Font = Enum.Font.Gotham
        serverLabel.Parent = serverList
        
        local labelCorner = Instance.new("UICorner")
        labelCorner.CornerRadius = UDim.new(0, 3)
        labelCorner.Parent = serverLabel
    end
    
    serverList.CanvasSize = UDim2.new(0, 0, 0, #servers * 27)
end

-- Función para detectar brainrots en un servidor
local function checkServerForBrainrots(serverId)
    local success, result = pcall(function()
        -- Simular verificación de servidor (en un juego real necesitarías acceso a la API del juego)
        -- Esta es una implementación conceptual
        local serverData = {
            players = {},
            items = {},
            events = {}
        }
        
        -- Verificar si algún brainrot está presente
        for _, brainrot in pairs(SECRET_BRAINROTS) do
            -- Aquí implementarías la lógica específica del juego para detectar cada brainrot
            -- Por ejemplo, verificar inventarios de jugadores, objetos en el mundo, etc.
            local chance = math.random(1, 1000)
            if chance <= 2 then -- 0.2% de probabilidad para testing
                return brainrot
            end
        end
        
        return nil
    end)
    
    if success and result then
        return result
    end
    return nil
end

-- Función para obtener lista de servidores
local function getServerList()
    local success, servers = pcall(function()
        -- En un entorno real, usarías la API de Roblox para obtener servidores
        -- Esta es una simulación para demostrar la estructura
        local serverList = {}
        
        for i = 1, 20 do -- Simular 20 servidores
            table.insert(serverList, {
                id = "Server_" .. i,
                playerCount = math.random(1, 50),
                ping = math.random(50, 200)
            })
        end
        
        return serverList
    end)
    
    if success then
        return servers
    else
        return {}
    end
end

-- Función para teletransportarse a un servidor
local function teleportToServer(serverId, brainrotFound)
    local success, errorMsg = pcall(function()
        print("🚀 Teletransportando a servidor:", serverId)
        print("🎯 Brainrot encontrado:", brainrotFound)
        
        -- Intentar teletransporte
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
    end)
    
    if not success then
        warn("❌ Error al teletransportarse:", errorMsg)
        -- Intentar teletransporte alternativo
        TeleportService:Teleport(game.PlaceId, player)
    end
end

-- Función principal de escaneo
local function scanServers()
    if isScanning then return end
    isScanning = true
    
    spawn(function()
        while isScanning do
            local servers = getServerList()
            local foundBrainrots = {}
            
            updateGUI("Escaneando " .. #servers .. " servidores...", foundBrainrots)
            
            for _, server in pairs(servers) do
                if not isScanning then break end
                
                local brainrotFound = checkServerForBrainrots(server.id)
                
                if brainrotFound then
                    print("🎉 ¡BRAINROT ENCONTRADO!")
                    print("📍 Servidor:", server.id)
                    print("🧠 Brainrot:", brainrotFound)
                    
                    table.insert(foundBrainrots, {
                        id = server.id,
                        brainrot = brainrotFound
                    })
                    
                    updateGUI("¡Brainrot encontrado! Teletransportando...", foundBrainrots)
                    
                    -- Teletransporte automático inmediato
                    teleportToServer(server.id, brainrotFound)
                    return -- Salir del bucle después del teletransporte
                end
                
                wait(0.1) -- Pequeña pausa entre verificaciones
            end
            
            if #foundBrainrots == 0 then
                updateGUI("Escaneando... (Sin brainrots encontrados)", foundBrainrots)
            end
            
            wait(5) -- Esperar 5 segundos antes del próximo escaneo completo
        end
    end)
end

-- Función para inicializar el script
local function initialize()
    print("🔍 Iniciando Brainrot Scanner...")
    print("📋 Brainrots objetivo:", #SECRET_BRAINROTS)
    
    -- Crear interfaz gráfica
    gui = createGUI()
    
    -- Iniciar escaneo
    scanServers()
    
    print("✅ Scanner iniciado correctamente")
end

-- Función para detener el scanner
local function stopScanner()
    isScanning = false
    if gui then
        gui:Destroy()
    end
    print("🛑 Scanner detenido")
end

-- Manejar cuando el jugador sale del juego
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopScanner()
    end
end)

-- Inicializar el script
initialize()

-- Comando para reiniciar manualmente (opcional)
player.Chatted:Connect(function(message)
    if message:lower() == "/restart_scanner" then
        stopScanner()
        wait(1)
        initialize()
    elseif message:lower() == "/stop_scanner" then
        stopScanner()
    end
end)
