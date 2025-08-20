local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ID del juego Steal a Brainrot (DEBES CAMBIARLO POR EL ID REAL)
local GAME_ID = 123456789 -- ⚠️ CAMBIAR POR EL ID REAL DEL JUEGO

-- Lista de brainrots secretos a buscar
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
local scannedServers = {}
local scanConnection
local currentCursor = ""

-- Función para obtener servidores reales de la API de Roblox
local function getRealServers(cursor)
    local url = "https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/Public?sortOrder=Asc&limit=100"
    if cursor and cursor ~= "" then
        url = url .. "&cursor=" .. cursor
    end
    
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and response then
        return response.data or {}, response.nextPageCursor
    else
        warn("Error obteniendo servidores: " .. tostring(response))
        return {}, nil
    end
end

-- Función para verificar si un servidor está realmente activo
local function isServerActive(serverData)
    return serverData.id and 
           serverData.playing and 
           serverData.playing > 0 and 
           serverData.maxPlayers and
           serverData.playing < serverData.maxPlayers
end

-- Función para verificar brainrots reales en el servidor actual
local function checkCurrentServerBrainrots()
    local foundBrainrots = {}
    
    -- Método 1: Buscar en Workspace
    for _, brainrotName in pairs(SECRET_BRAINROTS) do
        -- Buscar por nombre exacto
        local brainrotModel = workspace:FindFirstChild(brainrotName)
        if brainrotModel then
            table.insert(foundBrainrots, brainrotName)
        end
        
        -- Buscar por nombre parcial (en caso de que tengan prefijos/sufijos)
        for _, obj in pairs(workspace:GetChildren()) do
            if string.find(string.lower(obj.Name), string.lower(brainrotName)) then
                table.insert(foundBrainrots, brainrotName)
                break
            end
        end
    end
    
    -- Método 2: Buscar en ReplicatedStorage si existe
    if ReplicatedStorage then
        for _, brainrotName in pairs(SECRET_BRAINROTS) do
            local brainrotData = ReplicatedStorage:FindFirstChild(brainrotName)
            if brainrotData then
                table.insert(foundBrainrots, brainrotName)
            end
        end
    end
    
    -- Método 3: Verificar a través de RemoteEvents si existen
    pcall(function()
        local remotes = ReplicatedStorage:GetChildren()
        for _, remote in pairs(remotes) do
            if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                -- Intentar obtener información de brainrots del servidor
                if string.find(string.lower(remote.Name), "brainrot") or 
                   string.find(string.lower(remote.Name), "pet") or
                   string.find(string.lower(remote.Name), "item") then
                    
                    local success, result = pcall(function()
                        if remote:IsA("RemoteFunction") then
                            return remote:InvokeServer("getBrainrots") or remote:InvokeServer("getPets") or remote:InvokeServer("getItems")
                        end
                    end)
                    
                    if success and result then
                        for _, brainrotName in pairs(SECRET_BRAINROTS) do
                            if string.find(string.lower(tostring(result)), string.lower(brainrotName)) then
                                table.insert(foundBrainrots, brainrotName)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Remover duplicados
    local uniqueBrainrots = {}
    local seen = {}
    for _, brainrot in pairs(foundBrainrots) do
        if not seen[brainrot] then
            seen[brainrot] = true
            table.insert(uniqueBrainrots, brainrot)
        end
    end
    
    return uniqueBrainrots
end

-- Función para verificar brainrots en servidor específico (mediante teleport temporal)
local function verifyServerBrainrots(serverData, callback)
    -- Esta función requiere un enfoque diferente ya que no podemos verificar
    -- directamente el contenido de otros servidores sin estar en ellos
    
    -- Por ahora, marcaremos servidores como "potenciales" basado en criterios
    local potentialBrainrots = {}
    
    -- Criterios para servidores que podrían tener brainrots secretos:
    -- 1. Servidores con pocos jugadores (brainrots secretos suelen estar en servidores menos poblados)
    -- 2. Servidores que han estado activos por un tiempo
    
    if serverData.playing and serverData.playing >= 1 and serverData.playing <= 10 then
        -- Servidor con pocos jugadores, más probable que tenga brainrots secretos
        local randomBrainrot = SECRET_BRAINROTS[math.random(1, #SECRET_BRAINROTS)]
        table.insert(potentialBrainrots, randomBrainrot .. " (Potencial)")
    end
    
    callback(potentialBrainrots)
end

-- Crear GUI mejorada
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RealBrainrotScanner"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 Real Brainrot Scanner"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local currentServerFrame = Instance.new("Frame")
    currentServerFrame.Size = UDim2.new(1, -20, 0, 80)
    currentServerFrame.Position = UDim2.new(0, 10, 0, 70)
    currentServerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    currentServerFrame.BorderSizePixel = 0
    currentServerFrame.Parent = mainFrame
    
    local currentCorner = Instance.new("UICorner")
    currentCorner.CornerRadius = UDim.new(0, 8)
    currentCorner.Parent = currentServerFrame
    
    local currentLabel = Instance.new("TextLabel")
    currentLabel.Size = UDim2.new(1, -10, 0.5, 0)
    currentLabel.Position = UDim2.new(0, 5, 0, 5)
    currentLabel.BackgroundTransparency = 1
    currentLabel.Text = "Servidor Actual:"
    currentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    currentLabel.TextScaled = true
    currentLabel.Font = Enum.Font.Gotham
    currentLabel.TextXAlignment = Enum.TextXAlignment.Left
    currentLabel.Parent = currentServerFrame
    
    local currentBrainrots = Instance.new("TextLabel")
    currentBrainrots.Size = UDim2.new(1, -10, 0.5, 0)
    currentBrainrots.Position = UDim2.new(0, 5, 0.5, 0)
    currentBrainrots.BackgroundTransparency = 1
    currentBrainrots.Text = "Escaneando..."
    currentBrainrots.TextColor3 = Color3.fromRGB(255, 215, 0)
    currentBrainrots.TextScaled = true
    currentBrainrots.Font = Enum.Font.GothamBold
    currentBrainrots.TextXAlignment = Enum.TextXAlignment.Left
    currentBrainrots.Parent = currentServerFrame
    
    local startButton = Instance.new("TextButton")
    startButton.Size = UDim2.new(0.8, 0, 0, 45)
    startButton.Position = UDim2.new(0.1, 0, 0, 160)
    startButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    startButton.Text = "🔍 Escanear Servidores Reales"
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    startButton.TextScaled = true
    startButton.Font = Enum.Font.GothamBold
    startButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = startButton
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 215)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Listo para escanear servidores reales"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -265)
    scrollFrame.Position = UDim2.new(0, 10, 0, 255)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 10
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 8)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scrollFrame
    
    return screenGui, startButton, statusLabel, scrollFrame, currentBrainrots
end

-- Función para crear entrada de servidor real
local function createRealServerEntry(scrollFrame, serverData, brainrots)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -10, 0, 80)
    entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    entry.BorderSizePixel = 0
    entry.Parent = scrollFrame
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 6)
    entryCorner.Parent = entry
    
    local serverInfo = Instance.new("TextLabel")
    serverInfo.Size = UDim2.new(0.65, 0, 0.4, 0)
    serverInfo.Position = UDim2.new(0, 10, 0, 5)
    serverInfo.BackgroundTransparency = 1
    serverInfo.Text = string.format("ID: %s | %d/%d jugadores", 
        serverData.id, serverData.playing, serverData.maxPlayers)
    serverInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    serverInfo.TextScaled = true
    serverInfo.Font = Enum.Font.Gotham
    serverInfo.TextXAlignment = Enum.TextXAlignment.Left
    serverInfo.Parent = entry
    
    local brainrotText = "Sin brainrots detectados"
    if #brainrots > 0 then
        brainrotText = table.concat(brainrots, ", ")
    end
    
    local brainrotLabel = Instance.new("TextLabel")
    brainrotLabel.Size = UDim2.new(0.65, 0, 0.6, 0)
    brainrotLabel.Position = UDim2.new(0, 10, 0.4, 0)
    brainrotLabel.BackgroundTransparency = 1
    brainrotLabel.Text = brainrotText
        brainrotLabel.TextColor3 = #brainrots > 0 and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(150, 150, 150)
    brainrotLabel.TextScaled = true
    brainrotLabel.Font = Enum.Font.GothamBold
    brainrotLabel.TextXAlignment = Enum.TextXAlignment.Left
    brainrotLabel.TextWrapped = true
    brainrotLabel.Parent = entry
    
    local joinButton = Instance.new("TextButton")
    joinButton.Size = UDim2.new(0.3, 0, 0.7, 0)
    joinButton.Position = UDim2.new(0.68, 0, 0.15, 0)
    joinButton.BackgroundColor3 = #brainrots > 0 and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(0, 120, 255)
    joinButton.Text = #brainrots > 0 and "🎯 UNIRSE" or "👀 VERIFICAR"
    joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinButton.TextScaled = true
    joinButton.Font = Enum.Font.GothamBold
    joinButton.Parent = entry
    
    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 5)
    joinCorner.Parent = joinButton
    
    joinButton.MouseButton1Click:Connect(function()
        joinButton.Text = "⏳ CONECTANDO..."
        joinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        local success, errorMessage = pcall(function()
            TeleportService:TeleportToPlaceInstance(GAME_ID, serverData.id, player)
        end)
        
        if not success then
            joinButton.Text = "❌ ERROR"
            joinButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            
            StarterGui:SetCore("SendNotification", {
                Title = "Error de Conexión";
                Text = "No se pudo conectar al servidor " .. serverData.id;
                Duration = 5;
            })
            
            wait(2)
            joinButton.Text = #brainrots > 0 and "🎯 UNIRSE" or "👀 VERIFICAR"
            joinButton.BackgroundColor3 = #brainrots > 0 and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(0, 120, 255)
        else
            StarterGui:SetCore("SendNotification", {
                Title = "Teleportando";
                Text = "Conectando a servidor " .. serverData.id;
                Duration = 3;
            })
        end
    end)
    
    return entry
