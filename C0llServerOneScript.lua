-- Sistema Avanzado de Escaneo de Servidores
-- Busca servidores con brainrots secretos, jugadores con dinero alto, y análisis de calidad del servidor
-- Utiliza métodos viables para encontrar servidores prometedores

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local gui = nil
local panelVisible = false
local scanActive = false
local serverHistory = {}
local currentServerData = {}
local scanResults = {}

-- Lista completa de Brainrots Secretos
local SECRET_BRAINROTS = {
    "Karkerkar Kurkur", "Los Matteos", "Bisonte Giuppitere", "La vacca Saturno",
    "Trenostruzzo Turbo 4000", "Sammyni Sypderini", "Chimpanzini Sipderini",
    "Torrtuginni Dragonfrutini", "Dul Dul Dul", "Blackhole Goat", "Los Spyderinis",
    "Agarrini la Palini", "Fragola La La La", "Los Tralaleritos", "Guerriro Digitale",
    "Las Tralaleritas", "Job Sahur", "Las Vaquitas Saturnitas", "Graipuss Medussi",
    "No mi Hotspot", "La sahur Combinasion", "Pot Hotspot", "Chicleteira Bicicleteira",
    "Los No mis Hotspotsitos", "La Grande Combinasion", "Los Combinasionas",
    "Nuclearo Dinossauro", "Los Hotspotsitos", "Tralaledon", "Esok Sekolah",
    "Ketupat Kepat", "Los bros", "La Supreme Combinasion", "Ketchuru and Musturu",
    "Garama And Madundung", "Spaghetti Tualetti", "Dragon Cannelloni"
}

-- Función para obtener información completa de jugadores
local function getPlayerWealth(targetPlayer)
    local wealth = {
        robux = 0,
        premium = false,
        accountAge = 0,
        hasExpensiveItems = false,
        estimatedValue = 0
    }
    
    if not targetPlayer then return wealth end
    
    -- Obtener edad de cuenta
    wealth.accountAge = targetPlayer.AccountAge
    
    -- Verificar premium
    local success, isPremium = pcall(function()
        return targetPlayer.MembershipType == Enum.MembershipType.Premium
    end)
    if success then wealth.premium = isPremium end
    
    -- Estimar riqueza basada en accesorios y gamepass
    local accessories = targetPlayer.Character and targetPlayer.Character:GetChildren() or {}
    local expensiveCount = 0
    
    for _, accessory in pairs(accessories) do
        if accessory:IsA("Accessory") then
            expensiveCount = expensiveCount + 1
        end
    end
    
    -- Calcular valor estimado
    wealth.estimatedValue = (wealth.accountAge * 0.1) + (expensiveCount * 50)
    if wealth.premium then wealth.estimatedValue = wealth.estimatedValue + 200 end
    wealth.hasExpensiveItems = expensiveCount >= 3
    
    return wealth
end

-- Función para escanear brainrots secretos en todas las ubicaciones
local function scanForSecretBrainrots()
    local foundSecrets = {}
    local searchLocations = {
        workspace,
        ReplicatedStorage,
        ReplicatedStorage:FindFirstChild("Models"),
        workspace:FindFirstChild("Models"),
        workspace:FindFirstChild("Items"),
        workspace:FindFirstChild("Brainrots"),
        workspace:FindFirstChild("Spawns"),
        workspace:FindFirstChild("Map")
    }
    
    -- Buscar en todas las ubicaciones posibles
    for _, location in pairs(searchLocations) do
        if location then
            for _, descendant in pairs(location:GetDescendants()) do
                if descendant:IsA("Model") and table.find(SECRET_BRAINROTS, descendant.Name) then
                    if not foundSecrets[descendant.Name] then
                        foundSecrets[descendant.Name] = {
                            model = descendant,
                            location = location.Name,
                            path = descendant:GetFullName()
                        }
                    end
                end
            end
        end
    end
    
    return foundSecrets
end

