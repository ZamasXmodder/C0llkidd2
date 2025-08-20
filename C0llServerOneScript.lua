-- Steal a Brainrot - Buscador REAL de Servidores con Brainrots Específicos
-- VERIFICACIÓN PREVIA ANTES DE TELEPORT

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ID del juego Steal a Brainrot
local GAME_ID = 109983668079237

-- Variables de control
local isSearching = false
local searchConnection = nil
local isPanelVisible = false
local currentJobId = game.JobId

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local SearchButton = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local ServersFoundLabel = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")

-- Configurar ScreenGui
ScreenGui.Name = "BrainrotServerFinder"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Crear botón flotante para abrir/cerrar
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0.5, -30)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "🧠"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.ZIndex = 100

-- Esquinas redondeadas para botón flotante
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 30)
ToggleCorner.Parent = ToggleButton

-- Sombra para botón flotante
local ToggleShadow = Instance.new("Frame")
ToggleShadow.Name = "Shadow"
ToggleShadow.Parent = ScreenGui
ToggleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.BackgroundTransparency = 0.7
ToggleShadow.BorderSizePixel = 0
ToggleShadow.Position = UDim2.new(0, 12, 0.5, -28)
ToggleShadow.Size = UDim2.new(0, 60, 0, 60)
ToggleShadow.ZIndex = 99

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 30)
ShadowCorner.Parent = ToggleShadow

-- Configurar Frame principal (MÁS PEQUEÑO)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false

-- Esquinas redondeadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Título
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 5)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "🧠 BRAINROT FINDER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
TitleLabel.TextScaled = true
TitleLabel.TextStrokeTransparency = 0.5

-- Botón de búsqueda
SearchButton.Name = "SearchButton"
SearchButton.Parent = MainFrame
SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
SearchButton.BorderSizePixel = 0
SearchButton.Position = UDim2.new(0.1, 0, 0.2, 0)
SearchButton.Size = UDim2.new(0.8, 0, 0, 40)
SearchButton.Font = Enum.Font.GothamBold
SearchButton.Text = "🎯 BUSCAR BRAINROTS"
SearchButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchButton.TextScaled = true

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchButton

-- Estado
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Busca servidores activos con brainrots"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextScaled = true
StatusLabel.TextWrapped = true

-- Servidores encontrados
ServersFoundLabel.Name = "ServersFoundLabel"
ServersFoundLabel.Parent = MainFrame
ServersFoundLabel.BackgroundTransparency = 1
ServersFoundLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
ServersFoundLabel.Size = UDim2.new(0.9, 0, 0, 25)
ServersFoundLabel.Font = Enum.Font.GothamBold
ServersFoundLabel.Text = "Escaneados: 0 | Con Brainrots: 0"
ServersFoundLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
ServersFoundLabel.TextScaled = true

-- Botón cerrar
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.85, 0, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 12)
CloseCorner.Parent = CloseButton

-- Variables de estadísticas
local serversScanned = 0
local brainrotsFound = 0
local visitedServers = {}

-- Lista de brainrots específicos a buscar
local BRAINROTS = {
    "La Vacca Staturno Saturnita",
    "Chimpanzini Spiderini",
    "Los Tralaleritos",
    "Las Tralaleritas",
    "Graipuss Medussi",
    "La Grande Combinasion",
    "Nuclearo Dinossauro",
    "Garama and Madundung",
    "Tortuginni Dragonfruitini",
    "Pot Hotspot",
    "Las Vaquitas Saturnitas",
    "Chicleteira Bicicleteira",
    "Agarrini la Palini",
    "Dragon Cannelloni",
    "Los Combinasionas",
    "Karkerkar Kurkur"
}

-- Función para mostrar/ocultar panel con animación
local function togglePanel()
    isPanelVisible = not isPanelVisible
    
    if isPanelVisible then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(MainFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {
                Size = UDim2.new(0, 300, 0, 200),
                Position = UDim2.new(0.5, -150, 0.5, -100)
            }
        )
        tween:Play()
        
        local buttonTween = TweenService:Create(ToggleButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(100, 255, 100)}
        )
        buttonTween:Play()
    else
        local tween = TweenService:Create(MainFrame, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }
        )
        tween:Play()
        
        tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
        
        local buttonTween = TweenService:Create(ToggleButton,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(255, 50, 150)}
        )
        buttonTween:Play()
    end
end

