-- Simulador de Trampa corregido para Models
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrapSimulatorGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🕳️ Trap Simulator (Fixed)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Info de trampa
local trapInfoLabel = Instance.new("TextLabel")
trapInfoLabel.Parent = mainFrame
trapInfoLabel.Size = UDim2.new(1, 0, 0, 20)
trapInfoLabel.Position = UDim2.new(0, 0, 0.2, 0)
trapInfoLabel.BackgroundTransparency = 1
trapInfoLabel.Text = "Buscando trampa..."
trapInfoLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
trapInfoLabel.TextScaled = true
trapInfoLabel.Font = Enum.Font.Gotham

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.35, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Libre"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = mainFrame
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0.52, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱️ Tiempo: --"
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold

-- Botón principal
local simulateButton = Instance.new("TextButton")
simulateButton.Parent = mainFrame
simulateButton.Size = UDim2.new(0.85, 0, 0, 35)
simulateButton.Position = UDim2.new(0.075, 0, 0.75, 0)
simulateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
simulateButton.Text = "🔒 Activar Anti-Hit"
simulateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
simulateButton.TextScaled = true
simulateButton.Font = Enum.Font.GothamBold

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = simulateButton

-- Variables de estado
local isSimulating = false
local trapTimer = 0
local connections = {}
local foundTrapParts = {}

-- Función mejorada para encontrar partes de la trampa
local function findTrapParts()
    foundTrapParts = {}
    
    -- Buscar el modelo Trap
    local trapModel = workspace:FindFirstChild("Trap")
    if not trapModel then
        print("❌ No se encontró modelo 'Trap' en workspace")
        trapInfoLabel.Text = "❌ No hay trampa"
        trapInfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return {}
    end
    
    print("✅ Modelo Trap encontrado:", trapModel:GetFullName())
    print("📋 Tipo:", trapModel.ClassName)
    
    -- Si es un Model, buscar todas las partes dentro
    if trapModel:IsA("Model") then
        for _, child in pairs(trapModel:GetDescendants()) do
            if child:IsA("BasePart") and child.Touched then
                table.insert(foundTrapParts, child)
                print("🎯 Parte con Touched encontrada:", child.Name, "(" .. child.ClassName .. ")")
            end
        end
    elseif trapModel:IsA("BasePart") and trapModel.Touched then
        -- Si es una parte directamente
        table.insert(foundTrapParts, trapModel)
        print("🎯 Parte directa encontrada:", trapModel.Name)
    end
    
    -- Actualizar UI con info
    if #foundTrapParts > 0 then
        trapInfoLabel.Text = "✅ " .. #foundTrapParts .. " parte(s) encontrada(s)"
        trapInfoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        trapInfoLabel.Text = "⚠️ Trampa sin partes válidas"
        trapInfoLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    end
    
    return foundTrapParts
end

-- Función para activar todas las partes de la trampa
local function activateAllTrapParts()
    local parts = findTrapParts()
    local activated = 0
    
    for _, part in pairs(parts) do
        if part and part.Parent and part.Touched then
            -- Activar el evento Touched
            part.Touched:Fire(humanoidRootPart)
            activated = activated + 1
            print("🔥 Activada parte:", part.Name)
        end
    end
    
    print("✅ Total partes activadas:", activated)
    return activated > 0
end

-- Función para crear efecto visual
local function createTrapEffect()
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Name = "TrapSimulatorEffect"
    selectionBox.Parent = workspace
    selectionBox.Adornee = humanoidRootPart
    selectionBox.Color3 = Color3.fromRGB(255, 50, 50)
    selectionBox.LineThickness = 0.3
    selectionBox.Transparency = 0.3
    
    return selectionBox
end

-- Función para aplicar inmunidad
local function applyImmunity()
    if humanoid then
        -- Salud infinita
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        -- Movimiento libre
        humanoid.PlatformStand = false
        humanoid.Sit = false
        
        print("🛡️ Inmunidad aplicada")
    end
end

-- Función para mantener efectos
local function maintainEffects()
    -- Reactivar partes de trampa
    for _, part in pairs(foundTrapParts) do
        if part and part.Parent and part.Touched then
            part.Touched:Fire(humanoidRootPart)
        end
    end
    
    -- Mantener inmunidad
    if humanoid then
        humanoid.Health = math.max(humanoid.Health, humanoid.MaxHealth * 0.95)
        humanoid.PlatformStand = false
        humanoid.Sit = false
    end
end

-- Función para iniciar simulación
local function startSimulation()
    print("🚀 Iniciando simulación...")
    
    -- Buscar y activar trampa
    local success = activateAllTrapParts()
    if not success then
        warn("⚠️ No se pudieron activar partes de trampa, usando modo independiente")
    end
    
    -- Configurar estado
    trapTimer = 10
    isSimulating = true
    
    -- Crear efectos
    local selectionBox = createTrapEffect()
    applyImmunity()
    
    -- Actualizar UI
    statusLabel.Text = "Estado: Protegido (Anti-Hit)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    simulateButton.Text = "🔓 Desactivar Anti-Hit"
    simulateButton.BackgroundColor3 = Color3.fromRGB(250, 100, 100)
    
    -- Mantener efectos
    connections.maintain = RunService.Heartbeat:Connect(function()
        if isSimulating then
            maintainEffects()
        end
    end)
    
    -- Timer
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if isSimulating then
            trapTimer = trapTimer - deltaTime
            timerLabel.Text = "⏱️ Tiempo: " .. math.ceil(math.max(0, trapTimer)) .. "s"
            
            if trapTimer <= 0 then
                stopSimulation()
            end
        end
    end)
    
    -- Cleanup function
    connections.cleanup = function()
        if selectionBox then selectionBox:Destroy() end
    end
    
    print("✅ Simulación iniciada por 10 segundos")
end

-- Función para detener simulación
local function stopSimulation()
    print("🛑 Deteniendo simulación...")
    
    isSimulating = false
    trapTimer = 0
    
    -- Cleanup
    if connections.cleanup then
        connections.cleanup()
    end
    
    -- Desconectar
    for _, connection in pairs(connections) do
        if connection and typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Restaurar UI
    statusLabel.Text = "Estado: Libre"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timerLabel.Text = "⏱️ Tiempo: --"
    simulateButton.Text = "🔒 Activar Anti-Hit"
    simulateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    
    -- Restaurar salud
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid.PlatformStand = false
    end
    
    print("✅ Simulación detenida")
end

-- Toggle principal
local function toggleSimulation()
    if isSimulating then
        stopSimulation()
    else
        startSimulation()
    end
end

-- Conectar eventos
simulateButton.MouseButton1Click:Connect(toggleSimulation)

-- Manejar respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    if isSimulating then
        stopSimulation()
    end
end)

-- Inicialización
print("🎮 Trap Simulator (Fixed) cargado")
findTrapParts() -- Buscar partes al inicio
