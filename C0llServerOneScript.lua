-- Sistema Práctico de Brainrots - Versión Funcional
-- Enfoque realista en optimización del servidor actual y salto eficiente
-- Presiona G para panel, H para ESP, J para salto rápido

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables del sistema
local gui = nil
local panelVisible = false
local espActive = false
local espObjects = {}
local serverData = {}
local visitedServers = {}

-- Lista de Brainrots Secretos
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

-- Función para limpiar ESP
local function clearESP()
    for _, espObj in pairs(espObjects) do
        if espObj and espObj.highlight and espObj.highlight.Parent then
            espObj.highlight:Destroy()
        end
        if espObj and espObj.gui and espObj.gui.Parent then
            espObj.gui:Destroy()
        end
        if espObj and espObj.beam and espObj.beam.Parent then
            espObj.beam:Destroy()
        end
    end
    espObjects = {}
end

-- Función para buscar brainrots en todas las ubicaciones
local function findAllBrainrots()
    local found = {}
    local searchAreas = {
        workspace,
        ReplicatedStorage,
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Models"),
        workspace:FindFirstChild("Items"),
        ReplicatedStorage:FindFirstChild("Models")
    }
    
    for _, area in pairs(searchAreas) do
        if area then
            for _, obj in pairs(area:GetDescendants()) do
                if obj:IsA("Model") and table.find(SECRET_BRAINROTS, obj.Name) then
                    table.insert(found, {
                        name = obj.Name,
                        model = obj,
                        location = area.Name,
                        position = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.Position or 
                                 obj.PrimaryPart and obj.PrimaryPart.Position or
                                 obj:FindFirstChildOfClass("Part") and obj:FindFirstChildOfClass("Part").Position or Vector3.new(0,0,0)
                    })
                end
            end
        end
    end
    
    return found
end

