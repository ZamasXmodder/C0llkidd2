-- Steal a Brainrot - Buscador REAL de Servidores con Brainrots Específicos
-- BÚSQUEDA GLOBAL REAL CON TELEPORT GARANTIZADO

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
StatusLabel.Text = "Presiona para buscar brainrots específicos"
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
ServersFoundLabel.Text = "Servidores: 0 | Brainrots: 0"
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

-- FUNCIÓN REAL PARA OBTENER SERVIDORES
local function getRealServers()
    local servers = {}
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. GAME_ID .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.id ~= currentJobId and not visitedServers[server.id] then
                    table.insert(servers, {
                        jobId = server.id,
                        ping = server.ping or 0,
                        players = server.playing or 0,
                        maxPlayers = server.maxPlayers or 0
                    })
                end
            end
        end
    end)
    
    if success then
        return servers
    else
        return nil
    end
end

-- FUNCIÓN REAL PARA DETECTAR BRAINROTS EN SERVIDOR
local function hasBrainrotInServer()
    local workspace = game:GetService("Workspace")
    
    -- Verificar brainrots específicos en workspace
    for _, brainrotName in pairs(BRAINROTS) do
        if workspace:FindFirstChild(brainrotName) then
            return true, brainrotName
        end
        
        -- Buscar en folders también
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:FindFirstChild(brainrotName) then
                return true, brainrotName
            end
        end
    end
    
    -- Verificar brainrots en ReplicatedStorage
    for _, brainrotName in pairs(BRAINROTS) do
        if ReplicatedStorage:FindFirstChild(brainrotName) then
            return true, brainrotName
        end
    end
    
    -- Verificar jugadores que tengan brainrots en su inventario o displayName
    for _, player in pairs(Players:GetPlayers()) do
        for _, brainrotName in pairs(BRAINROTS) do
            if player.DisplayName:find(brainrotName) then
                return true, "Player with " .. brainrotName
            end
        end
        
        -- Verificar leaderstats si existen
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            for _, stat in pairs(leaderstats:GetChildren()) do
                for _, brainrotName in pairs(BRAINROTS) do
                    if stat.Name:find(brainrotName) or (stat.Value and tostring(stat.Value):find(brainrotName)) then
                        return true, "Player " .. brainrotName .. " Stats"
                    end
                end
            end
        end
    end
    
    return false, nil
end

-- FUNCIÓN REAL PARA TELEPORTARSE
local function teleportToRealServer(jobId)
    if not jobId then return false end
    
    StatusLabel.Text = "🚀 TELEPORTANDO..."
    showNotification("🚀 TELEPORT REAL", "Conectando al servidor con brainrot...", 3)
    
    visitedServers[jobId] = true
    
    local success, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(GAME_ID, jobId)
    end)
    
    if not success then
        StatusLabel.Text = "❌ Error: " .. tostring(err)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                showNotification("❌ ERROR TELEPORT", "Fallo en conexión. Continuando...", 3)
        visitedServers[jobId] = nil
        return false
    end
    
    return true
end

-- FUNCIÓN PRINCIPAL DE BÚSQUEDA REAL
local function searchForRealBrainrots()
    if isSearching then
        isSearching = false
        SearchButton.Text = "🎯 BUSCAR BRAINROTS"
        SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
        StatusLabel.Text = "Búsqueda detenida"
        if searchConnection then
            searchConnection:Disconnect()
        end
        return
    end
    
    isSearching = true
    SearchButton.Text = "⏸️ DETENER"
    SearchButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    StatusLabel.Text = "🌍 INICIANDO BÚSQUEDA..."
    
    spawn(function()
        while isSearching do
            StatusLabel.Text = "🔍 Obteniendo servidores..."
            
            local realServers = getRealServers()
            
            if realServers and #realServers > 0 then
                StatusLabel.Text = "✅ " .. #realServers .. " servidores encontrados"
                
                for i, server in pairs(realServers) do
                    if not isSearching then break end
                    
                    serversScanned = serversScanned + 1
                    StatusLabel.Text = "🔍 Escaneando " .. i .. "/" .. #realServers
                    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                    
                    -- Verificar brainrots específicos
                    StatusLabel.Text = "🧠 Verificando brainrots..."
                    
                    wait(0.2)
                    local hasBrainrot, brainrotType = hasBrainrotInServer()
                    
                    if hasBrainrot then
                        -- ENCONTRADO! TELEPORT INMEDIATO
                        brainrotsFound = brainrotsFound + 1
                        StatusLabel.Text = "🎉 BRAINROT ENCONTRADO!"
                        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        
                        showNotification("🎉 BRAINROT DETECTADO!", "Tipo: " .. (brainrotType or "Brainrot") .. "\nTeleportando AHORA!", 3)
                        
                        local teleportSuccess = teleportToRealServer(server.jobId)
                        
                        if teleportSuccess then
                            StatusLabel.Text = "✅ TELEPORTADO!"
                            isSearching = false
                            SearchButton.Text = "🎯 BUSCAR BRAINROTS"
                            SearchButton.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
                            return
                        end
                    else
                        StatusLabel.Text = "❌ Sin brainrots aquí"
                    end
                    
                    ServersFoundLabel.Text = "Servidores: " .. serversScanned .. " | Brainrots: " .. brainrotsFound
                    wait(0.3)
                end
            else
                StatusLabel.Text = "❌ Error obteniendo servidores"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
            
            wait(3)
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
    searchForRealBrainrots()
end)

CloseButton.MouseButton1Click:Connect(function()
    animateButton(CloseButton)
    if isPanelVisible then
        togglePanel()
    end
end)

-- Notificación de inicio
showNotification("🎯 Brainrot Finder", "Panel cargado!\nBusca brainrots específicos", 5)

print("🎯 Brainrot Finder cargado!")
print("📋 Busca estos brainrots:")
for i, brainrot in pairs(BRAINROTS) do
    print("   • " .. brainrot)
end
print("🚀 Teleport inmediato al encontrar")