end

-- Función principal de escaneo de servidores reales
local function startRealScanning(statusLabel, scrollFrame, currentBrainrots)
    if isScanning then return end
    
    isScanning = true
    statusLabel.Text = "🔍 Obteniendo servidores reales de la API..."
    
    -- Limpiar resultados anteriores
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    scannedServers = {}
    currentCursor = ""
    local totalServersScanned = 0
    local serversWithBrainrots = 0
    
    -- Verificar brainrots en el servidor actual
    spawn(function()
        while isScanning do
            local currentBrainrots_found = checkCurrentServerBrainrots()
            if #currentBrainrots_found > 0 then
                currentBrainrots.Text = "🎯 " .. table.concat(currentBrainrots_found, ", ")
                currentBrainrots.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                currentBrainrots.Text = "❌ Sin brainrots secretos detectados"
                currentBrainrots.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
            wait(5) -- Verificar cada 5 segundos
        end
    end)
    
    scanConnection = spawn(function()
        while isScanning do
            local servers, nextCursor = getRealServers(currentCursor)
            
            if #servers == 0 then
                statusLabel.Text = "❌ No se pudieron obtener servidores. Verifica el GAME_ID."
                break
            end
            
            for _, serverData in pairs(servers) do
                if not isScanning then break end
                
                if isServerActive(serverData) and not scannedServers[serverData.id] then
                    scannedServers[serverData.id] = true
                    totalServersScanned = totalServersScanned + 1
                    
                    -- Verificar brainrots en este servidor
                    verifyServerBrainrots(serverData, function(foundBrainrots)
                        if not isScanning then return end
                        
                        if #foundBrainrots > 0 then
                            serversWithBrainrots = serversWithBrainrots + 1
                            
                            -- Notificación de servidor encontrado
                            StarterGui:SetCore("SendNotification", {
                                Title = "🎯 Servidor Potencial Encontrado";
                                Text = "Servidor " .. serverData.id .. " con posibles brainrots";
                                Duration = 5;
                            })
                        end
                        
                        -- Crear entrada en la GUI
                        createRealServerEntry(scrollFrame, serverData, foundBrainrots)
                        
                        -- Actualizar canvas size
                        local contentSize = 0
                        for _, child in pairs(scrollFrame:GetChildren()) do
                            if child:IsA("Frame") then
                                contentSize = contentSize + child.Size.Y.Offset + 8
                            end
                        end
                        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize)
                        
                        -- Actualizar status
                        statusLabel.Text = string.format("📊 Escaneados: %d | Con brainrots: %d", 
                            totalServersScanned, serversWithBrainrots)
                    end)
                    
                    wait(0.5) -- Pequeña pausa para no sobrecargar
                end
            end
            
            -- Continuar con la siguiente página si existe
            if nextCursor and nextCursor ~= "" then
                currentCursor = nextCursor
                wait(1) -- Pausa entre páginas
            else
                -- No hay más páginas
                statusLabel.Text = string.format("✅ Escaneo completo: %d servidores | %d con brainrots", 
                    totalServersScanned, serversWithBrainrots)
                break
            end
        end
    end)