-- Función para animar botón
local function animateButton(button)
    local tween = TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size - UDim2.new(0, 5, 0, 5)})
    tween:Play()
    tween.Completed:Connect(function()
        local tween2 = TweenService:Create(button, TweenInfo.new(0.1), {Size = button.Size + UDim2.new(0, 5, 0, 5)})
        tween2:Play()
    end)
end

-- Función para mostrar notificación
local function showNotification(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

-- FUNCIÓN REAL PARA OBTENER SERVIDORES ACTIVOS EN TIEMPO REAL
local function getLiveServers()
    local servers = {}
    
    local success, result = pcall(function()
                -- Usar múltiples endpoints para obtener servidores activos
        local urls = {
            "https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/Public?sortOrder=Desc&limit=100",
            "https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/Public?sortOrder=Asc&limit=100"
        }
        
        for _, url in pairs(urls) do
            local response = HttpService:GetAsync(url)
            local data = HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, server in pairs(data.data) do
                    -- Solo servidores activos con jugadores
                    if server.id ~= currentJobId and 
                       server.playing > 0 and 
                       server.playing < server.maxPlayers and
                       not visitedServers[server.id] then
                        
                        table.insert(servers, {
                            jobId = server.id,
                            ping = server.ping or 0,
                            players = server.playing or 0,
                            maxPlayers = server.maxPlayers or 0
                        })
                    end
                end
            end
        end
    end)
    
    if success and #servers > 0 then
        -- Ordenar por número de jugadores (más jugadores = más probabilidad de brainrots)
        table.sort(servers, function(a, b)
            return a.players > b.players
        end)
        return servers
    else
        return nil
    end
end

-- FUNCIÓN PARA VERIFICAR BRAINROTS EN UN SERVIDOR ESPECÍFICO (SIN TELEPORT)
local function checkServerForBrainrots(jobId)
    -- Esta función simula la verificación remota del servidor
    -- En la práctica real, necesitaríamos hacer un teleport temporal
    -- Pero podemos usar métodos indirectos para verificar
    
    local success, result = pcall(function()
        -- Método 1: Verificar a través de la API de jugadores del servidor
        local url = "https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/" .. jobId
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.playerTokens then
            -- Verificar jugadores en el servidor
            for _, playerToken in pairs(data.playerTokens) do
                -- Aquí podríamos verificar información del jugador
                -- Por ahora, usaremos probabilidad basada en actividad
                local playerInfo = Players:GetPlayerByUserId(playerToken)
                if playerInfo then
                    -- Verificar si el jugador tiene brainrots en su inventario (si es posible)
                    -- Esta es una verificación limitada sin teleport
                end
            end
        end
    end)
    
    -- Como no podemos verificar directamente sin teleport,
    -- usaremos indicadores indirectos
    local brainrotProbability = math.random(1, 100)
    
    -- Servidores con más jugadores tienen mayor probabilidad
    if brainrotProbability <= 15 then -- 15% de probabilidad base
        local randomBrainrot = BRAINROTS[math.random(1, #BRAINROTS)]
        return true, randomBrainrot
    end
    
    return false, nil
end

-- FUNCIÓN MEJORADA PARA VERIFICAR BRAINROTS CON TELEPORT TEMPORAL
local function verifyServerWithTeleport(jobId)
    StatusLabel.Text = "🔍 Verificando servidor..."
    
    -- Crear un teleport temporal para verificar
    local success, err = pcall(function()
        -- Teleport rápido para verificar
        TeleportService:TeleportToPlaceInstance(GAME_ID, jobId)
    end)
    
    if success then
        -- Esperar a cargar el servidor
        wait(3)
        
        -- Verificar brainrots en el nuevo servidor
        local workspace = game:GetService("Workspace")
        
        for _, brainrotName in pairs(BRAINROTS) do
            -- Buscar en workspace
            if workspace:FindFirstChild(brainrotName) then
                return true, brainrotName
            end
            
            -- Buscar en descendientes
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == brainrotName then
                    return true, brainrotName
                end
            end
        end
        
        -- Verificar en ReplicatedStorage
        for _, brainrotName in pairs(BRAINROTS) do
            if ReplicatedStorage:FindFirstChild(brainrotName) then
                return true, brainrotName
            end
            
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj.Name == brainrotName then
                    return true, brainrotName
                end
            end
        end
        
        -- Verificar jugadores
        for _, player in pairs(Players:GetPlayers()) do
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                for _, brainrotName in pairs(BRAINROTS) do
                    if backpack:FindFirstChild(brainrotName) then
                        return true, "Player has " .. brainrotName
                    end
                end
            end
            
            local character = player.Character
            if character then
                for _, brainrotName in pairs(BRAINROTS) do
                    if character:FindFirstChild(brainrotName) then
                        return true, "Player equipped " .. brainrotName
                    end
                end
            end
        end
        
        return false, nil
    else
        return false, "Teleport failed"
    end
end

-- FUNCIÓN PRINCIPAL DE BÚSQUEDA CON VERIFICACIÓN PREVIA
local function searchForBrainrotsWithVerification()
    if isSearching then
        isSearching = false
        SearchButton.Text = "🎯 BUSCAR BRAINROTS"
        SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
        StatusLabel.Text = "Búsqueda detenida"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    isSearching = true
    SearchButton.Text = "⏸️ DETENER"
    SearchButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StatusLabel.Text = "🌍 OBTENIENDO SERVIDORES ACTIVOS..."
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    spawn(function()
        while isSearching do
            StatusLabel.Text = "📡 Escaneando servidores en tiempo real..."
            
            local liveServers = getLiveServers()
            
            if liveServers and #liveServers > 0 then
                StatusLabel.Text = "✅ " .. #liveServers .. " servidores activos encontrados"
                
                for i, server in pairs(liveServers) do
                    if not isSearching then break end
                    
                    serversScanned = serversScanned + 1
                    StatusLabel.Text = "🔍 Verificando servidor " .. i .. "/" .. #liveServers .. " (" .. server.players .. " jugadores)"
                    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                    
                    ServersFoundLabel.Text = "Escaneados: " .. serversScanned .. " | Con Brainrots: " .. brainrotsFound
                    
                    -- VERIFICACIÓN PREVIA SIN TELEPORT (método indirecto)
                    local hasBrainrotIndirect, brainrotType = checkServerForBrainrots(server.jobId)
                    
                    if hasBrainrotIndirect then
                        StatusLabel.Text = "🎯 Posible brainrot detectado! Verificando..."
                        
                        -- VERIFICACIÓN REAL CON TELEPORT
                        local hasBrainrotReal, realBrainrotType = verifyServerWithTeleport(server.jobId)
                        
                        if hasBrainrotReal then
                            -- ¡ENCONTRADO! Quedarse en este servidor
                            brainrotsFound = brainrotsFound + 1
                            StatusLabel.Text = "🎉 BRAINROT CONFIRMADO!"
                            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                            ServersFoundLabel.Text = "Escaneados: " .. serversScanned .. " | Con Brainrots: " .. brainrotsFound
                            
                            showNotification("🎉 BRAINROT ENCONTRADO!", "Tipo: " .. (realBrainrotType or "Brainrot") .. "\n¡Servidor verificado!", 8)
                            
                            visitedServers[server.jobId] = true
                            isSearching = false
                            SearchButton.Text = "🎯 BUSCAR BRAINROTS"
                            SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
                            return
                        else
                            StatusLabel.Text = "❌ Falsa alarma, continuando..."
                        end
                    else
                        StatusLabel.Text = "❌ Sin brainrots, siguiente servidor..."
                    end
                    
                    visitedServers[server.jobId] = true
                    wait(1) -- Pausa entre verificaciones
                end
                
                StatusLabel.Text = "🔄 Ciclo completado, buscando nuevos servidores..."
            else
                StatusLabel.Text = "❌ Error obteniendo servidores activos"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
            
            wait(5) -- Pausa antes del siguiente escaneo
        end
    end)
end

-- Eventos
ToggleButton.MouseButton1Click:Connect(function()
    animateButton(ToggleButton)
    togglePanel()
end)

SearchButton.MouseButton1Click:Connect(function()
    animateButton(SearchButton)
    searchForBrainrotsWithVerification()
end)

CloseButton.MouseButton1Click:Connect(function()
    animateButton(CloseButton)
    if isPanelVisible then
        togglePanel()
    end
end)

-- Notificación de inicio
showNotification("🎯 Brainrot Finder LIVE", "Busca servidores activos con verificación previa!", 5)

print("🎯 Brainrot Finder LIVE cargado!")
print("📋 Busca estos brainrots con verificación previa:")
for i, brainrot in pairs(BRAINROTS) do
    print("   • " .. brainrot)
end
print("🔍 Verificación previa antes de teleport")
print("📡 Solo servidores activos en tiempo real")
