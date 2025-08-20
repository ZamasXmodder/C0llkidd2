-- Simulador de Trampa usando el sistema nativo del juego
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
mainFrame.Size = UDim2.new(0, 280, 0, 180)
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
titleLabel.Text = "🕳️ Trap Simulator (Native)"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.22, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Libre"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham

-- Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Parent = mainFrame
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0.4, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱️ Tiempo: --"
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold

-- Botón principal
local simulateButton = Instance.new("TextButton")
simulateButton.Parent = mainFrame
simulateButton.Size = UDim2.new(0.85, 0, 0, 40)
simulateButton.Position = UDim2.new(0.075, 0, 0.65, 0)
simulateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
simulateButton.Text = "🔒 Activar Simulación"
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

-- Función para encontrar la trampa real en workspace
local function findRealTrap()
    -- Buscar trampa directamente en workspace
    local trap = workspace:FindFirstChild("Trap")
    if trap then
        print("✅ Trampa encontrada en workspace:", trap:GetFullName())
        return trap
    end
    
    -- Buscar en todos los descendientes
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "Trap" then
            print("✅ Trampa encontrada:", obj:GetFullName())
            return obj
        end
    end
    
    print("❌ No se encontró trampa en workspace")
    return nil
end

-- Función para buscar el sistema de red del juego
local function findNetworkSystem()
    -- Buscar en ReplicatedStorage
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if packages then
        print("📦 Packages encontrado")
        
        -- Buscar sistema de red
        for _, obj in pairs(packages:GetDescendants()) do
            if obj.Name:lower():find("net") or obj.Name:lower():find("remote") then
                print("🌐 Sistema de red encontrado:", obj:GetFullName())
                return obj
            end
        end
    end
    
    return nil
end

-- Función para activar la trampa usando el sistema nativo
local function activateNativeTrap()
    local trap = findRealTrap()
    if not trap then
        warn("⚠️ No se puede simular: trampa no encontrada")
        return false
    end
    
    -- Intentar activar la trampa tocándola
    if trap.Touched then
        trap.Touched:Fire(humanoidRootPart)
        print("🎯 Trampa activada por toque")
    end
    
    -- Buscar y ejecutar TrapScript si existe
    local trapScript = trap:FindFirstChild("TrapScript")
    if trapScript then
        print("📜 TrapScript encontrado")
        -- El script se ejecutará automáticamente al tocar
    end
    
    return true
end

-- Función para mantener el efecto de trampa
local function maintainTrapEffect()
    local trap = findRealTrap()
    if trap and trap.Touched then
        -- Reactivar cada pocos frames para mantener el efecto
        trap.Touched:Fire(humanoidRootPart)
    end
    
    -- Mantener inmunidad
    if humanoid then
        humanoid.Health = math.max(humanoid.Health, humanoid.MaxHealth * 0.95)
        humanoid.PlatformStand = false -- Permitir movimiento libre
        humanoid.Sit = false
    end
end

-- Función para iniciar la simulación
local function startSimulation()
    print("🚀 Iniciando simulación de trampa...")
    
    -- Activar trampa nativa
    if not activateNativeTrap() then
        return false
    end
    
    -- Configurar timer de 10 segundos
    trapTimer = 10
    isSimulating = true
    
    -- Actualizar UI
    statusLabel.Text = "Estado: Atrapado (Simulado)"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    simulateButton.Text = "🔓 Detener Simulación"
    simulateButton.BackgroundColor3 = Color3.fromRGB(250, 100, 100)
    
    -- Conexión para mantener efecto
    connections.maintain = RunService.Heartbeat:Connect(function()
        if isSimulating then
            maintainTrapEffect()
        end
    end)
    
    -- Conexión para countdown
    connections.timer = RunService.Heartbeat:Connect(function(deltaTime)
        if isSimulating then
            trapTimer = trapTimer - deltaTime
            timerLabel.Text = "⏱️ Tiempo: " .. math.ceil(math.max(0, trapTimer)) .. "s"
            
            if trapTimer <= 0 then
                stopSimulation()
            end
        end
    end)
    
    print("✅ Simulación iniciada - Duración: 10 segundos")
    return true
end

-- Función para detener la simulación
local function stopSimulation()
    print("🛑 Deteniendo simulación...")
    
    isSimulating = false
    trapTimer = 0
    
    -- Desconectar todas las conexiones
    for _, connection in pairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Restaurar UI
    statusLabel.Text = "Estado: Libre"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    timerLabel.Text = "⏱️ Tiempo: --"
    simulateButton.Text = "🔒 Activar Simulación"
    simulateButton.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
    
    -- Restaurar stats normales
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid.PlatformStand = false
    end
    
    print("✅ Simulación detenida")
end

-- Función principal de toggle
local function toggleSimulation()
    if isSimulating then
        stopSimulation()
    else
        startSimulation()
    end
end

-- Conectar botón
simulateButton.MouseButton1Click:Connect(toggleSimulation)

-- Manejar respawn del personaje
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Detener simulación si estaba activa
    if isSimulating then
        stopSimulation()
    end
end)

-- Inicialización
print("🎮 Trap Simulator (Native) cargado")
print("📍 Buscando sistema nativo del juego...")

-- Buscar componentes del juego
findNetworkSystem()
local trap = findRealTrap()
if trap then
    print("🎯 Listo para simular trampa:", trap.Name)
else
    print("⚠️ Coloca una trampa primero para usar la simulación")
end