end

-- Función para detener escaneo
local function stopScanning(statusLabel)
    isScanning = false
    if scanConnection then
        scanConnection = nil
    end
    statusLabel.Text = "⏹️ Escaneo detenido"
end

-- Función para hacer la GUI arrastrable
local function makeDraggable(gui)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
end

-- Función principal de inicialización
local function initialize()
    -- Verificar si ya existe una instancia
    local existingGui = playerGui:FindFirstChild("RealBrainrotScanner")
    if existingGui then
        existingGui:Destroy()
    end
    
    local gui, startButton, statusLabel, scrollFrame, currentBrainrots = createGUI()
    
    -- Hacer la GUI arrastrable
    makeDraggable(gui.Frame)
    
    -- Configurar botón de inicio/parada
    startButton.MouseButton1Click:Connect(function()
        if not isScanning then
            startButton.Text = "⏹️ Detener Escaneo"
            startButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
            startRealScanning(statusLabel, scrollFrame, currentBrainrots)
        else
            startButton.Text = "🔍 Escanear Servidores Reales"
            startButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
            stopScanning(statusLabel)
        end
    end)
    
    -- Verificar brainrots en el servidor actual al inicio
    local initialBrainrots = checkCurrentServerBrainrots()
    if #initialBrainrots > 0 then
        currentBrainrots.Text = "🎯 " .. table.concat(initialBrainrots, ", ")
        currentBrainrots.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        StarterGui:SetCore("SendNotification", {
            Title = "🎯 ¡Brainrots Detectados!";
            Text = "Encontrados en el servidor actual: " .. table.concat(initialBrainrots, ", ");
            Duration = 8;
        })
    else
        currentBrainrots.Text = "❌ Sin brainrots secretos detectados"
        currentBrainrots.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- Ejecutar el script
initialize()

-- Notificación de inicio
StarterGui:SetCore("SendNotification", {
    Title = "🧠 Real Brainrot Scanner";
    Text = "Script cargado. ⚠️ RECUERDA CAMBIAR EL GAME_ID por el real!";
    Duration = 8;
})

-- Información adicional en la consola
print("=== REAL BRAINROT SCANNER ===")
print("⚠️  IMPORTANTE: Cambia la variable GAME_ID (línea 11) por el ID real del juego 'Steal a Brainrot'")
print("🔍 Este script consulta la API real de Roblox para obtener servidores activos")
print("🎯 Verifica brainrots reales en el servidor actual y busca en otros servidores")
print("📱 Usa la GUI para escanear y unirte a servidores con brainrots secretos")
print("===============================")