-- Función para analizar calidad del servidor actual
local function analyzeCurrentServer()
    local serverData = {
        timestamp = tick(),
        jobId = game.JobId,
        placeId = game.PlaceId,
        playerCount = #Players:GetPlayers(),
        secretBrainrots = {},
        wealthyPlayers = {},
        totalWealth = 0,
        averageAge = 0,
        premiumCount = 0,
        serverScore = 0
    }
    
    -- Escanear brainrots secretos
    serverData.secretBrainrots = scanForSecretBrainrots()
    local secretCount = 0
    for _ in pairs(serverData.secretBrainrots) do
        secretCount = secretCount + 1
    end
    
    -- Analizar jugadores
    local totalAge = 0
    local totalWealth = 0
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        local wealth = getPlayerWealth(targetPlayer)
        totalAge = totalAge + wealth.accountAge
        totalWealth = totalWealth + wealth.estimatedValue
        
        if wealth.premium then
            serverData.premiumCount = serverData.premiumCount + 1
        end
        
        if wealth.estimatedValue >= 100 or wealth.hasExpensiveItems then
            table.insert(serverData.wealthyPlayers, {
                name = targetPlayer.Name,
                wealth = wealth
            })
        end
    end
    
    serverData.averageAge = serverData.playerCount > 0 and (totalAge / serverData.playerCount) or 0
    serverData.totalWealth = totalWealth
    
    -- Calcular puntuación del servidor
    local brainrotScore = secretCount * 25
    local wealthScore = math.min(totalWealth / 50, 50)
    local premiumScore = (serverData.premiumCount / math.max(serverData.playerCount, 1)) * 30
    local ageScore = math.min(serverData.averageAge / 100, 20)
    
    serverData.serverScore = brainrotScore + wealthScore + premiumScore + ageScore
    
    return serverData
end