-- Función para crear ESP
local function createESP(brainrotData)
    local model = brainrotData.model
    local part = model.PrimaryPart or model:FindFirstChildOfClass("Part")
    if not part then return end
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BrainrotESP"
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = model
    
    -- GUI flotante
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BrainrotGUI"
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Adornee = part
    billboard.Parent = workspace
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = billboard
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🧠 " .. brainrotData.name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = frame
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, -10, 0.4, 0)
    distanceLabel.Position = UDim2.new(0, 5, 0.6, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "📍 " .. brainrotData.location
    distanceLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    distanceLabel.TextScaled = true
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.Parent = frame
    
    -- Línea hacia el jugador
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = character.HumanoidRootPart
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = part
        
        local beam = Instance.new("Beam")
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
        beam.Width0 = 0.5
        beam.Width1 = 0.5
        beam.Transparency = NumberSequence.new(0.3)
        beam.Parent = workspace
        
        espObjects[model] = {
            highlight = highlight,
            gui = billboard,
            beam = beam,
            distanceLabel = distanceLabel
        }
    else
        espObjects[model] = {
            highlight = highlight,
            gui = billboard,
            distanceLabel = distanceLabel
        }
    end
end

-- Función para actualizar distancias en ESP
local function updateESP()
    if not espActive then return end
    
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    for model, espData in pairs(espObjects) do
        if model.Parent and espData.distanceLabel then
            local part = model.PrimaryPart or model:FindFirstChildOfClass("Part")
            if part then
                local distance = (humanoidRootPart.Position - part.Position).Magnitude
                espData.distanceLabel.Text = string.format("📏 %.1f studs", distance)
            end
        else
            -- Limpiar ESP de modelos eliminados
            if espData.highlight then espData.highlight:Destroy() end
            if espData.gui then espData.gui:Destroy() end
            if espData.beam then espData.beam:Destroy() end
            espObjects[model] = nil
        end
    end
end

-- Función para salto rápido de servidor
local function quickServerHop()
    print("🚀 Realizando salto de servidor...")
    
    local success, error = pcall(function()
        TeleportService:Teleport(game.PlaceId)
    end)
    
    if not success then
        warn("❌ Error en salto de servidor: " .. tostring(error))
        return false
    end
    
    return true
end

-- Función para analizar servidor actual
local function analyzeCurrentServer()
    local brainrots = findAllBrainrots()
    local playerCount = #Players:GetPlayers()
    
    serverData = {
        timestamp = os.time(),
        jobId = game.JobId,
        brainrots = brainrots,
        playerCount = playerCount,
        score = (#brainrots * 10) + (playerCount * 2)
    }
    
    -- Guardar en historial
    visitedServers[game.JobId] = serverData
    
    return serverData
end

-- Función para crear GUI principal
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainrotSystemGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, -1, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🧠 SISTEMA DE BRAINROTS AVANZADO"
    title.TextColor3 = Color3.fromRGB(255, 150, 50)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Panel de información
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -20, 0, 180)
    infoFrame.Position = UDim2.new(0, 10, 0, 60)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = mainFrame
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = infoFrame
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "InfoLabel"
    infoLabel.Size = UDim2.new(1, -20, 1, -20)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
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
    controlFrame.Size = UDim2.new(1, -20, 0, 80)
    controlFrame.Position = UDim2.new(0, 10, 0, 250)
    controlFrame.BackgroundTransparency = 1
    controlFrame.Parent = mainFrame
    
    -- Botón ESP
    local espButton = Instance.new("TextButton")
    espButton.Name = "ESPButton"
    espButton.Size = UDim2.new(0.48, 0, 0.45, 0)
    espButton.Position = UDim2.new(0, 0, 0, 0)
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
    
    -- Botón salto de servidor
    local hopButton = Instance.new("TextButton")
    hopButton.Size = UDim2.new(0.48, 0, 0.45, 0)
    hopButton.Position = UDim2.new(0.52, 0, 0, 0)
    hopButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    hopButton.BorderSizePixel = 0
    hopButton.Text = "🚀 SALTAR SERVIDOR"
    hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    hopButton.TextScaled = true
    hopButton.Font = Enum.Font.GothamBold
    hopButton.Parent = controlFrame
    
    local hopCorner = Instance.new("UICorner")
    hopCorner.CornerRadius = UDim.new(0, 6)
    hopCorner.Parent = hopButton
    
    -- Botón analizar
    local analyzeButton = Instance.new("TextButton")
    analyzeButton.Size = UDim2.new(1, 0, 0.45, 0)
    analyzeButton.Position = UDim2.new(0, 0, 0.55, 0)
    analyzeButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    analyzeButton.BorderSizePixel = 0
    analyzeButton.Text = "📊 ANALIZAR SERVIDOR"
    analyzeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    analyzeButton.TextScaled = true
    analyzeButton.Font = Enum.Font.GothamBold
    analyzeButton.Parent = controlFrame
    
    local analyzeCorner = Instance.new("UICorner")
    analyzeCorner.CornerRadius = UDim.new(0, 6)
    analyzeCorner.Parent = analyzeButton
    
    -- Función para actualizar información
    local function updateInfo()
        local data = analyzeCurrentServer()
        local brainrotList = {}
        
        for _, brainrot in pairs(data.brainrots) do
            table.insert(brainrotList, string.format("• %s (%s)", brainrot.name, brainrot.location))
        end
        
        local infoText = string.format([[📊 ANÁLISIS DEL SERVIDOR

🏆 Puntuación: %d puntos
👥 Jugadores: %d
🧠 Brainrots Secretos: %d

📋 BRAINROTS ENCONTRADOS:
%s

🕒 Actualizado: %s]], 
            data.score,
            data.playerCount,
            #data.brainrots,
            #brainrotList > 0 and table.concat(brainrotList, "\n") or "❌ Ninguno encontrado",
            os.date("%H:%M:%S")
        )
        
        infoLabel.Text = infoText
    end
    
    -- Eventos de botones
    espButton.MouseButton1Click:Connect(function()
        espActive = not espActive
        if espActive then
            espButton.Text = "🔍 ESP: ON"
            espButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            
            local brainrots = findAllBrainrots()
            for _, brainrot in pairs(brainrots) do
                createESP(brainrot)
            end
            print("✅ ESP activado - " .. #brainrots .. " brainrots marcados")
        else
            espButton.Text = "🔍 ESP: OFF"
            espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            clearESP()
            print("❌ ESP desactivado")
        end
    end)
    
    hopButton.MouseButton1Click:Connect(function()
        updateInfo()
        if serverData.score >= 50 then
            warn("⚠️ Servidor actual tiene buena puntuación: " .. serverData.score)
            warn("¿Seguro que deseas cambiar? Presiona J para confirmar.")
        else
            quickServerHop()
        end
    end)
    
    analyzeButton.MouseButton1Click:Connect(updateInfo)
    
    gui = screenGui
    
    -- Análisis inicial
    task.wait(0.5)
    updateInfo()
    
    return screenGui
end

-- Función para mostrar/ocultar panel
local function togglePanel()
    if not gui then return end
    
    panelVisible = not panelVisible
    local frame = gui.MainFrame
    
    local targetPos = panelVisible and UDim2.new(0.5, -225, 0.5, -175) or UDim2.new(0.5, -225, -1, -175)
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = targetPos}
    )
    tween:Play()
    
    if panelVisible then
        print("📱 Panel mostrado")
        -- Actualizar información al mostrar
        if gui and gui.MainFrame:FindFirstChild("Frame") then
            local analyzeButton = gui.MainFrame.Frame:FindFirstChild("TextButton")
            if analyzeButton and analyzeButton.Name ~= "ESPButton" then
                analyzeButton.MouseButton1Click:Fire()
            end
        end
    else
        print("📱 Panel ocultado")
    end
end

-- Crear la GUI
createGUI()

-- Loop para actualizar ESP
task.spawn(function()
    while true do
        if espActive then
            updateESP()
        end
        task.wait(1)
    end
end)

-- Controles de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.G then
        togglePanel()
    elseif input.KeyCode == Enum.KeyCode.H then
        if gui then
            local espButton = gui.MainFrame.Frame.ESPButton
            if espButton then
                espButton.MouseButton1Click:Fire()
            end
        end
    elseif input.KeyCode == Enum.KeyCode.J then
        quickServerHop()
    end
end)

-- Mensaje inicial
print("🧠 Sistema de Brainrots Avanzado cargado correctamente!")
print("🎮 Controles:")
print("   G = Mostrar/ocultar panel")
print("   H = Activar/desactivar ESP")
print("   J = Salto rápido de servidor")
print("📊 Iniciando análisis del servidor...")

-- Análisis automático inicial
task.spawn(function()
    task.wait(3)
    local initialData = analyzeCurrentServer()
    print(string.format("📊 Servidor analizado: %d brainrots, %d jugadores, puntuación: %d", 
        #initialData.brainrots, initialData.playerCount, initialData.score))
    
    if #initialData.brainrots > 0 then
        print("🧠 Brainrots secretos detectados:")
        for _, brainrot in pairs(initialData.brainrots) do
            print("  ✨ " .. brainrot.name .. " en " .. brainrot.location)
        end
    else
        print("📍 No se encontraron brainrots secretos en este servidor")
        print("💡 Usa 'J' para saltar a otro servidor")
    end
end)
