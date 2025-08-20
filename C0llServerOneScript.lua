local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ID del juego Steal a Brainrot (reemplaza con el ID real)
local GAME_ID = 109983668079237 -- Cambia este número por el ID real del juego

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
local foundServers = {}
local scanConnection

-- Crear GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotScanner"
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Brainrot Server Scanner"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = mainFrame
    
    local startButton = Instance.new("TextButton")
    startButton.Size = UDim2.new(0.8, 0, 0, 40)
    startButton.Position = UDim2.new(0.1, 0, 0, 60)
    startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    startButton.Text = "Iniciar Escaneo"
    startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    startButton.TextScaled = true
    startButton.Font = Enum.Font.SourceSansBold
    startButton.Parent = mainFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = startButton
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 30)
    statusLabel.Position = UDim2.new(0, 0, 0, 110)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Listo para escanear"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.Parent = mainFrame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -160)
    scrollFrame.Position = UDim2.new(0, 10, 0, 150)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 5)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scrollFrame
    
    return screenGui, startButton, statusLabel, scrollFrame
end

-- Función para obtener servidores activos
local function getActiveServers()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result.data then
        return result.data
    end
    return {}
end

-- Función para verificar brainrots en un servidor específico
local function checkBrainrotsInServer(serverId, callback)
    spawn(function()
        local success, result = pcall(function()
            -- Simular verificación de brainrots (aquí necesitarías la lógica específica del juego)
            -- Esta es una implementación de ejemplo que deberás adaptar
            local foundBrainrots = {}
            
            -- Aquí iría la lógica real para verificar los brainrots en el servidor
            -- Por ejemplo, usando RemoteEvents o verificando el workspace del servidor
            
            -- Simulación temporal (reemplaza con lógica real)
            if math.random(1, 10) == 1 then -- 10% de probabilidad para demo
                local randomBrainrot = SECRET_BRAINROTS[math.random(1, #SECRET_BRAINROTS)]
                table.insert(foundBrainrots, randomBrainrot)
            end
            
            return foundBrainrots
        end)
        
        if success then
            callback(result or {})
        else
            callback({})
        end
    end)
end

-- Función para teletransportar al jugador
local function teleportToServer(serverId, brainrotName)
    local success, errorMessage = pcall(function()
        TeleportService:TeleportToPlaceInstance(GAME_ID, serverId, player)
    end)
    
    if not success then
        StarterGui:SetCore("SendNotification", {
            Title = "Error de Teleport";
            Text = "No se pudo conectar al servidor";
            Duration = 5;
        })
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Teleportando...";
            Text = "Conectando a servidor con " .. brainrotName;
            Duration = 3;
        })
    end
end

-- Función para crear entrada de servidor en la lista
local function createServerEntry(scrollFrame, serverId, brainrotName, playerCount)
    local entry = Instance.new("Frame")
    entry.Size = UDim2.new(1, -10, 0, 60)
    entry.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    entry.BorderSizePixel = 0
    entry.Parent = scrollFrame
    
    local entryCorner = Instance.new("UICorner")
    entryCorner.CornerRadius = UDim.new(0, 5)
    entryCorner.Parent = entry
    
    local brainrotLabel = Instance.new("TextLabel")
    brainrotLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
    brainrotLabel.Position = UDim2.new(0, 10, 0, 5)
    brainrotLabel.BackgroundTransparency = 1
    brainrotLabel.Text = brainrotName
    brainrotLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    brainrotLabel.TextScaled = true
    brainrotLabel.Font = Enum.Font.SourceSansBold
    brainrotLabel.TextXAlignment = Enum.TextXAlignment.Left
    brainrotLabel.Parent = entry
    
    local serverInfo = Instance.new("TextLabel")
    serverInfo.Size = UDim2.new(0.7, 0, 0.5, 0)
    serverInfo.Position = UDim2.new(0, 10, 0.5, 0)
    serverInfo.BackgroundTransparency = 1
    serverInfo.Text = "Servidor: " .. serverId .. " | Jugadores: " .. playerCount
    serverInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    serverInfo.TextScaled = true
    serverInfo.Font = Enum.Font.SourceSans
    serverInfo.TextXAlignment = Enum.TextXAlignment.Left
    serverInfo.Parent = entry
    
    local joinButton = Instance.new("TextButton")
    joinButton.Size = UDim2.new(0.25, 0, 0.7, 0)
    joinButton.Position = UDim2.new(0.7, 5, 0.15, 0)
    joinButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    joinButton.Text = "UNIRSE"
    joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    joinButton.TextScaled = true
    joinButton.Font = Enum.Font.SourceSansBold
    joinButton.Parent = entry
    
    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 3)
    joinCorner.Parent = joinButton
    
    joinButton.MouseButton1Click:Connect(function()
        teleportToServer(serverId, brainrotName)
    end)
    
    return entry
end

-- Función principal de escaneo
local function startScanning(statusLabel, scrollFrame)
    if isScanning then return end
    
    isScanning = true
    statusLabel.Text = "Escaneando servidores..."
    
    -- Limpiar resultados anteriores
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    foundServers = {}
    
    scanConnection = RunService.Heartbeat:Connect(function()
        local servers = getActiveServers()
        
        for _, server in pairs(servers) do
            if server.id and server.playing and server.playing > 0 then
                checkBrainrotsInServer(server.id, function(brainrots)
                    if #brainrots > 0 then
                        for _, brainrot in pairs(brainrots) do
                            if not foundServers[server.id] then
                                foundServers[server.id] = true
                                
                                -- Crear entrada en la GUI
                                createServerEntry(scrollFrame, server.id, brainrot, server.playing)
                                
                                -- Actualizar canvas size
                                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 65)
                                
                                -- Notificación
                                StarterGui:SetCore("SendNotification", {
                                    Title = "¡Brainrot Encontrado!";
                                    Text = brainrot .. " en servidor " .. server.id;
                                    Duration = 5;
                                })
                                
                                -- Auto-teleport (opcional, descomenta si quieres teleport automático)
                                -- teleportToServer(server.id, brainrot)
                                -- return
                            end
                        end
                    end
                end)
            end
        end
        
        statusLabel.Text = "Escaneando... Servidores encontrados: " .. #foundServers
    end)
end

-- Función para detener escaneo
local function stopScanning(statusLabel)
    if scanConnection then
        scanConnection:Disconnect()
        scanConnection = nil
    end
    isScanning = false
    statusLabel.Text = "Escaneo detenido"
end

-- Inicializar GUI y funcionalidad
local function initialize()
    local gui, startButton, statusLabel, scrollFrame = createGUI()
    
    startButton.MouseButton1Click:Connect(function()
        if not isScanning then
            startButton.Text = "Detener Escaneo"
            startButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            startScanning(statusLabel, scrollFrame)
        else
            startButton.Text = "Iniciar Escaneo"
            startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
            stopScanning(statusLabel)
        end
    end)
    
    -- Hacer la GUI arrastrable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    gui.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Frame.Position
        end
    end)
    
    gui.Frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    gui.Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Ejecutar el script
initialize()

StarterGui:SetCore("SendNotification", {
    Title = "Brainrot Scanner";
    Text = "Script cargado correctamente. ¡Recuerda cambiar el GAME_ID!";
    Duration = 5;
})