-- Función para realizar servidor hopping inteligente
local function intelligentServerHop()
    local currentData = analyzeCurrentServer()
    
    -- Guardar datos del servidor actual
    if not serverHistory[game.JobId] then
        serverHistory[game.JobId] = currentData
        print("📊 Servidor guardado - Puntuación: " .. math.floor(currentData.serverScore))
    end
    
    -- Si el servidor actual es muy bueno, preguntar antes de salir
    if currentData.serverScore >= 75 then
        warn("⭐ ¡SERVIDOR DE ALTA CALIDAD DETECTADO!")
        warn("📊 Puntuación: " .. math.floor(currentData.serverScore))
        warn("🧠 Brainrots secretos: " .. table.concat(table.pack(pairs(currentData.secretBrainrots)), ", "))
        warn("💰 Jugadores ricos: " .. #currentData.wealthyPlayers)
        warn("💎 Premium: " .. currentData.premiumCount)
        return false
    end
    
    print("🚀 Buscando servidor mejor...")
    print("📊 Servidor actual - Puntuación: " .. math.floor(currentData.serverScore))
    
    -- Realizar teleport
    local success, result = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
    
    if not success then
        warn("❌ Error al cambiar servidor: " .. tostring(result))
        return false
    end
    
    return true
end

-- Función para crear GUI principal
local function createAdvancedGUI()
    local existing = playerGui:FindFirstChild("AdvancedServerScanner")
    if existing then existing:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedServerScanner"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -300, -1, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🎯 SISTEMA AVANZADO DE SERVIDORES"
    title.TextColor3 = Color3.fromRGB(255, 150, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Panel de información del servidor
    local infoFrame = Instance.new("ScrollingFrame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(1, -20, 0, 280)
    infoFrame.Position = UDim2.new(0, 10, 0, 70)
    infoFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
    infoFrame.BorderSizePixel = 0
    infoFrame.ScrollBarThickness = 8
    infoFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    infoFrame.Parent = mainFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 10)
    infoCorner.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, -20, 1, 0)
    infoLabel.Position = UDim2.new(0, 10, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🔄 Analizando servidor..."
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.TextWrapped = true
    infoLabel.Parent = infoFrame
    
    -- Panel de controles
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(1, -20, 0, 120)
    controlFrame.Position = UDim2.new(0, 10, 0, 360)
    controlFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mainFrame
    
    local controlCorner = Instance.new("UICorner")
    controlCorner.CornerRadius = UDim.new(0, 10)
    controlCorner.Parent = controlFrame
    
    -- Botón de análisis
    local analyzeButton = Instance.new("TextButton")
    analyzeButton.Size = UDim2.new(0.48, -5, 0.35, 0)
    analyzeButton.Position = UDim2.new(0, 10, 0, 10)
    analyzeButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    analyzeButton.BorderSizePixel = 0
    analyzeButton.Text = "🔍 ANALIZAR SERVIDOR"
    analyzeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    analyzeButton.TextScaled = true
    analyzeButton.Font = Enum.Font.GothamBold
    analyzeButton.Parent = controlFrame
    
    local analyzeCorner = Instance.new("UICorner")
    analyzeCorner.CornerRadius = UDim.new(0, 8)
    analyzeCorner.Parent = analyzeButton
    
    -- Botón de servidor hopping
    local hopButton = Instance.new("TextButton")
    hopButton.Size = UDim2.new(0.48, -5, 0.35, 0)
    hopButton.Position = UDim2.new(0.52, 0, 0, 10)
    hopButton.BackgroundColor3 = Color3.fromRGB(250, 150, 50)
    hopButton.BorderSizePixel = 0
    hopButton.Text = "🚀 BUSCAR MEJOR SERVIDOR"
    hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopButton.TextScaled = true
    hopButton.Font = Enum.Font.GothamBold
    hopButton.Parent = controlFrame
    
    local hopCorner = Instance.new("UICorner")
    hopCorner.CornerRadius = UDim.new(0, 8)
    hopCorner.Parent = hopButton
    
    -- Botón de servidor hopping automático
    local autoHopButton = Instance.new("TextButton")
    autoHopButton.Size = UDim2.new(1, -20, 0.35, 0)
    autoHopButton.Position = UDim2.new(0, 10, 0.4, 0)
    autoHopButton.BackgroundColor3 = Color3.fromRGB(150, 50, 250)
    autoHopButton.BorderSizePixel = 0
    autoHopButton.Text = "⚡ AUTO-HOP (Buscar Automáticamente)"
    autoHopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoHopButton.TextScaled = true
    autoHopButton.Font = Enum.Font.GothamBold
    autoHopButton.Parent = controlFrame
    
    local autoHopCorner = Instance.new("UICorner")
    autoHopCorner.CornerRadius = UDim.new(0, 8)
    autoHopCorner.Parent = autoHopButton
    
    -- Estado del auto-hop
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0.25, 0)
    statusLabel.Position = UDim2.new(0, 10, 0.75, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🎮 G = Panel | A = Analizar | S = Saltar servidor"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = controlFrame
    
    -- Función para actualizar información
    local function updateServerInfo()
        local data = analyzeCurrentServer()
        local secretsList = {}
        for name, info in pairs(data.secretBrainrots) do
            table.insert(secretsList, string.format("%s (%s)", name, info.location))
        end
        
        local wealthyList = {}
        for _, playerData in pairs(data.wealthyPlayers) do
            table.insert(wealthyList, string.format("%s (%.0f)", playerData.name, playerData.wealth.estimatedValue))
        end
        
        local infoText = string.format([[
📊 ANÁLISIS DEL SERVIDOR ACTUAL
═══════════════════════════════════

🏆 PUNTUACIÓN GENERAL: %.1f/100
%s

🧠 BRAINROTS SECRETOS ENCONTRADOS: %d
%s

💰 JUGADORES CON ALTO VALOR: %d
%s

👥 ESTADÍSTICAS DE JUGADORES:
• Total: %d jugadores
• Premium: %d (%.1f%%)
• Edad promedio: %.0f días
• Riqueza total estimada: %.0f

🔍 RECOMENDACIÓN:
%s

🕒 Última actualización: %s
]], 
            data.serverScore,
            data.serverScore >= 75 and "⭐ SERVIDOR EXCELENTE" or 
            data.serverScore >= 50 and "✅ SERVIDOR BUENO" or 
            data.serverScore >= 25 and "⚠️  SERVIDOR REGULAR" or "❌ SERVIDOR POBRE",
            
            table.getn(secretsList),
            table.getn(secretsList) > 0 and ("📋 " .. table.concat(secretsList, "\n📋 ")) or "❌ Ninguno encontrado",
            
            #wealthyList,
            #wealthyList > 0 and ("💎 " .. table.concat(wealthyList, "\n💎 ")) or "❌ Ninguno detectado",
            
            data.playerCount,
            data.premiumCount,
            (data.premiumCount / math.max(data.playerCount, 1)) * 100,
            data.averageAge,
            data.totalWealth,
            
            data.serverScore >= 75 and "🏆 ¡Quedarse en este servidor!" or
            data.serverScore >= 50 and "✅ Buen servidor para quedarse" or
            data.serverScore >= 25 and "⚖️  Considerar buscar otro servidor" or "🚀 Cambiar de servidor recomendado",
            
            os.date("%H:%M:%S")
        )
        
        infoLabel.Text = infoText
        
        -- Ajustar tamaño del canvas
        local textBounds = infoLabel.TextBounds
        infoLabel.Size = UDim2.new(1, -20, 0, textBounds.Y + 20)
        infoFrame.CanvasSize = UDim2.new(0, 0, 0, textBounds.Y + 40)
        
        currentServerData = data
    end
    
    -- Eventos de botones
    analyzeButton.MouseButton1Click:Connect(updateServerInfo)
    
    hopButton.MouseButton1Click:Connect(function()
        updateServerInfo()
        if not intelligentServerHop() then
            hopButton.Text = "⭐ SERVIDOR EXCELENTE"
            hopButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            task.wait(3)
            hopButton.Text = "🚀 BUSCAR MEJOR SERVIDOR"
            hopButton.BackgroundColor3 = Color3.fromRGB(250, 150, 50)
        end
    end)
    
    autoHopButton.MouseButton1Click:Connect(function()
        scanActive = not scanActive
        if scanActive then
            autoHopButton.Text = "⏹️ DETENER AUTO-HOP"
            autoHopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            statusLabel.Text = "🔄 Auto-hop activado - Buscando servidores..."
            
            -- Iniciar búsqueda automática
            task.spawn(function()
                while scanActive do
                    updateServerInfo()
                    task.wait(2)
                    
                    if scanActive and currentServerData.serverScore < 60 then
                        statusLabel.Text = "🚀 Cambiando servidor automáticamente..."
                        task.wait(1)
                        if not intelligentServerHop() then
                            scanActive = false
                            break
                        end
                    else
                        statusLabel.Text = "✅ Servidor satisfactorio encontrado!"
                        scanActive = false
                        break
                    end
                end
                
                autoHopButton.Text = "⚡ AUTO-HOP (Buscar Automáticamente)"
                autoHopButton.BackgroundColor3 = Color3.fromRGB(150, 50, 250)
                statusLabel.Text = "🎮 G = Panel | A = Analizar | S = Saltar servidor"
            end)
        else
            autoHopButton.Text = "⚡ AUTO-HOP (Buscar Automáticamente)"
            autoHopButton.BackgroundColor3 = Color3.fromRGB(150, 50, 250)
            statusLabel.Text = "🎮 G = Panel | A = Analizar | S = Saltar servidor"
        end
    end)
    
    gui = screenGui
    
    -- Análisis inicial
    task.wait(1)
    updateServerInfo()
    
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
        TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Panel mostrado - Analizando servidor actual...")
    else
        print("📱 Panel ocultado")
        scanActive = false
    end
end

-- Crear GUI
createAdvancedGUI()

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        togglePanel()
    elseif input.KeyCode == Enum.KeyCode.A then
        if gui then
            gui.MainFrame.ControlFrame:FindFirstChild("TextButton").MouseButton1Click:Fire()
        end
    elseif input.KeyCode == Enum.KeyCode.S then
        intelligentServerHop()
    end
end)

-- Análisis automático cada 30 segundos
task.spawn(function()
    while true do
        if panelVisible and gui then
            local analyzeButton = gui.MainFrame.ControlFrame:FindFirstChild("TextButton")
            if analyzeButton then
                analyzeButton.MouseButton1Click:Fire()
            end
        end
        task.wait(30)
    end
end)

-- Mensaje inicial
print("🎯 Sistema Avanzado de Servidores cargado!")
print("🎮 Controles:")
print("   G - Mostrar/ocultar panel")
print("   A - Analizar servidor actual")
print("   S - Saltar a otro servidor")
print("🔍 Busca: Brainrots secretos, jugadores ricos, servidores de calidad")
print("⚡ Incluye modo automático para encontrar los mejores servidores")

-- Análisis inicial del servidor
task.spawn(function()
    task.wait(5)
    local initialData = analyzeCurrentServer()
    print(string.format("📊 Servidor actual - Puntuación: %.1f/100", initialData.serverScore))
    
    local secretCount = 0
    for _ in pairs(initialData.secretBrainrots) do secretCount = secretCount + 1 end
    
    if secretCount > 0 then
        print("🧠 Brainrots secretos encontrados: " .. secretCount)
        for name, info in pairs(initialData.secretBrainrots) do
            print("  ✨ " .. name .. " (" .. info.location .. ")")
        end
    end
    
    if #initialData.wealthyPlayers > 0 then
        print("💰 Jugadores ricos detectados: " .. #initialData.wealthyPlayers)
    end
    
    if initialData.serverScore >= 75 then
        print("⭐ ¡EXCELENTE! Este servidor tiene alta calidad")
    elseif initialData.serverScore < 25 then
        print("💡 Sugerencia: Usar 'S' o auto-hop para encontrar mejor servidor")
    end
end)
